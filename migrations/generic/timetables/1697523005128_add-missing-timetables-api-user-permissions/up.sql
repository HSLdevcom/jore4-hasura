GRANT USAGE ON SCHEMA internal_service_calendar TO xxx_db_timetables_api_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA internal_service_calendar TO xxx_db_timetables_api_username_xxx;
GRANT INSERT ON ALL TABLES IN SCHEMA internal_service_calendar TO xxx_db_timetables_api_username_xxx;
GRANT UPDATE ON ALL TABLES IN SCHEMA internal_service_calendar TO xxx_db_timetables_api_username_xxx;
GRANT DELETE ON ALL TABLES IN SCHEMA internal_service_calendar TO xxx_db_timetables_api_username_xxx;

GRANT USAGE ON SCHEMA internal_utils TO xxx_db_timetables_api_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA internal_utils TO xxx_db_timetables_api_username_xxx;
GRANT INSERT ON ALL TABLES IN SCHEMA internal_utils TO xxx_db_timetables_api_username_xxx;
GRANT UPDATE ON ALL TABLES IN SCHEMA internal_utils TO xxx_db_timetables_api_username_xxx;
GRANT DELETE ON ALL TABLES IN SCHEMA internal_utils TO xxx_db_timetables_api_username_xxx;

GRANT USAGE ON SCHEMA return_value TO xxx_db_timetables_api_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA return_value TO xxx_db_timetables_api_username_xxx;
GRANT INSERT ON ALL TABLES IN SCHEMA return_value TO xxx_db_timetables_api_username_xxx;
GRANT UPDATE ON ALL TABLES IN SCHEMA return_value TO xxx_db_timetables_api_username_xxx;
GRANT DELETE ON ALL TABLES IN SCHEMA return_value TO xxx_db_timetables_api_username_xxx;

ALTER DEFAULT PRIVILEGES IN SCHEMA internal_service_calendar GRANT SELECT ON TABLES TO xxx_db_timetables_api_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA internal_utils GRANT SELECT ON TABLES TO xxx_db_timetables_api_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA return_value GRANT SELECT ON TABLES TO xxx_db_timetables_api_username_xxx;
