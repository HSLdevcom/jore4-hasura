CREATE OR REPLACE FUNCTION service_pattern.find_effective_scheduled_stop_points_in_journey_pattern(
  filter_journey_pattern_id  uuid,
  observation_date           date,
  include_draft_stops        boolean
)
  RETURNS TABLE (
    journey_pattern_id                 uuid,
    scheduled_stop_point_sequence      integer,
    is_used_as_timing_point            boolean,
    is_loading_time_allowed            boolean,
    is_regulated_timing_point          boolean,
    is_via_point                       boolean,
    via_point_name_i18n                jsonb,
    via_point_short_name_i18n          jsonb,
    effective_scheduled_stop_point_id  uuid
  )
  STABLE
  PARALLEL SAFE
  LANGUAGE sql AS
$$
WITH unambiguous_sspijp AS (
  SELECT DISTINCT
    sspijp.journey_pattern_id,
    sspijp.scheduled_stop_point_sequence,
    -- Pick the stop point instance with the highest priority.
    first_value(ssp.scheduled_stop_point_id) OVER (
      PARTITION BY sspijp.scheduled_stop_point_sequence
      ORDER BY ssp.priority DESC
    ) AS effective_scheduled_stop_point_id
  FROM journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
  JOIN service_pattern.scheduled_stop_point_invariant sspi ON sspi.label = sspijp.scheduled_stop_point_label
  JOIN service_pattern.scheduled_stop_point ssp USING (label)
  WHERE sspijp.journey_pattern_id = filter_journey_pattern_id
    AND (include_draft_stops OR ssp.priority < internal_utils.const_priority_draft())
    AND internal_utils.daterange_closed_upper(ssp.validity_start, ssp.validity_end) @> observation_date
)
SELECT
  journey_pattern_id,
  scheduled_stop_point_sequence,
  is_used_as_timing_point,
  is_loading_time_allowed,
  is_regulated_timing_point,
  is_via_point,
  via_point_name_i18n,
  via_point_short_name_i18n,
  effective_scheduled_stop_point_id
FROM unambiguous_sspijp
JOIN journey_pattern.scheduled_stop_point_in_journey_pattern USING (journey_pattern_id, scheduled_stop_point_sequence)
$$;
COMMENT ON FUNCTION service_pattern.find_effective_scheduled_stop_points_in_journey_pattern(uuid, date, boolean)
IS 'Find effective scheduled stop points in journey/service pattern.';


CREATE OR REPLACE FUNCTION service_pattern.find_scheduled_stop_point_locations_in_journey_pattern(
  filter_journey_pattern_id  uuid,
  observation_date           date,
  include_draft_stops        boolean
)
  RETURNS TABLE (
    journey_pattern_id                 uuid,
    scheduled_stop_point_sequence      integer,
    scheduled_stop_point_id            uuid,
    label                              text,
    measured_location                  geography(PointZ,4326),
    located_on_infrastructure_link_id  uuid,
    direction                          text,
    relative_distance_from_link_start  double precision,
    timing_place_id                    uuid
  )
  STABLE
  PARALLEL SAFE
  LANGUAGE sql AS
$$
SELECT
  sspijp.journey_pattern_id,
  sspijp.scheduled_stop_point_sequence,
  ssp.scheduled_stop_point_id,
  ssp.label,
  ssp.measured_location,
  ssp.located_on_infrastructure_link_id,
  ssp.direction,
  internal_utils.ST_LineLocatePoint(il.shape, ssp.measured_location) AS relative_distance_from_link_start,
  ssp.timing_place_id
FROM service_pattern.find_effective_scheduled_stop_points_in_journey_pattern(
  filter_journey_pattern_id,
  observation_date,
  include_draft_stops
) sspijp
JOIN service_pattern.scheduled_stop_point ssp ON ssp.scheduled_stop_point_id = sspijp.effective_scheduled_stop_point_id
JOIN infrastructure_network.infrastructure_link il ON il.infrastructure_link_id = ssp.located_on_infrastructure_link_id
$$;
COMMENT ON FUNCTION service_pattern.find_scheduled_stop_point_locations_in_journey_pattern(uuid, date, boolean)
IS 'Find location information for scheduled stop points in journey/service pattern.';


CREATE OR REPLACE FUNCTION service_pattern.get_distances_between_stop_points_in_journey_patterns(
  journey_pattern_ids  uuid[],
  observation_date     date,
  include_draft_stops  boolean
)
  RETURNS SETOF service_pattern.distance_between_stops_calculation
  STABLE
  PARALLEL SAFE
  LANGUAGE sql AS
$$
WITH RECURSIVE
scheduled_stop_point_info AS (
  SELECT
    jp.on_route_id                         AS route_id,
    jp.journey_pattern_id,
    -- Generate continuous (gapless) sequence number starting from 1.
    row_number() OVER(
      PARTITION BY jp.journey_pattern_id
      ORDER BY ssp.scheduled_stop_point_sequence ASC
    )::integer                             AS stop_point_sequence,
    ssp.label                              AS stop_point_label,
    ssp.located_on_infrastructure_link_id  AS infrastructure_link_id,
    ssp.direction                          AS stop_point_direction,
    ssp.relative_distance_from_link_start  AS stop_distance_from_link_start
  FROM journey_pattern.journey_pattern jp
  JOIN LATERAL (
    SELECT *
    FROM service_pattern.find_scheduled_stop_point_locations_in_journey_pattern(jp.journey_pattern_id, observation_date, include_draft_stops)
  ) ssp USING (journey_pattern_id)
  WHERE jp.journey_pattern_id = ANY(journey_pattern_ids)
),
ssp_merged_with_ilar AS ( -- contains recursive term
  SELECT
    sspi.route_id,
    sspi.journey_pattern_id,
    sspi.stop_point_sequence,
    sspi.stop_point_label,
    sspi.stop_distance_from_link_start,

    -- It is assumed, that we stop at the first matching infrastructure link.
    -- 
    -- Our data model does not properly support going around a loop multiple
    -- times without stopping at the same stop point in each loop.
    -- 
    -- Also, if we make a U-turn at the end of a bi-directional link and there
    -- is a two-way stop point along it, it is not possible with this logic to
    -- stop only once and in the return direction. The data model lacks the
    -- possibility to unequivocally define with which individual link visit we
    -- should stop at a stop point along it.
    -- 
    -- Therefore, there is an inherent indeterminism in the distance calculation
    -- for these corner cases. In practice, this may not cause problems.
    -- 
    first_value(ilar.infrastructure_link_sequence) OVER (
      PARTITION BY sspi.journey_pattern_id
      ORDER BY ilar.infrastructure_link_sequence ASC
    ) AS route_link_sequence_start

  FROM scheduled_stop_point_info sspi
  JOIN route.infrastructure_link_along_route ilar USING (route_id, infrastructure_link_id)
  WHERE sspi.stop_point_sequence = 1
    AND (
      sspi.stop_point_direction = 'bidirectional'
      OR sspi.stop_point_direction = 'forward' AND ilar.is_traversal_forwards
      OR sspi.stop_point_direction = 'backward' AND NOT ilar.is_traversal_forwards
    )
  UNION
  -- recursive term begins
  SELECT
    sspi.route_id,
    sspi.journey_pattern_id,
    sspi.stop_point_sequence,
    sspi.stop_point_label,
    sspi.stop_distance_from_link_start,

    -- It is assumed, that we stop at the first matching infrastructure link.
    -- See more remarks above (in the non-recursive term).
    first_value(ilar.infrastructure_link_sequence) OVER (
      PARTITION BY sspi.journey_pattern_id
      ORDER BY ilar.infrastructure_link_sequence ASC
    ) AS route_link_sequence_start

  FROM ssp_merged_with_ilar prev
  JOIN scheduled_stop_point_info sspi
    ON sspi.journey_pattern_id = prev.journey_pattern_id
      AND sspi.stop_point_sequence = prev.stop_point_sequence + 1
  JOIN route.infrastructure_link_along_route ilar
    ON ilar.route_id = sspi.route_id
      AND ilar.infrastructure_link_id = sspi.infrastructure_link_id
  WHERE
    (
      ilar.infrastructure_link_sequence > prev.route_link_sequence_start
      OR (
        ilar.infrastructure_link_sequence = prev.route_link_sequence_start
        AND (
          ilar.is_traversal_forwards AND sspi.stop_distance_from_link_start > prev.stop_distance_from_link_start
          OR NOT ilar.is_traversal_forwards AND sspi.stop_distance_from_link_start < prev.stop_distance_from_link_start
        )
      )
    )
    AND (
      sspi.stop_point_direction = 'bidirectional'
      OR sspi.stop_point_direction = 'forward' AND ilar.is_traversal_forwards
      OR sspi.stop_point_direction = 'backward' AND NOT ilar.is_traversal_forwards
    )
),
stop_interval AS (
  SELECT *
  FROM (
    SELECT
      journey_pattern_id,
      stop_point_sequence AS stop_interval_sequence,
      stop_point_label AS start_stop_label,
      lead(stop_point_label) OVER (
        PARTITION BY journey_pattern_id
        ORDER BY stop_point_sequence ASC
      ) AS end_stop_label,
      stop_distance_from_link_start::numeric AS start_stop_distance_from_link_start,
      lead(stop_distance_from_link_start) OVER (
        PARTITION BY journey_pattern_id
        ORDER BY stop_point_sequence ASC
      )::numeric AS end_stop_distance_from_link_start,
      route_id,
      route_link_sequence_start,
      lead(route_link_sequence_start) OVER (
        PARTITION BY journey_pattern_id
        ORDER BY stop_point_sequence ASC
      ) AS route_link_sequence_end
    FROM ssp_merged_with_ilar
  ) t
   -- Filter out last item, because N stops make N-1 stop intervals.
  WHERE route_link_sequence_end IS NOT NULL
),
route_link_traversal AS (
  SELECT
    si.journey_pattern_id,
    si.stop_interval_sequence,
    ilar.infrastructure_link_sequence,

    -- When the estimated length exists, scale the length of the link section by
    -- the ratio of the estimated length to the geometry length.
    -- 
    -- Take elevation changes into account, hence using 3D lengths.
    CASE
      WHEN il.estimated_length_in_metres IS NOT NULL THEN
        il.estimated_length_in_metres / ST_3DLength(transformed_link_shape.geom) * ST_3DLength(link_section_used.geom)
      ELSE
        ST_3DLength(link_section_used.geom)
    END AS distance_in_metres

  FROM stop_interval si
  JOIN route.infrastructure_link_along_route ilar
    ON ilar.route_id = si.route_id
      AND ilar.infrastructure_link_sequence
        BETWEEN si.route_link_sequence_start AND si.route_link_sequence_end
  JOIN infrastructure_network.infrastructure_link il USING (infrastructure_link_id)
  CROSS JOIN LATERAL (
    -- CRS transformations should result in a metric coordinate system.
    -- E.g. EPSG:4326 is not like one.
    SELECT ST_Transform(il.shape::geometry, internal_utils.determine_srid(il.shape)) AS geom
  ) transformed_link_shape
  CROSS JOIN LATERAL (
    SELECT
      CASE
        WHEN numrange IS NULL THEN transformed_link_shape.geom
        ELSE ST_LineSubstring(transformed_link_shape.geom, lower(numrange), upper(numrange))
      END AS geom
    FROM (
      -- Resolve start/end point on the first/last infra link in stop interval.
      SELECT CASE
        -- both stop points along same single link
        WHEN si.route_link_sequence_start = si.route_link_sequence_end THEN
          CASE
            WHEN ilar.is_traversal_forwards THEN
              numrange(start_stop_distance_from_link_start, end_stop_distance_from_link_start, '[]')
            ELSE
              numrange(end_stop_distance_from_link_start, start_stop_distance_from_link_start, '[]')
          END
        WHEN ilar.infrastructure_link_sequence = si.route_link_sequence_start THEN
          CASE
            WHEN ilar.is_traversal_forwards THEN
              numrange(start_stop_distance_from_link_start, 1.0, '[]')
            ELSE
              numrange(0.0, start_stop_distance_from_link_start, '[]')
          END
        WHEN ilar.infrastructure_link_sequence = si.route_link_sequence_end THEN
          CASE
            WHEN ilar.is_traversal_forwards THEN
              numrange(0.0, end_stop_distance_from_link_start, '[]')
            ELSE
              numrange(end_stop_distance_from_link_start, 1.0, '[]')
          END
        ELSE NULL
      END AS numrange
    ) line_endpoints
  ) link_section_used
),
stop_interval_distance AS (
  SELECT journey_pattern_id, stop_interval_sequence, sum(distance_in_metres) AS total_distance_in_metres
  FROM route_link_traversal
  GROUP BY journey_pattern_id, stop_interval_sequence
)
SELECT
  journey_pattern_id,
  route_id,
  priority AS route_priority,
  observation_date,
  stop_interval_sequence,
  start_stop_label,
  end_stop_label,
  total_distance_in_metres AS distance_in_metres
FROM stop_interval
JOIN stop_interval_distance USING (journey_pattern_id, stop_interval_sequence)
JOIN route.route USING (route_id)
ORDER BY route_id, journey_pattern_id, stop_interval_sequence
$$;
COMMENT ON FUNCTION service_pattern.get_distances_between_stop_points_in_journey_patterns(uuid[], date, boolean)
IS 'Get the distances between scheduled stop points (in metres) for the given journey/service patterns.';


CREATE OR REPLACE FUNCTION service_pattern.get_distances_between_stop_points_in_journey_pattern(
  journey_pattern_id   uuid,
  observation_date     date,
  include_draft_stops  boolean
)
  RETURNS SETOF service_pattern.distance_between_stops_calculation
  STABLE
  PARALLEL SAFE
  LANGUAGE sql AS
$$
SELECT *
FROM service_pattern.get_distances_between_stop_points_in_journey_patterns(ARRAY[journey_pattern_id], observation_date, include_draft_stops)
$$;
COMMENT ON FUNCTION service_pattern.get_distances_between_stop_points_in_journey_pattern(uuid, date, boolean)
IS 'Get the distances between scheduled stop points (in metres) for the given journey/service pattern.';


CREATE OR REPLACE FUNCTION service_pattern.get_distances_between_stop_points_by_routes(
  route_ids         uuid[],
  observation_date  date
)
  RETURNS SETOF service_pattern.distance_between_stops_calculation
  STABLE
  PARALLEL SAFE
  LANGUAGE sql AS
$$
SELECT stop_interval_length.*
FROM (
  SELECT
    r.route_id,
    array_agg(jp.journey_pattern_id) AS journey_pattern_ids
  FROM route.route r
  JOIN journey_pattern.journey_pattern jp ON jp.on_route_id = r.route_id
  WHERE
    r.route_id = ANY(route_ids)
    AND internal_utils.daterange_closed_upper(r.validity_start, r.validity_end) @> observation_date
  GROUP BY r.route_id
) ids
JOIN LATERAL (
  SELECT *
  FROM service_pattern.get_distances_between_stop_points_in_journey_patterns(ids.journey_pattern_ids, observation_date, false)
) stop_interval_length USING (route_id)
ORDER BY journey_pattern_id ASC, stop_interval_sequence ASC
$$;
COMMENT ON FUNCTION service_pattern.get_distances_between_stop_points_by_routes(uuid[], date)
IS 'Get the distances between scheduled stop points (in metres) for the journey/service patterns resolved from the route identifiers.';
