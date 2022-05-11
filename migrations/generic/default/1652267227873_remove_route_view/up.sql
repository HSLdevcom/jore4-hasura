-- rename and archive old route.route view
ALTER VIEW route.route RENAME TO route_1652267227873;
ALTER VIEW route.route_1652267227873 SET SCHEMA deleted;

-- rename some constraints because they would conflict after the table is moved
ALTER TABLE internal_route.route RENAME CONSTRAINT unique_validity_period TO route_unique_validity_period;
ALTER TABLE route.line RENAME CONSTRAINT unique_validity_period TO line_unique_validity_period;

-- move the internal_route schema contents to the new route schema
ALTER TABLE internal_route.route SET SCHEMA route;
ALTER FUNCTION internal_route.check_route_line_priorities SET SCHEMA route;
ALTER FUNCTION internal_route.check_route_validity_is_within_line_validity SET SCHEMA route;
ALTER FUNCTION internal_route.delete_route_related_localizations SET SCHEMA route;

-- fix the functions that they use the new schema in their body
CREATE OR REPLACE FUNCTION route.check_line_routes_priorities()
  RETURNS trigger
  LANGUAGE plpgsql AS
$route_check_line_routes_priorities$
BEGIN
  IF EXISTS(
    SELECT 1
    FROM route.line
    JOIN route.route ON route.route.on_line_id = route.line.line_id
    WHERE route.line.line_id = NEW.line_id
    AND route.line.priority > route.route.priority
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
    FROM route.route r
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
              JOIN route.route r ON r.starts_from_scheduled_stop_point_id = ssp.scheduled_stop_point_id
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
              JOIN route.route r ON r.ends_at_scheduled_stop_point_id = ssp.scheduled_stop_point_id
       WHERE r.route_id = param_route_id
     )
  THEN
    RAISE EXCEPTION 'route ending stop point does not reside on route''s last link';
  END IF;
END;
$$;

-- delete the internal_route schema
DROP SCHEMA internal_route;

-- create a function in place of the old route.route.route_shape column
-- this can be used by hasura as a computed field for the route.route table
-- https://hasura.io/docs/latest/graphql/core/databases/postgres/schema/computed-fields/#1-scalar-computed-fields
CREATE FUNCTION route.route_shape(route_row route.route)
RETURNS geography AS $route_shape$
  SELECT
    ST_LineMerge(
    ST_Collect(
      CASE
        WHEN ilar.is_traversal_forwards THEN il.shape::geometry
        ELSE ST_Reverse(il.shape::geometry)
        END
      )
    )::geography AS route_shape
  FROM
    route.route r
      LEFT JOIN (
      route.infrastructure_link_along_route AS ilar
        INNER JOIN infrastructure_network.infrastructure_link AS il
        ON (ilar.infrastructure_link_id = il.infrastructure_link_id)
      ) ON (route_row.route_id = ilar.route_id)
    WHERE r.route_id = route_row.route_id;
  -- GROUP BY route_row.route_id;
$route_shape$ LANGUAGE sql STABLE;
