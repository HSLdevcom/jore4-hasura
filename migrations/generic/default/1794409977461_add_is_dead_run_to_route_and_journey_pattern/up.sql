ALTER TABLE route.route
  ADD COLUMN is_dead_run boolean DEFAULT false NOT NULL;

ALTER TABLE journey_pattern.journey_pattern
  ADD COLUMN is_dead_run boolean DEFAULT false NOT NULL;
