DROP FUNCTION route.route_shape(route_row route.route);

ALTER FUNCTION deleted.route_shape_1660903023968(route_row route.route)
    SET SCHEMA route;
     
ALTER FUNCTION route.route_shape_1660903023968
(route_row route.route)
RENAME TO route_shape;
