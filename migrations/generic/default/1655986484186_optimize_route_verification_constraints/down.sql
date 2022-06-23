
-- drop new triggers and functions

DROP TRIGGER queue_verify_infra_link_stop_refs_on_sspijp_insert_trigger
  ON journey_pattern.scheduled_stop_point_in_journey_pattern;
DROP TRIGGER queue_verify_infra_link_stop_refs_on_sspijp_update_trigger
  ON journey_pattern.scheduled_stop_point_in_journey_pattern;

DROP TRIGGER queue_verify_infra_link_stop_refs_on_ilar_update_trigger
  ON route.infrastructure_link_along_route;
DROP TRIGGER queue_verify_infra_link_stop_refs_on_ilar_delete_trigger
  ON route.infrastructure_link_along_route;
DROP TRIGGER truncate_sspijp_on_ilar_truncate_trigger
  ON route.infrastructure_link_along_route;

DROP TRIGGER queue_verify_infra_link_stop_refs_on_ssp_insert_trigger
  ON internal_service_pattern.scheduled_stop_point;
DROP TRIGGER queue_verify_infra_link_stop_refs_on_ssp_update_trigger
  ON internal_service_pattern.scheduled_stop_point;

DROP TRIGGER queue_verify_infra_link_stop_refs_on_jp_update_trigger
  ON journey_pattern.journey_pattern;


DROP TRIGGER verify_infra_link_stop_refs_on_sspijp_trigger
  ON journey_pattern.scheduled_stop_point_in_journey_pattern;

DROP TRIGGER verify_infra_link_stop_refs_on_ilar_trigger
  ON route.infrastructure_link_along_route;

DROP TRIGGER verify_infra_link_stop_refs_on_scheduled_stop_point_trigger
  ON internal_service_pattern.scheduled_stop_point;

DROP TRIGGER verify_infra_link_stop_refs_on_journey_pattern_trigger
  ON journey_pattern.journey_pattern;

DROP FUNCTION journey_pattern.infra_link_stop_refs_already_verified();


DROP FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_ssp_label();
DROP FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_id();
DROP FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_journey_pattern_id();
DROP FUNCTION journey_pattern.truncate_scheduled_stop_point_in_journey_pattern();

DROP FUNCTION journey_pattern.verify_infra_link_stop_refs();

DROP FUNCTION journey_pattern.create_verify_infra_link_stop_refs_queue_temp_table();


-- restore old functions from the "deleted" schema and re-create their triggers

ALTER FUNCTION deleted.verify_infra_link_stop_refs_by_new_ssp_1655986484186()
  SET SCHEMA journey_pattern;

ALTER FUNCTION journey_pattern.verify_infra_link_stop_refs_by_new_ssp_1655986484186()
  RENAME TO verify_infra_link_stop_refs_by_new_scheduled_stop_point_label;


ALTER FUNCTION deleted.verify_infra_link_stop_refs_by_old_route_id_1655986484186()
  SET SCHEMA journey_pattern;

ALTER FUNCTION journey_pattern.verify_infra_link_stop_refs_by_old_route_id_1655986484186()
  RENAME TO verify_infra_link_stop_refs_by_old_route_id;


ALTER FUNCTION deleted.verify_infra_link_stop_refs_by_new_journey_pattern_id_1655986484186()
  SET SCHEMA journey_pattern;

ALTER FUNCTION journey_pattern.verify_infra_link_stop_refs_by_new_journey_pattern_id_1655986484186()
  RENAME TO verify_infra_link_stop_refs_by_new_journey_pattern_id;


CREATE CONSTRAINT TRIGGER verify_infra_link_stop_refs_on_scheduled_stop_point_in_journey_trigger
  AFTER INSERT OR UPDATE
  ON journey_pattern.scheduled_stop_point_in_journey_pattern
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
EXECUTE PROCEDURE journey_pattern.verify_infra_link_stop_refs_by_new_journey_pattern_id();
COMMENT ON
  TRIGGER verify_infra_link_stop_refs_on_scheduled_stop_point_in_journey_trigger
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
