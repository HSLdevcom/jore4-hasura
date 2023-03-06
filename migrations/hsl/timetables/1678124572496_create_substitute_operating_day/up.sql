CREATE TABLE service_calendar.substitute_operating_day_by_line_type (
  substitute_operating_day_by_line_type_id  uuid DEFAULT gen_random_uuid(),
  type_of_line                              text NOT NULL,
  superseded_date                           date NOT NULL,
  substitute_day_of_week                    integer,
  begin_time                                interval,
  end_time                                  interval,
  timezone                                  text NOT NULL DEFAULT internal_utils.default_timezone(),
  begin_datetime                            timestamp with time zone GENERATED ALWAYS AS (timezone(timezone, coalesce(begin_time, service_calendar.operating_day_start_time()) + superseded_date)) STORED NOT NULL,
  end_datetime                              timestamp with time zone GENERATED ALWAYS AS (timezone(timezone, coalesce(end_time,   service_calendar.operating_day_end_time())   + superseded_date)) STORED NOT NULL
);

ALTER TABLE ONLY service_calendar.substitute_operating_day_by_line_type
  ADD CONSTRAINT substitute_operating_day_by_line_type_pkey
  PRIMARY KEY (substitute_operating_day_by_line_type_id);

ALTER TABLE ONLY service_calendar.substitute_operating_day_by_line_type
  ADD CONSTRAINT substitute_operating_day_by_line_type_type_of_line_fkey
  FOREIGN KEY (type_of_line) REFERENCES route.type_of_line(type_of_line);

COMMENT ON TABLE service_calendar.substitute_operating_day_by_line_type IS
  'Models substitute public transit as (1) a reference day or (2) indicating that public transit does not occur on certain date. Substitute operating days are always bound to a type of line.';
COMMENT ON COLUMN service_calendar.substitute_operating_day_by_line_type.type_of_line IS 'The type of line this substitute operating day is bound to.';
COMMENT ON COLUMN service_calendar.substitute_operating_day_by_line_type.superseded_date IS 'The date of operating day being superseded.';
COMMENT ON COLUMN service_calendar.substitute_operating_day_by_line_type.substitute_day_of_week IS
  'The ISO day of week (1=Monday, ... , 7=Sunday) of the day type used as the basis for operating day substitution. A NULL value indicates that there is no public transit at all, i.e. no vehicle journeys are operated within the given time period.';
COMMENT ON COLUMN service_calendar.substitute_operating_day_by_line_type.begin_time IS
  'The time from which the substituting public transit comes into effect. If NULL, the substitution is in effect from the start of the operating day. When substitute_day_of_week is not NULL (reference day case), vehicle journeys prior to this time are not operated. When substitute_day_of_week is NULL (no traffic case), the vehicle journeys before this time are operated as usual.';
COMMENT ON COLUMN service_calendar.substitute_operating_day_by_line_type.end_time IS
  'The time (exclusive) until which the substituting public transit is valid. If NULL, the substitution is in effect until the end of the operating day. When substitute_day_of_week is not NULL (reference day case), vehicle journeys starting from this time are not operated. When substitute_day_of_week is NULL (no traffic case), the vehicle journeys starting from this time are operated as usual.';
COMMENT ON COLUMN service_calendar.substitute_operating_day_by_line_type.begin_datetime IS 'Calculated timestamp for the instant from which the substituting public transit comes into effect.';
COMMENT ON COLUMN service_calendar.substitute_operating_day_by_line_type.end_datetime IS 'Calculated timestamp for the instant (exclusive) until which the substituting public transit is in effect.';
