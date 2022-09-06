-- Previously, the route<->journey pattern consistency check was run separately for every significant changed row in
-- any of the related tables:
--   - journey_pattern.scheduled_stop_point_in_journey_pattern
--   - route.infrastructure_link_along_route
--   - internal_service_pattern.scheduled_stop_point
--   - journey_pattern.journey_pattern
--
-- This was realized via deferred row-level constraint triggers only and thus caused a lot of overhead.
--
-- With this change, we create statement-level triggers for the significant operations on above mentioned tables to
-- enqueue verification of the changed journey patterns and routes using a temp table (updated_journey_pattern_routes).
-- Then we use deferred constraint triggers at the end of transactions to check the consistency of each queued
-- journey pattern / route only once. Since constraint triggers can only be specified on row-level, a postgresql
-- transaction run-time config setting is used to prevent the triggers from running and thus performing the same
-- checks multiple times.
--
-- Unfortunately, this scheme cannot be used for the TRUNCATE operation on the route.infrastructure_link_along_route
-- table, because Postgresql does not allow deferred constraint triggers for TRUNCATE. The TRUNCATE operation is used
-- extensively during tests, and we cannot guarantee that Hasura does not ever use it. The workaround used is to
-- truncate also the journey_pattern.scheduled_stop_point_in_journey_pattern table (if it is non-empty) whenever
-- route.infrastructure_link_along_route is truncated, which ensures data consistency.


-- drop old triggers and move old functions to the "deleted" schema

DROP TRIGGER verify_infra_link_stop_refs_on_journey_pattern_trigger
  ON journey_pattern.journey_pattern;

DROP TRIGGER verify_infra_link_stop_refs_on_scheduled_stop_point_trigger
  ON internal_service_pattern.scheduled_stop_point;

DROP TRIGGER verify_infra_link_stop_refs_on_infrastructure_link_along_route_trigger
  ON route.infrastructure_link_along_route;

DROP TRIGGER verify_infra_link_stop_refs_on_scheduled_stop_point_in_journey_trigger
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


-- set up new functions and triggers

CREATE FUNCTION journey_pattern.create_verify_infra_link_stop_refs_queue_temp_table()
  RETURNS VOID
  LANGUAGE sql AS
$$
  CREATE TEMP TABLE IF NOT EXISTS updated_journey_pattern_routes
  (
    journey_pattern_id UUID UNIQUE,
    route_id           UUID UNIQUE
  )
    ON COMMIT DELETE ROWS;
  $$;
COMMENT ON FUNCTION journey_pattern.create_verify_infra_link_stop_refs_queue_temp_table()
  IS '''Create the temp table used to enqueue verification of the changed journey patterns and routes from
  statement-level triggers''';


-- create the trigger functions to enqueue verification of the changed journey patterns and routes from statement-level
-- triggers

CREATE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_ssp_label()
  RETURNS TRIGGER
  LANGUAGE plpgsql AS
$$
BEGIN
  --RAISE NOTICE 'journey_pattern.queue_verify_infra_link_stop_refs_by_new_ssp_label()';

  PERFORM journey_pattern.create_verify_infra_link_stop_refs_queue_temp_table();

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

  PERFORM journey_pattern.create_verify_infra_link_stop_refs_queue_temp_table();

  INSERT INTO updated_journey_pattern_routes (route_id)
  SELECT route_id
  FROM old_table
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

  INSERT INTO updated_journey_pattern_routes (journey_pattern_id)
  SELECT journey_pattern_id
  FROM new_table
  ON CONFLICT DO NOTHING;

  RETURN NULL;
END;
$$;

-- create function to perform verification of all queued journey pattern / route entries

CREATE FUNCTION journey_pattern.verify_infra_link_stop_refs()
  RETURNS TRIGGER
  LANGUAGE plpgsql AS
$$
DECLARE
  journey_pattern_id UUID;
  route_id           UUID;
BEGIN
  --RAISE NOTICE 'journey_pattern.verify_infra_link_stop_refs()';

  FOR journey_pattern_id, route_id IN SELECT *
                                      FROM updated_journey_pattern_routes
    LOOP
      PERFORM journey_pattern.verify_route_journey_pattern_refs(journey_pattern_id, route_id);
    END LOOP;

  RETURN NULL;
END;
$$;
COMMENT ON FUNCTION journey_pattern.verify_infra_link_stop_refs()
  IS '''Perform verification of all queued journey pattern / route entries. The queued entries are cleared after a
  successful run to prevent from double checks in subsequent function calls within the same transaction.''';

-- create function to truncate the scheduled_stop_point_in_journey_pattern if it contains any rows

CREATE FUNCTION journey_pattern.truncate_scheduled_stop_point_in_journey_pattern()
  RETURNS TRIGGER
  LANGUAGE plpgsql AS
$$
BEGIN
  --RAISE NOTICE 'journey_pattern.truncate_scheduled_stop_point_in_journey_pattern()';

  IF (SELECT COUNT(*) FROM journey_pattern.scheduled_stop_point_in_journey_pattern) > 0 THEN
    RAISE WARNING 'TRUNCATING journey_pattern.scheduled_stop_point_in_journey_pattern to ensure data consistency';
    TRUNCATE journey_pattern.scheduled_stop_point_in_journey_pattern CASCADE;
  END IF;

  RETURN NULL;
END;
$$;
COMMENT ON FUNCTION journey_pattern.truncate_scheduled_stop_point_in_journey_pattern()
  IS '''Truncate the scheduled_stop_point_in_journey_pattern if it contains any rows. It must not be truncated if it
  does not contain data to prevent errors if it was truncated ("touched") within the same transaction.''';


-- create the statement level triggers to enqueue the changed journey patterns / routes for later verification

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

CREATE TRIGGER queue_verify_infra_link_stop_refs_on_jp_update_trigger
  AFTER UPDATE
  ON journey_pattern.journey_pattern
  REFERENCING NEW TABLE AS new_table
  FOR EACH STATEMENT
EXECUTE PROCEDURE journey_pattern.queue_verify_infra_link_stop_refs_by_new_journey_pattern_id();

-- create the trigger to truncate the scheduled_stop_point_in_journey_pattern table when infrastructure_link_along_route
-- is truncated

CREATE TRIGGER truncate_sspijp_on_ilar_truncate_trigger
  AFTER TRUNCATE
  ON route.infrastructure_link_along_route
  FOR EACH STATEMENT
EXECUTE PROCEDURE journey_pattern.truncate_scheduled_stop_point_in_journey_pattern();


-- create the constraint triggers to perform the verification of the queued changed journey patterns / routes

CREATE FUNCTION journey_pattern.infra_link_stop_refs_already_verified()
  RETURNS BOOLEAN
  LANGUAGE plpgsql
  VOLATILE AS
$$
DECLARE
  infra_link_stop_refs_already_verified BOOLEAN;
BEGIN
  infra_link_stop_refs_already_verified :=
    NULLIF(current_setting('journey_pattern_vars.infra_link_stop_refs_already_verified', TRUE), '');
  IF infra_link_stop_refs_already_verified IS TRUE THEN
    RETURN TRUE;
  ELSE
    SET LOCAL journey_pattern_vars.infra_link_stop_refs_already_verified = TRUE;
    RETURN FALSE;
  END IF;
END
$$;
COMMENT ON FUNCTION journey_pattern.infra_link_stop_refs_already_verified()
  IS 'Keep track of whether the infra link <-> stop ref verification has already been performed in this transaction';

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
  AFTER INSERT OR UPDATE
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
     - which is traversed in the wrong direction compared to the stop''s allowed directions';

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
