
DROP FUNCTION internal_service_pattern.insert_scheduled_stop_point_with_vehicle_mode(
  scheduled_stop_point_id uuid,
  measured_location GEOGRAPHY(POINTZ,4326),
  located_on_infrastructure_link_id uuid,
  direction text,
  label text,
  validity_start timestamp with time zone,
  validity_end timestamp with time zone,
  priority integer,
  supported_vehicle_mode text
);

ALTER FUNCTION deleted.insert_scheduled_stop_point_1654783185212(
  scheduled_stop_point_id uuid,
  measured_location GEOGRAPHY(POINTZ,4326),
  located_on_infrastructure_link_id uuid,
  direction text,
  label text,
  validity_start timestamp with time zone,
  validity_end timestamp with time zone,
  priority integer,
  supported_vehicle_mode text
  )
SET SCHEMA internal_service_pattern;

ALTER FUNCTION internal_service_pattern.insert_scheduled_stop_point_1654783185212(
  scheduled_stop_point_id uuid,
  measured_location GEOGRAPHY(POINTZ,4326),
  located_on_infrastructure_link_id uuid,
  direction text,
  label text,
  validity_start timestamp with time zone,
  validity_end timestamp with time zone,
  priority integer,
  supported_vehicle_mode text
  )
RENAME TO insert_scheduled_stop_point;


DROP TRIGGER service_pattern_insert_scheduled_stop_point_trigger
  ON service_pattern.scheduled_stop_point;

DROP FUNCTION service_pattern.insert_scheduled_stop_point ();

ALTER FUNCTION deleted.insert_scheduled_stop_point_1654783185212 ()
  SET SCHEMA service_pattern;

ALTER FUNCTION service_pattern.insert_scheduled_stop_point_1654783185212 ()
  RENAME TO insert_scheduled_stop_point;

CREATE TRIGGER service_pattern_insert_scheduled_stop_point_trigger
  INSTEAD OF INSERT ON service_pattern.scheduled_stop_point
  FOR EACH ROW EXECUTE PROCEDURE service_pattern.insert_scheduled_stop_point();
