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
  ADD COLUMN type_of_line text REFERENCES route.type_of_line (type_of_line);

COMMENT ON COLUMN journey_pattern.journey_pattern_ref.type_of_line IS 'The type of line (GTFS route type): https://developers.google.com/transit/gtfs/reference/extended-route-types';

CREATE INDEX journey_pattern_ref_type_of_line
  ON journey_pattern.journey_pattern_ref USING btree (type_of_line);
