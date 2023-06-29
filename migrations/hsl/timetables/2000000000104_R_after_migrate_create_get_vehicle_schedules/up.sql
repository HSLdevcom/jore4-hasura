CREATE OR REPLACE FUNCTION vehicle_journey.get_vehicle_schedules_on_date(journey_pattern_uuid uuid, observation_date date)
  RETURNS SETOF return_value.vehicle_schedule
  LANGUAGE SQL
  STABLE
AS $$
WITH substitute_operating_day_by_line_type_vehicle_schedules AS
(
  SELECT DISTINCT vj.vehicle_journey_id,
    vsf.validity_start,
    vsf.validity_end,
    internal_utils.const_timetables_priority_substitute_by_line_type(), -- priority
    ( -- calculate what is the correct day type id for the superseded date
      SELECT day_type_id
      FROM service_calendar.get_active_day_types_for_date(sodblt.superseded_date) dt
        JOIN  service_calendar.day_type_active_on_day_of_week dtaodow USING(day_type_id)
      GROUP BY day_type_id
      HAVING count(label) = 1
    ),
    NULL::uuid, -- vehicle_schedule_frame_id
    sodblt.substitute_operating_day_by_line_type_id,
    sodblt.created_at
  FROM service_calendar.substitute_operating_day_by_line_type sodblt
    JOIN journey_pattern.journey_pattern_ref jpr USING(type_of_line)
    JOIN vehicle_journey.vehicle_journey vj USING(journey_pattern_ref_id)
    JOIN vehicle_service.block b USING (block_id)
    JOIN vehicle_service.vehicle_service vs USING (vehicle_service_id)
    JOIN vehicle_schedule.vehicle_schedule_frame vsf USING (vehicle_schedule_frame_id)
    JOIN service_calendar.day_type_active_on_day_of_week dtaodow USING (day_type_id)
  WHERE jpr.journey_pattern_id = journey_pattern_uuid
    AND sodblt.superseded_date BETWEEN vsf.validity_start AND vsf.validity_end
    AND sodblt.substitute_day_of_week = dtaodow.day_of_week
    AND sodblt.superseded_date = observation_date
    AND vsf.priority != internal_utils.const_timetables_priority_staging()
    AND vsf.priority != internal_utils.const_timetables_priority_draft()
    AND (sodblt.begin_time IS NULL OR vehicle_journey.vehicle_journey_start_time(vj)::INTERVAL >= sodblt.begin_time)
    AND (sodblt.end_time IS NULL OR vehicle_journey.vehicle_journey_start_time(vj)::INTERVAL < sodblt.end_time)
),
vehicle_schedules AS
(
  SELECT DISTINCT vj.vehicle_journey_id,
    vsf.validity_start,
    vsf.validity_end,
    vsf.priority,
    dt.day_type_id,
    vsf.vehicle_schedule_frame_id,
    NULL:: uuid, -- substitute_operating_day_by_line_type_id
    vsf.created_at
  FROM vehicle_schedule.vehicle_schedule_frame vsf
    JOIN vehicle_service.vehicle_service vs USING (vehicle_schedule_frame_id)
    JOIN service_calendar.day_type dt USING(day_type_id)
    JOIN vehicle_service.block b USING(vehicle_service_id)
    JOIN vehicle_journey.vehicle_journey vj USING(block_id)
    JOIN journey_pattern.journey_pattern_ref jpr USING (journey_pattern_ref_id)
  WHERE jpr.journey_pattern_id = journey_pattern_uuid
    AND vsf.priority != internal_utils.const_timetables_priority_staging()
    AND vsf.priority != internal_utils.const_timetables_priority_draft()
    AND observation_date BETWEEN vsf.validity_start AND vsf.validity_end
  UNION
  -- Get possible vehicle schedules from substitute operating day by line type
  SELECT *
  FROM substitute_operating_day_by_line_type_vehicle_schedules
  UNION
  -- If there is substitute operating day by line type set for observation day
  -- but it yields no vehicle schedules, we return one row without vehicle_journey_id
  -- to indicate that there is no traffic on that day.
  SELECT NULL::uuid, -- vehile_journey_id
    superseded_date,
    superseded_date,
    internal_utils.const_timetables_priority_substitute_by_line_type(), -- priority
    ( -- calculate what is the correct day type id for the superseded date
      SELECT day_type_id
      FROM service_calendar.get_active_day_types_for_date(sodblt.superseded_date) dt
        JOIN  service_calendar.day_type_active_on_day_of_week dtaodow USING(day_type_id)
      GROUP BY day_type_id
      HAVING count(label) = 1
    ),
    NULL::uuid, -- vehicle_schedule_frame_id
    substitute_operating_day_by_line_type_id,
    created_at
  FROM service_calendar.substitute_operating_day_by_line_type sodblt
  WHERE NOT EXISTS
  (
    SELECT * FROM substitute_operating_day_by_line_type_vehicle_schedules
  )
  AND EXISTS
  (
    SELECT 1
    FROM service_calendar.substitute_operating_day_by_line_type sodblt
    JOIN journey_pattern.journey_pattern_ref jpr USING (type_of_line)
    WHERE jpr.journey_pattern_id = journey_pattern_uuid
      AND sodblt.superseded_date = observation_date
  )
)
-- When we have all the vehicle_schedules for the journey_pattern on observation day, we group them
-- by day type and select the highest priority
SELECT *
FROM vehicle_schedules
WHERE (priority, day_type_id) IN (
  SELECT MAX(priority), day_type_id
  FROM vehicle_schedules
  GROUP BY day_type_id
);
$$
;

COMMENT ON FUNCTION vehicle_journey.get_vehicle_schedules_on_date(journey_pattern_uuid uuid, observation_date date)
IS 'Returns all valid highest priority vehicle schedules for a journey pattern on a observation date. Uses return_value.vehicle_schedule as the return value
which is on the vehicle_journey level, but has some enrichted data e.g. priority, validity range etc. This function returns all the vehicle journeys for
vehicle_schedule_frames with the enrichted data, but also calculates the correct vehicle_journeys for substitute_operating_day_by_line_type and leaves out
all the vehicle_journeys that are out of the begin_time, end_time range. If a substitute_operating_day_by_line_type is valid for journey pattern but has
the time range does not return any vehicle journeys (or if the substitute_operating_day_by_line_type substitute_operating_day_of_week is NULL) we return
a row which does not have vehicle_journey set. This is an indicator that the day type does not have operation on the given day. This is of course overruled
by special priority schedules, it being a higher priority.
';
