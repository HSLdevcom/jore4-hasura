-- note: how to handle active-on-day-of-week and active-on-day-of-year collisions?
-- note: how to handle vehicle services that are empty (no service on the given day)
DROP VIEW IF EXISTS vehicle_schedule.timetable_instances;
CREATE VIEW vehicle_schedule.timetable_instances AS
  SELECT
    vsf.vehicle_schedule_frame_id,
    vsf.name_i18n AS vehicle_schedule_frame_name_i18n,
    vs.vehicle_service_id,
    dt.day_type_id,
    dt.name_i18n AS day_type_name_i18n,
    b.block_id,
    vj.vehicle_journey_id,
    jp.journey_pattern_id
  FROM vehicle_schedule.vehicle_schedule_frame vsf
  -- note: at the moment the vehicle schedule frame is first inserted, it doesn't have any child attributes. The collisions should still however be checked
  LEFT JOIN vehicle_service.vehicle_service vs ON vs.vehicle_schedule_frame_id = vsf.vehicle_schedule_frame_id
  LEFT JOIN service_calendar.day_type dt ON vs.day_type_id = dt.day_type_id
  LEFT JOIN vehicle_service.block b ON b.vehicle_service_id = vs.vehicle_service_id
  LEFT JOIN vehicle_journey.vehicle_journey vj ON vj.block_id = b.block_id
  -- we want to check integrity for journey pattern, not journey pattern reference
  LEFT JOIN journey_pattern.journey_pattern_ref jp ON vj.journey_pattern_ref_id = jp.journey_pattern_ref_id
;

CREATE FUNCTION vehicle_schedule.queue_verify_timetable_collisions() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  rowdata RECORD;
BEGIN
  RAISE NOTICE 'vehicle_schedule.queue_verify_timetable_collisions()';

  FOR rowdata IN (SELECT * FROM vehicle_schedule.timetable_instances) LOOP
      RAISE NOTICE '%', to_json(rowdata);
  END LOOP;

  RETURN NULL;
END;
$$;

DROP TRIGGER IF EXISTS queue_verify_timetable_collisions_on_insert_trigger
  ON vehicle_schedule.vehicle_schedule_frame;
CREATE TRIGGER queue_verify_timetable_collisions_on_insert_trigger
  AFTER INSERT ON vehicle_schedule.vehicle_schedule_frame
  FOR EACH STATEMENT
  EXECUTE FUNCTION vehicle_schedule.queue_verify_timetable_collisions();
COMMENT ON TRIGGER queue_verify_timetable_collisions_on_insert_trigger ON vehicle_schedule.vehicle_schedule_frame IS 'TODO';
