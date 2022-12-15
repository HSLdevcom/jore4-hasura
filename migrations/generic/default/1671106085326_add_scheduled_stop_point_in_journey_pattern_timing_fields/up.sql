ALTER TABLE journey_pattern.scheduled_stop_point_in_journey_pattern
  RENAME COLUMN is_timing_point TO is_used_as_timing_point;

ALTER TABLE journey_pattern.scheduled_stop_point_in_journey_pattern
  ADD COLUMN is_loading_time_allowed boolean DEFAULT false NOT NULL;

COMMENT ON COLUMN journey_pattern.scheduled_stop_point_in_journey_pattern.is_used_as_timing_point IS 'Is this scheduled stop point used as a timing point in the journey pattern?';
COMMENT ON COLUMN journey_pattern.scheduled_stop_point_in_journey_pattern.is_loading_time_allowed IS 'Is adding loading time to this scheduled stop point in the journey pattern allowed?';
