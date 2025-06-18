-- 
-- Day of week reference must be in ISO range (1-7).
-- 
ALTER TABLE service_calendar.substitute_operating_day_by_line_type
  ADD CONSTRAINT substitute_operating_day_by_line_type_valid_dow
  CHECK (substitute_day_of_week BETWEEN 1 AND 7);

-- 
-- The begin time must be within the time limits of the operating day.
-- 
ALTER TABLE service_calendar.substitute_operating_day_by_line_type
  ADD CONSTRAINT substitute_operating_day_by_line_type_valid_begin_time
  CHECK (
    begin_time >= service_calendar.const_operating_day_start_time()
      AND begin_time < coalesce(end_time, service_calendar.const_operating_day_end_time())
  );

-- 
-- The end time must be within the time limits of the operating day.
-- 
ALTER TABLE service_calendar.substitute_operating_day_by_line_type
  ADD CONSTRAINT substitute_operating_day_by_line_type_valid_end_time
  CHECK (
    end_time > coalesce(begin_time, service_calendar.const_operating_day_start_time())
      AND end_time <= service_calendar.const_operating_day_end_time()
  );

-- 
-- Ensure non-overlapping time ranges for a given line type.
-- 
-- Since currently "no traffic" restrictions cannot overlap with the time spans
-- of reference days, it is safe not to filter by type of substitute operating
-- day in this constraint.
-- 
ALTER TABLE service_calendar.substitute_operating_day_by_line_type
  ADD CONSTRAINT substitute_operating_day_by_line_type_no_timespan_overlap
  EXCLUDE USING gist (
    type_of_line WITH =,
    tstzrange(begin_datetime, end_datetime) WITH &&
  );

-- 
-- Allow only one type of substitute operating day definition (either reference
-- day or no traffic) to exist for a given line type and superseded date. That
-- is, all rows with the same line type and superseded date must have either
-- NULL or non-NULL value in substitute_day_of_week column. NULL
-- substitute_day_of_week is converted to zero in order to have no traffic
-- case conflict with reference day cases for same date.
-- 
-- In addition, do not allow multiple day of week references for a given line
-- type and superseded date. However, it is allowed to have multiple time
-- periods for a single day of week reference as long as these time periods do
-- not overlap.
-- 
ALTER TABLE service_calendar.substitute_operating_day_by_line_type
  ADD CONSTRAINT substitute_operating_day_by_line_type_unique_dow
  EXCLUDE USING gist (
    type_of_line WITH =,
    superseded_date WITH =,
    coalesce(substitute_day_of_week, 0) WITH <>
  );
