ALTER TABLE return_value.timetable_version
  DROP CONSTRAINT timetable_version_day_type_id_fkey;

ALTER TABLE return_value.timetable_version
  DROP CONSTRAINT timetable_version_substitute_operating_day_by_line_type_id_fkey;

ALTER TABLE return_value.timetable_version
  DROP CONSTRAINT timetable_version_vehicle_schedule_frame_id_fkey;