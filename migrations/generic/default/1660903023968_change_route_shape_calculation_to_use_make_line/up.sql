ALTER FUNCTION route.route_shape
(route_row route.route)
RENAME TO route_shape_1660903023968;

ALTER FUNCTION route.route_shape_1660903023968(route_row route.route)
    SET SCHEMA deleted;

-- Change the route_shape calculating function to use 'ST_MakeLine' to 
-- get only LineStrings as result of route_shape
CREATE FUNCTION route.route_shape(route_row route.route)
RETURNS geography AS $route_shape$
  SELECT
    ST_MakeLine(
      CASE
        WHEN ilar.is_traversal_forwards THEN il.shape::geometry
        ELSE ST_Reverse(il.shape::geometry)
      END
        ORDER BY ilar.infrastructure_link_sequence
    )::geography AS route_shape
  FROM
    route.route r
      LEFT JOIN (
      route.infrastructure_link_along_route AS ilar
        INNER JOIN infrastructure_network.infrastructure_link AS il
        ON (ilar.infrastructure_link_id = il.infrastructure_link_id)
      ) ON (route_row.route_id = ilar.route_id)
    WHERE r.route_id = route_row.route_id;
$route_shape$ LANGUAGE sql STABLE;