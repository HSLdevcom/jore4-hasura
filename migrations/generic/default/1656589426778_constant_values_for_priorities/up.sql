CREATE FUNCTION internal_utils.const_priority_draft()
  RETURNS int LANGUAGE sql IMMUTABLE PARALLEL SAFE AS
'SELECT 30';