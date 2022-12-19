create schema staging;

create table staging.block ( like vehicle_service.block );
create table staging.passing_times ( like passing_times.timetabled_passing_time );
create table staging.vehicle_schedule_frame ( like vehicle_schedule.vehicle_schedule_frame );
create table staging.vehicle_service ( like vehicle_service.vehicle_service );
create table staging.vehicle_journey ( like vehicle_journey.vehicle_journey );

create unique index staging_block_ref_idx on staging.block (block_id);
create unique index staging_passing_times_ref_idx on staging.passing_times (timetabled_passing_time_id);
create unique index staging_vehicle_journey_ref_idx on staging.vehicle_journey (vehicle_journey_id);
create unique index staging_vehicle_schedule_frame_ref_idx on staging.vehicle_schedule_frame (vehicle_schedule_frame_id);
create unique index staging_vehicle_service_ref_idx on staging.vehicle_service (vehicle_service_id);

alter table staging.block add constraint vehicle_service_fk foreign key (vehicle_service_id) references staging.vehicle_service(vehicle_service_id);
alter table staging.passing_times add constraint vehicle_journey_fk foreign key (vehicle_journey_id) references staging.vehicle_journey(vehicle_journey_id);
alter table staging.passing_times add constraint scheduled_stop_point_in_journey_pattern_fk foreign key (scheduled_stop_point_in_journey_pattern_ref_id) references service_pattern.scheduled_stop_point_in_journey_pattern_ref(scheduled_stop_point_in_journey_pattern_ref_id);
alter table staging.vehicle_journey add constraint block_fk foreign key (block_id) references staging.block(block_id);
alter table staging.vehicle_journey add constraint journey_pattern_ref_fk foreign key (journey_pattern_ref_id) references journey_pattern.journey_pattern_ref(journey_pattern_ref_id);
alter table staging.vehicle_service add constraint day_type_fk foreign key (day_type_id) references service_calendar.day_type(day_type_id);
alter table staging.vehicle_service add constraint vehicle_schedule_frame_fk foreign key (vehicle_schedule_frame_id) references staging.vehicle_schedule_frame(vehicle_schedule_frame_id);
