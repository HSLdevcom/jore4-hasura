ALTER TABLE journey_pattern.scheduled_stop_point_in_journey_pattern
  RENAME COLUMN is_used_as_timing_point TO is_timing_point;

ALTER TABLE journey_pattern.scheduled_stop_point_in_journey_pattern
  DROP COLUMN is_loading_time_allowed;

COMMENT ON COLUMN journey_pattern.scheduled_stop_point_in_journey_pattern.is_timing_point IS 'Is this scheduled stop point a timing point?';
