-- note: ALTER DEFAULT PRIVILEGES IN SCHEMA only adds GRANTs to *new* tables created after this migration
-- if using GRANT, it'll only apply to the *existing* tables

GRANT USAGE ON SCHEMA infrastructure_network TO xxx_db_jore3importer_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA infrastructure_network TO xxx_db_jore3importer_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA infrastructure_network
  GRANT SELECT ON TABLES TO xxx_db_jore3importer_username_xxx;

GRANT USAGE ON SCHEMA reusable_components TO xxx_db_jore3importer_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA reusable_components TO xxx_db_jore3importer_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA reusable_components
  GRANT SELECT ON TABLES TO xxx_db_jore3importer_username_xxx;

GRANT USAGE ON SCHEMA internal_utils TO xxx_db_jore3importer_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA internal_utils TO xxx_db_jore3importer_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA internal_utils
  GRANT SELECT ON TABLES TO xxx_db_jore3importer_username_xxx;

GRANT USAGE ON SCHEMA service_pattern TO xxx_db_jore3importer_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA service_pattern TO xxx_db_jore3importer_username_xxx;
GRANT INSERT ON ALL TABLES IN SCHEMA service_pattern TO xxx_db_jore3importer_username_xxx;
GRANT UPDATE ON ALL TABLES IN SCHEMA service_pattern TO xxx_db_jore3importer_username_xxx;
GRANT DELETE ON ALL TABLES IN SCHEMA service_pattern TO xxx_db_jore3importer_username_xxx;
GRANT TRUNCATE ON ALL TABLES IN SCHEMA service_pattern TO xxx_db_jore3importer_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA service_pattern GRANT SELECT ON TABLES TO xxx_db_jore3importer_username_xxx;

GRANT USAGE ON SCHEMA journey_pattern TO xxx_db_jore3importer_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA journey_pattern TO xxx_db_jore3importer_username_xxx;
GRANT INSERT ON ALL TABLES IN SCHEMA journey_pattern TO xxx_db_jore3importer_username_xxx;
GRANT UPDATE ON ALL TABLES IN SCHEMA journey_pattern TO xxx_db_jore3importer_username_xxx;
GRANT DELETE ON ALL TABLES IN SCHEMA journey_pattern TO xxx_db_jore3importer_username_xxx;
GRANT TRUNCATE ON ALL TABLES IN SCHEMA journey_pattern TO xxx_db_jore3importer_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA journey_pattern GRANT SELECT ON TABLES TO xxx_db_jore3importer_username_xxx;

GRANT USAGE ON SCHEMA internal_service_pattern TO xxx_db_jore3importer_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA internal_service_pattern TO xxx_db_jore3importer_username_xxx;
GRANT INSERT ON ALL TABLES IN SCHEMA internal_service_pattern TO xxx_db_jore3importer_username_xxx;
GRANT UPDATE ON ALL TABLES IN SCHEMA internal_service_pattern TO xxx_db_jore3importer_username_xxx;
GRANT DELETE ON ALL TABLES IN SCHEMA internal_service_pattern TO xxx_db_jore3importer_username_xxx;
GRANT TRUNCATE ON ALL TABLES IN SCHEMA internal_service_pattern TO xxx_db_jore3importer_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA internal_service_pattern GRANT SELECT ON TABLES TO xxx_db_jore3importer_username_xxx;

GRANT USAGE ON SCHEMA route TO xxx_db_jore3importer_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA route TO xxx_db_jore3importer_username_xxx;
GRANT INSERT ON ALL TABLES IN SCHEMA route TO xxx_db_jore3importer_username_xxx;
GRANT UPDATE ON ALL TABLES IN SCHEMA route TO xxx_db_jore3importer_username_xxx;
GRANT DELETE ON ALL TABLES IN SCHEMA route TO xxx_db_jore3importer_username_xxx;
GRANT TRUNCATE ON ALL TABLES IN SCHEMA route TO xxx_db_jore3importer_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA route GRANT SELECT ON TABLES TO xxx_db_jore3importer_username_xxx;
