GRANT USAGE ON SCHEMA journey_pattern TO xxx_db_timetables_api_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA journey_pattern TO xxx_db_timetables_api_username_xxx;
GRANT INSERT ON ALL TABLES IN SCHEMA journey_pattern TO xxx_db_timetables_api_username_xxx;
GRANT UPDATE ON ALL TABLES IN SCHEMA journey_pattern TO xxx_db_timetables_api_username_xxx;
GRANT DELETE ON ALL TABLES IN SCHEMA journey_pattern TO xxx_db_timetables_api_username_xxx;

GRANT USAGE ON SCHEMA passing_times TO xxx_db_timetables_api_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA passing_times TO xxx_db_timetables_api_username_xxx;
GRANT INSERT ON ALL TABLES IN SCHEMA passing_times TO xxx_db_timetables_api_username_xxx;
GRANT UPDATE ON ALL TABLES IN SCHEMA passing_times TO xxx_db_timetables_api_username_xxx;
GRANT DELETE ON ALL TABLES IN SCHEMA passing_times TO xxx_db_timetables_api_username_xxx;

GRANT USAGE ON SCHEMA route TO xxx_db_timetables_api_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA route TO xxx_db_timetables_api_username_xxx;
GRANT INSERT ON ALL TABLES IN SCHEMA route TO xxx_db_timetables_api_username_xxx;
GRANT UPDATE ON ALL TABLES IN SCHEMA route TO xxx_db_timetables_api_username_xxx;
GRANT DELETE ON ALL TABLES IN SCHEMA route TO xxx_db_timetables_api_username_xxx;

GRANT USAGE ON SCHEMA service_calendar TO xxx_db_timetables_api_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA service_calendar TO xxx_db_timetables_api_username_xxx;
GRANT INSERT ON ALL TABLES IN SCHEMA service_calendar TO xxx_db_timetables_api_username_xxx;
GRANT UPDATE ON ALL TABLES IN SCHEMA service_calendar TO xxx_db_timetables_api_username_xxx;
GRANT DELETE ON ALL TABLES IN SCHEMA service_calendar TO xxx_db_timetables_api_username_xxx;

GRANT USAGE ON SCHEMA service_pattern TO xxx_db_timetables_api_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA service_pattern TO xxx_db_timetables_api_username_xxx;
GRANT INSERT ON ALL TABLES IN SCHEMA service_pattern TO xxx_db_timetables_api_username_xxx;
GRANT UPDATE ON ALL TABLES IN SCHEMA service_pattern TO xxx_db_timetables_api_username_xxx;
GRANT DELETE ON ALL TABLES IN SCHEMA service_pattern TO xxx_db_timetables_api_username_xxx;

GRANT USAGE ON SCHEMA vehicle_journey TO xxx_db_timetables_api_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA vehicle_journey TO xxx_db_timetables_api_username_xxx;
GRANT INSERT ON ALL TABLES IN SCHEMA vehicle_journey TO xxx_db_timetables_api_username_xxx;
GRANT UPDATE ON ALL TABLES IN SCHEMA vehicle_journey TO xxx_db_timetables_api_username_xxx;
GRANT DELETE ON ALL TABLES IN SCHEMA vehicle_journey TO xxx_db_timetables_api_username_xxx;

GRANT USAGE ON SCHEMA vehicle_schedule TO xxx_db_timetables_api_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA vehicle_schedule TO xxx_db_timetables_api_username_xxx;
GRANT INSERT ON ALL TABLES IN SCHEMA vehicle_schedule TO xxx_db_timetables_api_username_xxx;
GRANT UPDATE ON ALL TABLES IN SCHEMA vehicle_schedule TO xxx_db_timetables_api_username_xxx;
GRANT DELETE ON ALL TABLES IN SCHEMA vehicle_schedule TO xxx_db_timetables_api_username_xxx;

GRANT USAGE ON SCHEMA vehicle_service TO xxx_db_timetables_api_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA vehicle_service TO xxx_db_timetables_api_username_xxx;
GRANT INSERT ON ALL TABLES IN SCHEMA vehicle_service TO xxx_db_timetables_api_username_xxx;
GRANT UPDATE ON ALL TABLES IN SCHEMA vehicle_service TO xxx_db_timetables_api_username_xxx;
GRANT DELETE ON ALL TABLES IN SCHEMA vehicle_service TO xxx_db_timetables_api_username_xxx;

GRANT USAGE ON SCHEMA vehicle_type TO xxx_db_timetables_api_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA vehicle_type TO xxx_db_timetables_api_username_xxx;
GRANT INSERT ON ALL TABLES IN SCHEMA vehicle_type TO xxx_db_timetables_api_username_xxx;
GRANT UPDATE ON ALL TABLES IN SCHEMA vehicle_type TO xxx_db_timetables_api_username_xxx;
GRANT DELETE ON ALL TABLES IN SCHEMA vehicle_type TO xxx_db_timetables_api_username_xxx;

-- Note: ALTER DEFAULT PRIVILEGES IN SCHEMA only adds GRANTs to *new* tables created after this migration
-- if using GRANT, it'll only apply to the *existing* tables
ALTER DEFAULT PRIVILEGES IN SCHEMA journey_pattern GRANT SELECT ON TABLES TO xxx_db_timetables_api_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA passing_times GRANT SELECT ON TABLES TO xxx_db_timetables_api_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA route GRANT SELECT ON TABLES TO xxx_db_timetables_api_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA service_calendar GRANT SELECT ON TABLES TO xxx_db_timetables_api_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA service_pattern GRANT SELECT ON TABLES TO xxx_db_timetables_api_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA vehicle_journey GRANT SELECT ON TABLES TO xxx_db_timetables_api_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA vehicle_schedule GRANT SELECT ON TABLES TO xxx_db_timetables_api_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA vehicle_service GRANT SELECT ON TABLES TO xxx_db_timetables_api_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA vehicle_type GRANT SELECT ON TABLES TO xxx_db_timetables_api_username_xxx;
