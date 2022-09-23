-------------------- Timing Pattern --------------------

DROP TABLE timing_pattern.timing_point;
DROP SCHEMA timing_pattern;

-------------------- Service Pattern --------------------

ALTER TABLE internal_service_pattern.scheduled_stop_point_invariant
  DROP COLUMN timing_point_label;
