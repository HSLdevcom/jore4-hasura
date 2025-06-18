GRANT USAGE ON SCHEMA timing_pattern TO xxx_db_jore3importer_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA timing_pattern TO xxx_db_jore3importer_username_xxx;
GRANT INSERT ON ALL TABLES IN SCHEMA timing_pattern TO xxx_db_jore3importer_username_xxx;
GRANT UPDATE ON ALL TABLES IN SCHEMA timing_pattern TO xxx_db_jore3importer_username_xxx;
GRANT DELETE ON ALL TABLES IN SCHEMA timing_pattern TO xxx_db_jore3importer_username_xxx;
GRANT TRUNCATE ON ALL TABLES IN SCHEMA timing_pattern TO xxx_db_jore3importer_username_xxx;

-- Note: ALTER DEFAULT PRIVILEGES IN SCHEMA only adds GRANTs to *new* tables created after this migration
-- if using GRANT, it'll only apply to the *existing* tables
ALTER DEFAULT PRIVILEGES IN SCHEMA timing_pattern GRANT SELECT ON TABLES TO xxx_db_jore3importer_username_xxx;
