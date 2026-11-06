-- Rename the DRY_RUN journey type to DEAD_RUN.
--
-- DRY_RUN is intentionally left in the enum table so that clients that have not
-- been updated yet can still write it. Such writes are normalized to DEAD_RUN by
-- the normalize_deprecated_journey_type_trigger trigger, which is (re)created in
-- the repeatable migration 2000000000102_R_after_migrate_create_vehicle_journey.

INSERT INTO timetables.journey_type
  (type)
  VALUES
  ('DEAD_RUN')
  ON CONFLICT (type) DO NOTHING;

UPDATE timetables.vehicle_journey
  SET journey_type = 'DEAD_RUN'
  WHERE journey_type = 'DRY_RUN';

COMMENT ON COLUMN timetables.vehicle_journey.journey_type IS 'STANDARD | DEAD_RUN | SERVICE_JOURNEY';
