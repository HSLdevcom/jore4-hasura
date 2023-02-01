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

CREATE TABLE route.line_ref (
  line_ref_id uuid DEFAULT gen_random_uuid(),
  label text NOT NULL,
  type_of_line text NOT NULL
);

ALTER TABLE ONLY route.line_ref
  ADD CONSTRAINT line_ref_pkey PRIMARY KEY (line_ref_id);
ALTER TABLE ONLY route.line_ref
  ADD CONSTRAINT line_ref_type_of_line_fkey FOREIGN KEY (type_of_line) REFERENCES route.type_of_line(type_of_line);

COMMENT ON TABLE route.line_ref IS 'Reference to a given snapshot of a LINE. Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:1:3:420 ';
COMMENT ON COLUMN route.line_ref.label IS 'The label of the line.';
COMMENT ON COLUMN route.line_ref.type_of_line IS 'The type of line (GTFS route type): https://developers.google.com/transit/gtfs/reference/extended-route-types';

CREATE INDEX line_ref_type_of_line_idx ON route.line_ref USING btree (type_of_line);

-------------------- Journey Pattern --------------------

ALTER TABLE ONLY journey_pattern.journey_pattern_ref
  ADD COLUMN line_ref_id uuid REFERENCES route.line_ref (line_ref_id);

COMMENT ON COLUMN journey_pattern.journey_pattern_ref.line_ref_id IS 'The line with which this journey pattern is associated.';

CREATE INDEX journey_pattern_ref_line_ref_idx ON journey_pattern.journey_pattern_ref USING btree (line_ref_id);

-------------------- Service Calendar --------------------

CREATE TABLE service_calendar.substitute_operating_day (
  substitute_operating_day_id uuid DEFAULT gen_random_uuid(),
  type_of_line text NOT NULL,
  affected_date date NOT NULL,
  no_traffic boolean NOT NULL,
  reference_date date,
  begin_time interval,
  end_time interval,
  begin_datetime timestamp GENERATED ALWAYS AS (begin_time + affected_date) STORED,
  end_datetime timestamp GENERATED ALWAYS AS (end_time + affected_date) STORED
);

ALTER TABLE ONLY service_calendar.substitute_operating_day
  ADD CONSTRAINT substitute_operating_day_pkey PRIMARY KEY (substitute_operating_day_id);

ALTER TABLE ONLY service_calendar.substitute_operating_day
  ADD CONSTRAINT substitute_operating_day_type_of_line_fkey FOREIGN KEY (type_of_line) REFERENCES route.type_of_line(type_of_line);

COMMENT ON TABLE service_calendar.substitute_operating_day IS
  'Modeling substitute public transit with date references or indicating that public transit does not occur on certain date. Substitute operating days are bound to a type of line.';
COMMENT ON COLUMN service_calendar.substitute_operating_day.type_of_line IS 'The type of line this substitute operating day is bound to.';
COMMENT ON COLUMN service_calendar.substitute_operating_day.affected_date IS 'The date of operating day being substituted.';
COMMENT ON COLUMN service_calendar.substitute_operating_day.no_traffic IS 'Indicates whether there is no public transit at all.';
COMMENT ON COLUMN service_calendar.substitute_operating_day.reference_date IS 'The date of the reference day used as the basis for replacement. Must not be given when no traffic is selected.';
COMMENT ON COLUMN service_calendar.substitute_operating_day.begin_time IS 'The time from which the substituting public transit comes into effect. Null if substitute is valid from the start of operating day.';
COMMENT ON COLUMN service_calendar.substitute_operating_day.end_time IS 'The time until which the substituting public transit is valid. Null if substitute is valid until the end of operating day.';
COMMENT ON COLUMN service_calendar.substitute_operating_day.begin_datetime IS 'Calculated timestamp for the instant from which the substituting public transit comes into effect. Null if substitute is valid from the start of operating day.';
COMMENT ON COLUMN service_calendar.substitute_operating_day.end_datetime IS 'Calculated timestamp for the instant until which the substituting public transit is valid. Null if substitute is valid until the end of operating day.';

CREATE INDEX substitute_operating_day_type_of_line_idx ON service_calendar.substitute_operating_day USING btree (type_of_line);
