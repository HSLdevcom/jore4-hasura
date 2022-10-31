CREATE FUNCTION internal_route.check_route_validity_is_within_line_validity()
  RETURNS trigger
  LANGUAGE plpgsql AS
$$
DECLARE
  line_validity_start TIMESTAMP WITH TIME ZONE;
  line_validity_end TIMESTAMP WITH TIME ZONE;
BEGIN
  SELECT l.validity_start, l.validity_end
  FROM route.line l
  INTO line_validity_start, line_validity_end
    WHERE l.line_id = NEW.on_line_id;

  IF (line_validity_start IS NOT NULL AND (NEW.validity_start < line_validity_start OR NEW.validity_start IS NULL)) OR
     (line_validity_end IS NOT NULL AND (NEW.validity_end > line_validity_end OR NEW.validity_end IS NULL))
  THEN
    RAISE EXCEPTION 'route validity period must lie within its line''s validity period';
  END IF;

  RETURN NEW;
END;
$$;

CREATE CONSTRAINT TRIGGER check_route_validity_is_within_line_validity_trigger
  AFTER INSERT OR UPDATE ON internal_route.route
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW EXECUTE PROCEDURE internal_route.check_route_validity_is_within_line_validity();


CREATE FUNCTION route.check_line_validity_against_all_associated_routes()
  RETURNS trigger
  LANGUAGE plpgsql AS
$$
BEGIN
  IF EXISTS(
    SELECT 1
    FROM internal_route.route r
    WHERE r.on_line_id = NEW.line_id
      AND ((NEW.validity_start IS NOT NULL AND (NEW.validity_start > r.validity_start OR r.validity_start IS NULL)) OR
           (NEW.validity_end IS NOT NULL AND (NEW.validity_end < r.validity_end OR r.validity_end IS NULL)))
    )
  THEN
    RAISE EXCEPTION 'line validity period must span all its routes'' validity periods';
  END IF;

  RETURN NEW;
END;
$$;

CREATE CONSTRAINT TRIGGER check_line_validity_against_all_associated_routes_trigger
  AFTER UPDATE ON route.line
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW EXECUTE PROCEDURE route.check_line_validity_against_all_associated_routes();
