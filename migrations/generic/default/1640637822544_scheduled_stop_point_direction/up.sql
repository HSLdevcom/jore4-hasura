CREATE FUNCTION internal_service_pattern.check_scheduled_stop_point_infrastructure_link_direction()
  RETURNS trigger
  LANGUAGE plpgsql AS
$internal_service_pattern_check_scheduled_stop_point_infrastructure_link_direction$
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
$internal_service_pattern_check_scheduled_stop_point_infrastructure_link_direction$;

CREATE CONSTRAINT TRIGGER check_scheduled_stop_point_infrastructure_link_direction_trigger
  AFTER INSERT OR UPDATE ON internal_service_pattern.scheduled_stop_point
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW EXECUTE PROCEDURE internal_service_pattern.check_scheduled_stop_point_infrastructure_link_direction();


CREATE FUNCTION infrastructure_network.check_infrastructure_link_scheduled_stop_points_direction_trigger()
  RETURNS trigger
  LANGUAGE plpgsql AS
$infrastructure_network_check_infrastructure_link_scheduled_stop_points_direction_trigger$
BEGIN
  IF EXISTS(
    SELECT 1
    FROM internal_service_pattern.scheduled_stop_point
    JOIN infrastructure_network.infrastructure_link
      ON infrastructure_network.infrastructure_link.infrastructure_link_id =
         internal_service_pattern.scheduled_stop_point.located_on_infrastructure_link_id
    WHERE internal_service_pattern.scheduled_stop_point.located_on_infrastructure_link_id = NEW.infrastructure_link_id
    AND (
      (internal_service_pattern.scheduled_stop_point.direction = 'forward' AND NEW.direction = 'backward') OR
      (internal_service_pattern.scheduled_stop_point.direction = 'backward' AND NEW.direction = 'forward') OR
      (internal_service_pattern.scheduled_stop_point.direction = 'bidirectional' AND NEW.direction != 'bidirectional')
    )
  )
  THEN
    RAISE EXCEPTION 'infrastructure link direction must be compatible with the directions of the stop points residing on it';
  END IF;

  RETURN NEW;
END;
$infrastructure_network_check_infrastructure_link_scheduled_stop_points_direction_trigger$;

CREATE CONSTRAINT TRIGGER check_infrastructure_link_scheduled_stop_points_direction_trigger
  AFTER UPDATE ON infrastructure_network.infrastructure_link
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW EXECUTE PROCEDURE infrastructure_network.check_infrastructure_link_scheduled_stop_points_direction_trigger();
