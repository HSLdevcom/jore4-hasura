-------------------- Route --------------------

CREATE TABLE route.type_of_line (
    type_of_line text NOT NULL
);
COMMENT ON TABLE route.type_of_line IS 'Type of line. https://www.transmodel-cen.eu/model/EARoot/EA2/EA1/EA3/EA491.htm';
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
  ADD COLUMN type_of_line text REFERENCES route.type_of_line (type_of_line);

COMMENT ON COLUMN journey_pattern.journey_pattern_ref.type_of_line IS 'The type of line (GTFS route type): https://developers.google.com/transit/gtfs/reference/extended-route-types';

CREATE INDEX journey_pattern_ref_type_of_line ON journey_pattern.journey_pattern_ref USING btree (type_of_line);

-------------------- Service Calendar --------------------

CREATE TABLE service_calendar.substitute_operating_day (
  substitute_operating_day_id  uuid DEFAULT gen_random_uuid(),
  type_of_line                 text NOT NULL,
  superseded_date              date NOT NULL,
  no_traffic                   boolean NOT NULL,
  reference_date               date,
  begin_time                   interval,
  end_time                     interval,
  timezone                     text NOT NULL DEFAULT service_calendar.default_timezone(),
  begin_datetime               timestamp with time zone GENERATED ALWAYS AS (timezone(timezone, coalesce(begin_time, service_calendar.operating_day_start_time()) + superseded_date)) STORED NOT NULL,
  end_datetime                 timestamp with time zone GENERATED ALWAYS AS (timezone(timezone, coalesce(end_time,   service_calendar.operating_day_end_time())   + superseded_date)) STORED NOT NULL
);

ALTER TABLE ONLY service_calendar.substitute_operating_day
  ADD CONSTRAINT substitute_operating_day_pkey PRIMARY KEY (substitute_operating_day_id);

ALTER TABLE ONLY service_calendar.substitute_operating_day
  ADD CONSTRAINT substitute_operating_day_type_of_line_fkey FOREIGN KEY (type_of_line) REFERENCES route.type_of_line(type_of_line);

COMMENT ON TABLE service_calendar.substitute_operating_day IS
  'Models substitute public transit with (1) date references or (2) indicating that public transit does not occur on certain date. Substitute operating days are always bound to a type of line.';
COMMENT ON COLUMN service_calendar.substitute_operating_day.type_of_line IS 'The type of line this substitute operating day is bound to.';
COMMENT ON COLUMN service_calendar.substitute_operating_day.superseded_date IS 'The date of operating day being superseded.';
COMMENT ON COLUMN service_calendar.substitute_operating_day.no_traffic IS 'Indicates whether there is public transit at all. If true, the no-traffic restriction is in effect and the vehicle journeys within the given time period are not operated. If it is false, the vehicle journeys within the given time period on the reference day are operated and the vehicle journeys outside of that period will not be operated.';
COMMENT ON COLUMN service_calendar.substitute_operating_day.reference_date IS 'The date of the reference day used as the basis for operating day substitution. Must be left NULL if no traffic restriction is desired.';
COMMENT ON COLUMN service_calendar.substitute_operating_day.begin_time IS 'The time from which the substituting public transit comes into effect. If null, the substitution is in effect from the start of the operating day. When no_traffic=false (and a reference date is given), vehicle journeys prior to this time are not operated. When no_traffic=true, the vehicle journeys before this time are operated as usual.';
COMMENT ON COLUMN service_calendar.substitute_operating_day.end_time IS 'The time (exclusive) until which the substituting public transit is valid. If null, the substitution is in effect until the end of the operating day. When no_traffic=false (and a reference date is given), vehicle journeys starting from this time are not operated. When no_traffic=true, the vehicle journeys starting from this time are operated as usual.';
COMMENT ON COLUMN service_calendar.substitute_operating_day.begin_datetime IS 'Calculated timestamp for the instant from which the substituting public transit comes into effect.';
COMMENT ON COLUMN service_calendar.substitute_operating_day.end_datetime IS 'Calculated timestamp for the instant (exclusive) until which the substituting public transit is in effect.';

-- Do not allow multiple reference day definitions for a given line type and
-- superseded date. Implemented with a partial unique index.
-- 
-- Consecutive vehicle journeys in a vehicle service block may belong to
-- different lines. The blocks planned in Hastus (and the associated vehicle
-- journeys) may not work together if you abruptly switch from a block to
-- another block of a different day at a certain time.
CREATE UNIQUE INDEX substitute_operating_day_uniqueness
  ON service_calendar.substitute_operating_day
  USING btree (type_of_line, superseded_date)
  WHERE reference_date IS NOT NULL;
