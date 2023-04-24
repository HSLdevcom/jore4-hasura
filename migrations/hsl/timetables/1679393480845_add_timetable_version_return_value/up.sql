
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
IS 'This return value is used for functions that determine what timetable versions are in effect. In effect will be true for all the timetable version rows that
are valid on given observation day and are the highest priority of that day type. As an example if we have:
Saturday Standard priority valid for 1.1.2023 - 30.6.2023
Saturday Temporary priority valid for 1.5.2023 - 31.5.2023
Saturday Special priority valid for 20.5.2023 - 20.5.2023

If we check the timetable versions for the date 1.2.2023, for Saturday we only get the Standard priority, beacuse it is the only one valid on that time. So that 
row would have in_effect = true. 
If we check the timetable versions for the date 1.5.2023, for Saturday we would get the Standard and the Temporary priority for this date, as they are both valid.
But only the higher priority is in effect on this date. So the Saturday Temporary priority would have in_effect = true, and the Saturday Standard priority would 
have in_effect = false.
If we check the timetable versions for the date 20.5.2023, for Saturday we have all three valid, but only one can be in_effect, and that would be the Special 
priority in this case.
';
