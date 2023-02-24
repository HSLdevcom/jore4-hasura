CREATE UNIQUE INDEX passing_times_timetabled_passing_time_vehicle_journey_id_scheduled_stop_point_in_journey_pattern_ref_id_unique_idx
ON passing_times.timetabled_passing_time USING btree (vehicle_journey_id, scheduled_stop_point_in_journey_pattern_ref_id);
-- The (vehicle_journey_id, scheduled_stop_point_in_journey_pattern_ref_id) UNIQUE index
-- already covers this (vehicle_journey_id) part,
-- no need for two separate indexes.
DROP INDEX passing_times.idx_timetabled_passing_time_vehicle_journey;
