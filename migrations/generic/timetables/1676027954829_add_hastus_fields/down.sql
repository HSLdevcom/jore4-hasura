ALTER TABLE vehicle_service.block
  DROP COLUMN start_timing_place,
  DROP COLUMN end_timing_place,
  DROP COLUMN preparing_duration,
  DROP COLUMN finishing_duration,
  DROP COLUMN vehicle_type;

ALTER TABLE vehicle_journey.vehicle_journey
  DROP COLUMN journey_name;

ALTER TABLE vehicle_service.vehicle_service
  DROP COLUMN name_i18n;
