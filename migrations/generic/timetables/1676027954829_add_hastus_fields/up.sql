ALTER TABLE vehicle_service.block
  ADD COLUMN preparing_duration interval,
  ADD COLUMN finishing_duration interval,
  ADD COLUMN vehicle_type smallint;

COMMENT ON COLUMN vehicle_service.block.preparing_duration IS 'Preparation time before start of vehicle service block.';
COMMENT ON COLUMN vehicle_service.block.finishing_duration IS 'Finishing time after end of vehicle service block.';
COMMENT ON COLUMN vehicle_service.block.vehicle_type IS 'Vehicle type.';


ALTER TABLE vehicle_journey.vehicle_journey
  ADD COLUMN journey_name_i18n jsonb;

COMMENT ON COLUMN vehicle_journey.vehicle_journey.journey_name_i18n IS 'Name that user can give to the vehicle journey.';


ALTER TABLE vehicle_service.vehicle_service
  ADD COLUMN name_i18n jsonb;

COMMENT ON COLUMN vehicle_service.vehicle_service.name_i18n IS 'Name for vehicle service.';
