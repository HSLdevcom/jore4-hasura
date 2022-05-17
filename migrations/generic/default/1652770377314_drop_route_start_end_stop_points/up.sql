
DROP TRIGGER verify_route_start_end_stop_points_by_old_and_new_link_id_trigger
  ON internal_service_pattern.scheduled_stop_point;

DROP TRIGGER verify_route_start_end_stop_points_by_old_and_new_route_id_trigger
  ON route.infrastructure_link_along_route;

DROP TRIGGER verify_route_start_end_stop_points_by_new_route_id_trigger
  ON route.route;


ALTER FUNCTION route.verify_route_start_end_stop_points_by_old_and_new_link_id ()
  RENAME TO verify_route_start_end_stop_points_by_old_and_new_link_id_1652770377314;
ALTER FUNCTION route.verify_route_start_end_stop_points_by_old_and_new_link_id_1652770377314 ()
  SET SCHEMA deleted;

ALTER FUNCTION route.verify_route_start_end_stop_points_by_old_and_new_route_id ()
  RENAME TO verify_route_start_end_stop_points_by_old_and_new_route_id_1652770377314;
ALTER FUNCTION route.verify_route_start_end_stop_points_by_old_and_new_route_id_1652770377314 ()
  SET SCHEMA deleted;

ALTER FUNCTION route.verify_route_start_end_stop_points_by_new_route_id ()
  RENAME TO verify_route_start_end_stop_points_by_new_route_id_1652770377314;
ALTER FUNCTION route.verify_route_start_end_stop_points_by_new_route_id_1652770377314 ()
  SET SCHEMA deleted;

ALTER FUNCTION route.verify_route_start_end_stop_points (UUID)
  RENAME TO verify_route_start_end_stop_points_1652770377314;
ALTER FUNCTION route.verify_route_start_end_stop_points_1652770377314 (UUID)
  SET SCHEMA deleted;


ALTER TABLE route.route
  DROP COLUMN starts_from_scheduled_stop_point_id,
  DROP COLUMN ends_at_scheduled_stop_point_id;
