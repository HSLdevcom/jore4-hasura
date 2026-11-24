CREATE OR REPLACE FUNCTION internal_utils.execute_queued_validations() RETURNS trigger
  LANGUAGE plpgsql
AS $$
BEGIN
  -- RAISE LOG 'internal_utils.execute_queued_validations() started';

  -- In case this is called without creating the tables.
  -- At least for refresh_journey_patterns_in_vehicle_service there is such case (vehicle_journey delete)
  PERFORM internal_utils.create_validation_queue_temp_tables();

  -- RAISE LOG 'before timetables.refresh_journey_patterns_in_vehicle_service()';
  PERFORM timetables.refresh_journey_patterns_in_vehicle_service();

  -- RAISE LOG 'before timetables.validate_queued_schedules_uniqueness()';
  PERFORM timetables.validate_queued_schedules_uniqueness();

  -- RAISE LOG 'before timetables.validate_passing_time_sequences()';
  PERFORM timetables.validate_passing_time_sequences();

  -- RAISE LOG 'before timetables.validate_service_sequential_integrity()';
  PERFORM timetables.validate_service_sequential_integrity();

  -- RAISE LOG 'internal_utils.execute_queued_validations() finished';

  RETURN NULL;
END;
$$;
COMMENT ON FUNCTION internal_utils.execute_queued_validations()
IS 'Runs all queued validations. This is intended to be ran only once per transaction (see queued_validations_already_processed).';
