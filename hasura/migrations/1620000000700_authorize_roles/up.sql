-- Schema owners have privileges. Set privileges here for the other roles.

-- Enable any role to use any extension.
GRANT USAGE ON SCHEMA extensions TO PUBLIC;
GRANT SELECT, REFERENCES ON ALL TABLES IN SCHEMA extensions TO PUBLIC;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA extensions TO PUBLIC;
GRANT EXECUTE ON ALL ROUTINES IN SCHEMA extensions TO PUBLIC;



-- Read and write access

-- Hasura
GRANT USAGE ON SCHEMA
  reusable_components,
  infrastructure_network,
  service_pattern,
  route,
  journey_pattern
  TO xxx_db_username_xxx;
GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE ON ALL TABLES IN SCHEMA
  reusable_components,
  infrastructure_network,
  service_pattern,
  route,
  journey_pattern
  TO xxx_db_username_xxx;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA
  reusable_components,
  infrastructure_network,
  service_pattern,
  route,
  journey_pattern
  TO xxx_db_username_xxx;
GRANT EXECUTE ON ALL ROUTINES IN SCHEMA
  reusable_components,
  infrastructure_network,
  service_pattern,
  route,
  journey_pattern
  TO xxx_db_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA
  reusable_components,
  infrastructure_network,
  service_pattern,
  route,
  journey_pattern
  GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE ON TABLES
  TO xxx_db_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA
  reusable_components,
  infrastructure_network,
  service_pattern,
  route,
  journey_pattern
  GRANT USAGE ON SEQUENCES
  TO xxx_db_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA
  reusable_components,
  infrastructure_network,
  service_pattern,
  route,
  journey_pattern
  GRANT EXECUTE ON ROUTINES
  TO xxx_db_username_xxx;



-- Read access

-- FIXME: just an example. Must use xxx instead of xx in real life (but not here, since it would cause an error due to a non-present secret).
-- jore3mapmatcher
-- GRANT USAGE ON SCHEMA import_jore3 TO xx_db_jore3mapmatcher_username_xx;
-- GRANT SELECT, REFERENCES ON ALL TABLES IN SCHEMA import_jore3 TO xx_db_jore3mapmatcher_username_xx;
-- GRANT SELECT ON ALL SEQUENCES IN SCHEMA import_jore3 TO xx_db_jore3mapmatcher_username_xx;
-- GRANT EXECUTE ON ALL ROUTINES IN SCHEMA import_jore3 TO xx_db_jore3mapmatcher_username_xx;
-- ALTER DEFAULT PRIVILEGES IN SCHEMA import_jore3 GRANT SELECT, REFERENCES ON TABLES TO xx_db_jore3mapmatcher_username_xx;
-- ALTER DEFAULT PRIVILEGES IN SCHEMA import_jore3 GRANT SELECT ON SEQUENCES TO xx_db_jore3mapmatcher_username_xx;
-- ALTER DEFAULT PRIVILEGES IN SCHEMA import_jore3 GRANT EXECUTE ON ROUTINES TO xx_db_jore3mapmatcher_username_xx;
