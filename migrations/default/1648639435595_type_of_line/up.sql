CREATE TABLE route.type_of_line (
  type_of_line text PRIMARY KEY,
  belonging_to_vehicle_mode text NOT NULL REFERENCES reusable_components.vehicle_mode (vehicle_mode)
);
COMMENT ON TABLE
  route.type_of_line IS
  'Type of line. https://www.transmodel-cen.eu/model/EARoot/EA2/EA1/EA3/EA491.htm';
COMMENT ON COLUMN
  route.type_of_line.type_of_line IS
  'GTFS route type: https://developers.google.com/transit/gtfs/reference/extended-route-types';
INSERT INTO route.type_of_line
  (type_of_line, belonging_to_vehicle_mode)
  VALUES
  ('regional_rail_service', 'train'),
  ('suburban_railway', 'train'),
  ('metro_service', 'metro'),
  ('regional_bus_service', 'bus'),
  ('express_bus_service', 'bus'),
  ('stopping_bus_service', 'bus'),
  ('special_needs_bus', 'bus'),
  ('demand_and_response_bus_service', 'bus'),
  ('city_tram_service', 'tram'),
  ('regional_tram_service', 'tram'),
  ('ferry_service', 'ferry')
  ON CONFLICT (type_of_line) DO NOTHING;
CREATE INDEX ON
  route.type_of_line
  (belonging_to_vehicle_mode);

ALTER TABLE route.line
  ADD COLUMN type_of_line text NOT NULL REFERENCES route.type_of_line (type_of_line);

COMMENT ON COLUMN
  route.line.type_of_line IS
  'The type of the line.';

CREATE FUNCTION route.check_type_of_line_vehicle_mode()
  RETURNS trigger
  LANGUAGE plpgsql AS
$$
BEGIN
  IF NOT EXISTS(
    SELECT 1
    FROM route.line
           JOIN route.type_of_line
                ON route.type_of_line.type_of_line = NEW.type_of_line
    WHERE route.type_of_line.belonging_to_vehicle_mode = NEW.primary_vehicle_mode
    )
  THEN
    RAISE EXCEPTION 'type of line must match lines primary vehicle mode';
  END IF;

  RETURN NEW;
END;
$$;

CREATE CONSTRAINT TRIGGER check_type_of_line_vehicle_mode_trigger
  AFTER INSERT OR UPDATE
  ON route.line
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
EXECUTE PROCEDURE route.check_type_of_line_vehicle_mode();