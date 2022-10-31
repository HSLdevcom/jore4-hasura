DROP TRIGGER verify_infra_link_stop_refs_on_scheduled_stop_point_trigger
  ON internal_service_pattern.scheduled_stop_point;

DROP FUNCTION journey_pattern.verify_infra_link_stop_refs_by_new_scheduled_stop_point_label();

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


DROP FUNCTION journey_pattern.check_infra_link_stop_refs_with_new_scheduled_stop_point(
  replace_scheduled_stop_point_id uuid,
  new_located_on_infrastructure_link_id uuid,
  new_measured_location GEOGRAPHY(POINTZ, 4326),
  new_direction text,
  new_label text,
  new_validity_start timestamp with time zone,
  new_validity_end timestamp with time zone
);

DROP FUNCTION journey_pattern.verify_route_journey_pattern_refs(uuid, uuid);

DROP FUNCTION journey_pattern.check_route_journey_pattern_refs(
  filter_journey_pattern_id uuid,
  filter_route_id uuid,
  replace_scheduled_stop_point_id uuid,
  new_located_on_infrastructure_link_id uuid,
  new_measured_location GEOGRAPHY(POINTZ, 4326),
  new_direction text,
  new_label text,
  new_validity_start timestamp with time zone,
  new_validity_end timestamp with time zone
);

DROP FUNCTION internal_service_pattern.get_scheduled_stop_points_with_new(
  replace_scheduled_stop_point_id uuid,
  new_scheduled_stop_point_id uuid,
  new_located_on_infrastructure_link_id uuid,
  new_measured_location GEOGRAPHY(POINTZ, 4326),
  new_direction text,
  new_label text,
  new_validity_start timestamp with time zone,
  new_validity_end timestamp with time zone
);

ALTER FUNCTION deleted.verify_route_journey_pattern_refs_1649661919181(uuid, uuid)
  SET SCHEMA journey_pattern;

ALTER FUNCTION journey_pattern.verify_route_journey_pattern_refs_1649661919181(uuid, uuid)
  RENAME TO verify_route_journey_pattern_refs;
