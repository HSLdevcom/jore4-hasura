create index idx_infrastructure_link_direction on
  infrastructure_network.infrastructure_link (direction);
  
create index idx_infrastructure_link_external_link_source_fkey on
  infrastructure_network.infrastructure_link (external_link_source);

create index idx_route_direction on
  route.route (direction);

create index idx_route_on_line_id on
  route.route (on_line_id);

create index idx_direction_the_opposite_of_direction on
  route.direction (the_opposite_of_direction);
   
create index idx_line_primary_vehicle_mode on
  route.line (primary_vehicle_mode);

create index idx_line_type_of_line on
  route.line (type_of_line);

create index idx_scheduled_stop_point_direction on
  internal_service_pattern.scheduled_stop_point (direction);

create index idx_hdb_catalog_hdb_scheduled_event_invocation_logs on
  hdb_catalog.hdb_scheduled_event_invocation_logs (event_id);