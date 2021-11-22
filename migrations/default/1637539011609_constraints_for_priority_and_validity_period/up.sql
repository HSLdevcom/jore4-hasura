
ALTER TABLE internal_service_pattern.scheduled_stop_point
ADD CONSTRAINT unique_validity_period EXCLUDE USING GIST (
  label WITH =,
  priority WITH =,
  TSTZRANGE(validity_start, validity_end) WITH &&
);

ALTER TABLE internal_route.route
ADD CONSTRAINT unique_validity_period EXCLUDE USING GIST (
  label WITH =,
  direction WITH =,
  priority WITH =,
  TSTZRANGE(validity_start, validity_end) WITH &&
);

ALTER TABLE route.line
ADD CONSTRAINT unique_validity_period EXCLUDE USING GIST (
  label WITH =,
  priority WITH =,
  TSTZRANGE(validity_start, validity_end) WITH &&
);
