ALTER TABLE vehicle_schedule.vehicle_schedule_frame
  ALTER COLUMN validity_start DROP NOT NULL,
  ALTER COLUMN validity_end DROP NOT NULL;
