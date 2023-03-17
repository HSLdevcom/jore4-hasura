-- NOTE: it would make more sense to return `interval` instead of `text`, but
-- hasura won't let save those as computed fields:
-- "Inconsistent object: in table "vehicle_journey.vehicle_journey": in computed field "start_time": the computed field "start_time" cannot be added to table "vehicle_journey.vehicle_journey" because the function "vehicle_journey.vehicle_journey_start_time" returning type interval is not a BASE type"

CREATE OR REPLACE FUNCTION vehicle_journey.vehicle_journey_start_time(vj vehicle_journey.vehicle_journey)
RETURNS text AS $$
  SELECT MIN (departure_time)::text AS start_time
  FROM passing_times.timetabled_passing_time tpt
  WHERE tpt.vehicle_journey_id = vj.vehicle_journey_id;
$$ LANGUAGE sql STABLE;

CREATE OR REPLACE FUNCTION vehicle_journey.vehicle_journey_end_time(vj vehicle_journey.vehicle_journey)
RETURNS text AS $$
  SELECT MAX (arrival_time)::text AS end_time
  FROM passing_times.timetabled_passing_time tpt
  WHERE tpt.vehicle_journey_id = vj.vehicle_journey_id;
$$ LANGUAGE sql STABLE;

-- TODO: these should be in separate migration file, preferably before all other repeatable after migrations -> would need to increment all migration timestamps.

-- Create queue tables.

CREATE OR REPLACE FUNCTION internal_utils.create_validation_queue_temp_tables() RETURNS void
  LANGUAGE sql PARALLEL SAFE
AS $$
  CREATE TEMP TABLE IF NOT EXISTS modified_vehicle_schedule_frame
  (
    vehicle_schedule_frame_id UUID UNIQUE
  )
  ON COMMIT DELETE ROWS;

  CREATE TEMP TABLE IF NOT EXISTS modified_journey_pattern_ref
  (
    journey_pattern_ref_id UUID UNIQUE
  )
  ON COMMIT DELETE ROWS;

  -- TODO: more tables
$$;
COMMENT ON FUNCTION internal_utils.create_validation_queue_temp_tables()
IS 'Create the temp tables used to enqueue validation of the changed rows from statement-level triggers.';

-- Create functions for queuing rows for validation.

CREATE OR REPLACE FUNCTION vehicle_schedule.queue_validation_by_vsf_id() RETURNS trigger
  LANGUAGE plpgsql
AS $$
BEGIN
  -- RAISE LOG 'vehicle_schedule.queue_validation_by_vsf_id()';

  PERFORM internal_utils.create_validation_queue_temp_tables();

  INSERT INTO modified_vehicle_schedule_frame (vehicle_schedule_frame_id)
  SELECT DISTINCT vehicle_schedule_frame_id
  FROM new_table
  ON CONFLICT DO NOTHING;

  RETURN NULL;
END;
$$;
COMMENT ON FUNCTION vehicle_schedule.queue_validation_by_vsf_id()
IS 'Queue modified vehicle schedule frames for validation which is performed at the end of transaction.';

CREATE OR REPLACE FUNCTION internal_utils.queued_validations_already_processed() RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
  queued_validations_already_processed BOOLEAN;
BEGIN
  queued_validations_already_processed := NULLIF(current_setting('internal_vars.queued_validations_already_processed', TRUE), '');
  IF queued_validations_already_processed IS TRUE THEN
    RETURN TRUE;
  ELSE
    -- SET LOCAL = only for this transaction. https://www.postgresql.org/docs/current/sql-set.html
    SET LOCAL internal_vars.queued_validations_already_processed = TRUE;
    RETURN FALSE;
  END IF;
END
$$;
COMMENT ON FUNCTION internal_utils.queued_validations_already_processed()
IS 'Keep track of whether the queued validations have already been processed in this transaction';

-- Create the function to process validation queues.
-- Placeholder, so that the triggers for it can be setup here.
-- Actual implementation added in later migration when all functions that this needs to call exist.

CREATE OR REPLACE FUNCTION internal_utils.execute_queued_validations() RETURNS trigger
  LANGUAGE plpgsql
AS $$
BEGIN
  RETURN NULL;
END;
$$;

-- Create the triggers.
-- Queue triggers:

DROP TRIGGER IF EXISTS queue_vsf_validation_on_insert_trigger ON vehicle_schedule.vehicle_schedule_frame;
CREATE TRIGGER queue_vsf_validation_on_insert_trigger
  AFTER INSERT ON vehicle_schedule.vehicle_schedule_frame
  REFERENCING NEW TABLE AS new_table
  FOR EACH STATEMENT
  EXECUTE FUNCTION vehicle_schedule.queue_validation_by_vsf_id();

DROP TRIGGER IF EXISTS queue_vsf_validation_on_update_trigger ON vehicle_schedule.vehicle_schedule_frame;
CREATE TRIGGER queue_vsf_validation_on_update_trigger
  AFTER UPDATE ON vehicle_schedule.vehicle_schedule_frame
  REFERENCING NEW TABLE AS new_table
  FOR EACH STATEMENT
  EXECUTE FUNCTION vehicle_schedule.queue_validation_by_vsf_id();

-- End of statement validation triggers:

DROP TRIGGER IF EXISTS process_queued_validation_on_vsf_trigger ON vehicle_schedule.vehicle_schedule_frame;
CREATE CONSTRAINT TRIGGER process_queued_validation_on_vsf_trigger
  AFTER UPDATE OR INSERT ON vehicle_schedule.vehicle_schedule_frame
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
  WHEN (NOT internal_utils.queued_validations_already_processed())
  EXECUTE FUNCTION internal_utils.execute_queued_validations();
COMMENT ON TRIGGER process_queued_validation_on_vsf_trigger ON vehicle_schedule.vehicle_schedule_frame
IS 'Trigger to validate the schedule uniqueness after modifications on vehicle schedule frames.
    This trigger will cause those VSFs to be checked, whose ID was queued to be checked by a statement level trigger.';


-- Triggers TODO here:

-- done AFTER INSERT ON vehicle_schedule.vehicle_schedule_frame -- schedules
-- done AFTER UPDATE ON vehicle_schedule.vehicle_schedule_frame -- schedules
-- AFTER UPDATE ON journey_pattern.journey_pattern_ref -- journey_patterns_in_vehicle_service
-- AFTER UPDATE ON journey_pattern.journey_pattern_ref -- schedules
-- AFTER UPDATE ON vehicle_service.block -- journey_patterns_in_vehicle_service
-- AFTER UPDATE ON vehicle_service.block -- foreign key -- schedules
-- AFTER UPDATE ON vehicle_service.vehicle_service -- foreign key, days? -- schedules
-- AFTER UPDATE OR INSERT ON vehicle_journey -- schedules
-- AFTER UPDATE OR INSERT OR DELETE ON vehicle_journey.vehicle_journey -- journey_patterns_in_vehicle_service

-- -- passing times
-- AFTER UPDATE ON passing_times.timetabled_passing_time
-- AFTER INSERT ON passing_times.timetabled_passing_time
-- AFTER DELETE ON passing_times.timetabled_passing_time
-- AFTER UPDATE ON service_pattern.scheduled_stop_point_in_journey_pattern_ref
-- AFTER INSERT ON service_pattern.scheduled_stop_point_in_journey_pattern_ref
