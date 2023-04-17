-- Similar to internal_service_pattern.insert_scheduled_stop_point_with_vehicle_mode in generic schema,
-- but with additional HSL specific fields.
CREATE OR REPLACE FUNCTION internal_service_pattern.insert_scheduled_stop_point_with_vehicle_mode(
  scheduled_stop_point_id uuid,
  external_id integer,
  measured_location public.geography,
  located_on_infrastructure_link_id uuid,
  direction text,
  label text,
  validity_start date,
  validity_end date,
  priority integer,
  supported_vehicle_mode text,
  timing_place_id uuid DEFAULT NULL
)
  RETURNS void
  LANGUAGE plpgsql
  AS $$
BEGIN
  INSERT INTO service_pattern.scheduled_stop_point (scheduled_stop_point_id,
                                                    external_id,
                                                    measured_location,
                                                    located_on_infrastructure_link_id,
                                                    direction,
                                                    label,
                                                    timing_place_id,
                                                    validity_start,
                                                    validity_end,
                                                    priority)
  VALUES (scheduled_stop_point_id,
          external_id,
          measured_location,
          located_on_infrastructure_link_id,
          direction,
          label,
          timing_place_id,
          validity_start,
          validity_end,
          priority);

  INSERT INTO service_pattern.vehicle_mode_on_scheduled_stop_point(scheduled_stop_point_id,
                                                                   vehicle_mode)
  VALUES (scheduled_stop_point_id,
          supported_vehicle_mode);
END;
$$;
