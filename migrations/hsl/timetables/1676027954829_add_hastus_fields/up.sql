ALTER TABLE vehicle_journey.vehicle_journey
  ADD COLUMN journey_type text,
  ADD COLUMN displayed_name text,
  ADD COLUMN lay_start_time interval,
  ADD COLUMN lay_end_time interval,
  ADD COLUMN is_vehicle_type_mandatory boolean,
  ADD COLUMN is_backup_journey boolean,
  ADD COLUMN is_extra_journey boolean;

COMMENT ON COLUMN vehicle_journey.vehicle_journey.journey_type IS 'STANDARD | PULL_OUT | PULL_IN | TRANSFER';
COMMENT ON COLUMN vehicle_journey.vehicle_journey.displayed_name IS 'Displayed name of the journey.';
COMMENT ON COLUMN vehicle_journey.vehicle_journey.lay_start_time IS 'Terminal time.';
COMMENT ON COLUMN vehicle_journey.vehicle_journey.lay_end_time IS 'Recovery time';
COMMENT ON COLUMN vehicle_journey.vehicle_journey.is_vehicle_type_mandatory IS 'It is required to use the same vehicle type as required in vehicle service.';
COMMENT ON COLUMN vehicle_journey.vehicle_journey.is_backup_journey IS 'Is the journey a backup journey.';
COMMENT ON COLUMN vehicle_journey.vehicle_journey.is_extra_journey IS 'Is the journey an extra journey.';


ALTER TABLE vehicle_schedule.vehicle_schedule_frame
  ADD COLUMN booking_label text,
  RENAME COLUMN name_i18n TO booking_description_i18n,
  ADD COLUMN label text;

COMMENT ON COLUMN vehicle_schedule.vehicle_schedule_frame.booking_label IS 'Comes from BookingRecord vsc_booking field from Hastus.';
COMMENT ON COLUMN vehicle_schedule.vehicle_schedule_frame.booking_description_i18n IS 'Comes from BookingRecord vsc_booking_desc field from Hastus.';
COMMENT ON COLUMN vehicle_schedule.vehicle_schedule_frame.label IS 'Comes from BookingRecord vsc_name field from Hastus.';
