ALTER TABLE passing_times.timetabled_passing_time
  ADD CONSTRAINT arrival_or_departure_time_exists CHECK (arrival_time IS NOT NULL OR departure_time IS NOT NULL);

ALTER TABLE passing_times.timetabled_passing_time
  ADD CONSTRAINT arrival_not_after_departure CHECK (
    (arrival_time IS NULL OR departure_time IS NULL) OR
    (arrival_time <= departure_time)
  );

CREATE OR REPLACE FUNCTION passing_times.get_passing_time_order_validity_data(filter_vehicle_journey_ids uuid[], filter_journey_pattern_ref_ids uuid[])
RETURNS TABLE(
  vehicle_journey_id uuid,
  first_passing_time_id uuid,
  last_passing_time_id uuid,
  stop_order_is_valid boolean,
  coherent_journey_pattern_refs boolean
)
  LANGUAGE sql STABLE PARALLEL SAFE
AS $$
WITH RECURSIVE
  -- Select data in a suitable format for passing time stop point validation.
  passing_time_sequence_combos AS (
    SELECT
      tpt.*,
      vj.journey_pattern_ref_id AS vehicle_journey_journey_pattern_ref_id,
      ssp.journey_pattern_ref_id AS stop_point_journey_pattern_ref_id,
      -- Create a continuous sequence number of the scheduled_stop_point_sequence
      -- (which is not required to be continuous, i.e. there can be gaps).
      ROW_NUMBER() OVER (PARTITION BY tpt.vehicle_journey_id ORDER BY ssp.scheduled_stop_point_sequence) stop_point_order
    FROM passing_times.timetabled_passing_time tpt
    JOIN service_pattern.scheduled_stop_point_in_journey_pattern_ref ssp USING (scheduled_stop_point_in_journey_pattern_ref_id)
    JOIN vehicle_journey.vehicle_journey vj USING (vehicle_journey_id)
    WHERE vehicle_journey_id = ANY(filter_vehicle_journey_ids)
    OR ssp.journey_pattern_ref_id = ANY(filter_journey_pattern_ref_ids)
  ),
  -- Try to go through passing times in sequence order,
  -- and mark if the passing times are in matching order.
  traversal AS (
    SELECT
      *,
      true AS is_after_previous
    FROM passing_time_sequence_combos combos
    WHERE combos.stop_point_order = 1
  UNION ALL
    SELECT
      combo.*,
      combo.arrival_time >= previous_combo.departure_time AS is_after_previous
    FROM traversal as previous_combo
    JOIN passing_time_sequence_combos combo USING (vehicle_journey_id)
    WHERE combo.stop_point_order = previous_combo.stop_point_order + 1
  ),
  -- Check validity of the whole stop point order sequence for each vehicle journey.
  stop_point_order_validity AS (
    SELECT
      DISTINCT vehicle_journey_id,
      EVERY(is_after_previous) AS stop_order_is_valid,
      -- There exists two paths between vehicle_journey and journey_pattern_ref:
      -- 1. directly from vehicle_journey -> journey_pattern_ref
      -- 2. via timetabled_passing_times and related scheduled_stop_point_in_journey_pattern_ref
      -- Let's ensure that vehicle_journey and its timetabled_passing_times reference same journey_pattern_ref
      EVERY(vehicle_journey_journey_pattern_ref_id = stop_point_journey_pattern_ref_id) AS coherent_journey_pattern_refs
    FROM traversal GROUP BY vehicle_journey_id
  ),
  -- Select ids of first and last passing times for journey, according to stop point order.
  first_last_passing_times AS (
    SELECT
      DISTINCT vehicle_journey_id,
      FIRST_VALUE(timetabled_passing_time_id) OVER stop_point_window AS first_passing_time_id,
      LAST_VALUE (timetabled_passing_time_id) OVER stop_point_window AS last_passing_time_id
    FROM passing_time_sequence_combos
    WINDOW stop_point_window AS (
      PARTITION BY vehicle_journey_id ORDER BY stop_point_order ASC
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )
  )
-- Collect the result.
SELECT
  vehicle_journey_id,
  first_passing_time_id,
  last_passing_time_id,
  stop_order_is_valid,
  coherent_journey_pattern_refs
FROM stop_point_order_validity JOIN first_last_passing_times USING (vehicle_journey_id)
$$;
COMMENT ON FUNCTION passing_times.get_passing_time_order_validity_data(filter_vehicle_journey_ids uuid[], filter_journey_pattern_ref_ids uuid[]) IS '
  For vehicle journey passing time sequences in given vehicle journeys and/or journey patterns,
  returns information on the sequence and its validity:
  id of the vehicle journey, ids of first and last passing times in the sequence,
  and whether all passing times for the vehicle journey are in stop point sequence order, that is,
  in same order by passing_time as their corresponding stop points (scheduled_stop_point_in_journey_pattern_ref).';

CREATE OR REPLACE FUNCTION passing_times.passing_times_sequence_already_validated() RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
  passing_times_sequence_already_validated BOOLEAN;
BEGIN
  passing_times_sequence_already_validated := NULLIF(current_setting('passing_times_vars.passing_times_sequence_already_validated', TRUE), '');
  IF passing_times_sequence_already_validated IS TRUE THEN
    RETURN TRUE;
  ELSE
    -- SET LOCAL = only for this transaction. https://www.postgresql.org/docs/current/sql-set.html
    SET LOCAL passing_times_vars.passing_times_sequence_already_validated = TRUE;
    RETURN FALSE;
  END IF;
END
$$;
COMMENT ON FUNCTION passing_times.passing_times_sequence_already_validated()
IS 'Keep track of whether the passing times sequence validation has already been performed in this transaction';

CREATE OR REPLACE FUNCTION passing_times.validate_passing_time_sequences() RETURNS VOID
    LANGUAGE plpgsql
    AS $$
DECLARE
  row_validation_data RECORD;
BEGIN
  -- RAISE NOTICE 'passing_times.validate_passing_time_sequences()';

  -- Retrieve all the vehicle_journey_ids and journey_pattern_ref_ids
  -- from the queues and perform the validation for all included passing times.
  FOR row_validation_data IN (
    WITH filter_vehicle_journey_ids AS (
      SELECT array_agg(DISTINCT vehicle_journey_id) AS ids
      FROM modified_vehicle_journey
    ),
    filter_journey_pattern_ref_ids AS (
      SELECT array_agg(DISTINCT journey_pattern_ref_id) AS ids
      FROM modified_journey_pattern_ref
    )

    SELECT *
    FROM passing_times.get_passing_time_order_validity_data(
      (SELECT ids FROM filter_vehicle_journey_ids),
      (SELECT ids FROM filter_journey_pattern_ref_ids)
    )

    JOIN passing_times.timetabled_passing_time USING (vehicle_journey_id)
  )
  LOOP
    IF (row_validation_data.stop_order_is_valid = false)
    THEN
      RAISE EXCEPTION 'passing times and their matching stop points must be in same order: vehicle_journey_id %, timetabled_passing_time_id %',
        row_validation_data.vehicle_journey_id, row_validation_data.timetabled_passing_time_id;
    END IF;

    IF (
      row_validation_data.timetabled_passing_time_id = row_validation_data.first_passing_time_id
      AND row_validation_data.arrival_time IS NOT NULL
    )
    THEN
      RAISE EXCEPTION 'first passing time must not have arrival_time set: vehicle_journey_id %, timetabled_passing_time_id %',
        row_validation_data.vehicle_journey_id, row_validation_data.timetabled_passing_time_id;
    END IF;

    IF (
      row_validation_data.timetabled_passing_time_id = row_validation_data.last_passing_time_id
      AND row_validation_data.departure_time IS NOT NULL
    )
    THEN
      RAISE EXCEPTION 'last passing time must not have departure_time set: vehicle_journey_id %, timetabled_passing_time_id %',
        row_validation_data.vehicle_journey_id, row_validation_data.timetabled_passing_time_id;
    END IF;

    IF (
      row_validation_data.timetabled_passing_time_id != row_validation_data.first_passing_time_id
      AND
      row_validation_data.timetabled_passing_time_id != row_validation_data.last_passing_time_id
      AND (
        row_validation_data.departure_time IS NULL OR
        row_validation_data.arrival_time IS NULL
      )
    )
    THEN
      RAISE EXCEPTION 'all passing time that are not first or last in the sequence must have both departure and arrival time defined: vehicle_journey_id %, timetabled_passing_time_id %',
        row_validation_data.vehicle_journey_id, row_validation_data.timetabled_passing_time_id;
    END IF;

    IF (row_validation_data.coherent_journey_pattern_refs = false)
    THEN
      RAISE EXCEPTION 'inconsistent journey_pattern_ref within vehicle journey, all timetabled_passing_times must reference same journey_pattern_ref as the vehicle_journey: vehicle_journey_id %',
        row_validation_data.vehicle_journey_id;
    END IF;
  END LOOP;
END;
$$;
COMMENT ON FUNCTION passing_times.validate_passing_time_sequences()
IS 'Perform validation of all passing time sequences that have been added to the temporary queue table.
    Raise an exception if the there are any inconsistencies in passing times and their stop point sequences,
    or if arrival_time or departure_time are not defined properly.';

-- Since there will be lots of rows modified, ROW level triggers would be inefficient.
-- We can't use STATEMENT level triggers for validation because constraint triggers
-- can only be specified FOR EACH ROW, not STATEMENT level.
--
-- Overall the process goes like this, two triggers are involved:
-- 1. queue_validate_passing_times_sequence_on_pt_update_trigger (or insert_trigger: these need to be separate because PostgreSQL doesn't accept INSERT OR UPDATE here)
-- * note that this is NOT DEFERRABLE (default)
-- --> calls queue_validate_passing_times_sequence_by_vehicle_journey_id:
-- * creates queue tables if needed ( passing_times.create_validate_passing_times_sequence_queue_temp_table )
-- * this queues vehicle journeys to be validated by inserting their ids to the queue temp table, no actual validation performed yet.
-- 2. validate_passing_times_sequence_trigger
-- * checked at end of transaction (INITIALLY DEFERRED).
-- * passing_times_sequence_already_validated handles that we only do the validation once, even if trigger is set up to fire FOR EACH ROW
-- --> calls validate_passing_time_sequences
-- * validates all entries previously added to the queue temp table.
--
-- Similar setup exists for scheduled_stop_point_in_journey_pattern_ref tables.

DROP TRIGGER IF EXISTS queue_validate_passing_times_sequence_on_pt_update_trigger ON passing_times.timetabled_passing_time;
CREATE TRIGGER queue_validate_passing_times_sequence_on_pt_update_trigger
  AFTER UPDATE ON passing_times.timetabled_passing_time
  REFERENCING NEW TABLE AS new_table
  FOR EACH STATEMENT
  EXECUTE FUNCTION vehicle_journey.queue_validation_by_vj_id();
COMMENT ON TRIGGER queue_validate_passing_times_sequence_on_pt_update_trigger ON passing_times.timetabled_passing_time
IS 'Trigger to queue validation of passing times <-> stop point sequences on update.
    Actual validation is triggered later by deferred validate_passing_times_sequence_trigger() trigger';

DROP TRIGGER IF EXISTS queue_validate_passing_times_sequence_on_pt_insert_trigger ON passing_times.timetabled_passing_time;
CREATE TRIGGER queue_validate_passing_times_sequence_on_pt_insert_trigger
  AFTER INSERT ON passing_times.timetabled_passing_time
  REFERENCING NEW TABLE AS new_table
  FOR EACH STATEMENT
  EXECUTE FUNCTION vehicle_journey.queue_validation_by_vj_id();
COMMENT ON TRIGGER queue_validate_passing_times_sequence_on_pt_insert_trigger ON passing_times.timetabled_passing_time
IS 'Trigger to queue validation of passing times <-> stop point sequences on insert.
    Actual validation is triggered later by deferred validate_passing_times_sequence_trigger() trigger';

DROP TRIGGER IF EXISTS queue_validate_passing_times_sequence_on_pt_delete_trigger ON passing_times.timetabled_passing_time;
CREATE TRIGGER queue_validate_passing_times_sequence_on_pt_delete_trigger
  AFTER DELETE ON passing_times.timetabled_passing_time
  REFERENCING OLD TABLE AS new_table -- FIXME! "old is new"
  FOR EACH STATEMENT
  EXECUTE FUNCTION vehicle_journey.queue_validation_by_vj_id();
COMMENT ON TRIGGER queue_validate_passing_times_sequence_on_pt_delete_trigger ON passing_times.timetabled_passing_time
IS 'Trigger to queue validation of passing times <-> stop point sequences on delete.
    Actual validation is triggered later by deferred validate_passing_times_sequence_trigger() trigger';

DROP TRIGGER IF EXISTS validate_passing_times_sequence_trigger ON passing_times.timetabled_passing_time;
CREATE CONSTRAINT TRIGGER validate_passing_times_sequence_trigger
  AFTER UPDATE OR INSERT OR DELETE ON passing_times.timetabled_passing_time
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
  WHEN (NOT passing_times.passing_times_sequence_already_validated())
  EXECUTE FUNCTION internal_utils.execute_queued_validations();
COMMENT ON TRIGGER validate_passing_times_sequence_trigger ON passing_times.timetabled_passing_time
IS 'Trigger to validate the passing time <-> stop point sequence after modifications on the passing time table.
    This trigger will cause those vehicle journeys to be checked, whose ID was queued to be checked by a statement level trigger.';

DROP TRIGGER IF EXISTS queue_validate_passing_times_sequence_on_ssp_update_trigger ON service_pattern.scheduled_stop_point_in_journey_pattern_ref;
CREATE TRIGGER queue_validate_passing_times_sequence_on_ssp_update_trigger
  AFTER UPDATE ON service_pattern.scheduled_stop_point_in_journey_pattern_ref
  REFERENCING NEW TABLE AS new_table
  FOR EACH STATEMENT
  EXECUTE FUNCTION journey_pattern.queue_validation_by_jpr_id();
COMMENT ON TRIGGER queue_validate_passing_times_sequence_on_ssp_update_trigger ON service_pattern.scheduled_stop_point_in_journey_pattern_ref
IS 'Trigger to queue validation of passing times <-> stop point sequences on stop point update.
    Actual validation is triggered later by deferred validate_passing_times_sequence_trigger() trigger';

DROP TRIGGER IF EXISTS queue_validate_passing_times_sequence_on_ssp_insert_trigger ON service_pattern.scheduled_stop_point_in_journey_pattern_ref;
CREATE TRIGGER queue_validate_passing_times_sequence_on_ssp_insert_trigger
  AFTER INSERT ON service_pattern.scheduled_stop_point_in_journey_pattern_ref
  REFERENCING NEW TABLE AS new_table
  FOR EACH STATEMENT
  EXECUTE FUNCTION journey_pattern.queue_validation_by_jpr_id();
COMMENT ON TRIGGER queue_validate_passing_times_sequence_on_ssp_insert_trigger ON service_pattern.scheduled_stop_point_in_journey_pattern_ref
IS 'Trigger to queue validation of passing times <-> stop point sequences on stop point insert.
    Actual validation is triggered later by deferred validate_passing_times_sequence_trigger() trigger';

DROP TRIGGER IF EXISTS validate_passing_times_sequence_trigger ON service_pattern.scheduled_stop_point_in_journey_pattern_ref;
CREATE CONSTRAINT TRIGGER validate_passing_times_sequence_trigger
  AFTER UPDATE OR INSERT ON service_pattern.scheduled_stop_point_in_journey_pattern_ref
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
  WHEN (NOT passing_times.passing_times_sequence_already_validated())
  EXECUTE FUNCTION internal_utils.execute_queued_validations();
COMMENT ON TRIGGER validate_passing_times_sequence_trigger ON service_pattern.scheduled_stop_point_in_journey_pattern_ref
IS 'Trigger to validate the passing time <-> stop point sequence after modifications on the passing time table.
    This trigger will cause those vehicle journeys to be checked, whose ID was queued to be checked by a statement level trigger.';
