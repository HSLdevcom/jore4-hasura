CREATE FUNCTION infrastructure_network.find_closest_link_and_direction (
    point_of_interest geography,
    query_distance_in_meters double precision,
    OUT point_of_interest_geojson text,
    OUT closest_infrastructure_link_id uuid,
    OUT closest_infrastructure_link_shape_geojson text,
    OUT point_distance_from_link double precision,
    OUT traffic_flow_direction_of_point_on_link text
)
RETURNS SETOF RECORD
LANGUAGE SQL
    STABLE
    STRICT
    PARALLEL SAFE
AS $function$
SELECT
    ST_AsGeoJSON(point_of_interest),
    link.infrastructure_link_id,
    ST_AsGeoJSON(link.shape),
    closest_link_result.distance,
    direction.direction
FROM (
    SELECT
        infrastructure_link_id,
        point_of_interest <-> shape AS distance
    FROM infrastructure_network.infrastructure_link
    WHERE ST_DWithin(point_of_interest, shape, query_distance_in_meters)
    ORDER BY distance
    LIMIT 1
) closest_link_result
INNER JOIN infrastructure_network.infrastructure_link link
    ON link.infrastructure_link_id = closest_link_result.infrastructure_link_id
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
        SELECT least(query_distance_in_meters, floor(ST_Length(link_geom))) AS capped_radius
    ) buf_radius
) side_buf
CROSS JOIN LATERAL (
    SELECT
        CASE
            WHEN in_left = false AND in_right = true THEN 'forward'
            WHEN in_left = true AND in_right = false THEN 'backward'
            ELSE 'unknown'
        END AS direction
    FROM (
        SELECT
            ST_Contains(lhs_side_buf_geom, point_geom) AS in_left,
            ST_Contains(rhs_side_buf_geom, point_geom) AS in_right
    ) direction_test
) direction;
$function$;

COMMENT ON FUNCTION
  infrastructure_network.find_closest_link_and_direction(geography, double precision) IS
  'Function for resolving closest infrastructure link and direction to the given point of interest (e.g. stop).
  Recommended upper limit for query_distance_in_meters parameter is 50 (meters) as it increasing distance increases odds of matching errors.
  Note: in some cases link direction cannot be calculated (e.g. if coordinates happen to be just between two infrastruture link).';
