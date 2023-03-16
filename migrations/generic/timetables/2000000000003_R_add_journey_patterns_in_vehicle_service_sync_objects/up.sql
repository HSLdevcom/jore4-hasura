ALTER TABLE vehicle_service.journey_patterns_in_vehicle_service
  ADD CONSTRAINT journey_patterns_in_vehicle_service_reference_count_check
  CHECK (reference_count >= 0);

CREATE OR REPLACE FUNCTION vehicle_service.refresh_journey_patterns_in_vehicle_service() RETURNS VOID
  LANGUAGE plpgsql
  VOLATILE PARALLEL UNSAFE
AS $$
BEGIN
  -- RAISE LOG 'refresh_journey_patterns_in_vehicle_service()';

  -- Step 1: reset all counts.
  UPDATE vehicle_service.journey_patterns_in_vehicle_service
  SET reference_count = 0;

  -- Step 2: upsert new entries.
  INSERT INTO vehicle_service.journey_patterns_in_vehicle_service (journey_pattern_id, vehicle_service_id, reference_count)
    SELECT DISTINCT journey_pattern_id, vehicle_service_id, COUNT(journey_pattern_ref_id) AS ref_count
    FROM vehicle_service.vehicle_service
    JOIN vehicle_service.block USING (vehicle_service_id)
    JOIN vehicle_journey.vehicle_journey USING (block_id)
    JOIN journey_pattern.journey_pattern_ref USING (journey_pattern_ref_id)
    GROUP BY (journey_pattern_id, vehicle_service_id, journey_pattern_ref_id)
  ON CONFLICT (vehicle_service_id, journey_pattern_id) DO
    UPDATE SET reference_count = EXCLUDED.reference_count;

  -- Step 3: remove all rows that are no longer used,
  -- that is, where the reference between vehicle_service and journey_pattern no longer exists.
  DELETE FROM vehicle_service.journey_patterns_in_vehicle_service
  WHERE reference_count = 0;
END;
$$;
COMMENT ON FUNCTION vehicle_service.refresh_journey_patterns_in_vehicle_service()
IS 'Rebuilds the whole journey_patterns_in_vehicle_service table.';

CREATE OR REPLACE FUNCTION vehicle_service.queue_journey_patterns_in_vehicle_service_refresh() RETURNS TRIGGER
  LANGUAGE plpgsql
  AS $$
BEGIN
  SET LOCAL vehicle_service.journey_patterns_in_vehicle_service_refresh_queued = TRUE;
  RETURN NEW;
END
$$;
COMMENT ON FUNCTION vehicle_service.queue_journey_patterns_in_vehicle_service_refresh()
IS 'Sets a flag that journey_patterns_in_vehicle_service should be refreshed.
 The actual refresh can then be triggered by execute_queued_journey_patterns_in_vehicle_service_refresh_once()';

CREATE OR REPLACe FUNCTION vehicle_service.execute_queued_journey_patterns_in_vehicle_service_refresh_once() RETURNS VOID
  LANGUAGE plpgsql
  AS $$
DECLARE
  journey_patterns_in_vehicle_service_refresh_queued BOOLEAN;
  already_refreshed_journey_patterns_in_vehicle_service BOOLEAN;
BEGIN
  -- RAISE LOG 'execute_queued_journey_patterns_in_vehicle_service_refresh_once()';

  journey_patterns_in_vehicle_service_refresh_queued := NULLIF(current_setting('vehicle_service.journey_patterns_in_vehicle_service_refresh_queued', TRUE), '');
  -- RAISE LOG 'execute_queued_journey_patterns_in_vehicle_service_refresh_once, refresh queued refreshed: %', journey_patterns_in_vehicle_service_refresh_queued;
  IF journey_patterns_in_vehicle_service_refresh_queued IS TRUE THEN
    already_refreshed_journey_patterns_in_vehicle_service := NULLIF(current_setting('vehicle_service.already_refreshed_journey_patterns_in_vehicle_service', TRUE), '');
    -- RAISE LOG 'execute_queued_journey_patterns_in_vehicle_service_refresh_once, already refreshed: %', already_refreshed_journey_patterns_in_vehicle_service;

    IF already_refreshed_journey_patterns_in_vehicle_service IS NOT TRUE THEN
      -- RAISE LOG 'execute_queued_journey_patterns_in_vehicle_service_refresh_once(): execute and reset flag.';

      PERFORM vehicle_service.refresh_journey_patterns_in_vehicle_service();

      SET LOCAL vehicle_service.already_refreshed_journey_patterns_in_vehicle_service = TRUE;
    END IF;
  END IF;
END
$$;
COMMENT ON FUNCTION vehicle_service.execute_queued_journey_patterns_in_vehicle_service_refresh_once()
IS 'Executes the vehicle_service.refresh_journey_patterns_in_vehicle_service function
 if it has been queued (by queue_journey_patterns_in_vehicle_service_refresh)
 and not yet executed in this transaction via this function.
 Otherwise does nothing.';

CREATE OR REPLACE FUNCTION vehicle_service.execute_queued_journey_patterns_in_vehicle_service_refresh_trg() RETURNS TRIGGER
  LANGUAGE plpgsql
  AS $$
BEGIN
  PERFORM vehicle_service.execute_queued_journey_patterns_in_vehicle_service_refresh_once();

  RETURN NEW;
END
$$;
COMMENT ON FUNCTION vehicle_service.execute_queued_journey_patterns_in_vehicle_service_refresh_trg()
IS 'Trigger for calling execute_queued_journey_patterns_in_vehicle_service_refresh_once()';

-- Create triggers for initiating the journey_patterns_in_vehicle_service refresh.
-- These are created as CONSTRAINT TRIGGERs so they can be DEFERRED to the end of transaction,
-- so that all write operations are considered when refreshing the table.
--
-- We expect UPDATE/INSERT/DELETE operations to be rare and mostly be done
-- in one transaction when data is imported, so it does not matter much
-- that we refresh the whole table on each write operation.
--
-- If it looks like write operations will be used more regularly,
-- it might make sense to rethink these triggers, possibly optimizing them
-- to only refresh necessary parts of the journey_patterns_in_vehicle_service table.
-- The reference_count can probably be utilized for such purpose.
--
-- For INSERT/DELETE we only need to trigger refresh when vehicle_journey is touched.
-- If any rows from tables higher in the hierarchy are INSERTed/DELETEd,
-- then their children (vehicle_journey) will be touched as well.
--
-- For UPDATE operations, only foreign key column updates can invalidate
-- the journey_patterns_in_vehicle_service table, so it is enough to check those.

-- block queue + execute:
DROP TRIGGER IF EXISTS queue_refresh_jps_in_vs_on_block_modified_trigger ON vehicle_service.block;
CREATE TRIGGER queue_refresh_jps_in_vs_on_block_modified_trigger
  AFTER UPDATE ON vehicle_service.block
  FOR EACH STATEMENT
  EXECUTE FUNCTION vehicle_service.queue_journey_patterns_in_vehicle_service_refresh();

DROP TRIGGER IF EXISTS refresh_jps_in_vs_on_block_modified_trigger ON vehicle_service.block;
CREATE CONSTRAINT TRIGGER refresh_jps_in_vs_on_block_modified_trigger
  AFTER UPDATE ON vehicle_service.block
  DEFERRABLE INITIALLY DEFERRED FOR EACH ROW
  EXECUTE FUNCTION vehicle_service.execute_queued_journey_patterns_in_vehicle_service_refresh_trg();

-- journey_pattern_ref queue + execute:
DROP TRIGGER IF EXISTS queue_refresh_jps_in_vs_on_jpr_modified_trigger ON journey_pattern.journey_pattern_ref;
CREATE TRIGGER queue_refresh_jps_in_vs_on_jpr_modified_trigger
  AFTER UPDATE ON journey_pattern.journey_pattern_ref
  FOR EACH STATEMENT
  EXECUTE FUNCTION vehicle_service.queue_journey_patterns_in_vehicle_service_refresh();

DROP TRIGGER IF EXISTS refresh_jps_in_vs_on_jpr_modified_trigger ON journey_pattern.journey_pattern_ref;
CREATE CONSTRAINT TRIGGER refresh_jps_in_vs_on_jpr_modified_trigger
  AFTER UPDATE ON journey_pattern.journey_pattern_ref
  DEFERRABLE INITIALLY DEFERRED FOR EACH ROW
  EXECUTE FUNCTION vehicle_service.execute_queued_journey_patterns_in_vehicle_service_refresh_trg();

-- vehicle_journey queue + execute:
DROP TRIGGER IF EXISTS queue_refresh_jps_in_vs_on_vj_modified_trigger ON vehicle_journey.vehicle_journey;
CREATE TRIGGER queue_refresh_jps_in_vs_on_vj_modified_trigger
  AFTER UPDATE OR INSERT OR DELETE ON vehicle_journey.vehicle_journey
  FOR EACH STATEMENT
  EXECUTE FUNCTION vehicle_service.queue_journey_patterns_in_vehicle_service_refresh();

DROP TRIGGER IF EXISTS refresh_jps_in_vs_on_vj_modified_trigger ON vehicle_journey.vehicle_journey;
CREATE CONSTRAINT TRIGGER refresh_jps_in_vs_on_vj_modified_trigger
  AFTER UPDATE OR INSERT OR DELETE ON vehicle_journey.vehicle_journey
  DEFERRABLE INITIALLY DEFERRED FOR EACH ROW
  EXECUTE FUNCTION vehicle_service.execute_queued_journey_patterns_in_vehicle_service_refresh_trg();
