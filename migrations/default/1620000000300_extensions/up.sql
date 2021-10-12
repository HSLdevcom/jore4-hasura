--
-- Extensions
--

-- Hasura creates at least the pgcrypto extension in the public schema in its initialization phase.
-- Since the postgis extension is not relocatable, let's drop the extensions first.
DROP EXTENSION IF EXISTS pgcrypto CASCADE;
DROP EXTENSION IF EXISTS postgis CASCADE;

-- For ease of use, all extensions go into the schema extensions. We expect no
-- name conflicts between extensions.
CREATE SCHEMA extensions;
CREATE EXTENSION pgcrypto WITH SCHEMA extensions;
CREATE EXTENSION postgis WITH SCHEMA extensions;



-- Hasura needs pgcrypto in search_path and the schema public exists no longer:
-- https://hasura.io/docs/latest/graphql/core/deployment/postgres-requirements.html#pgcrypto-in-pg-search-path

-- Enable using extensions implicitly.
--
-- This does not affect the current session.
DO $$ BEGIN
  EXECUTE format(
    'ALTER DATABASE %I SET search_path = extensions',
    current_database()
  );
END $$;

-- Enable the current session to use extensions implicitly.
SELECT set_config('search_path', 'extensions', false);
