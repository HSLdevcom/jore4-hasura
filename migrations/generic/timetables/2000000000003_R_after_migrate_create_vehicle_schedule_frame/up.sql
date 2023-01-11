-- note: how to handle active-on-day-of-week and active-on-day-of-year collisions?
-- note: how to handle vehicle services that are empty (no service on the given day) as they dont have any journey patterns
DROP VIEW IF EXISTS vehicle_schedule.timetable_instances;
CREATE VIEW vehicle_schedule.timetable_instances AS
  -- looking for distinct tuples of (vehicle schedule frame validity period, vehicle schedule frame priority, day type, journey pattern)
  SELECT DISTINCT
      vsf.vehicle_schedule_frame_id
    , vsf.priority
    , vsf.name_i18n AS vehicle_schedule_frame_name_i18n
    , vs.vehicle_service_id
    , dt.day_type_id
    , dt.name_i18n AS day_type_name_i18n
    , b.block_id
    , vj.vehicle_journey_id
    , jp.journey_pattern_id
    , dow.day_of_week AS active_day_of_week
  FROM vehicle_schedule.vehicle_schedule_frame vsf
  -- FIXME: here we assume that all vehicle schedule frames have journey patterns under through their vehicle journeys
  JOIN vehicle_service.vehicle_service vs ON vs.vehicle_schedule_frame_id = vsf.vehicle_schedule_frame_id
  JOIN service_calendar.day_type dt ON vs.day_type_id = dt.day_type_id
  JOIN vehicle_service.block b ON b.vehicle_service_id = vs.vehicle_service_id
  JOIN vehicle_journey.vehicle_journey vj ON vj.block_id = b.block_id
  -- we want to check integrity for journey pattern, not journey pattern reference
  JOIN journey_pattern.journey_pattern_ref jp ON vj.journey_pattern_ref_id = jp.journey_pattern_ref_id
  -- only checking for "active on day of week" for now, not other day type attributes
  LEFT JOIN service_calendar.day_type_active_on_day_of_week dow ON dow.day_type_id = dt.day_type_id
;

CREATE OR REPLACE FUNCTION vehicle_schedule.queue_verify_timetable_collisions() RETURNS trigger
  LANGUAGE plpgsql
  AS $$
DECLARE
  current RECORD;
BEGIN
  RAISE NOTICE 'vehicle_schedule.queue_verify_timetable_collisions()';

  FOR current IN (
    SELECT
      -- hash helps identifying tuples in the loop
      md5(ti::text) AS rowhash,
      ti.* FROM vehicle_schedule.timetable_instances ti
  )
  LOOP
    RAISE NOTICE 'Validating timetable: %', to_json(current);

    -- looking for conflicting timetables where...
    IF EXISTS (
      SELECT 1
      FROM vehicle_schedule.timetable_instances other
      WHERE
        -- (should not check for conflicts with itself)
        current.rowhash != md5(other::text)
        -- ...two timetables have the same priority
        AND current.priority = other.priority
        -- ...they are not draft priorities
        -- TODO create function for checking for drafts
        AND current.priority < 30
        -- ...affect the same route (journey pattern)
        -- TODO should we check journey pattern refs instead?
        AND current.journey_pattern_id = other.journey_pattern_id
        -- ...be active on the same day of week (if the activeness is defined)
        -- TODO create a function to check if two day types are generally overlapping
        AND current.active_day_of_week IS NOT NULL
        AND current.active_day_of_week = other.active_day_of_week
    ) THEN
      RAISE NOTICE 'Conflicting timetable: %', to_json(current);
    END IF;
  END LOOP;

  RETURN NULL;
END;
$$;

-- TODO call this trigger on all insert and update operations
DROP TRIGGER IF EXISTS queue_verify_timetable_collisions_on_insert_trigger ON vehicle_schedule.vehicle_schedule_frame;
CREATE TRIGGER queue_verify_timetable_collisions_on_insert_trigger AFTER INSERT ON vehicle_schedule.vehicle_schedule_frame
  FOR EACH STATEMENT EXECUTE FUNCTION vehicle_schedule.queue_verify_timetable_collisions();
COMMENT ON TRIGGER queue_verify_timetable_collisions_on_insert_trigger ON vehicle_schedule.vehicle_schedule_frame IS 'TODO';

INSERT INTO vehicle_schedule.vehicle_schedule_frame
  (name_i18n, validity_start, validity_end, priority)
VALUES
  ('{"fi_FI": "aaaaaaaaaaaaaaaaaa", "sv_FI": "2022 Höst - 2022 Vår"}', '2022-08-15', '2023-06-04', 10);
