CREATE FUNCTION internal_utils.const_priority_standard()
  RETURNS int LANGUAGE sql IMMUTABLE PARALLEL SAFE AS
'SELECT 10';

CREATE FUNCTION internal_utils.const_priority_temporary()
  RETURNS int LANGUAGE sql IMMUTABLE PARALLEL SAFE AS
'SELECT 20';

CREATE FUNCTION internal_utils.const_priority_draft()
  RETURNS int LANGUAGE sql IMMUTABLE PARALLEL SAFE AS
'SELECT 30';