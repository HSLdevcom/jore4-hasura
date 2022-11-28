
CREATE OR REPLACE FUNCTION route.check_line_routes_priorities() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS(
    SELECT 1
    FROM route.line
    JOIN route.route ON route.route.on_line_id = route.line.line_id
    WHERE route.line.line_id = NEW.line_id
    AND route.line.priority > route.route.priority
  )
  THEN
    RAISE EXCEPTION 'route priority must be >= line priority';
  END IF;

  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION route.check_line_validity_against_all_associated_routes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS(
    SELECT 1
    FROM route.route r
    WHERE r.on_line_id = NEW.line_id
      AND ((NEW.validity_start IS NOT NULL AND (NEW.validity_start > r.validity_start OR r.validity_start IS NULL)) OR
           (NEW.validity_end IS NOT NULL AND (NEW.validity_end < r.validity_end OR r.validity_end IS NULL)))
    )
  THEN
    RAISE EXCEPTION 'line validity period must span all its routes'' validity periods';
  END IF;

  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION route.check_route_line_priorities() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  line_prio INT;
BEGIN
  SELECT route.line.priority
  FROM route.line
  INTO line_prio
  WHERE route.line.line_id = NEW.on_line_id;

  IF NEW.priority < line_prio
  THEN
    RAISE EXCEPTION 'route priority must be >= line priority';
  END IF;

  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION route.check_route_link_infrastructure_link_direction() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  link_dir TEXT;
BEGIN
  SELECT infrastructure_network.infrastructure_link.direction
  FROM infrastructure_network.infrastructure_link
  INTO link_dir WHERE infrastructure_network.infrastructure_link.
  infrastructure_link_id = NEW.infrastructure_link_id;

  -- NB: link_dir = 'bidirectional' allows both traversal directions
  IF (NEW.is_traversal_forwards = TRUE AND link_dir = 'backward') OR
     (NEW.is_traversal_forwards = FALSE AND link_dir = 'forward')
  THEN
    RAISE EXCEPTION 'route link direction must be compatible with infrastructure link direction';
  END IF;

  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION route.check_route_validity_is_within_line_validity() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  line_validity_start date;
  line_validity_end   date;
BEGIN
  SELECT l.validity_start, l.validity_end
  FROM route.line l
  INTO line_validity_start, line_validity_end
    WHERE l.line_id = NEW.on_line_id;

  IF (line_validity_start IS NOT NULL AND (NEW.validity_start < line_validity_start OR NEW.validity_start IS NULL)) OR
     (line_validity_end IS NOT NULL AND (NEW.validity_end > line_validity_end OR NEW.validity_end IS NULL))
  THEN
    RAISE EXCEPTION 'route validity period must lie within its line''s validity period';
  END IF;

  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION route.check_type_of_line_vehicle_mode() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NOT EXISTS(
    SELECT 1
    FROM route.line
           JOIN route.type_of_line
                ON route.type_of_line.type_of_line = NEW.type_of_line
    WHERE route.type_of_line.belonging_to_vehicle_mode = NEW.primary_vehicle_mode
    )
  THEN
    RAISE EXCEPTION 'type of line must match lines primary vehicle mode';
  END IF;

  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION route.delete_route() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  DELETE FROM internal_route.route
  WHERE route_id = OLD.route_id;
  RETURN OLD;
END;
$$;

CREATE OR REPLACE FUNCTION route.insert_route() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO internal_route.route (
    description_i18n,
    starts_from_scheduled_stop_point_id,
    ends_at_scheduled_stop_point_id,
    on_line_id,
    validity_start,
    validity_end,
    priority,
    label,
    direction,
    variant
  ) VALUES (
    NEW.description_i18n,
    NEW.starts_from_scheduled_stop_point_id,
    NEW.ends_at_scheduled_stop_point_id,
    NEW.on_line_id,
    NEW.validity_start,
    NEW.validity_end,
    NEW.priority,
    NEW.label,
    NEW.direction,
    NEW.variant
  ) RETURNING route_id INTO NEW.route_id;
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION route.route_shape(route_row route.route) RETURNS public.geography
    LANGUAGE sql STABLE
    AS $$
  SELECT
    ST_MakeLine(
      CASE
        WHEN ilar.is_traversal_forwards THEN il.shape::geometry
        ELSE ST_Reverse(il.shape::geometry)
      END
        ORDER BY ilar.infrastructure_link_sequence
    )::geography AS route_shape
  FROM
    route.route r
      LEFT JOIN (
      route.infrastructure_link_along_route AS ilar
        INNER JOIN infrastructure_network.infrastructure_link AS il
        ON (ilar.infrastructure_link_id = il.infrastructure_link_id)
      ) ON (route_row.route_id = ilar.route_id)
    WHERE r.route_id = route_row.route_id;
$$;

CREATE OR REPLACE FUNCTION route.update_route() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
    direction = NEW.direction,
    variant = NEW.variant
  WHERE route_id = OLD.route_id;
  RETURN NEW;
END;
$$;

ALTER TABLE ONLY route.route
    ADD CONSTRAINT route_unique_validity_period EXCLUDE USING gist (label WITH =, coalesce(variant,-1) WITH =, direction WITH =, priority WITH =, internal_utils.daterange_closed_upper(validity_start, validity_end) WITH &&) WHERE ((priority < internal_utils.const_priority_draft()));
ALTER TABLE ONLY route.line
    ADD CONSTRAINT line_unique_validity_period EXCLUDE USING gist (label WITH =, priority WITH =, internal_utils.daterange_closed_upper(validity_start, validity_end) WITH &&) WHERE ((priority < internal_utils.const_priority_draft()));

DROP TRIGGER IF EXISTS check_line_routes_priorities_trigger ON route.line;
CREATE CONSTRAINT TRIGGER check_line_routes_priorities_trigger AFTER UPDATE ON route.line DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION route.check_line_routes_priorities();
DROP TRIGGER IF EXISTS check_line_validity_against_all_associated_routes_trigger ON route.line;
CREATE CONSTRAINT TRIGGER check_line_validity_against_all_associated_routes_trigger AFTER UPDATE ON route.line DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION route.check_line_validity_against_all_associated_routes();
DROP TRIGGER IF EXISTS check_route_line_priorities_trigger ON route.route;
CREATE CONSTRAINT TRIGGER check_route_line_priorities_trigger AFTER INSERT OR UPDATE ON route.route DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION route.check_route_line_priorities();
DROP TRIGGER IF EXISTS check_route_link_infrastructure_link_direction_trigger ON route.infrastructure_link_along_route;
CREATE CONSTRAINT TRIGGER check_route_link_infrastructure_link_direction_trigger AFTER INSERT OR UPDATE ON route.infrastructure_link_along_route DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION route.check_route_link_infrastructure_link_direction();
DROP TRIGGER IF EXISTS check_route_validity_is_within_line_validity_trigger ON route.route;
CREATE CONSTRAINT TRIGGER check_route_validity_is_within_line_validity_trigger AFTER INSERT OR UPDATE ON route.route DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION route.check_route_validity_is_within_line_validity();
DROP TRIGGER IF EXISTS check_type_of_line_vehicle_mode_trigger ON route.line;
CREATE CONSTRAINT TRIGGER check_type_of_line_vehicle_mode_trigger AFTER INSERT OR UPDATE ON route.line DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION route.check_type_of_line_vehicle_mode();
DROP TRIGGER IF EXISTS queue_verify_infra_link_stop_refs_on_ilar_delete_trigger ON route.infrastructure_link_along_route;
CREATE TRIGGER queue_verify_infra_link_stop_refs_on_ilar_delete_trigger AFTER DELETE ON route.infrastructure_link_along_route REFERENCING OLD TABLE AS old_table FOR EACH STATEMENT EXECUTE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_id();
COMMENT ON TRIGGER queue_verify_infra_link_stop_refs_on_ilar_delete_trigger ON route.infrastructure_link_along_route IS 'Trigger to verify the infra link <-> scheduled stop point references.
      Deleting an infrastructure_link_along_route -row can break the route consistency in such a way that
      an infra link associated with a stop point on journey pattern might not be part of the route anymore.';
DROP TRIGGER IF EXISTS queue_verify_infra_link_stop_refs_on_ilar_update_trigger ON route.infrastructure_link_along_route;
CREATE TRIGGER queue_verify_infra_link_stop_refs_on_ilar_update_trigger AFTER UPDATE ON route.infrastructure_link_along_route REFERENCING OLD TABLE AS old_table FOR EACH STATEMENT EXECUTE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_id();
COMMENT ON TRIGGER queue_verify_infra_link_stop_refs_on_ilar_update_trigger ON route.infrastructure_link_along_route IS 'Trigger to verify the infra link <-> scheduled stop point references.
      Updating an infrastructure_link_along_route -row can break the route consistency in such a way that
      an infra link associated with a stop point on a journey pattern might not be part of the (journey pattern''s)
      route anymore.';
DROP TRIGGER IF EXISTS queue_verify_infra_link_stop_refs_on_route_delete_trigger ON route.route;
CREATE TRIGGER queue_verify_infra_link_stop_refs_on_route_delete_trigger AFTER DELETE ON route.route REFERENCING OLD TABLE AS old_table FOR EACH STATEMENT EXECUTE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_label();
COMMENT ON TRIGGER queue_verify_infra_link_stop_refs_on_route_delete_trigger ON route.route IS 'Trigger to verify the infra link <-> scheduled stop point references.
      Deleting a route row can "reveal" a lower priority route instance (which was not valid before), which may be
      break the route consistency such that:
      1. The revealed route''s journey pattern may contain a stop point, which is located on an infra link not part of
         the revealed route.
      2. The revealed route''s journey pattern may contain a stop point located at a position in the journey pattern,
         which does not correspond to the position of the stop point''s infra link within the revealed route.
      3. A stop point of the revealed route''s journey pattern might not have any instances whose validity time overlap
         at all with the revealed route''s validity time ("ghost stop").';
DROP TRIGGER IF EXISTS truncate_sspijp_on_ilar_truncate_trigger ON route.infrastructure_link_along_route;
CREATE TRIGGER truncate_sspijp_on_ilar_truncate_trigger AFTER TRUNCATE ON route.infrastructure_link_along_route FOR EACH STATEMENT EXECUTE FUNCTION journey_pattern.truncate_scheduled_stop_point_in_journey_pattern();
DROP TRIGGER IF EXISTS verify_infra_link_stop_refs_on_ilar_trigger ON route.infrastructure_link_along_route;
CREATE CONSTRAINT TRIGGER verify_infra_link_stop_refs_on_ilar_trigger AFTER DELETE OR UPDATE ON route.infrastructure_link_along_route DEFERRABLE INITIALLY DEFERRED FOR EACH ROW WHEN ((NOT journey_pattern.infra_link_stop_refs_already_verified())) EXECUTE FUNCTION journey_pattern.verify_infra_link_stop_refs();
COMMENT ON TRIGGER verify_infra_link_stop_refs_on_ilar_trigger ON route.infrastructure_link_along_route IS 'Trigger to verify the infra link <-> stop references after an update or delete on the
   infrastructure_link_along_route table.

   This trigger will cause those routes to be checked, whose ID was queued to be checked by a statement
   level trigger.';
DROP TRIGGER IF EXISTS verify_infra_link_stop_refs_on_route_trigger ON route.route;
CREATE CONSTRAINT TRIGGER verify_infra_link_stop_refs_on_route_trigger AFTER DELETE ON route.route DEFERRABLE INITIALLY DEFERRED FOR EACH ROW WHEN ((NOT journey_pattern.infra_link_stop_refs_already_verified())) EXECUTE FUNCTION journey_pattern.verify_infra_link_stop_refs();

ALTER TABLE route.route
    ADD CONSTRAINT route_variant_unsigned_check CHECK (variant >= 0);
