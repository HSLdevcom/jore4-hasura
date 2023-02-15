ALTER TABLE vehicle_journey.vehicle_journey
  DROP COLUMN journey_type,
  DROP COLUMN displayed_name,
  DROP COLUMN lay_start_time,
  DROP COLUMN lay_end_time,
  DROP COLUMN is_vehicle_type_mandatory,
  DROP COLUMN is_backup_journey,
  DROP COLUMN is_extra_journey;

ALTER TABLE vehicle_schedule.vehicle_schedule_frame
  DROP COLUMN booking_label,
  RENAME COLUMN booking_description_i18n TO name_i18n,
  DROP COLUMN label;
