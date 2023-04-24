CREATE OR REPLACE FUNCTION internal_utils.const_timetables_priority_substitute_by_line_type() RETURNS integer
  LANGUAGE sql IMMUTABLE PARALLEL SAFE
  AS $$SELECT 23$$;

CREATE OR REPLACE FUNCTION internal_utils.const_timetables_priority_special() RETURNS integer
  LANGUAGE sql IMMUTABLE PARALLEL SAFE
  AS $$SELECT 25$$;

CREATE OR REPLACE FUNCTION internal_utils.const_timetables_priority_draft() RETURNS integer
  LANGUAGE sql IMMUTABLE PARALLEL SAFE
  AS $$SELECT 30$$;

CREATE OR REPLACE FUNCTION internal_utils.const_timetables_priority_staging() RETURNS integer
  LANGUAGE sql IMMUTABLE PARALLEL SAFE
  AS $$SELECT 40$$;

CREATE OR REPLACE FUNCTION vehicle_service.get_timetables_and_substitute_operating_days(journey_pattern_ids uuid[], start_date date, end_date date)
  RETURNS SETOF return_value.timetable_version
  LANGUAGE SQL
  STABLE
AS $$
SELECT DISTINCT vsf.vehicle_schedule_frame_id, -- vehicle_schedule_frame_id
  NULL::uuid, -- substitute_operating_day_by_line_type_id is NULL for this type
  vsf.validity_start, -- validity_start
  vsf.validity_end, -- validity_end
  vsf.priority, --priority
  false, -- in_effect default value
  dt.day_type_id -- day_type_id
    FROM vehicle_schedule.vehicle_schedule_frame vsf
      JOIN vehicle_service.vehicle_service vs USING (vehicle_schedule_frame_id)
      JOIN service_calendar.day_type dt USING(day_type_id)
      JOIN vehicle_service.journey_patterns_in_vehicle_service jp_in_vs USING(vehicle_service_id)
    WHERE jp_in_vs.journey_pattern_id = ANY(journey_pattern_ids)
    AND vsf.validity_end >= start_date
    AND vsf.validity_start <= end_date
    AND vsf.priority != internal_utils.const_timetables_priority_staging() -- ignore staging priorities completely, since they are not shown anywhere
union
SELECT DISTINCT
  NULL::uuid, -- vehicle_schedule_frame_id is null for this type
  sodblt.substitute_operating_day_by_line_type_id, -- substitute_operating_day_by_line_type_id
  sodblt.superseded_date, -- validity start is the superseded date for substitute operating day by line type
  sodblt.superseded_date, -- validity end is the superseded date for substitute operating day by line type
  internal_utils.const_timetables_priority_substitute_by_line_type(), --priority for these are substitute by line type
  false, --in_effect default value.
  ( -- calculate what is the correct day type id for the superseded date
    SELECT day_type_id
    FROM service_calendar.get_active_day_types_for_date(sodblt.superseded_date) dt
      JOIN  service_calendar.day_type_active_on_day_of_week dtaodow USING(day_type_id)
      GROUP BY day_type_id
      HAVING count(label) = 1
  )
FROM journey_pattern.journey_pattern_ref jpr
  JOIN service_calendar.substitute_operating_day_by_line_type sodblt USING(type_of_line)
  WHERE jpr.journey_pattern_id = ANY(journey_pattern_ids)
  AND sodblt.superseded_date >= start_date
  AND sodblt.superseded_date <= end_date
$$
;

COMMENT ON FUNCTION vehicle_service.get_timetables_and_substitute_operating_days
IS 'Uses return_value.timetable_version as return value. Returns all the corresponding data from
vehicle_schedule.vehicle_schedule_frame and service_calendar.substitute_operating_day_by_line_type that matches the given timerange and journey_pattern,
but leaves out staging priorities completely.
This function will also match the day type for the substitute day by using the superseded date.
In the return values, either the vehicle_schedule_frame_id OR substitute_operating_day_by_line_type_id will be NULL.
Also the in_effect value is defaulted here to false and the real value will be calculated in the get_timetable_versions_by_journey_pattern_ids function.';

CREATE OR REPLACE FUNCTION vehicle_service.get_timetable_versions_by_journey_pattern_ids(journey_pattern_ids uuid[], start_date date, end_date date, observation_date date)
  RETURNS SETOF return_value.timetable_version
  LANGUAGE SQL
  STABLE
AS $$
WITH timetable_versions AS
(
  SELECT gen_random_uuid() AS id, *
  FROM vehicle_service.get_timetables_and_substitute_operating_days(journey_pattern_ids, start_date, end_date)
)
SELECT
  timetable_versions.vehicle_schedule_frame_id,
  timetable_versions.substitute_operating_day_by_line_type_id,
  timetable_versions.validity_start,
  timetable_versions.validity_end,
  timetable_versions.priority,
  ( -- calculate the in_effect value
    timetable_versions.validity_start <= observation_date
    AND timetable_versions.validity_end >= observation_date
    AND timetable_versions.priority != internal_utils.const_timetables_priority_draft() -- do not set in effect value to drafts, staging priority is already omitted in get_timetables_and_substitute_operating_days
    AND
    (
      timetable_versions.priority = internal_utils.const_timetables_priority_special()
      OR NOT EXISTS
      (
        SELECT 1
        FROM timetable_versions overriding_tv
        WHERE
          overriding_tv.id != timetable_versions.id
          AND overriding_tv.day_type_id = timetable_versions.day_type_id
          AND overriding_tv.priority != internal_utils.const_timetables_priority_draft() -- do not override other priorities with draft priority
          AND overriding_tv.priority > timetable_versions.priority
          AND overriding_tv.validity_start <= observation_date
          AND overriding_tv.validity_end >= observation_date
      )
    )
  ) AS in_effect,
  timetable_versions.day_type_id
FROM timetable_versions;
$$
;

COMMENT ON FUNCTION vehicle_service.get_timetable_versions_by_journey_pattern_ids
IS 'Uses the return_value.timetable_version as the return value. This function will get
all the data needed for timetable versions including substitute_operating_days. After the data is fetched this function will determine what versions are `in effect` on the given observation date
The logic for this is that:
* All the special priorities (priority 25) are always in effect on their validity period.
* All the substitute priorities (priority 23) are in effect on their validity period and if there is no other version in effect with the exact same day type.
* All the temporary priorities (priority 20) are in effect on their validity period and if there is no other version in effect with the exact same day type.
* All the standard priorities (priority 20) are in effect on their validity period and if there is no other version in effect with the exact same day type.
* Draft priorities will not be set in effect, nor they will affect other priorities';
