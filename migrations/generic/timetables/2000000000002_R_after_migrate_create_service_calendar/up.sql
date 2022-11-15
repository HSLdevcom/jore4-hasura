ALTER TABLE service_calendar.day_type_active_on_day_of_week
  ADD CONSTRAINT day_type_active_on_day_of_week_day_of_week_check CHECK (day_of_week >= 1 AND day_of_week <= 7);
