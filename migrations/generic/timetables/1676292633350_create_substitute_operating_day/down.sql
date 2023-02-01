-------------------- Service Calendar --------------------

DROP TABLE service_calendar.substitute_operating_day;

-------------------- Journey Pattern --------------------

ALTER TABLE ONLY journey_pattern.journey_pattern_ref DROP COLUMN line_ref_id;

-------------------- Line --------------------

DROP TABLE route.line_ref;
DROP TABLE route.type_of_line;
