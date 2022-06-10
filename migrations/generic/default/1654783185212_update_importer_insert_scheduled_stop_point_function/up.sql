
-- Create a new version of the INSTEAD OF INSERT -trigger for the service_pattern.scheduled_stop_point
-- view. The old version did not insert an ID that was possibly specified in the record. The new version
-- inserts the ID if specified, or defaults to the previous version's behaviour (insert without specified
-- ID) if none is specified.

DROP TRIGGER service_pattern_insert_scheduled_stop_point_trigger
  ON service_pattern.scheduled_stop_point;

ALTER FUNCTION service_pattern.insert_scheduled_stop_point ()
  RENAME TO insert_scheduled_stop_point_1654783185212;

ALTER FUNCTION service_pattern.insert_scheduled_stop_point_1654783185212 ()
  SET SCHEMA deleted;

CREATE FUNCTION service_pattern.insert_scheduled_stop_point ()
  RETURNS TRIGGER
  LANGUAGE plpgsql
AS $service_pattern_insert_scheduled_stop_point$
BEGIN
  PERFORM internal_service_pattern.insert_scheduled_stop_point_label(NEW.label);

  IF NEW.scheduled_stop_point_id IS NOT NULL
  THEN
    INSERT INTO internal_service_pattern.scheduled_stop_point (
      scheduled_stop_point_id,
      measured_location,
      located_on_infrastructure_link_id,
      direction,
      label,
      validity_start,
      validity_end,
      priority
    ) VALUES (
               NEW.scheduled_stop_point_id,
               NEW.measured_location,
               NEW.located_on_infrastructure_link_id,
               NEW.direction,
               NEW.label,
               NEW.validity_start,
               NEW.validity_end,
               NEW.priority
             ) RETURNING scheduled_stop_point_id INTO NEW.scheduled_stop_point_id;
  ELSE
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
  END IF;
  RETURN NEW;
END;
$service_pattern_insert_scheduled_stop_point$;

CREATE TRIGGER service_pattern_insert_scheduled_stop_point_trigger
  INSTEAD OF INSERT ON service_pattern.scheduled_stop_point
  FOR EACH ROW EXECUTE PROCEDURE service_pattern.insert_scheduled_stop_point();



-- Create a new version of the internal_service_pattern.insert_scheduled_stop_point provided for convenience
-- to the Jore3 importer or other internal use. The old version inserted a row directly into the
-- internal_service_pattern.scheduled_stop_point table, skipping any functionality implemented in the
-- service_pattern.scheduled_stop_point view's INSTEAD OF INSERT trigger. The new version inserts the row
-- into the view, making use of any functionality implemented in the INSTEAD OF INSERT trigger.

ALTER FUNCTION internal_service_pattern.insert_scheduled_stop_point(
  scheduled_stop_point_id uuid,
  measured_location geography(PointZ,4326),
  located_on_infrastructure_link_id uuid,
  direction text,
  label text,
  validity_start timestamp with time zone,
  validity_end timestamp with time zone,
  priority integer,
  supported_vehicle_mode text
  )
RENAME TO insert_scheduled_stop_point_1654783185212;

ALTER FUNCTION internal_service_pattern.insert_scheduled_stop_point_1654783185212(
  scheduled_stop_point_id uuid,
  measured_location geography(PointZ,4326),
  located_on_infrastructure_link_id uuid,
  direction text,
  label text,
  validity_start timestamp with time zone,
  validity_end timestamp with time zone,
  priority integer,
  supported_vehicle_mode text
  )
SET SCHEMA deleted;

CREATE FUNCTION internal_service_pattern.insert_scheduled_stop_point_with_vehicle_mode(
  scheduled_stop_point_id uuid,
  measured_location geography(PointZ,4326),
  located_on_infrastructure_link_id uuid,
  direction text,
  label text,
  validity_start timestamp with time zone,
  validity_end timestamp with time zone,
  priority integer,
  supported_vehicle_mode text
) RETURNS void AS $$
BEGIN
  INSERT INTO service_pattern.scheduled_stop_point (
    scheduled_stop_point_id,
    measured_location,
    located_on_infrastructure_link_id,
    direction,
    label,
    validity_start,
    validity_end,
    priority
  )
  VALUES (
           scheduled_stop_point_id,
           measured_location,
           located_on_infrastructure_link_id,
           direction,
           label,
           validity_start,
           validity_end,
           priority
         );

  INSERT INTO service_pattern.vehicle_mode_on_scheduled_stop_point(
    scheduled_stop_point_id,
    vehicle_mode
  )
  VALUES (
           scheduled_stop_point_id,
           supported_vehicle_mode
         );
END;
$$ LANGUAGE plpgsql;
