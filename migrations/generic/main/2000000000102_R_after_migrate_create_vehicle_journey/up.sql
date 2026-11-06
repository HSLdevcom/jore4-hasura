-- NOTE: it would make more sense to return `interval` instead of `text`, but
-- hasura won't let save those as computed fields:
-- "Inconsistent object: in table "timetables.vehicle_journey": in computed field "start_time": the computed field "start_time" cannot be added to table "timetables.vehicle_journey" because the function "timetables.vehicle_journey_start_time" returning type interval is not a BASE type"

CREATE OR REPLACE FUNCTION timetables.vehicle_journey_start_time(vj timetables.vehicle_journey)
RETURNS text AS $$
  SELECT MIN (departure_time)::text AS start_time
  FROM timetables.timetabled_passing_time tpt
  WHERE tpt.vehicle_journey_id = vj.vehicle_journey_id;
$$ LANGUAGE sql STABLE;

CREATE OR REPLACE FUNCTION timetables.vehicle_journey_end_time(vj timetables.vehicle_journey)
RETURNS text AS $$
  SELECT MAX (arrival_time)::text AS end_time
  FROM timetables.timetabled_passing_time tpt
  WHERE tpt.vehicle_journey_id = vj.vehicle_journey_id;
$$ LANGUAGE sql STABLE;

-- Create the same functions to return interval for database internal use
CREATE OR REPLACE FUNCTION internal_utils.vehicle_journey_start_time_interval(vj timetables.vehicle_journey)
RETURNS interval AS $$
  SELECT MIN (departure_time) AS start_time
  FROM timetables.timetabled_passing_time tpt
  WHERE tpt.vehicle_journey_id = vj.vehicle_journey_id;
$$ LANGUAGE sql STABLE;

CREATE OR REPLACE FUNCTION internal_utils.vehicle_journey_end_time_interval(vj timetables.vehicle_journey)
RETURNS interval AS $$
  SELECT MAX (arrival_time) AS end_time
  FROM timetables.timetabled_passing_time tpt
  WHERE tpt.vehicle_journey_id = vj.vehicle_journey_id;
$$ LANGUAGE sql STABLE;

-- Backwards compatibility: the journey type DRY_RUN was renamed to DEAD_RUN.
-- Clients that still write the deprecated value get it normalized here, so that
-- DRY_RUN is never persisted. Remove this trigger (and the DRY_RUN row in
-- timetables.journey_type) once all clients have been migrated.
--
-- NOTE: the condition is deliberately evaluated inside the function body instead
-- of a WHEN clause or UPDATE OF journey_type. Both of those would make the
-- trigger depend on the journey_type column, which breaks down migrations that
-- drop that column.
CREATE OR REPLACE FUNCTION timetables.normalize_deprecated_journey_type()
RETURNS trigger AS $$
BEGIN
  IF NEW.journey_type = 'DRY_RUN' THEN
    NEW.journey_type := 'DEAD_RUN';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS normalize_deprecated_journey_type_trigger ON timetables.vehicle_journey;
CREATE TRIGGER normalize_deprecated_journey_type_trigger
  BEFORE INSERT OR UPDATE ON timetables.vehicle_journey
  FOR EACH ROW
  EXECUTE FUNCTION timetables.normalize_deprecated_journey_type();
COMMENT ON TRIGGER normalize_deprecated_journey_type_trigger ON timetables.vehicle_journey
IS 'Normalizes the deprecated journey type DRY_RUN to DEAD_RUN on write.';
