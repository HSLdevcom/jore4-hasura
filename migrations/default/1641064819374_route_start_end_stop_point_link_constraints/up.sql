
CREATE FUNCTION route.verify_route_start_end_stop_points(param_route_id UUID)
  RETURNS VOID
  LANGUAGE plpgsql AS
$$
BEGIN
  IF (
       SELECT ilar.infrastructure_link_id
       FROM route.infrastructure_link_along_route ilar
       WHERE ilar.route_id = param_route_id
       ORDER BY ilar.infrastructure_link_sequence ASC
       LIMIT 1
     ) != (
       SELECT ssp.located_on_infrastructure_link_id
       FROM internal_service_pattern.scheduled_stop_point ssp
              JOIN internal_route.route r ON r.starts_from_scheduled_stop_point_id = ssp.scheduled_stop_point_id
       WHERE r.route_id = param_route_id
     )
  THEN
    RAISE EXCEPTION 'route starting stop point does not reside on route''s first link';
  END IF;

  IF (
       SELECT ilar.infrastructure_link_id
       FROM route.infrastructure_link_along_route ilar
       WHERE ilar.route_id = param_route_id
       ORDER BY ilar.infrastructure_link_sequence DESC
       LIMIT 1
     ) != (
       SELECT ssp.located_on_infrastructure_link_id
       FROM internal_service_pattern.scheduled_stop_point ssp
              JOIN internal_route.route r ON r.ends_at_scheduled_stop_point_id = ssp.scheduled_stop_point_id
       WHERE r.route_id = param_route_id
     )
  THEN
    RAISE EXCEPTION 'route ending stop point does not reside on route''s last link';
  END IF;
END;
$$;


CREATE FUNCTION route.verify_route_start_end_stop_points_by_new_route_id()
  RETURNS TRIGGER
  LANGUAGE plpgsql AS
$$
BEGIN
  PERFORM route.verify_route_start_end_stop_points(NEW.route_id);

  RETURN NULL;
END;
$$;

CREATE FUNCTION route.verify_route_start_end_stop_points_by_old_and_new_route_id()
  RETURNS TRIGGER
  LANGUAGE plpgsql AS
$$
BEGIN
  PERFORM route.verify_route_start_end_stop_points(OLD.route_id);
  PERFORM route.verify_route_start_end_stop_points(NEW.route_id);

  RETURN NULL;
END;
$$;

CREATE FUNCTION route.verify_route_start_end_stop_points_by_old_and_new_link_id()
  RETURNS TRIGGER
  LANGUAGE plpgsql AS
$$
DECLARE
  route_id UUID;
BEGIN
  FOR route_id IN SELECT ilar.route_id
                  FROM route.infrastructure_link_along_route ilar
                  WHERE ilar.infrastructure_link_id IN (OLD.located_on_infrastructure_link_id, NEW.located_on_infrastructure_link_id)
    LOOP
      PERFORM route.verify_route_start_end_stop_points(route_id);
    END LOOP;

  RETURN NULL;
END;
$$;


CREATE CONSTRAINT TRIGGER verify_route_start_end_stop_points_by_new_route_id_trigger
  AFTER INSERT OR UPDATE ON internal_route.route
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW EXECUTE PROCEDURE route.verify_route_start_end_stop_points_by_new_route_id();

CREATE CONSTRAINT TRIGGER verify_route_start_end_stop_points_by_old_and_new_route_id_trigger
  AFTER INSERT OR UPDATE OR DELETE ON route.infrastructure_link_along_route
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW EXECUTE PROCEDURE route.verify_route_start_end_stop_points_by_old_and_new_route_id();

CREATE CONSTRAINT TRIGGER verify_route_start_end_stop_points_by_old_and_new_link_id_trigger
  AFTER UPDATE ON internal_service_pattern.scheduled_stop_point
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW EXECUTE PROCEDURE route.verify_route_start_end_stop_points_by_old_and_new_link_id();
