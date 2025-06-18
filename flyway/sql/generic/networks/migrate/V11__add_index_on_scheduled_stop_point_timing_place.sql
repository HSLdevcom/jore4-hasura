CREATE INDEX idx_scheduled_stop_point_timing_place
  ON service_pattern.scheduled_stop_point USING btree (timing_place_id);
