DROP TRIGGER check_line_validity_against_all_associated_routes_trigger
  ON route.line;

DROP FUNCTION route.check_line_validity_against_all_associated_routes();


DROP TRIGGER check_route_validity_is_within_line_validity_trigger
  ON internal_route.route;

DROP FUNCTION internal_route.check_route_validity_is_within_line_validity();
