CREATE TABLE return_value.frames_replaced_by_staging_timetables (
  staging_vehicle_schedule_frame_id uuid REFERENCES vehicle_schedule.vehicle_schedule_frame(vehicle_schedule_frame_id) NOT NULL,
  replaced_vehicle_schedule_frame_id uuid REFERENCES vehicle_schedule.vehicle_schedule_frame(vehicle_schedule_frame_id) NOT NULL,
  journey_pattern_id uuid NOT NULL,
  active_on_day_of_week integer NOT NULL,
  priority integer NOT NULL,
  staging_validity_range daterange NOT NULL,
  replaced_validity_range daterange NOT NULL,
  validity_intersection daterange NOT NULL
);
COMMENT ON TABLE return_value.frames_replaced_by_staging_timetables
IS 'The return value for vehicle_schedule.get_frames_replaced_by_staging_timetables.';
