-------------------- Service Calendar --------------------

DROP TABLE service_calendar.substitute_operating_day_by_line_type;

-------------------- Journey Pattern --------------------

ALTER TABLE ONLY journey_pattern.journey_pattern_ref DROP COLUMN type_of_line;

-------------------- Line --------------------

DROP TABLE route.type_of_line;
