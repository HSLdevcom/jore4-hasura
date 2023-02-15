ALTER TABLE vehicle_journey.vehicle_journey
  ADD COLUMN displayed_label text DEFAULT NULL,
  ADD COLUMN is_vehicle_type_mandatory boolean NOT NULL DEFAULT false,
  ADD COLUMN is_backup_journey boolean NOT NULL DEFAULT false,
  ADD COLUMN is_extra_journey boolean NOT NULL DEFAULT false;

COMMENT ON COLUMN vehicle_journey.vehicle_journey.displayed_label IS 'Displayed name of the journey.';
COMMENT ON COLUMN vehicle_journey.vehicle_journey.is_vehicle_type_mandatory IS 'It is required to use the same vehicle type as required in vehicle service.';
COMMENT ON COLUMN vehicle_journey.vehicle_journey.is_backup_journey IS 'Is the journey a backup journey.';
COMMENT ON COLUMN vehicle_journey.vehicle_journey.is_extra_journey IS 'Is the journey an extra journey.';

ALTER TABLE vehicle_schedule.vehicle_schedule_frame
  ADD COLUMN booking_label text DEFAULT '', -- add default value to avoid migration failure if there are existing rows
  ADD COLUMN booking_description_i18n jsonb NULL;
-- Populate booking_label field with the existing value from name_i18n
UPDATE vehicle_schedule.vehicle_schedule_frame SET booking_label = name_i18n->'fi_FI';
-- add NOT NULL constraint to make this field required in all new rows
ALTER TABLE vehicle_schedule.vehicle_schedule_frame
  ALTER COLUMN booking_label SET NOT NULL;
COMMENT ON COLUMN vehicle_schedule.vehicle_schedule_frame.booking_label IS 'Booking label for the vehicle schedule frame. Comes from BookingRecord vsc_booking field from Hastus.';
COMMENT ON COLUMN vehicle_schedule.vehicle_schedule_frame.booking_description_i18n IS 'Booking description for the vehicle schedule frame. Comes from BookingRecord vsc_booking_desc field from Hastus.';

ALTER TABLE reusable_components.vehicle_type
  ADD COLUMN hsl_id smallint;

COMMENT ON COLUMN reusable_components.vehicle_type.hsl_id is 'ID used in Hastus to represent the vehicle type.';
