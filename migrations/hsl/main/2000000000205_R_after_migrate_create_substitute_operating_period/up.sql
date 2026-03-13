ALTER TABLE timetables.substitute_operating_period
  ADD CONSTRAINT substitute_operating_period_period_name_key UNIQUE (period_name);
