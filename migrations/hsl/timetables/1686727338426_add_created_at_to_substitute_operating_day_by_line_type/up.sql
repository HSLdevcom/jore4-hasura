ALTER TABLE service_calendar.substitute_operating_day_by_line_type
  ADD COLUMN created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW();
