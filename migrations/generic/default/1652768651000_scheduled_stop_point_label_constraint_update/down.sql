
DROP TRIGGER verify_infra_link_stop_refs_on_scheduled_stop_point_trigger
  ON internal_service_pattern.scheduled_stop_point;

DROP FUNCTION journey_pattern.verify_infra_link_stop_refs_by_new_scheduled_stop_point_id();

ALTER FUNCTION deleted.verify_infra_link_stop_refs_by_new_ssp_1649847021000()
  SET SCHEMA journey_pattern;

ALTER FUNCTION journey_pattern.verify_infra_link_stop_refs_by_new_ssp_1649847021000()
  RENAME TO verify_infra_link_stop_refs_by_new_scheduled_stop_point_id;

CREATE CONSTRAINT TRIGGER verify_infra_link_stop_refs_on_scheduled_stop_point_trigger
  AFTER UPDATE
  ON internal_service_pattern.scheduled_stop_point
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
EXECUTE PROCEDURE journey_pattern.verify_infra_link_stop_refs_by_new_scheduled_stop_point_id();


DROP FUNCTION journey_pattern.verify_route_journey_pattern_refs(uuid, uuid);

ALTER FUNCTION deleted.verify_route_journey_pattern_refs_1649661919181(uuid, uuid)
  SET SCHEMA journey_pattern;

ALTER FUNCTION journey_pattern.verify_route_journey_pattern_refs_1649661919181(uuid, uuid)
  RENAME TO verify_route_journey_pattern_refs;
