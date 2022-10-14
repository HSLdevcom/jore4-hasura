-------------------- Service Pattern --------------------

ALTER TABLE service_pattern.scheduled_stop_point
  DROP COLUMN timing_point_id;

-------------------- Timing Pattern --------------------

DROP TABLE timing_pattern.timing_point;
DROP SCHEMA timing_pattern;
