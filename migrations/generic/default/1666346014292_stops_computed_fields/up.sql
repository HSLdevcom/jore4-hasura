CREATE FUNCTION service_pattern.scheduled_stop_point_relative_distance_from_infrastructure_link_start(ssp service_pattern.scheduled_stop_point)
RETURNS double precision AS $$
  SELECT
    internal_utils.st_linelocatepoint(il.shape, ssp.measured_location) AS relative_distance_from_infrastructure_link_start
  FROM infrastructure_network.infrastructure_link il
  WHERE ssp.located_on_infrastructure_link_id = il.infrastructure_link_id;
$$ LANGUAGE sql STABLE;

CREATE FUNCTION service_pattern.scheduled_stop_point_closest_point_on_infrastructure_link(ssp service_pattern.scheduled_stop_point)
RETURNS geography AS $$
  SELECT
    internal_utils.st_closestpoint(il.shape, ssp.measured_location) AS closest_point_on_infrastructure_link
  FROM infrastructure_network.infrastructure_link il
  WHERE ssp.located_on_infrastructure_link_id = il.infrastructure_link_id;
$$ LANGUAGE sql STABLE;
