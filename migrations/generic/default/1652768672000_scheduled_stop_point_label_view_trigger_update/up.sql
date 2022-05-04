
CREATE FUNCTION internal_service_pattern.insert_scheduled_stop_point_label (new_label text)
  RETURNS VOID
  LANGUAGE sql
AS $$
INSERT INTO internal_service_pattern.scheduled_stop_point_invariant (label)
VALUES (new_label)
ON CONFLICT (label)
  DO NOTHING;
$$;

CREATE FUNCTION internal_service_pattern.delete_scheduled_stop_point_label (old_label text)
  RETURNS VOID
  LANGUAGE sql
AS $$
DELETE FROM internal_service_pattern.scheduled_stop_point_invariant
WHERE label = old_label
  AND NOT EXISTS (SELECT 1 FROM internal_service_pattern.scheduled_stop_point WHERE label = old_label);
$$;


DROP TRIGGER service_pattern_insert_scheduled_stop_point_trigger
  ON service_pattern.scheduled_stop_point;

ALTER FUNCTION service_pattern.insert_scheduled_stop_point ()
  RENAME TO insert_scheduled_stop_point_1651476243443;

ALTER FUNCTION service_pattern.insert_scheduled_stop_point_1651476243443 ()
  SET SCHEMA deleted;

DROP TRIGGER service_pattern_update_scheduled_stop_point_trigger
  ON service_pattern.scheduled_stop_point;

ALTER FUNCTION service_pattern.update_scheduled_stop_point ()
  RENAME TO update_scheduled_stop_point_1651476243443;

ALTER FUNCTION service_pattern.update_scheduled_stop_point_1651476243443 ()
  SET SCHEMA deleted;

DROP TRIGGER service_pattern_delete_scheduled_stop_point_trigger
  ON service_pattern.scheduled_stop_point;

ALTER FUNCTION service_pattern.delete_scheduled_stop_point ()
  RENAME TO delete_scheduled_stop_point_1651476243443;

ALTER FUNCTION service_pattern.delete_scheduled_stop_point_1651476243443 ()
  SET SCHEMA deleted;


CREATE FUNCTION service_pattern.insert_scheduled_stop_point ()
  RETURNS TRIGGER
  LANGUAGE plpgsql
AS $service_pattern_insert_scheduled_stop_point$
BEGIN
  PERFORM internal_service_pattern.insert_scheduled_stop_point_label(NEW.label);

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

CREATE TRIGGER service_pattern_insert_scheduled_stop_point_trigger
  INSTEAD OF INSERT ON service_pattern.scheduled_stop_point
  FOR EACH ROW EXECUTE PROCEDURE service_pattern.insert_scheduled_stop_point();

CREATE FUNCTION service_pattern.update_scheduled_stop_point ()
  RETURNS TRIGGER
  LANGUAGE plpgsql
AS $service_pattern_update_scheduled_stop_point$
BEGIN
  PERFORM internal_service_pattern.insert_scheduled_stop_point_label(NEW.label);

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

  PERFORM internal_service_pattern.delete_scheduled_stop_point_label(OLD.label);
  RETURN NEW;
END;
$service_pattern_update_scheduled_stop_point$;

CREATE TRIGGER service_pattern_update_scheduled_stop_point_trigger
  INSTEAD OF UPDATE ON service_pattern.scheduled_stop_point
  FOR EACH ROW EXECUTE PROCEDURE service_pattern.update_scheduled_stop_point();

CREATE FUNCTION service_pattern.delete_scheduled_stop_point ()
  RETURNS TRIGGER
  LANGUAGE plpgsql
AS $service_pattern_delete_scheduled_stop_point$
BEGIN
  DELETE FROM internal_service_pattern.scheduled_stop_point
  WHERE scheduled_stop_point_id = OLD.scheduled_stop_point_id;

  PERFORM internal_service_pattern.delete_scheduled_stop_point_label(OLD.label);
  RETURN OLD;
END;
$service_pattern_delete_scheduled_stop_point$;

CREATE TRIGGER service_pattern_delete_scheduled_stop_point_trigger
  INSTEAD OF DELETE ON service_pattern.scheduled_stop_point
  FOR EACH ROW EXECUTE PROCEDURE service_pattern.delete_scheduled_stop_point();
