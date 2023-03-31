ALTER TABLE service_pattern.scheduled_stop_point
  ADD CONSTRAINT service_pattern_scheduled_stop_point_external_id_range_check CHECK (external_id BETWEEN 1 AND 9999999);
