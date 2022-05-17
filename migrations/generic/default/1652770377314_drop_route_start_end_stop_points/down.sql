
ALTER TABLE route.route
  ADD COLUMN starts_from_scheduled_stop_point_id uuid REFERENCES internal_service_pattern.scheduled_stop_point (scheduled_stop_point_id),
  ADD COLUMN ends_at_scheduled_stop_point_id uuid REFERENCES internal_service_pattern.scheduled_stop_point (scheduled_stop_point_id);

BEGIN;
-- to revert the change, pick a random stop from the route's first and last link
UPDATE route.route r
SET
  starts_from_scheduled_stop_point_id = (
    SELECT ssp.scheduled_stop_point_id
    FROM internal_service_pattern.scheduled_stop_point ssp
    WHERE ssp.located_on_infrastructure_link_id = (
      SELECT ilar.infrastructure_link_id
      FROM route.infrastructure_link_along_route ilar
      WHERE ilar.route_id = r.route_id
      ORDER BY ilar.infrastructure_link_sequence ASC
      LIMIT 1)
    LIMIT 1),
  ends_at_scheduled_stop_point_id = (
    SELECT ssp.scheduled_stop_point_id
    FROM internal_service_pattern.scheduled_stop_point ssp
    WHERE ssp.located_on_infrastructure_link_id = (
      SELECT ilar.infrastructure_link_id
      FROM route.infrastructure_link_along_route ilar
      WHERE ilar.route_id = r.route_id
      ORDER BY ilar.infrastructure_link_sequence DESC
      LIMIT 1)
    LIMIT 1);

-- in theory, it is possible that some route has no links at all
UPDATE route.route r
SET
  starts_from_scheduled_stop_point_id = (
    SELECT ssp.scheduled_stop_point_id
    FROM internal_service_pattern.scheduled_stop_point ssp
    LIMIT 1),
  ends_at_scheduled_stop_point_id = (
    SELECT ssp.scheduled_stop_point_id
    FROM internal_service_pattern.scheduled_stop_point ssp
    LIMIT 1)
WHERE starts_from_scheduled_stop_point_id IS NULL;
COMMIT;

ALTER TABLE route.route
  ALTER COLUMN starts_from_scheduled_stop_point_id SET NOT NULL,
  ALTER COLUMN ends_at_scheduled_stop_point_id SET NOT NULL;


ALTER FUNCTION deleted.verify_route_start_end_stop_points_by_old_and_new_link_id_1652770377314 ()
  SET SCHEMA route;
ALTER FUNCTION route.verify_route_start_end_stop_points_by_old_and_new_link_id_1652770377314 ()
  RENAME TO verify_route_start_end_stop_points_by_old_and_new_link_id;

ALTER FUNCTION deleted.verify_route_start_end_stop_points_by_old_and_new_route_id_1652770377314 ()
  SET SCHEMA route;
ALTER FUNCTION route.verify_route_start_end_stop_points_by_old_and_new_route_id_1652770377314 ()
  RENAME TO verify_route_start_end_stop_points_by_old_and_new_route_id;

ALTER FUNCTION deleted.verify_route_start_end_stop_points_by_new_route_id_1652770377314 ()
  SET SCHEMA route;
ALTER FUNCTION route.verify_route_start_end_stop_points_by_new_route_id_1652770377314 ()
  RENAME TO verify_route_start_end_stop_points_by_new_route_id;

ALTER FUNCTION deleted.verify_route_start_end_stop_points_1652770377314 (UUID)
  SET SCHEMA route;
ALTER FUNCTION route.verify_route_start_end_stop_points_1652770377314 (UUID)
  RENAME TO verify_route_start_end_stop_points;


CREATE CONSTRAINT TRIGGER verify_route_start_end_stop_points_by_new_route_id_trigger
  AFTER INSERT OR UPDATE ON route.route
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


CREATE VIEW deleted.route_1652267227873
AS SELECT r.route_id,
          r.description_i18n,
          r.starts_from_scheduled_stop_point_id,
          r.ends_at_scheduled_stop_point_id,
          st_linemerge(st_collect(
            CASE
              WHEN ilar.is_traversal_forwards THEN il.shape::geometry
              ELSE st_reverse(il.shape::geometry)
              END))::geography AS route_shape,
          r.on_line_id,
          r.validity_start,
          r.validity_end,
          r.priority,
          r.label,
          r.direction
   FROM route.route r
          LEFT JOIN (route.infrastructure_link_along_route ilar
     JOIN infrastructure_network.infrastructure_link il ON ilar.infrastructure_link_id = il.infrastructure_link_id) ON r.route_id = ilar.route_id
   GROUP BY r.route_id;

CREATE VIEW deleted.route_1637329168554
AS SELECT r.route_id,
          r.description_i18n,
          r.starts_from_scheduled_stop_point_id,
          r.ends_at_scheduled_stop_point_id,
          st_linemerge(st_collect(
            CASE
              WHEN ilar.is_traversal_forwards THEN il.shape::geometry
              ELSE st_reverse(il.shape::geometry)
              END))::geography AS route_shape,
          r.on_line_id,
          r.validity_start,
          r.validity_end,
          r.priority
   FROM route.route r
          LEFT JOIN (route.infrastructure_link_along_route ilar
     JOIN infrastructure_network.infrastructure_link il ON ilar.infrastructure_link_id = il.infrastructure_link_id) ON r.route_id = ilar.route_id
   GROUP BY r.route_id;
