
ALTER TABLE route.line
DROP CONSTRAINT unique_validity_period;

ALTER TABLE internal_route.route
DROP CONSTRAINT unique_validity_period;

ALTER TABLE internal_service_pattern.scheduled_stop_point
DROP CONSTRAINT unique_validity_period;
