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

-- create the column without constraints first
ALTER TABLE route.line
  ADD COLUMN type_of_line text NULL;
COMMENT ON COLUMN
  route.line.type_of_line IS
  'The type of the line.';

-- Filling up the column with some initial content with the USING expression, then adding the constraints
-- NOTE: cannot use the UPDATE statement here, as it fails with "cannot ALTER TABLE because it has pending trigger events" error
ALTER TABLE route.line
  ALTER COLUMN type_of_line SET DATA TYPE text USING
    CASE
      WHEN primary_vehicle_mode = 'train' THEN 'regional_rail_service'
      WHEN primary_vehicle_mode = 'metro' THEN 'metro_service'
      WHEN primary_vehicle_mode = 'bus' THEN 'regional_bus_service'
      WHEN primary_vehicle_mode = 'tram' THEN 'regional_tram_service'
      WHEN primary_vehicle_mode = 'ferry' THEN 'ferry_service'
    END,
  ALTER COLUMN type_of_line SET NOT NULL,
  ADD CONSTRAINT line_type_of_line_fkey FOREIGN KEY (type_of_line) REFERENCES route.type_of_line (type_of_line);

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
