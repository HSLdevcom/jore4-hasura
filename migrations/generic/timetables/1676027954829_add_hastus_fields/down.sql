ALTER TABLE vehicle_journey.vehicle_journey
  DROP COLUMN journey_name_i18n,
  DROP COLUMN turnaround_time,
  DROP COLUMN layover_time,
  DROP COLUMN journey_type;

ALTER TABLE vehicle_service.block
  DROP COLUMN preparing_time,
  DROP COLUMN finishing_time,
  DROP COLUMN vehicle_type;

DROP TABLE reusable_components.vehicle_type;

DROP SCHEMA reusable_components;

ALTER TABLE vehicle_service.vehicle_service
  DROP COLUMN name_i18n;

ALTER TABLE vehicle_schedule.vehicle_schedule_frame
  ALTER COLUMN name_i18n SET NOT NULL,
  DROP COLUMN label;

DROP TABLE vehicle_journey.journey_type;
