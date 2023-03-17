CREATE OR REPLACE FUNCTION internal_utils.execute_queued_validations() RETURNS trigger
  LANGUAGE plpgsql
AS $$
BEGIN
  RAISE LOG 'internal_utils.execute_queued_validations() started';

  RAISE LOG 'before vehicle_service.execute_queued_journey_patterns_in_vehicle_service_refresh_once()';
  PERFORM vehicle_service.execute_queued_journey_patterns_in_vehicle_service_refresh_once();

  RAISE LOG 'before vehicle_schedule.validate_queued_schedules_uniqueness()';
  PERFORM vehicle_schedule.validate_queued_schedules_uniqueness();

  RAISE LOG 'internal_utils.execute_queued_validations() finished';

  RETURN NULL;
END;
$$;
COMMENT ON FUNCTION internal_utils.execute_queued_validations()
IS 'Queue modified vehicle schedule frames for validation which is performed at the end of transaction.';
