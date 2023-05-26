CREATE OR REPLACE FUNCTION internal_utils.const_priority_draft() RETURNS integer
  LANGUAGE sql IMMUTABLE PARALLEL SAFE
  AS $$SELECT 30$$;

DROP FUNCTION IF EXISTS internal_utils.const_timetables_priority_special();

DROP FUNCTION IF EXISTS internal_utils.const_timetables_priority_substitute_by_line_type();

DROP FUNCTION IF EXISTS internal_utils.const_timetables_priority_staging();

DROP FUNCTION IF EXISTS internal_utils.const_timetables_priority_draft();
