
CREATE TABLE return_value.vehicle_schedule (
  vehicle_journey_id uuid REFERENCES vehicle_journey.vehicle_journey(vehicle_journey_id) NOT NULL,
  validity_start date NOT NULL,
  validity_end date NOT NULL,
  priority integer NOT NULL,
  day_type_id uuid REFERENCES service_calendar.day_type(day_type_id) NOT NULL,
  vehicle_schedule_frame_id uuid REFERENCES vehicle_schedule.vehicle_schedule_frame(vehicle_schedule_frame_id),
  substitute_operating_day_by_line_type_id uuid REFERENCES service_calendar.substitute_operating_day_by_line_type(substitute_operating_day_by_line_type_id),
  created_at timestamp with time zone
);

COMMENT ON TABLE return_value.vehicle_schedule
IS 'This return value table is used in function vehicle_journey.get_vehicle_schedules_on_date. It consists of vehicle_journey_id, vehicle_schedule_frame_id or
substitute_operating_day_by_line_type_id and also enrichted with data, which are used in the UI side.'
