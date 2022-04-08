
-- restore old versions of view and modification functions

DROP VIEW route.route;
CREATE VIEW route.route AS
  SELECT
    r.route_id,
    r.description_i18n,
    r.starts_from_scheduled_stop_point_id,
    r.ends_at_scheduled_stop_point_id,
    -- FIXME: clamp with start and end stops: join on scheduled stop point view, ST_LineSubstring, consider direction
    ST_LineMerge(
      ST_Collect(
        CASE
          WHEN ilar.is_traversal_forwards THEN il.shape::geometry
          ELSE ST_Reverse(il.shape::geometry)
          END
        )
      )::geography AS route_shape
  FROM
    internal_route.route AS r
  LEFT JOIN (
    route.infrastructure_link_along_route AS ilar
      INNER JOIN infrastructure_network.infrastructure_link AS il
      ON (ilar.infrastructure_link_id = il.infrastructure_link_id)
    ) ON (r.route_id = ilar.route_id)
  GROUP BY r.route_id;
COMMENT ON VIEW
  route.route IS
  'The routes from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:1:3:483';
COMMENT ON COLUMN
  route.route.route_id IS
  'The ID of the route.';
COMMENT ON COLUMN
  route.route.description_i18n IS
  'The description of the route in the form of starting location - destination. Placeholder for multilingual strings.';
COMMENT ON COLUMN
  route.route.starts_from_scheduled_stop_point_id IS
  'The scheduled stop point where the route starts from.';
COMMENT ON COLUMN
  route.route.ends_at_scheduled_stop_point_id IS
  'The scheduled stop point where the route ends at.';
COMMENT ON COLUMN
  route.route.route_shape IS
  'A PostGIS LinestringZ geography in EPSG:4326 describing the shape of the route.';

CREATE TRIGGER route_insert_route_trigger
  INSTEAD OF INSERT ON route.route
  FOR EACH ROW EXECUTE PROCEDURE route.insert_route();

CREATE TRIGGER route_update_route_trigger
  INSTEAD OF UPDATE ON route.route
  FOR EACH ROW EXECUTE PROCEDURE route.update_route();

CREATE TRIGGER route_delete_route_trigger
  INSTEAD OF DELETE ON route.route
  FOR EACH ROW EXECUTE PROCEDURE route.delete_route();

CREATE OR REPLACE FUNCTION route.insert_route ()
  RETURNS TRIGGER
  LANGUAGE plpgsql
AS $route_insert_route$
BEGIN
  INSERT INTO internal_route.route (
    description_i18n,
    starts_from_scheduled_stop_point_id,
    ends_at_scheduled_stop_point_id
  ) VALUES (
     NEW.description_i18n,
     NEW.starts_from_scheduled_stop_point_id,
     NEW.ends_at_scheduled_stop_point_id
   ) RETURNING route_id INTO NEW.route_id;
  RETURN NEW;
END;
$route_insert_route$;

CREATE OR REPLACE FUNCTION route.update_route ()
  RETURNS TRIGGER
  LANGUAGE plpgsql
AS $route_update_route$
BEGIN
  UPDATE internal_route.route
  SET
    route_id = NEW.route_id,
    description_i18n = NEW.description_i18n,
    starts_from_scheduled_stop_point_id = NEW.starts_from_scheduled_stop_point_id,
    ends_at_scheduled_stop_point_id = NEW.ends_at_scheduled_stop_point_id
  WHERE route_id = OLD.route_id;
  RETURN NEW;
END;
$route_update_route$;


ALTER TABLE internal_route.route
  DROP COLUMN on_line_id;

DROP TABLE route.line;
