ALTER TABLE service_calendar.day_type_active_on_day_of_week
  ADD CONSTRAINT day_type_active_on_day_of_week_day_of_week_check CHECK (day_of_week >= 1 AND day_of_week <= 7);

CREATE OR REPLACE FUNCTION service_calendar.get_active_day_types_for_date(observation_date date)
  RETURNS SETOF service_calendar.day_type
  LANGUAGE sql STABLE
AS $$
  SELECT dt.*
    FROM service_calendar.day_type dt
    -- in the future, day types might have other filter properties apart from "active on day of week", thus using LEFT JOIN
    LEFT JOIN service_calendar.day_type_active_on_day_of_week dtaodow ON dtaodow.day_type_id = dt.day_type_id
    -- day types active on the same day of week as the observation date
    WHERE extract(isodow FROM observation_date) = dtaodow.day_of_week
$$;
COMMENT ON FUNCTION service_calendar.get_active_day_types_for_date IS 'Finds all the day types that are active on the given observation date.
There might be multiple filter conditions in the future: day of week, day of year, etc.
See: https://www.transmodel-cen.eu/model/index.htm?goto=1:6:3:294 ';
