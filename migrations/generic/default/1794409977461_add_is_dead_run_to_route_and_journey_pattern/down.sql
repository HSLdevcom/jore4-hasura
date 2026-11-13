DROP INDEX journey_pattern.idx_journey_pattern_is_dead_run;

ALTER TABLE journey_pattern.journey_pattern
  DROP COLUMN is_dead_run;

DROP INDEX route.idx_route_is_dead_run;

ALTER TABLE route.route
  DROP COLUMN is_dead_run;
