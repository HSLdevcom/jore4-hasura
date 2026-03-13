-- create schemas if they don't yet exist, because the drop function below reference them
CREATE SCHEMA IF NOT EXISTS infrastructure_network;
COMMENT ON SCHEMA infrastructure_network IS 'The infrastructure network model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:1:1:1:445';
CREATE SCHEMA IF NOT EXISTS internal_utils;
COMMENT ON SCHEMA internal_utils IS 'General utilities';
CREATE SCHEMA IF NOT EXISTS network;
COMMENT ON SCHEMA network IS 'Network module adapted from transmodel https://www.transmodel-cen.eu/model/index.htm';
CREATE SCHEMA IF NOT EXISTS timetables;
COMMENT ON SCHEMA timetables IS 'Timetables module adapted from transmodel https://www.transmodel-cen.eu/model/index.htm';
CREATE SCHEMA IF NOT EXISTS reusable_components;
COMMENT ON SCHEMA reusable_components IS 'The reusable components model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=1:6:260';
CREATE SCHEMA IF NOT EXISTS return_value;
COMMENT ON SCHEMA return_value
IS 'This schema is used for all the SQL functions that need to have a table as return value. Nothing is stored in the tables in this schema.';

-- Create functions for dropping triggers, constraints and functions.

-- drop all triggers in jore4 schemas
-- note: information_schema.triggers is missing TRUNCATE triggers
-- note2: pg_catalog.pg_triggers contains the TRUNCATE triggers but many other things too
-- so here we combine a bit of both
CREATE OR REPLACE FUNCTION internal_utils.drop_triggers(target_schemas text[]) RETURNS void
AS $$
DECLARE
  trigger_record RECORD;
BEGIN
  FOR trigger_record IN
    (
      -- CRUD triggers
      SELECT
        trigger_schema AS schema_name,
        event_object_table AS table_name,
        trigger_name
      FROM information_schema.triggers
      WHERE
        trigger_schema = ANY(target_schemas)
    UNION (
      -- TRUNCATE triggers
      SELECT
        n.nspname as schema_name,
        c.relname as table_name,
        t.tgname AS trigger_name
      FROM pg_trigger t
        JOIN pg_class c on t.tgrelid = c.oid
        JOIN pg_namespace n on c.relnamespace = n.oid
      WHERE
        t.tgtype = 32 AND -- TRUNCATE triggers only
        n.nspname = ANY(target_schemas)
    )
  )
  LOOP
    -- note: if the same trigger function is executed e.g. both on INSERT and UPDATE, there are two rows with the same trigger name
    -- This results in the DROP command being executed twice below, thus we use IF EXISTS here
    RAISE NOTICE 'Dropping trigger: %.%.%', trigger_record.schema_name, trigger_record.table_name, trigger_record.trigger_name;
    EXECUTE 'DROP TRIGGER IF EXISTS ' || quote_ident(trigger_record.trigger_name) || ' ON ' || quote_ident(trigger_record.schema_name) || '.' || quote_ident(trigger_record.table_name) || ';';
  END LOOP;
END;
$$
LANGUAGE plpgsql;

-- dropping all constrains in jore4 schemas (except for primary and foreign key constraints)
CREATE OR REPLACE FUNCTION internal_utils.drop_constraints(target_schemas text[]) RETURNS void
AS $$
DECLARE
  constraint_record RECORD;
BEGIN
  FOR constraint_record IN (
    SELECT
      n.nspname as schema_name,
      t.relname as table_name,
      c.conname as constraint_name
    FROM pg_constraint c
      JOIN pg_class t on c.conrelid = t.oid
      JOIN pg_namespace n on t.relnamespace = n.oid
    WHERE
      -- c = check constraint, f = foreign key constraint, p = primary key constraint, u = unique constraint, t = constraint trigger, x = exclusion constraint
      c.contype IN ('c', 'u', 't', 'x') AND
      n.nspname = ANY(target_schemas)
  )
  LOOP
    RAISE NOTICE 'Dropping constraint: %.%.%', constraint_record.schema_name, constraint_record.table_name, constraint_record.constraint_name;
    EXECUTE 'ALTER TABLE ' || quote_ident(constraint_record.schema_name) || '.' || quote_ident(constraint_record.table_name) || ' DROP CONSTRAINT ' || quote_ident(constraint_record.constraint_name) || ';';
  END LOOP;
END;
$$
LANGUAGE plpgsql;

-- drop all functions in jore4 schemas which are not declared as immutable
CREATE OR REPLACE FUNCTION internal_utils.drop_functions(target_schemas text[]) RETURNS void
AS $$
DECLARE
  sql_command text;
BEGIN
  SELECT INTO sql_command
    string_agg(
      format('DROP %s %s;',
        CASE prokind
          WHEN 'f' THEN 'FUNCTION'
          WHEN 'a' THEN 'AGGREGATE'
          WHEN 'p' THEN 'PROCEDURE'
          WHEN 'w' THEN 'FUNCTION'
          ELSE NULL
        END,
        oid::regprocedure),
      E'\n')
  FROM pg_proc
  WHERE pronamespace = ANY(target_schemas::regnamespace[])
  AND provolatile NOT IN ('i');

  IF sql_command IS NOT NULL THEN
    EXECUTE sql_command;
  ELSE
    RAISE NOTICE 'No functions found';
  END IF;
END;
$$
LANGUAGE plpgsql;

-- Apply the drop functions to all of our schemas.

SELECT
  internal_utils.drop_triggers(schema_names),
  internal_utils.drop_constraints(schema_names),
  internal_utils.drop_functions(schema_names)
FROM (VALUES (ARRAY[
  'infrastructure_network',
  'network',
  'timetables'
])) AS t (schema_names);
