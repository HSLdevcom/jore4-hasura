CREATE SCHEMA jore3;
GRANT ALL PRIVILEGES ON SCHEMA jore3 TO xxx_db_jore3importer_username_xxx;

CREATE SCHEMA internal_jore3;
GRANT ALL PRIVILEGES ON SCHEMA internal_jore3 TO xxx_db_jore3importer_username_xxx;

GRANT
  USAGE
  ON SCHEMA jore3
  TO
    xxx_hsl_jore4_db_jore3transformer_username_xxx,
    xxx_hsl_jore4_db_mapmatcher_username_xxx;

GRANT
  SELECT, REFERENCES
  ON ALL TABLES
  IN SCHEMA jore3
  TO
    xxx_hsl_jore4_db_jore3transformer_username_xxx,
    xxx_hsl_jore4_db_mapmatcher_username_xxx;

GRANT
  SELECT
  ON ALL SEQUENCES
  IN SCHEMA jore3
  TO
    xxx_hsl_jore4_db_jore3transformer_username_xxx,
    xxx_hsl_jore4_db_mapmatcher_username_xxx;

GRANT
  EXECUTE
  ON ALL ROUTINES
  IN SCHEMA jore3
  TO
    xxx_hsl_jore4_db_jore3transformer_username_xxx,
    xxx_hsl_jore4_db_mapmatcher_username_xxx;
