ALTER TABLE journey_pattern.scheduled_stop_point_in_journey_pattern
  ADD COLUMN is_regulated_timing_point boolean DEFAULT false NOT NULL;

COMMENT ON COLUMN journey_pattern.scheduled_stop_point_in_journey_pattern.is_regulated_timing_point IS 'Is this stop point passing time regulated so that it cannot be passed before scheduled time?';
