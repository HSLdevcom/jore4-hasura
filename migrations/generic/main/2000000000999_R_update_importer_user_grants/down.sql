REVOKE USAGE ON SCHEMA internal_utils FROM xxx_db_jore3importer_username_xxx;
REVOKE SELECT ON ALL TABLES IN SCHEMA internal_utils FROM xxx_db_jore3importer_username_xxx;
REVOKE INSERT ON ALL TABLES IN SCHEMA internal_utils FROM xxx_db_jore3importer_username_xxx;
REVOKE UPDATE ON ALL TABLES IN SCHEMA internal_utils FROM xxx_db_jore3importer_username_xxx;
REVOKE DELETE ON ALL TABLES IN SCHEMA internal_utils FROM xxx_db_jore3importer_username_xxx;
REVOKE TRUNCATE ON ALL TABLES IN SCHEMA internal_utils FROM xxx_db_jore3importer_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA internal_utils
  REVOKE SELECT ON TABLES FROM xxx_db_jore3importer_username_xxx;

REVOKE USAGE ON SCHEMA reusable_components FROM xxx_db_jore3importer_username_xxx;
REVOKE SELECT ON ALL TABLES IN SCHEMA reusable_components FROM xxx_db_jore3importer_username_xxx;
REVOKE INSERT ON ALL TABLES IN SCHEMA reusable_components FROM xxx_db_jore3importer_username_xxx;
REVOKE UPDATE ON ALL TABLES IN SCHEMA reusable_components FROM xxx_db_jore3importer_username_xxx;
REVOKE DELETE ON ALL TABLES IN SCHEMA reusable_components FROM xxx_db_jore3importer_username_xxx;
REVOKE TRUNCATE ON ALL TABLES IN SCHEMA reusable_components FROM xxx_db_jore3importer_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA reusable_components REVOKE SELECT ON TABLES FROM xxx_db_jore3importer_username_xxx;

REVOKE USAGE ON SCHEMA network FROM xxx_db_jore3importer_username_xxx;
REVOKE SELECT ON ALL TABLES IN SCHEMA network FROM xxx_db_jore3importer_username_xxx;
REVOKE INSERT ON ALL TABLES IN SCHEMA network FROM xxx_db_jore3importer_username_xxx;
REVOKE UPDATE ON ALL TABLES IN SCHEMA network FROM xxx_db_jore3importer_username_xxx;
REVOKE DELETE ON ALL TABLES IN SCHEMA network FROM xxx_db_jore3importer_username_xxx;
REVOKE TRUNCATE ON ALL TABLES IN SCHEMA network FROM xxx_db_jore3importer_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA network REVOKE SELECT ON TABLES FROM xxx_db_jore3importer_username_xxx;
