
-- scheduled_stop_point changes
-------------------------------

ALTER TABLE internal_service_pattern.scheduled_stop_point
ADD COLUMN validity_start TIMESTAMP,
ADD COLUMN validity_end TIMESTAMP,
ADD COLUMN priority INT NOT NULL;

CREATE OR REPLACE VIEW service_pattern.scheduled_stop_point AS
SELECT
  ssp.scheduled_stop_point_id,
  ssp.label,
  ssp.measured_location,
  ssp.located_on_infrastructure_link_id,
  ssp.direction,
  internal_utils.ST_LineLocatePoint(il.shape, ssp.measured_location) AS relative_distance_from_infrastructure_link_start,
  internal_utils.ST_ClosestPoint(il.shape, ssp.measured_location) AS closest_point_on_infrastructure_link,
  ssp.validity_start,
  ssp.validity_end,
  ssp.priority
FROM
  internal_service_pattern.scheduled_stop_point AS ssp
    INNER JOIN infrastructure_network.infrastructure_link AS il ON (ssp.located_on_infrastructure_link_id = il.infrastructure_link_id);
COMMENT ON COLUMN
  service_pattern.scheduled_stop_point.validity_start IS
  'The point in time when the stop becomes valid. If NULL, the stop has been always valid.';
COMMENT ON COLUMN
  service_pattern.scheduled_stop_point.validity_end IS
  'The point in time from which onwards the stop is no longer valid. If NULL, the stop will be always valid.';
COMMENT ON COLUMN
  service_pattern.scheduled_stop_point.priority IS
  'The priority of the stop definition. The definition may be overridden by higher priority definitions.';

CREATE OR REPLACE FUNCTION service_pattern.insert_scheduled_stop_point ()
  RETURNS TRIGGER
  LANGUAGE plpgsql
AS $service_pattern_insert_scheduled_stop_point$
BEGIN
  INSERT INTO internal_service_pattern.scheduled_stop_point (
    measured_location,
    located_on_infrastructure_link_id,
    direction,
    label,
    validity_start,
    validity_end,
    priority
  ) VALUES (
    NEW.measured_location,
    NEW.located_on_infrastructure_link_id,
    NEW.direction,
    NEW.label,
    NEW.validity_start,
    NEW.validity_end,
    NEW.priority
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
    label = NEW.label,
    validity_start = NEW.validity_start,
    validity_end = NEW.validity_end,
    priority = NEW.priority
  WHERE scheduled_stop_point_id = OLD.scheduled_stop_point_id;
  RETURN NEW;
END;
$service_pattern_update_scheduled_stop_point$;

-- Deletion works the same way as before, since it does not reference the new columns

-- route changes
----------------

ALTER TABLE internal_route.route
ADD COLUMN validity_start TIMESTAMP,
ADD COLUMN validity_end TIMESTAMP,
ADD COLUMN priority INT NOT NULL;

CREATE OR REPLACE VIEW route.route AS
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
  r.priority
FROM
  internal_route.route AS r
    LEFT JOIN (
    route.infrastructure_link_along_route AS ilar
      INNER JOIN infrastructure_network.infrastructure_link AS il
      ON (ilar.infrastructure_link_id = il.infrastructure_link_id)
    ) ON (r.route_id = ilar.route_id)
GROUP BY r.route_id;
COMMENT ON COLUMN
  route.route.validity_start IS
  'The point in time when the route becomes valid. If NULL, the route has been always valid.';
COMMENT ON COLUMN
  route.route.validity_end IS
  'The point in time from which onwards the route is no longer valid. If NULL, the route will be always valid.';
COMMENT ON COLUMN
  route.route.priority IS
  'The priority of the route definition. The definition may be overridden by higher priority definitions.';

CREATE OR REPLACE FUNCTION route.insert_route ()
  RETURNS TRIGGER
  LANGUAGE plpgsql
AS $route_insert_route$
BEGIN
  INSERT INTO internal_route.route (
    description_i18n,
    starts_from_scheduled_stop_point_id,
    ends_at_scheduled_stop_point_id,
    on_line_id,
    validity_start,
    validity_end,
    priority
  ) VALUES (
    NEW.description_i18n,
    NEW.starts_from_scheduled_stop_point_id,
    NEW.ends_at_scheduled_stop_point_id,
    NEW.on_line_id,
    NEW.validity_start,
    NEW.validity_end,
    NEW.priority
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
    on_line_id = NEW.on_line_id,
    validity_start = NEW.validity_start,
    validity_end = NEW.validity_end,
    priority = NEW.priority
  WHERE route_id = OLD.route_id;
  RETURN NEW;
END;
$route_update_route$;

-- Deletion works the same way as before, because it does not reference the new columns.


-- line changes
---------------

ALTER TABLE route.line
ADD COLUMN validity_start TIMESTAMP,
ADD COLUMN validity_end TIMESTAMP,
ADD COLUMN priority INT NOT NULL;
COMMENT ON COLUMN
  route.line.validity_start IS
  'The point in time when the line becomes valid. If NULL, the line has been always valid.';
COMMENT ON COLUMN
  route.line.validity_end IS
  'The point in time from which onwards the line is no longer valid. If NULL, the line will be always valid.';
COMMENT ON COLUMN
  route.line.priority IS
  'The priority of the line definition. The definition may be overridden by higher priority definitions.';
