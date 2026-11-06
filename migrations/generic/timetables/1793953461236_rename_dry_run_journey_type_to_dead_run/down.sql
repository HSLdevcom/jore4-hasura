UPDATE vehicle_journey.vehicle_journey
  SET journey_type = 'DRY_RUN'
  WHERE journey_type = 'DEAD_RUN';

DELETE FROM vehicle_journey.journey_type
  WHERE type = 'DEAD_RUN';

COMMENT ON COLUMN vehicle_journey.vehicle_journey.journey_type IS 'STANDARD | DRY_RUN | SERVICE_JOURNEY';
