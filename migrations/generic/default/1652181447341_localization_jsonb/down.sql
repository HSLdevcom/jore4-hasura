-- revert changes to route.line
DROP INDEX idx_line_name_i18n;
DROP INDEX idx_line_short_name_i18n;
ALTER TABLE route.line
    ALTER COLUMN name_i18n SET DATA TYPE text,
    ALTER COLUMN name_i18n SET NOT NULL,
    ALTER COLUMN short_name_i18n SET DATA TYPE text,
    ALTER COLUMN short_name_i18n DROP NOT NULL;

-- drop route.route view as we're going to change the underlying table's data types
DROP VIEW route.route;

-- revert changes to internal_route.route columns
DROP INDEX idx_route_name_i18n;
DROP INDEX idx_route_origin_name_i18n;
DROP INDEX idx_route_origin_short_name_i18n;
DROP INDEX idx_route_destination_name_i18n;
DROP INDEX idx_route_destination_short_name_i18n;
ALTER TABLE internal_route.route
    DROP COLUMN name_i18n,
    ALTER COLUMN description_i18n SET DATA TYPE text,
    DROP COLUMN origin_name_i18n,
    DROP COLUMN origin_short_name_i18n,
    DROP COLUMN destination_name_i18n,
    DROP COLUMN destination_short_name_i18n;

-- recreate old route.route view
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
