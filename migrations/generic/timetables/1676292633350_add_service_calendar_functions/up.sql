CREATE OR REPLACE FUNCTION service_calendar.const_operating_day_start_time()
  RETURNS interval
  IMMUTABLE
  PARALLEL SAFE
  LANGUAGE sql AS
$$
SELECT interval '04:30:00'
$$;

COMMENT ON FUNCTION service_calendar.const_operating_day_start_time()
  IS 'Get the (inclusive) start time of operating day.';


CREATE OR REPLACE FUNCTION service_calendar.const_operating_day_end_time()
  RETURNS interval
  IMMUTABLE
  PARALLEL SAFE
  LANGUAGE sql AS
$$
SELECT interval '28:30:00'
$$;

COMMENT ON FUNCTION service_calendar.const_operating_day_end_time()
  IS 'Get the (exclusive) end time of operating day.';


CREATE OR REPLACE FUNCTION internal_utils.const_default_timezone()
  RETURNS text
  IMMUTABLE
  PARALLEL SAFE
  LANGUAGE sql AS
$$
SELECT 'Europe/Helsinki'
$$;

COMMENT ON FUNCTION internal_utils.const_default_timezone()
  IS 'Get the default timezone of service calendar.';
