CREATE TABLE infrastructure_network.link_properties (
    infrastructure_link_id uuid,
    point_distance_from_link double precision,
    traffic_flow_direction_of_point_on_link text
);
COMMENT ON TABLE
  infrastructure_network.link_properties IS
  'Helper table used by infrastructure_network.find_closest_link_and_direction function.
   Hasura requires custom sql functions to return data as table or SETOF table: https://hasura.io/docs/latest/graphql/core/databases/postgres/schema/custom-functions.html#supported-sql-functions';

CREATE FUNCTION infrastructure_network.find_closest_link_and_direction(
    geog geography,
    radius_in_meters double precision
)
RETURNS SETOF infrastructure_network.link_properties
LANGUAGE sql
STABLE
STRICT
PARALLEL SAFE
AS $function$
SELECT
    link.infrastructure_link_id,
    closest_link_result.distance AS point_distance_from_link,
    direction.direction AS traffic_flow_direction_of_point_on_link
FROM (
    SELECT
        infrastructure_link_id,
        geog <-> shape AS distance
    FROM infrastructure_network.infrastructure_link
    WHERE ST_DWithin(geog, shape, radius_in_meters)
    ORDER BY distance
    LIMIT 1
) closest_link_result
INNER JOIN infrastructure_network.infrastructure_link link
    ON link.infrastructure_link_id = closest_link_result.infrastructure_link_id
CROSS JOIN LATERAL (
    SELECT
        ST_Transform(ST_Force2D(geog::geometry), srid) AS point_geom,
        ST_Transform(ST_Force2D(link.shape::geometry), srid) AS link_geom
    FROM (
        SELECT internal_utils.determine_srid(link.shape, geog) AS srid
    ) best
) geom_2d
CROSS JOIN LATERAL (
    SELECT
        ST_Intersection(
            round_buffer_geom,
            ST_Difference(lhs_offset_buffer_geom, rhs_side_buffer_geom)
        ) AS lhs_geom,
        ST_Intersection(
            round_buffer_geom,
            ST_Difference(rhs_offset_buffer_geom, lhs_side_buffer_geom)
        ) AS rhs_geom
    FROM (
        SELECT
            ST_Buffer(geom_2d.link_geom, radius_in_meters, 'join=round') AS round_buffer_geom,

            ST_Buffer(geom_2d.link_geom, radius_in_meters, 'side=left' ) AS lhs_side_buffer_geom,
            ST_Buffer(geom_2d.link_geom, radius_in_meters, 'side=right') AS rhs_side_buffer_geom,

            ST_Buffer(lhs_offset_line_geom, radius_in_meters, 'endcap=square join=mitre') AS lhs_offset_buffer_geom,
            ST_Buffer(rhs_offset_line_geom, radius_in_meters, 'endcap=square join=mitre') AS rhs_offset_buffer_geom
        FROM (
            SELECT
                ST_OffsetCurve(geom_2d.link_geom,  radius_in_meters, 'quad_segs=8 join=round') AS lhs_offset_line_geom,
                ST_OffsetCurve(geom_2d.link_geom, -radius_in_meters, 'quad_segs=8 join=round') AS rhs_offset_line_geom
        ) offset_line
    ) buf
) split_round_buffer
CROSS JOIN LATERAL (
    SELECT
        CASE
            WHEN in_left = false AND in_right = true THEN 'forward'
            WHEN in_left = true AND in_right = false THEN 'backward'
            ELSE 'unknown'
        END AS direction
    FROM (
        SELECT
            ST_Contains(split_round_buffer.lhs_geom, geom_2d.point_geom) AS in_left,
            ST_Contains(split_round_buffer.rhs_geom, geom_2d.point_geom) AS in_right
    ) direction_test
) direction;
$function$;

COMMENT ON FUNCTION
  infrastructure_network.find_closest_link_and_direction(geography, double precision) IS
  'Function for resolving closest infrastructure link and direction to the given point of interest.';
