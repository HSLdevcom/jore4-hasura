DROP FUNCTION internal_service_pattern.insert_scheduled_stop_point(
    scheduled_stop_point_id uuid,
    measured_location geography(PointZ,4326),
    located_on_infrastructure_link_id uuid,
    direction text,
    label text,
    validity_start timestamp with time zone,
    validity_end timestamp with time zone,
    priority integer,
    supported_vehicle_mode text
);
