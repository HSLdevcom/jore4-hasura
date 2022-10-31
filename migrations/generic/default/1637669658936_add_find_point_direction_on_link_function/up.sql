CREATE FUNCTION infrastructure_network.find_point_direction_on_link (
    point_of_interest geography,
    infrastructure_link_uuid uuid,
    point_max_distance_in_meters double precision DEFAULT 50.0
)
RETURNS SETOF infrastructure_network.direction
LANGUAGE sql
STABLE
STRICT
PARALLEL SAFE
AS $function$
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
$function$;

COMMENT ON FUNCTION
  infrastructure_network.find_point_direction_on_link(geography, uuid, double precision) IS
  'Function for resolving point direction relative to given infrastructure link.
  Recommended upper limit for point_max_distance_in_meters parameter is 50 as increasing distance increases odds of matching errors.
  Returns null if direction could not be resolved.';
