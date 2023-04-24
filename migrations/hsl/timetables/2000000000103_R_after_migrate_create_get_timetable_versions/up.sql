CREATE OR REPLACE FUNCTION vehicle_service.get_timetables_and_substitute_operating_days(journey_pattern_uuid uuid, begin_date date, end_date date)
 RETURNS SETOF return_value.timetable_version
 LANGUAGE sql
 STABLE
AS $function$
SELECT DISTINCT vsf.vehicle_schedule_frame_id, null::uuid, vsf.validity_start, vsf.validity_end, vsf.priority, false, dt.day_type_id 
  FROM vehicle_schedule.vehicle_schedule_frame vsf
    JOIN vehicle_service.vehicle_service vs USING (vehicle_schedule_frame_id) 
    JOIN service_calendar.day_type dt USING(day_type_id)
    JOIN vehicle_service.block b USING(vehicle_service_id)
    JOIN vehicle_service.journey_patterns_in_vehicle_service jp_in_vs USING(vehicle_service_id)
  WHERE jp_in_vs.journey_pattern_id = journey_pattern_uuid 
  AND vsf.validity_end >= begin_date 
  AND vsf.validity_start <= end_date
union 
SELECT DISTINCT null::uuid, sodblt.substitute_operating_day_by_line_type_id, sodblt.superseded_date, sodblt.superseded_date, 23, false, (SELECT day_type_id FROM service_calendar.get_active_day_types_for_date(superseded_date) dt
JOIN  service_calendar.day_type_active_on_day_of_week dtaodow USING(day_type_id)
GROUP BY day_type_id
HAVING count(label) = 1)
  FROM journey_pattern.journey_pattern_ref jpr 
    JOIN service_calendar.substitute_operating_day_by_line_type sodblt USING(type_of_line)
    WHERE jpr.journey_pattern_id = journey_pattern_uuid 
    AND sodblt.superseded_date >= begin_date 
    AND sodblt.superseded_date <= end_date
$function$
;

COMMENT ON FUNCTION vehicle_service.get_timetables_and_substitute_operating_days 
IS 'Uses return_value.timetable_version as return value. Returns all the corresponding data from 
vehicle_schedule.vehicle_schedule_frame and service_calendar.substitute_operating_day_by_line_type that matches the given timerange and journey_pattern.
This function will also match the day type for the substitute day by using the superseded date.
In the return values, either the vehicle_schedule_frame_id OR substitute_operating_day_by_line_type_id will be NULL.';
 
CREATE OR REPLACE FUNCTION vehicle_service.get_timetables_and_substitute_operating_days_by_journey_pattern_ids(journey_pattern_ids uuid[], begin_date date, end_date date)
 RETURNS SETOF return_value.timetable_version
 LANGUAGE plpgsql
 STABLE
AS $FUNCTION$
  BEGIN
  for i IN  1 .. array_upper(journey_pattern_ids, 1)
  LOOP 
    RETURN query(SELECT * FROM vehicle_service.get_timetables_and_substitute_operating_days(journey_pattern_ids[i], begin_date, end_date));
  END LOOP;
  
  END;
$FUNCTION$
;

COMMENT ON FUNCTION vehicle_service.get_timetables_and_substitute_operating_days_by_journey_pattern_ids 
IS 'Helper function to call vehicle_service.get_timetables_and_substitute_operating_days for each given journey_pattern.';

CREATE OR REPLACE FUNCTION vehicle_service.get_timetable_versions_by_journey_pattern_ids(journey_pattern_ids uuid[], begin_date date, end_date date, observation_date date)
 RETURNS SETOF return_value.timetable_version
 LANGUAGE plpgsql
AS $FUNCTION$
  BEGIN
    CREATE TEMP TABLE table_holder ON COMMIT DELETE ROWS AS
         SELECT * FROM vehicle_service.get_timetables_and_substitute_operating_days_by_journey_pattern_ids(journey_pattern_ids, begin_date, end_date);
  
  UPDATE table_holder SET in_effect = true 
  WHERE priority = 25 AND validity_start <= observation_date AND validity_end >= observation_date;
  
  UPDATE table_holder AS subquery SET in_effect = true
  WHERE priority = 23 AND validity_start <= observation_date AND validity_end >= observation_date AND NOT EXISTS (SELECT * FROM table_holder WHERE day_type_id = subquery.day_type_id AND in_effect = true);
  
  UPDATE table_holder AS subquery SET in_effect = true
  WHERE priority = 20 AND validity_start <= observation_date AND validity_end >= observation_date AND NOT EXISTS (SELECT * FROM table_holder WHERE day_type_id = subquery.day_type_id AND in_effect = true);
  
  UPDATE table_holder AS subquery SET in_effect = true
  WHERE priority = 10 AND validity_start <= observation_date AND validity_end >= observation_date AND NOT EXISTS (SELECT * FROM table_holder WHERE day_type_id = subquery.day_type_id AND in_effect = true);
    
  RETURN query (SELECT * FROM table_holder);
  END;
$FUNCTION$
;

COMMENT ON FUNCTION vehicle_service.get_timetables_and_substitute_operating_days_by_journey_pattern_ids 
IS 'Uses the return_value.timetable_version as the return value. This function will get
all the data needed for timetable versions including substitute_operating_days. After the data is fetched this function will determine what versions are `in effect` on the given observation date
The logic for this is that:
* All the special priorities (priority 25) are always in effect on their validity period. 
* All the substitute priorities (priority 23) are in effect on their validity period and if there is no other version in effect with the exact same day type.
* All the temporary priorities (priority 20) are in effect on their validity period and if there is no other version in effect with the exact same day type.
* All the standard priorities (priority 20) are in effect on their validity period and if there is no other version in effect with the exact same day type.';
