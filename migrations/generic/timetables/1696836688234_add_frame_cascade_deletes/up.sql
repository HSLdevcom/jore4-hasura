ALTER TABLE ONLY vehicle_service.vehicle_service DROP CONSTRAINT vehicle_service_vehicle_schedule_frame_id_fkey;
ALTER TABLE ONLY vehicle_service.vehicle_service ADD CONSTRAINT vehicle_service_vehicle_schedule_frame_id_fkey
FOREIGN KEY (vehicle_schedule_frame_id) REFERENCES vehicle_schedule.vehicle_schedule_frame(vehicle_schedule_frame_id) ON DELETE CASCADE;

ALTER TABLE ONLY vehicle_service.block DROP CONSTRAINT block_vehicle_service_id_fkey;
ALTER TABLE ONLY vehicle_service.block ADD CONSTRAINT block_vehicle_service_id_fkey
FOREIGN KEY (vehicle_service_id) REFERENCES vehicle_service.vehicle_service(vehicle_service_id) ON DELETE CASCADE;

ALTER TABLE ONLY vehicle_journey.vehicle_journey DROP CONSTRAINT vehicle_journey_block_id_fkey;
ALTER TABLE ONLY vehicle_journey.vehicle_journey ADD CONSTRAINT vehicle_journey_block_id_fkey
FOREIGN KEY (block_id) REFERENCES vehicle_service.block(block_id) ON DELETE CASCADE;

ALTER TABLE ONLY passing_times.timetabled_passing_time DROP CONSTRAINT timetabled_passing_time_vehicle_journey_id_fkey;
ALTER TABLE ONLY passing_times.timetabled_passing_time ADD CONSTRAINT timetabled_passing_time_vehicle_journey_id_fkey
FOREIGN KEY (vehicle_journey_id) REFERENCES vehicle_journey.vehicle_journey(vehicle_journey_id) ON DELETE CASCADE;
