-- The previous version of the route verification triggered individual runs of the route verification
-- function for every route to be checked, which was - despite all optimizations done up until that point -
-- quite slow. This version checks all routes in one go and additionally also checks that there are no
-- so-called "ghost stop points", whose validity span does not overlap with the route's validity span at all
-- (which causes the stop points from appearing on the journey pattern).


--------------------------------------------------------
-- tear down previous version of functions and triggers
--------------------------------------------------------

ALTER FUNCTION journey_pattern.maximum_priority_validity_spans(
  entity_type TEXT,
  filter_validity_start TIMESTAMP WITH TIME ZONE,
  filter_validity_end TIMESTAMP WITH TIME ZONE,
  upper_priority_limit INT,
  replace_scheduled_stop_point_id UUID,
  new_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE,
  new_priority int
  )
  RENAME TO maximum_priority_validity_spans_1661496355072;

ALTER FUNCTION journey_pattern.maximum_priority_validity_spans_1661496355072(
  entity_type TEXT,
  filter_validity_start TIMESTAMP WITH TIME ZONE,
  filter_validity_end TIMESTAMP WITH TIME ZONE,
  upper_priority_limit INT,
  replace_scheduled_stop_point_id UUID,
  new_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE,
  new_priority int
  )
  SET SCHEMA deleted;



ALTER FUNCTION journey_pattern.check_route_journey_pattern_refs(
  filter_journey_pattern_id uuid,
  filter_route_id uuid,
  replace_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE,
  new_priority INT
  )
  RENAME TO check_route_journey_pattern_refs_1661496355072;

ALTER FUNCTION journey_pattern.check_route_journey_pattern_refs_1661496355072(
  filter_journey_pattern_id uuid,
  filter_route_id uuid,
  replace_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE,
  new_priority INT
  )
  SET SCHEMA deleted;



ALTER FUNCTION journey_pattern.check_infra_link_stop_refs_with_new_scheduled_stop_point(
  replace_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE,
  new_priority INT
  )
  RENAME TO check_infra_link_stop_refs_with_new_ssp_1661496355072;

ALTER FUNCTION journey_pattern.check_infra_link_stop_refs_with_new_ssp_1661496355072(
  replace_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE,
  new_priority INT
  )
  SET SCHEMA deleted;



ALTER FUNCTION journey_pattern.create_verify_infra_link_stop_refs_queue_temp_table()
  RENAME TO create_verify_infra_link_stop_refs_queue_temp_t_1661496355072;

ALTER FUNCTION journey_pattern.create_verify_infra_link_stop_refs_queue_temp_t_1661496355072()
  SET SCHEMA deleted;



ALTER FUNCTION journey_pattern.verify_infra_link_stop_refs()
  RENAME TO verify_infra_link_stop_refs_1661496355072;

ALTER FUNCTION journey_pattern.verify_infra_link_stop_refs_1661496355072()
  SET SCHEMA deleted;



DROP TRIGGER verify_infra_link_stop_refs_on_sspijp_trigger
  ON journey_pattern.scheduled_stop_point_in_journey_pattern;

DROP TRIGGER verify_infra_link_stop_refs_on_ilar_trigger
  ON route.infrastructure_link_along_route;

DROP TRIGGER verify_infra_link_stop_refs_on_scheduled_stop_point_trigger
  ON internal_service_pattern.scheduled_stop_point;

DROP TRIGGER verify_infra_link_stop_refs_on_journey_pattern_trigger
  ON journey_pattern.journey_pattern;

DROP TRIGGER verify_infra_link_stop_refs_on_route_trigger
  ON route.route;



DROP TRIGGER queue_verify_infra_link_stop_refs_on_sspijp_insert_trigger
  ON journey_pattern.scheduled_stop_point_in_journey_pattern;
DROP TRIGGER queue_verify_infra_link_stop_refs_on_sspijp_update_trigger
  ON journey_pattern.scheduled_stop_point_in_journey_pattern;

DROP TRIGGER queue_verify_infra_link_stop_refs_on_ilar_update_trigger
  ON route.infrastructure_link_along_route;
DROP TRIGGER queue_verify_infra_link_stop_refs_on_ilar_delete_trigger
  ON route.infrastructure_link_along_route;

DROP TRIGGER queue_verify_infra_link_stop_refs_on_ssp_insert_trigger
  ON internal_service_pattern.scheduled_stop_point;
DROP TRIGGER queue_verify_infra_link_stop_refs_on_ssp_update_trigger
  ON internal_service_pattern.scheduled_stop_point;
DROP TRIGGER queue_verify_infra_link_stop_refs_on_ssp_delete_trigger
  ON internal_service_pattern.scheduled_stop_point;

DROP TRIGGER queue_verify_infra_link_stop_refs_on_jp_update_trigger
  ON journey_pattern.journey_pattern;

DROP TRIGGER queue_verify_infra_link_stop_refs_on_route_delete_trigger
  ON route.route;


ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_ssp_label()
  RENAME TO queue_verify_infra_link_stop_refs_by_new_ssp_l_1661496355072;

ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_ssp_l_1661496355072()
  SET SCHEMA deleted;


ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_id()
  RENAME TO queue_verify_infra_link_stop_refs_by_old_route_id_1661496355072;

ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_id_1661496355072()
  SET SCHEMA deleted;


ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_journey_pattern_id()
  RENAME TO queue_verify_infra_link_stop_refs_by_new_jp_id_1661496355072;

ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_jp_id_1661496355072()
  SET SCHEMA deleted;


ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_other_journey_pattern_ids()
  RENAME TO queue_verify_infra_link_stop_refs_by_other_jp_ids_1661496355072;

ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_other_jp_ids_1661496355072()
  SET SCHEMA deleted;


ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_other_route_ids()
  RENAME TO queue_verify_infra_link_stop_refs_by_other_r_ids_1661496355072;

ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_other_r_ids_1661496355072()
  SET SCHEMA deleted;



--------------------------------------------------------
-- create the new functions
--------------------------------------------------------

CREATE FUNCTION journey_pattern.get_broken_route_check_filters(filter_route_ids UUID[])
  RETURNS TABLE
          (
            labels         TEXT[],
            validity_start TIMESTAMP WITH TIME ZONE,
            validity_end   TIMESTAMP WITH TIME ZONE
          )
  STABLE
  PARALLEL SAFE
  LANGUAGE SQL
AS
$$
WITH RECURSIVE
  route_param AS (
    SELECT label,
           TSTZRANGE(r.validity_start, r.validity_end)   AS validity_range,
           ROW_NUMBER() OVER (ORDER BY r.validity_start) AS ord
    FROM route.route r
    WHERE r.route_id = ANY (filter_route_ids)
  ),
  -- Merge the route ranges to be checked into one. In common use cases, there should not be any (significant)
  -- gaps between the ranges, but with future versions of postgresql it will be possible and might be good to change
  -- this to use tstzmultirange instead of merging the ranges.
  merged_route_range AS (
    SELECT validity_range, ord
    FROM route_param
    WHERE ord = 1
    UNION ALL
    SELECT range_merge(prev.validity_range, cur.validity_range), cur.ord
    FROM merged_route_range prev
           JOIN route_param cur ON cur.ord = prev.ord + 1
  )
  -- gather the array of route labels to check and the merged route validity range
SELECT (SELECT array_agg(DISTINCT label) FROM route_param) AS labels,
       LOWER(validity_range)                               AS validity_start,
       UPPER(validity_range)                               AS validity_end
FROM merged_route_range
WHERE ord = (SELECT max(ord) FROM merged_route_range);
$$;
COMMENT ON FUNCTION journey_pattern.get_broken_route_check_filters(filter_route_ids UUID[])
IS 'Gather the filter parameters (route labels and validity range to check) for the broken route check.';



CREATE FUNCTION journey_pattern.maximum_priority_validity_spans(
  entity_type TEXT,
  filter_route_labels TEXT[],
  filter_validity_start TIMESTAMP WITH TIME ZONE DEFAULT NULL,
  filter_validity_end TIMESTAMP WITH TIME ZONE DEFAULT NULL,
  upper_priority_limit INT DEFAULT NULL,
  replace_scheduled_stop_point_id UUID DEFAULT NULL,
  new_scheduled_stop_point_id UUID DEFAULT NULL,
  new_located_on_infrastructure_link_id UUID DEFAULT NULL,
  new_measured_location geography(PointZ, 4326) DEFAULT NULL,
  new_direction TEXT DEFAULT NULL,
  new_label TEXT DEFAULT NULL,
  new_validity_start timestamp WITH TIME ZONE DEFAULT NULL,
  new_validity_end timestamp WITH TIME ZONE DEFAULT NULL,
  new_priority int DEFAULT NULL
)
  RETURNS TABLE
          (
            id             UUID,
            validity_start TIMESTAMP WITH TIME ZONE,
            validity_end   TIMESTAMP WITH TIME ZONE
          )
  STABLE
  PARALLEL SAFE
  LANGUAGE SQL
AS
$$
WITH RECURSIVE
  -- collect the entities matching the given parameters
  entity AS (
    SELECT r.route_id AS id, r.validity_start, r.validity_end, r.LABEL AS key1, r.direction AS key2, r.priority
    FROM route.route r
    WHERE entity_type = 'route'
      AND TSTZRANGE(r.validity_start, r.validity_end) && TSTZRANGE(filter_validity_start, filter_validity_end)
      AND (r.label = ANY (filter_route_labels) OR filter_route_labels IS NULL)
      AND (r.priority < upper_priority_limit OR upper_priority_limit IS NULL)
    UNION ALL
    SELECT ssp.scheduled_stop_point_id AS id,
           ssp.validity_start,
           ssp.validity_end,
           ssp.label                   AS key1,
           NULL                        AS key2,
           ssp.priority
    FROM internal_service_pattern.get_scheduled_stop_points_with_new(
           replace_scheduled_stop_point_id,
           new_scheduled_stop_point_id,
           new_located_on_infrastructure_link_id,
           new_measured_location,
           new_direction,
           new_label,
           new_validity_start,
           new_validity_end,
           new_priority) ssp
    WHERE entity_type = 'scheduled_stop_point'
      AND TSTZRANGE(ssp.validity_start, ssp.validity_end) && TSTZRANGE(filter_validity_start, filter_validity_end)
      AND (ssp.priority < upper_priority_limit OR upper_priority_limit IS NULL)
      AND (EXISTS(
             SELECT 1
             FROM journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
                    JOIN journey_pattern.journey_pattern jp ON jp.journey_pattern_id = sspijp.journey_pattern_id
                    JOIN route.route r
                         ON r.route_id = jp.on_route_id
                           AND r.label = ANY (filter_route_labels)
             WHERE sspijp.scheduled_stop_point_label = ssp.LABEL
             ) OR filter_route_labels IS NULL)
  ),
  -- form the list of potential validity span boundaries
  boundary AS (
    SELECT e.validity_start, TRUE AS is_start, e.key1, e.key2, e.priority
    FROM entity e
    UNION ALL
    SELECT e.validity_end, FALSE AS is_start, e.key1, e.key2, e.priority
    FROM entity e
  ),
  -- order the list both ascending and descending, because it has to be traversed both ways below
  ordered_boundary AS (
    SELECT *,
           -- The "validity_start IS NULL" cases have to be interpreted together with "is_start". Depending on the latter value,
           -- "validity_start IS NULL" can mean "negative inf" or "positive inf"
           row_number()
           OVER (PARTITION BY key1, key2 ORDER BY is_start AND validity_start IS NULL DESC, validity_start ASC)      AS start_order,
           row_number()
           OVER (PARTITION BY key1, key2 ORDER BY NOT is_start AND validity_start IS NULL DESC, validity_start DESC) AS end_order
    FROM boundary
  ),
  -- mark the minimum priority for each row, at which a start validity boundary is relevant (i.e. not overlapped by a higher priority)
  marked_min_start_priority AS (
    SELECT *, priority AS cur_start_priority
    FROM ordered_boundary
    WHERE start_order = 1
    UNION ALL
    SELECT next_boundary.*,
           CASE
             WHEN next_boundary.is_start AND next_boundary.priority > cur_start_priority THEN next_boundary.priority
             WHEN NOT next_boundary.is_start AND next_boundary.priority >= cur_start_priority THEN 0
             ELSE cur_start_priority
             END AS cur_start_priority
    FROM marked_min_start_priority marked
           JOIN ordered_boundary next_boundary
                ON next_boundary.start_order = marked.start_order + 1 AND next_boundary.key1 = marked.key1 AND
                   (next_boundary.key2 = marked.key2 OR next_boundary.key2 IS NULL)
  ),
  -- mark the minimum priority for each row, at which an end validity boundary is relevant (i.e. not overlapped by a higher priority)
  marked_min_start_end_priority AS (
    SELECT *, priority AS cur_end_priority
    FROM marked_min_start_priority
    WHERE end_order = 1
    UNION ALL
    SELECT next_boundary.*,
           CASE
             WHEN NOT next_boundary.is_start AND next_boundary.priority > cur_end_priority THEN next_boundary.priority
             WHEN next_boundary.is_start AND next_boundary.priority >= cur_end_priority THEN 0
             ELSE cur_end_priority
             END AS cur_end_priority
    FROM marked_min_start_end_priority marked
           JOIN marked_min_start_priority next_boundary
                ON next_boundary.end_order = marked.end_order + 1 AND next_boundary.key1 = marked.key1 AND
                   (next_boundary.key2 = marked.key2 OR next_boundary.key2 IS NULL)
  ),
  -- filter only the relevant boundaries and connect them to form validity spans (with both start and end)
  reduced_boundary AS (
    SELECT key1,
           key2,
           lead(TRUE, 1, false) OVER entity_window AS has_next,
           validity_start,
           lead(validity_start) OVER entity_window AS validity_end
    FROM marked_min_start_end_priority
    WHERE priority >= cur_end_priority
      AND priority >= cur_start_priority
      WINDOW entity_window AS (PARTITION BY key1, key2 ORDER BY start_order)
  ),
  -- find the instances which are valid in the validity spans
  boundary_with_entities AS (
    SELECT rb.key1, rb.key2, rb.has_next, rb.validity_start, rb.validity_end, e.id, e.priority
    FROM reduced_boundary rb
           JOIN entity e ON e.key1 = rb.key1 AND (e.key2 = rb.key2 OR e.key2 IS NULL) AND
                            TSTZRANGE(e.validity_start, e.validity_end) && TSTZRANGE(rb.validity_start, rb.validity_end)
    WHERE rb.has_next
  )
-- choose the instance with the highest priority for each validity span and
SELECT id, validity_start, validity_end
FROM (SELECT id,
             validity_start,
             validity_end,
             priority,
             max(priority) OVER (PARTITION BY key1, key2, validity_start) AS max_priority
      FROM boundary_with_entities) bwe
WHERE priority = max_priority
$$;
COMMENT ON FUNCTION journey_pattern.maximum_priority_validity_spans(
  entity_type TEXT,
  filter_route_labels TEXT[],
  filter_validity_start TIMESTAMP WITH TIME ZONE,
  filter_validity_end TIMESTAMP WITH TIME ZONE,
  upper_priority_limit INT,
  replace_scheduled_stop_point_id UUID,
  new_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE,
  new_priority int
  )
  IS
    'Find the validity time spans of highest priority in the given time span for entities of the given type (routes or
    scheduled stop points), which are related to routes with any of the given labels.

    Consider the validity times of two overlapping route instances with label A:
    A* (prio 20):        |-------|
    A (prio 10):   |-------------------------|

    These would be split into the following maximum priority validity time spans:
                   |--A--|--A*---|----A------|

    For scheduled stop points the splitting is performed in the same fashion, except that if
    replace_scheduled_stop_point_id is not null, the stop with that id is left out. If the new_xxx arguments are
    specified, the check is also performed for a stop defined by those arguments, which is not yet present in the
    table data.';



CREATE FUNCTION journey_pattern.get_broken_route_journey_patterns(
  filter_route_ids UUID[],
  replace_scheduled_stop_point_id UUID DEFAULT NULL,
  new_located_on_infrastructure_link_id UUID DEFAULT NULL,
  new_measured_location geography(PointZ, 4326) DEFAULT NULL,
  new_direction TEXT DEFAULT NULL,
  new_label TEXT DEFAULT NULL,
  new_validity_start timestamp WITH TIME ZONE DEFAULT NULL,
  new_validity_end timestamp WITH TIME ZONE DEFAULT NULL,
  new_priority INT DEFAULT NULL
)
  RETURNS SETOF journey_pattern.journey_pattern
  STABLE
  PARALLEL SAFE
  LANGUAGE SQL
AS
$$
WITH RECURSIVE
  new_ssp_param AS (
    SELECT CASE WHEN new_located_on_infrastructure_link_id IS NOT NULL THEN gen_random_uuid() END
             AS new_scheduled_stop_point_id
  ),
  filter_route AS (
    SELECT labels, validity_start, validity_end
    FROM journey_pattern.get_broken_route_check_filters(filter_route_ids)
  ),
  -- fetch the route entities with their prioritized validity times
  prioritized_route AS (
    SELECT r.route_id,
           r.label,
           r.direction,
           r.priority,
           priority_validity_spans.validity_start,
           priority_validity_spans.validity_end
    FROM route.route r
           JOIN journey_pattern.maximum_priority_validity_spans(
      'route',
      (SELECT labels FROM filter_route),
      (SELECT validity_start FROM filter_route),
      (SELECT validity_end FROM filter_route),
      internal_utils.const_priority_draft()
      ) priority_validity_spans
                ON priority_validity_spans.id = r.route_id
  ),
  ssp_with_new AS (
    SELECT *
    FROM internal_service_pattern.get_scheduled_stop_points_with_new(
      replace_scheduled_stop_point_id,
      (SELECT new_scheduled_stop_point_id FROM new_ssp_param),
      new_located_on_infrastructure_link_id,
      new_measured_location,
      new_direction,
      new_label,
      new_validity_start,
      new_validity_end,
      new_priority
      )
  ),
  -- fetch the stop point entities with their prioritized validity times
  prioritized_ssp_with_new AS (
    SELECT ssp.scheduled_stop_point_id,
           ssp.located_on_infrastructure_link_id,
           ssp.measured_location,
           ssp.relative_distance_from_infrastructure_link_start,
           ssp.direction,
           ssp.label,
           ssp.priority,
           priority_validity_spans.validity_start,
           priority_validity_spans.validity_end
    FROM ssp_with_new ssp
           JOIN journey_pattern.maximum_priority_validity_spans(
      'scheduled_stop_point',
      (SELECT labels FROM filter_route),
      (SELECT validity_start FROM filter_route),
      (SELECT validity_end FROM filter_route),
      internal_utils.const_priority_draft(),
      replace_scheduled_stop_point_id,
      (SELECT new_scheduled_stop_point_id FROM new_ssp_param),
      new_located_on_infrastructure_link_id,
      new_measured_location,
      new_direction,
      new_label,
      new_validity_start,
      new_validity_end,
      new_priority
      ) priority_validity_spans
                ON priority_validity_spans.id = ssp.scheduled_stop_point_id
  ),
  -- For all stops in the journey patterns, list all visits of the stop's infra link. (But only include
  -- visits happening in a direction matching the stop's allowed directions - if the direction is wrong,
  -- we cannot approach the stop point on that particular link visit. Similarly, include only those stop
  -- instances, whose validity period overlaps with the route's priority span's validity period.)
  sspijp_ilar_combos AS (
    SELECT sspijp.journey_pattern_id,
           ssp.scheduled_stop_point_id,
           sspijp.scheduled_stop_point_sequence,
           sspijp.stop_point_order,
           ssp.relative_distance_from_infrastructure_link_start,
           ilar.route_id,
           ilar.infrastructure_link_id,
           ilar.infrastructure_link_sequence,
           ilar.is_traversal_forwards
    FROM (
           SELECT r.route_id,
                  jp.journey_pattern_id,
                  sspijp.scheduled_stop_point_label,
                  sspijp.scheduled_stop_point_sequence,
                  -- Create a continuous sequence number of the scheduled_stop_point_sequence (which is not
                  -- required to be continuous, i.e. there can be gaps).
                  -- Note that the sequence number is assigned for the whole journey pattern, not for individual
                  -- route validity spans. This means that the route verification is performed for all stops in the
                  -- journey pattern at once, i.e. it is intentionally not possible to have a stop order in one route
                  -- validity span that is in conflict with the stop order in another route validity span. This is to
                  -- prevent situations in which it would be impossible to remove a higher priority route due to the
                  -- adjacent lower priority route spans having incompatible stop orders.
                  ROW_NUMBER()
                  OVER (PARTITION BY sspijp.journey_pattern_id ORDER BY sspijp.scheduled_stop_point_sequence) AS stop_point_order
           FROM route.route r
                  JOIN journey_pattern.journey_pattern jp ON jp.on_route_id = r.route_id
                  JOIN journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
                       ON sspijp.journey_pattern_id = jp.journey_pattern_id
           WHERE r.route_id = ANY (filter_route_ids)
         ) AS sspijp
           JOIN prioritized_ssp_with_new ssp
                ON ssp.label = sspijp.scheduled_stop_point_label
           JOIN prioritized_route r
                ON r.route_id = sspijp.route_id
                  -- scheduled stop point instances, whose validity period does not overlap with the
                  -- route's validity period, are filtered out here
                  AND TSTZRANGE(ssp.validity_start, ssp.validity_end) &&
                      TSTZRANGE(r.validity_start, r.validity_end)
           JOIN route.infrastructure_link_along_route ilar
                ON ilar.route_id = r.route_id
                  AND ilar.infrastructure_link_id = ssp.located_on_infrastructure_link_id
                  -- visits of the link in a direction not matching the stop's possible directions are
                  -- filtered out here
                  AND (ssp.direction = 'bidirectional' OR
                       ((ssp.direction = 'forward' AND ilar.is_traversal_forwards = true)
                         OR (ssp.direction = 'backward' AND ilar.is_traversal_forwards = false)))
  ),
  -- Iteratively try to traverse the journey patterns in their specified order one stop point at a time, such
  -- that all visited links appear in ascending order on each journey pattern's route.
  -- Note that this CTE will contain more rows than only the ones depicting actual traversals. To find
  -- actual possible traversals, choose the row with min(infrastructure_link_sequence) for every listed stop
  -- visit, as done below.
  traversal AS (
    SELECT *
    FROM sspijp_ilar_combos
    WHERE stop_point_order = 1
    UNION ALL
    SELECT sspijp_ilar_combos.*
    FROM traversal
           JOIN sspijp_ilar_combos ON sspijp_ilar_combos.journey_pattern_id = traversal.journey_pattern_id
         -- select the next stop
    WHERE sspijp_ilar_combos.stop_point_order = traversal.stop_point_order + 1
      -- Only allow visiting the route links in ascending route link order. If two stops are on the same
      -- link, check that they are traversed in accordance with their location on the link.
      AND (sspijp_ilar_combos.infrastructure_link_sequence > traversal.infrastructure_link_sequence
      OR (sspijp_ilar_combos.infrastructure_link_sequence = traversal.infrastructure_link_sequence
        AND ((sspijp_ilar_combos.is_traversal_forwards AND
              sspijp_ilar_combos.relative_distance_from_infrastructure_link_start >=
              traversal.relative_distance_from_infrastructure_link_start)
          OR (NOT sspijp_ilar_combos.is_traversal_forwards AND
              sspijp_ilar_combos.relative_distance_from_infrastructure_link_start <=
              traversal.relative_distance_from_infrastructure_link_start)
            )
             )
      )
  ),
  -- List all stops of the journey pattern and left-join their visits in the traversal performed above.
  infra_link_seq AS (
    SELECT route_id,
           scheduled_stop_point_id,
           infrastructure_link_sequence,
           -- also order by scheduled_stop_point_id to get a deterministic order between stops with the same
           -- label
           ROW_NUMBER() OVER (
             PARTITION BY journey_pattern_id
             ORDER BY
               stop_point_order,
               infrastructure_link_sequence,
               CASE
                 WHEN is_traversal_forwards THEN relative_distance_from_infrastructure_link_start
                 ELSE -relative_distance_from_infrastructure_link_start END,
               scheduled_stop_point_id)
             AS stop_point_order,
           ROW_NUMBER() OVER (
             PARTITION BY journey_pattern_id
             ORDER BY
               infrastructure_link_sequence,
               CASE
                 WHEN is_traversal_forwards THEN relative_distance_from_infrastructure_link_start
                 ELSE -relative_distance_from_infrastructure_link_start END,
               stop_point_order,
               scheduled_stop_point_id)
             AS infra_link_order,
           is_ghost_ssp
    FROM (
           SELECT t.journey_pattern_id,
                  t.stop_point_order,
                  t.infrastructure_link_sequence,
                  t.is_traversal_forwards,
                  t.relative_distance_from_infrastructure_link_start,
                  t.scheduled_stop_point_id,
                  ROW_NUMBER()
                  OVER (PARTITION BY sspijp.journey_pattern_id, ssp.scheduled_stop_point_id, r.route_id, infrastructure_link_id, stop_point_order ORDER BY infrastructure_link_sequence)
                                                          AS order_by_min,
                  r.route_id,
                  ssp.scheduled_stop_point_id IS NOT NULL AS ssp_match,
                  -- if there is no matching stop point within the validity span in question, check if there is a
                  -- matching ssp at all on the entire route
                  (ssp.scheduled_stop_point_id IS NULL
                    AND NOT EXISTS(
                      SELECT 1
                      FROM route.route full_route
                             JOIN ssp_with_new any_ssp ON any_ssp.label = sspijp.scheduled_stop_point_label
                      WHERE full_route.route_id = jp.on_route_id
                        AND TSTZRANGE(full_route.validity_start, full_route.validity_end) &&
                            TSTZRANGE(any_ssp.validity_start, any_ssp.validity_end)
                      )
                    )                                     AS is_ghost_ssp
           FROM prioritized_route r
                  JOIN journey_pattern.journey_pattern jp ON jp.on_route_id = r.route_id
                  JOIN journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
                       ON sspijp.journey_pattern_id = jp.journey_pattern_id
                  LEFT JOIN prioritized_ssp_with_new ssp  -- left join to be able to find the ghost ssp
                            ON ssp.label = sspijp.scheduled_stop_point_label
                              AND TSTZRANGE(ssp.validity_start, ssp.validity_end) &&
                                  TSTZRANGE(r.validity_start, r.validity_end)
                  LEFT JOIN traversal t
                            ON t.journey_pattern_id = sspijp.journey_pattern_id
                              AND t.scheduled_stop_point_id = ssp.scheduled_stop_point_id
                              AND t.scheduled_stop_point_sequence = sspijp.scheduled_stop_point_sequence
           WHERE r.route_id = ANY (filter_route_ids)
         ) AS ordered_sspijp_ilar_combos
    WHERE (ordered_sspijp_ilar_combos.order_by_min = 1 AND ssp_match)
       OR is_ghost_ssp -- by keeping the ghost ssp lines, we will trigger an exception if any are present
  )
  -- Perform the final route integrity check:
  -- 1. In case no visit is present for any row (infrastructure_link_sequence is null), it was not possible to
  --    visit all stops in a way matching the route's link order.
  -- 2. In case the order of the stops' infra link visits is not the same as the stop order for all stops, this
  --    means that there are stops with the same ordinal number (same label), which have to be visited in a
  --    different order to cover all stops. This in turn means that the stops subsequent to these exceptions cannot
  --    be reached via all combinations of stops.
SELECT jp.*
FROM journey_pattern.journey_pattern jp
WHERE EXISTS(
        SELECT 1
        FROM infra_link_seq ils
        WHERE ils.route_id = jp.on_route_id
          AND (ils.infrastructure_link_sequence IS NULL -- this is also true for any ghost ssp occurrence
          OR ils.stop_point_order != ils.infra_link_order)
        );
$$;
COMMENT ON FUNCTION journey_pattern.get_broken_route_journey_patterns(
  filter_route_ids UUID[],
  replace_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE,
  new_priority INT
  )
  IS
    'Check if it is possible to visit all stops of journey patterns in such a fashion that all links, on which
     the stops reside, are visited in an order matching the corresponding routes'' link order. Additionally it is
     checked that there are no stop points on the route''s journey pattern, whose validity span does not overlap with
     the route''s validity span at all. Only the links / stops on the routes with the specified filter_route_ids are
     taken into account for the checks.

     If replace_scheduled_stop_point_id is not null, the stop with that id is left out of the check.
     If the new_xxx arguments are specified, the check is also performed for an imaginary stop defined by those
     arguments, which is not yet present in the table data.

     This functions returns those journey pattern / route combinations, which are broken (either in actual
     table data or with the proposed scheduled stop point changes).';


CREATE FUNCTION journey_pattern.check_infra_link_stop_refs_with_new_scheduled_stop_point(
  replace_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE,
  new_priority INT
)
  RETURNS SETOF journey_pattern.journey_pattern
  STABLE
  PARALLEL SAFE
  LANGUAGE SQL AS
$$
WITH filter_route_ids AS (
  SELECT array_agg(DISTINCT r.route_id) AS arr
  FROM route.route r
         LEFT JOIN journey_pattern.journey_pattern jp ON jp.on_route_id = r.route_id
         LEFT JOIN journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
                   ON sspijp.journey_pattern_id = jp.journey_pattern_id
         LEFT JOIN internal_service_pattern.scheduled_stop_point ssp
                   ON ssp.label = sspijp.scheduled_stop_point_label
       -- 1. the scheduled stop point instance to be inserted (defined by the new_... arguments) or
  WHERE ((sspijp.scheduled_stop_point_label = new_label AND
          TSTZRANGE(r.validity_start, r.validity_end) && TSTZRANGE(new_validity_start, new_validity_end))
    -- 2. the scheduled stop point instance to be replaced (identified by the replace_scheduled_stop_point_id argument)
    OR (ssp.scheduled_stop_point_id = replace_scheduled_stop_point_id AND
        TSTZRANGE(r.validity_start, r.validity_end) && TSTZRANGE(ssp.validity_start, ssp.validity_end)))
)
SELECT *
FROM journey_pattern.get_broken_route_journey_patterns(
  (SELECT arr FROM filter_route_ids),
  replace_scheduled_stop_point_id,
  new_located_on_infrastructure_link_id,
  new_measured_location,
  new_direction,
  new_label,
  new_validity_start,
  new_validity_end,
  new_priority
  );
$$;
COMMENT ON FUNCTION journey_pattern.check_infra_link_stop_refs_with_new_scheduled_stop_point(
  replace_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE,
  new_priority INT)
  IS
    'Check whether the journey pattern''s / route''s links and stop points still correspond to each other
     if a new stop point would be inserted (defined by arguments new_xxx). If replace_scheduled_stop_point_id
     is specified, the new stop point is thought to replace the stop point with that ID.
     This function returns a list of journey pattern and route ids, in which the links
     and stop points would conflict with each other.';


CREATE FUNCTION journey_pattern.create_verify_infra_link_stop_refs_queue_temp_table()
  RETURNS VOID
  VOLATILE
  PARALLEL SAFE
  LANGUAGE sql AS
$$
  CREATE TEMP TABLE IF NOT EXISTS updated_route
  (
    route_id UUID UNIQUE
  )
    ON COMMIT DELETE ROWS;
  $$;
COMMENT ON FUNCTION journey_pattern.create_verify_infra_link_stop_refs_queue_temp_table()
  IS 'Create the temp table used to enqueue verification of the changed routes from
  statement-level triggers';

-- function to perform verification of all queued journey pattern / route entries

CREATE FUNCTION journey_pattern.verify_infra_link_stop_refs()
  RETURNS TRIGGER
  LANGUAGE plpgsql AS
$$
BEGIN
  --RAISE NOTICE 'journey_pattern.verify_infra_link_stop_refs()';

  IF EXISTS(
    WITH filter_route_ids AS (
      SELECT array_agg(DISTINCT ur.route_id) AS arr
      FROM updated_route ur
    )
    SELECT 1
    FROM journey_pattern.get_broken_route_journey_patterns(
        (SELECT arr FROM filter_route_ids)
      )
      -- ensure there is something to be checked at all
    WHERE EXISTS(SELECT 1 FROM updated_route)
    )
  THEN
    RAISE EXCEPTION 'route''s and journey pattern''s traversal paths must match each other';
  END IF;

  RETURN NULL;
END;
$$;
COMMENT ON FUNCTION journey_pattern.verify_infra_link_stop_refs()
  IS 'Perform verification of all queued route entries.
   Raise an exception if the specified journey pattern''s / route''s links and stop points do not
   correspond to each other.';



CREATE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_ssp_label()
  RETURNS TRIGGER
  LANGUAGE plpgsql AS
$$
BEGIN
  --RAISE NOTICE 'journey_pattern.queue_verify_infra_link_stop_refs_by_new_ssp_label()';

  PERFORM journey_pattern.create_verify_infra_link_stop_refs_queue_temp_table();

  INSERT INTO updated_route (route_id)
  SELECT r.route_id
  FROM new_table
         JOIN route.route r ON EXISTS(
    SELECT 1
    FROM journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
           JOIN journey_pattern.journey_pattern jp ON jp.journey_pattern_id = sspijp.journey_pattern_id
    WHERE sspijp.scheduled_stop_point_label = new_table.label
      AND TSTZRANGE(r.validity_start, r.validity_end) && TSTZRANGE(new_table.validity_start, new_table.validity_end)
      AND jp.on_route_id = r.route_id
    )
  ON CONFLICT DO NOTHING;

  RETURN NULL;
END;
$$;

CREATE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_id()
  RETURNS TRIGGER
  LANGUAGE plpgsql
AS
$$
BEGIN
  --RAISE NOTICE 'journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_id()';

  PERFORM journey_pattern.create_verify_infra_link_stop_refs_queue_temp_table();

  INSERT INTO updated_route (route_id)
  SELECT r.route_id
  FROM old_table
         JOIN route.route r ON r.route_id = old_table.route_id
  ON CONFLICT DO NOTHING;

  RETURN NULL;
END;
$$;

CREATE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_journey_pattern_id()
  RETURNS TRIGGER
  LANGUAGE plpgsql
AS
$$
BEGIN
  --RAISE NOTICE 'journey_pattern.queue_verify_infra_link_stop_refs_by_new_journey_pattern_id()';

  PERFORM journey_pattern.create_verify_infra_link_stop_refs_queue_temp_table();

  INSERT INTO updated_route (route_id)
  SELECT r.route_id
  FROM new_table
         JOIN journey_pattern.journey_pattern jp ON jp.journey_pattern_id = new_table.journey_pattern_id
         JOIN route.route r ON r.route_id = jp.on_route_id
  ON CONFLICT DO NOTHING;

  RETURN NULL;
END;
$$;

-- previously queue_verify_infra_link_stop_refs_by_other_journey_pattern_ids
CREATE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_ssp_label()
  RETURNS TRIGGER
  LANGUAGE plpgsql AS
$$
BEGIN
  --RAISE NOTICE 'journey_pattern.queue_verify_infra_link_stop_refs_by_old_ssp_label()';

  PERFORM journey_pattern.create_verify_infra_link_stop_refs_queue_temp_table();

  INSERT INTO updated_route (route_id)
  SELECT r.route_id
  FROM old_table
         JOIN route.route r ON EXISTS(
    SELECT 1
    FROM journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
           JOIN journey_pattern.journey_pattern jp ON jp.journey_pattern_id = sspijp.journey_pattern_id
    WHERE sspijp.scheduled_stop_point_label = old_table.label
      AND TSTZRANGE(r.validity_start, r.validity_end) && TSTZRANGE(old_table.validity_start, old_table.validity_end)
      AND jp.on_route_id = r.route_id
    )
  ON CONFLICT DO NOTHING;

  RETURN NULL;
END;
$$;


-- previously queue_verify_infra_link_stop_refs_by_other_route_ids
CREATE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_label()
  RETURNS TRIGGER
  LANGUAGE plpgsql AS
$$
BEGIN
  --RAISE NOTICE 'journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_label()';

  PERFORM journey_pattern.create_verify_infra_link_stop_refs_queue_temp_table();

  INSERT INTO updated_route (route_id)
  SELECT route_id
  FROM old_table
  ON CONFLICT DO NOTHING;

  RETURN NULL;
END;
$$;



--------------------------------------------------------
-- re-create the triggers
--------------------------------------------------------

CREATE TRIGGER queue_verify_infra_link_stop_refs_on_sspijp_insert_trigger
  AFTER INSERT
  ON journey_pattern.scheduled_stop_point_in_journey_pattern
  REFERENCING NEW TABLE AS new_table
  FOR EACH STATEMENT
EXECUTE PROCEDURE journey_pattern.queue_verify_infra_link_stop_refs_by_new_journey_pattern_id();
CREATE TRIGGER queue_verify_infra_link_stop_refs_on_sspijp_update_trigger
  AFTER UPDATE
  ON journey_pattern.scheduled_stop_point_in_journey_pattern
  REFERENCING NEW TABLE AS new_table
  FOR EACH STATEMENT
EXECUTE PROCEDURE journey_pattern.queue_verify_infra_link_stop_refs_by_new_journey_pattern_id();

CREATE TRIGGER queue_verify_infra_link_stop_refs_on_ilar_update_trigger
  AFTER UPDATE
  ON route.infrastructure_link_along_route
  REFERENCING OLD TABLE AS old_table
  FOR EACH STATEMENT
EXECUTE PROCEDURE journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_id();
CREATE TRIGGER queue_verify_infra_link_stop_refs_on_ilar_delete_trigger
  AFTER DELETE
  ON route.infrastructure_link_along_route
  REFERENCING OLD TABLE AS old_table
  FOR EACH STATEMENT
EXECUTE PROCEDURE journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_id();

CREATE TRIGGER queue_verify_infra_link_stop_refs_on_ssp_insert_trigger
  AFTER INSERT
  ON internal_service_pattern.scheduled_stop_point
  REFERENCING NEW TABLE AS new_table
  FOR EACH STATEMENT
EXECUTE PROCEDURE journey_pattern.queue_verify_infra_link_stop_refs_by_new_ssp_label();
CREATE TRIGGER queue_verify_infra_link_stop_refs_on_ssp_update_trigger
  AFTER UPDATE
  ON internal_service_pattern.scheduled_stop_point
  REFERENCING NEW TABLE AS new_table
  FOR EACH STATEMENT
EXECUTE PROCEDURE journey_pattern.queue_verify_infra_link_stop_refs_by_new_ssp_label();
CREATE TRIGGER queue_verify_infra_link_stop_refs_on_ssp_delete_trigger
  AFTER DELETE
  ON internal_service_pattern.scheduled_stop_point
  REFERENCING OLD TABLE AS old_table
  FOR EACH STATEMENT
EXECUTE PROCEDURE journey_pattern.queue_verify_infra_link_stop_refs_by_old_ssp_label();

CREATE TRIGGER queue_verify_infra_link_stop_refs_on_jp_update_trigger
  AFTER UPDATE
  ON journey_pattern.journey_pattern
  REFERENCING NEW TABLE AS new_table
  FOR EACH STATEMENT
EXECUTE PROCEDURE journey_pattern.queue_verify_infra_link_stop_refs_by_new_journey_pattern_id();

CREATE TRIGGER queue_verify_infra_link_stop_refs_on_route_delete_trigger
  AFTER DELETE
  ON route.route
  REFERENCING OLD TABLE AS old_table
  FOR EACH STATEMENT
EXECUTE PROCEDURE journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_label();



CREATE CONSTRAINT TRIGGER verify_infra_link_stop_refs_on_sspijp_trigger
  AFTER INSERT OR UPDATE
  ON journey_pattern.scheduled_stop_point_in_journey_pattern
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
  WHEN (NOT journey_pattern.infra_link_stop_refs_already_verified())
EXECUTE PROCEDURE journey_pattern.verify_infra_link_stop_refs();
COMMENT ON
  TRIGGER verify_infra_link_stop_refs_on_sspijp_trigger
  ON journey_pattern.scheduled_stop_point_in_journey_pattern IS
  'Check inclusion of a stop into a journey pattern (through insert / update):
     - included stop might be on a link, which is not included in the journey pattern''s route
     - included stop might be included at a position, which does not correspond to the position of its
       infra link in the journey pattern''s route
     - included stop''s link might be traversed in a direction not suitable with the route''s traversal
       direction
   Exclusion of a stop from a journey pattern (through update / delete) is not a problem,
   because it cannot get the order of the stops mixed up.';

CREATE CONSTRAINT TRIGGER verify_infra_link_stop_refs_on_ilar_trigger
  AFTER UPDATE OR DELETE
  ON route.infrastructure_link_along_route
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
  WHEN (NOT journey_pattern.infra_link_stop_refs_already_verified())
EXECUTE PROCEDURE journey_pattern.verify_infra_link_stop_refs();
COMMENT ON
  TRIGGER verify_infra_link_stop_refs_on_ilar_trigger
  ON route.infrastructure_link_along_route IS
  'Check exclusion of a link from a route (through update / delete):
     - a route''s journey pattern may contain a stop point residing on that link
   Inclusion of a link (through insert / update) is not a problem, because it cannot get the order of the
   stops mixed up (stop residing on a route''s link cannot be part of journey pattern already at that stage).';

CREATE CONSTRAINT TRIGGER verify_infra_link_stop_refs_on_scheduled_stop_point_trigger
  AFTER INSERT OR UPDATE OR DELETE
  ON internal_service_pattern.scheduled_stop_point
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
  WHEN (NOT journey_pattern.infra_link_stop_refs_already_verified())
EXECUTE PROCEDURE journey_pattern.verify_infra_link_stop_refs();
COMMENT ON
  TRIGGER verify_infra_link_stop_refs_on_scheduled_stop_point_trigger
  ON internal_service_pattern.scheduled_stop_point IS
  'Check if the stop is moved to a link
     - that is not part of all the routes'' journey patterns the stop is part of OR
     - which is in the wrong order in the stop''s journey patterns OR
     - which is traversed in the wrong direction compared to the stop''s allowed directions

  Also check the journey patterns, which have stops with the same label, in case the stop is removed.
  Other stops with the same label and lower priority might become "visible" in that case.';

CREATE CONSTRAINT TRIGGER verify_infra_link_stop_refs_on_journey_pattern_trigger
  AFTER UPDATE
  ON journey_pattern.journey_pattern
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
  WHEN (NOT journey_pattern.infra_link_stop_refs_already_verified())
EXECUTE PROCEDURE journey_pattern.verify_infra_link_stop_refs();
COMMENT ON
  TRIGGER verify_infra_link_stop_refs_on_journey_pattern_trigger
  ON journey_pattern.journey_pattern IS
  'Check if the journey pattern is moved to a route
    - which does not contain all links the journey pattern''s stops reside on OR
    - which traverses a link of a stop of the journey pattern in the wrong direction compared to the stop''s allowed
      directions';


CREATE CONSTRAINT TRIGGER verify_infra_link_stop_refs_on_route_trigger
  AFTER DELETE
  ON route.route
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
  WHEN (NOT journey_pattern.infra_link_stop_refs_already_verified())
EXECUTE PROCEDURE journey_pattern.verify_infra_link_stop_refs();
COMMENT ON
  TRIGGER verify_infra_link_stop_refs_on_journey_pattern_trigger
  ON journey_pattern.journey_pattern IS
  'Check the integrity of routes with lower priorities in case a route is removed.
  Other routes with the same label and lower priority might become "visible" in that case.';
