-- NOTE: it would make more sense to return `interval` instead of `text`, but
-- hasura won't let save those as computed fields:
-- "Inconsistent object: in table "vehicle_journey.vehicle_journey": in computed field "start_time": the computed field "start_time" cannot be added to table "vehicle_journey.vehicle_journey" because the function "vehicle_journey.vehicle_journey_start_time" returning type interval is not a BASE type"

CREATE FUNCTION vehicle_journey.vehicle_journey_start_time(vj vehicle_journey.vehicle_journey)
RETURNS text AS $$
  SELECT MIN (departure_time)::text AS start_time
  FROM passing_times.timetabled_passing_time tpt
  WHERE tpt.vehicle_journey_id = vj.vehicle_journey_id;
$$ LANGUAGE sql STABLE;

CREATE FUNCTION vehicle_journey.vehicle_journey_end_time(vj vehicle_journey.vehicle_journey)
RETURNS text AS $$
  SELECT MAX (arrival_time)::text AS end_time
  FROM passing_times.timetabled_passing_time tpt
  WHERE tpt.vehicle_journey_id = vj.vehicle_journey_id;
$$ LANGUAGE sql STABLE;
