ALTER TABLE service_calendar.substitute_operating_day_by_line_type DROP CONSTRAINT substitute_operating_day_by_line_type_unique_dow;
ALTER TABLE service_calendar.substitute_operating_day_by_line_type DROP CONSTRAINT substitute_operating_day_by_line_type_no_timespan_overlap;
ALTER TABLE service_calendar.substitute_operating_day_by_line_type DROP CONSTRAINT substitute_operating_day_by_line_type_valid_end_time;
ALTER TABLE service_calendar.substitute_operating_day_by_line_type DROP CONSTRAINT substitute_operating_day_by_line_type_valid_begin_time;
ALTER TABLE service_calendar.substitute_operating_day_by_line_type DROP CONSTRAINT substitute_operating_day_by_line_type_valid_dow;