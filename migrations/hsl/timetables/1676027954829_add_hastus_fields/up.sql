ALTER TABLE vehicle_journey.vehicle_journey
  ADD COLUMN displayed_label text,
  ADD COLUMN is_vehicle_type_mandatory boolean NOT NULL DEFAULT false,
  ADD COLUMN is_backup_journey boolean NOT NULL DEFAULT false,
  ADD COLUMN is_extra_journey boolean NOT NULL DEFAULT false;

COMMENT ON COLUMN vehicle_journey.vehicle_journey.displayed_label IS 'Displayed name of the journey.';
COMMENT ON COLUMN vehicle_journey.vehicle_journey.is_vehicle_type_mandatory IS 'It is required to use the same vehicle type as required in vehicle service.';
COMMENT ON COLUMN vehicle_journey.vehicle_journey.is_backup_journey IS 'Is the journey a backup journey.';
COMMENT ON COLUMN vehicle_journey.vehicle_journey.is_extra_journey IS 'Is the journey an extra journey.';

ALTER TABLE vehicle_schedule.vehicle_schedule_frame
  ADD COLUMN booking_label text;

COMMENT ON COLUMN vehicle_schedule.vehicle_schedule_frame.booking_label IS 'Booking label for the vehicle schedule frame. Comes from BookingRecord vsc_booking field from Hastus.';

ALTER TABLE reusable_components.vehicle_type
  ADD COLUMN hsl_id smallint;

COMMENT ON COLUMN reusable_components.vehicle_type.hsl_id is 'ID used in Hastus to represent the vehicle type.';
