
CREATE TABLE return_value.timetable_version (
  vehicle_schedule_frame_id uuid REFERENCES vehicle_schedule.vehicle_schedule_frame(vehicle_schedule_frame_id) NULL,
  substitute_operating_day_by_line_type_id uuid REFERENCES service_calendar.substitute_operating_day_by_line_type(substitute_operating_day_by_line_type_id) NULL,
  validity_start date NOT NULL,
  validity_end date NOT NULL,
  priority integer NOT NULL,
  in_effect boolean NOT NULL,
  day_type_id uuid REFERENCES service_calendar.day_type(day_type_id) NOT NULL
);

COMMENT ON TABLE return_value.timetable_version 
IS 'This return value is used for functions that determine what timetable versions are in effect.';
