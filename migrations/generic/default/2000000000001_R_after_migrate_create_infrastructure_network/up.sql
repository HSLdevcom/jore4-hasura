CREATE OR REPLACE FUNCTION infrastructure_network.check_infrastructure_link_route_link_direction() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS(
    SELECT 1
    FROM route.infrastructure_link_along_route
           JOIN infrastructure_network.infrastructure_link
                ON infrastructure_network.infrastructure_link.infrastructure_link_id =
                   route.infrastructure_link_along_route.infrastructure_link_id
    WHERE route.infrastructure_link_along_route.infrastructure_link_id = NEW.infrastructure_link_id
      AND (
      -- NB: NEW.direction = 'bidirectional' allows both traversal directions
        (route.infrastructure_link_along_route.is_traversal_forwards = TRUE AND NEW.direction = 'backward') OR
        (route.infrastructure_link_along_route.is_traversal_forwards = FALSE AND NEW.direction = 'forward')
      )
    )
  THEN
    RAISE EXCEPTION 'route link direction must be compatible with infrastructure link direction';
  END IF;

  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION infrastructure_network.check_infrastructure_link_scheduled_stop_points_direction_trigg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS(
    SELECT 1
    FROM service_pattern.scheduled_stop_point
    JOIN infrastructure_network.infrastructure_link
      ON infrastructure_network.infrastructure_link.infrastructure_link_id =
         service_pattern.scheduled_stop_point.located_on_infrastructure_link_id
    WHERE service_pattern.scheduled_stop_point.located_on_infrastructure_link_id = NEW.infrastructure_link_id
    AND (
      (service_pattern.scheduled_stop_point.direction = 'forward' AND NEW.direction = 'backward') OR
      (service_pattern.scheduled_stop_point.direction = 'backward' AND NEW.direction = 'forward') OR
      (service_pattern.scheduled_stop_point.direction = 'bidirectional' AND NEW.direction != 'bidirectional')
    )
  )
  THEN
    RAISE EXCEPTION 'infrastructure link direction must be compatible with the directions of the stop points residing on it';
  END IF;

  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION infrastructure_network.find_point_direction_on_link(point_of_interest public.geography, infrastructure_link_uuid uuid, point_max_distance_in_meters double precision DEFAULT 50.0) RETURNS SETOF infrastructure_network.direction
    LANGUAGE sql STABLE STRICT PARALLEL SAFE
    AS $$
SELECT direction.*
FROM (
    SELECT shape
    FROM infrastructure_network.infrastructure_link
    WHERE infrastructure_link_id = infrastructure_link_uuid
) link
CROSS JOIN LATERAL (
    SELECT
        ST_Transform(ST_Force2D(point_of_interest::geometry), srid) AS point_geom,
        ST_Transform(ST_Force2D(link.shape::geometry), srid) AS link_geom
    FROM (
        SELECT internal_utils.determine_srid(link.shape, point_of_interest) AS srid
    ) best
) geom_2d
CROSS JOIN LATERAL (
    SELECT
        ST_Buffer(link_geom, capped_radius, 'side=left' ) AS lhs_side_buf_geom,
        ST_Buffer(link_geom, capped_radius, 'side=right') AS rhs_side_buf_geom
    FROM (
        -- Buffer radius is capped by link length in order to have sensible side buffer areas.
        SELECT least(point_max_distance_in_meters, floor(ST_Length(link_geom))) AS capped_radius
    ) buf_radius
) side_buf
CROSS JOIN LATERAL (
    SELECT
        CASE
            WHEN in_left = false AND in_right = true THEN 'forward'
            WHEN in_left = true AND in_right = false THEN 'backward'
            ELSE null
        END AS value
    FROM (
        SELECT
            ST_Contains(lhs_side_buf_geom, point_geom) AS in_left,
            ST_Contains(rhs_side_buf_geom, point_geom) AS in_right
    ) direction_test
) calculated_direction
INNER JOIN infrastructure_network.direction direction ON direction.value = calculated_direction.value;
$$;
COMMENT ON FUNCTION infrastructure_network.find_point_direction_on_link(point_of_interest public.geography, infrastructure_link_uuid uuid, point_max_distance_in_meters double precision) IS 'Function for resolving point direction relative to given infrastructure link.
  Recommended upper limit for point_max_distance_in_meters parameter is 50 as increasing distance increases odds of matching errors.
  Returns null if direction could not be resolved.';

CREATE OR REPLACE FUNCTION infrastructure_network.resolve_point_to_closest_link(geog public.geography) RETURNS SETOF infrastructure_network.infrastructure_link
    LANGUAGE sql STABLE STRICT PARALLEL SAFE
    AS $$
SELECT link.*
FROM (
    SELECT geog
) point_of_interest
CROSS JOIN LATERAL (
    SELECT
        link.infrastructure_link_id,
        point_of_interest.geog <-> link.shape AS distance
    FROM infrastructure_network.infrastructure_link link
    WHERE ST_DWithin(point_of_interest.geog, link.shape, 100) -- link filtering radius set to 100 m
    ORDER BY distance
    LIMIT 1
) closest_link_result
INNER JOIN infrastructure_network.infrastructure_link link ON link.infrastructure_link_id = closest_link_result.infrastructure_link_id;
$$;
COMMENT ON FUNCTION infrastructure_network.resolve_point_to_closest_link(geog public.geography) IS 'Function for resolving closest infrastructure link to the given point of interest.';

DROP TRIGGER IF EXISTS check_infrastructure_link_route_link_direction_trigger ON infrastructure_network.infrastructure_link;
CREATE CONSTRAINT TRIGGER check_infrastructure_link_route_link_direction_trigger AFTER UPDATE ON infrastructure_network.infrastructure_link DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION infrastructure_network.check_infrastructure_link_route_link_direction();
DROP TRIGGER IF EXISTS check_infrastructure_link_scheduled_stop_points_direction_trigg ON infrastructure_network.infrastructure_link;
CREATE CONSTRAINT TRIGGER check_infrastructure_link_scheduled_stop_points_direction_trigg AFTER UPDATE ON infrastructure_network.infrastructure_link DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION infrastructure_network.check_infrastructure_link_scheduled_stop_points_direction_trigg();
DROP TRIGGER IF EXISTS prevent_update_of_vehicle_submode_on_infrastructure_link ON infrastructure_network.vehicle_submode_on_infrastructure_link;
CREATE TRIGGER prevent_update_of_vehicle_submode_on_infrastructure_link BEFORE UPDATE ON infrastructure_network.vehicle_submode_on_infrastructure_link FOR EACH ROW EXECUTE FUNCTION internal_utils.prevent_update();
