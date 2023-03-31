ALTER TABLE service_pattern.scheduled_stop_point
  ADD CONSTRAINT service_pattern_scheduled_stop_point_numeric_id_range_check CHECK (numeric_id BETWEEN 1 AND 9999999);
