ALTER TABLE route.route
  ADD COLUMN is_dead_run boolean DEFAULT false NOT NULL;
CREATE INDEX idx_route_is_dead_run ON route.route USING btree (is_dead_run);

ALTER TABLE journey_pattern.journey_pattern
  ADD COLUMN is_dead_run boolean DEFAULT false NOT NULL;
CREATE INDEX idx_journey_pattern_is_dead_run ON journey_pattern.journey_pattern USING btree (is_dead_run);
