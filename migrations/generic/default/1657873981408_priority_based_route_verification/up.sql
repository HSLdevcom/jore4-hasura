
CREATE FUNCTION journey_pattern.maximum_priority_validity_spans(
  entity_type TEXT,
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
  RETURNS TABLE(
                 id UUID,
                 validity_start TIMESTAMP WITH TIME ZONE,
                 validity_end TIMESTAMP WITH TIME ZONE
               )
  LANGUAGE SQL
  STABLE
AS $$
WITH RECURSIVE
-- collect the entities matching the given parameters
  entity AS (
    SELECT r.route_id AS id, r.validity_start, r.validity_end, r.LABEL AS key1, r.direction AS key2, r.priority
    FROM route.route r
    WHERE entity_type = 'route' AND TSTZRANGE(r.validity_start, r.validity_end) && TSTZRANGE(filter_validity_start, filter_validity_end)
      AND (r.priority < upper_priority_limit OR upper_priority_limit IS NULL)
    UNION ALL
    SELECT ssp.scheduled_stop_point_id AS id, ssp.validity_start, ssp.validity_end, ssp.LABEL AS key1, NULL AS key2, ssp.priority
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
    WHERE entity_type = 'scheduled_stop_point' AND TSTZRANGE(ssp.validity_start, ssp.validity_end) && TSTZRANGE(filter_validity_start, filter_validity_end)
      AND (ssp.priority < upper_priority_limit OR upper_priority_limit IS NULL)
  ),
-- form the list of potential validity span boundaries
  boundary AS (
    SELECT e.validity_start, TRUE AS is_start, e.key1, e.key2, e.priority FROM entity e
    UNION ALL
    SELECT e.validity_end, FALSE AS is_start, e.key1, e.key2, e.priority FROM entity e
  ),
-- order the list both ascending and descending, because it has to be traversed both ways below
  ordered_boundary AS (
    SELECT *,
           -- The "validity_start IS NULL" cases have to be interpreted together with "is_start". Depending on the latter value,
           -- "validity_start IS NULL" can mean "negative inf" or "positive inf"
           row_number() OVER (PARTITION BY key1, key2 ORDER BY is_start AND validity_start IS NULL DESC, validity_start ASC) AS start_order,
           row_number() OVER (PARTITION BY key1, key2 ORDER BY NOT is_start AND validity_start IS NULL DESC, validity_start DESC) AS end_order
    FROM boundary
  ),
-- mark the minimum priority for each row, at which a start validity boundary is relevant (i.e. not overlapped by a higher priority)
  marked_min_start_priority AS (
    SELECT *, priority AS cur_start_priority FROM ordered_boundary WHERE start_order = 1
    UNION ALL
    SELECT next_boundary.*,
           CASE
             WHEN next_boundary.is_start AND next_boundary.priority > cur_start_priority THEN next_boundary.priority
             WHEN NOT next_boundary.is_start AND next_boundary.priority >= cur_start_priority THEN 0
             ELSE cur_start_priority
             END AS cur_start_priority
    FROM marked_min_start_priority marked
           JOIN ordered_boundary next_boundary ON next_boundary.start_order = marked.start_order + 1 AND next_boundary.key1 = marked.key1 AND (next_boundary.key2 = marked.key2 OR next_boundary.key2 IS NULL)
  ),
-- mark the minimum priority for each row, at which an end validity boundary is relevant (i.e. not overlapped by a higher priority)
  marked_min_start_end_priority AS (
    SELECT *, priority AS cur_end_priority FROM marked_min_start_priority WHERE end_order = 1
    UNION ALL
    SELECT next_boundary.*,
           CASE
             WHEN NOT next_boundary.is_start AND next_boundary.priority > cur_end_priority THEN next_boundary.priority
             WHEN next_boundary.is_start AND next_boundary.priority >= cur_end_priority THEN 0
             ELSE cur_end_priority
             END AS cur_end_priority
    FROM marked_min_start_end_priority marked
           JOIN marked_min_start_priority next_boundary ON next_boundary.end_order = marked.end_order + 1 AND next_boundary.key1 = marked.key1 AND (next_boundary.key2 = marked.key2 OR next_boundary.key2 IS NULL)
  ),
-- filter only the relevant boundaries and connect them to form validity spans (with both start and end)
  reduced_boundary AS (
    SELECT key1, key2, lead(TRUE, 1, false) OVER entity_window AS has_next, validity_start, lead(validity_start) OVER entity_window AS validity_end
    FROM marked_min_start_end_priority
    WHERE priority >= cur_end_priority AND priority >= cur_start_priority
      WINDOW entity_window AS (PARTITION BY key1, key2 ORDER BY start_order)
  ),
-- find the instances which are valid in the validity spans
  boundary_with_entities AS (
    SELECT rb.key1, rb.key2, rb.has_next, rb.validity_start, rb.validity_end, e.id, e.priority
    FROM reduced_boundary rb
           JOIN entity e ON e.key1 = rb.key1 AND (e.key2 = rb.key2 OR e.key2 IS NULL) AND TSTZRANGE(e.validity_start, e.validity_end) && TSTZRANGE(rb.validity_start, rb.validity_end)
    WHERE rb.has_next
  )
-- choose the instance with the highest priority for each validity span
SELECT id, validity_start, validity_end FROM
  (SELECT id, validity_start, validity_end, priority, max(priority) OVER (PARTITION BY key1, key2, validity_start) AS max_priority FROM boundary_with_entities) bwe
WHERE priority = max_priority;
$$;
COMMENT ON FUNCTION journey_pattern.maximum_priority_validity_spans(
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
  new_priority int)
  IS
  'Find the validity time spans of highest priority in the given time span for entities of the given type (routes or
  scheduled stop points), which are related to routes with the given label.

  Consider the validity times of two overlapping route instances with label A:
  A* (prio 20):        |-------|
  A (prio 10):   |-------------------------|

  These would be split into the following maximum priority validity time spans:
                 |--A--|--A*---|----A------|

  For scheduled stop points the splitting is performed in the same fashion, except that if
  replace_scheduled_stop_point_id is not null, the stop with that id is left out. If the new_xxx arguments are
  specified, the check is also performed for a stop defined by those arguments, which is not yet present in the
  table data.';


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
  RENAME TO check_route_journey_pattern_refs_1657873981408;

ALTER FUNCTION journey_pattern.check_route_journey_pattern_refs_1657873981408(
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

CREATE FUNCTION journey_pattern.check_route_journey_pattern_refs(
  filter_journey_pattern_id uuid,
  filter_route_id uuid,
  replace_scheduled_stop_point_id UUID DEFAULT NULL,
  new_located_on_infrastructure_link_id UUID DEFAULT NULL,
  new_measured_location geography(PointZ, 4326) DEFAULT NULL,
  new_direction TEXT DEFAULT NULL,
  new_label TEXT DEFAULT NULL,
  new_validity_start timestamp WITH TIME ZONE DEFAULT NULL,
  new_validity_end timestamp WITH TIME ZONE DEFAULT NULL,
  new_priority INT DEFAULT NULL
)
  RETURNS bool
  LANGUAGE plpgsql
AS
$$
DECLARE
  filter_validity_start TIMESTAMP WITH TIME ZONE;
  filter_validity_end TIMESTAMP WITH TIME ZONE;
  new_scheduled_stop_point_id UUID DEFAULT NULL;
BEGIN
  -- Since only the maximum priority instances should be taken into account, we'll save the label of the specific route
  -- we're supposed to check. We'll also save the validity times of that route, because instances outside that validity
  -- time do not have to be taken into account.
  SELECT r.route_id, r.validity_start, r.validity_end
  INTO filter_route_id, filter_validity_start, filter_validity_end
  FROM route.route r
  LEFT JOIN journey_pattern.journey_pattern jp ON jp.on_route_id = r.route_id
  WHERE (r.route_id = filter_route_id AND filter_journey_pattern_id IS NULL)
     OR (jp.journey_pattern_id = filter_journey_pattern_id AND filter_route_id IS NULL);

  IF filter_route_id IS NULL
  THEN
    RAISE EXCEPTION 'No routes found using the given parameters';
  END IF;

  IF new_located_on_infrastructure_link_id IS NOT NULL
  THEN
    SELECT gen_random_uuid() INTO new_scheduled_stop_point_id;
  END IF;

  -- Check if it is possible to visit all stops of a journey pattern in such a fashion that all links, on which
  -- the stops reside, are visited in an order matching the route's link order. The check is performed for the
  -- highest priority instances at each time within the given route's validity time span.
  --
  -- This implicitly ensures
  --   - that every stop point in the journey pattern resides on a link that is part of the journey pattern's route
  --   - the stop points' order is the same as the order of the links they reside on
  --   - the stop points' directions match the directions, in which the stop points' links are visited.
  --
  -- For debugging purposes, an additional query fragment is provided below.
  RETURN NOT EXISTS (
    SELECT 1
    FROM (
           WITH RECURSIVE
             -- Get the highest priority time spans for the routes and stop points to be checked
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
                 filter_validity_start,
                 filter_validity_end,
                 internal_utils.const_priority_draft()
               ) priority_validity_spans
               ON priority_validity_spans.id = r.route_id
             ),
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
               JOIN journey_pattern.maximum_priority_validity_spans(
                 'scheduled_stop_point',
                 filter_validity_start,
                 filter_validity_end,
                 internal_utils.const_priority_draft(),
                 replace_scheduled_stop_point_id,
                 new_scheduled_stop_point_id,
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
             -- For all stops in the journey pattern, list all visits of the stop's infra link. (But only include
             -- visits happening in a direction matching the stop's allowed directions - if the direction is wrong,
             -- we cannot approach the stop point on that particular link visit. Similarly, include only those stop
             -- instances, whose validity period overlaps with the route's validity period.)
             sspijp_ilar_combos AS (
               SELECT sspijp.journey_pattern_id,
                      r.validity_start,
                      ssp.scheduled_stop_point_id,
                      sspijp.scheduled_stop_point_sequence,
                      sspijp.stop_point_order,
                      ssp.relative_distance_from_infrastructure_link_start,
                      ilar.route_id,
                      ilar.infrastructure_link_id,
                      ilar.infrastructure_link_sequence,
                      ilar.is_traversal_forwards
               FROM (
                      SELECT journey_pattern_id,
                             scheduled_stop_point_label,
                             scheduled_stop_point_sequence,
                             -- create a continuous sequence number of the scheduled_stop_point_sequence (which is not
                             -- required to be continuous, i.e. there can be gaps)
                             ROW_NUMBER()
                             OVER (PARTITION BY journey_pattern_id ORDER BY scheduled_stop_point_sequence) AS stop_point_order
                      FROM journey_pattern.scheduled_stop_point_in_journey_pattern
                    ) AS sspijp
                      LEFT JOIN prioritized_ssp_with_new ssp
                                ON ssp.label = sspijp.scheduled_stop_point_label
                      LEFT JOIN journey_pattern.journey_pattern jp ON jp.journey_pattern_id = sspijp.journey_pattern_id
                      LEFT JOIN prioritized_route r
                                ON r.route_id = jp.on_route_id
                                  -- scheduled stop point instances, whose validity period does not overlap with the
                                  -- route's validity period, are filtered out here
                                  AND TSTZRANGE(ssp.validity_start, ssp.validity_end) &&
                                      TSTZRANGE(r.validity_start, r.validity_end)
                      LEFT JOIN route.infrastructure_link_along_route ilar
                                ON ilar.route_id = r.route_id
                                  AND ilar.infrastructure_link_id = ssp.located_on_infrastructure_link_id
                                  -- visits of the link in a direction not matching the stop's possible directions are
                                  -- filtered out here
                                  AND (ssp.direction = 'bidirectional' OR
                                       ((ssp.direction = 'forward' AND ilar.is_traversal_forwards = true)
                                         OR (ssp.direction = 'backward' AND ilar.is_traversal_forwards = false)))
               WHERE r.route_id = filter_route_id
             ),
             -- Iteratively try to traverse the journey pattern in its specified order one stop point at a time, such that
             -- all visited links appear in ascending order on the journey pattern's route.
             -- Note that this CTE will contain more rows than only the ones depicting an actual traversal. To find an
             -- actual possible traversal, choose the row with min(infrastructure_link_sequence) for every listed stop
             -- visit, as done in the debug query addition shown below this query.
             traversal AS (
               SELECT *
               FROM sspijp_ilar_combos
               WHERE stop_point_order = 1
               UNION ALL
               SELECT sspijp_ilar_combos.*
               FROM traversal
                      JOIN sspijp_ilar_combos ON sspijp_ilar_combos.journey_pattern_id = traversal.journey_pattern_id
                                             AND sspijp_ilar_combos.validity_start = traversal.validity_start
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
             )
             -- List all stops of the journey pattern and left-join their visits in the traversal performed above.
             -- 1. In case no visit is present for any row (infrastructure_link_sequence is null), it was not possible to
             --    visit all stops in a way matching the route's link order.
             -- 2. In case the order of the stops' infra link visits is not the same as the stop order for all stops, this
             --    means that there are stops with the same ordinal number (same label), which have to be visited in a
             --    different order to cover all stops. This in turn means that the stops subsequent to these exceptions cannot
             --    be reached via all combinations of stops.
           SELECT infrastructure_link_sequence,
                  -- also order by scheduled_stop_point_id to get a deterministic order between stops with the same
                  -- label
                  ROW_NUMBER() OVER (
                    PARTITION BY journey_pattern_id, validity_start
                    ORDER BY
                      stop_point_order,
                      infrastructure_link_sequence,
                      CASE WHEN is_traversal_forwards THEN relative_distance_from_infrastructure_link_start ELSE -relative_distance_from_infrastructure_link_start END,
                      scheduled_stop_point_id)
                    AS stop_point_order,
                  ROW_NUMBER() OVER (
                    PARTITION BY journey_pattern_id, validity_start
                    ORDER BY
                      infrastructure_link_sequence,
                      CASE WHEN is_traversal_forwards THEN relative_distance_from_infrastructure_link_start ELSE -relative_distance_from_infrastructure_link_start END,
                      stop_point_order,
                      scheduled_stop_point_id)
                    AS infra_link_order
           FROM (
                  SELECT t.journey_pattern_id,
                         t.validity_start,
                         t.stop_point_order,
                         t.infrastructure_link_sequence,
                         t.is_traversal_forwards,
                         t.relative_distance_from_infrastructure_link_start,
                         t.scheduled_stop_point_id,
                         ROW_NUMBER()
                         OVER (PARTITION BY sspijp.journey_pattern_id, r.validity_start, ssp.scheduled_stop_point_id, r.route_id, infrastructure_link_id, stop_point_order ORDER BY infrastructure_link_sequence)
                           AS order_by_min
                  FROM journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
                         JOIN prioritized_ssp_with_new ssp
                              ON ssp.label = sspijp.scheduled_stop_point_label
                         JOIN journey_pattern.journey_pattern jp ON jp.journey_pattern_id = sspijp.journey_pattern_id
                         JOIN prioritized_route r
                              ON r.route_id = jp.on_route_id
                         LEFT JOIN traversal t
                                   ON t.journey_pattern_id = sspijp.journey_pattern_id
                                     AND t.validity_start = r.validity_start
                                     AND t.scheduled_stop_point_id = ssp.scheduled_stop_point_id
                                     AND t.scheduled_stop_point_sequence = sspijp.scheduled_stop_point_sequence
                  WHERE r.route_id = filter_route_id
                    -- scheduled stop point instances, whose validity period does not overlap with the
                    -- route's validity period, are filtered out here
                    AND TSTZRANGE(ssp.validity_start, ssp.validity_end) &&
                        TSTZRANGE(r.validity_start, r.validity_end)
                ) AS ordered_sspijp_ilar_combos
           WHERE ordered_sspijp_ilar_combos.order_by_min = 1
         ) AS infra_link_seq
    WHERE infra_link_seq.infrastructure_link_sequence IS NULL
       OR infra_link_seq.stop_point_order != infra_link_seq.infra_link_order
    );
END;
$$;
COMMENT ON FUNCTION journey_pattern.check_route_journey_pattern_refs(
  filter_journey_pattern_id uuid,
  filter_route_id uuid,
  replace_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE,
  new_priority INT)
  IS
    'Check if it is possible to visit all stops of a journey pattern in such a fashion that all links, on which
     the stops reside, are visited in an order matching the route''s link order.

     Only the highest priority route and stop point validity time spans for the given route / journey pattern parameters
     are taken into account, with the exception of drafts, which are not at all included in the check.

     If replace_scheduled_stop_point_id is not null, the stop with that id is left out of the check.
     If the new_xxx arguments are specified, the check is also performed for an imaginary stop defined by those
     arguments, which is not yet present in the table data.';


-- With priority based route verification, we also need to take deletion of routes and scheduled stop points
-- into account. This is due to the fact that removing one instance can make another instance with a lower
-- priority become "visible" (i.e. highest priority) for a time span, in which it hasn't been visible until now.

CREATE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_other_journey_pattern_ids()
  RETURNS TRIGGER
  LANGUAGE plpgsql AS
$$
BEGIN
  --RAISE NOTICE 'journey_pattern.queue_verify_infra_link_stop_refs_by_other_journey_pattern_ids()';

  PERFORM journey_pattern.create_verify_infra_link_stop_refs_queue_temp_table();

  INSERT INTO updated_journey_pattern_routes (journey_pattern_id)
  SELECT sspijp.journey_pattern_id
  FROM old_table
         JOIN journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
              ON sspijp.scheduled_stop_point_label = old_table.label
         JOIN journey_pattern.journey_pattern jp ON jp.journey_pattern_id = sspijp.journey_pattern_id
         JOIN route.route r on r.route_id = jp.on_route_id
  WHERE TSTZRANGE(r.validity_start, r.validity_end) && TSTZRANGE(old_table.validity_start, old_table.validity_end)
  ON CONFLICT DO NOTHING;

  RETURN NULL;
END;
$$;

CREATE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_other_route_ids()
  RETURNS TRIGGER
  LANGUAGE plpgsql AS
$$
BEGIN
  --RAISE NOTICE 'journey_pattern.queue_verify_infra_link_stop_refs_by_other_route_ids()';

  PERFORM journey_pattern.create_verify_infra_link_stop_refs_queue_temp_table();

  INSERT INTO updated_journey_pattern_routes (route_id)
  SELECT r.route_id
  FROM old_table
         JOIN route.route r
              ON r.label = old_table.label
  WHERE TSTZRANGE(r.validity_start, r.validity_end) && TSTZRANGE(old_table.validity_start, old_table.validity_end)
  AND r.priority < old_table.priority
  ON CONFLICT DO NOTHING;

  RETURN NULL;
END;
$$;

CREATE TRIGGER queue_verify_infra_link_stop_refs_on_ssp_delete_trigger
  AFTER DELETE
  ON internal_service_pattern.scheduled_stop_point
  REFERENCING OLD TABLE AS old_table
  FOR EACH STATEMENT
EXECUTE PROCEDURE journey_pattern.queue_verify_infra_link_stop_refs_by_other_journey_pattern_ids();

CREATE TRIGGER queue_verify_infra_link_stop_refs_on_route_delete_trigger
  AFTER DELETE
  ON route.route
  REFERENCING OLD TABLE AS old_table
  FOR EACH STATEMENT
EXECUTE PROCEDURE journey_pattern.queue_verify_infra_link_stop_refs_by_other_route_ids();

DROP TRIGGER verify_infra_link_stop_refs_on_scheduled_stop_point_trigger
  ON internal_service_pattern.scheduled_stop_point;

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
  RENAME TO check_infra_link_stop_refs_with_new_ssp_1657873981408;

ALTER FUNCTION journey_pattern.check_infra_link_stop_refs_with_new_ssp_1657873981408(
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
  LANGUAGE SQL AS
$$
SELECT DISTINCT jp.*
FROM journey_pattern.journey_pattern jp
WHERE EXISTS (SELECT 1 FROM journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
              LEFT JOIN internal_service_pattern.scheduled_stop_point ssp ON ssp.label = sspijp.scheduled_stop_point_label
              LEFT JOIN journey_pattern.journey_pattern jp ON jp.journey_pattern_id = sspijp.journey_pattern_id
              LEFT JOIN route.route r ON r.route_id = jp.on_route_id
              WHERE ((sspijp.scheduled_stop_point_label = new_label AND TSTZRANGE(r.validity_start, r.validity_end) && TSTZRANGE(new_validity_start, new_validity_end))
                  OR (ssp.scheduled_stop_point_id = replace_scheduled_stop_point_id AND TSTZRANGE(r.validity_start, r.validity_end) && TSTZRANGE(ssp.validity_start, ssp.validity_end)))
                AND sspijp.journey_pattern_id = jp.journey_pattern_id)
  AND NOT journey_pattern.check_route_journey_pattern_refs(
  jp.journey_pattern_id,
  NULL,
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
     if a new stop point would be inserted (defined by arguments new_xxx). If
     replace_scheduled_stop_point_id is specified, the new stop point is thought to replace the stop point
     with that ID.
     This function returns a list of journey pattern and route ids, in which the links
     and stop points would conflict with each other.';
