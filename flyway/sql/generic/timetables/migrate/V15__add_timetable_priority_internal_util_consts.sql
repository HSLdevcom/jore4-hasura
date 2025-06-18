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

DROP FUNCTION IF EXISTS internal_utils.const_priority_draft();
