
DROP TRIGGER check_line_routes_validity_periods_trigger
  ON route.line;

DROP FUNCTION route.check_line_routes_validity_periods();


DROP TRIGGER check_route_line_validity_periods_trigger
  ON internal_route.route;

DROP FUNCTION internal_route.check_route_line_validity_period();
