DROP INDEX infrastructure_network.idx_infrastructure_link_direction;
  
DROP INDEX infrastructure_network.idx_infrastructure_link_external_link_source_fkey;

DROP INDEX route.idx_route_direction;

DROP INDEX route.idx_route_on_line_id;

DROP INDEX route.idx_direction_the_opposite_of_direction;
   
DROP INDEX route.idx_line_primary_vehicle_mode;

DROP INDEX route.idx_line_type_of_line;

DROP INDEX internal_service_pattern.idx_scheduled_stop_point_direction;

DROP INDEX hdb_catalog.idx_hdb_catalog_hdb_scheduled_event_invocation_logs;