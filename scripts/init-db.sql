
-- Initializations, which are needed locally, but not in the cloud / prod environments,
-- go here.

-- These users are created from the jore4-deploy repository in cloud environments.
CREATE USER jore4auth PASSWORD 'jore4auth';
CREATE USER jore3importer PASSWORD 'jore3importer';
CREATE USER jore4hasura PASSWORD 'jore4hasurapassword';

-- create the extensions used
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS postgis;

-- create the schema required by the hasura system
CREATE SCHEMA IF NOT EXISTS hdb_catalog;

-- make the user an owner of system schemas
ALTER SCHEMA hdb_catalog OWNER TO jore4hasura;

-- allow hasura to create new schemas in migrations
GRANT CREATE ON DATABASE postgres TO jore4hasura;
