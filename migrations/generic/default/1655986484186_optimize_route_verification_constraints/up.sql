
DROP TRIGGER verify_infra_link_stop_refs_on_journey_pattern_trigger
  ON journey_pattern.journey_pattern;

DROP TRIGGER verify_infra_link_stop_refs_on_scheduled_stop_point_trigger
  ON internal_service_pattern.scheduled_stop_point;

DROP TRIGGER verify_infra_link_stop_refs_on_infrastructure_link_along_route_trigger
  ON route.infrastructure_link_along_route;

DROP TRIGGER verify_infra_link_stop_refs_on_scheduled_stop_point_in_journey_pattern_trigger
  ON journey_pattern.scheduled_stop_point_in_journey_pattern;


ALTER FUNCTION journey_pattern.verify_infra_link_stop_refs_by_new_scheduled_stop_point_label()
  RENAME TO verify_infra_link_stop_refs_by_new_ssp_1655986484186;

ALTER FUNCTION journey_pattern.verify_infra_link_stop_refs_by_new_ssp_1655986484186()
  SET SCHEMA deleted;


ALTER FUNCTION journey_pattern.verify_infra_link_stop_refs_by_old_route_id()
  RENAME TO verify_infra_link_stop_refs_by_old_route_id_1655986484186;

ALTER FUNCTION journey_pattern.verify_infra_link_stop_refs_by_old_route_id_1655986484186()
  SET SCHEMA deleted;


ALTER FUNCTION journey_pattern.verify_infra_link_stop_refs_by_new_journey_pattern_id()
  RENAME TO verify_infra_link_stop_refs_by_new_journey_pattern_id_1655986484186;

ALTER FUNCTION journey_pattern.verify_infra_link_stop_refs_by_new_journey_pattern_id_1655986484186()
  SET SCHEMA deleted;


CREATE FUNCTION journey_pattern.create_queue_verify_infra_link_stop_refs_temp_table()
  RETURNS VOID
  LANGUAGE sql AS
$$
  CREATE TEMP TABLE IF NOT EXISTS updated_journey_pattern_routes
  (
    journey_pattern_id UUID UNIQUE,
    route_id UUID UNIQUE
  )
    ON COMMIT DELETE ROWS;
$$;

CREATE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_scheduled_stop_point_label()
  RETURNS TRIGGER
  LANGUAGE plpgsql AS
$$
BEGIN
  --RAISE NOTICE 'journey_pattern.queue_verify_infra_link_stop_refs_by_new_scheduled_stop_point_label()';

  PERFORM journey_pattern.create_queue_verify_infra_link_stop_refs_temp_table();

  INSERT INTO updated_journey_pattern_routes (journey_pattern_id)
  SELECT sspijp.journey_pattern_id
  FROM new_table
  JOIN journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
    ON sspijp.scheduled_stop_point_label = new_table.label
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

  PERFORM journey_pattern.create_queue_verify_infra_link_stop_refs_temp_table();

  INSERT INTO updated_journey_pattern_routes (route_id)
  SELECT route_id FROM old_table
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

  PERFORM journey_pattern.create_queue_verify_infra_link_stop_refs_temp_table();

  INSERT INTO updated_journey_pattern_routes (journey_pattern_id)
  SELECT journey_pattern_id
  FROM new_table
  ON CONFLICT DO NOTHING;

  RETURN NULL;
END;
$$;

CREATE FUNCTION journey_pattern.verify_infra_link_stop_refs()
  RETURNS TRIGGER
  LANGUAGE plpgsql AS
$$
DECLARE
  journey_pattern_id UUID;
  route_id UUID;
BEGIN
  --RAISE NOTICE 'journey_pattern.verify_infra_link_stop_refs()';

  FOR journey_pattern_id, route_id IN SELECT *
                                      FROM updated_journey_pattern_routes
    LOOP
      PERFORM journey_pattern.verify_route_journey_pattern_refs(journey_pattern_id, route_id);
    END LOOP;

  TRUNCATE updated_journey_pattern_routes;

  RETURN NULL;
END;
$$;


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
EXECUTE PROCEDURE journey_pattern.queue_verify_infra_link_stop_refs_by_new_scheduled_stop_point_label();
CREATE TRIGGER queue_verify_infra_link_stop_refs_on_ssp_update_trigger
  AFTER UPDATE
  ON internal_service_pattern.scheduled_stop_point
  REFERENCING NEW TABLE AS new_table
  FOR EACH STATEMENT
EXECUTE PROCEDURE journey_pattern.queue_verify_infra_link_stop_refs_by_new_scheduled_stop_point_label();

CREATE TRIGGER queue_verify_infra_link_stop_refs_on_jp_update_trigger
  AFTER UPDATE
  ON journey_pattern.journey_pattern
  REFERENCING NEW TABLE AS new_table
  FOR EACH STATEMENT
EXECUTE PROCEDURE journey_pattern.queue_verify_infra_link_stop_refs_by_new_journey_pattern_id();


CREATE CONSTRAINT TRIGGER verify_infra_link_stop_refs_on_scheduled_stop_point_in_journey_pattern_trigger
  AFTER INSERT OR UPDATE
  ON journey_pattern.scheduled_stop_point_in_journey_pattern
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
EXECUTE PROCEDURE journey_pattern.verify_infra_link_stop_refs();
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
EXECUTE PROCEDURE journey_pattern.verify_infra_link_stop_refs();
COMMENT ON
  TRIGGER verify_infra_link_stop_refs_on_infrastructure_link_along_route_trigger
  ON route.infrastructure_link_along_route IS
  'Check exclusion of a link from a route (through update / delete):
     - a route''s journey pattern may contain a stop point residing on that link
   Inclusion of a link (through insert / update) is not a problem, because it cannot get the order of the
   stops mixed up (stop residing on a route''s link cannot be part of journey pattern already at that stage).';

CREATE CONSTRAINT TRIGGER verify_infra_link_stop_refs_on_scheduled_stop_point_trigger
  AFTER INSERT OR UPDATE
  ON internal_service_pattern.scheduled_stop_point
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
EXECUTE PROCEDURE journey_pattern.verify_infra_link_stop_refs();
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
EXECUTE PROCEDURE journey_pattern.verify_infra_link_stop_refs();
COMMENT ON
  TRIGGER verify_infra_link_stop_refs_on_journey_pattern_trigger
  ON journey_pattern.journey_pattern IS
  'Check if the journey pattern is moved to a route
    - which does not contain all links the journey pattern''s stops reside on OR
    - which traverses a link of a stop of the journey pattern in the wrong direction compared to the stop''s allowed
      directions';
