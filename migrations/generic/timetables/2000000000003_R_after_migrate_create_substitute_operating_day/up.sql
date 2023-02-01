ALTER TABLE service_calendar.substitute_operating_day
  ADD CONSTRAINT substitute_operating_day_is_no_traffic_valid
  CHECK (
    (no_traffic = true AND reference_date IS NULL)
    OR (no_traffic = false AND reference_date IS NOT NULL)
  );

ALTER TABLE service_calendar.substitute_operating_day
  ADD CONSTRAINT substitute_operating_day_no_timespan_overlap
  EXCLUDE USING gist (
    type_of_line WITH =,
    affected_date WITH=,
    tsrange(begin_datetime, end_datetime, '[]') WITH &&
  );
