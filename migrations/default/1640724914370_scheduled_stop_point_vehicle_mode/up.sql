-- Prevent the many-to-many vehicle_(sub)mode relationship tables from being updated.
-- This removes the need to create update triggers for those tables in order to check
-- the vehicle_(sub)mode relationship between infra links and scheduled stop points.
CREATE OR REPLACE FUNCTION public.prevent_update()
  RETURNS trigger
  LANGUAGE plpgsql AS
$$
BEGIN
  RAISE EXCEPTION 'update of table not allowed';
END;
$$;

CREATE TRIGGER prevent_update_of_vehicle_submode_on_infrastructure_link
  BEFORE UPDATE
  ON infrastructure_network.vehicle_submode_on_infrastructure_link
  FOR EACH ROW
EXECUTE PROCEDURE public.prevent_update();

CREATE TRIGGER prevent_update_of_vehicle_mode_on_scheduled_stop_point
  BEFORE UPDATE
  ON service_pattern.vehicle_mode_on_scheduled_stop_point
  FOR EACH ROW
EXECUTE PROCEDURE public.prevent_update();


CREATE FUNCTION service_pattern.check_scheduled_stop_point_vehicle_mode_by_scheduled_stop_point()
  RETURNS trigger
  LANGUAGE plpgsql AS
$$
BEGIN
  IF NOT EXISTS(
    SELECT 1
    FROM service_pattern.vehicle_mode_on_scheduled_stop_point
           JOIN internal_service_pattern.scheduled_stop_point
                ON internal_service_pattern.scheduled_stop_point.scheduled_stop_point_id =
                   service_pattern.vehicle_mode_on_scheduled_stop_point.scheduled_stop_point_id
           JOIN infrastructure_network.infrastructure_link
                ON infrastructure_network.infrastructure_link.infrastructure_link_id =
                   internal_service_pattern.scheduled_stop_point.located_on_infrastructure_link_id
           JOIN infrastructure_network.vehicle_submode_on_infrastructure_link
                ON infrastructure_network.vehicle_submode_on_infrastructure_link.infrastructure_link_id =
                   infrastructure_network.infrastructure_link.infrastructure_link_id
           JOIN reusable_components.vehicle_submode ON reusable_components.vehicle_submode.vehicle_submode =
                                                       infrastructure_network.vehicle_submode_on_infrastructure_link.vehicle_submode
    WHERE service_pattern.vehicle_mode_on_scheduled_stop_point.vehicle_mode =
          reusable_components.vehicle_submode.belonging_to_vehicle_mode
      AND internal_service_pattern.scheduled_stop_point.scheduled_stop_point_id = NEW.scheduled_stop_point_id
    )
  THEN
    RAISE EXCEPTION 'scheduled stop point vehicle mode must be compatible with allowed infrastructure link vehicle submodes';
  END IF;

  RETURN NEW;
END;
$$;

CREATE CONSTRAINT TRIGGER scheduled_stop_point_vehicle_mode_by_scheduled_stop_point_trigger
  AFTER INSERT OR UPDATE
  ON internal_service_pattern.scheduled_stop_point
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
EXECUTE PROCEDURE service_pattern.check_scheduled_stop_point_vehicle_mode_by_scheduled_stop_point();


CREATE FUNCTION service_pattern.check_scheduled_stop_point_vehicle_mode_by_vehicle_mode()
  RETURNS trigger
  LANGUAGE plpgsql AS
$$
BEGIN
  IF EXISTS(
       SELECT 1
       FROM service_pattern.vehicle_mode_on_scheduled_stop_point
              JOIN internal_service_pattern.scheduled_stop_point
                   ON internal_service_pattern.scheduled_stop_point.scheduled_stop_point_id =
                      service_pattern.vehicle_mode_on_scheduled_stop_point.scheduled_stop_point_id
              JOIN infrastructure_network.infrastructure_link
                   ON infrastructure_network.infrastructure_link.infrastructure_link_id =
                      internal_service_pattern.scheduled_stop_point.located_on_infrastructure_link_id
              JOIN infrastructure_network.vehicle_submode_on_infrastructure_link
                   ON infrastructure_network.vehicle_submode_on_infrastructure_link.infrastructure_link_id =
                      infrastructure_network.infrastructure_link.infrastructure_link_id
              JOIN reusable_components.vehicle_submode ON reusable_components.vehicle_submode.vehicle_submode =
                                                          infrastructure_network.vehicle_submode_on_infrastructure_link.vehicle_submode
       WHERE service_pattern.vehicle_mode_on_scheduled_stop_point.vehicle_mode =
             reusable_components.vehicle_submode.belonging_to_vehicle_mode
         AND internal_service_pattern.scheduled_stop_point.scheduled_stop_point_id = OLD.scheduled_stop_point_id
       )
    !=
     EXISTS(
       SELECT 1
       FROM internal_service_pattern.scheduled_stop_point
       WHERE internal_service_pattern.scheduled_stop_point.scheduled_stop_point_id = OLD.scheduled_stop_point_id
       )
  THEN
    RAISE EXCEPTION 'scheduled stop point must be assigned a vehicle mode which is compatible with allowed infrastructure link vehicle submodes';
  END IF;

  RETURN OLD;
END;
$$;

CREATE CONSTRAINT TRIGGER scheduled_stop_point_vehicle_mode_by_vehicle_mode_trigger
  AFTER DELETE
  ON service_pattern.vehicle_mode_on_scheduled_stop_point
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
EXECUTE PROCEDURE service_pattern.check_scheduled_stop_point_vehicle_mode_by_vehicle_mode();


CREATE FUNCTION service_pattern.check_scheduled_stop_point_vehicle_mode_by_infra_link()
  RETURNS trigger
  LANGUAGE plpgsql AS
$$
BEGIN
  IF EXISTS(
    SELECT 1
    FROM reusable_components.vehicle_submode
           JOIN service_pattern.vehicle_mode_on_scheduled_stop_point
                ON service_pattern.vehicle_mode_on_scheduled_stop_point.vehicle_mode =
                   reusable_components.vehicle_submode.belonging_to_vehicle_mode
           JOIN internal_service_pattern.scheduled_stop_point
                ON internal_service_pattern.scheduled_stop_point.scheduled_stop_point_id =
                   service_pattern.vehicle_mode_on_scheduled_stop_point.scheduled_stop_point_id
    WHERE reusable_components.vehicle_submode.vehicle_submode = OLD.vehicle_submode
      AND internal_service_pattern.scheduled_stop_point.located_on_infrastructure_link_id = OLD.infrastructure_link_id
    )
  THEN
    RAISE
      EXCEPTION 'cannot remove relationship between scheduled stop point vehicle mode and infrastructure link vehicle submodes';
  END IF;
  RETURN NEW;
END;
$$;

CREATE CONSTRAINT TRIGGER scheduled_stop_point_vehicle_mode_by_infra_link_trigger
  AFTER DELETE
  ON infrastructure_network.vehicle_submode_on_infrastructure_link
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
EXECUTE PROCEDURE service_pattern.check_scheduled_stop_point_vehicle_mode_by_infra_link();
