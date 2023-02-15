ALTER TABLE vehicle_journey.vehicle_journey
  DROP COLUMN journey_type,
  DROP COLUMN displayed_name,
  DROP COLUMN lay_start_time_minutes,
  DROP COLUMN lay_end_time_minutes,
  DROP COLUMN is_vehicle_type_mandatory,
  DROP COLUMN backup_journey,
  DROP COLUMN extra_journey;

ALTER TABLE vehicle_schedule.vehicle_schedule_frame
  DROP COLUMN booking_label,
  RENAME COLUMN booking_description_i18n TO name_i18n,
  DROP COLUMN timetable_name;
