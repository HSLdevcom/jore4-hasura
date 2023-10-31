-- This migration contains necessary triggers for queueing modified rows for later validation.
--
-- Since there will be lots of rows modified, ROW level triggers would be inefficient.
-- We can't use STATEMENT level triggers for validation because constraint triggers
-- can only be specified FOR EACH ROW, not STATEMENT level.
--
-- Overall the process goes like this, two types of triggers are involved:
--
-- 1. queue_xx_on_update/insert/delete_trigger
-- * Note: these need to be separate for each operation
--         because PostgreSQL doesn't accept eg. INSERT OR UPDATE here
-- * Note: Called immediately after INSERT/UPDATE/DELETE statement (because NOT DEFERRABLE is in effect by default)
-- --> Calls create_validation_queue_temp_tables:
-- * Creates queue tables if needed (one for each real table involved here)
--   - These are temporary tables only for the current transaction.
-- * This queues rows to be validated by inserting their ids to the appropriate queue temp table,
--   no actual validation gets performed yet.
--
-- 2. process_queued_validation_on_xxx_trigger
-- * Executed at end of transaction (INITIALLY DEFERRED).
-- * internal_utils.queued_validations_already_processed handles that we only do the validation once,
--   even if trigger is set up to fire FOR EACH ROW
-- --> Calls internal_utils.execute_queued_validations
-- * Note: this is defined in a separate migration.
-- * This then calls all necessary validation functions.
-- * Each validation function typically fetches necessary modified entries
--   that were previously added to the queue temp tables and performs its validation on them.

-- Create queue tables.

CREATE OR REPLACE FUNCTION internal_utils.create_validation_queue_temp_tables() RETURNS void
  LANGUAGE sql PARALLEL SAFE
  AS $$
    CREATE TEMP TABLE IF NOT EXISTS modified_vehicle_schedule_frame
    ( vehicle_schedule_frame_id UUID UNIQUE )
    ON COMMIT DELETE ROWS;

    CREATE TEMP TABLE IF NOT EXISTS modified_vehicle_service
    ( vehicle_service_id UUID UNIQUE )
    ON COMMIT DELETE ROWS;

    CREATE TEMP TABLE IF NOT EXISTS modified_block
    ( block_id UUID UNIQUE )
    ON COMMIT DELETE ROWS;

    CREATE TEMP TABLE IF NOT EXISTS modified_vehicle_journey
    ( vehicle_journey_id UUID UNIQUE )
    ON COMMIT DELETE ROWS;

    CREATE TEMP TABLE IF NOT EXISTS modified_journey_pattern_ref
    ( journey_pattern_ref_id UUID UNIQUE )
    ON COMMIT DELETE ROWS;
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
    FROM modified_table -- either the NEW TABLE on INSERT/UPDATE, or OLD TABLE on DELETE.
    ON CONFLICT DO NOTHING;

    RETURN NULL;
  END;
  $$;
COMMENT ON FUNCTION vehicle_schedule.queue_validation_by_vsf_id()
IS 'Queue modified vehicle schedule frames for validation which is performed at the end of transaction.';

CREATE OR REPLACE FUNCTION vehicle_service.queue_validation_by_vs_id() RETURNS trigger
  LANGUAGE plpgsql
  AS $$
  BEGIN
    -- RAISE LOG 'vehicle_service.queue_validation_by_vs_id()';

    PERFORM internal_utils.create_validation_queue_temp_tables();

    INSERT INTO modified_vehicle_service (vehicle_service_id)
    SELECT DISTINCT vehicle_service_id
    FROM modified_table -- either the NEW TABLE on INSERT/UPDATE, or OLD TABLE on DELETE.
    ON CONFLICT DO NOTHING;

    RETURN NULL;
  END;
  $$;
COMMENT ON FUNCTION vehicle_service.queue_validation_by_vs_id()
IS 'Queue modified vehicle services for validation which is performed at the end of transaction.';

CREATE OR REPLACE FUNCTION vehicle_service.queue_validation_by_block_id() RETURNS trigger
  LANGUAGE plpgsql
  AS $$
  BEGIN
    -- RAISE LOG 'vehicle_service.queue_validation_by_block_id()';

    PERFORM internal_utils.create_validation_queue_temp_tables();

    INSERT INTO modified_block (block_id)
    SELECT DISTINCT block_id
    FROM modified_table -- either the NEW TABLE on INSERT/UPDATE, or OLD TABLE on DELETE.
    ON CONFLICT DO NOTHING;

    RETURN NULL;
  END;
  $$;
COMMENT ON FUNCTION vehicle_service.queue_validation_by_block_id()
IS 'Queue modified vehicle service blocks for validation which is performed at the end of transaction.';

CREATE OR REPLACE FUNCTION vehicle_journey.queue_validation_by_vj_id() RETURNS trigger
  LANGUAGE plpgsql
  AS $$
  BEGIN
    -- RAISE LOG 'vehicle_journey.queue_validation_by_vj_id()';

    PERFORM internal_utils.create_validation_queue_temp_tables();

    INSERT INTO modified_vehicle_journey (vehicle_journey_id)
    SELECT DISTINCT vehicle_journey_id
    FROM modified_table -- either the NEW TABLE on INSERT/UPDATE, or OLD TABLE on DELETE.
    ON CONFLICT DO NOTHING;

    RETURN NULL;
  END;
  $$;
COMMENT ON FUNCTION vehicle_journey.queue_validation_by_vj_id()
IS 'Queue modified vehicle journeys for validation which is performed at the end of transaction.';

CREATE OR REPLACE FUNCTION journey_pattern.queue_validation_by_jpr_id() RETURNS trigger
  LANGUAGE plpgsql
  AS $$
  BEGIN
    -- RAISE LOG 'journey_pattern.queue_validation_by_jpr_id()';

    PERFORM internal_utils.create_validation_queue_temp_tables();

    INSERT INTO modified_journey_pattern_ref (journey_pattern_ref_id)
    SELECT DISTINCT journey_pattern_ref_id
    FROM modified_table -- either the NEW TABLE on INSERT/UPDATE, or OLD TABLE on DELETE.
    ON CONFLICT DO NOTHING;

    RETURN NULL;
  END;
  $$;
COMMENT ON FUNCTION journey_pattern.queue_validation_by_jpr_id()
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

-- vehicle_schedule_frame:
DROP TRIGGER IF EXISTS queue_vsf_validation_on_insert_trigger ON vehicle_schedule.vehicle_schedule_frame;
CREATE TRIGGER queue_vsf_validation_on_insert_trigger
  AFTER INSERT ON vehicle_schedule.vehicle_schedule_frame
  REFERENCING NEW TABLE AS modified_table
  FOR EACH STATEMENT
  EXECUTE FUNCTION vehicle_schedule.queue_validation_by_vsf_id();
COMMENT ON TRIGGER queue_vsf_validation_on_insert_trigger ON vehicle_schedule.vehicle_schedule_frame
IS 'Trigger for queuing modified vehicle schedule frames for later validation.
Actual validation is performed at the end of transaction by execute_queued_validations().';

DROP TRIGGER IF EXISTS queue_vsf_validation_on_update_trigger ON vehicle_schedule.vehicle_schedule_frame;
CREATE TRIGGER queue_vsf_validation_on_update_trigger
  AFTER UPDATE ON vehicle_schedule.vehicle_schedule_frame
  REFERENCING NEW TABLE AS modified_table
  FOR EACH STATEMENT
  EXECUTE FUNCTION vehicle_schedule.queue_validation_by_vsf_id();
COMMENT ON TRIGGER queue_vsf_validation_on_update_trigger ON vehicle_schedule.vehicle_schedule_frame
IS 'Trigger for queuing modified vehicle schedule frames for later validation.
Actual validation is performed at the end of transaction by execute_queued_validations().';

-- vehicle_service:
DROP TRIGGER IF EXISTS queue_vs_validation_on_update_trigger ON vehicle_service.vehicle_service;
CREATE TRIGGER queue_vs_validation_on_update_trigger
  AFTER UPDATE ON vehicle_service.vehicle_service
  REFERENCING NEW TABLE AS modified_table
  FOR EACH STATEMENT
  EXECUTE FUNCTION vehicle_service.queue_validation_by_vs_id();
COMMENT ON TRIGGER queue_vs_validation_on_update_trigger ON vehicle_service.vehicle_service
IS 'Trigger for queuing modified vehicle schedules for later validation.
Actual validation is performed at the end of transaction by execute_queued_validations().';

-- block:
DROP TRIGGER IF EXISTS queue_block_validation_on_update_trigger ON vehicle_service.block;
CREATE TRIGGER queue_block_validation_on_update_trigger
  AFTER UPDATE ON vehicle_service.block
  REFERENCING NEW TABLE AS modified_table
  FOR EACH STATEMENT
  EXECUTE FUNCTION vehicle_service.queue_validation_by_block_id();
COMMENT ON TRIGGER queue_block_validation_on_update_trigger ON vehicle_service.block
IS 'Trigger for queuing modified vehicle service blocks for later validation.
Actual validation is performed at the end of transaction by execute_queued_validations().';

-- vehicle_journey:
DROP TRIGGER IF EXISTS queue_vj_validation_on_insert_trigger ON vehicle_journey.vehicle_journey;
CREATE TRIGGER queue_vj_validation_on_insert_trigger
  AFTER INSERT ON vehicle_journey.vehicle_journey
  REFERENCING NEW TABLE AS modified_table
  FOR EACH STATEMENT
  EXECUTE FUNCTION vehicle_journey.queue_validation_by_vj_id();
COMMENT ON TRIGGER queue_vj_validation_on_insert_trigger ON vehicle_journey.vehicle_journey
IS 'Trigger for queuing modified vehicle journeys for later validation.
Actual validation is performed at the end of transaction by execute_queued_validations().';

DROP TRIGGER IF EXISTS queue_vj_validation_on_update_trigger ON vehicle_journey.vehicle_journey;
CREATE TRIGGER queue_vj_validation_on_update_trigger
  AFTER UPDATE ON vehicle_journey.vehicle_journey
  REFERENCING NEW TABLE AS modified_table
  FOR EACH STATEMENT
  EXECUTE FUNCTION vehicle_journey.queue_validation_by_vj_id();
COMMENT ON TRIGGER queue_vj_validation_on_update_trigger ON vehicle_journey.vehicle_journey
IS 'Trigger for queuing modified vehicle journeys for later validation.
Actual validation is performed at the end of transaction by execute_queued_validations().';

-- journey_pattern_ref:
DROP TRIGGER IF EXISTS queue_jpr_validation_on_update_trigger ON journey_pattern.journey_pattern_ref;
CREATE TRIGGER queue_jpr_validation_on_update_trigger
  AFTER UPDATE ON journey_pattern.journey_pattern_ref
  REFERENCING NEW TABLE AS modified_table
  FOR EACH STATEMENT
  EXECUTE FUNCTION journey_pattern.queue_validation_by_jpr_id();
COMMENT ON TRIGGER queue_jpr_validation_on_update_trigger ON journey_pattern.journey_pattern_ref
IS 'Trigger for queuing modified journey pattern refs for later validation.
Actual validation is performed at the end of transaction by execute_queued_validations().';

DROP TRIGGER IF EXISTS queue_jpr_validation_on_insert_trigger ON journey_pattern.journey_pattern_ref;
CREATE TRIGGER queue_jpr_validation_on_insert_trigger
  AFTER INSERT ON journey_pattern.journey_pattern_ref
  REFERENCING NEW TABLE AS modified_table
  FOR EACH STATEMENT
  EXECUTE FUNCTION journey_pattern.queue_validation_by_jpr_id();
COMMENT ON TRIGGER queue_jpr_validation_on_insert_trigger ON journey_pattern.journey_pattern_ref
IS 'Trigger for queuing modified journey pattern refs for later validation.
Actual validation is performed at the end of transaction by execute_queued_validations().';

-- timetabled_passing_time (NOTE: these queue the whole vehicle_journey for validation):

DROP TRIGGER IF EXISTS queue_validate_passing_times_sequence_on_pt_update_trigger ON passing_times.timetabled_passing_time;
CREATE TRIGGER queue_validate_passing_times_sequence_on_pt_update_trigger
  AFTER UPDATE ON passing_times.timetabled_passing_time
  REFERENCING NEW TABLE AS modified_table
  FOR EACH STATEMENT
  EXECUTE FUNCTION vehicle_journey.queue_validation_by_vj_id();
COMMENT ON TRIGGER queue_validate_passing_times_sequence_on_pt_update_trigger ON passing_times.timetabled_passing_time
IS 'Trigger to queue validation of passing times <-> stop point sequences on update.
    Actual validation is triggered later by deferred validate_passing_times_sequence_trigger() trigger';

DROP TRIGGER IF EXISTS queue_validate_passing_times_sequence_on_pt_insert_trigger ON passing_times.timetabled_passing_time;
CREATE TRIGGER queue_validate_passing_times_sequence_on_pt_insert_trigger
  AFTER INSERT ON passing_times.timetabled_passing_time
  REFERENCING NEW TABLE AS modified_table
  FOR EACH STATEMENT
  EXECUTE FUNCTION vehicle_journey.queue_validation_by_vj_id();
COMMENT ON TRIGGER queue_validate_passing_times_sequence_on_pt_insert_trigger ON passing_times.timetabled_passing_time
IS 'Trigger to queue validation of passing times <-> stop point sequences on insert.
    Actual validation is triggered later by deferred validate_passing_times_sequence_trigger() trigger';

DROP TRIGGER IF EXISTS queue_validate_passing_times_sequence_on_pt_delete_trigger ON passing_times.timetabled_passing_time;
CREATE TRIGGER queue_validate_passing_times_sequence_on_pt_delete_trigger
  AFTER DELETE ON passing_times.timetabled_passing_time
  REFERENCING OLD TABLE AS modified_table
  FOR EACH STATEMENT
  EXECUTE FUNCTION vehicle_journey.queue_validation_by_vj_id();
COMMENT ON TRIGGER queue_validate_passing_times_sequence_on_pt_delete_trigger ON passing_times.timetabled_passing_time
IS 'Trigger to queue validation of passing times <-> stop point sequences on delete.
    Actual validation is triggered later by deferred validate_passing_times_sequence_trigger() trigger';

-- scheduled_stop_point_in_journey_pattern_ref (NOTE: these queue the whole journey_pattern_ref for validation):

DROP TRIGGER IF EXISTS queue_validate_passing_times_sequence_on_ssp_update_trigger ON service_pattern.scheduled_stop_point_in_journey_pattern_ref;
CREATE TRIGGER queue_validate_passing_times_sequence_on_ssp_update_trigger
  AFTER UPDATE ON service_pattern.scheduled_stop_point_in_journey_pattern_ref
  REFERENCING NEW TABLE AS modified_table
  FOR EACH STATEMENT
  EXECUTE FUNCTION journey_pattern.queue_validation_by_jpr_id();
COMMENT ON TRIGGER queue_validate_passing_times_sequence_on_ssp_update_trigger ON service_pattern.scheduled_stop_point_in_journey_pattern_ref
IS 'Trigger to queue validation of passing times <-> stop point sequences on stop point update.
    Actual validation is triggered later by deferred validate_passing_times_sequence_trigger() trigger';

DROP TRIGGER IF EXISTS queue_validate_passing_times_sequence_on_ssp_insert_trigger ON service_pattern.scheduled_stop_point_in_journey_pattern_ref;
CREATE TRIGGER queue_validate_passing_times_sequence_on_ssp_insert_trigger
  AFTER INSERT ON service_pattern.scheduled_stop_point_in_journey_pattern_ref
  REFERENCING NEW TABLE AS modified_table
  FOR EACH STATEMENT
  EXECUTE FUNCTION journey_pattern.queue_validation_by_jpr_id();
COMMENT ON TRIGGER queue_validate_passing_times_sequence_on_ssp_insert_trigger ON service_pattern.scheduled_stop_point_in_journey_pattern_ref
IS 'Trigger to queue validation of passing times <-> stop point sequences on stop point insert.
    Actual validation is triggered later by deferred validate_passing_times_sequence_trigger() trigger';

-- End of statement validation triggers:

DROP TRIGGER IF EXISTS process_queued_validation_on_vsf_trigger ON vehicle_schedule.vehicle_schedule_frame;
CREATE CONSTRAINT TRIGGER process_queued_validation_on_vsf_trigger
  AFTER INSERT OR UPDATE ON vehicle_schedule.vehicle_schedule_frame
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
  WHEN (NOT internal_utils.queued_validations_already_processed())
  EXECUTE FUNCTION internal_utils.execute_queued_validations();
COMMENT ON TRIGGER process_queued_validation_on_vsf_trigger ON vehicle_schedule.vehicle_schedule_frame
IS 'Trigger to execute queued validations at the end of the transaction that were registered earlier by statement level triggers';

DROP TRIGGER IF EXISTS process_queued_validation_on_vs_trigger ON vehicle_service.vehicle_service;
CREATE CONSTRAINT TRIGGER process_queued_validation_on_vs_trigger
  AFTER UPDATE ON vehicle_service.vehicle_service
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
  WHEN (NOT internal_utils.queued_validations_already_processed())
  EXECUTE FUNCTION internal_utils.execute_queued_validations();
COMMENT ON TRIGGER process_queued_validation_on_vs_trigger ON vehicle_service.vehicle_service
IS 'Trigger to execute queued validations at the end of the transaction that were registered earlier by statement level triggers';

DROP TRIGGER IF EXISTS process_queued_validation_on_block_trigger ON vehicle_service.block;
CREATE CONSTRAINT TRIGGER process_queued_validation_on_block_trigger
  AFTER UPDATE ON vehicle_service.block
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
  WHEN (NOT internal_utils.queued_validations_already_processed())
  EXECUTE FUNCTION internal_utils.execute_queued_validations();
COMMENT ON TRIGGER process_queued_validation_on_block_trigger ON vehicle_service.block
IS 'Trigger to execute queued validations at the end of the transaction that were registered earlier by statement level triggers';

DROP TRIGGER IF EXISTS process_queued_validation_on_vj_trigger ON vehicle_journey.vehicle_journey;
CREATE CONSTRAINT TRIGGER process_queued_validation_on_vj_trigger
  -- NOTE: the DELETE does not currently have related queue trigger.
  -- That is because we only need it for refresh_journey_patterns_in_vehicle_service,
  -- which does not need to know which rows were deleted.
  AFTER UPDATE OR INSERT OR DELETE ON vehicle_journey.vehicle_journey
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
  WHEN (NOT internal_utils.queued_validations_already_processed())
  EXECUTE FUNCTION internal_utils.execute_queued_validations();
COMMENT ON TRIGGER process_queued_validation_on_vj_trigger ON vehicle_journey.vehicle_journey
IS 'Trigger to execute queued validations at the end of the transaction that were registered earlier by statement level triggers';

DROP TRIGGER IF EXISTS process_queued_validation_on_jpr_trigger ON journey_pattern.journey_pattern_ref;
CREATE CONSTRAINT TRIGGER process_queued_validation_on_jpr_trigger
  AFTER UPDATE ON journey_pattern.journey_pattern_ref
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
  WHEN (NOT internal_utils.queued_validations_already_processed())
  EXECUTE FUNCTION internal_utils.execute_queued_validations();
COMMENT ON TRIGGER process_queued_validation_on_jpr_trigger ON journey_pattern.journey_pattern_ref
IS 'Trigger to execute queued validations at the end of the transaction that were registered earlier by statement level triggers';

DROP TRIGGER IF EXISTS validate_passing_times_sequence_trigger ON passing_times.timetabled_passing_time;
CREATE CONSTRAINT TRIGGER validate_passing_times_sequence_trigger
  AFTER UPDATE OR INSERT OR DELETE ON passing_times.timetabled_passing_time
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
  WHEN (NOT internal_utils.queued_validations_already_processed())
  EXECUTE FUNCTION internal_utils.execute_queued_validations();
COMMENT ON TRIGGER validate_passing_times_sequence_trigger ON passing_times.timetabled_passing_time
IS 'Trigger to validate the passing time <-> stop point sequence after modifications on the passing time table.
    This trigger will cause those vehicle journeys to be checked, whose ID was queued to be checked by a statement level trigger.';

DROP TRIGGER IF EXISTS validate_passing_times_sequence_trigger ON service_pattern.scheduled_stop_point_in_journey_pattern_ref;
CREATE CONSTRAINT TRIGGER validate_passing_times_sequence_trigger
  AFTER UPDATE OR INSERT ON service_pattern.scheduled_stop_point_in_journey_pattern_ref
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
  WHEN (NOT internal_utils.queued_validations_already_processed())
  EXECUTE FUNCTION internal_utils.execute_queued_validations();
COMMENT ON TRIGGER validate_passing_times_sequence_trigger ON service_pattern.scheduled_stop_point_in_journey_pattern_ref
IS 'Trigger to validate the passing time <-> stop point sequence after modifications on the passing time table.
    This trigger will cause those vehicle journeys to be checked, whose ID was queued to be checked by a statement level trigger.';
