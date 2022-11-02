
DROP FUNCTION internal_service_pattern.insert_scheduled_stop_point_with_vehicle_mode(
  scheduled_stop_point_id uuid,
  measured_location geography(PointZ, 4326),
  located_on_infrastructure_link_id uuid,
  direction text,
  label text,
  validity_start date,
  validity_end date,
  priority integer,
  supported_vehicle_mode text
);

ALTER FUNCTION deleted.insert_scheduled_stop_point_with_vehicle_mode_1667313108899(
  scheduled_stop_point_id uuid,
  measured_location geography(PointZ, 4326),
  located_on_infrastructure_link_id uuid,
  direction text,
  label text,
  validity_start date,
  validity_end date,
  priority integer,
  supported_vehicle_mode text
  )
  SET SCHEMA internal_service_pattern;

ALTER FUNCTION internal_service_pattern.insert_scheduled_stop_point_with_vehicle_mode_1667313108899(
  scheduled_stop_point_id uuid,
  measured_location geography(PointZ, 4326),
  located_on_infrastructure_link_id uuid,
  direction text,
  label text,
  validity_start date,
  validity_end date,
  priority integer,
  supported_vehicle_mode text
  )
  RENAME TO insert_scheduled_stop_point_with_vehicle_mode;
