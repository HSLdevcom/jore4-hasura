drop index infrastructure_network.idx_infrastructure_link_direction;
  
drop index infrastructure_network.idx_infrastructure_link_external_link_source_fkey;

drop index route.idx_route_direction;

drop index route.idx_route_on_line_id;

drop index route.idx_direction_the_opposite_of_direction;
   
drop index route.idx_line_primary_vehicle_mode;

drop index route.idx_line_type_of_line;

drop index internal_service_pattern.idx_scheduled_stop_point_direction;

drop index hdb_catalog.idx_hdb_catalog_hdb_scheduled_event_invocation_logs;