CREATE SCHEMA internal_service_pattern;

-- drop the triggers that were created for the table
DROP TRIGGER service_pattern_insert_scheduled_stop_point_trigger ON service_pattern.scheduled_stop_point;
DROP TRIGGER service_pattern_update_scheduled_stop_point_trigger ON service_pattern.scheduled_stop_point;
DROP TRIGGER service_pattern_delete_scheduled_stop_point_trigger ON service_pattern.scheduled_stop_point;

-- move the service_pattern schema contents to the internal_service_pattern schema
ALTER TABLE service_pattern.scheduled_stop_point SET SCHEMA internal_service_pattern;
ALTER TABLE service_pattern.scheduled_stop_point_invariant SET SCHEMA internal_service_pattern;
ALTER FUNCTION service_pattern.check_scheduled_stop_point_infrastructure_link_direction SET SCHEMA internal_service_pattern;
ALTER FUNCTION service_pattern.delete_scheduled_stop_point_label SET SCHEMA internal_service_pattern;
ALTER FUNCTION service_pattern.get_scheduled_stop_points_with_new SET SCHEMA internal_service_pattern;
ALTER FUNCTION service_pattern.insert_scheduled_stop_point_label SET SCHEMA internal_service_pattern;
ALTER FUNCTION service_pattern.insert_scheduled_stop_point_with_vehicle_mode SET SCHEMA internal_service_pattern;

-- retrieve old service_pattern.scheduled_stop_point view
ALTER VIEW deleted.scheduled_stop_point_1666001572785 SET SCHEMA service_pattern;
ALTER VIEW service_pattern.scheduled_stop_point_1666001572785 RENAME TO scheduled_stop_point;

-- fix the functions that they use the new schema in their body
CREATE OR REPLACE FUNCTION infrastructure_network.check_infrastructure_link_scheduled_stop_points_direction_trigg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS(
    SELECT 1
    FROM internal_service_pattern.scheduled_stop_point
    JOIN infrastructure_network.infrastructure_link
      ON infrastructure_network.infrastructure_link.infrastructure_link_id =
         internal_service_pattern.scheduled_stop_point.located_on_infrastructure_link_id
    WHERE internal_service_pattern.scheduled_stop_point.located_on_infrastructure_link_id = NEW.infrastructure_link_id
    AND (
      (internal_service_pattern.scheduled_stop_point.direction = 'forward' AND NEW.direction = 'backward') OR
      (internal_service_pattern.scheduled_stop_point.direction = 'backward' AND NEW.direction = 'forward') OR
      (internal_service_pattern.scheduled_stop_point.direction = 'bidirectional' AND NEW.direction != 'bidirectional')
    )
  )
  THEN
    RAISE EXCEPTION 'infrastructure link direction must be compatible with the directions of the stop points residing on it';
  END IF;

  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION journey_pattern.check_infra_link_stop_refs_with_new_scheduled_stop_point(replace_scheduled_stop_point_id uuid, new_located_on_infrastructure_link_id uuid, new_measured_location public.geography, new_direction text, new_label text, new_validity_start date, new_validity_end date, new_priority integer) RETURNS SETOF journey_pattern.journey_pattern
    LANGUAGE sql STABLE PARALLEL SAFE
    AS $$
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
          internal_utils.daterange_closed_upper(r.validity_start, r.validity_end) &&
          internal_utils.daterange_closed_upper(new_validity_start, new_validity_end))
    -- 2. the scheduled stop point instance to be replaced (identified by the replace_scheduled_stop_point_id argument)
    OR (ssp.scheduled_stop_point_id = replace_scheduled_stop_point_id AND
        internal_utils.daterange_closed_upper(r.validity_start, r.validity_end) &&
        internal_utils.daterange_closed_upper(ssp.validity_start, ssp.validity_end)))
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

CREATE OR REPLACE FUNCTION journey_pattern.get_broken_route_journey_patterns(filter_route_ids uuid[], replace_scheduled_stop_point_id uuid DEFAULT NULL::uuid, new_located_on_infrastructure_link_id uuid DEFAULT NULL::uuid, new_measured_location public.geography DEFAULT NULL::public.geography, new_direction text DEFAULT NULL::text, new_label text DEFAULT NULL::text, new_validity_start date DEFAULT NULL::date, new_validity_end date DEFAULT NULL::date, new_priority integer DEFAULT NULL::integer) RETURNS SETOF journey_pattern.journey_pattern
    LANGUAGE sql STABLE PARALLEL SAFE
    AS $$
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
                  AND internal_utils.daterange_closed_upper(ssp.validity_start, ssp.validity_end) &&
                      internal_utils.daterange_closed_upper(r.validity_start, r.validity_end)
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
             AS infra_link_order
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
                        AND internal_utils.daterange_closed_upper(full_route.validity_start, full_route.validity_end) &&
                            internal_utils.daterange_closed_upper(any_ssp.validity_start, any_ssp.validity_end)
                      )
                    )                                     AS is_ghost_ssp
           FROM prioritized_route r
                  JOIN journey_pattern.journey_pattern jp ON jp.on_route_id = r.route_id
                  JOIN journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
                       ON sspijp.journey_pattern_id = jp.journey_pattern_id
                  LEFT JOIN prioritized_ssp_with_new ssp -- left join to be able to find the ghost ssp
                            ON ssp.label = sspijp.scheduled_stop_point_label
                              AND internal_utils.daterange_closed_upper(ssp.validity_start, ssp.validity_end) &&
                                  internal_utils.daterange_closed_upper(r.validity_start, r.validity_end)
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

CREATE OR REPLACE FUNCTION journey_pattern.maximum_priority_validity_spans(entity_type text, filter_route_labels text[], filter_validity_start date DEFAULT NULL::date, filter_validity_end date DEFAULT NULL::date, upper_priority_limit integer DEFAULT NULL::integer, replace_scheduled_stop_point_id uuid DEFAULT NULL::uuid, new_scheduled_stop_point_id uuid DEFAULT NULL::uuid, new_located_on_infrastructure_link_id uuid DEFAULT NULL::uuid, new_measured_location public.geography DEFAULT NULL::public.geography, new_direction text DEFAULT NULL::text, new_label text DEFAULT NULL::text, new_validity_start date DEFAULT NULL::date, new_validity_end date DEFAULT NULL::date, new_priority integer DEFAULT NULL::integer) RETURNS TABLE(id uuid, validity_start date, validity_end date)
    LANGUAGE sql STABLE PARALLEL SAFE
    AS $$
WITH RECURSIVE
  -- collect the entities matching the given parameters
  -- e.g.
  -- id, validity_start, validity_end, key, prio
  ----------------------------------------------
  --  1,     2020-01-01,   2025-01-01,   A,   10
  --  2,     2022-01-01,   2027-01-01,   A,   20
  entity AS (
    SELECT r.route_id AS id, r.validity_start, r.validity_end, r.label AS key1, r.direction AS key2, r.priority
    FROM route.route r
    WHERE entity_type = 'route'
      AND internal_utils.daterange_closed_upper(r.validity_start, r.validity_end) &&
          internal_utils.daterange_closed_upper(filter_validity_start, filter_validity_end)
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
      AND internal_utils.daterange_closed_upper(ssp.validity_start, ssp.validity_end) &&
          internal_utils.daterange_closed_upper(filter_validity_start, filter_validity_end)
      AND (ssp.priority < upper_priority_limit OR upper_priority_limit IS NULL)
      AND (EXISTS(
             SELECT 1
             FROM journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
                    JOIN journey_pattern.journey_pattern jp ON jp.journey_pattern_id = sspijp.journey_pattern_id
                    JOIN route.route r
                         ON r.route_id = jp.on_route_id
                           AND r.label = ANY (filter_route_labels)
             WHERE sspijp.scheduled_stop_point_label = ssp.label
             ) OR filter_route_labels IS NULL)
  ),
  -- form the list of potential validity span boundaries
  -- e.g.
  -- id, validity_start, is_start, key, prio
  ------------------------------------------
  --  1,     2020-01-01,     true,   A,   10
  --  1,     2025-01-01,    false,   A,   10
  --  2,     2022-01-01,     true,   A,   20
  --  2,     2027-01-01,    false,   A,   20
  boundary AS (
    SELECT e.validity_start, TRUE AS is_start, e.key1, e.key2, e.priority
    FROM entity e
    UNION ALL
    SELECT internal_utils.date_closed2open_upper(e.validity_end), FALSE AS is_start, e.key1, e.key2, e.priority
    FROM entity e
  ),
  -- Order the list both ascending and descending, because it has to be traversed both ways below. By traversing the
  -- list in both directions, we can find the validity span boundaries with highest priority without using fifos or
  -- similar.
  -- e.g.
  -- id, validity_start, is_start, key, prio, start_order, end_order
  ------------------------------------------------------------------
  --  1,     2020-01-01,     true,   A,   10,           1,         4
  --  2,     2022-01-01,     true,   A,   20,           2,         3
  --  1,     2025-01-01,    false,   A,   10,           3,         2
  --  2,     2027-01-01,    false,   A,   20,           4,         1
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
  -- mark the minimum priority for each row, at which a start validity boundary is relevant (i.e. not overlapped by a higher priority),
  -- traverse the list of boundaries from start to end
  -- e.g.
  -- id, validity_start, is_start, key, prio, start_order, end_order, cur_start_priority
  --------------------------------------------------------------------------------------
  --  1,     2020-01-01,     true,   A,   10,           1,         4,                 10
  --  2,     2022-01-01,     true,   A,   20,           2,         3,                 20
  --  1,     2025-01-01,    false,   A,   10,           3,         2,                 20
  --  2,     2027-01-01,    false,   A,   20,           4,         1,                  0
  marked_min_start_priority AS (
    SELECT *, priority AS cur_start_priority
    FROM ordered_boundary
    WHERE start_order = 1
    UNION ALL
    SELECT next_boundary.*,
           CASE
             -- if the boundary marks the beginning of a validity span and the span's priority is higher than the
             -- previously marked priority, this span is valid from now on
             WHEN next_boundary.is_start AND next_boundary.priority > cur_start_priority THEN next_boundary.priority
             -- if the boundary marks the end of a validity span and the span's priority is higher or equal than the
             -- previously marked priority, the currently valid span is ending and any span starting further down may
             -- potentially be the new valid one
             WHEN NOT next_boundary.is_start AND next_boundary.priority >= cur_start_priority THEN 0
             -- otherwise, any previously discovered validity span stays valid
             ELSE cur_start_priority
             END AS cur_start_priority
    FROM marked_min_start_priority marked
           JOIN ordered_boundary next_boundary
                ON next_boundary.start_order = marked.start_order + 1 AND next_boundary.key1 = marked.key1 AND
                   (next_boundary.key2 = marked.key2 OR next_boundary.key2 IS NULL)
  ),
  -- mark the minimum priority for each row, at which an end validity boundary is relevant (i.e. not overlapped by a higher priority),
  -- traverse the list of boundaries from end to start
  -- e.g.
  -- id, validity_start, is_start, key, prio, start_order, end_order, cur_start_priority, cur_end_priority
  --------------------------------------------------------------------------------------------------------
  --  2,     2027-01-01,    false,   A,   20,           4,         1,                  0,               20
  --  1,     2025-01-01,    false,   A,   10,           3,         2,                 20,               20
  --  2,     2022-01-01,     true,   A,   20,           2,         3,                 20,                0
  --  1,     2020-01-01,     true,   A,   10,           1,         4,                 10,               10
  marked_min_start_end_priority AS (
    SELECT *, priority AS cur_end_priority
    FROM marked_min_start_priority
    WHERE end_order = 1
    UNION ALL
    SELECT next_boundary.*,
           CASE
             -- if the boundary marks the end of a validity span and the span's priority is higher than the
             -- previously marked priority, this span is valid from now on
             WHEN NOT next_boundary.is_start AND next_boundary.priority > cur_end_priority THEN next_boundary.priority
             -- if the boundary marks the start of a validity span and the span's priority is higher or equal than the
             -- previously marked priority, the currently valid span is ending and any span ending further down may
             -- potentially be the new valid one
             WHEN next_boundary.is_start AND next_boundary.priority >= cur_end_priority THEN 0
             -- otherwise, any previously discovered validity span stays valid
             ELSE cur_end_priority
             END AS cur_end_priority
    FROM marked_min_start_end_priority marked
           JOIN marked_min_start_priority next_boundary
                ON next_boundary.end_order = marked.end_order + 1 AND next_boundary.key1 = marked.key1 AND
                   (next_boundary.key2 = marked.key2 OR next_boundary.key2 IS NULL)
  ),
  -- filter only the highest priority boundaries and connect them to form validity spans (with both start and end)
  -- e.g.
  -- key, has_next, validity_start, validity_end
  ----------------------------------------------
  --   A,     true,     2020-01-01,   2022-01-01
  --   A,     true,     2022-01-01,   2027-01-01
  -----A,-----true,-----2025-01-01,--------------- (removed by WHERE clause)
  --   A,    false,     2027-01-01,         null
  reduced_boundary AS (
    SELECT key1,
           key2,
           -- The last row will have has_next = FALSE. This is needed because we cannot rely on validity_end being NULL
           -- in ONLY the last row, since NULL in timestamps depicts infinity.
           lead(TRUE, 1, FALSE) OVER entity_window AS has_next,
           validity_start,
           lead(internal_utils.date_open2closed_upper(validity_start)) OVER entity_window AS validity_end
    FROM marked_min_start_end_priority
    WHERE priority >= cur_end_priority
      AND priority >= cur_start_priority
      WINDOW entity_window AS (PARTITION BY key1, key2 ORDER BY start_order)
  ),
  -- find the instances which are valid in the validity spans
  -- e.g.
  -- key, has_next, validity_start, validity_end, id, priority
  ------------------------------------------------------------
  --   A,     true,     2020-01-01,   2022-01-01,  1,       10
  --   A,     true,     2022-01-01,   2027-01-01,  1,       10
  --   A,     true,     2022-01-01,   2027-01-01,  2,       20
  -----A,----false,-----2027-01-01,---------null,--------------- (removed by WHERE clause)
  boundary_with_entities AS (
    SELECT rb.key1, rb.key2, rb.has_next, rb.validity_start, rb.validity_end, e.id, e.priority
    FROM reduced_boundary rb
           JOIN entity e ON e.key1 = rb.key1 AND (e.key2 = rb.key2 OR e.key2 IS NULL) AND
                            internal_utils.daterange_closed_upper(e.validity_start, e.validity_end) &&
                            internal_utils.daterange_closed_upper(rb.validity_start, rb.validity_end)
    WHERE rb.has_next
  )
-- choose the instance with the highest priority for each validity span
-- e.g.
-- id, validity_start, validity_end
-----------------------------------
--  1,     2020-01-01,   2022-01-01
--  2,     2022-01-01,   2027-01-01
-- (see COMMENT ON below for a graphical summary of the example data)
SELECT id, validity_start, validity_end
FROM (SELECT id,
             validity_start,
             validity_end,
             priority,
             max(priority) OVER (PARTITION BY key1, key2, validity_start) AS max_priority
      FROM boundary_with_entities) bwe
WHERE priority = max_priority
$$;

CREATE OR REPLACE FUNCTION service_pattern.check_scheduled_stop_point_vehicle_mode_by_infra_link() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS(
    SELECT 1
    FROM reusable_components.vehicle_submode
           JOIN service_pattern.vehicle_mode_on_scheduled_stop_point
                ON service_pattern.vehicle_mode_on_scheduled_stop_point.vehicle_mode =
                   reusable_components.vehicle_submode.belonging_to_vehicle_mode
           JOIN internal_service_pattern.scheduled_stop_point
                ON internal_service_pattern.scheduled_stop_point.scheduled_stop_point_id =
                   service_pattern.vehicle_mode_on_scheduled_stop_point.scheduled_stop_point_id
    WHERE reusable_components.vehicle_submode.vehicle_submode = OLD.vehicle_submode
      AND internal_service_pattern.scheduled_stop_point.located_on_infrastructure_link_id = OLD.infrastructure_link_id
    )
  THEN
    RAISE
      EXCEPTION 'cannot remove relationship between scheduled stop point vehicle mode and infrastructure link vehicle submodes';
  END IF;
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION service_pattern.check_scheduled_stop_point_vehicle_mode_by_scheduled_stop_point() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NOT EXISTS(
    SELECT 1
    FROM service_pattern.vehicle_mode_on_scheduled_stop_point
           JOIN internal_service_pattern.scheduled_stop_point
                ON internal_service_pattern.scheduled_stop_point.scheduled_stop_point_id =
                   service_pattern.vehicle_mode_on_scheduled_stop_point.scheduled_stop_point_id
           JOIN infrastructure_network.infrastructure_link
                ON infrastructure_network.infrastructure_link.infrastructure_link_id =
                   internal_service_pattern.scheduled_stop_point.located_on_infrastructure_link_id
           JOIN infrastructure_network.vehicle_submode_on_infrastructure_link
                ON infrastructure_network.vehicle_submode_on_infrastructure_link.infrastructure_link_id =
                   infrastructure_network.infrastructure_link.infrastructure_link_id
           JOIN reusable_components.vehicle_submode ON reusable_components.vehicle_submode.vehicle_submode =
                                                       infrastructure_network.vehicle_submode_on_infrastructure_link.vehicle_submode
    WHERE service_pattern.vehicle_mode_on_scheduled_stop_point.vehicle_mode =
          reusable_components.vehicle_submode.belonging_to_vehicle_mode
      AND internal_service_pattern.scheduled_stop_point.scheduled_stop_point_id = NEW.scheduled_stop_point_id
    )
  THEN
    RAISE EXCEPTION 'scheduled stop point vehicle mode must be compatible with allowed infrastructure link vehicle submodes';
  END IF;

  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION service_pattern.check_scheduled_stop_point_vehicle_mode_by_vehicle_mode() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS(
       SELECT 1
       FROM service_pattern.vehicle_mode_on_scheduled_stop_point
              JOIN internal_service_pattern.scheduled_stop_point
                   ON internal_service_pattern.scheduled_stop_point.scheduled_stop_point_id =
                      service_pattern.vehicle_mode_on_scheduled_stop_point.scheduled_stop_point_id
              JOIN infrastructure_network.infrastructure_link
                   ON infrastructure_network.infrastructure_link.infrastructure_link_id =
                      internal_service_pattern.scheduled_stop_point.located_on_infrastructure_link_id
              JOIN infrastructure_network.vehicle_submode_on_infrastructure_link
                   ON infrastructure_network.vehicle_submode_on_infrastructure_link.infrastructure_link_id =
                      infrastructure_network.infrastructure_link.infrastructure_link_id
              JOIN reusable_components.vehicle_submode ON reusable_components.vehicle_submode.vehicle_submode =
                                                          infrastructure_network.vehicle_submode_on_infrastructure_link.vehicle_submode
       WHERE service_pattern.vehicle_mode_on_scheduled_stop_point.vehicle_mode =
             reusable_components.vehicle_submode.belonging_to_vehicle_mode
         AND internal_service_pattern.scheduled_stop_point.scheduled_stop_point_id = OLD.scheduled_stop_point_id
       )
    !=
     EXISTS(
       SELECT 1
       FROM internal_service_pattern.scheduled_stop_point
       WHERE internal_service_pattern.scheduled_stop_point.scheduled_stop_point_id = OLD.scheduled_stop_point_id
       )
  THEN
    RAISE EXCEPTION 'scheduled stop point must be assigned a vehicle mode which is compatible with allowed infrastructure link vehicle submodes';
  END IF;

  RETURN OLD;
END;
$$;

CREATE OR REPLACE FUNCTION service_pattern.delete_scheduled_stop_point() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  DELETE FROM internal_service_pattern.scheduled_stop_point
  WHERE scheduled_stop_point_id = OLD.scheduled_stop_point_id;

  PERFORM internal_service_pattern.delete_scheduled_stop_point_label(OLD.label);
  RETURN OLD;
END;
$$;

CREATE OR REPLACE FUNCTION service_pattern.insert_scheduled_stop_point() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM internal_service_pattern.insert_scheduled_stop_point_label(NEW.label);

  IF NEW.scheduled_stop_point_id IS NOT NULL
  THEN
    INSERT INTO internal_service_pattern.scheduled_stop_point (
      scheduled_stop_point_id,
      measured_location,
      located_on_infrastructure_link_id,
      direction,
      label,
      validity_start,
      validity_end,
      priority
    ) VALUES (
               NEW.scheduled_stop_point_id,
               NEW.measured_location,
               NEW.located_on_infrastructure_link_id,
               NEW.direction,
               NEW.label,
               NEW.validity_start,
               NEW.validity_end,
               NEW.priority
             ) RETURNING scheduled_stop_point_id INTO NEW.scheduled_stop_point_id;
  ELSE
    INSERT INTO internal_service_pattern.scheduled_stop_point (
      measured_location,
      located_on_infrastructure_link_id,
      direction,
      label,
      validity_start,
      validity_end,
      priority
    ) VALUES (
               NEW.measured_location,
               NEW.located_on_infrastructure_link_id,
               NEW.direction,
               NEW.label,
               NEW.validity_start,
               NEW.validity_end,
               NEW.priority
             ) RETURNING scheduled_stop_point_id INTO NEW.scheduled_stop_point_id;
  END IF;
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION service_pattern.update_scheduled_stop_point() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM internal_service_pattern.insert_scheduled_stop_point_label(NEW.label);

  UPDATE internal_service_pattern.scheduled_stop_point
  SET
    scheduled_stop_point_id = NEW.scheduled_stop_point_id,
    measured_location = NEW.measured_location,
    located_on_infrastructure_link_id = NEW.located_on_infrastructure_link_id,
    direction = NEW.direction,
    label = NEW.label,
    validity_start = NEW.validity_start,
    validity_end = NEW.validity_end,
    priority = NEW.priority
  WHERE scheduled_stop_point_id = OLD.scheduled_stop_point_id;

  PERFORM internal_service_pattern.delete_scheduled_stop_point_label(OLD.label);
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION internal_service_pattern.delete_scheduled_stop_point_label(old_label text) RETURNS void
    LANGUAGE sql
    AS $$
DELETE FROM internal_service_pattern.scheduled_stop_point_invariant
WHERE label = old_label
  AND NOT EXISTS (SELECT 1 FROM internal_service_pattern.scheduled_stop_point WHERE label = old_label);
$$;

COMMENT ON FUNCTION internal_service_pattern.get_scheduled_stop_points_with_new(replace_scheduled_stop_point_id uuid, new_scheduled_stop_point_id uuid, new_located_on_infrastructure_link_id uuid, new_measured_location public.geography, new_direction text, new_label text, new_validity_start date, new_validity_end date, new_priority integer) IS 'Returns the scheduled stop points from the internal_service_pattern.scheduled_stop_point table.
     If replace_scheduled_stop_point_id is not null, the stop point with that ID is filtered out.
     Similarly, if the new_xxx arguments are specified, a scheduled stop point with those values is
     appended to the result (it is not inserted into the table).';

CREATE OR REPLACE FUNCTION internal_service_pattern.insert_scheduled_stop_point_label(new_label text) RETURNS void
    LANGUAGE sql
    AS $$
INSERT INTO internal_service_pattern.scheduled_stop_point_invariant (label)
VALUES (new_label)
ON CONFLICT (label)
  DO NOTHING;
$$;

CREATE OR REPLACE FUNCTION internal_service_pattern.insert_scheduled_stop_point_with_vehicle_mode(scheduled_stop_point_id uuid, measured_location public.geography, located_on_infrastructure_link_id uuid, direction text, label text, validity_start date, validity_end date, priority integer, supported_vehicle_mode text) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO internal_service_pattern.scheduled_stop_point (scheduled_stop_point_id,
                                                             measured_location,
                                                             located_on_infrastructure_link_id,
                                                             direction,
                                                             label,
                                                             validity_start,
                                                             validity_end,
                                                             priority)
  VALUES (scheduled_stop_point_id,
          measured_location,
          located_on_infrastructure_link_id,
          direction,
          label,
          validity_start,
          validity_end,
          priority);

  INSERT INTO service_pattern.vehicle_mode_on_scheduled_stop_point(scheduled_stop_point_id,
                                                                   vehicle_mode)
  VALUES (scheduled_stop_point_id,
          supported_vehicle_mode);
END;
$$;

-- the return type changes, so have to recreate the function
DROP FUNCTION internal_service_pattern.get_scheduled_stop_points_with_new(replace_scheduled_stop_point_id uuid, new_scheduled_stop_point_id uuid, new_located_on_infrastructure_link_id uuid, new_measured_location public.geography, new_direction text, new_label text, new_validity_start date, new_validity_end date, new_priority integer);
CREATE FUNCTION internal_service_pattern.get_scheduled_stop_points_with_new(replace_scheduled_stop_point_id uuid DEFAULT NULL::uuid, new_scheduled_stop_point_id uuid DEFAULT NULL::uuid, new_located_on_infrastructure_link_id uuid DEFAULT NULL::uuid, new_measured_location public.geography DEFAULT NULL::public.geography, new_direction text DEFAULT NULL::text, new_label text DEFAULT NULL::text, new_validity_start date DEFAULT NULL::date, new_validity_end date DEFAULT NULL::date, new_priority integer DEFAULT NULL::integer) RETURNS SETOF service_pattern.scheduled_stop_point
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  IF new_scheduled_stop_point_id IS NULL THEN
    RETURN QUERY
      SELECT *
      FROM service_pattern.scheduled_stop_point ssp
      WHERE replace_scheduled_stop_point_id IS NULL
         OR ssp.scheduled_stop_point_id != replace_scheduled_stop_point_id;
  ELSE
    RETURN QUERY
      SELECT *
      FROM service_pattern.scheduled_stop_point ssp
      WHERE replace_scheduled_stop_point_id IS NULL
         OR ssp.scheduled_stop_point_id != replace_scheduled_stop_point_id
      UNION ALL
      SELECT new_scheduled_stop_point_id,
             new_label,
             new_measured_location::geography(PointZ, 4326),
             new_located_on_infrastructure_link_id,
             new_direction,
             internal_utils.st_linelocatepoint(il.shape, new_measured_location) AS relative_distance_from_infrastructure_link_start,
             NULL::geography(PointZ, 4326)                                      AS closest_point_on_infrastructure_link,
             new_validity_start,
             new_validity_end,
             new_priority
      FROM infrastructure_network.infrastructure_link il
      WHERE il.infrastructure_link_id = new_located_on_infrastructure_link_id;
  END IF;
END;
$$;
