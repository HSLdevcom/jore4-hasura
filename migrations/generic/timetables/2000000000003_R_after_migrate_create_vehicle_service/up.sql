CREATE OR REPLACE FUNCTION vehicle_service.get_vehicle_services_for_date(observation_date date)
  RETURNS SETOF vehicle_service.vehicle_service
  LANGUAGE sql STABLE
AS $$
  SELECT vs.*
    FROM vehicle_service.vehicle_service vs
    JOIN service_calendar.get_active_day_types_for_date(observation_date) dt on vs.day_type_id = dt.day_type_id
    JOIN vehicle_schedule.vehicle_schedule_frame vsf on vs.vehicle_schedule_frame_id = vsf.vehicle_schedule_frame_id
    -- match only effective vehicle schedule frames on the given operating day
    WHERE vsf.validity_start <= observation_date AND observation_date <= vsf.validity_end
$$;
COMMENT ON FUNCTION vehicle_service.get_vehicle_services_for_date IS 'Find all vehicle services that are active on the given observation date.
The results are not filtered by highest priority, that can be done on the UI on demand';

SELECT vehicle_service.get_vehicle_services_for_date('2022-11-25'::date)
