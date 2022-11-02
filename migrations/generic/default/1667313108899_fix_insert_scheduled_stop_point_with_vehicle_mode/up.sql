
ALTER FUNCTION internal_service_pattern.insert_scheduled_stop_point_with_vehicle_mode(
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
  RENAME TO insert_scheduled_stop_point_with_vehicle_mode_1667313108899;
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
  SET SCHEMA deleted;

CREATE FUNCTION internal_service_pattern.insert_scheduled_stop_point_with_vehicle_mode(
  scheduled_stop_point_id uuid,
  measured_location geography(PointZ, 4326),
  located_on_infrastructure_link_id uuid,
  direction text,
  label text,
  validity_start date,
  validity_end date,
  priority integer,
  supported_vehicle_mode text
) RETURNS void AS
$$
BEGIN
  -- have to use service_pattern.scheduled_stop_point here to have the view's instead of insert -trigger
  -- invoked, which will also add a scheduled_stop_point_invariant row if needed
  INSERT INTO service_pattern.scheduled_stop_point (scheduled_stop_point_id,
                                                    measured_location,
                                                    located_on_infrastructure_link_id,
                                                    direction,
                                                    label,
                                                    validity_start,
                                                    validity_end,
                                                    priority)
  VALUES (scheduled_stop_point_id,
          measured_location,
          located_on_infrastructure_link_id,
          direction,
          label,
          validity_start,
          validity_end,
          priority);

  INSERT INTO service_pattern.vehicle_mode_on_scheduled_stop_point(scheduled_stop_point_id,
                                                                   vehicle_mode)
  VALUES (scheduled_stop_point_id,
          supported_vehicle_mode);
END;
$$ LANGUAGE plpgsql;
