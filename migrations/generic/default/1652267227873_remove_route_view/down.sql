DROP FUNCTION route.route_shape(route_row route.route);

CREATE SCHEMA internal_route;

CREATE OR REPLACE FUNCTION route.check_line_routes_priorities()
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
CREATE OR REPLACE FUNCTION route.check_line_validity_against_all_associated_routes()
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
CREATE OR REPLACE FUNCTION route.verify_route_start_end_stop_points(param_route_id UUID)
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

ALTER TABLE route.route SET SCHEMA internal_route;
ALTER FUNCTION route.check_route_line_priorities SET SCHEMA internal_route;
ALTER FUNCTION route.check_route_validity_is_within_line_validity SET SCHEMA internal_route;
ALTER FUNCTION route.delete_route_related_localizations SET SCHEMA internal_route;

ALTER TABLE internal_route.route RENAME CONSTRAINT route_unique_validity_period TO unique_validity_period;
ALTER TABLE route.line RENAME CONSTRAINT line_unique_validity_period TO unique_validity_period;

ALTER VIEW deleted.route_1652267227873 SET SCHEMA route;
ALTER VIEW route.route_1652267227873 RENAME TO route;
