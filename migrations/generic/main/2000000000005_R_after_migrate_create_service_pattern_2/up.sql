
CREATE OR REPLACE FUNCTION network.check_scheduled_stop_point_infrastructure_link_direction() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  link_dir TEXT;
BEGIN
  SELECT infrastructure_network.infrastructure_link.direction
  FROM infrastructure_network.infrastructure_link
  INTO link_dir
  WHERE infrastructure_network.infrastructure_link.infrastructure_link_id = NEW.located_on_infrastructure_link_id;

  IF (NEW.direction = 'forward' AND link_dir = 'backward') OR
     (NEW.direction = 'backward' AND link_dir = 'forward') OR
     (NEW.direction = 'bidirectional' AND link_dir != 'bidirectional')
  THEN
    RAISE EXCEPTION 'scheduled stop point direction must be compatible with infrastructure link direction';
  END IF;

  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION network.check_scheduled_stop_point_vehicle_mode_by_infra_link() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS(
    SELECT 1
    FROM reusable_components.vehicle_submode
           JOIN network.vehicle_mode_on_scheduled_stop_point
                ON network.vehicle_mode_on_scheduled_stop_point.vehicle_mode =
                   reusable_components.vehicle_submode.belonging_to_vehicle_mode
           JOIN network.scheduled_stop_point
                ON network.scheduled_stop_point.scheduled_stop_point_id =
                   network.vehicle_mode_on_scheduled_stop_point.scheduled_stop_point_id
    WHERE reusable_components.vehicle_submode.vehicle_submode = OLD.vehicle_submode
      AND network.scheduled_stop_point.located_on_infrastructure_link_id = OLD.infrastructure_link_id
    )
  THEN
    RAISE
      EXCEPTION 'cannot remove relationship between scheduled stop point vehicle mode and infrastructure link vehicle submodes';
  END IF;
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION network.check_scheduled_stop_point_vehicle_mode_by_scheduled_stop_point() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NOT EXISTS(
    SELECT 1
    FROM network.vehicle_mode_on_scheduled_stop_point
           JOIN network.scheduled_stop_point
                ON network.scheduled_stop_point.scheduled_stop_point_id =
                   network.vehicle_mode_on_scheduled_stop_point.scheduled_stop_point_id
           JOIN infrastructure_network.infrastructure_link
                ON infrastructure_network.infrastructure_link.infrastructure_link_id =
                   network.scheduled_stop_point.located_on_infrastructure_link_id
           JOIN infrastructure_network.vehicle_submode_on_infrastructure_link
                ON infrastructure_network.vehicle_submode_on_infrastructure_link.infrastructure_link_id =
                   infrastructure_network.infrastructure_link.infrastructure_link_id
           JOIN reusable_components.vehicle_submode ON reusable_components.vehicle_submode.vehicle_submode =
                                                       infrastructure_network.vehicle_submode_on_infrastructure_link.vehicle_submode
    WHERE network.vehicle_mode_on_scheduled_stop_point.vehicle_mode =
          reusable_components.vehicle_submode.belonging_to_vehicle_mode
      AND network.scheduled_stop_point.scheduled_stop_point_id = NEW.scheduled_stop_point_id
    )
  THEN
    RAISE EXCEPTION 'scheduled stop point vehicle mode must be compatible with allowed infrastructure link vehicle submodes';
  END IF;

  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION network.check_scheduled_stop_point_vehicle_mode_by_vehicle_mode() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS(
       SELECT 1
       FROM network.vehicle_mode_on_scheduled_stop_point
              JOIN network.scheduled_stop_point
                   ON network.scheduled_stop_point.scheduled_stop_point_id =
                      network.vehicle_mode_on_scheduled_stop_point.scheduled_stop_point_id
              JOIN infrastructure_network.infrastructure_link
                   ON infrastructure_network.infrastructure_link.infrastructure_link_id =
                      network.scheduled_stop_point.located_on_infrastructure_link_id
              JOIN infrastructure_network.vehicle_submode_on_infrastructure_link
                   ON infrastructure_network.vehicle_submode_on_infrastructure_link.infrastructure_link_id =
                      infrastructure_network.infrastructure_link.infrastructure_link_id
              JOIN reusable_components.vehicle_submode ON reusable_components.vehicle_submode.vehicle_submode =
                                                          infrastructure_network.vehicle_submode_on_infrastructure_link.vehicle_submode
       WHERE network.vehicle_mode_on_scheduled_stop_point.vehicle_mode =
             reusable_components.vehicle_submode.belonging_to_vehicle_mode
         AND network.scheduled_stop_point.scheduled_stop_point_id = OLD.scheduled_stop_point_id
       )
    !=
     EXISTS(
       SELECT 1
       FROM network.scheduled_stop_point
       WHERE network.scheduled_stop_point.scheduled_stop_point_id = OLD.scheduled_stop_point_id
       )
  THEN
    RAISE EXCEPTION 'scheduled stop point must be assigned a vehicle mode which is compatible with allowed infrastructure link vehicle submodes';
  END IF;

  RETURN OLD;
END;
$$;

CREATE OR REPLACE FUNCTION network.delete_scheduled_stop_point_label(old_label text) RETURNS void
    LANGUAGE sql
    AS $$
DELETE FROM network.scheduled_stop_point_invariant
WHERE label = old_label
  AND NOT EXISTS (SELECT 1 FROM network.scheduled_stop_point WHERE label = old_label);
$$;

CREATE OR REPLACE FUNCTION network.insert_scheduled_stop_point_label(new_label text) RETURNS void
    LANGUAGE sql
    AS $$
INSERT INTO network.scheduled_stop_point_invariant (label)
VALUES (new_label)
ON CONFLICT (label)
  DO NOTHING;
$$;

CREATE OR REPLACE FUNCTION network.on_delete_scheduled_stop_point() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM network.delete_scheduled_stop_point_label(OLD.label);
  RETURN OLD;
END;
$$;

CREATE OR REPLACE FUNCTION network.on_insert_scheduled_stop_point() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM network.insert_scheduled_stop_point_label(NEW.label);
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION network.on_update_scheduled_stop_point() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM network.insert_scheduled_stop_point_label(NEW.label);
  PERFORM network.delete_scheduled_stop_point_label(OLD.label);
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION network.scheduled_stop_point_closest_point_on_infrastructure_link(ssp network.scheduled_stop_point) RETURNS public.geography
    LANGUAGE sql STABLE
    AS $$
  SELECT
    internal_utils.st_closestpoint(il.shape, ssp.measured_location) AS closest_point_on_infrastructure_link
  FROM infrastructure_network.infrastructure_link il
  WHERE ssp.located_on_infrastructure_link_id = il.infrastructure_link_id;
$$;
COMMENT ON FUNCTION network.scheduled_stop_point_closest_point_on_infrastructure_link IS 'The point on the infrastructure link closest to measured_location. A PostGIS PointZ geography in EPSG:4326.';

CREATE OR REPLACE FUNCTION network.ssp_relative_distance_from_infrastructure_link_start(ssp network.scheduled_stop_point) RETURNS double precision
    LANGUAGE sql STABLE
    AS $$
  SELECT
    internal_utils.st_linelocatepoint(il.shape, ssp.measured_location) AS relative_distance_from_infrastructure_link_start
  FROM infrastructure_network.infrastructure_link il
  WHERE ssp.located_on_infrastructure_link_id = il.infrastructure_link_id;
$$;
COMMENT ON FUNCTION network.ssp_relative_distance_from_infrastructure_link_start IS 'The relative distance of the stop from the start of the linestring along the infrastructure link. Regardless of the specified direction, this value is the distance from the beginning of the linestring. The distance is normalized to the closed interval [0, 1].';

ALTER TABLE ONLY network.scheduled_stop_point
    ADD CONSTRAINT unique_validity_period EXCLUDE USING gist (label WITH =, priority WITH =, internal_utils.daterange_closed_upper(validity_start, validity_end) WITH &&) WHERE ((priority < internal_utils.const_priority_draft()));

DROP TRIGGER IF EXISTS scheduled_stop_point_vehicle_mode_by_infra_link_trigger ON infrastructure_network.vehicle_submode_on_infrastructure_link;
CREATE CONSTRAINT TRIGGER scheduled_stop_point_vehicle_mode_by_infra_link_trigger AFTER DELETE ON infrastructure_network.vehicle_submode_on_infrastructure_link DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION network.check_scheduled_stop_point_vehicle_mode_by_infra_link();
DROP TRIGGER IF EXISTS check_scheduled_stop_point_infrastructure_link_direction_trigge ON network.scheduled_stop_point;
CREATE CONSTRAINT TRIGGER check_scheduled_stop_point_infrastructure_link_direction_trigge AFTER INSERT OR UPDATE ON network.scheduled_stop_point DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION network.check_scheduled_stop_point_infrastructure_link_direction();
DROP TRIGGER IF EXISTS prevent_update_of_vehicle_mode_on_scheduled_stop_point ON network.vehicle_mode_on_scheduled_stop_point;
CREATE TRIGGER prevent_update_of_vehicle_mode_on_scheduled_stop_point BEFORE UPDATE ON network.vehicle_mode_on_scheduled_stop_point FOR EACH ROW EXECUTE FUNCTION internal_utils.prevent_update();
DROP TRIGGER IF EXISTS queue_verify_infra_link_stop_refs_on_ssp_delete_trigger ON network.scheduled_stop_point;
CREATE TRIGGER queue_verify_infra_link_stop_refs_on_ssp_delete_trigger AFTER DELETE ON network.scheduled_stop_point REFERENCING OLD TABLE AS old_table FOR EACH STATEMENT EXECUTE FUNCTION network.queue_verify_infra_link_stop_refs_by_old_ssp_label();
COMMENT ON TRIGGER queue_verify_infra_link_stop_refs_on_ssp_delete_trigger ON network.scheduled_stop_point IS 'Trigger to verify the infra link <-> scheduled stop point references.
      Deleting a scheduled_stop_point instance can break the route consistency in the following ways:
      1. The deleted stop point instance may "reveal" a lower priority stop point instance, which may make the route and
         journey pattern conflict in the ways described above (see trigger for insertion of a row in the
         scheduled_stop_point table).
      2. The updated stop point might not anymore have any instances whose validity time would at all overlap with the
         journey pattern''s route''s validity time ("ghost stop").';
DROP TRIGGER IF EXISTS queue_verify_infra_link_stop_refs_on_ssp_insert_trigger ON network.scheduled_stop_point;
CREATE TRIGGER queue_verify_infra_link_stop_refs_on_ssp_insert_trigger AFTER INSERT ON network.scheduled_stop_point REFERENCING NEW TABLE AS new_table FOR EACH STATEMENT EXECUTE FUNCTION network.queue_verify_infra_link_stop_refs_by_new_ssp_label();
COMMENT ON TRIGGER queue_verify_infra_link_stop_refs_on_ssp_insert_trigger ON network.scheduled_stop_point IS 'Trigger to verify the infra link <-> scheduled stop point references.
      Inserting a scheduled_stop_point instance can break the route consistency in the following ways:
      1. The new stop point instance might be located on an infra link which is not part of all of its journey
         pattern''s routes.
      2. The stop point instance might be located on an infra link, whose position in a route does not correspond to the
         position of the stop point in the corresponding journey pattern.';
DROP TRIGGER IF EXISTS queue_verify_infra_link_stop_refs_on_ssp_update_trigger ON network.scheduled_stop_point;
CREATE TRIGGER queue_verify_infra_link_stop_refs_on_ssp_update_trigger AFTER UPDATE ON network.scheduled_stop_point REFERENCING NEW TABLE AS new_table FOR EACH STATEMENT EXECUTE FUNCTION network.queue_verify_infra_link_stop_refs_by_new_ssp_label();
COMMENT ON TRIGGER queue_verify_infra_link_stop_refs_on_ssp_update_trigger ON network.scheduled_stop_point IS 'Trigger to verify the infra link <-> scheduled stop point references.
      Updating a scheduled_stop_point instance can break the route consistency in the following ways:
      1. The updated stop point instance might be located on an infra link which is not part of all of its journey
         pattern''s routes.
      2. The updated stop point instance might be located on an infra link, whose position in a route does not
         correspond to the position of the stop point in the corresponding journey pattern.
      3. The deleted stop point instance may "reveal" a lower priority stop point instance (by change of validity time),
         which may make the route and journey pattern conflict in the ways described above with regard to the revealed
         stop point.
      4. The updated stop point might not anymore have any instances whose validity time would at all overlap with the
         journey pattern''s route''s validity time ("ghost stop").';
DROP TRIGGER IF EXISTS scheduled_stop_point_vehicle_mode_by_scheduled_stop_point_trigg ON network.scheduled_stop_point;
CREATE CONSTRAINT TRIGGER scheduled_stop_point_vehicle_mode_by_scheduled_stop_point_trigg AFTER INSERT OR UPDATE ON network.scheduled_stop_point DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION network.check_scheduled_stop_point_vehicle_mode_by_scheduled_stop_point();
DROP TRIGGER IF EXISTS scheduled_stop_point_vehicle_mode_by_vehicle_mode_trigger ON network.vehicle_mode_on_scheduled_stop_point;
CREATE CONSTRAINT TRIGGER scheduled_stop_point_vehicle_mode_by_vehicle_mode_trigger AFTER DELETE ON network.vehicle_mode_on_scheduled_stop_point DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION network.check_scheduled_stop_point_vehicle_mode_by_vehicle_mode();
DROP TRIGGER IF EXISTS service_pattern_delete_scheduled_stop_point_trigger ON network.scheduled_stop_point;
CREATE TRIGGER service_pattern_delete_scheduled_stop_point_trigger AFTER DELETE ON network.scheduled_stop_point FOR EACH ROW EXECUTE FUNCTION network.on_delete_scheduled_stop_point();
DROP TRIGGER IF EXISTS service_pattern_insert_scheduled_stop_point_trigger ON network.scheduled_stop_point;
CREATE TRIGGER service_pattern_insert_scheduled_stop_point_trigger BEFORE INSERT ON network.scheduled_stop_point FOR EACH ROW EXECUTE FUNCTION network.on_insert_scheduled_stop_point();
DROP TRIGGER IF EXISTS service_pattern_update_scheduled_stop_point_trigger ON network.scheduled_stop_point;
CREATE TRIGGER service_pattern_update_scheduled_stop_point_trigger BEFORE UPDATE ON network.scheduled_stop_point FOR EACH ROW EXECUTE FUNCTION network.on_update_scheduled_stop_point();
DROP TRIGGER IF EXISTS verify_infra_link_stop_refs_on_scheduled_stop_point_trigger ON network.scheduled_stop_point;
CREATE CONSTRAINT TRIGGER verify_infra_link_stop_refs_on_scheduled_stop_point_trigger AFTER INSERT OR DELETE OR UPDATE ON network.scheduled_stop_point DEFERRABLE INITIALLY DEFERRED FOR EACH ROW WHEN ((NOT network.infra_link_stop_refs_already_verified())) EXECUTE FUNCTION network.verify_infra_link_stop_refs();
COMMENT ON TRIGGER verify_infra_link_stop_refs_on_scheduled_stop_point_trigger ON network.scheduled_stop_point IS 'Trigger to verify the infra link <-> stop references after an insert, update, or delete on the
   scheduled_stop_point table.

   This trigger will cause those routes to be checked, whose ID was queued to be checked by a statement
   level trigger.';
