CREATE INDEX idx_vehicle_service_day_type ON vehicle_service.vehicle_service USING btree (day_type_id);
CREATE INDEX idx_vehicle_service_vehicle_schedule_frame ON vehicle_service.vehicle_service USING btree (vehicle_schedule_frame_id);
CREATE INDEX idx_block_vehicle_service ON vehicle_service.block USING btree (vehicle_service_id);
CREATE INDEX idx_vehicle_journey_block ON vehicle_journey.vehicle_journey USING btree (block_id);
CREATE INDEX idx_vehicle_journey_journey_pattern_ref ON vehicle_journey.vehicle_journey USING btree (journey_pattern_ref_id);
CREATE INDEX idx_timetabled_passing_time_sspijp_ref ON passing_times.timetabled_passing_time USING btree (scheduled_stop_point_in_journey_pattern_ref_id);
CREATE INDEX idx_timetabled_passing_time_vehicle_journey ON passing_times.timetabled_passing_time USING btree (vehicle_journey_id);
