ALTER TABLE vehicle_service.block
  DROP COLUMN preparing_duration,
  DROP COLUMN finishing_duration,
  DROP COLUMN vehicle_type;

ALTER TABLE vehicle_journey.vehicle_journey
  DROP COLUMN journey_name_i18n;

ALTER TABLE vehicle_service.vehicle_service
  DROP COLUMN name_i18n;
