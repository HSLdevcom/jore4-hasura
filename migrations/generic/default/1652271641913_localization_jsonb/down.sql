-- revert changes to route.route columns
DROP INDEX route.idx_route_name_i18n;
DROP INDEX route.idx_route_origin_name_i18n;
DROP INDEX route.idx_route_origin_short_name_i18n;
DROP INDEX route.idx_route_destination_name_i18n;
DROP INDEX route.idx_route_destination_short_name_i18n;
ALTER TABLE route.route
    DROP COLUMN name_i18n,
    ALTER COLUMN description_i18n SET DATA TYPE text,
    DROP COLUMN origin_name_i18n,
    DROP COLUMN origin_short_name_i18n,
    DROP COLUMN destination_name_i18n,
    DROP COLUMN destination_short_name_i18n;

-- revert changes to route.line
DROP INDEX route.idx_line_name_i18n;
DROP INDEX route.idx_line_short_name_i18n;
ALTER TABLE route.line
    ALTER COLUMN name_i18n SET DATA TYPE text,
    ALTER COLUMN name_i18n SET NOT NULL,
    ALTER COLUMN short_name_i18n SET DATA TYPE text,
    ALTER COLUMN short_name_i18n SET NOT NULL;

-- recreate deleted views
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
