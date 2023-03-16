ALTER TABLE vehicle_service.journey_patterns_in_vehicle_service
  ADD CONSTRAINT journey_patterns_in_vehicle_service_reference_count_check
  CHECK (reference_count >= 0);

CREATE OR REPLACE FUNCTION vehicle_service.refresh_journey_patterns_in_vehicle_service()
RETURNS VOID
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

CREATE OR REPLACE FUNCTION vehicle_service.execute_journey_patterns_in_vehicle_service_refresh_once() RETURNS TRIGGER
  LANGUAGE plpgsql
  AS $$
DECLARE
  already_refreshed_journey_patterns_in_vehicle_service BOOLEAN;
BEGIN
  -- RAISE LOG 'execute_journey_patterns_in_vehicle_service_refresh_once()';

  already_refreshed_journey_patterns_in_vehicle_service := NULLIF(current_setting('vehicle_service.already_refreshed_journey_patterns_in_vehicle_service', TRUE), '');
  -- RAISE LOG 'execute_journey_patterns_in_vehicle_service_refresh_once, already refreshed: %', already_refreshed_journey_patterns_in_vehicle_service;

  IF already_refreshed_journey_patterns_in_vehicle_service IS NOT TRUE THEN
    -- RAISE LOG 'execute_journey_patterns_in_vehicle_service_refresh_once(): execute and reset flag.';

    PERFORM vehicle_service.refresh_journey_patterns_in_vehicle_service();

    SET LOCAL vehicle_service.already_refreshed_journey_patterns_in_vehicle_service = TRUE;
  END IF;

  RETURN NEW;
END
$$;
COMMENT ON FUNCTION vehicle_service.execute_journey_patterns_in_vehicle_service_refresh_once()
IS 'Executes the vehicle_service.refresh_journey_patterns_in_vehicle_service function
 if it has not been already executed in this transaction via this function.
 Otherwise does nothing.';

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

DROP TRIGGER IF EXISTS refresh_jps_in_vs_on_block_modified_trigger ON vehicle_service.block;
CREATE CONSTRAINT TRIGGER refresh_jps_in_vs_on_block_modified_trigger
  AFTER UPDATE ON vehicle_service.block
  DEFERRABLE INITIALLY DEFERRED FOR EACH ROW WHEN (OLD.vehicle_service_id <> NEW.vehicle_service_id)
  EXECUTE FUNCTION vehicle_service.execute_journey_patterns_in_vehicle_service_refresh_once();

DROP TRIGGER IF EXISTS refresh_jps_in_vs_on_jpr_modified_trigger ON journey_pattern.journey_pattern_ref;
CREATE CONSTRAINT TRIGGER refresh_jps_in_vs_on_jpr_modified_trigger
  AFTER UPDATE ON journey_pattern.journey_pattern_ref
  DEFERRABLE INITIALLY DEFERRED FOR EACH ROW WHEN (OLD.journey_pattern_id <> NEW.journey_pattern_id)
  EXECUTE FUNCTION vehicle_service.execute_journey_patterns_in_vehicle_service_refresh_once();

DROP TRIGGER IF EXISTS refresh_jps_in_vs_on_vj_modified_trigger ON vehicle_journey.vehicle_journey;
CREATE CONSTRAINT TRIGGER refresh_jps_in_vs_on_vj_modified_trigger
  AFTER UPDATE OR INSERT OR DELETE ON vehicle_journey.vehicle_journey
  DEFERRABLE INITIALLY DEFERRED FOR EACH ROW
  EXECUTE FUNCTION vehicle_service.execute_journey_patterns_in_vehicle_service_refresh_once();

