REVOKE USAGE ON SCHEMA internal_service_calendar FROM xxx_db_timetables_api_username_xxx;
REVOKE SELECT ON ALL TABLES IN SCHEMA internal_service_calendar FROM xxx_db_timetables_api_username_xxx;
REVOKE INSERT ON ALL TABLES IN SCHEMA internal_service_calendar FROM xxx_db_timetables_api_username_xxx;
REVOKE UPDATE ON ALL TABLES IN SCHEMA internal_service_calendar FROM xxx_db_timetables_api_username_xxx;
REVOKE DELETE ON ALL TABLES IN SCHEMA internal_service_calendar FROM xxx_db_timetables_api_username_xxx;

REVOKE USAGE ON SCHEMA internal_utils FROM xxx_db_timetables_api_username_xxx;
REVOKE SELECT ON ALL TABLES IN SCHEMA internal_utils FROM xxx_db_timetables_api_username_xxx;
REVOKE INSERT ON ALL TABLES IN SCHEMA internal_utils FROM xxx_db_timetables_api_username_xxx;
REVOKE UPDATE ON ALL TABLES IN SCHEMA internal_utils FROM xxx_db_timetables_api_username_xxx;
REVOKE DELETE ON ALL TABLES IN SCHEMA internal_utils FROM xxx_db_timetables_api_username_xxx;

REVOKE USAGE ON SCHEMA return_value FROM xxx_db_timetables_api_username_xxx;
REVOKE SELECT ON ALL TABLES IN SCHEMA return_value FROM xxx_db_timetables_api_username_xxx;
REVOKE INSERT ON ALL TABLES IN SCHEMA return_value FROM xxx_db_timetables_api_username_xxx;
REVOKE UPDATE ON ALL TABLES IN SCHEMA return_value FROM xxx_db_timetables_api_username_xxx;
REVOKE DELETE ON ALL TABLES IN SCHEMA return_value FROM xxx_db_timetables_api_username_xxx;

ALTER DEFAULT PRIVILEGES IN SCHEMA internal_service_calendar REVOKE SELECT ON TABLES FROM xxx_db_timetables_api_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA internal_utils REVOKE SELECT ON TABLES FROM xxx_db_timetables_api_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA return_value REVOKE SELECT ON TABLES FROM xxx_db_timetables_api_username_xxx;
