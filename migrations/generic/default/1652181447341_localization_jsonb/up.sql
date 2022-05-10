
-- change route.line localized fields from text to jsonb
-- also set them NOT NULL as they are required fields
ALTER TABLE route.line
    ALTER COLUMN name_i18n SET DATA TYPE JSONB
      USING to_jsonb('{"fi_FI": "' || name_i18n || '"}'),
    ALTER COLUMN short_name_i18n SET DATA TYPE JSONB
      USING to_jsonb('{"fi_FI": "' || short_name_i18n || '"}'),
    ALTER COLUMN short_name_i18n SET NOT NULL;
CREATE INDEX idx_line_name_i18n on route.line USING gin (name_i18n);
CREATE INDEX idx_line_short_name_i18n on route.line USING gin (short_name_i18n);

-- have to drop all previous views that use the columns below, it's not possible to keep them as the underlying tables change
DROP VIEW route.route;
DROP VIEW deleted.route_1637329168554;

-- change internal_route.route localized fields from text to jsonb
-- add some more localized fields that will be used in the future
-- also set them NOT NULL as they are all required fields
ALTER TABLE internal_route.route
    ADD COLUMN name_i18n JSONB NOT NULL,
    ALTER COLUMN description_i18n SET DATA TYPE JSONB
      USING to_jsonb('{"fi_FI": "' || description_i18n || '"}'),
    ADD COLUMN origin_name_i18n JSONB NOT NULL,
    ADD COLUMN origin_short_name_i18n JSONB NOT NULL,
    ADD COLUMN destination_name_i18n JSONB NOT NULL,
    ADD COLUMN destination_short_name_i18n JSONB NOT NULL;
CREATE INDEX idx_route_name_i18n on internal_route.route USING gin (name_i18n);
CREATE INDEX idx_route_origin_name_i18n on internal_route.route USING gin (origin_name_i18n);
CREATE INDEX idx_route_origin_short_name_i18n on internal_route.route USING gin (origin_short_name_i18n);
CREATE INDEX idx_route_destination_name_i18n on internal_route.route USING gin (destination_name_i18n);
CREATE INDEX idx_route_destination_short_name_i18n on internal_route.route USING gin (destination_short_name_i18n);

-- recreate the route.route view with the new fields
CREATE VIEW route.route AS
SELECT
  r.route_id,
  r.name_i18n,
  r.description_i18n,
  r.origin_name_i18n,
  r.origin_short_name_i18n,
  r.destination_name_i18n,
  r.destination_short_name_i18n,
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
  r.on_line_id,
  r.validity_start,
  r.validity_end,
  r.priority,
  r.label,
  r.direction
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
  route.route.name_i18n IS
  'The full name of the route. Uses multilingual strings.';
COMMENT ON COLUMN
  route.route.description_i18n IS
  'The free-form description of the route. Uses multilingual strings.';
COMMENT ON COLUMN
  route.route.origin_name_i18n IS
  'The full name of the route origin. Uses multilingual strings.';
COMMENT ON COLUMN
  route.route.origin_short_name_i18n IS
  'The short name of the route origin. Uses multilingual strings.';
COMMENT ON COLUMN
  route.route.destination_name_i18n IS
  'The full name of the route destination. Uses multilingual strings.';
COMMENT ON COLUMN
  route.route.destination_short_name_i18n IS
  'The short name of the route destination. Uses multilingual strings.';
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
COMMENT ON COLUMN
  route.route.validity_start IS
  'The point in time when the route becomes valid. If NULL, the route has been always valid before end time of validity period.';
COMMENT ON COLUMN
  route.route.validity_end IS
  'The point in time from which onwards the route is no longer valid. If NULL, the route is valid indefinitely after the start time of the validity period.';
COMMENT ON COLUMN
  route.route.priority IS
  'The priority of the route definition. The definition may be overridden by higher priority definitions.';
COMMENT ON COLUMN
  route.route.label IS
  'The label of the route definition, label and direction together are unique for a certain priority and validity period.';
COMMENT ON COLUMN
  route.route.direction IS
  'The direction of the route definition, label and direction together are unique for a certain priority and validity period.';

ALTER FUNCTION route.insert_route ()
RENAME TO insert_route_1652181447341;

ALTER FUNCTION route.insert_route_1652181447341 ()
SET SCHEMA deleted;

CREATE FUNCTION route.insert_route ()
  RETURNS TRIGGER
  LANGUAGE plpgsql
AS $route_insert_route$
BEGIN
  INSERT INTO internal_route.route (
    name_i18n,
    description_i18n,
    origin_name_i18n,
    origin_short_name_i18n,
    destination_name_i18n,
    destination_short_name_i18n,
    starts_from_scheduled_stop_point_id,
    ends_at_scheduled_stop_point_id,
    on_line_id,
    validity_start,
    validity_end,
    priority,
    label,
    direction
  ) VALUES (
    NEW.name_i18n,
    NEW.description_i18n,
    NEW.origin_name_i18n,
    NEW.origin_short_name_i18n,
    NEW.destination_name_i18n,
    NEW.destination_short_name_i18n,
    NEW.starts_from_scheduled_stop_point_id,
    NEW.ends_at_scheduled_stop_point_id,
    NEW.on_line_id,
    NEW.validity_start,
    NEW.validity_end,
    NEW.priority,
    NEW.label,
    NEW.direction
  ) RETURNING route_id INTO NEW.route_id;
  RETURN NEW;
END;
$route_insert_route$;

ALTER FUNCTION route.update_route ()
  RENAME TO update_route_1652181447341;

ALTER FUNCTION route.update_route_1652181447341 ()
  SET SCHEMA deleted;

CREATE FUNCTION route.update_route ()
  RETURNS TRIGGER
  LANGUAGE plpgsql
AS $route_update_route$
BEGIN
  UPDATE internal_route.route
  SET
    route_id = NEW.route_id,
    name_i18n = NEW.name_i18n,
    description_i18n = NEW.description_i18n,
    origin_name_i18n = NEW.origin_name_i18n,
    origin_short_name_i18n = NEW.origin_short_name_i18n,
    destination_name_i18n = NEW.destination_name_i18n,
    destination_short_name_i18n = NEW.destination_short_name_i18n,
    starts_from_scheduled_stop_point_id = NEW.starts_from_scheduled_stop_point_id,
    ends_at_scheduled_stop_point_id = NEW.ends_at_scheduled_stop_point_id,
    on_line_id = NEW.on_line_id,
    validity_start = NEW.validity_start,
    validity_end = NEW.validity_end,
    priority = NEW.priority,
    label = NEW.label,
    direction = NEW.direction
  WHERE route_id = OLD.route_id;
  RETURN NEW;
END;
$route_update_route$;

-- Deletion works the same way as before, because it does not reference the new columns.

CREATE TRIGGER route_insert_route_trigger
  INSTEAD OF INSERT ON route.route
  FOR EACH ROW EXECUTE PROCEDURE route.insert_route();

CREATE TRIGGER route_update_route_trigger
  INSTEAD OF UPDATE ON route.route
  FOR EACH ROW EXECUTE PROCEDURE route.update_route();

CREATE TRIGGER route_delete_route_trigger
  INSTEAD OF DELETE ON route.route
  FOR EACH ROW EXECUTE PROCEDURE route.delete_route();

-- fail migration for debugging
-- DROP TABLE foo;
