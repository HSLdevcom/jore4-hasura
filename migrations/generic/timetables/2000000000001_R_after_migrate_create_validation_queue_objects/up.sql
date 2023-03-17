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
    FROM new_table
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
    FROM new_table
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
    FROM new_table
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
    FROM new_table
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
    FROM new_table
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

DROP TRIGGER IF EXISTS queue_vsf_validation_on_insert_trigger ON vehicle_schedule.vehicle_schedule_frame;
CREATE TRIGGER queue_vsf_validation_on_insert_trigger
  AFTER INSERT ON vehicle_schedule.vehicle_schedule_frame
  REFERENCING NEW TABLE AS new_table
  FOR EACH STATEMENT
  EXECUTE FUNCTION vehicle_schedule.queue_validation_by_vsf_id();
COMMENT ON TRIGGER queue_vsf_validation_on_insert_trigger ON vehicle_schedule.vehicle_schedule_frame
IS 'Trigger for queuing modified vehicle schedule frames for later validation.
Actual validation is performed at the end of transaction by execute_queued_validations().';

DROP TRIGGER IF EXISTS queue_vsf_validation_on_update_trigger ON vehicle_schedule.vehicle_schedule_frame;
CREATE TRIGGER queue_vsf_validation_on_update_trigger
  AFTER UPDATE ON vehicle_schedule.vehicle_schedule_frame
  REFERENCING NEW TABLE AS new_table
  FOR EACH STATEMENT
  EXECUTE FUNCTION vehicle_schedule.queue_validation_by_vsf_id();
COMMENT ON TRIGGER queue_vsf_validation_on_update_trigger ON vehicle_schedule.vehicle_schedule_frame
IS 'Trigger for queuing modified vehicle schedule frames for later validation.
Actual validation is performed at the end of transaction by execute_queued_validations().';

DROP TRIGGER IF EXISTS queue_block_validation_on_update_trigger ON vehicle_service.block;
CREATE TRIGGER queue_block_validation_on_update_trigger
  AFTER UPDATE ON vehicle_service.block
  REFERENCING NEW TABLE AS new_table
  FOR EACH STATEMENT
  EXECUTE FUNCTION vehicle_service.queue_validation_by_block_id();
COMMENT ON TRIGGER queue_block_validation_on_update_trigger ON vehicle_service.block
IS 'Trigger for queuing modified vehicle service blocks for later validation.
Actual validation is performed at the end of transaction by execute_queued_validations().';

DROP TRIGGER IF EXISTS queue_vj_validation_on_update_trigger ON vehicle_journey.vehicle_journey;
CREATE TRIGGER queue_vj_validation_on_update_trigger
  AFTER UPDATE ON vehicle_journey.vehicle_journey
  REFERENCING NEW TABLE AS new_table
  FOR EACH STATEMENT
  EXECUTE FUNCTION vehicle_journey.queue_validation_by_vj_id();
COMMENT ON TRIGGER queue_vj_validation_on_update_trigger ON vehicle_journey.vehicle_journey
IS 'Trigger for queuing modified vehicle journeys for later validation.
Actual validation is performed at the end of transaction by execute_queued_validations().';

DROP TRIGGER IF EXISTS queue_jpr_validation_on_update_trigger ON journey_pattern.journey_pattern_ref;
CREATE TRIGGER queue_jpr_validation_on_update_trigger
  AFTER UPDATE ON journey_pattern.journey_pattern_ref
  REFERENCING NEW TABLE AS new_table
  FOR EACH STATEMENT
  EXECUTE FUNCTION journey_pattern.queue_validation_by_jpr_id();
COMMENT ON TRIGGER queue_jpr_validation_on_update_trigger ON journey_pattern.journey_pattern_ref
IS 'Trigger for queuing modified journey pattern refs for later validation.
Actual validation is performed at the end of transaction by execute_queued_validations().';

DROP TRIGGER IF EXISTS queue_jpr_validation_on_insert_trigger ON journey_pattern.journey_pattern_ref;
CREATE TRIGGER queue_jpr_validation_on_insert_trigger
  AFTER INSERT ON journey_pattern.journey_pattern_ref
  REFERENCING NEW TABLE AS new_table
  FOR EACH STATEMENT
  EXECUTE FUNCTION journey_pattern.queue_validation_by_jpr_id();
COMMENT ON TRIGGER queue_jpr_validation_on_insert_trigger ON journey_pattern.journey_pattern_ref
IS 'Trigger for queuing modified journey pattern refs for later validation.
Actual validation is performed at the end of transaction by execute_queued_validations().';

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
