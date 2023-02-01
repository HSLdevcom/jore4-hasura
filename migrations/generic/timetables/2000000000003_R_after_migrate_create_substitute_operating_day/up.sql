-- Reference date and "no traffic" are mutually exclusive. One must be selected.
ALTER TABLE service_calendar.substitute_operating_day
  ADD CONSTRAINT substitute_operating_day_is_no_traffic_valid
  CHECK (
    (no_traffic = true AND reference_date IS NULL)
    OR (no_traffic = false AND reference_date IS NOT NULL)
  );

-- Do not allow overlapping time ranges for a pair consisting of
-- type-of-line and superseded date.
ALTER TABLE service_calendar.substitute_operating_day
  ADD CONSTRAINT substitute_operating_day_no_timespan_overlap
  EXCLUDE USING gist (
    type_of_line WITH =,
    superseded_date WITH=,
    tsrange(begin_datetime, end_datetime, '[]') WITH &&
  );
