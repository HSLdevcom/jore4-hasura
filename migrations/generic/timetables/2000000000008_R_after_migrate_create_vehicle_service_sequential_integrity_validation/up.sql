CREATE OR REPLACE FUNCTION vehicle_service.get_vehicle_service_timing_data(vehicle_service_ids uuid[])
  RETURNS TABLE(
    vehicle_service_id uuid,
    service_start interval,
    service_end interval,
    block_id uuid,
    block_start interval,
    block_end interval,
    preparing_time interval,
    finishing_time interval,
    vehicle_journey_id uuid,
    journey_start interval,
    journey_end interval,
    journey_first_stop_departure interval,
    journey_last_stop_arrival interval,
    turnaround_time interval,
    layover_time interval,
    timetabled_passing_time_id uuid,
    stop_departure_time interval,
    stop_arrival_time interval
  )
  LANGUAGE sql STABLE PARALLEL SAFE
AS $$
  -- Process goes like this:
  -- 1 (timing_data): collect all required columns from DB, coalesce to get rid off nulls
  -- 2 (with_journey_times): passing times -> start & end of each journey
  -- 3 (with_block_times): journey times -> start & end of each block
  -- 4 (with_service_times): block times -> start & end of each service
  -- 5: return all fetched and calculated columns.
  --
  -- Note: this could be written as many nested subqueries as well.
  -- Tried it, but there was no difference in performance and query plans were near identical.
  WITH timing_data AS (
    SELECT
      vehicle_service_id,
      MIN(tpt.departure_time) OVER (PARTITION BY vehicle_journey_id) AS journey_first_stop_departure,
      MAX(tpt.arrival_time) OVER (PARTITION BY vehicle_journey_id) AS journey_last_stop_arrival,
      block_id,
      COALESCE (block.preparing_time, INTERVAL '0') AS preparing_time,
      COALESCE (block.finishing_time, INTERVAL '0') AS finishing_time,
      vehicle_journey_id,
      COALESCE (journey.turnaround_time, INTERVAL '0') AS turnaround_time,
      COALESCE (journey.layover_time, INTERVAL '0') AS layover_time,
      timetabled_passing_time_id,
      COALESCE (tpt.departure_time, passing_time) AS stop_departure_time,
      COALESCE (tpt.arrival_time, passing_time) AS stop_arrival_time
    FROM vehicle_journey.vehicle_journey journey
    JOIN passing_times.timetabled_passing_time tpt USING (vehicle_journey_id)
    JOIN vehicle_service.block block USING (block_id)
    JOIN vehicle_service.vehicle_service service USING (vehicle_service_id)
    WHERE vehicle_service_id = ANY(vehicle_service_ids)
  ),
  with_journey_times AS (
    SELECT
      *,
      journey_first_stop_departure - layover_time AS journey_start,
      journey_last_stop_arrival + turnaround_time AS journey_end
    FROM timing_data
  ),
  with_block_times AS (
    SELECT
      *,
      MIN(journey_start) OVER (PARTITION BY block_id) AS block_start,
      MAX(journey_end) OVER (PARTITION BY block_id) AS block_end
    FROM with_journey_times
  ),
  with_service_times AS (
    SELECT
      *,
      MIN(block_start) OVER (PARTITION BY vehicle_service_id) AS service_start,
      MAX(block_end) OVER (PARTITION BY vehicle_service_id) AS service_end
    FROM with_block_times
  )
  SELECT
    vehicle_service_id,
    service_start,
    service_end,
    block_id,
    block_start,
    block_end,
    preparing_time,
    finishing_time,
    vehicle_journey_id,
    journey_start,
    journey_end,
    journey_first_stop_departure,
    journey_last_stop_arrival,
    turnaround_time as turnaround_time,
    layover_time as layover_time,
    timetabled_passing_time_id,
    stop_departure_time,
    stop_arrival_time
  FROM with_service_times;
$$;
COMMENT ON FUNCTION vehicle_service.get_vehicle_service_timing_data(vehicle_service_ids uuid[])
IS 'A helper function for sequential integrity validation.
For given vehicle_services, returns the blocks, journeys and timetabled passing times that they contain,
and start and end times for each level.';

CREATE OR REPLACE FUNCTION vehicle_service.validate_service_sequential_integrity() RETURNS VOID
  LANGUAGE plpgsql
AS $$
  DECLARE
    error_message TEXT;
  BEGIN
    -- RAISE NOTICE 'vehicle_service.validate_service_sequential_integrity()';

    -- Build modified_vehicle_service_ids from modified_ tables,
    -- finding out which services or their children were modified.
    -- Eg. if block_id is present in modified_block, it's parent vehicle_service will be selected.
    WITH modified_vehicle_service_ids AS (
      SELECT vehicle_service_id
      -- TODO: add passing times. Implement the logic first without these, to validate that it works.
      FROM modified_vehicle_journey
      JOIN vehicle_journey.vehicle_journey USING (vehicle_journey_id)
      FULL OUTER JOIN modified_block USING (block_id)
      JOIN vehicle_service.block USING (block_id)
      FULL OUTER JOIN modified_vehicle_service USING (vehicle_service_id)
    ),
    timing_data AS (
      SELECT * FROM vehicle_service.get_vehicle_service_timing_data(
        (SELECT array_agg(vehicle_service_id) FROM modified_vehicle_service_ids)
      )
    ),
    ordered AS (
      SELECT
        -- Assign an index for each row according to their temporal order, per vehicle service. To be used as identifier.
        ROW_NUMBER() OVER (
          PARTITION BY vehicle_service_id
          ORDER BY service_start, block_start, journey_start, stop_departure_time
        ) order_number,
        *
      FROM timing_data
      ORDER BY vehicle_service_id, service_start, block_start, journey_start, stop_departure_time
    ),
    with_inconsistencies AS (
      SELECT
        ordered.block_id <> next_time.block_id AND ordered.block_end > next_time.block_start AS block_overlaps_with_next,
        ordered.vehicle_journey_id <> next_time.vehicle_journey_id AND ordered.journey_end > next_time.journey_start AS jourey_overlaps_with_next,
        next_time.block_id AS next_block_id,
        next_time.block_start AS next_block_start,
        next_time.block_end AS next_block_end,
        next_time.vehicle_journey_id AS next_vehicle_journey_id,
        next_time.journey_start AS next_journey_start,
        next_time.journey_end AS next_journey_end,
        ordered.*
      FROM ordered
      JOIN ordered next_time ON ordered.vehicle_service_id = next_time.vehicle_service_id AND next_time.order_number = (ordered.order_number + 1)
    )
    SELECT string_agg(error_text, '. ')
      FROM (
        SELECT format(
          'vehicle_service %s: block %s (%s - %s) overlaps with block %s (%s - %s)',
          vehicle_service_id,
          block_id,
          block_start,
          block_end,
          next_block_id,
          next_block_start,
          next_block_end
        ) AS error_text
        FROM with_inconsistencies
        WHERE block_overlaps_with_next
      UNION
        SELECT format(
          'vehicle_service %s: journey %s (%s - %s) overlaps with journey %s (%s - %s)',
          vehicle_service_id,
          vehicle_journey_id,
          journey_start,
          journey_end,
          next_vehicle_journey_id,
          next_journey_start,
          next_journey_end
        ) AS error_text
        FROM with_inconsistencies
        WHERE jourey_overlaps_with_next
      ) AS errors
    INTO error_message;

    IF error_message IS NOT NULL THEN
        RAISE EXCEPTION 'Sequential integrity issues detected: %', error_message;
    END IF;
  END
$$;
