CREATE INDEX idx_infrastructure_link_direction ON
  infrastructure_network.infrastructure_link (direction);
  
CREATE INDEX idx_infrastructure_link_external_link_source_fkey ON
  infrastructure_network.infrastructure_link (external_link_source);

CREATE INDEX idx_route_direction ON
  route.route (direction);

CREATE INDEX idx_route_on_line_id ON
  route.route (on_line_id);

CREATE INDEX idx_direction_the_opposite_of_direction ON
  route.direction (the_opposite_of_direction);
   
CREATE INDEX idx_line_primary_vehicle_mode ON
  route.line (primary_vehicle_mode);

CREATE INDEX idx_line_type_of_line ON
  route.line (type_of_line);

CREATE INDEX idx_scheduled_stop_point_direction ON
  internal_service_pattern.scheduled_stop_point (direction);

CREATE INDEX idx_hdb_catalog_hdb_scheduled_event_invocation_logs ON
  hdb_catalog.hdb_scheduled_event_invocation_logs (event_id);