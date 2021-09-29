--
-- Temporary destructive cleanup
--

-- During rapid development, drop all used schemas discarding all data and start
-- fresh. This way the SQL schema migration files stay more readable and in one
-- place. Once the schemas stabilize, use proper schema migrations and delete
-- this schema migration.
DROP SCHEMA IF EXISTS extensions CASCADE;

DROP SCHEMA IF EXISTS internal_utils CASCADE;

DROP SCHEMA IF EXISTS reusable_components CASCADE;
DROP SCHEMA IF EXISTS infrastructure_network CASCADE;
DROP SCHEMA IF EXISTS internal_service_pattern CASCADE;
DROP SCHEMA IF EXISTS service_pattern CASCADE;
DROP SCHEMA IF EXISTS internal_route CASCADE;
DROP SCHEMA IF EXISTS route CASCADE;
DROP SCHEMA IF EXISTS journey_pattern CASCADE;

DROP SCHEMA IF EXISTS import_jore3 CASCADE;
