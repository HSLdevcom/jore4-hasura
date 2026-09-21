REVOKE INSERT ON ALL TABLES IN SCHEMA service_pattern FROM xxx_db_jore3importer_username_xxx;
REVOKE UPDATE ON ALL TABLES IN SCHEMA service_pattern FROM xxx_db_jore3importer_username_xxx;
REVOKE DELETE ON ALL TABLES IN SCHEMA service_pattern FROM xxx_db_jore3importer_username_xxx;
REVOKE TRUNCATE ON ALL TABLES IN SCHEMA service_pattern FROM xxx_db_jore3importer_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA service_pattern
	REVOKE SELECT,INSERT,UPDATE,DELETE ON TABLES FROM xxx_db_jore3importer_username_xxx;

REVOKE INSERT ON ALL TABLES IN SCHEMA journey_pattern FROM xxx_db_jore3importer_username_xxx;
REVOKE UPDATE ON ALL TABLES IN SCHEMA journey_pattern FROM xxx_db_jore3importer_username_xxx;
REVOKE DELETE ON ALL TABLES IN SCHEMA journey_pattern FROM xxx_db_jore3importer_username_xxx;
REVOKE TRUNCATE ON ALL TABLES IN SCHEMA journey_pattern FROM xxx_db_jore3importer_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA journey_pattern
	REVOKE SELECT,INSERT,UPDATE,DELETE ON TABLES FROM xxx_db_jore3importer_username_xxx;

REVOKE INSERT ON ALL TABLES IN SCHEMA internal_service_pattern FROM xxx_db_jore3importer_username_xxx;
REVOKE UPDATE ON ALL TABLES IN SCHEMA internal_service_pattern FROM xxx_db_jore3importer_username_xxx;
REVOKE DELETE ON ALL TABLES IN SCHEMA internal_service_pattern FROM xxx_db_jore3importer_username_xxx;
REVOKE TRUNCATE ON ALL TABLES IN SCHEMA internal_service_pattern FROM xxx_db_jore3importer_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA internal_service_pattern
	REVOKE SELECT,INSERT,UPDATE,DELETE ON TABLES FROM xxx_db_jore3importer_username_xxx;

REVOKE INSERT ON ALL TABLES IN SCHEMA route FROM xxx_db_jore3importer_username_xxx;
REVOKE UPDATE ON ALL TABLES IN SCHEMA route FROM xxx_db_jore3importer_username_xxx;
REVOKE DELETE ON ALL TABLES IN SCHEMA route FROM xxx_db_jore3importer_username_xxx;
REVOKE TRUNCATE ON ALL TABLES IN SCHEMA route FROM xxx_db_jore3importer_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA route
	REVOKE SELECT,INSERT,UPDATE,DELETE ON TABLES FROM xxx_db_jore3importer_username_xxx;

REVOKE INSERT ON ALL TABLES IN SCHEMA timing_pattern FROM xxx_db_jore3importer_username_xxx;
REVOKE UPDATE ON ALL TABLES IN SCHEMA timing_pattern FROM xxx_db_jore3importer_username_xxx;
REVOKE DELETE ON ALL TABLES IN SCHEMA timing_pattern FROM xxx_db_jore3importer_username_xxx;
REVOKE TRUNCATE ON ALL TABLES IN SCHEMA timing_pattern FROM xxx_db_jore3importer_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA timing_pattern
	REVOKE SELECT,INSERT,UPDATE,DELETE ON TABLES FROM xxx_db_jore3importer_username_xxx;
