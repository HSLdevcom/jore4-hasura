
DROP FUNCTION journey_pattern.check_infra_link_stop_refs_with_new_scheduled_stop_point;

ALTER FUNCTION deleted.check_infra_link_stop_refs_with_new_ssp_1661150118779 (
  replace_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location GEOGRAPHY(POINTZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE,
  new_priority INT
  )
  SET SCHEMA journey_pattern;

ALTER FUNCTION journey_pattern.check_infra_link_stop_refs_with_new_ssp_1661150118779 (
  replace_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location GEOGRAPHY(POINTZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE,
  new_priority INT
  )
  RENAME TO check_infra_link_stop_refs_with_new_scheduled_stop_point;
