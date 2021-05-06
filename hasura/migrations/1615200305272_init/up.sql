-- drop public schema as it might not be available e.g. in azure's db
DROP SCHEMA IF EXISTS public CASCADE;

CREATE SCHEMA postgis;
CREATE SCHEMA pgcrypto;
CREATE EXTENSION postgis WITH SCHEMA postgis;
CREATE EXTENSION pgcrypto WITH SCHEMA pgcrypto;
CREATE SCHEMA infrastructure_network;

-- hasura needs pgcrypto in search_path https://hasura.io/docs/latest/graphql/core/deployment/postgres-requirements.html#pgcrypto-in-pg-search-path
-- add also postgis on search_path so that we can use it directly in migrations (`gen_random_uuid()` vs. `pgcrypto.gen_random_uuid()`)
-- this doesn't seem to affect current session
DO $$
BEGIN
  EXECUTE 'ALTER DATABASE ' || current_database() || ' SET search_path = postgis, pgcrypto';
END
$$;

-- update search path also for current session
SELECT set_config('search_path', 'postgis, pgcrypto,' || current_setting('search_path'), false);

CREATE TABLE infrastructure_network.infrastructure_links (
  infrastructure_link_id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  infrastructure_link_geog geography(LinestringZ,4326) NOT NULL
);
