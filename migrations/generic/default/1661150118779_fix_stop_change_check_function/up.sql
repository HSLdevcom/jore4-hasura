
ALTER FUNCTION journey_pattern.check_infra_link_stop_refs_with_new_scheduled_stop_point (
  replace_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE,
  new_priority INT
  )
  RENAME TO check_infra_link_stop_refs_with_new_ssp_1661150118779;
ALTER FUNCTION journey_pattern.check_infra_link_stop_refs_with_new_ssp_1661150118779 (
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


-- The previous version of the function did not return (in any reasonable time frame) for even slightly complicated
-- use cases. This version fixes this behaviour, the execution time is now growing linearly wrt the amount of routes
-- to be checked.
-- NB: Postgresql's query planner does not do a good job with the check_route_journey_pattern_refs -function used
-- below, so the routes are checked in a loop.

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
  LANGUAGE plpgsql AS
$$
DECLARE affected_journey_pattern journey_pattern.journey_pattern;
BEGIN
  -- fetch all journey patterns, whose route has has an overlapping validity time with either...
  FOR affected_journey_pattern IN SELECT DISTINCT jp.*
                                  FROM journey_pattern.journey_pattern jp
                                         JOIN route.route r ON r.route_id = jp.on_route_id
                                         LEFT JOIN journey_pattern.scheduled_stop_point_in_journey_pattern sspijp ON sspijp.journey_pattern_id = jp.journey_pattern_id
                                         LEFT JOIN internal_service_pattern.scheduled_stop_point ssp ON ssp.label = sspijp.scheduled_stop_point_label
                                  -- 1. the scheduled stop point instance to be inserted (defined by the new_... arguments) or
                                  WHERE ((sspijp.scheduled_stop_point_label = new_label AND TSTZRANGE(r.validity_start, r.validity_end) && TSTZRANGE(new_validity_start, new_validity_end))
                                    -- 2. the scheduled stop point instance to be replaced (identified by the replace_scheduled_stop_point_id argument)
                                    OR (ssp.scheduled_stop_point_id = replace_scheduled_stop_point_id AND TSTZRANGE(r.validity_start, r.validity_end) && TSTZRANGE(ssp.validity_start, ssp.validity_end)))
    LOOP
      -- check if the journey pattern would be broken by the proposed scheduled stop point change
      IF NOT journey_pattern.check_route_journey_pattern_refs(
        affected_journey_pattern.journey_pattern_id,
        NULL,
        replace_scheduled_stop_point_id,
        new_located_on_infrastructure_link_id,
        new_measured_location,
        new_direction,
        new_label,
        new_validity_start,
        new_validity_end,
        new_priority
        ) THEN
        RETURN NEXT affected_journey_pattern;
      END IF;
    END LOOP;
END;
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
