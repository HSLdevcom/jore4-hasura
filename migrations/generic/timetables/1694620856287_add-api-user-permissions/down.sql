REVOKE USAGE ON SCHEMA journey_pattern FROM xxx_db_timetables_api_username_xxx;
REVOKE SELECT ON ALL TABLES IN SCHEMA journey_pattern FROM xxx_db_timetables_api_username_xxx;
REVOKE INSERT ON ALL TABLES IN SCHEMA journey_pattern FROM xxx_db_timetables_api_username_xxx;
REVOKE UPDATE ON ALL TABLES IN SCHEMA journey_pattern FROM xxx_db_timetables_api_username_xxx;
REVOKE DELETE ON ALL TABLES IN SCHEMA journey_pattern FROM xxx_db_timetables_api_username_xxx;

REVOKE USAGE ON SCHEMA passing_times FROM xxx_db_timetables_api_username_xxx;
REVOKE SELECT ON ALL TABLES IN SCHEMA passing_times FROM xxx_db_timetables_api_username_xxx;
REVOKE INSERT ON ALL TABLES IN SCHEMA passing_times FROM xxx_db_timetables_api_username_xxx;
REVOKE UPDATE ON ALL TABLES IN SCHEMA passing_times FROM xxx_db_timetables_api_username_xxx;
REVOKE DELETE ON ALL TABLES IN SCHEMA passing_times FROM xxx_db_timetables_api_username_xxx;

REVOKE USAGE ON SCHEMA route FROM xxx_db_timetables_api_username_xxx;
REVOKE SELECT ON ALL TABLES IN SCHEMA route FROM xxx_db_timetables_api_username_xxx;
REVOKE INSERT ON ALL TABLES IN SCHEMA route FROM xxx_db_timetables_api_username_xxx;
REVOKE UPDATE ON ALL TABLES IN SCHEMA route FROM xxx_db_timetables_api_username_xxx;
REVOKE DELETE ON ALL TABLES IN SCHEMA route FROM xxx_db_timetables_api_username_xxx;

REVOKE USAGE ON SCHEMA service_calendar FROM xxx_db_timetables_api_username_xxx;
REVOKE SELECT ON ALL TABLES IN SCHEMA service_calendar FROM xxx_db_timetables_api_username_xxx;
REVOKE INSERT ON ALL TABLES IN SCHEMA service_calendar FROM xxx_db_timetables_api_username_xxx;
REVOKE UPDATE ON ALL TABLES IN SCHEMA service_calendar FROM xxx_db_timetables_api_username_xxx;
REVOKE DELETE ON ALL TABLES IN SCHEMA service_calendar FROM xxx_db_timetables_api_username_xxx;

REVOKE USAGE ON SCHEMA service_pattern FROM xxx_db_timetables_api_username_xxx;
REVOKE SELECT ON ALL TABLES IN SCHEMA service_pattern FROM xxx_db_timetables_api_username_xxx;
REVOKE INSERT ON ALL TABLES IN SCHEMA service_pattern FROM xxx_db_timetables_api_username_xxx;
REVOKE UPDATE ON ALL TABLES IN SCHEMA service_pattern FROM xxx_db_timetables_api_username_xxx;
REVOKE DELETE ON ALL TABLES IN SCHEMA service_pattern FROM xxx_db_timetables_api_username_xxx;

REVOKE USAGE ON SCHEMA vehicle_journey FROM xxx_db_timetables_api_username_xxx;
REVOKE SELECT ON ALL TABLES IN SCHEMA vehicle_journey FROM xxx_db_timetables_api_username_xxx;
REVOKE INSERT ON ALL TABLES IN SCHEMA vehicle_journey FROM xxx_db_timetables_api_username_xxx;
REVOKE UPDATE ON ALL TABLES IN SCHEMA vehicle_journey FROM xxx_db_timetables_api_username_xxx;
REVOKE DELETE ON ALL TABLES IN SCHEMA vehicle_journey FROM xxx_db_timetables_api_username_xxx;

REVOKE USAGE ON SCHEMA vehicle_schedule FROM xxx_db_timetables_api_username_xxx;
REVOKE SELECT ON ALL TABLES IN SCHEMA vehicle_schedule FROM xxx_db_timetables_api_username_xxx;
REVOKE INSERT ON ALL TABLES IN SCHEMA vehicle_schedule FROM xxx_db_timetables_api_username_xxx;
REVOKE UPDATE ON ALL TABLES IN SCHEMA vehicle_schedule FROM xxx_db_timetables_api_username_xxx;
REVOKE DELETE ON ALL TABLES IN SCHEMA vehicle_schedule FROM xxx_db_timetables_api_username_xxx;

REVOKE USAGE ON SCHEMA vehicle_service FROM xxx_db_timetables_api_username_xxx;
REVOKE SELECT ON ALL TABLES IN SCHEMA vehicle_service FROM xxx_db_timetables_api_username_xxx;
REVOKE INSERT ON ALL TABLES IN SCHEMA vehicle_service FROM xxx_db_timetables_api_username_xxx;
REVOKE UPDATE ON ALL TABLES IN SCHEMA vehicle_service FROM xxx_db_timetables_api_username_xxx;
REVOKE DELETE ON ALL TABLES IN SCHEMA vehicle_service FROM xxx_db_timetables_api_username_xxx;

REVOKE USAGE ON SCHEMA vehicle_type FROM xxx_db_timetables_api_username_xxx;
REVOKE SELECT ON ALL TABLES IN SCHEMA vehicle_type FROM xxx_db_timetables_api_username_xxx;
REVOKE INSERT ON ALL TABLES IN SCHEMA vehicle_type FROM xxx_db_timetables_api_username_xxx;
REVOKE UPDATE ON ALL TABLES IN SCHEMA vehicle_type FROM xxx_db_timetables_api_username_xxx;
REVOKE DELETE ON ALL TABLES IN SCHEMA vehicle_type FROM xxx_db_timetables_api_username_xxx;

ALTER DEFAULT PRIVILEGES IN SCHEMA journey_pattern REVOKE SELECT ON TABLES FROM xxx_db_timetables_api_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA passing_times REVOKE SELECT ON TABLES FROM xxx_db_timetables_api_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA route REVOKE SELECT ON TABLES FROM xxx_db_timetables_api_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA service_calendar REVOKE SELECT ON TABLES FROM xxx_db_timetables_api_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA service_pattern REVOKE SELECT ON TABLES FROM xxx_db_timetables_api_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA vehicle_journey REVOKE SELECT ON TABLES FROM xxx_db_timetables_api_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA vehicle_schedule REVOKE SELECT ON TABLES FROM xxx_db_timetables_api_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA vehicle_service REVOKE SELECT ON TABLES FROM xxx_db_timetables_api_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA vehicle_type REVOKE SELECT ON TABLES FROM xxx_db_timetables_api_username_xxx;
