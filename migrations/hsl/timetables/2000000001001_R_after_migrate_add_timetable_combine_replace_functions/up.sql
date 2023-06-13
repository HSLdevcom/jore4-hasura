CREATE OR REPLACE FUNCTION vehicle_schedule.promote_staging_timetables(
  staging_vehicle_schedule_frame_ids_to_promote uuid[],
  target_priority integer
)
RETURNS VOID
LANGUAGE plpgsql
VOLATILE PARALLEL UNSAFE
AS $$
  DECLARE
    replacement RECORD;
  BEGIN
    RAISE LOG 'STARTING';

    FOR replacement IN
      SELECT

        staging_vehicle_schedule_frame_id,
        array_agg(res.replaced_vehicle_schedule_frame_id) AS replaced_vehicle_schedule_frame_ids,
        staging_frame.validity_start AS staging_validity_start
      FROM vehicle_schedule.get_frames_replaced_by_staging_timetables(
        staging_vehicle_schedule_frame_ids_to_promote, target_priority
      ) res
      JOIN vehicle_schedule.vehicle_schedule_frame staging_frame
      ON staging_frame.vehicle_schedule_frame_id = res.staging_vehicle_schedule_frame_id
      GROUP BY (staging_vehicle_schedule_frame_id, staging_validity_start)
    LOOP
      RAISE LOG 'Looping replacements: % -> %', replacement.staging_vehicle_schedule_frame_id, replacement.replaced_vehicle_schedule_frame_ids;

      -- End the current VSF just before new one starts.
      -- TODO: there is an unhandled corner case here: new one might be starting before current one.
      UPDATE vehicle_schedule.vehicle_schedule_frame
      SET validity_end = (replacement.staging_validity_start - INTERVAL '1 day')::date
      WHERE vehicle_schedule_frame_id = ANY(replacement.replaced_vehicle_schedule_frame_ids);

      -- Promote the staging VSF to target priority.
      UPDATE vehicle_schedule.vehicle_schedule_frame
      SET priority = target_priority
      WHERE vehicle_schedule_frame_id = replacement.staging_vehicle_schedule_frame_id;
    END LOOP;

    RAISE LOG 'DONE';
  END
$$;


CREATE OR REPLACE FUNCTION vehicle_schedule.combine_staging_timetables(
  staging_vehicle_schedule_frame_ids_to_promote uuid[],
  target_priority integer
)
RETURNS VOID
LANGUAGE plpgsql
VOLATILE PARALLEL UNSAFE
AS $$
  DECLARE
    staging_frame RECORD;
    target_frame RECORD;
  BEGIN
      RAISE LOG 'STARTING';

    FOR staging_frame IN
      SELECT * FROM vehicle_schedule.vehicle_schedule_frame
      WHERE vehicle_schedule_frame_id = ANY(staging_vehicle_schedule_frame_ids_to_promote)
    LOOP
      RAISE LOG 'loopity loop';
      SELECT * INTO target_frame
      FROM vehicle_schedule.vehicle_schedule_frame target_vsf
      WHERE target_vsf.priority = target_priority
      -- The combined (staging) and target must have some shared journey patterns.
      -- TODO: this could be optimized. Maybe use temp table for the result.
      -- TODO: it is possible that there are multiple targets.
      -- Maybe deal with these by checking that target has all the same routes as staging (and possibly more).
      AND EXISTS (
        SELECT 1 FROM
        vehicle_schedule.get_frames_replaced_by_staging_timetables(
          staging_vehicle_schedule_frame_ids_to_promote, target_priority
        ) replacement
        WHERE replacement.staging_vehicle_schedule_frame_id = staging_frame.vehicle_schedule_frame_id
        AND replacement.replaced_vehicle_schedule_frame_id = target_vsf.vehicle_schedule_frame_id
      )
      AND target_vsf.validity_start = staging_frame.validity_start
      AND target_vsf.validity_end = staging_frame.validity_end;

--      SELECT DISTINCT journey_pattern_id FROM vehicle_service.journey_patterns_in_vehicle_service jpivs
--      JOIN vehicle_service.vehicle_service vs USING (vehicle_service_id)
--      WHERE vs.vehicle_schedule_frame_id = staging_frame.vehicle_schedule_frame_id;
    -- could probably do this with union all + except, but would have to use temp tables or duplicate queries many times.
    -- https://stackoverflow.com/questions/5727882/check-if-two-selects-are-equivalent


      IF target_frame IS NULL THEN
        RAISE EXCEPTION 'Could not find target for vehicle_schedule_frame for staging_frame %.', staging_frame.vehicle_schedule_frame_id;
      END IF;

      -- Move staging frame services to target frame.
      UPDATE vehicle_service.vehicle_service service_to_update
      SET vehicle_schedule_frame_id = target_frame.vehicle_schedule_frame_id
      WHERE service_to_update.vehicle_schedule_frame_id = staging_frame.vehicle_schedule_frame_id;

      -- The staging frame is not "empty" -> delete.
      DELETE FROM vehicle_schedule.vehicle_schedule_frame frame_to_delete
      WHERE frame_to_delete.vehicle_schedule_frame_id = staging_frame.vehicle_schedule_frame_id;

      RAISE LOG 'LOOP DONE';
    END LOOP;

    RAISE LOG 'DONE';
    -- RAISE EXCEPTION 'nope';
  END
$$;
