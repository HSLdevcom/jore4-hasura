ALTER TABLE vehicle_journey.vehicle_journey
  DROP COLUMN displayed_name,
  DROP COLUMN is_vehicle_type_mandatory,
  DROP COLUMN is_backup_journey,
  DROP COLUMN is_extra_journey;

ALTER TABLE vehicle_schedule.vehicle_schedule_frame
  DROP COLUMN booking_label,
  DROP COLUMN booking_description_i18n;

ALTER TABLE vehicle_type.vehicle_type
  DROP COLUMN hsl_id;
