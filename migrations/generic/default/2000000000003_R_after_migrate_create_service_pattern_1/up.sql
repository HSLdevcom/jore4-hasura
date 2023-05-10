CREATE OR REPLACE VIEW service_pattern.scheduled_stop_points_with_infra_link_data AS (
  SELECT ssp.scheduled_stop_point_id,
         ssp.measured_location,
         ssp.located_on_infrastructure_link_id,
         ssp.direction,
         ssp.label,
         ssp.validity_start,
         ssp.validity_end,
         ssp.priority,
         internal_utils.st_linelocatepoint(il.shape, ssp.measured_location) AS relative_distance_from_infrastructure_link_start
  FROM service_pattern.scheduled_stop_point ssp
  JOIN infrastructure_network.infrastructure_link il ON ssp.located_on_infrastructure_link_id = il.infrastructure_link_id
);
COMMENT ON VIEW service_pattern.scheduled_stop_points_with_infra_link_data
IS 'Contains scheduled_stop_points enriched with some infra link data.';

CREATE OR REPLACE FUNCTION service_pattern.new_scheduled_stop_point_if_id_given(
  new_scheduled_stop_point_id uuid DEFAULT NULL::uuid,
  new_located_on_infrastructure_link_id uuid DEFAULT NULL::uuid,
  new_measured_location public.geography DEFAULT NULL::public.geography,
  new_direction text DEFAULT NULL::text,
  new_label text DEFAULT NULL::text,
  new_validity_start date DEFAULT NULL::date,
  new_validity_end date DEFAULT NULL::date,
  new_priority integer DEFAULT NULL::integer
)
RETURNS TABLE(
  scheduled_stop_point_id uuid,
  measured_location public.geography,
  located_on_infrastructure_link_id uuid,
  direction text,
  label text,
  validity_start date,
  validity_end date,
  priority integer,
  relative_distance_from_infrastructure_link_start double precision
)
  LANGUAGE sql STABLE
AS $$
  SELECT new_scheduled_stop_point_id,
         new_measured_location::geography(PointZ, 4326),
         new_located_on_infrastructure_link_id,
         new_direction,
         new_label,
         new_validity_start,
         new_validity_end,
         new_priority,
         internal_utils.st_linelocatepoint(il.shape, new_measured_location) AS relative_distance_from_infrastructure_link_start
  FROM infrastructure_network.infrastructure_link il
  WHERE new_scheduled_stop_point_id IS NOT NULL
  AND new_located_on_infrastructure_link_id = il.infrastructure_link_id;
$$;
COMMENT ON FUNCTION service_pattern.new_scheduled_stop_point_if_id_given(new_scheduled_stop_point_id uuid, new_located_on_infrastructure_link_id uuid, new_measured_location public.geography, new_direction text, new_label text, new_validity_start date, new_validity_end date, new_priority integer)
IS 'Conditionally returns a row representing a new scheduled_stop_point, or nothing.
  Intended to be used in conjunction with service_pattern.scheduled_stop_points_with_infra_link_data view.
  If value for new_scheduled_stop_point_id parameter is given,
  returns a row representing that scheduled_stop_point.
  The structure matches the service_pattern.scheduled_stop_points_with_infra_link_data view.
  In case new_scheduled_stop_point_id is null, returns nothing.
';
