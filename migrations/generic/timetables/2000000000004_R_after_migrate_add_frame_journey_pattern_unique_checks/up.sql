
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
  -- There might be updates queued that have not been processed yet.
  SELECT * FROM vehicle_service.execute_queued_journey_patterns_in_vehicle_service_refresh_once();

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
    JOIN vehicle_schedule.vehicle_schedule_frame USING (vehicle_schedule_frame_id)
    JOIN service_calendar.day_type_active_on_day_of_week USING (day_type_id)
    JOIN journey_patterns_to_check USING (journey_pattern_id)
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

CREATE OR REPLACE FUNCTION vehicle_schedule.validate_schedule_uniqueness() RETURNS trigger
  LANGUAGE plpgsql
AS $$
DECLARE
  overlapping_schedule RECORD;
  error_message TEXT;
BEGIN
  -- RAISE NOTICE 'vehicle_schedule.validate_schedule_uniqueness()';

  SELECT * FROM vehicle_schedule.get_overlapping_schedules(
    (SELECT array_agg(vehicle_schedule_frame_id) FROM updated_vehicle_schedule_frame),
    (SELECT array_agg(journey_pattern_ref_id) FROM updated_journey_pattern_ref)
  )
  LIMIT 1 -- RECORD type, so other rows are discarded anyway.
  INTO overlapping_schedule;

  IF FOUND THEN
    -- Note, this includes only one of the conflicting rows. There might be multiple.
    SELECT format(
      'vehicle schedule frame %s and vehicle schedule frame %s, priority %s, journey_pattern_id %s, overlapping on %s on day of week %s',
      overlapping_schedule.current_vehicle_schedule_frame_id,
      overlapping_schedule.other_vehicle_schedule_frame_id,
      overlapping_schedule.priority,
      overlapping_schedule.journey_pattern_id,
      overlapping_schedule.validity_intersection,
      overlapping_schedule.active_on_day_of_week
    ) INTO error_message;
    RAISE EXCEPTION 'conflicting schedules detected: %', error_message;
  END IF;

  RETURN NULL;
END;
$$;
COMMENT ON FUNCTION vehicle_schedule.validate_schedule_uniqueness()
IS 'TODO';

CREATE OR REPLACE FUNCTION vehicle_schedule.create_schedule_validation_queue_temp_tables() RETURNS void
  LANGUAGE sql PARALLEL SAFE
AS $$
  CREATE TEMP TABLE IF NOT EXISTS updated_vehicle_schedule_frame
  (
    vehicle_schedule_frame_id UUID UNIQUE
  )
  ON COMMIT DELETE ROWS;

  -- Note: table with same name is used for passing time validation. This is fine.
  CREATE TEMP TABLE IF NOT EXISTS updated_journey_pattern_ref
  (
    journey_pattern_ref_id UUID UNIQUE
  )
  ON COMMIT DELETE ROWS;
$$;
COMMENT ON FUNCTION vehicle_schedule.create_schedule_validation_queue_temp_tables()
IS 'Create the temp tables used to enqueue validation of the changed vehicle schedule frames and journey patterns from statement-level triggers';

CREATE OR REPLACE FUNCTION vehicle_schedule.queue_schedule_uniqueness_validation_by_vsf_id() RETURNS trigger
  LANGUAGE plpgsql
AS $$
BEGIN
  -- RAISE NOTICE 'vehicle_schedule.queue_schedule_uniqueness_validation_by_vsf_id()';

  PERFORM vehicle_schedule.create_schedule_validation_queue_temp_tables();

  INSERT INTO updated_vehicle_schedule_frame (vehicle_schedule_frame_id)
  SELECT DISTINCT vehicle_schedule_frame_id
  FROM new_table
  ON CONFLICT DO NOTHING;

  RETURN NULL;
END;
$$;
COMMENT ON FUNCTION vehicle_schedule.queue_schedule_uniqueness_validation_by_vsf_id()
IS 'Queue modified vehicle schedule frames for schedule uniqueness validation which is performed at the end of transaction.';

CREATE OR REPLACE FUNCTION vehicle_schedule.schedule_uniqueness_already_validated() RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
  schedule_uniqueness_already_validated BOOLEAN;
BEGIN
  schedule_uniqueness_already_validated := NULLIF(current_setting('vehicle_schedule_vars.schedule_uniqueness_already_validated', TRUE), '');
  IF schedule_uniqueness_already_validated IS TRUE THEN
    RETURN TRUE;
  ELSE
    -- SET LOCAL = only for this transaction. https://www.postgresql.org/docs/current/sql-set.html
    SET LOCAL vehicle_schedule_vars.schedule_uniqueness_already_validated = TRUE;
    RETURN FALSE;
  END IF;
END
$$;
COMMENT ON FUNCTION vehicle_schedule.schedule_uniqueness_already_validated()
IS 'Keep track of whether the schedule uniqueness validation has already been performed in this transaction';

-- TODO: add all necessary triggers, and run the validation only once per transaction.
DROP TRIGGER IF EXISTS queue_validate_schedule_uniqueness_on_vsf_insert_trigger ON vehicle_schedule.vehicle_schedule_frame;
CREATE TRIGGER queue_validate_schedule_uniqueness_on_vsf_insert_trigger
  AFTER INSERT ON vehicle_schedule.vehicle_schedule_frame
  REFERENCING NEW TABLE AS new_table
  FOR EACH STATEMENT
  EXECUTE FUNCTION vehicle_schedule.queue_schedule_uniqueness_validation_by_vsf_id();
COMMENT ON TRIGGER queue_validate_schedule_uniqueness_on_vsf_insert_trigger ON vehicle_schedule.vehicle_schedule_frame
IS 'TODO';

DROP TRIGGER IF EXISTS queue_validate_schedule_uniqueness_on_vsf_update_trigger ON vehicle_schedule.vehicle_schedule_frame;
CREATE TRIGGER queue_validate_schedule_uniqueness_on_vsf_update_trigger
  AFTER UPDATE ON vehicle_schedule.vehicle_schedule_frame
  REFERENCING NEW TABLE AS new_table
  FOR EACH STATEMENT
  EXECUTE FUNCTION vehicle_schedule.queue_schedule_uniqueness_validation_by_vsf_id();
COMMENT ON TRIGGER queue_validate_schedule_uniqueness_on_vsf_update_trigger ON vehicle_schedule.vehicle_schedule_frame
IS 'TODO';

DROP TRIGGER IF EXISTS validate_schedule_uniqueness_trigger ON vehicle_schedule.vehicle_schedule_frame;
CREATE CONSTRAINT TRIGGER validate_schedule_uniqueness_trigger
  AFTER UPDATE OR INSERT OR DELETE ON vehicle_schedule.vehicle_schedule_frame
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
  WHEN (NOT vehicle_schedule.schedule_uniqueness_already_validated())
  EXECUTE FUNCTION vehicle_schedule.validate_schedule_uniqueness();
COMMENT ON TRIGGER validate_schedule_uniqueness_trigger ON vehicle_schedule.vehicle_schedule_frame
IS 'Trigger to validate the schedule uniqueness after modifications on vehicle schedule frames.
    This trigger will cause those VSFs to be checked, whose ID was queued to be checked by a statement level trigger.';
