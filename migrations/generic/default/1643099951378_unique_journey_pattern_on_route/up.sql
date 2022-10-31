-- This change can later be undone when the UI supports multiple journey patterns under the same route.

-- In order to do so, add a new migration containing this migration's up.sql and
-- down.sql with swapped content (rename up.sql to down.sql and vice versa).

DROP INDEX journey_pattern.journey_pattern_on_route_id_idx;

CREATE UNIQUE INDEX journey_pattern_on_route_id_idx ON journey_pattern.journey_pattern (on_route_id);
