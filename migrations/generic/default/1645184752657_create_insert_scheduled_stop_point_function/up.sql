CREATE FUNCTION internal_service_pattern.insert_scheduled_stop_point(
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
        INSERT INTO internal_service_pattern.scheduled_stop_point (
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
