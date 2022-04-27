-- modify route.route view to include localized description fields

ALTER VIEW route.route
RENAME TO route_1651054214739;

ALTER VIEW route.route_1651054214739
SET SCHEMA deleted;

CREATE VIEW route.route AS
SELECT
  r.route_id,
  r.description_i18n,
  lti.localized_text_fi AS description_fi,
  lti.localized_text_sv AS description_sv,
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
    LEFT JOIN (
      SELECT *
      FROM localization.localized_texts_inline
      WHERE codeset_name = 'route_description'
    ) lti ON (lti.entity_id = r.route_id)
GROUP BY r.route_id, lti.localized_text_fi, lti.localized_text_sv;
COMMENT ON VIEW
  route.route IS
  'The routes from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:1:3:483';
COMMENT ON COLUMN
  route.route.route_id IS
  'The ID of the route.';
COMMENT ON COLUMN
  route.route.description_i18n IS
  'Deprecated. The description of the route in the form of starting location - destination. Placeholder for multilingual strings.';
COMMENT ON COLUMN
  route.route.description_fi IS
  'The Finnish description of the route in the form of starting location - destination.';
COMMENT ON COLUMN
  route.route.description_sv IS
  'The Swedish description of the route in the form of starting location - destination.';
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
RENAME TO insert_route_1651054214739;

ALTER FUNCTION route.insert_route_1651054214739 ()
SET SCHEMA deleted;

CREATE FUNCTION route.insert_route ()
  RETURNS TRIGGER
  LANGUAGE plpgsql
AS $route_insert_route$
BEGIN
  -- insert route
  INSERT INTO internal_route.route (
    description_i18n,
    starts_from_scheduled_stop_point_id,
    ends_at_scheduled_stop_point_id,
    on_line_id,
    validity_start,
    validity_end,
    priority,
    label,
    direction
  ) VALUES (
    NEW.description_i18n,
    NEW.starts_from_scheduled_stop_point_id,
    NEW.ends_at_scheduled_stop_point_id,
    NEW.on_line_id,
    NEW.validity_start,
    NEW.validity_end,
    NEW.priority,
    NEW.label,
    NEW.direction
  ) RETURNING route_id INTO NEW.route_id;

  -- insert Finnish description
  PERFORM localization.upsert_localized_text (
    NEW.route_id,
    'route_description',
    'fi_FI',
    NEW.description_fi
  );

  -- insert Swedish description
  PERFORM localization.upsert_localized_text (
    NEW.route_id,
    'route_description',
    'sv_SV',
    NEW.description_sv
  );

  RETURN NEW;
END;
$route_insert_route$;

ALTER FUNCTION route.update_route ()
  RENAME TO update_route_1651054214739;

ALTER FUNCTION route.update_route_1651054214739 ()
  SET SCHEMA deleted;

CREATE FUNCTION route.update_route ()
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
    priority = NEW.priority,
    label = NEW.label,
    direction = NEW.direction
  WHERE route_id = OLD.route_id;

  -- insert Finnish description
  PERFORM localization.upsert_localized_text (
    NEW.route_id,
    'route_description',
    'fi_FI',
    NEW.description_fi
  );

  -- insert Swedish description
  PERFORM localization.upsert_localized_text (
    NEW.route_id,
    'route_description',
    'sv_SV',
    NEW.description_sv
  );

  RETURN NEW;
END;
$route_update_route$;

ALTER FUNCTION route.delete_route ()
  RENAME TO delete_route_1651054214739;

ALTER FUNCTION route.delete_route_1651054214739 ()
  SET SCHEMA deleted;

CREATE FUNCTION route.delete_route ()
  RETURNS TRIGGER
  LANGUAGE plpgsql
AS $route_delete_route$
BEGIN
  -- delete route
  DELETE FROM internal_route.route
  WHERE route_id = OLD.route_id;

  -- delete localizations
  DELETE FROM localization.localized_texts
  WHERE entity_id = OLD.route_id;

  RETURN OLD;
END;
$route_delete_route$;

CREATE TRIGGER route_insert_route_trigger
  INSTEAD OF INSERT ON route.route
  FOR EACH ROW EXECUTE PROCEDURE route.insert_route();

CREATE TRIGGER route_update_route_trigger
  INSTEAD OF UPDATE ON route.route
  FOR EACH ROW EXECUTE PROCEDURE route.update_route();

CREATE TRIGGER route_delete_route_trigger
  INSTEAD OF DELETE ON route.route
  FOR EACH ROW EXECUTE PROCEDURE route.delete_route();
