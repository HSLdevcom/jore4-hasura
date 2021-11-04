CREATE FUNCTION infrastructure_network.resolve_point_to_closest_link(
  geog geography
)
RETURNS SETOF infrastructure_network.infrastructure_link
LANGUAGE sql
STABLE
STRICT
PARALLEL SAFE
AS $infrastructure_network_resolve_point_to_closest_link$
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
$infrastructure_network_resolve_point_to_closest_link$;

COMMENT ON FUNCTION
  infrastructure_network.resolve_point_to_closest_link(geography) IS
  'Function for resolving closest infrastructure link to the given point of interest.';
