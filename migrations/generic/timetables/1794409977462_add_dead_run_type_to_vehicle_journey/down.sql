DROP INDEX vehicle_journey.idx_vehicle_journey_dead_run_type;

ALTER TABLE vehicle_journey.vehicle_journey
  DROP COLUMN dead_run_type;

DROP TABLE vehicle_journey.dead_run_type;
