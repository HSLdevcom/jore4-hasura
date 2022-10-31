CREATE FUNCTION journey_pattern.verify_route_journey_pattern_refs(
  filter_journey_pattern_id uuid,
  filter_route_id uuid
)
  RETURNS void
  LANGUAGE plpgsql
AS
$$
BEGIN
  -- Check if it is possible to visit all stops of a journey pattern in such a fashion that all links, on which
  -- the stops reside, are visited in an order matching the route's link order.
  --
  -- This implicitly ensures
  --   - that every stop point in the journey pattern resides on a link that is part of the journey pattern's route
  --   - the stop points' order is the same as the order of the links they reside on
  --   - the stop points' directions match the directions, in which the stop points' links are visited.
  --
  -- For debugging purposes, an additional query fragment is provided below.
  IF EXISTS (
    SELECT 1
    FROM (
       WITH RECURSIVE
         -- For all stops in the journey pattern, list all visits of the stop's infra link. (But only include
         -- visits happening in a direction matching the stop's allowed directions - if the direction is wrong,
         -- we cannot approach the stop point on that particular link visit.)
         sspijp_ilar_combos AS (
           SELECT sspijp.journey_pattern_id,
                  sspijp.scheduled_stop_point_id,
                  sspijp.scheduled_stop_point_sequence,
                  sspijp.stop_point_order,
                  ilar.route_id,
                  ilar.infrastructure_link_id,
                  ilar.infrastructure_link_sequence
           FROM (
                  SELECT journey_pattern_id,
                         scheduled_stop_point_id,
                         scheduled_stop_point_sequence,
                         -- create a continuous sequence number of the scheduled_stop_point_sequence (which is not
                         -- required to be continuous, i.e. there can be gaps)
                         ROW_NUMBER()
                         OVER (PARTITION BY journey_pattern_id ORDER BY scheduled_stop_point_sequence) AS stop_point_order
                  FROM journey_pattern.scheduled_stop_point_in_journey_pattern
                ) AS sspijp
                  LEFT JOIN internal_service_pattern.scheduled_stop_point ssp
                            ON ssp.scheduled_stop_point_id = sspijp.scheduled_stop_point_id
                  LEFT JOIN journey_pattern.journey_pattern jp ON jp.journey_pattern_id = sspijp.journey_pattern_id
                  LEFT JOIN route.infrastructure_link_along_route ilar
                            ON ilar.route_id = jp.on_route_id
                              AND ilar.infrastructure_link_id = ssp.located_on_infrastructure_link_id
                              -- visits of the link in a direction not matching the stop's possible directions are
                              -- filtered out here
                              AND (ssp.direction = 'bidirectional' OR
                                   ((ssp.direction = 'forward' AND ilar.is_traversal_forwards = true)
                                     OR (ssp.direction = 'backward' AND ilar.is_traversal_forwards = false)))
           WHERE jp.journey_pattern_id = filter_journey_pattern_id
              OR jp.on_route_id = filter_route_id
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
           -- select the next stop
           WHERE sspijp_ilar_combos.stop_point_order = traversal.stop_point_order + 1
             -- Only allow visiting the route links in ascending route link order. >= is needed to be able
             -- to visit two stops residing on the same infra link consecutively.
             AND sspijp_ilar_combos.infrastructure_link_sequence >= traversal.infrastructure_link_sequence
         )
       -- List all stops of the journey pattern and left-join their visits in the traversal performed above. In case
       -- no visit is present for any row (infrastructure_link_sequence is null), it was not possible to visit all
       -- stops in a way matching the route's link order.
       SELECT t.infrastructure_link_sequence
       FROM journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
              LEFT JOIN internal_service_pattern.scheduled_stop_point ssp
                        ON ssp.scheduled_stop_point_id = sspijp.scheduled_stop_point_id
              LEFT JOIN journey_pattern.journey_pattern jp ON jp.journey_pattern_id = sspijp.journey_pattern_id
              LEFT JOIN traversal t
                        ON t.journey_pattern_id = sspijp.journey_pattern_id
                          AND t.scheduled_stop_point_id = sspijp.scheduled_stop_point_id
                          AND t.scheduled_stop_point_sequence = sspijp.scheduled_stop_point_sequence
       WHERE sspijp.journey_pattern_id = filter_journey_pattern_id
          OR jp.on_route_id = filter_route_id
    ) as infra_link_seq
    WHERE infra_link_seq.infrastructure_link_sequence IS NULL
  )
  THEN
    RAISE EXCEPTION 'route''s and journey pattern''s traversal paths must match each other';
  END IF;

  -- When debugging the above query, you can start by placing the following query to be the main query. It will list
  -- the actual possible traversal instead of checking the feasibility of any traversal:
  --   SELECT *
  --   FROM (
  --          SELECT journey_pattern_id,
  --                 scheduled_stop_point_id,
  --                 scheduled_stop_point_sequence,
  --                 ROW_NUMBER()
  --                 OVER (PARTITION BY journey_pattern_id, scheduled_stop_point_id, route_id, infrastructure_link_id, stop_point_order ORDER BY infrastructure_link_sequence) AS order_by_min
  --          FROM traversal
  --        ) AS ordered_sspijp_ilar_combos
  --   WHERE ordered_sspijp_ilar_combos.order_by_min = 1;
END;
$$;


CREATE FUNCTION journey_pattern.verify_infra_link_stop_refs_by_new_journey_pattern_id()
  RETURNS trigger
  LANGUAGE plpgsql
AS
$$
BEGIN
  PERFORM journey_pattern.verify_route_journey_pattern_refs(NEW.journey_pattern_id, NULL);

  RETURN NULL;
END;
$$;

CREATE FUNCTION journey_pattern.verify_infra_link_stop_refs_by_old_route_id()
  RETURNS trigger
  LANGUAGE plpgsql
AS
$$
BEGIN
  PERFORM journey_pattern.verify_route_journey_pattern_refs(NULL, OLD.route_id);

  RETURN NULL;
END;
$$;

CREATE FUNCTION journey_pattern.verify_infra_link_stop_refs_by_new_scheduled_stop_point_id()
  RETURNS trigger
  LANGUAGE plpgsql AS
$$
DECLARE
  journey_pattern_id UUID;
BEGIN
  FOR journey_pattern_id IN SELECT sspijp.journey_pattern_id
                            FROM journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
                            WHERE sspijp.scheduled_stop_point_id = NEW.scheduled_stop_point_id
    LOOP
      PERFORM journey_pattern.verify_route_journey_pattern_refs(journey_pattern_id, NULL);
    END LOOP;

  RETURN NULL;
END;
$$;


CREATE CONSTRAINT TRIGGER verify_infra_link_stop_refs_on_scheduled_stop_point_in_journey_pattern_trigger
  AFTER INSERT OR UPDATE
  ON journey_pattern.scheduled_stop_point_in_journey_pattern
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
EXECUTE PROCEDURE journey_pattern.verify_infra_link_stop_refs_by_new_journey_pattern_id();
COMMENT ON
  TRIGGER verify_infra_link_stop_refs_on_scheduled_stop_point_in_journey_pattern_trigger
  ON journey_pattern.scheduled_stop_point_in_journey_pattern IS
  'Check inclusion of a stop into a journey pattern (through insert / update):
     - included stop might be on a link, which is not included in the journey pattern''s route
     - included stop might be included at a position, which does not correspond to the position of its
       infra link in the journey pattern''s route
     - included stop''s link might be traversed in a direction not suitable with the route''s traversal
       direction
   Exclusion of a stop from a journey pattern (through update / delete) is not a problem,
   because it cannot get the order of the stops mixed up.';

CREATE CONSTRAINT TRIGGER verify_infra_link_stop_refs_on_infrastructure_link_along_route_trigger
  AFTER UPDATE OR DELETE
  ON route.infrastructure_link_along_route
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
EXECUTE PROCEDURE journey_pattern.verify_infra_link_stop_refs_by_old_route_id();
COMMENT ON
  TRIGGER verify_infra_link_stop_refs_on_infrastructure_link_along_route_trigger
  ON route.infrastructure_link_along_route IS
  'Check exclusion of a link from a route (through update / delete):
     - a route''s journey pattern may contain a stop point residing on that link
   Inclusion of a link (through insert / update) is not a problem, because it cannot get the order of the
   stops mixed up (stop residing on a route''s link cannot be part of journey pattern already at that stage).';

CREATE CONSTRAINT TRIGGER verify_infra_link_stop_refs_on_scheduled_stop_point_trigger
  AFTER UPDATE
  ON internal_service_pattern.scheduled_stop_point
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
EXECUTE PROCEDURE journey_pattern.verify_infra_link_stop_refs_by_new_scheduled_stop_point_id();
COMMENT ON
  TRIGGER verify_infra_link_stop_refs_on_scheduled_stop_point_trigger
  ON internal_service_pattern.scheduled_stop_point IS
  'Check if the stop is moved to a link
     - that is not part of all the routes'' journey patterns the stop is part of OR
     - which is in the wrong order in the stop''s journey patterns OR
     - which is traversed in the wrong direction compared to the stop''s allowed directions';

CREATE CONSTRAINT TRIGGER verify_infra_link_stop_refs_on_journey_pattern_trigger
  AFTER UPDATE
  ON journey_pattern.journey_pattern
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
EXECUTE PROCEDURE journey_pattern.verify_infra_link_stop_refs_by_new_journey_pattern_id();
COMMENT ON
  TRIGGER verify_infra_link_stop_refs_on_journey_pattern_trigger
  ON journey_pattern.journey_pattern IS
  'Check if the journey pattern is moved to a route
    - which does not contain all links the journey pattern''s stops reside on OR
    - which traverses a link of a stop of the journey pattern in the wrong direction compared to the stop''s allowed
      directions';
