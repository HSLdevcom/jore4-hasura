
-- scheduled_stop_point changes
-------------------------------

DROP VIEW service_pattern.scheduled_stop_point;
CREATE VIEW service_pattern.scheduled_stop_point AS
SELECT
  ssp.scheduled_stop_point_id,
  ssp.label,
  ssp.measured_location,
  ssp.located_on_infrastructure_link_id,
  ssp.direction,
  internal_utils.ST_LineLocatePoint(il.shape, ssp.measured_location) AS relative_distance_from_infrastructure_link_start,
  internal_utils.ST_ClosestPoint(il.shape, ssp.measured_location) AS closest_point_on_infrastructure_link
FROM
  internal_service_pattern.scheduled_stop_point AS ssp
    INNER JOIN infrastructure_network.infrastructure_link AS il ON (ssp.located_on_infrastructure_link_id = il.infrastructure_link_id);
COMMENT ON VIEW
  service_pattern.scheduled_stop_point IS
  'The scheduled stop points: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:4:845 . Colloquially known as stops from the perspective of timetable planning.';
COMMENT ON COLUMN
  service_pattern.scheduled_stop_point.scheduled_stop_point_id IS
  'The ID of the scheduled stop point.';
COMMENT ON COLUMN
  service_pattern.scheduled_stop_point.label IS
  'The label is the short code that identifies the stop to the passengers. There can be at most one stop with the same label at a time. The label matches the GTFS stop_code.';
COMMENT ON COLUMN
  service_pattern.scheduled_stop_point.measured_location IS
  'The measured location describes the physical location of the stop. For some stops this describes the location of the pole-mounted flag. A PostGIS PointZ geography in EPSG:4326.';
COMMENT ON COLUMN
  service_pattern.scheduled_stop_point.located_on_infrastructure_link_id IS
  'The infrastructure link on which the stop is located.';
COMMENT ON COLUMN
  service_pattern.scheduled_stop_point.direction IS
  'The direction(s) of traffic with respect to the digitization, i.e. the direction of the specified line string.';
COMMENT ON COLUMN
  service_pattern.scheduled_stop_point.relative_distance_from_infrastructure_link_start IS
  'The relative distance of the stop from the start of the linestring along the infrastructure link. Regardless of the specified direction, this value is the distance from the beginning of the linestring. The distance is normalized to the closed interval [0, 1].';
COMMENT ON COLUMN
  service_pattern.scheduled_stop_point.closest_point_on_infrastructure_link IS
  'The point on the infrastructure link closest to measured_location. A PostGIS PointZ geography in EPSG:4326.';

CREATE TRIGGER service_pattern_insert_scheduled_stop_point_trigger
  INSTEAD OF INSERT ON service_pattern.scheduled_stop_point
  FOR EACH ROW EXECUTE PROCEDURE service_pattern.insert_scheduled_stop_point();

CREATE TRIGGER service_pattern_update_scheduled_stop_point_trigger
  INSTEAD OF UPDATE ON service_pattern.scheduled_stop_point
  FOR EACH ROW EXECUTE PROCEDURE service_pattern.update_scheduled_stop_point();

CREATE TRIGGER service_pattern_delete_scheduled_stop_point_trigger
  INSTEAD OF DELETE ON service_pattern.scheduled_stop_point
  FOR EACH ROW EXECUTE PROCEDURE service_pattern.delete_scheduled_stop_point();

CREATE OR REPLACE FUNCTION service_pattern.insert_scheduled_stop_point ()
  RETURNS TRIGGER
  LANGUAGE plpgsql
AS $service_pattern_insert_scheduled_stop_point$
BEGIN
  INSERT INTO internal_service_pattern.scheduled_stop_point (
    measured_location,
    located_on_infrastructure_link_id,
    direction,
    label
  ) VALUES (
    NEW.measured_location,
    NEW.located_on_infrastructure_link_id,
    NEW.direction,
    NEW.label
  ) RETURNING scheduled_stop_point_id INTO NEW.scheduled_stop_point_id;
  RETURN NEW;
END;
$service_pattern_insert_scheduled_stop_point$;

CREATE OR REPLACE FUNCTION service_pattern.update_scheduled_stop_point ()
  RETURNS TRIGGER
  LANGUAGE plpgsql
AS $service_pattern_update_scheduled_stop_point$
BEGIN
  UPDATE internal_service_pattern.scheduled_stop_point
  SET
    scheduled_stop_point_id = NEW.scheduled_stop_point_id,
    measured_location = NEW.measured_location,
    located_on_infrastructure_link_id = NEW.located_on_infrastructure_link_id,
    direction = NEW.direction,
    label = NEW.label
  WHERE scheduled_stop_point_id = OLD.scheduled_stop_point_id;
  RETURN NEW;
END;
$service_pattern_update_scheduled_stop_point$;

ALTER TABLE internal_service_pattern.scheduled_stop_point
DROP COLUMN validity_start,
DROP COLUMN validity_end,
DROP COLUMN priority;


-- route changes
----------------

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
    )::geography AS route_shape,
  r.on_line_id
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
COMMENT ON COLUMN
  route.route.on_line_id IS
  'The line to which this route belongs.';

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
    ends_at_scheduled_stop_point_id,
    on_line_id
  ) VALUES (
    NEW.description_i18n,
    NEW.starts_from_scheduled_stop_point_id,
    NEW.ends_at_scheduled_stop_point_id,
    NEW.on_line_id
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
    ends_at_scheduled_stop_point_id = NEW.ends_at_scheduled_stop_point_id,
    on_line_id = NEW.on_line_id
  WHERE route_id = OLD.route_id;
  RETURN NEW;
END;
$route_update_route$;

ALTER TABLE internal_route.route
DROP COLUMN validity_start,
DROP COLUMN validity_end,
DROP COLUMN priority;


-- line changes
---------------

ALTER TABLE route.line
DROP COLUMN validity_start,
DROP COLUMN validity_end,
DROP COLUMN priority;
