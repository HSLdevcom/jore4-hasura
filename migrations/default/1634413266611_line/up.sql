
CREATE TABLE route.line (
  line_id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  name_i18n text NOT NULL,
  short_name_i18n text,
  description_i18n text,
  primary_vehicle_mode text NOT NULL REFERENCES reusable_components.vehicle_mode (vehicle_mode)
);
COMMENT ON TABLE
  route.line IS
  'The line from Transmodel: http://www.transmodel-cen.eu/model/index.htm?goto=2:1:3:487';
COMMENT ON COLUMN
  route.line.line_id IS
  'The ID of the line.';
COMMENT ON COLUMN
  route.line.name_i18n IS
  'The name of the line. Placeholder for multilingual strings.';
COMMENT ON COLUMN
  route.line.short_name_i18n IS
  'The shorted name of the line. Placeholder for multilingual strings.';
COMMENT ON COLUMN
  route.line.description_i18n IS
  'The description of the line. Placeholder for multilingual strings.';
COMMENT ON COLUMN
  route.line.primary_vehicle_mode IS
  'The mode of the vehicles used as primary on the line.';

ALTER TABLE internal_route.route
  ADD COLUMN on_line_id uuid REFERENCES route.line (line_id);
COMMENT ON COLUMN
  internal_route.route.on_line_id IS
  'The line to which this route belongs.';

CREATE OR REPLACE FUNCTION route.insert_route ()
  RETURNS TRIGGER
  LANGUAGE plpgsql
AS $route_insert_route$
BEGIN
  INSERT INTO internal_route.route (
    description_i18n,
    starts_from_scheduled_stop_point_id,
    ends_at_scheduled_stop_point_id,
    on_line_id
  ) VALUES (
     NEW.description_i18n,
     NEW.starts_from_scheduled_stop_point_id,
     NEW.ends_at_scheduled_stop_point_id,
     NEW.on_line_id
   ) RETURNING route_id INTO NEW.route_id;
  RETURN NEW;
END;
$route_insert_route$;

CREATE OR REPLACE FUNCTION route.update_route ()
  RETURNS TRIGGER
  LANGUAGE plpgsql
AS $route_update_route$
BEGIN
  UPDATE internal_route.route
  SET
    route_id = NEW.route_id,
    description_i18n = NEW.description_i18n,
    starts_from_scheduled_stop_point_id = NEW.starts_from_scheduled_stop_point_id,
    ends_at_scheduled_stop_point_id = NEW.ends_at_scheduled_stop_point_id,
    on_line_id = NEW.on_line_id
  WHERE route_id = OLD.route_id;
  RETURN NEW;
END;
$route_update_route$;

-- Deletion works the same way as before, because it does not reference the new column.
