ALTER TABLE vehicle_service.block
  ADD COLUMN start_timing_place text,
  ADD COLUMN end_timing_place text,
  ADD COLUMN preparing_duration smallint,
  ADD COLUMN finishing_duration smallint,
  ADD COLUMN vehicle_type smallint;

COMMENT ON COLUMN vehicle_service.block.start_timing_place IS 'Timing place on the beginning of the route.';
COMMENT ON COLUMN vehicle_service.block.end_timing_place IS 'Timing place on the end of the route';
COMMENT ON COLUMN vehicle_service.block.preparing_duration IS 'Preparation time before start.';
COMMENT ON COLUMN vehicle_service.block.finishing_duration IS 'Finishing time after end.';
COMMENT ON COLUMN vehicle_service.block.vehicle_type IS 'Vehicle type.';


ALTER TABLE vehicle_journey.vehicle_journey
  ADD COLUMN journey_name text;

COMMENT ON COLUMN vehicle_journey.vehicle_journey.journey_name IS 'Journey name.';


ALTER TABLE vehicle_service.vehicle_service
  ADD COLUMN name_i18n jsonb;

COMMENT ON COLUMN vehicle_service.vehicle_service.name_i18n IS 'Name for vehicle service.';
