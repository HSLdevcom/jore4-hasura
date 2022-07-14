
-- undo changes to the check_infra_link_stop_refs_with_new_scheduled_stop_point function

DROP FUNCTION journey_pattern.check_infra_link_stop_refs_with_new_scheduled_stop_point(
  replace_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE,
  new_priority INT
);

ALTER FUNCTION deleted.check_infra_link_stop_refs_with_new_ssp_1657795756608(
  replace_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE
  )
  SET SCHEMA journey_pattern;

ALTER FUNCTION journey_pattern.check_infra_link_stop_refs_with_new_ssp_1657795756608(
  replace_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE
  )
  RENAME TO check_infra_link_stop_refs_with_new_scheduled_stop_point;


-- undo changes to the check_route_journey_pattern_refs function

DROP FUNCTION journey_pattern.check_route_journey_pattern_refs(
  filter_journey_pattern_id uuid,
  filter_route_id uuid,
  replace_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE,
  new_priority INT
);

ALTER FUNCTION deleted.check_route_journey_pattern_refs_1657795756608(
  filter_journey_pattern_id uuid,
  filter_route_id uuid,
  replace_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE
  )
  SET SCHEMA journey_pattern;

ALTER FUNCTION journey_pattern.check_route_journey_pattern_refs_1657795756608(
  filter_journey_pattern_id uuid,
  filter_route_id uuid,
  replace_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE
  )
  RENAME TO check_route_journey_pattern_refs;


-- undo changes to the check_route_journey_pattern_refs function

DROP FUNCTION internal_service_pattern.get_scheduled_stop_points_with_new(
  replace_scheduled_stop_point_id UUID,
  new_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE,
  new_priority INT
);

ALTER FUNCTION deleted.get_scheduled_stop_points_with_new_1657795756608(
  replace_scheduled_stop_point_id UUID,
  new_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE
  )
  SET SCHEMA internal_service_pattern;

ALTER FUNCTION internal_service_pattern.get_scheduled_stop_points_with_new_1657795756608(
  replace_scheduled_stop_point_id UUID,
  new_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE
  )
  RENAME TO get_scheduled_stop_points_with_new;
