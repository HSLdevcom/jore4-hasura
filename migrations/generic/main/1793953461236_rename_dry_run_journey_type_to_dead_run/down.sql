UPDATE timetables.vehicle_journey
  SET journey_type = 'DRY_RUN'
  WHERE journey_type = 'DEAD_RUN';

DELETE FROM timetables.journey_type
  WHERE type = 'DEAD_RUN';

COMMENT ON COLUMN timetables.vehicle_journey.journey_type IS 'STANDARD | DRY_RUN | SERVICE_JOURNEY';
