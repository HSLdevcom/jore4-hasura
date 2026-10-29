GRANT INSERT ON ALL TABLES IN SCHEMA service_pattern TO xxx_db_jore3importer_username_xxx;
GRANT UPDATE ON ALL TABLES IN SCHEMA service_pattern TO xxx_db_jore3importer_username_xxx;
GRANT DELETE ON ALL TABLES IN SCHEMA service_pattern TO xxx_db_jore3importer_username_xxx;
GRANT TRUNCATE ON ALL TABLES IN SCHEMA service_pattern TO xxx_db_jore3importer_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA service_pattern
  GRANT SELECT,INSERT,UPDATE,DELETE ON TABLES TO xxx_db_jore3importer_username_xxx;

GRANT INSERT ON ALL TABLES IN SCHEMA journey_pattern TO xxx_db_jore3importer_username_xxx;
GRANT UPDATE ON ALL TABLES IN SCHEMA journey_pattern TO xxx_db_jore3importer_username_xxx;
GRANT DELETE ON ALL TABLES IN SCHEMA journey_pattern TO xxx_db_jore3importer_username_xxx;
GRANT TRUNCATE ON ALL TABLES IN SCHEMA journey_pattern TO xxx_db_jore3importer_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA journey_pattern
  GRANT SELECT,INSERT,UPDATE,DELETE ON TABLES TO xxx_db_jore3importer_username_xxx;

GRANT INSERT ON ALL TABLES IN SCHEMA internal_service_pattern TO xxx_db_jore3importer_username_xxx;
GRANT UPDATE ON ALL TABLES IN SCHEMA internal_service_pattern TO xxx_db_jore3importer_username_xxx;
GRANT DELETE ON ALL TABLES IN SCHEMA internal_service_pattern TO xxx_db_jore3importer_username_xxx;
GRANT TRUNCATE ON ALL TABLES IN SCHEMA internal_service_pattern TO xxx_db_jore3importer_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA internal_service_pattern
  GRANT SELECT,INSERT,UPDATE,DELETE ON TABLES TO xxx_db_jore3importer_username_xxx;

GRANT INSERT ON ALL TABLES IN SCHEMA route TO xxx_db_jore3importer_username_xxx;
GRANT UPDATE ON ALL TABLES IN SCHEMA route TO xxx_db_jore3importer_username_xxx;
GRANT DELETE ON ALL TABLES IN SCHEMA route TO xxx_db_jore3importer_username_xxx;
GRANT TRUNCATE ON ALL TABLES IN SCHEMA route TO xxx_db_jore3importer_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA route
  GRANT SELECT,INSERT,UPDATE,DELETE ON TABLES TO xxx_db_jore3importer_username_xxx;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA route TO xxx_db_jore3importer_username_xxx;
ALTER DEFAULT PRIVILEGES FOR ROLE object_creator_role IN SCHEMA route
  GRANT USAGE ON SEQUENCES TO xxx_db_jore3importer_username_xxx;

GRANT INSERT ON ALL TABLES IN SCHEMA timing_pattern TO xxx_db_jore3importer_username_xxx;
GRANT UPDATE ON ALL TABLES IN SCHEMA timing_pattern TO xxx_db_jore3importer_username_xxx;
GRANT DELETE ON ALL TABLES IN SCHEMA timing_pattern TO xxx_db_jore3importer_username_xxx;
GRANT TRUNCATE ON ALL TABLES IN SCHEMA timing_pattern TO xxx_db_jore3importer_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA timing_pattern
  GRANT SELECT,INSERT,UPDATE,DELETE ON TABLES TO xxx_db_jore3importer_username_xxx;
