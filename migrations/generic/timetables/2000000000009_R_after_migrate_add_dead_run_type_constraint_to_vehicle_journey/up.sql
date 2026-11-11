ALTER TABLE vehicle_journey.vehicle_journey
  ADD CONSTRAINT check_dead_run_type_consistency CHECK (
    (journey_type = 'DEAD_RUN' AND dead_run_type IS NOT NULL) OR
    (journey_type != 'DEAD_RUN' AND dead_run_type IS NULL));
