ALTER TABLE journey_pattern.scheduled_stop_point_in_journey_pattern
  ADD CONSTRAINT ck_is_used_as_timing_point_state CHECK(NOT (is_used_as_timing_point = false AND is_regulated_timing_point = true));

ALTER TABLE journey_pattern.scheduled_stop_point_in_journey_pattern
  ADD CONSTRAINT ck_is_regulated_timing_point_state CHECK(NOT (is_regulated_timing_point = false AND is_loading_time_allowed = true));
