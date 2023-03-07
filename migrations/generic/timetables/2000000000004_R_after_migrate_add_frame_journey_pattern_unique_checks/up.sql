
CREATE OR REPLACE FUNCTION vehicle_schedule.get_overlapping_schedules(filter_vehicle_schedule_frame_ids uuid[], filter_journey_pattern_ref_ids uuid[])
RETURNS TABLE(
  current_vehicle_schedule_frame_id uuid,
  other_vehicle_schedule_frame_id uuid,
  journey_pattern_id uuid,
  day_of_week integer,
  priority integer,
  current_validity_range daterange,
  other_validity_range daterange,
  validity_intersection daterange
)
LANGUAGE sql STABLE PARALLEL SAFE
AS $$
WITH
  -- Collect all relevant data about journey patterns for vehicle schedule frames.
  -- TODO: can this be narrowed down? Now selects basically the whole DB.
  vehicle_schedule_frame_journey_patterns AS (
    -- TODO: Consider making this into a view
    SELECT DISTINCT
      vehicle_schedule_frame_id,
      journey_pattern_id,
      validity_start,
      validity_end,
      daterange(validity_start, validity_end) AS validity_range,
      day_of_week,
      priority
    FROM vehicle_schedule.vehicle_schedule_frame FRAME
    JOIN vehicle_service.vehicle_service SERVICE USING (vehicle_schedule_frame_id)
    JOIN vehicle_service.block BLOCK USING (vehicle_service_id)
    JOIN vehicle_journey.vehicle_journey JOURNEY USING (block_id)
    JOIN service_calendar.day_type_active_on_day_of_week DAY_OF_WEEK USING (day_type_id)
    JOIN journey_pattern.journey_pattern_ref PATTERN USING (journey_pattern_ref_id)
  ),
  -- TODO: use the function parameters instead.
  vehicle_journey_ids_filter AS (
    SELECT vehicle_schedule_frame_id FROM vehicle_schedule.vehicle_schedule_frame vsf
    -- WHERE vehicle_schedule_frame_id IN (
    -- )
  ),
  schedules_to_check AS (
    SELECT FVS.* FROM vehicle_schedule_frame_journey_patterns FVS
    JOIN vehicle_journey_ids_filter USING (vehicle_schedule_frame_id)
  ),
  -- Select all schedules in DB that have conflicts with schedules_to_check.
  -- Note that this will contain each conflicting schedule frame pair twice.
  schedule_conflicts AS (
    SELECT DISTINCT
      current_schedule.vehicle_schedule_frame_id as current_vehicle_schedule_frame_id,
      other_schedule.vehicle_schedule_frame_id AS other_vehicle_schedule_frame_id,
      journey_pattern_id,
      day_of_week,
      priority,
      current_schedule.validity_range AS current_validity_range,
      other_schedule.validity_range AS other_validity_range,
      current_schedule.validity_range * other_schedule.validity_range AS validity_intersection
    FROM schedules_to_check current_schedule
    -- Check if the schedules conflict.
    JOIN vehicle_schedule_frame_journey_patterns other_schedule USING (journey_pattern_id, day_of_week, priority)
    WHERE ((current_schedule.validity_start, current_schedule.validity_end) OVERLAPS (other_schedule.validity_start, other_schedule.validity_end))
    AND other_schedule.vehicle_schedule_frame_id != current_schedule.vehicle_schedule_frame_id
  )
SELECT * FROM schedule_conflicts;
$$;
COMMENT ON FUNCTION vehicle_schedule.get_overlapping_schedules(filter_vehicle_schedule_frame_ids uuid[], filter_journey_pattern_ref_ids uuid[])
IS 'TODO.';

CREATE OR REPLACE FUNCTION vehicle_schedule.validate_schedule_uniqueness() RETURNS trigger
  LANGUAGE plpgsql
AS $$
DECLARE
  overlapping_schedule RECORD;
  error_message TEXT;
BEGIN
  -- RAISE NOTICE 'vehicle_schedule.validate_schedule_uniqueness()';

  SELECT * FROM vehicle_schedule.get_overlapping_schedules(
    array[]::uuid[], array[]::uuid[]
  )
  LIMIT 1 -- RECORD type, so other rows are discarded anyway.
  INTO overlapping_schedule;

  IF FOUND THEN
    -- Note, this includes only one of the conflicting rows. There might be multiple.
    SELECT format(
      'vehicle schedule frame %s and vehicle schedule frame %s, priority %s, journey_pattern_id %s, overlapping on %s on weekday %s',
		  overlapping_schedule.current_vehicle_schedule_frame_id,
		  overlapping_schedule.other_vehicle_schedule_frame_id,
		  overlapping_schedule.priority,
		  overlapping_schedule.journey_pattern_id,
		  overlapping_schedule.validity_intersection,
		  overlapping_schedule.day_of_week
    ) INTO error_message;
    RAISE EXCEPTION 'conflicting schedules detected: %', error_message;
  END IF;

  RETURN NULL;
END;
$$;
COMMENT ON FUNCTION vehicle_schedule.validate_schedule_uniqueness()
IS 'TODO';

-- TODO: add all necessary triggers, and run the validation only once per transaction.
DROP TRIGGER IF EXISTS validate_schedule_uniqueness_trigger ON vehicle_schedule.vehicle_schedule_frame;
CREATE CONSTRAINT TRIGGER validate_schedule_uniqueness_trigger
  AFTER UPDATE OR INSERT ON vehicle_schedule.vehicle_schedule_frame
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
  EXECUTE FUNCTION vehicle_schedule.validate_schedule_uniqueness();
COMMENT ON TRIGGER validate_schedule_uniqueness_trigger ON vehicle_schedule.vehicle_schedule_frame
IS 'TODO';
