CREATE OR REPLACE FUNCTION internal_utils.const_priority_draft() RETURNS integer
  LANGUAGE sql IMMUTABLE PARALLEL SAFE
  AS $$SELECT 30$$;
