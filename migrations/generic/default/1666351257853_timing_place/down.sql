-------------------- Service Pattern --------------------

ALTER TABLE service_pattern.scheduled_stop_point
  DROP COLUMN timing_place_id;

-------------------- Timing Pattern --------------------

DROP TABLE timing_pattern.timing_place;
DROP SCHEMA timing_pattern;
