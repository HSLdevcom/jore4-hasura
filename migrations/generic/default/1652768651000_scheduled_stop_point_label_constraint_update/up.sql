

ALTER FUNCTION journey_pattern.verify_route_journey_pattern_refs(uuid, uuid)
RENAME TO verify_route_journey_pattern_refs_1649661919181;

ALTER FUNCTION journey_pattern.verify_route_journey_pattern_refs_1649661919181(uuid, uuid)
SET SCHEMA deleted;


-- After these changes, there can be many stops with the same label which are part of the same journey pattern. In
-- the previous version, this constraint was checking that the scheduled stop point instances, that were part of the
-- journey pattern, and their order matched the route's links' and the order of those.
-- With the changes, we must include a check that all scheduled stop point instances with the same label appear at the
-- same position in all versions of the journey pattern. When performing the checks, we distinctively leave out stop
-- point instances, whose validity time does not overlap with the validity time of the route to be checked.

CREATE FUNCTION internal_service_pattern.get_scheduled_stop_points_with_new(
  replace_scheduled_stop_point_id UUID DEFAULT NULL,
  new_scheduled_stop_point_id UUID DEFAULT NULL,
  new_located_on_infrastructure_link_id UUID DEFAULT NULL,
  new_measured_location GEOGRAPHY(POINTZ, 4326) DEFAULT NULL,
  new_direction TEXT DEFAULT NULL,
  new_label TEXT DEFAULT NULL,
  new_validity_start timestamp WITH TIME ZONE DEFAULT NULL,
  new_validity_end timestamp WITH TIME ZONE DEFAULT NULL
)
  RETURNS SETOF service_pattern.scheduled_stop_point
  STABLE
  LANGUAGE plpgsql
AS
$$
BEGIN
  IF new_scheduled_stop_point_id IS NULL THEN
    RETURN QUERY
      SELECT * FROM service_pattern.scheduled_stop_point ssp
      WHERE replace_scheduled_stop_point_id IS NULL OR ssp.scheduled_stop_point_id != replace_scheduled_stop_point_id;
  ELSE
    RETURN QUERY
      SELECT * FROM service_pattern.scheduled_stop_point ssp
      WHERE replace_scheduled_stop_point_id IS NULL OR ssp.scheduled_stop_point_id != replace_scheduled_stop_point_id
      UNION ALL
      SELECT
        new_scheduled_stop_point_id, new_label, new_measured_location::geography(PointZ, 4326),
        new_located_on_infrastructure_link_id, new_direction,
        internal_utils.st_linelocatepoint(il.shape, new_measured_location) AS relative_distance_from_infrastructure_link_start,
        NULL::geography(PointZ, 4326) AS closest_point_on_infrastructure_link,
        new_validity_start, new_validity_end, NULL::integer AS priority
      FROM infrastructure_network.infrastructure_link il
      WHERE il.infrastructure_link_id = new_located_on_infrastructure_link_id;
  END IF;
END;
$$;
COMMENT ON FUNCTION internal_service_pattern.get_scheduled_stop_points_with_new(
  replace_scheduled_stop_point_id UUID,
  new_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location GEOGRAPHY(POINTZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE)
IS
  'Returns the scheduled stop points from the internal_service_pattern.scheduled_stop_point table.
   If replace_scheduled_stop_point_id is not null, the stop point with that ID is filtered out.
   Similarly, if the new_xxx arguments are specified, a scheduled stop point with those values is
   appended to the result (it is not inserted into the table).';

CREATE FUNCTION journey_pattern.check_route_journey_pattern_refs(
  filter_journey_pattern_id uuid,
  filter_route_id uuid,
  replace_scheduled_stop_point_id UUID DEFAULT NULL,
  new_located_on_infrastructure_link_id UUID DEFAULT NULL,
  new_measured_location GEOGRAPHY(POINTZ, 4326) DEFAULT NULL,
  new_direction TEXT DEFAULT NULL,
  new_label TEXT DEFAULT NULL,
  new_validity_start timestamp WITH TIME ZONE DEFAULT NULL,
  new_validity_end timestamp WITH TIME ZONE DEFAULT NULL
)
  RETURNS bool
  LANGUAGE plpgsql
AS
$$
DECLARE
  new_scheduled_stop_point_id UUID DEFAULT NULL;
BEGIN
  IF new_located_on_infrastructure_link_id IS NOT NULL
  THEN
    SELECT gen_random_uuid() INTO new_scheduled_stop_point_id;
  END IF;

  -- Check if it is possible to visit all stops of a journey pattern in such a fashion that all links, on which
  -- the stops reside, are visited in an order matching the route's link order.
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
             ssp_with_new AS (
               SELECT * FROM internal_service_pattern.get_scheduled_stop_points_with_new(
                 replace_scheduled_stop_point_id,
                 new_scheduled_stop_point_id,
                 new_located_on_infrastructure_link_id,
                 new_measured_location,
                 new_direction,
                 new_label,
                 new_validity_start,
                 new_validity_end)
             ),
             -- For all stops in the journey pattern, list all visits of the stop's infra link. (But only include
             -- visits happening in a direction matching the stop's allowed directions - if the direction is wrong,
             -- we cannot approach the stop point on that particular link visit. Similarly, include only those stop
             -- instances, whose validity period overlaps with the route's validity period.)
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
                      SELECT journey_pattern_id,
                             scheduled_stop_point_label,
                             scheduled_stop_point_sequence,
                             -- create a continuous sequence number of the scheduled_stop_point_sequence (which is not
                             -- required to be continuous, i.e. there can be gaps)
                             ROW_NUMBER()
                             OVER (PARTITION BY journey_pattern_id ORDER BY scheduled_stop_point_sequence) AS stop_point_order
                      FROM journey_pattern.scheduled_stop_point_in_journey_pattern
                    ) AS sspijp
                      LEFT JOIN ssp_with_new ssp
                                ON ssp.label = sspijp.scheduled_stop_point_label
                      LEFT JOIN journey_pattern.journey_pattern jp ON jp.journey_pattern_id = sspijp.journey_pattern_id
                      LEFT JOIN route.route r
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
               WHERE jp.journey_pattern_id = filter_journey_pattern_id
                  OR r.route_id = filter_route_id
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
                  ROW_NUMBER()
                  OVER (ORDER BY stop_point_order, infrastructure_link_sequence, scheduled_stop_point_id)
                    AS stop_point_order,
                  ROW_NUMBER()
                  OVER (ORDER BY infrastructure_link_sequence, stop_point_order, scheduled_stop_point_id)
                    AS infra_link_order
           FROM (
                  SELECT t.stop_point_order,
                         t.infrastructure_link_sequence,
                         t.scheduled_stop_point_id,
                         ROW_NUMBER()
                         OVER (PARTITION BY sspijp.journey_pattern_id, ssp.scheduled_stop_point_id, r.route_id, infrastructure_link_id, stop_point_order ORDER BY infrastructure_link_sequence)
                           AS order_by_min
                  FROM journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
                         JOIN ssp_with_new ssp
                              ON ssp.label = sspijp.scheduled_stop_point_label
                         JOIN journey_pattern.journey_pattern jp ON jp.journey_pattern_id = sspijp.journey_pattern_id
                         JOIN route.route r
                              ON r.route_id = jp.on_route_id
                         LEFT JOIN traversal t
                                   ON t.journey_pattern_id = sspijp.journey_pattern_id
                                     AND t.scheduled_stop_point_id = ssp.scheduled_stop_point_id
                                     AND t.scheduled_stop_point_sequence = sspijp.scheduled_stop_point_sequence
                  WHERE (jp.journey_pattern_id = filter_journey_pattern_id
                    OR r.route_id = filter_route_id)
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
  new_measured_location GEOGRAPHY(POINTZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE)
IS
  'Check if it is possible to visit all stops of a journey pattern in such a fashion that all links, on which
   the stops reside, are visited in an order matching the route''s link order.

   If a filter_xxx argument is not null, only the links / stops on that route / journey pattern are taken into
   account. If replace_scheduled_stop_point_id is not null, the stop with that id is left out of the check.
   If the new_xxx arguments are specified, the check is also performed for an imaginary stop defined by those
   arguments, which is not yet present in the table data.';

CREATE FUNCTION journey_pattern.verify_route_journey_pattern_refs(
  filter_journey_pattern_id uuid,
  filter_route_id uuid
)
  RETURNS void
  LANGUAGE plpgsql
AS
$$
BEGIN
  IF NOT journey_pattern.check_route_journey_pattern_refs(
    filter_journey_pattern_id,
    filter_route_id
    )
  THEN
    RAISE EXCEPTION 'route''s and journey pattern''s traversal paths must match each other';
  END IF;
END;
$$;
COMMENT ON FUNCTION journey_pattern.verify_route_journey_pattern_refs(
  filter_journey_pattern_id uuid,
  filter_route_id uuid)
IS
  'Raise an exception if the specified journey pattern''s / route''s links and stop points do not
   correspond to each other.';

CREATE FUNCTION journey_pattern.check_infra_link_stop_refs_with_new_scheduled_stop_point(
  replace_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location GEOGRAPHY(POINTZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE
)
  RETURNS SETOF journey_pattern.journey_pattern
  STABLE
  LANGUAGE sql AS
$$
SELECT jp.*
FROM journey_pattern.journey_pattern jp
WHERE EXISTS (SELECT 1 FROM journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
              WHERE sspijp.scheduled_stop_point_label = new_label
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
    new_validity_end
  );
$$;
COMMENT ON FUNCTION journey_pattern.check_infra_link_stop_refs_with_new_scheduled_stop_point(
  replace_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location GEOGRAPHY(POINTZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE)
IS
  'Check whether the journey pattern''s / route''s links and stop points still correspond to each other
   if a new stop point would be inserted (defined by arguments new_xxx). If
   replace_scheduled_stop_point_id is specified, the new stop point is thought to replace the stop point
   with that ID.
   This function returns a list of journey pattern and route ids, in which the links
   and stop points would conflict with each other.';


DROP TRIGGER verify_infra_link_stop_refs_on_scheduled_stop_point_trigger
  ON internal_service_pattern.scheduled_stop_point;

ALTER FUNCTION journey_pattern.verify_infra_link_stop_refs_by_new_scheduled_stop_point_id()
  RENAME TO verify_infra_link_stop_refs_by_new_ssp_1649847021000;

ALTER FUNCTION journey_pattern.verify_infra_link_stop_refs_by_new_ssp_1649847021000()
  SET SCHEMA deleted;

CREATE FUNCTION journey_pattern.verify_infra_link_stop_refs_by_new_scheduled_stop_point_label()
  RETURNS TRIGGER
  LANGUAGE plpgsql AS
$$
DECLARE
  journey_pattern_id UUID;
BEGIN
  FOR journey_pattern_id IN SELECT sspijp.journey_pattern_id
                            FROM journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
                            WHERE sspijp.scheduled_stop_point_label = NEW.label
    LOOP
      PERFORM journey_pattern.verify_route_journey_pattern_refs(journey_pattern_id, NULL);
    END LOOP;

  RETURN NULL;
END;
$$;

CREATE CONSTRAINT TRIGGER verify_infra_link_stop_refs_on_scheduled_stop_point_trigger
  AFTER INSERT OR UPDATE
  ON internal_service_pattern.scheduled_stop_point
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
EXECUTE PROCEDURE journey_pattern.verify_infra_link_stop_refs_by_new_scheduled_stop_point_label();
COMMENT ON
  TRIGGER verify_infra_link_stop_refs_on_scheduled_stop_point_trigger
  ON internal_service_pattern.scheduled_stop_point IS
  'Check if the stop is moved to a link
     - that is not part of all the routes'' journey patterns the stop is part of OR
     - which is in the wrong order in the stop''s journey patterns OR
     - which is traversed in the wrong direction compared to the stop''s allowed directions';
