ALTER TABLE internal_route.route
ALTER COLUMN on_line_id SET NOT NULL;


CREATE FUNCTION internal_route.check_route_line_priorities()
  RETURNS trigger
  LANGUAGE plpgsql AS
$internal_route_route_insert_update_trigger$
DECLARE
  line_prio INT;
BEGIN
  SELECT route.line.priority
  FROM route.line
  INTO line_prio
  WHERE route.line.line_id = NEW.on_line_id;

  IF NEW.priority < line_prio
  THEN
    RAISE EXCEPTION 'route priority must be >= line priority';
  END IF;

  RETURN NEW;
END;
$internal_route_route_insert_update_trigger$;

CREATE CONSTRAINT TRIGGER check_route_line_priorities_trigger
  AFTER INSERT OR UPDATE ON internal_route.route
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW EXECUTE PROCEDURE internal_route.check_route_line_priorities();


CREATE FUNCTION route.check_line_routes_priorities()
  RETURNS trigger
  LANGUAGE plpgsql AS
$route_check_line_routes_priorities$
BEGIN
  IF EXISTS(
    SELECT 1
    FROM route.line
    JOIN internal_route.route ON internal_route.route.on_line_id = route.line.line_id
    WHERE route.line.line_id = NEW.line_id
    AND route.line.priority > internal_route.route.priority
  )
  THEN
    RAISE EXCEPTION 'route priority must be >= line priority';
  END IF;

  RETURN NEW;
END;
$route_check_line_routes_priorities$;

CREATE CONSTRAINT TRIGGER check_line_routes_priorities_trigger
  AFTER UPDATE ON route.line
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW EXECUTE PROCEDURE route.check_line_routes_priorities();
