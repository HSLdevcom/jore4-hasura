ALTER TABLE passing_times.timetabled_passing_time
  ADD CONSTRAINT arrival_or_departure_time_exists CHECK (arrival_time IS NOT NULL OR departure_time IS NOT NULL);
