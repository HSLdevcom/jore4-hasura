-- HSL before-migrate: drop all views in the dssview schema dynamically.
-- The dssview schema itself is NOT dropped (it is created by the external infrastructure repository).
-- This runs before generic/main/1000000000000_R_before_migrate.
DO $$
DECLARE
  view_record RECORD;
BEGIN
  FOR view_record IN (
    SELECT table_schema, table_name
    FROM information_schema.views
    WHERE table_schema = 'dssview'
  )
  LOOP
    RAISE NOTICE 'Dropping view: %.%', view_record.table_schema, view_record.table_name;
    EXECUTE 'DROP VIEW IF EXISTS ' || quote_ident(view_record.table_schema) || '.' || quote_ident(view_record.table_name) || ' CASCADE;';
  END LOOP;
END;
$$;
