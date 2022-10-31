DROP TRIGGER check_line_routes_priorities_trigger
  ON route.line;

DROP FUNCTION route.check_line_routes_priorities();


DROP TRIGGER check_route_line_priorities_trigger
  ON internal_route.route;

DROP FUNCTION internal_route.check_route_line_priorities();


ALTER TABLE internal_route.route
ALTER COLUMN on_line_id DROP NOT NULL;
