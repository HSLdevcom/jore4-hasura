CREATE OR REPLACE FUNCTION route.find_route_ids(
  line_id           uuid,
  route_priority    int,
  observation_date  date
)
  RETURNS SETOF uuid
  STABLE
  PARALLEL SAFE
  LANGUAGE sql AS
$$
SELECT route_id
FROM route.route r
WHERE on_line_id = line_id
  AND priority = route_priority
  AND internal_utils.daterange_closed_upper(validity_start, validity_end) @> observation_date
$$;
COMMENT ON FUNCTION route.find_route_ids(uuid, int, date)
IS 'Find the IDs for routes that belong to the given line, have the given priority and are valid on the given date.';


CREATE OR REPLACE FUNCTION service_pattern.find_scheduled_stop_point_locations_in_journey_pattern(
  filter_journey_pattern_id  uuid,
  observation_date           date
)
  RETURNS TABLE (
    journey_pattern_id                 uuid,
    scheduled_stop_point_sequence      integer,
    scheduled_stop_point_id            uuid,
    label                              text,
    measured_location                  geography(PointZ,4326),
    located_on_infrastructure_link_id  uuid,
    direction                          text,
    timing_place_id                    uuid
  )
  STABLE
  PARALLEL SAFE
  LANGUAGE sql AS
$$
WITH unambiguous_sspijp AS (
  SELECT
    sspijp.journey_pattern_id,
    sspijp.scheduled_stop_point_sequence,
    -- Pick the stop point instance with highest priority.
    first_value(ssp.scheduled_stop_point_id) OVER (
      PARTITION BY sspijp.journey_pattern_id, sspijp.scheduled_stop_point_sequence
      ORDER BY ssp.priority DESC
    ) AS scheduled_stop_point_id
  FROM journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
  JOIN service_pattern.scheduled_stop_point_invariant sspi ON sspi.label = sspijp.scheduled_stop_point_label
  JOIN service_pattern.scheduled_stop_point ssp USING (label)
  WHERE sspijp.journey_pattern_id = filter_journey_pattern_id
    AND ssp.priority < internal_utils.const_priority_draft()
    AND internal_utils.daterange_closed_upper(ssp.validity_start, ssp.validity_end) @> observation_date
)
SELECT
  journey_pattern_id,
  -- Generate continuous (gapless) sequence number starting from 1.
  row_number() OVER(ORDER BY scheduled_stop_point_sequence ASC)::integer AS scheduled_stop_point_sequence,
  scheduled_stop_point_id,
  label,
  measured_location,
  located_on_infrastructure_link_id,
  direction,
  timing_place_id
FROM unambiguous_sspijp sspijp
JOIN service_pattern.scheduled_stop_point ssp USING (scheduled_stop_point_id)
$$;
COMMENT ON FUNCTION service_pattern.find_scheduled_stop_point_locations_in_journey_pattern(uuid, date)
IS 'Get location information for scheduled stop points in journey/service pattern.';


CREATE OR REPLACE FUNCTION service_pattern.get_distances_between_stop_points(
  journey_pattern_ids  uuid[],
  observation_date     date
)
  RETURNS TABLE (
    route_id                uuid,
    journey_pattern_id      uuid,
    stop_interval_sequence  integer,
    start_stop_label        text,
    end_stop_label          text,
    distance_in_metres      double precision
  )
  STABLE
  PARALLEL SAFE
  LANGUAGE sql AS
$$
WITH RECURSIVE
scheduled_stop_point_info AS (
  SELECT
    jp.on_route_id                         AS route_id,
    jp.journey_pattern_id,
    ssp.scheduled_stop_point_sequence      AS stop_point_sequence,
    ssp.label                              AS stop_point_label,
    ssp.measured_location                  AS stop_point_location,
    ssp.located_on_infrastructure_link_id  AS infrastructure_link_id,
    ssp.direction                          AS stop_point_direction
  FROM journey_pattern.journey_pattern jp
  JOIN LATERAL (
    SELECT *
    FROM service_pattern.find_scheduled_stop_point_locations_in_journey_pattern(jp.journey_pattern_id, observation_date)
  ) ssp USING (journey_pattern_id)
  WHERE jp.journey_pattern_id = ANY(journey_pattern_ids)
),
ssp_merged_with_ilar AS ( -- contains recursive term
  SELECT
    sspi.route_id,
    sspi.journey_pattern_id,
    sspi.stop_point_sequence,
    sspi.stop_point_label,
    sspi.stop_point_location,

    -- It is assumed, that we stop at the first matching infrastructure link.
    -- 
    -- Our data model does not properly support going around a loop without
    -- stopping at the same stop point in each loop.
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
  UNION ALL
  -- recursive term begins
  SELECT
    sspi.route_id,
    sspi.journey_pattern_id,
    sspi.stop_point_sequence,
    sspi.stop_point_label,
    sspi.stop_point_location,

    -- It is assumed, that we stop at the first matching infrastructure link.
    -- See more remarks above (in the non-recursive term).
    first_value(ilar.infrastructure_link_sequence) OVER (
      ORDER BY ilar.infrastructure_link_sequence ASC
    ) AS route_link_sequence_start

  FROM ssp_merged_with_ilar prev
  JOIN scheduled_stop_point_info sspi
    ON sspi.journey_pattern_id = prev.journey_pattern_id
      AND sspi.stop_point_sequence = prev.stop_point_sequence + 1
  JOIN route.infrastructure_link_along_route ilar
    ON ilar.route_id = sspi.route_id
      AND ilar.infrastructure_link_id = sspi.infrastructure_link_id
  WHERE ilar.infrastructure_link_sequence > prev.route_link_sequence_start
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
      stop_point_location AS start_stop_location,
      lead(stop_point_location) OVER (
        PARTITION BY journey_pattern_id
        ORDER BY stop_point_sequence ASC
      ) AS end_stop_location,
      route_id,
      route_link_sequence_start,
      lead(route_link_sequence_start) OVER (
        PARTITION BY journey_pattern_id
        ORDER BY route_link_sequence_start ASC
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
    CASE
      WHEN line_endpoints IS NULL THEN l.estimated_length_in_metres
      ELSE
        ST_3DLength( -- take elevation changes into account
          ST_LineSubstring(
            -- This transformation should result in a metric coordinate system.
            -- E.g. EPSG:4326 is not like that.
            ST_Transform(l.shape::geometry, internal_utils.determine_srid(l.shape)),
            line_endpoints[1],
            line_endpoints[2]
          )
        )
    END AS distance_in_metres
  FROM stop_interval si
  JOIN route.infrastructure_link_along_route ilar
    ON ilar.route_id = si.route_id
      AND ilar.infrastructure_link_sequence
        BETWEEN si.route_link_sequence_start AND si.route_link_sequence_end
  JOIN infrastructure_network.infrastructure_link l USING (infrastructure_link_id)
  CROSS JOIN LATERAL (
    -- Resolve start/end point on the first/last infra link in stop interval.
    SELECT CASE
      -- both stop points along same single link
      WHEN si.route_link_sequence_start = si.route_link_sequence_end THEN
        CASE
          WHEN ilar.is_traversal_forwards THEN
            ARRAY[
              internal_utils.ST_LineLocatePoint(l.shape, start_stop_location),
              internal_utils.ST_LineLocatePoint(l.shape, end_stop_location)
            ]
          ELSE
            ARRAY[
              internal_utils.ST_LineLocatePoint(l.shape, end_stop_location),
              internal_utils.ST_LineLocatePoint(l.shape, start_stop_location)
            ]
        END
      WHEN ilar.infrastructure_link_sequence = si.route_link_sequence_start THEN
        CASE
          WHEN ilar.is_traversal_forwards THEN
            ARRAY[
              internal_utils.ST_LineLocatePoint(l.shape, start_stop_location),
              1.0
            ]
          ELSE
            ARRAY[
              0.0,
              internal_utils.ST_LineLocatePoint(l.shape, start_stop_location)
            ]
        END
      WHEN ilar.infrastructure_link_sequence = si.route_link_sequence_end THEN
        CASE
          WHEN ilar.is_traversal_forwards THEN
            ARRAY[
              0.0,
              internal_utils.ST_LineLocatePoint(l.shape, end_stop_location)
            ]
          ELSE
            ARRAY[
              internal_utils.ST_LineLocatePoint(l.shape, end_stop_location),
              1.0
            ]
        END
      ELSE NULL -- not the first or last link in sequence, will use the estimated length column instead.
    END AS line_endpoints
  ) sub
),
stop_interval_distance AS (
  SELECT journey_pattern_id, stop_interval_sequence, sum(distance_in_metres) AS total_distance_in_metres
  FROM route_link_traversal
  GROUP BY journey_pattern_id, stop_interval_sequence
)
SELECT
  route_id,
  journey_pattern_id,
  stop_interval_sequence,
  start_stop_label,
  end_stop_label,
  total_distance_in_metres AS distance_in_metres
FROM stop_interval si
JOIN stop_interval_distance dist USING (journey_pattern_id, stop_interval_sequence)
ORDER BY route_id, journey_pattern_id, stop_interval_sequence;
$$;
COMMENT ON FUNCTION service_pattern.get_distances_between_stop_points(uuid[], date)
IS 'Get the distances between scheduled stop points (in metres) for the given journey/service patterns.';


CREATE OR REPLACE FUNCTION service_pattern.get_distances_between_stop_points_for_journey_patterns(
  line_id           uuid,
  route_priority    integer,
  observation_date  date
)
  RETURNS TABLE (
    route_id                uuid,
    journey_pattern_id      uuid,
    stop_interval_sequence  integer,
    start_stop_label        text,
    end_stop_label          text,
    distance_in_metres      double precision
  )
  STABLE
  PARALLEL SAFE
  LANGUAGE sql AS
$$
SELECT *
FROM service_pattern.get_distances_between_stop_points(
  (
    SELECT array_agg(journey_pattern_id) AS journey_pattern_ids
    FROM journey_pattern.journey_pattern
    WHERE on_route_id IN (SELECT route.find_route_ids(line_id, route_priority, observation_date))
  ),
  observation_date
)
$$;
COMMENT ON FUNCTION service_pattern.get_distances_between_stop_points_for_journey_patterns(uuid, integer, date)
IS 'Get the distances between scheduled stop points (in metres) for the journey/service patterns resolved from the routes belonging to the given line.';
