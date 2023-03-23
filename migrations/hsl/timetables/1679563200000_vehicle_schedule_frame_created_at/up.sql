ALTER TABLE vehicle_schedule.vehicle_schedule_frame
  ADD COLUMN created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW();
