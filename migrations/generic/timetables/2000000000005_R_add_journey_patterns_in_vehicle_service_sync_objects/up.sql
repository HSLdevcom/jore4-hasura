ALTER TABLE vehicle_service.journey_patterns_in_vehicle_service
  ADD CONSTRAINT journey_patterns_in_vehicle_service_reference_count_check
  CHECK (reference_count >= 0);

-- We expect UPDATE/INSERT/DELETE operations to be rare and mostly be done
-- in one transaction when data is imported, so it does not matter much
-- that we refresh the whole table on each write operation.
--
-- If it looks like write operations will be used more regularly,
-- it might make sense to rethink these triggers, possibly optimizing them
-- to only refresh necessary parts of the journey_patterns_in_vehicle_service table.
-- The reference_count can probably be utilized for such purpose.
CREATE OR REPLACE FUNCTION vehicle_service.refresh_journey_patterns_in_vehicle_service() RETURNS void
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
