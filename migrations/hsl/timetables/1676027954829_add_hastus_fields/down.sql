ALTER TABLE vehicle_journey.vehicle_journey
  DROP COLUMN displayed_label,
  DROP COLUMN is_vehicle_type_mandatory,
  DROP COLUMN is_backup_journey,
  DROP COLUMN is_extra_journey;

ALTER TABLE vehicle_schedule.vehicle_schedule_frame
  DROP COLUMN booking_label;

ALTER TABLE reusable_components.vehicle_type
  DROP COLUMN hsl_id;
