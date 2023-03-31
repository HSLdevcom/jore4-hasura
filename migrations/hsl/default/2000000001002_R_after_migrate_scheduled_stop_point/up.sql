ALTER TABLE service_pattern.scheduled_stop_point
  ADD CONSTRAINT service_pattern_scheduled_stop_point_numeric_id_range_check CHECK (1 <= numeric_id AND numeric_id <= 9999999);
