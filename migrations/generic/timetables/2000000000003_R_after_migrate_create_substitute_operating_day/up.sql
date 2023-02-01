-- 
-- Reference date and "no traffic" (boolean flag enabled) are mutually
-- exclusive.
-- 
ALTER TABLE service_calendar.substitute_operating_day
  ADD CONSTRAINT substitute_operating_day_reference_date_nullability
  CHECK (
    (no_traffic AND reference_date IS NULL)
    OR (NOT no_traffic AND reference_date IS NOT NULL)
  );

-- 
-- The begin time must be within the time limits of the operating day.
-- 
ALTER TABLE service_calendar.substitute_operating_day
  ADD CONSTRAINT substitute_operating_day_valid_begin_time
  CHECK (
    begin_time >= service_calendar.operating_day_start_time()
      AND begin_time < coalesce(end_time, service_calendar.operating_day_end_time())
  );

-- 
-- The end time must be within the time limits of the operating day.
-- 
ALTER TABLE service_calendar.substitute_operating_day
  ADD CONSTRAINT substitute_operating_day_valid_end_time
  CHECK (
    end_time > coalesce(begin_time, service_calendar.operating_day_start_time())
      AND end_time <= service_calendar.operating_day_end_time()
  );

-- 
-- Block overlapping time ranges for a given line type.
-- 
-- Since currently "no traffic" restrictions cannot overlap with the time spans
-- of reference days, it is safe not to filter by type of substitute operating
-- day in this constraint.
-- 
ALTER TABLE service_calendar.substitute_operating_day
  ADD CONSTRAINT substitute_operating_day_no_timespan_overlap
  EXCLUDE USING gist (
    type_of_line WITH =,
    tstzrange(begin_datetime, end_datetime) WITH &&
  );

-- 
-- Allow only one type of substitute operating day definition (either reference
-- day or no traffic) to exist for a given line type and superseded date. That
-- is, all rows with the same line type and superseded date must share the same
-- boolean value for the no_traffic column.
--
-- A cast is done to make the GiST index work with a boolean element.
-- 
ALTER TABLE service_calendar.substitute_operating_day
  ADD CONSTRAINT substitute_operating_day_type_exclusion
  EXCLUDE USING gist (
    type_of_line WITH =,
    superseded_date WITH =,
    (no_traffic::int) WITH <>
  );
