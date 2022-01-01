
CREATE FUNCTION journey_pattern.infra_link_order_map_by_journey_pattern_id(
  filter_journey_pattern_id uuid
)
  RETURNS TABLE(
                 journey_pattern_id uuid,
                 scheduled_stop_point_id uuid,
                 scheduled_stop_point_sequence int,
                 journey_pattern_order bigint,
                 route_id uuid,
                 route_link_id uuid,
                 infrastructure_link_sequence int,
                 route_order bigint
               )
  LANGUAGE SQL
AS
$$
SELECT
  sspijp.journey_pattern_id,
  sspijp.scheduled_stop_point_id,
  sspijp.scheduled_stop_point_sequence,
  row_number() OVER (PARTITION BY sspijp.journey_pattern_id ORDER BY sspijp.scheduled_stop_point_sequence) AS journey_pattern_order,
  ilar.route_id,
  ilar.infrastructure_link_id as route_link_id,
  ilar.infrastructure_link_sequence,
  -- order also by scheduled_stop_point_sequence to get a deterministic order also when there are multiple stops on the same infra link
  row_number() OVER (PARTITION BY ilar.route_id ORDER BY ilar.infrastructure_link_sequence, sspijp.scheduled_stop_point_sequence) AS route_order
FROM journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
       LEFT JOIN internal_service_pattern.scheduled_stop_point ssp ON ssp.scheduled_stop_point_id = sspijp.scheduled_stop_point_id
       LEFT JOIN journey_pattern.journey_pattern jp ON jp.journey_pattern_id = sspijp.journey_pattern_id
       LEFT JOIN route.infrastructure_link_along_route ilar ON ilar.route_id = jp.on_route_id AND ilar.infrastructure_link_id = ssp.located_on_infrastructure_link_id
WHERE sspijp.journey_pattern_id = filter_journey_pattern_id
$$;
COMMENT ON FUNCTION
  journey_pattern.infra_link_order_map_by_journey_pattern_id IS
  'Retrieve the map of the infra link order of stop points according between the route and
  journey_pattern. The map is constructed from the given journey_pattern_id.';


CREATE FUNCTION journey_pattern.infra_link_order_map_by_route_id(
  filter_route_id uuid
)
  RETURNS TABLE(
                 journey_pattern_id uuid,
                 scheduled_stop_point_id uuid,
                 scheduled_stop_point_sequence int,
                 journey_pattern_order bigint,
                 route_id uuid,
                 route_link_id uuid,
                 infrastructure_link_sequence int,
                 route_order bigint
               )
  LANGUAGE SQL AS
$$
SELECT
  sspijp.journey_pattern_id,
  sspijp.scheduled_stop_point_id,
  sspijp.scheduled_stop_point_sequence,
  row_number() OVER (PARTITION BY sspijp.journey_pattern_id ORDER BY sspijp.scheduled_stop_point_sequence) AS journey_pattern_order,
  ilar.route_id,
  ilar.infrastructure_link_id as route_link_id,
  ilar.infrastructure_link_sequence,
  -- order also by scheduled_stop_point_sequence to get a deterministic order also when there are multiple stops on the same infra link
  row_number() OVER (PARTITION BY ilar.route_id ORDER BY ilar.infrastructure_link_sequence, sspijp.scheduled_stop_point_sequence) AS route_order
FROM route.infrastructure_link_along_route ilar
       LEFT JOIN journey_pattern.journey_pattern jp ON jp.on_route_id = filter_route_id
       LEFT JOIN journey_pattern.scheduled_stop_point_in_journey_pattern sspijp ON sspijp.journey_pattern_id = jp.journey_pattern_id
       LEFT JOIN internal_service_pattern.scheduled_stop_point ssp ON ssp.scheduled_stop_point_id = sspijp.scheduled_stop_point_id
WHERE ilar.infrastructure_link_id = ssp.located_on_infrastructure_link_id AND ilar.route_id = filter_route_id
$$;
COMMENT ON FUNCTION journey_pattern.infra_link_order_map_by_route_id IS
  'Retrieve the map of the infra link order of stop points according between the route and
  journey_pattern. The map is constructed from the given route_id.';



CREATE FUNCTION journey_pattern.verify_journey_pattern_infra_link_order(
  filter_journey_pattern_id uuid,
  filter_route_id uuid
)
  RETURNS void
  LANGUAGE plpgsql
AS
$$
BEGIN
  CREATE TEMP TABLE infra_link_map AS
  SELECT * FROM journey_pattern.infra_link_order_map_by_journey_pattern_id(filter_journey_pattern_id)
  WHERE filter_journey_pattern_id IS NOT NULL
  UNION ALL
  SELECT * FROM journey_pattern.infra_link_order_map_by_route_id(filter_route_id)
  WHERE filter_route_id IS NOT NULL;

  IF EXISTS (
    SELECT 1
    FROM infra_link_map
    WHERE route_link_id IS NULL
    )
  THEN
    DROP TABLE infra_link_map;
    RAISE EXCEPTION 'found stop in journey pattern which is on a link that is not part of the route';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM infra_link_map
    WHERE journey_pattern_order != route_order
    )
  THEN
    DROP TABLE infra_link_map;
    RAISE EXCEPTION 'stops in journey pattern are not in the same order as the links they are on in the route';
  END IF;

  DROP TABLE infra_link_map;
END;
$$;


CREATE FUNCTION journey_pattern.verify_infra_link_order_by_new_journey_pattern_id()
  RETURNS TRIGGER
  LANGUAGE plpgsql
AS
$$
BEGIN
  PERFORM journey_pattern.verify_journey_pattern_infra_link_order(NEW.journey_pattern_id, NULL);

  RETURN NULL;
END;
$$;

CREATE FUNCTION journey_pattern.verify_infra_link_order_by_old_route_id()
  RETURNS TRIGGER
  LANGUAGE plpgsql
AS
$$
BEGIN
  PERFORM journey_pattern.verify_journey_pattern_infra_link_order(NULL, OLD.route_id);

  RETURN NULL;
END;
$$;

CREATE FUNCTION journey_pattern.verify_infra_link_order_by_new_scheduled_stop_point_id()
  RETURNS TRIGGER
  LANGUAGE plpgsql AS
$$
DECLARE
  journey_pattern_id UUID;
BEGIN
  FOR journey_pattern_id IN SELECT sspijp.journey_pattern_id
                            FROM journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
                            WHERE sspijp.scheduled_stop_point_id = NEW.scheduled_stop_point_id
    LOOP
      PERFORM journey_pattern.verify_journey_pattern_infra_link_order(journey_pattern_id, NULL);
    END LOOP;

  RETURN NULL;
END;
$$;


CREATE CONSTRAINT TRIGGER verify_infra_link_order_on_scheduled_stop_point_in_journey_pattern_trigger
  AFTER INSERT OR UPDATE ON journey_pattern.scheduled_stop_point_in_journey_pattern
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW EXECUTE PROCEDURE journey_pattern.verify_infra_link_order_by_new_journey_pattern_id();
COMMENT ON
  TRIGGER verify_infra_link_order_on_scheduled_stop_point_in_journey_pattern_trigger
  ON journey_pattern.scheduled_stop_point_in_journey_pattern IS
  'Check inclusion of a stop into a journey pattern (through insert / update):
     - included stop might be on a link, which is not included in the journey pattern''s route
     - included stop might be included at a position, which does not correspond to the position of its
       infra link in the journey pattern''s route
   Exclusion of a stop from a journey pattern (through update / delete) is not a problem,
   because it cannot get the order of the stops mixed up.';

CREATE CONSTRAINT TRIGGER verify_infra_link_order_on_infrastructure_link_along_route_trigger
  AFTER UPDATE OR DELETE ON route.infrastructure_link_along_route
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW EXECUTE PROCEDURE journey_pattern.verify_infra_link_order_by_old_route_id();
COMMENT ON
  TRIGGER verify_infra_link_order_on_infrastructure_link_along_route_trigger
  ON route.infrastructure_link_along_route IS
  'Check exclusion of a link from a route (through update / delete):
     - a route''s journey pattern may contain a stop point residing on that link
   Inclusion of a link (through insert / update) is not a problem, because it cannot get the order of the
   stops mixed up (stop residing on a route''s link cannot be part of journey pattern already at that stage).';

CREATE CONSTRAINT TRIGGER verify_infra_link_order_on_scheduled_stop_point_trigger
  AFTER UPDATE ON internal_service_pattern.scheduled_stop_point
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW EXECUTE PROCEDURE journey_pattern.verify_infra_link_order_by_new_scheduled_stop_point_id();
COMMENT ON
  TRIGGER verify_infra_link_order_on_scheduled_stop_point_trigger
  ON internal_service_pattern.scheduled_stop_point IS
  'Check if the stop is moved to a link
     - that is not part of all the routes'' journey patterns the stop is part of OR
     - which is in the wrong order in the stop''s journey patterns';

CREATE CONSTRAINT TRIGGER verify_infra_link_order_on_journey_pattern_trigger
  AFTER UPDATE ON journey_pattern.journey_pattern
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW EXECUTE PROCEDURE journey_pattern.verify_infra_link_order_by_new_journey_pattern_id();
COMMENT ON
  TRIGGER verify_infra_link_order_on_journey_pattern_trigger
  ON journey_pattern.journey_pattern IS
  'Check if the journey pattern is moved to a route, which does not contain all links the journey pattern''s
   stops reside on.';
