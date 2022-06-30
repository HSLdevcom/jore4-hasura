

ALTER TABLE internal_service_pattern.scheduled_stop_point
DROP CONSTRAINT unique_validity_period;

ALTER TABLE internal_service_pattern.scheduled_stop_point
ADD CONSTRAINT unique_validity_period EXCLUDE USING GIST (
  label WITH =,
  priority WITH =,
  TSTZRANGE(validity_start, validity_end) WITH &&
)
WHERE (priority < internal_utils.const_priority_draft());

ALTER TABLE route.route
DROP CONSTRAINT route_unique_validity_period;

ALTER TABLE route.route
ADD CONSTRAINT route_unique_validity_period EXCLUDE USING GIST (
  label WITH =,
  direction WITH =,
  priority WITH =,
  TSTZRANGE(validity_start, validity_end) WITH &&
)
WHERE (priority < internal_utils.const_priority_draft());

ALTER TABLE route.line
DROP CONSTRAINT line_unique_validity_period;

ALTER TABLE route.line
ADD CONSTRAINT line_unique_validity_period EXCLUDE USING GIST (
  label WITH =,
  priority WITH =,
  TSTZRANGE(validity_start, validity_end) WITH &&
)
WHERE (priority < internal_utils.const_priority_draft());