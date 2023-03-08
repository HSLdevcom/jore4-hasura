-------------------- Route --------------------

CREATE TABLE route.type_of_line (
    type_of_line text NOT NULL
);
COMMENT ON TABLE route.type_of_line IS 'Type of line. https://www.transmodel-cen.eu/model/index.htm?goto=2:1:3:424';
COMMENT ON COLUMN route.type_of_line.type_of_line IS 'GTFS route type: https://developers.google.com/transit/gtfs/reference/extended-route-types';

ALTER TABLE ONLY route.type_of_line
  ADD CONSTRAINT type_of_line_pkey PRIMARY KEY (type_of_line);

INSERT INTO route.type_of_line
  (type_of_line)
  VALUES
  ('regional_rail_service'),
  ('suburban_railway'),
  ('metro_service'),
  ('regional_bus_service'),
  ('express_bus_service'),
  ('stopping_bus_service'),
  ('special_needs_bus'),
  ('demand_and_response_bus_service'),
  ('city_tram_service'),
  ('regional_tram_service'),
  ('ferry_service')
  ON CONFLICT (type_of_line) DO NOTHING;

-------------------- Journey Pattern --------------------

ALTER TABLE ONLY journey_pattern.journey_pattern_ref
  ADD COLUMN type_of_line text NOT NULL REFERENCES route.type_of_line (type_of_line);

COMMENT ON COLUMN journey_pattern.journey_pattern_ref.type_of_line IS 'The type of line (GTFS route type): https://developers.google.com/transit/gtfs/reference/extended-route-types';

CREATE INDEX journey_pattern_ref_type_of_line
  ON journey_pattern.journey_pattern_ref USING btree (type_of_line);

-------------------- Service Calendar --------------------

CREATE TABLE service_calendar.substitute_operating_day_by_line_type (
  substitute_operating_day_by_line_type_id  uuid DEFAULT gen_random_uuid(),
  type_of_line                              text NOT NULL,
  superseded_date                           date NOT NULL,
  substitute_day_of_week                    integer,
  begin_time                                interval,
  end_time                                  interval,
  timezone                                  text NOT NULL DEFAULT internal_utils.const_default_timezone(),
  begin_datetime                            timestamp with time zone GENERATED ALWAYS AS (timezone(timezone, coalesce(begin_time, service_calendar.const_operating_day_start_time()) + superseded_date)) STORED NOT NULL,
  end_datetime                              timestamp with time zone GENERATED ALWAYS AS (timezone(timezone, coalesce(end_time,   service_calendar.const_operating_day_end_time())   + superseded_date)) STORED NOT NULL
);

ALTER TABLE ONLY service_calendar.substitute_operating_day_by_line_type
  ADD CONSTRAINT substitute_operating_day_by_line_type_pkey
  PRIMARY KEY (substitute_operating_day_by_line_type_id);

ALTER TABLE ONLY service_calendar.substitute_operating_day_by_line_type
  ADD CONSTRAINT substitute_operating_day_by_line_type_type_of_line_fkey
  FOREIGN KEY (type_of_line) REFERENCES route.type_of_line(type_of_line);

CREATE INDEX substitute_operating_day_by_line_type_type_of_line
  ON service_calendar.substitute_operating_day_by_line_type USING btree (type_of_line);

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
