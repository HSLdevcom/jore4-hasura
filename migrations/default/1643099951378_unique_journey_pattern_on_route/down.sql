
DROP INDEX journey_pattern.journey_pattern_on_route_id_idx;

CREATE INDEX journey_pattern_on_route_id_idx ON journey_pattern.journey_pattern (on_route_id);
