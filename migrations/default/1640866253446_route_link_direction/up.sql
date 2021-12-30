CREATE FUNCTION route.check_route_link_infrastructure_link_direction()
  RETURNS trigger
  LANGUAGE plpgsql AS
$$
DECLARE
  link_dir TEXT;
BEGIN
  SELECT infrastructure_network.infrastructure_link.direction
  FROM infrastructure_network.infrastructure_link
  INTO link_dir WHERE infrastructure_network.infrastructure_link.
  infrastructure_link_id = NEW.infrastructure_link_id;

  -- NB: link_dir = 'bidirectional' allows both traversal directions
  IF (NEW.is_traversal_forwards = TRUE AND link_dir = 'backward') OR
     (NEW.is_traversal_forwards = FALSE AND link_dir = 'forward')
  THEN
    RAISE EXCEPTION 'route link direction must be compatible with infrastructure link direction';
  END IF;

  RETURN NEW;
END;
$$;

CREATE CONSTRAINT TRIGGER check_route_link_infrastructure_link_direction_trigger
  AFTER INSERT OR UPDATE
  ON route.infrastructure_link_along_route
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
EXECUTE PROCEDURE route.check_route_link_infrastructure_link_direction();


CREATE FUNCTION infrastructure_network.check_infrastructure_link_route_link_direction()
  RETURNS trigger
  LANGUAGE plpgsql AS
$$
BEGIN
  IF EXISTS(
    SELECT 1
    FROM route.infrastructure_link_along_route
           JOIN infrastructure_network.infrastructure_link
                ON infrastructure_network.infrastructure_link.infrastructure_link_id =
                   route.infrastructure_link_along_route.infrastructure_link_id
    WHERE route.infrastructure_link_along_route.infrastructure_link_id = NEW.infrastructure_link_id
      AND (
      -- NB: NEW.direction = 'bidirectional' allows both traversal directions
        (route.infrastructure_link_along_route.is_traversal_forwards = TRUE AND NEW.direction = 'backward') OR
        (route.infrastructure_link_along_route.is_traversal_forwards = FALSE AND NEW.direction = 'forward')
      )
    )
  THEN
    RAISE EXCEPTION 'route link direction must be compatible with infrastructure link direction';
  END IF;

  RETURN NEW;
END;
$$;

CREATE CONSTRAINT TRIGGER check_infrastructure_link_route_link_direction_trigger
  AFTER UPDATE
  ON infrastructure_network.infrastructure_link
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
EXECUTE PROCEDURE infrastructure_network.check_infrastructure_link_route_link_direction();
