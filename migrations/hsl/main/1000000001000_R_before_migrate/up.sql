-- create schemas if they don't yet exist, because the drop functions below reference them
CREATE SCHEMA IF NOT EXISTS hsl_route;
COMMENT ON SCHEMA hsl_route IS 'HSL specific route related additions to the base schema.';

-- Apply the drop functions to all HSL schemas.

SELECT
  internal_utils.drop_triggers(schema_names),
  internal_utils.drop_constraints(schema_names),
  internal_utils.drop_functions(schema_names)
FROM (VALUES (ARRAY[
  'hsl_route'
])) AS t (schema_names);
