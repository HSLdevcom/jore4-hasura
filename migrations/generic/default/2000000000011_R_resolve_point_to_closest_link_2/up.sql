DROP FUNCTION IF EXISTS infrastructure_network.resolve_point_to_closest_link(public.geography); -- create or replace does not work beacause of the changed function signature
CREATE OR REPLACE FUNCTION infrastructure_network.resolve_point_to_closest_link(geog public.geography, filter_vehicle_submode text DEFAULT 'generic_bus') RETURNS SETOF infrastructure_network.infrastructure_link
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
    INNER JOIN infrastructure_network.vehicle_submode_on_infrastructure_link vs on vs.infrastructure_link_id = link.infrastructure_link_id
    WHERE vs.vehicle_submode = filter_vehicle_submode
    AND ST_DWithin(point_of_interest.geog, link.shape, 100) -- link filtering radius set to 100 m
    ORDER BY distance
    LIMIT 1
) closest_link_result
INNER JOIN infrastructure_network.infrastructure_link link ON link.infrastructure_link_id = closest_link_result.infrastructure_link_id;
$$;
COMMENT ON FUNCTION infrastructure_network.resolve_point_to_closest_link(geog public.geography, filter_vehicle_submode text) IS 'Function for resolving closest infrastructure link to the given point of interest.';
