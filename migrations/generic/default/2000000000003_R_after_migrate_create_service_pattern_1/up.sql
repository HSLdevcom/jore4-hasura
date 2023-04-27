CREATE OR REPLACE FUNCTION service_pattern.get_scheduled_stop_points_with_new(
  replace_scheduled_stop_point_id uuid DEFAULT NULL::uuid,
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
  relative_distance_from_infrastructure_link_start double precision,
  closest_point_on_infrastructure_link public.geography
)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  IF new_scheduled_stop_point_id IS NULL THEN
    RETURN QUERY
      SELECT ssp.scheduled_stop_point_id,
             ssp.measured_location,
             ssp.located_on_infrastructure_link_id,
             ssp.direction,
             ssp.label,
             ssp.validity_start,
             ssp.validity_end,
             ssp.priority,
             internal_utils.st_linelocatepoint(il.shape, ssp.measured_location) AS relative_distance_from_infrastructure_link_start,
             internal_utils.st_closestpoint(il.shape, ssp.measured_location) AS closest_point_on_infrastructure_link
      FROM service_pattern.scheduled_stop_point ssp
        JOIN infrastructure_network.infrastructure_link il ON ssp.located_on_infrastructure_link_id = il.infrastructure_link_id
      WHERE replace_scheduled_stop_point_id IS NULL
         OR ssp.scheduled_stop_point_id != replace_scheduled_stop_point_id;
  ELSE
    RETURN QUERY
      SELECT ssp.scheduled_stop_point_id,
             ssp.measured_location,
             ssp.located_on_infrastructure_link_id,
             ssp.direction,
             ssp.label,
             ssp.validity_start,
             ssp.validity_end,
             ssp.priority,
             internal_utils.st_linelocatepoint(il.shape, ssp.measured_location) AS relative_distance_from_infrastructure_link_start,
             internal_utils.st_closestpoint(il.shape, ssp.measured_location) AS closest_point_on_infrastructure_link
      FROM service_pattern.scheduled_stop_point ssp
        JOIN infrastructure_network.infrastructure_link il ON ssp.located_on_infrastructure_link_id = il.infrastructure_link_id
      WHERE replace_scheduled_stop_point_id IS NULL
         OR ssp.scheduled_stop_point_id != replace_scheduled_stop_point_id
      UNION ALL
      SELECT new_scheduled_stop_point_id,
             new_measured_location::geography(PointZ, 4326),
             new_located_on_infrastructure_link_id,
             new_direction,
             new_label,
             new_validity_start,
             new_validity_end,
             new_priority,
             internal_utils.st_linelocatepoint(il.shape, new_measured_location) AS relative_distance_from_infrastructure_link_start,
             NULL::geography(PointZ, 4326)                                      AS closest_point_on_infrastructure_link
      FROM infrastructure_network.infrastructure_link il
      WHERE il.infrastructure_link_id = new_located_on_infrastructure_link_id;
  END IF;
END;
$$;
COMMENT ON FUNCTION service_pattern.get_scheduled_stop_points_with_new(replace_scheduled_stop_point_id uuid, new_scheduled_stop_point_id uuid, new_located_on_infrastructure_link_id uuid, new_measured_location public.geography, new_direction text, new_label text, new_validity_start date, new_validity_end date, new_priority integer)
IS 'Returns the scheduled stop points from the service_pattern.scheduled_stop_point table.
    If replace_scheduled_stop_point_id is not null, the stop point with that ID is filtered out.
    Similarly, if the new_xxx arguments are specified, a scheduled stop point with those values is
    appended to the result (it is not inserted into the table).';
