-- create schemas if they don't yet exist, because the drop function below reference them
CREATE SCHEMA IF NOT EXISTS infrastructure_network;
COMMENT ON SCHEMA infrastructure_network IS 'The infrastructure network model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:1:1:1:445';
CREATE SCHEMA IF NOT EXISTS internal_service_pattern;
CREATE SCHEMA IF NOT EXISTS internal_utils;
COMMENT ON SCHEMA internal_utils IS 'General utilities';
CREATE SCHEMA IF NOT EXISTS journey_pattern;
COMMENT ON SCHEMA journey_pattern IS 'The journey pattern model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:1:799';
CREATE SCHEMA IF NOT EXISTS reusable_components;
COMMENT ON SCHEMA reusable_components IS 'The reusable components model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=1:6:260';
CREATE SCHEMA IF NOT EXISTS route;
COMMENT ON SCHEMA route IS 'The route model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:1:3:475';
CREATE SCHEMA IF NOT EXISTS service_pattern;
COMMENT ON SCHEMA service_pattern IS 'The service pattern model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:4:840';
CREATE SCHEMA IF NOT EXISTS timing_pattern;
COMMENT ON SCHEMA timing_pattern IS 'The timing pattern model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:2:703 ';

-- drop all triggers in jore4 schemas
-- note: information_schema.triggers is missing TRUNCATE triggers
-- note2: pg_catalog.pg_triggers contains the TRUNCATE triggers but many other things too
-- so here we combine a bit of both
DO $$
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
        trigger_schema IN (
        'infrastructure_network',
        'internal_service_pattern',
        'internal_utils',
        'journey_pattern',
        'reusable_components',
        'route',
        'service_pattern'
    ) UNION (
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
        n.nspname IN (
        'infrastructure_network',
        'internal_service_pattern',
        'internal_utils',
        'journey_pattern',
        'reusable_components',
        'route',
        'service_pattern',
        'timing_pattern'
      )
    ))
  LOOP
    -- note: if the same trigger function is executed e.g. both on INSERT and UPDATE, there are two rows with the same trigger name
    -- This results in the DROP command being executed twice below, thus we use IF EXISTS here
    RAISE NOTICE 'Dropping trigger: %.%.%', trigger_record.schema_name, trigger_record.table_name, trigger_record.trigger_name;
    EXECUTE 'DROP TRIGGER IF EXISTS ' || quote_ident(trigger_record.trigger_name) || ' ON ' || quote_ident(trigger_record.schema_name) || '.' || quote_ident(trigger_record.table_name) || ';';
  END LOOP;
END;
$$;

-- dropping all constrains in jore4 schemas (except for primary and foreign key constraints)
DO $$
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
      n.nspname IN (
      'infrastructure_network',
      'internal_service_pattern',
      'internal_utils',
      'journey_pattern',
      'reusable_components',
      'route',
      'service_pattern',
      'timing_pattern'
    ))
  LOOP
    RAISE NOTICE 'Dropping constraint: %.%.%', constraint_record.schema_name, constraint_record.table_name, constraint_record.constraint_name;
    EXECUTE 'ALTER TABLE ' || quote_ident(constraint_record.schema_name) || '.' || quote_ident(constraint_record.table_name) || ' DROP CONSTRAINT ' || quote_ident(constraint_record.constraint_name) || ';';
  END LOOP;
END;
$$;

-- drop all functions in jore4 schemas
DO $$
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
  WHERE pronamespace IN (
    'infrastructure_network'::regnamespace,
    'internal_service_pattern'::regnamespace,
    'internal_utils'::regnamespace,
    'journey_pattern'::regnamespace,
    'reusable_components'::regnamespace,
    'route'::regnamespace,
    'service_pattern'::regnamespace,
    'timing_pattern'::regnamespace
  );

  IF sql_command IS NOT NULL THEN
    EXECUTE sql_command;
  ELSE
    RAISE NOTICE 'No functions found';
  END IF;
END;
$$;
