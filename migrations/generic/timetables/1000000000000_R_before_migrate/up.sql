-- create schemas if they don't yet exist, because the drop function below reference them
CREATE SCHEMA IF NOT EXISTS journey_pattern;
COMMENT ON SCHEMA journey_pattern IS 'The journey pattern model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:1:683 ';
CREATE SCHEMA IF NOT EXISTS service_pattern;
COMMENT ON SCHEMA service_pattern IS 'The service pattern model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:4:723 ';
CREATE SCHEMA IF NOT EXISTS service_calendar;
COMMENT ON SCHEMA service_calendar IS 'The service calendar model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=1:6:3:294 ';
CREATE SCHEMA IF NOT EXISTS vehicle_schedule;
COMMENT ON SCHEMA vehicle_schedule IS 'The vehicle schedule frame adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=3:7:2:993 ';
CREATE SCHEMA IF NOT EXISTS vehicle_service;
COMMENT ON SCHEMA vehicle_service IS 'The vehicle service model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=3:5:947 ';
CREATE SCHEMA IF NOT EXISTS vehicle_journey;
COMMENT ON SCHEMA vehicle_journey IS 'The vehicle journey model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=3:1:1:824 ';
CREATE SCHEMA IF NOT EXISTS passing_times;
COMMENT ON SCHEMA passing_times IS 'The passing times model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=3:4:939 ';

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
          'journey_pattern',
          'service_pattern',
          'service_calendar',
          'vehicle_schedule',
          'vehicle_service',
          'vehicle_journey',
          'passing_times'
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
          'journey_pattern',
          'service_pattern',
          'service_calendar',
          'vehicle_schedule',
          'vehicle_service',
          'vehicle_journey',
          'passing_times'
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
        'journey_pattern',
        'service_pattern',
        'service_calendar',
        'vehicle_schedule',
        'vehicle_service',
        'vehicle_journey',
        'passing_times'
    ))
  LOOP
    RAISE NOTICE 'Dropping constraint: %.%.%', constraint_record.schema_name, constraint_record.table_name, constraint_record.constraint_name;
    EXECUTE 'ALTER TABLE ' || quote_ident(constraint_record.schema_name) || '.' || quote_ident(constraint_record.table_name) || ' DROP CONSTRAINT ' || quote_ident(constraint_record.constraint_name) || ';';
  END LOOP;
END;
$$;

-- drop all functions in jore4 schemas which are not declared as immutable
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
    'journey_pattern'::regnamespace,
    'service_pattern'::regnamespace,
    'service_calendar'::regnamespace,
    'vehicle_schedule'::regnamespace,
    'vehicle_service'::regnamespace,
    'vehicle_journey'::regnamespace,
    'passing_times'::regnamespace
  )
  AND provolatile NOT IN ('i');

  IF sql_command IS NOT NULL THEN
    EXECUTE sql_command;
  ELSE
    RAISE NOTICE 'No functions found';
  END IF;
END;
$$;
