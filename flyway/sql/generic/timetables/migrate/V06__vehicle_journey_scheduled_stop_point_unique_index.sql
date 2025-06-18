-- The unique index makes sure that every stop in the journey pattern sequence can be used only once.
-- This however does not affect loops as those are separate rows within the journey pattern.
CREATE UNIQUE INDEX timetabled_passing_time_stop_point_unique_idx
ON passing_times.timetabled_passing_time USING btree (vehicle_journey_id, scheduled_stop_point_in_journey_pattern_ref_id);
-- The (vehicle_journey_id, scheduled_stop_point_in_journey_pattern_ref_id) UNIQUE index
-- already covers this (vehicle_journey_id) part,
-- no need for two separate indexes.
DROP INDEX passing_times.idx_timetabled_passing_time_vehicle_journey;
