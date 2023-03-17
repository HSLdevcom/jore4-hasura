
CREATE OR REPLACE FUNCTION vehicle_schedule.get_overlapping_schedules(filter_vehicle_schedule_frame_ids uuid[], filter_journey_pattern_ref_ids uuid[])
RETURNS TABLE(
  current_vehicle_schedule_frame_id uuid,
  other_vehicle_schedule_frame_id uuid,
  journey_pattern_id uuid,
  active_on_day_of_week integer,
  priority integer,
  current_validity_range daterange,
  other_validity_range daterange,
  validity_intersection daterange
)
LANGUAGE sql
AS $$
  WITH
  -- Find out which rows we need to check.
  -- Only modified rows and those they could possibly conflict with need to be checked. This includes:
  -- 1. modified VSFs
  -- 2. all VSFs that have same JP as any of the modified ones
  -- 3. all VSFs that use any of the modified JPs
  -- Achieve this by filtering with journey_pattern_id,
  -- and include all JP ids that were either modified or relate to any modified VSFs.
  journey_patterns_to_check AS (
      SELECT journey_pattern_id
      FROM journey_pattern.journey_pattern_ref
      WHERE journey_pattern_ref_id = ANY(filter_journey_pattern_ref_ids)
    UNION
      SELECT DISTINCT journey_pattern_id
      FROM vehicle_schedule.vehicle_schedule_frame
      JOIN vehicle_service.vehicle_service vs  USING (vehicle_schedule_frame_id)
      JOIN vehicle_service.journey_patterns_in_vehicle_service USING (vehicle_service_id)
      WHERE vehicle_schedule_frame_id = ANY(filter_vehicle_schedule_frame_ids)
  ),
  -- Collect all relevant data about journey patterns for vehicle schedule frames.
  vehicle_schedule_frame_journey_patterns AS (
    SELECT DISTINCT
      vehicle_schedule_frame_id,
      journey_pattern_id,
      validity_range,
      day_of_week,
      priority
    FROM vehicle_service.journey_patterns_in_vehicle_service
    JOIN vehicle_service.vehicle_service USING (vehicle_service_id)
    JOIN journey_pattern.journey_pattern_ref USING (journey_pattern_id)
    JOIN vehicle_schedule.vehicle_schedule_frame USING (vehicle_schedule_frame_id)
    JOIN service_calendar.day_type_active_on_day_of_week USING (day_type_id)
    WHERE (
      journey_pattern_id IN (SELECT * FROM journey_patterns_to_check)
    )
  ),
  -- Select all schedules in DB that have conflicts with schedules_to_check.
  -- Note that this will contain each conflicting schedule frame pair twice.
  schedule_conflicts AS (
    SELECT DISTINCT
      current_schedule.vehicle_schedule_frame_id as current_vehicle_schedule_frame_id,
      other_schedule.vehicle_schedule_frame_id AS other_vehicle_schedule_frame_id,
      journey_pattern_id,
      day_of_week AS active_on_day_of_week,
      priority,
      current_schedule.validity_range AS current_validity_range,
      other_schedule.validity_range AS other_validity_range,
      current_schedule.validity_range * other_schedule.validity_range AS validity_intersection
    FROM vehicle_schedule_frame_journey_patterns current_schedule
    -- Check if the schedules conflict.
    JOIN vehicle_schedule_frame_journey_patterns other_schedule USING (journey_pattern_id, day_of_week, priority)
    WHERE (current_schedule.validity_range && other_schedule.validity_range)
    AND other_schedule.vehicle_schedule_frame_id != current_schedule.vehicle_schedule_frame_id
  )
SELECT * FROM schedule_conflicts;
$$;
COMMENT ON FUNCTION vehicle_schedule.get_overlapping_schedules(filter_vehicle_schedule_frame_ids uuid[], filter_journey_pattern_ref_ids uuid[])
IS 'Returns information on all schedules that are overlapping.
  Two vehicle_schedule_frames will be considered overlapping if they have:
  - same priority
  - are valid on the same day (validity_range, active_on_day_of_week)
  - have any vehicle_journeys for same journey_patterns';

CREATE OR REPLACE FUNCTION vehicle_schedule.validate_queued_schedules_uniqueness() RETURNS VOID
  LANGUAGE plpgsql
AS $$
DECLARE
  overlapping_schedule RECORD;
  error_message TEXT;
BEGIN
  -- RAISE NOTICE 'vehicle_schedule.validate_queued_schedules_uniqueness()';

  SELECT * FROM vehicle_schedule.get_overlapping_schedules(
    (SELECT array_agg(vehicle_schedule_frame_id) FROM modified_vehicle_schedule_frame),
    (SELECT array_agg(journey_pattern_ref_id) FROM modified_journey_pattern_ref)
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
      overlapping_schedule.active_on_day_of_week
    ) INTO error_message;
    RAISE EXCEPTION 'conflicting schedules detected: %', error_message;
  END IF;
END;
$$;
COMMENT ON FUNCTION vehicle_schedule.validate_queued_schedules_uniqueness()
IS 'Performs validation on schedules, checking that there are no overlapping schedules.
  Essentially runs get_overlapping_schedules for all modified rows
  and throws an error if any overlapping schedules are detected.';

