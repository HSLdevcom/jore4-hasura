--
-- Sorted PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: SCHEMA internal_service_calendar; Type: ACL; Schema: -; Owner: dbhasura
--

GRANT USAGE ON SCHEMA internal_service_calendar TO dbtimetablesapi;

--
-- Name: SCHEMA internal_utils; Type: ACL; Schema: -; Owner: dbhasura
--

GRANT USAGE ON SCHEMA internal_utils TO dbtimetablesapi;

--
-- Name: SCHEMA journey_pattern; Type: ACL; Schema: -; Owner: dbhasura
--

GRANT USAGE ON SCHEMA journey_pattern TO dbtimetablesapi;

--
-- Name: SCHEMA passing_times; Type: ACL; Schema: -; Owner: dbhasura
--

GRANT USAGE ON SCHEMA passing_times TO dbtimetablesapi;

--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: dbadmin
--

GRANT ALL ON SCHEMA public TO dbhasura;
GRANT USAGE ON SCHEMA public TO dbtimetablesapi;

--
-- Name: SCHEMA return_value; Type: ACL; Schema: -; Owner: dbhasura
--

GRANT USAGE ON SCHEMA return_value TO dbtimetablesapi;

--
-- Name: SCHEMA route; Type: ACL; Schema: -; Owner: dbhasura
--

GRANT USAGE ON SCHEMA route TO dbtimetablesapi;

--
-- Name: SCHEMA service_calendar; Type: ACL; Schema: -; Owner: dbhasura
--

GRANT USAGE ON SCHEMA service_calendar TO dbtimetablesapi;

--
-- Name: SCHEMA service_pattern; Type: ACL; Schema: -; Owner: dbhasura
--

GRANT USAGE ON SCHEMA service_pattern TO dbtimetablesapi;

--
-- Name: SCHEMA vehicle_journey; Type: ACL; Schema: -; Owner: dbhasura
--

GRANT USAGE ON SCHEMA vehicle_journey TO dbtimetablesapi;

--
-- Name: SCHEMA vehicle_schedule; Type: ACL; Schema: -; Owner: dbhasura
--

GRANT USAGE ON SCHEMA vehicle_schedule TO dbtimetablesapi;

--
-- Name: SCHEMA vehicle_service; Type: ACL; Schema: -; Owner: dbhasura
--

GRANT USAGE ON SCHEMA vehicle_service TO dbtimetablesapi;

--
-- Name: SCHEMA vehicle_type; Type: ACL; Schema: -; Owner: dbhasura
--

GRANT USAGE ON SCHEMA vehicle_type TO dbtimetablesapi;

--
-- Name: TABLE journey_pattern_ref; Type: ACL; Schema: journey_pattern; Owner: dbhasura
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE journey_pattern.journey_pattern_ref TO dbtimetablesapi;

--
-- Name: TABLE timetabled_passing_time; Type: ACL; Schema: passing_times; Owner: dbhasura
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE passing_times.timetabled_passing_time TO dbtimetablesapi;

--
-- Name: TABLE pg_aggregate; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_aggregate TO dbhasura;

--
-- Name: TABLE pg_am; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_am TO dbhasura;

--
-- Name: TABLE pg_amop; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_amop TO dbhasura;

--
-- Name: TABLE pg_amproc; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_amproc TO dbhasura;

--
-- Name: TABLE pg_attrdef; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_attrdef TO dbhasura;

--
-- Name: TABLE pg_attribute; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_attribute TO dbhasura;

--
-- Name: TABLE pg_auth_members; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_auth_members TO dbhasura;

--
-- Name: TABLE pg_authid; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_authid TO dbhasura;

--
-- Name: TABLE pg_available_extension_versions; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_available_extension_versions TO dbhasura;

--
-- Name: TABLE pg_available_extensions; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_available_extensions TO dbhasura;

--
-- Name: TABLE pg_backend_memory_contexts; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_backend_memory_contexts TO dbhasura;

--
-- Name: TABLE pg_cast; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_cast TO dbhasura;

--
-- Name: TABLE pg_class; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_class TO dbhasura;

--
-- Name: TABLE pg_collation; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_collation TO dbhasura;

--
-- Name: TABLE pg_config; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_config TO dbhasura;

--
-- Name: TABLE pg_constraint; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_constraint TO dbhasura;

--
-- Name: TABLE pg_conversion; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_conversion TO dbhasura;

--
-- Name: TABLE pg_cursors; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_cursors TO dbhasura;

--
-- Name: TABLE pg_database; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_database TO dbhasura;

--
-- Name: TABLE pg_db_role_setting; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_db_role_setting TO dbhasura;

--
-- Name: TABLE pg_default_acl; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_default_acl TO dbhasura;

--
-- Name: TABLE pg_depend; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_depend TO dbhasura;

--
-- Name: TABLE pg_description; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_description TO dbhasura;

--
-- Name: TABLE pg_enum; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_enum TO dbhasura;

--
-- Name: TABLE pg_event_trigger; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_event_trigger TO dbhasura;

--
-- Name: TABLE pg_extension; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_extension TO dbhasura;

--
-- Name: TABLE pg_file_settings; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_file_settings TO dbhasura;

--
-- Name: TABLE pg_foreign_data_wrapper; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_foreign_data_wrapper TO dbhasura;

--
-- Name: TABLE pg_foreign_server; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_foreign_server TO dbhasura;

--
-- Name: TABLE pg_foreign_table; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_foreign_table TO dbhasura;

--
-- Name: TABLE pg_group; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_group TO dbhasura;

--
-- Name: TABLE pg_hba_file_rules; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_hba_file_rules TO dbhasura;

--
-- Name: TABLE pg_ident_file_mappings; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_ident_file_mappings TO dbhasura;

--
-- Name: TABLE pg_index; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_index TO dbhasura;

--
-- Name: TABLE pg_indexes; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_indexes TO dbhasura;

--
-- Name: TABLE pg_inherits; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_inherits TO dbhasura;

--
-- Name: TABLE pg_init_privs; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_init_privs TO dbhasura;

--
-- Name: TABLE pg_language; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_language TO dbhasura;

--
-- Name: TABLE pg_largeobject; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_largeobject TO dbhasura;

--
-- Name: TABLE pg_largeobject_metadata; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_largeobject_metadata TO dbhasura;

--
-- Name: TABLE pg_locks; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_locks TO dbhasura;

--
-- Name: TABLE pg_matviews; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_matviews TO dbhasura;

--
-- Name: TABLE pg_namespace; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_namespace TO dbhasura;

--
-- Name: TABLE pg_opclass; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_opclass TO dbhasura;

--
-- Name: TABLE pg_operator; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_operator TO dbhasura;

--
-- Name: TABLE pg_opfamily; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_opfamily TO dbhasura;

--
-- Name: TABLE pg_parameter_acl; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_parameter_acl TO dbhasura;

--
-- Name: TABLE pg_partitioned_table; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_partitioned_table TO dbhasura;

--
-- Name: TABLE pg_policies; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_policies TO dbhasura;

--
-- Name: TABLE pg_policy; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_policy TO dbhasura;

--
-- Name: TABLE pg_prepared_statements; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_prepared_statements TO dbhasura;

--
-- Name: TABLE pg_prepared_xacts; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_prepared_xacts TO dbhasura;

--
-- Name: TABLE pg_proc; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_proc TO dbhasura;

--
-- Name: TABLE pg_publication; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_publication TO dbhasura;

--
-- Name: TABLE pg_publication_namespace; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_publication_namespace TO dbhasura;

--
-- Name: TABLE pg_publication_rel; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_publication_rel TO dbhasura;

--
-- Name: TABLE pg_publication_tables; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_publication_tables TO dbhasura;

--
-- Name: TABLE pg_range; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_range TO dbhasura;

--
-- Name: TABLE pg_replication_origin; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_replication_origin TO dbhasura;

--
-- Name: TABLE pg_replication_origin_status; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_replication_origin_status TO dbhasura;

--
-- Name: TABLE pg_replication_slots; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_replication_slots TO dbhasura;

--
-- Name: TABLE pg_rewrite; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_rewrite TO dbhasura;

--
-- Name: TABLE pg_roles; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_roles TO dbhasura;

--
-- Name: TABLE pg_rules; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_rules TO dbhasura;

--
-- Name: TABLE pg_seclabel; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_seclabel TO dbhasura;

--
-- Name: TABLE pg_seclabels; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_seclabels TO dbhasura;

--
-- Name: TABLE pg_sequence; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_sequence TO dbhasura;

--
-- Name: TABLE pg_sequences; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_sequences TO dbhasura;

--
-- Name: TABLE pg_settings; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_settings TO dbhasura;

--
-- Name: TABLE pg_shadow; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_shadow TO dbhasura;

--
-- Name: TABLE pg_shdepend; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_shdepend TO dbhasura;

--
-- Name: TABLE pg_shdescription; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_shdescription TO dbhasura;

--
-- Name: TABLE pg_shmem_allocations; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_shmem_allocations TO dbhasura;

--
-- Name: TABLE pg_shseclabel; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_shseclabel TO dbhasura;

--
-- Name: TABLE pg_stat_activity; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_activity TO dbhasura;

--
-- Name: TABLE pg_stat_all_indexes; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_all_indexes TO dbhasura;

--
-- Name: TABLE pg_stat_all_tables; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_all_tables TO dbhasura;

--
-- Name: TABLE pg_stat_archiver; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_archiver TO dbhasura;

--
-- Name: TABLE pg_stat_bgwriter; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_bgwriter TO dbhasura;

--
-- Name: TABLE pg_stat_database; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_database TO dbhasura;

--
-- Name: TABLE pg_stat_database_conflicts; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_database_conflicts TO dbhasura;

--
-- Name: TABLE pg_stat_gssapi; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_gssapi TO dbhasura;

--
-- Name: TABLE pg_stat_progress_analyze; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_progress_analyze TO dbhasura;

--
-- Name: TABLE pg_stat_progress_basebackup; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_progress_basebackup TO dbhasura;

--
-- Name: TABLE pg_stat_progress_cluster; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_progress_cluster TO dbhasura;

--
-- Name: TABLE pg_stat_progress_copy; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_progress_copy TO dbhasura;

--
-- Name: TABLE pg_stat_progress_create_index; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_progress_create_index TO dbhasura;

--
-- Name: TABLE pg_stat_progress_vacuum; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_progress_vacuum TO dbhasura;

--
-- Name: TABLE pg_stat_recovery_prefetch; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_recovery_prefetch TO dbhasura;

--
-- Name: TABLE pg_stat_replication; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_replication TO dbhasura;

--
-- Name: TABLE pg_stat_replication_slots; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_replication_slots TO dbhasura;

--
-- Name: TABLE pg_stat_slru; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_slru TO dbhasura;

--
-- Name: TABLE pg_stat_ssl; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_ssl TO dbhasura;

--
-- Name: TABLE pg_stat_subscription; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_subscription TO dbhasura;

--
-- Name: TABLE pg_stat_subscription_stats; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_subscription_stats TO dbhasura;

--
-- Name: TABLE pg_stat_sys_indexes; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_sys_indexes TO dbhasura;

--
-- Name: TABLE pg_stat_sys_tables; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_sys_tables TO dbhasura;

--
-- Name: TABLE pg_stat_user_functions; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_user_functions TO dbhasura;

--
-- Name: TABLE pg_stat_user_indexes; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_user_indexes TO dbhasura;

--
-- Name: TABLE pg_stat_user_tables; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_user_tables TO dbhasura;

--
-- Name: TABLE pg_stat_wal; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_wal TO dbhasura;

--
-- Name: TABLE pg_stat_wal_receiver; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_wal_receiver TO dbhasura;

--
-- Name: TABLE pg_stat_xact_all_tables; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_xact_all_tables TO dbhasura;

--
-- Name: TABLE pg_stat_xact_sys_tables; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_xact_sys_tables TO dbhasura;

--
-- Name: TABLE pg_stat_xact_user_functions; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_xact_user_functions TO dbhasura;

--
-- Name: TABLE pg_stat_xact_user_tables; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_xact_user_tables TO dbhasura;

--
-- Name: TABLE pg_statio_all_indexes; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_statio_all_indexes TO dbhasura;

--
-- Name: TABLE pg_statio_all_sequences; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_statio_all_sequences TO dbhasura;

--
-- Name: TABLE pg_statio_all_tables; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_statio_all_tables TO dbhasura;

--
-- Name: TABLE pg_statio_sys_indexes; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_statio_sys_indexes TO dbhasura;

--
-- Name: TABLE pg_statio_sys_sequences; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_statio_sys_sequences TO dbhasura;

--
-- Name: TABLE pg_statio_sys_tables; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_statio_sys_tables TO dbhasura;

--
-- Name: TABLE pg_statio_user_indexes; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_statio_user_indexes TO dbhasura;

--
-- Name: TABLE pg_statio_user_sequences; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_statio_user_sequences TO dbhasura;

--
-- Name: TABLE pg_statio_user_tables; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_statio_user_tables TO dbhasura;

--
-- Name: TABLE pg_statistic; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_statistic TO dbhasura;

--
-- Name: TABLE pg_statistic_ext; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_statistic_ext TO dbhasura;

--
-- Name: TABLE pg_statistic_ext_data; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_statistic_ext_data TO dbhasura;

--
-- Name: TABLE pg_stats; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_stats TO dbhasura;

--
-- Name: TABLE pg_stats_ext; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_stats_ext TO dbhasura;

--
-- Name: TABLE pg_stats_ext_exprs; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_stats_ext_exprs TO dbhasura;

--
-- Name: TABLE pg_subscription; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_subscription TO dbhasura;

--
-- Name: TABLE pg_subscription_rel; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_subscription_rel TO dbhasura;

--
-- Name: TABLE pg_tables; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_tables TO dbhasura;

--
-- Name: TABLE pg_tablespace; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_tablespace TO dbhasura;

--
-- Name: TABLE pg_timezone_abbrevs; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_timezone_abbrevs TO dbhasura;

--
-- Name: TABLE pg_timezone_names; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_timezone_names TO dbhasura;

--
-- Name: TABLE pg_transform; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_transform TO dbhasura;

--
-- Name: TABLE pg_trigger; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_trigger TO dbhasura;

--
-- Name: TABLE pg_ts_config; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_ts_config TO dbhasura;

--
-- Name: TABLE pg_ts_config_map; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_ts_config_map TO dbhasura;

--
-- Name: TABLE pg_ts_dict; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_ts_dict TO dbhasura;

--
-- Name: TABLE pg_ts_parser; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_ts_parser TO dbhasura;

--
-- Name: TABLE pg_ts_template; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_ts_template TO dbhasura;

--
-- Name: TABLE pg_type; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_type TO dbhasura;

--
-- Name: TABLE pg_user; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_user TO dbhasura;

--
-- Name: TABLE pg_user_mapping; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_user_mapping TO dbhasura;

--
-- Name: TABLE pg_user_mappings; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_user_mappings TO dbhasura;

--
-- Name: TABLE pg_views; Type: ACL; Schema: pg_catalog; Owner: dbadmin
--

GRANT SELECT ON TABLE pg_catalog.pg_views TO dbhasura;

--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.armor(bytea) TO dbhasura;
GRANT ALL ON FUNCTION public.armor(bytea) TO dbtimetablesapi;

--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.armor(bytea, text[], text[]) TO dbhasura;
GRANT ALL ON FUNCTION public.armor(bytea, text[], text[]) TO dbtimetablesapi;

--
-- Name: FUNCTION cash_dist(money, money); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.cash_dist(money, money) TO dbhasura;
GRANT ALL ON FUNCTION public.cash_dist(money, money) TO dbtimetablesapi;

--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.crypt(text, text) TO dbhasura;
GRANT ALL ON FUNCTION public.crypt(text, text) TO dbtimetablesapi;

--
-- Name: FUNCTION date_dist(date, date); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.date_dist(date, date) TO dbhasura;
GRANT ALL ON FUNCTION public.date_dist(date, date) TO dbtimetablesapi;

--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.dearmor(text) TO dbhasura;
GRANT ALL ON FUNCTION public.dearmor(text) TO dbtimetablesapi;

--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.decrypt(bytea, bytea, text) TO dbhasura;
GRANT ALL ON FUNCTION public.decrypt(bytea, bytea, text) TO dbtimetablesapi;

--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.decrypt_iv(bytea, bytea, bytea, text) TO dbhasura;
GRANT ALL ON FUNCTION public.decrypt_iv(bytea, bytea, bytea, text) TO dbtimetablesapi;

--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.digest(bytea, text) TO dbhasura;
GRANT ALL ON FUNCTION public.digest(bytea, text) TO dbtimetablesapi;

--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.digest(text, text) TO dbhasura;
GRANT ALL ON FUNCTION public.digest(text, text) TO dbtimetablesapi;

--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.encrypt(bytea, bytea, text) TO dbhasura;
GRANT ALL ON FUNCTION public.encrypt(bytea, bytea, text) TO dbtimetablesapi;

--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.encrypt_iv(bytea, bytea, bytea, text) TO dbhasura;
GRANT ALL ON FUNCTION public.encrypt_iv(bytea, bytea, bytea, text) TO dbtimetablesapi;

--
-- Name: FUNCTION float4_dist(real, real); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.float4_dist(real, real) TO dbhasura;
GRANT ALL ON FUNCTION public.float4_dist(real, real) TO dbtimetablesapi;

--
-- Name: FUNCTION float8_dist(double precision, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.float8_dist(double precision, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.float8_dist(double precision, double precision) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_bit_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bit_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bit_compress(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_bit_consistent(internal, bit, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bit_consistent(internal, bit, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bit_consistent(internal, bit, smallint, oid, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_bit_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bit_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bit_penalty(internal, internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_bit_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bit_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bit_picksplit(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_bit_same(public.gbtreekey_var, public.gbtreekey_var, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bit_same(public.gbtreekey_var, public.gbtreekey_var, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bit_same(public.gbtreekey_var, public.gbtreekey_var, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_bit_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bit_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bit_union(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_bool_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bool_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bool_compress(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_bool_consistent(internal, boolean, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bool_consistent(internal, boolean, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bool_consistent(internal, boolean, smallint, oid, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_bool_fetch(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bool_fetch(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bool_fetch(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_bool_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bool_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bool_penalty(internal, internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_bool_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bool_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bool_picksplit(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_bool_same(public.gbtreekey2, public.gbtreekey2, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bool_same(public.gbtreekey2, public.gbtreekey2, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bool_same(public.gbtreekey2, public.gbtreekey2, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_bool_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bool_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bool_union(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_bpchar_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bpchar_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bpchar_compress(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_bpchar_consistent(internal, character, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bpchar_consistent(internal, character, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bpchar_consistent(internal, character, smallint, oid, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_bytea_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bytea_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bytea_compress(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_bytea_consistent(internal, bytea, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bytea_consistent(internal, bytea, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bytea_consistent(internal, bytea, smallint, oid, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_bytea_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bytea_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bytea_penalty(internal, internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_bytea_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bytea_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bytea_picksplit(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_bytea_same(public.gbtreekey_var, public.gbtreekey_var, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bytea_same(public.gbtreekey_var, public.gbtreekey_var, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bytea_same(public.gbtreekey_var, public.gbtreekey_var, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_bytea_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bytea_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bytea_union(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_cash_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_cash_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_cash_compress(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_cash_consistent(internal, money, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_cash_consistent(internal, money, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_cash_consistent(internal, money, smallint, oid, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_cash_distance(internal, money, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_cash_distance(internal, money, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_cash_distance(internal, money, smallint, oid, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_cash_fetch(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_cash_fetch(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_cash_fetch(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_cash_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_cash_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_cash_penalty(internal, internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_cash_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_cash_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_cash_picksplit(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_cash_same(public.gbtreekey16, public.gbtreekey16, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_cash_same(public.gbtreekey16, public.gbtreekey16, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_cash_same(public.gbtreekey16, public.gbtreekey16, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_cash_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_cash_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_cash_union(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_date_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_date_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_date_compress(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_date_consistent(internal, date, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_date_consistent(internal, date, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_date_consistent(internal, date, smallint, oid, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_date_distance(internal, date, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_date_distance(internal, date, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_date_distance(internal, date, smallint, oid, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_date_fetch(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_date_fetch(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_date_fetch(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_date_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_date_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_date_penalty(internal, internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_date_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_date_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_date_picksplit(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_date_same(public.gbtreekey8, public.gbtreekey8, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_date_same(public.gbtreekey8, public.gbtreekey8, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_date_same(public.gbtreekey8, public.gbtreekey8, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_date_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_date_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_date_union(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_decompress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_decompress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_decompress(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_enum_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_enum_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_enum_compress(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_enum_consistent(internal, anyenum, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_enum_consistent(internal, anyenum, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_enum_consistent(internal, anyenum, smallint, oid, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_enum_fetch(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_enum_fetch(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_enum_fetch(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_enum_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_enum_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_enum_penalty(internal, internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_enum_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_enum_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_enum_picksplit(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_enum_same(public.gbtreekey8, public.gbtreekey8, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_enum_same(public.gbtreekey8, public.gbtreekey8, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_enum_same(public.gbtreekey8, public.gbtreekey8, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_enum_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_enum_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_enum_union(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_float4_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_float4_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_float4_compress(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_float4_consistent(internal, real, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_float4_consistent(internal, real, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_float4_consistent(internal, real, smallint, oid, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_float4_distance(internal, real, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_float4_distance(internal, real, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_float4_distance(internal, real, smallint, oid, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_float4_fetch(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_float4_fetch(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_float4_fetch(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_float4_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_float4_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_float4_penalty(internal, internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_float4_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_float4_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_float4_picksplit(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_float4_same(public.gbtreekey8, public.gbtreekey8, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_float4_same(public.gbtreekey8, public.gbtreekey8, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_float4_same(public.gbtreekey8, public.gbtreekey8, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_float4_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_float4_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_float4_union(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_float8_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_float8_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_float8_compress(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_float8_consistent(internal, double precision, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_float8_consistent(internal, double precision, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_float8_consistent(internal, double precision, smallint, oid, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_float8_distance(internal, double precision, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_float8_distance(internal, double precision, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_float8_distance(internal, double precision, smallint, oid, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_float8_fetch(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_float8_fetch(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_float8_fetch(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_float8_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_float8_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_float8_penalty(internal, internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_float8_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_float8_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_float8_picksplit(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_float8_same(public.gbtreekey16, public.gbtreekey16, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_float8_same(public.gbtreekey16, public.gbtreekey16, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_float8_same(public.gbtreekey16, public.gbtreekey16, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_float8_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_float8_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_float8_union(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_inet_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_inet_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_inet_compress(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_inet_consistent(internal, inet, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_inet_consistent(internal, inet, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_inet_consistent(internal, inet, smallint, oid, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_inet_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_inet_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_inet_penalty(internal, internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_inet_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_inet_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_inet_picksplit(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_inet_same(public.gbtreekey16, public.gbtreekey16, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_inet_same(public.gbtreekey16, public.gbtreekey16, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_inet_same(public.gbtreekey16, public.gbtreekey16, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_inet_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_inet_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_inet_union(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_int2_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int2_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int2_compress(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_int2_consistent(internal, smallint, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int2_consistent(internal, smallint, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int2_consistent(internal, smallint, smallint, oid, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_int2_distance(internal, smallint, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int2_distance(internal, smallint, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int2_distance(internal, smallint, smallint, oid, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_int2_fetch(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int2_fetch(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int2_fetch(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_int2_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int2_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int2_penalty(internal, internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_int2_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int2_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int2_picksplit(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_int2_same(public.gbtreekey4, public.gbtreekey4, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int2_same(public.gbtreekey4, public.gbtreekey4, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int2_same(public.gbtreekey4, public.gbtreekey4, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_int2_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int2_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int2_union(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_int4_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int4_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int4_compress(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_int4_consistent(internal, integer, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int4_consistent(internal, integer, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int4_consistent(internal, integer, smallint, oid, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_int4_distance(internal, integer, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int4_distance(internal, integer, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int4_distance(internal, integer, smallint, oid, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_int4_fetch(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int4_fetch(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int4_fetch(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_int4_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int4_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int4_penalty(internal, internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_int4_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int4_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int4_picksplit(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_int4_same(public.gbtreekey8, public.gbtreekey8, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int4_same(public.gbtreekey8, public.gbtreekey8, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int4_same(public.gbtreekey8, public.gbtreekey8, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_int4_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int4_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int4_union(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_int8_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int8_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int8_compress(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_int8_consistent(internal, bigint, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int8_consistent(internal, bigint, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int8_consistent(internal, bigint, smallint, oid, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_int8_distance(internal, bigint, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int8_distance(internal, bigint, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int8_distance(internal, bigint, smallint, oid, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_int8_fetch(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int8_fetch(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int8_fetch(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_int8_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int8_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int8_penalty(internal, internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_int8_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int8_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int8_picksplit(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_int8_same(public.gbtreekey16, public.gbtreekey16, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int8_same(public.gbtreekey16, public.gbtreekey16, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int8_same(public.gbtreekey16, public.gbtreekey16, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_int8_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int8_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int8_union(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_intv_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_intv_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_intv_compress(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_intv_consistent(internal, interval, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_intv_consistent(internal, interval, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_intv_consistent(internal, interval, smallint, oid, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_intv_decompress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_intv_decompress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_intv_decompress(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_intv_distance(internal, interval, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_intv_distance(internal, interval, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_intv_distance(internal, interval, smallint, oid, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_intv_fetch(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_intv_fetch(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_intv_fetch(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_intv_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_intv_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_intv_penalty(internal, internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_intv_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_intv_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_intv_picksplit(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_intv_same(public.gbtreekey32, public.gbtreekey32, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_intv_same(public.gbtreekey32, public.gbtreekey32, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_intv_same(public.gbtreekey32, public.gbtreekey32, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_intv_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_intv_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_intv_union(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_macad8_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_macad8_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_macad8_compress(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_macad8_consistent(internal, macaddr8, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_macad8_consistent(internal, macaddr8, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_macad8_consistent(internal, macaddr8, smallint, oid, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_macad8_fetch(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_macad8_fetch(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_macad8_fetch(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_macad8_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_macad8_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_macad8_penalty(internal, internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_macad8_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_macad8_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_macad8_picksplit(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_macad8_same(public.gbtreekey16, public.gbtreekey16, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_macad8_same(public.gbtreekey16, public.gbtreekey16, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_macad8_same(public.gbtreekey16, public.gbtreekey16, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_macad8_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_macad8_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_macad8_union(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_macad_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_macad_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_macad_compress(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_macad_consistent(internal, macaddr, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_macad_consistent(internal, macaddr, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_macad_consistent(internal, macaddr, smallint, oid, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_macad_fetch(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_macad_fetch(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_macad_fetch(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_macad_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_macad_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_macad_penalty(internal, internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_macad_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_macad_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_macad_picksplit(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_macad_same(public.gbtreekey16, public.gbtreekey16, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_macad_same(public.gbtreekey16, public.gbtreekey16, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_macad_same(public.gbtreekey16, public.gbtreekey16, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_macad_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_macad_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_macad_union(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_numeric_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_numeric_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_numeric_compress(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_numeric_consistent(internal, numeric, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_numeric_consistent(internal, numeric, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_numeric_consistent(internal, numeric, smallint, oid, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_numeric_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_numeric_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_numeric_penalty(internal, internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_numeric_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_numeric_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_numeric_picksplit(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_numeric_same(public.gbtreekey_var, public.gbtreekey_var, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_numeric_same(public.gbtreekey_var, public.gbtreekey_var, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_numeric_same(public.gbtreekey_var, public.gbtreekey_var, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_numeric_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_numeric_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_numeric_union(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_oid_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_oid_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_oid_compress(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_oid_consistent(internal, oid, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_oid_consistent(internal, oid, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_oid_consistent(internal, oid, smallint, oid, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_oid_distance(internal, oid, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_oid_distance(internal, oid, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_oid_distance(internal, oid, smallint, oid, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_oid_fetch(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_oid_fetch(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_oid_fetch(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_oid_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_oid_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_oid_penalty(internal, internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_oid_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_oid_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_oid_picksplit(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_oid_same(public.gbtreekey8, public.gbtreekey8, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_oid_same(public.gbtreekey8, public.gbtreekey8, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_oid_same(public.gbtreekey8, public.gbtreekey8, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_oid_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_oid_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_oid_union(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_text_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_text_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_text_compress(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_text_consistent(internal, text, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_text_consistent(internal, text, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_text_consistent(internal, text, smallint, oid, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_text_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_text_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_text_penalty(internal, internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_text_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_text_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_text_picksplit(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_text_same(public.gbtreekey_var, public.gbtreekey_var, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_text_same(public.gbtreekey_var, public.gbtreekey_var, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_text_same(public.gbtreekey_var, public.gbtreekey_var, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_text_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_text_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_text_union(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_time_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_time_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_time_compress(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_time_consistent(internal, time without time zone, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_time_consistent(internal, time without time zone, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_time_consistent(internal, time without time zone, smallint, oid, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_time_distance(internal, time without time zone, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_time_distance(internal, time without time zone, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_time_distance(internal, time without time zone, smallint, oid, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_time_fetch(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_time_fetch(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_time_fetch(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_time_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_time_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_time_penalty(internal, internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_time_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_time_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_time_picksplit(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_time_same(public.gbtreekey16, public.gbtreekey16, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_time_same(public.gbtreekey16, public.gbtreekey16, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_time_same(public.gbtreekey16, public.gbtreekey16, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_time_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_time_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_time_union(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_timetz_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_timetz_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_timetz_compress(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_timetz_consistent(internal, time with time zone, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_timetz_consistent(internal, time with time zone, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_timetz_consistent(internal, time with time zone, smallint, oid, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_ts_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_ts_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_ts_compress(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_ts_consistent(internal, timestamp without time zone, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_ts_consistent(internal, timestamp without time zone, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_ts_consistent(internal, timestamp without time zone, smallint, oid, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_ts_distance(internal, timestamp without time zone, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_ts_distance(internal, timestamp without time zone, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_ts_distance(internal, timestamp without time zone, smallint, oid, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_ts_fetch(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_ts_fetch(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_ts_fetch(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_ts_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_ts_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_ts_penalty(internal, internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_ts_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_ts_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_ts_picksplit(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_ts_same(public.gbtreekey16, public.gbtreekey16, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_ts_same(public.gbtreekey16, public.gbtreekey16, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_ts_same(public.gbtreekey16, public.gbtreekey16, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_ts_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_ts_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_ts_union(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_tstz_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_tstz_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_tstz_compress(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_tstz_consistent(internal, timestamp with time zone, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_tstz_consistent(internal, timestamp with time zone, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_tstz_consistent(internal, timestamp with time zone, smallint, oid, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_tstz_distance(internal, timestamp with time zone, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_tstz_distance(internal, timestamp with time zone, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_tstz_distance(internal, timestamp with time zone, smallint, oid, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_uuid_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_uuid_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_uuid_compress(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_uuid_consistent(internal, uuid, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_uuid_consistent(internal, uuid, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_uuid_consistent(internal, uuid, smallint, oid, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_uuid_fetch(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_uuid_fetch(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_uuid_fetch(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_uuid_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_uuid_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_uuid_penalty(internal, internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_uuid_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_uuid_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_uuid_picksplit(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_uuid_same(public.gbtreekey32, public.gbtreekey32, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_uuid_same(public.gbtreekey32, public.gbtreekey32, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_uuid_same(public.gbtreekey32, public.gbtreekey32, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_uuid_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_uuid_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_uuid_union(internal, internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_var_decompress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_var_decompress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_var_decompress(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbt_var_fetch(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_var_fetch(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_var_fetch(internal) TO dbtimetablesapi;

--
-- Name: FUNCTION gbtreekey16_in(cstring); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbtreekey16_in(cstring) TO dbhasura;
GRANT ALL ON FUNCTION public.gbtreekey16_in(cstring) TO dbtimetablesapi;

--
-- Name: FUNCTION gbtreekey16_out(public.gbtreekey16); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbtreekey16_out(public.gbtreekey16) TO dbhasura;
GRANT ALL ON FUNCTION public.gbtreekey16_out(public.gbtreekey16) TO dbtimetablesapi;

--
-- Name: FUNCTION gbtreekey2_in(cstring); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbtreekey2_in(cstring) TO dbhasura;
GRANT ALL ON FUNCTION public.gbtreekey2_in(cstring) TO dbtimetablesapi;

--
-- Name: FUNCTION gbtreekey2_out(public.gbtreekey2); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbtreekey2_out(public.gbtreekey2) TO dbhasura;
GRANT ALL ON FUNCTION public.gbtreekey2_out(public.gbtreekey2) TO dbtimetablesapi;

--
-- Name: FUNCTION gbtreekey32_in(cstring); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbtreekey32_in(cstring) TO dbhasura;
GRANT ALL ON FUNCTION public.gbtreekey32_in(cstring) TO dbtimetablesapi;

--
-- Name: FUNCTION gbtreekey32_out(public.gbtreekey32); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbtreekey32_out(public.gbtreekey32) TO dbhasura;
GRANT ALL ON FUNCTION public.gbtreekey32_out(public.gbtreekey32) TO dbtimetablesapi;

--
-- Name: FUNCTION gbtreekey4_in(cstring); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbtreekey4_in(cstring) TO dbhasura;
GRANT ALL ON FUNCTION public.gbtreekey4_in(cstring) TO dbtimetablesapi;

--
-- Name: FUNCTION gbtreekey4_out(public.gbtreekey4); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbtreekey4_out(public.gbtreekey4) TO dbhasura;
GRANT ALL ON FUNCTION public.gbtreekey4_out(public.gbtreekey4) TO dbtimetablesapi;

--
-- Name: FUNCTION gbtreekey8_in(cstring); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbtreekey8_in(cstring) TO dbhasura;
GRANT ALL ON FUNCTION public.gbtreekey8_in(cstring) TO dbtimetablesapi;

--
-- Name: FUNCTION gbtreekey8_out(public.gbtreekey8); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbtreekey8_out(public.gbtreekey8) TO dbhasura;
GRANT ALL ON FUNCTION public.gbtreekey8_out(public.gbtreekey8) TO dbtimetablesapi;

--
-- Name: FUNCTION gbtreekey_var_in(cstring); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbtreekey_var_in(cstring) TO dbhasura;
GRANT ALL ON FUNCTION public.gbtreekey_var_in(cstring) TO dbtimetablesapi;

--
-- Name: FUNCTION gbtreekey_var_out(public.gbtreekey_var); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbtreekey_var_out(public.gbtreekey_var) TO dbhasura;
GRANT ALL ON FUNCTION public.gbtreekey_var_out(public.gbtreekey_var) TO dbtimetablesapi;

--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gen_random_bytes(integer) TO dbhasura;
GRANT ALL ON FUNCTION public.gen_random_bytes(integer) TO dbtimetablesapi;

--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gen_random_uuid() TO dbhasura;
GRANT ALL ON FUNCTION public.gen_random_uuid() TO dbtimetablesapi;

--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gen_salt(text) TO dbhasura;
GRANT ALL ON FUNCTION public.gen_salt(text) TO dbtimetablesapi;

--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gen_salt(text, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.gen_salt(text, integer) TO dbtimetablesapi;

--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.hmac(bytea, bytea, text) TO dbhasura;
GRANT ALL ON FUNCTION public.hmac(bytea, bytea, text) TO dbtimetablesapi;

--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.hmac(text, text, text) TO dbhasura;
GRANT ALL ON FUNCTION public.hmac(text, text, text) TO dbtimetablesapi;

--
-- Name: FUNCTION int2_dist(smallint, smallint); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.int2_dist(smallint, smallint) TO dbhasura;
GRANT ALL ON FUNCTION public.int2_dist(smallint, smallint) TO dbtimetablesapi;

--
-- Name: FUNCTION int4_dist(integer, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.int4_dist(integer, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.int4_dist(integer, integer) TO dbtimetablesapi;

--
-- Name: FUNCTION int8_dist(bigint, bigint); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.int8_dist(bigint, bigint) TO dbhasura;
GRANT ALL ON FUNCTION public.int8_dist(bigint, bigint) TO dbtimetablesapi;

--
-- Name: FUNCTION interval_dist(interval, interval); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.interval_dist(interval, interval) TO dbhasura;
GRANT ALL ON FUNCTION public.interval_dist(interval, interval) TO dbtimetablesapi;

--
-- Name: FUNCTION oid_dist(oid, oid); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.oid_dist(oid, oid) TO dbhasura;
GRANT ALL ON FUNCTION public.oid_dist(oid, oid) TO dbtimetablesapi;

--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_armor_headers(text, OUT key text, OUT value text) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_armor_headers(text, OUT key text, OUT value text) TO dbtimetablesapi;

--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_key_id(bytea) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_key_id(bytea) TO dbtimetablesapi;

--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_pub_decrypt(bytea, bytea) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_pub_decrypt(bytea, bytea) TO dbtimetablesapi;

--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_pub_decrypt(bytea, bytea, text) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_pub_decrypt(bytea, bytea, text) TO dbtimetablesapi;

--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_pub_decrypt(bytea, bytea, text, text) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_pub_decrypt(bytea, bytea, text, text) TO dbtimetablesapi;

--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_pub_decrypt_bytea(bytea, bytea) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_pub_decrypt_bytea(bytea, bytea) TO dbtimetablesapi;

--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dbtimetablesapi;

--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dbtimetablesapi;

--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_pub_encrypt(text, bytea) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_pub_encrypt(text, bytea) TO dbtimetablesapi;

--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_pub_encrypt(text, bytea, text) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_pub_encrypt(text, bytea, text) TO dbtimetablesapi;

--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_pub_encrypt_bytea(bytea, bytea) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_pub_encrypt_bytea(bytea, bytea) TO dbtimetablesapi;

--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dbtimetablesapi;

--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_sym_decrypt(bytea, text) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_sym_decrypt(bytea, text) TO dbtimetablesapi;

--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_sym_decrypt(bytea, text, text) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_sym_decrypt(bytea, text, text) TO dbtimetablesapi;

--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_sym_decrypt_bytea(bytea, text) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_sym_decrypt_bytea(bytea, text) TO dbtimetablesapi;

--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_sym_decrypt_bytea(bytea, text, text) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_sym_decrypt_bytea(bytea, text, text) TO dbtimetablesapi;

--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_sym_encrypt(text, text) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_sym_encrypt(text, text) TO dbtimetablesapi;

--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_sym_encrypt(text, text, text) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_sym_encrypt(text, text, text) TO dbtimetablesapi;

--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_sym_encrypt_bytea(bytea, text) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_sym_encrypt_bytea(bytea, text) TO dbtimetablesapi;

--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_sym_encrypt_bytea(bytea, text, text) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_sym_encrypt_bytea(bytea, text, text) TO dbtimetablesapi;

--
-- Name: FUNCTION time_dist(time without time zone, time without time zone); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.time_dist(time without time zone, time without time zone) TO dbhasura;
GRANT ALL ON FUNCTION public.time_dist(time without time zone, time without time zone) TO dbtimetablesapi;

--
-- Name: FUNCTION ts_dist(timestamp without time zone, timestamp without time zone); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.ts_dist(timestamp without time zone, timestamp without time zone) TO dbhasura;
GRANT ALL ON FUNCTION public.ts_dist(timestamp without time zone, timestamp without time zone) TO dbtimetablesapi;

--
-- Name: FUNCTION tstz_dist(timestamp with time zone, timestamp with time zone); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.tstz_dist(timestamp with time zone, timestamp with time zone) TO dbhasura;
GRANT ALL ON FUNCTION public.tstz_dist(timestamp with time zone, timestamp with time zone) TO dbtimetablesapi;

--
-- Name: TABLE direction; Type: ACL; Schema: route; Owner: dbhasura
--

GRANT SELECT ON TABLE route.direction TO dbtimetablesapi;

--
-- Name: TABLE type_of_line; Type: ACL; Schema: route; Owner: dbhasura
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE route.type_of_line TO dbtimetablesapi;

--
-- Name: TABLE day_type; Type: ACL; Schema: service_calendar; Owner: dbhasura
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE service_calendar.day_type TO dbtimetablesapi;

--
-- Name: TABLE day_type_active_on_day_of_week; Type: ACL; Schema: service_calendar; Owner: dbhasura
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE service_calendar.day_type_active_on_day_of_week TO dbtimetablesapi;

--
-- Name: TABLE scheduled_stop_point_in_journey_pattern_ref; Type: ACL; Schema: service_pattern; Owner: dbhasura
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE service_pattern.scheduled_stop_point_in_journey_pattern_ref TO dbtimetablesapi;

--
-- Name: TABLE journey_type; Type: ACL; Schema: vehicle_journey; Owner: dbhasura
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE vehicle_journey.journey_type TO dbtimetablesapi;

--
-- Name: TABLE vehicle_journey; Type: ACL; Schema: vehicle_journey; Owner: dbhasura
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE vehicle_journey.vehicle_journey TO dbtimetablesapi;

--
-- Name: TABLE vehicle_schedule_frame; Type: ACL; Schema: vehicle_schedule; Owner: dbhasura
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE vehicle_schedule.vehicle_schedule_frame TO dbtimetablesapi;

--
-- Name: TABLE block; Type: ACL; Schema: vehicle_service; Owner: dbhasura
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE vehicle_service.block TO dbtimetablesapi;

--
-- Name: TABLE journey_patterns_in_vehicle_service; Type: ACL; Schema: vehicle_service; Owner: dbhasura
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE vehicle_service.journey_patterns_in_vehicle_service TO dbtimetablesapi;

--
-- Name: TABLE vehicle_service; Type: ACL; Schema: vehicle_service; Owner: dbhasura
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE vehicle_service.vehicle_service TO dbtimetablesapi;

--
-- Name: TABLE vehicle_type; Type: ACL; Schema: vehicle_type; Owner: dbhasura
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE vehicle_type.vehicle_type TO dbtimetablesapi;

--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';

--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';

--
-- Name: SCHEMA internal_service_calendar; Type: COMMENT; Schema: -; Owner: dbhasura
--

COMMENT ON SCHEMA internal_service_calendar IS 'This schema is used for the internal SQL functions that are related to service_calendar schema. These internal functions are
not exposed to GraphQL API, hence the prefix.';

--
-- Name: SCHEMA internal_utils; Type: COMMENT; Schema: -; Owner: dbhasura
--

COMMENT ON SCHEMA internal_utils IS 'Internal general utilities. Functions in this schema are not exposed to GraphQL API, hence the prefix.';

--
-- Name: SCHEMA journey_pattern; Type: COMMENT; Schema: -; Owner: dbhasura
--

COMMENT ON SCHEMA journey_pattern IS 'The journey pattern model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:1:683 ';

--
-- Name: SCHEMA passing_times; Type: COMMENT; Schema: -; Owner: dbhasura
--

COMMENT ON SCHEMA passing_times IS 'The passing times model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=3:4:939 ';

--
-- Name: SCHEMA return_value; Type: COMMENT; Schema: -; Owner: dbhasura
--

COMMENT ON SCHEMA return_value IS 'This schema is used for all the SQL functions that need to have a table as return value. Nothing is stored in the tables in this schema.';

--
-- Name: SCHEMA route; Type: COMMENT; Schema: -; Owner: dbhasura
--

COMMENT ON SCHEMA route IS 'The route model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:1:3:416';

--
-- Name: SCHEMA service_calendar; Type: COMMENT; Schema: -; Owner: dbhasura
--

COMMENT ON SCHEMA service_calendar IS 'The service calendar model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=1:6:3:294 ';

--
-- Name: SCHEMA service_pattern; Type: COMMENT; Schema: -; Owner: dbhasura
--

COMMENT ON SCHEMA service_pattern IS 'The service pattern model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:4:723 ';

--
-- Name: SCHEMA vehicle_journey; Type: COMMENT; Schema: -; Owner: dbhasura
--

COMMENT ON SCHEMA vehicle_journey IS 'The vehicle journey model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=3:1:1:824 ';

--
-- Name: SCHEMA vehicle_schedule; Type: COMMENT; Schema: -; Owner: dbhasura
--

COMMENT ON SCHEMA vehicle_schedule IS 'The vehicle schedule frame adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=3:7:2:993 ';

--
-- Name: SCHEMA vehicle_service; Type: COMMENT; Schema: -; Owner: dbhasura
--

COMMENT ON SCHEMA vehicle_service IS 'The vehicle service model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=3:5:947 ';

--
-- Name: FUNCTION create_validation_queue_temp_tables(); Type: COMMENT; Schema: internal_utils; Owner: dbhasura
--

COMMENT ON FUNCTION internal_utils.create_validation_queue_temp_tables() IS 'Create the temp tables used to enqueue validation of the changed rows from statement-level triggers.';

--
-- Name: FUNCTION execute_queued_validations(); Type: COMMENT; Schema: internal_utils; Owner: dbhasura
--

COMMENT ON FUNCTION internal_utils.execute_queued_validations() IS 'Runs all queued validations. This is intended to be ran only once per transaction (see queued_validations_already_processed).';

--
-- Name: FUNCTION queued_validations_already_processed(); Type: COMMENT; Schema: internal_utils; Owner: dbhasura
--

COMMENT ON FUNCTION internal_utils.queued_validations_already_processed() IS 'Keep track of whether the queued validations have already been processed in this transaction';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: COLUMN journey_pattern_ref.journey_pattern_id; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON COLUMN journey_pattern.journey_pattern_ref.journey_pattern_id IS 'The ID of the referenced JOURNEY PATTERN';

--
-- Name: COLUMN journey_pattern_ref.observation_timestamp; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON COLUMN journey_pattern.journey_pattern_ref.observation_timestamp IS 'The user-given point of time used to pick one journey pattern (with route and scheduled stop points) among possibly many variants. The selected, unambiguous journey pattern variant is used as a basis for schedule planning.';

--
-- Name: COLUMN journey_pattern_ref.route_direction; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON COLUMN journey_pattern.journey_pattern_ref.route_direction IS 'The direction of the route associated with the referenced journey pattern';

--
-- Name: COLUMN journey_pattern_ref.route_label; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON COLUMN journey_pattern.journey_pattern_ref.route_label IS 'The label of the route associated with the referenced journey pattern';

--
-- Name: COLUMN journey_pattern_ref.route_validity_end; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON COLUMN journey_pattern.journey_pattern_ref.route_validity_end IS 'The end date of the validity period of the route associated with the referenced journey pattern. If NULL, then the end of the validity period is unbounded (infinity).';

--
-- Name: COLUMN journey_pattern_ref.route_validity_start; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON COLUMN journey_pattern.journey_pattern_ref.route_validity_start IS 'The start date of the validity period of the route associated with the referenced journey pattern. If NULL, then the start of the validity period is unbounded (-infinity).';

--
-- Name: COLUMN journey_pattern_ref.snapshot_timestamp; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON COLUMN journey_pattern.journey_pattern_ref.snapshot_timestamp IS 'The timestamp when the snapshot was taken';

--
-- Name: COLUMN journey_pattern_ref.type_of_line; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON COLUMN journey_pattern.journey_pattern_ref.type_of_line IS 'The type of line (GTFS route type): https://developers.google.com/transit/gtfs/reference/extended-route-types';

--
-- Name: FUNCTION queue_validation_by_jpr_id(); Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON FUNCTION journey_pattern.queue_validation_by_jpr_id() IS 'Queue modified journey pattern refs for validation which is performed at the end of transaction.';

--
-- Name: TABLE journey_pattern_ref; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON TABLE journey_pattern.journey_pattern_ref IS 'Reference to a given snapshot of a JOURNEY PATTERN for a given operating day. Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:4:729 ';

--
-- Name: TRIGGER process_queued_validation_on_jpr_trigger ON journey_pattern_ref; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON TRIGGER process_queued_validation_on_jpr_trigger ON journey_pattern.journey_pattern_ref IS 'Trigger to execute queued validations at the end of the transaction that were registered earlier by statement level triggers';

--
-- Name: TRIGGER queue_jpr_validation_on_insert_trigger ON journey_pattern_ref; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON TRIGGER queue_jpr_validation_on_insert_trigger ON journey_pattern.journey_pattern_ref IS 'Trigger for queuing inserted journey pattern refs for later validation.
Actual validation is performed at the end of transaction by execute_queued_validations().';

--
-- Name: TRIGGER queue_jpr_validation_on_update_trigger ON journey_pattern_ref; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON TRIGGER queue_jpr_validation_on_update_trigger ON journey_pattern.journey_pattern_ref IS 'Trigger for queuing updated journey pattern refs for later validation.
Actual validation is performed at the end of transaction by execute_queued_validations().';

--
-- Name: COLUMN timetabled_passing_time.arrival_time; Type: COMMENT; Schema: passing_times; Owner: dbhasura
--

COMMENT ON COLUMN passing_times.timetabled_passing_time.arrival_time IS 'The time when the vehicle arrives to the SCHEDULED STOP POINT. Measured as interval counted from the midnight of the OPERATING DAY. When NULL, only the departure time is defined for the passing time. E.g. in case this is the first SCHEDULED STOP POINT of the journey.';

--
-- Name: COLUMN timetabled_passing_time.departure_time; Type: COMMENT; Schema: passing_times; Owner: dbhasura
--

COMMENT ON COLUMN passing_times.timetabled_passing_time.departure_time IS 'The time when the vehicle departs from the SCHEDULED STOP POINT. Measured as interval counted from the midnight of the OPERATING DAY. When NULL, only the arrival time is defined for the passing time. E.g. in case this is the last SCHEDULED STOP POINT of the journey.';

--
-- Name: COLUMN timetabled_passing_time.passing_time; Type: COMMENT; Schema: passing_times; Owner: dbhasura
--

COMMENT ON COLUMN passing_times.timetabled_passing_time.passing_time IS 'The time when the vehicle can be considered as passing a SCHEDULED STOP POINT. Computed field to ease development; it can never be NULL.';

--
-- Name: COLUMN timetabled_passing_time.scheduled_stop_point_in_journey_pattern_ref_id; Type: COMMENT; Schema: passing_times; Owner: dbhasura
--

COMMENT ON COLUMN passing_times.timetabled_passing_time.scheduled_stop_point_in_journey_pattern_ref_id IS 'The SCHEDULED STOP POINT of the JOURNEY PATTERN where the vehicle passes';

--
-- Name: COLUMN timetabled_passing_time.vehicle_journey_id; Type: COMMENT; Schema: passing_times; Owner: dbhasura
--

COMMENT ON COLUMN passing_times.timetabled_passing_time.vehicle_journey_id IS 'The VEHICLE JOURNEY to which this TIMETABLED PASSING TIME belongs';

--
-- Name: FUNCTION get_passing_time_order_validity_data(filter_vehicle_journey_ids uuid[], filter_journey_pattern_ref_ids uuid[]); Type: COMMENT; Schema: passing_times; Owner: dbhasura
--

COMMENT ON FUNCTION passing_times.get_passing_time_order_validity_data(filter_vehicle_journey_ids uuid[], filter_journey_pattern_ref_ids uuid[]) IS '
  For vehicle journey passing time sequences in given vehicle journeys and/or journey patterns,
  returns information on the sequence and its validity:
  id of the vehicle journey, ids of first and last passing times in the sequence,
  and whether all passing times for the vehicle journey are in stop point sequence order, that is,
  in same order by passing_time as their corresponding stop points (scheduled_stop_point_in_journey_pattern_ref).';

--
-- Name: FUNCTION validate_passing_time_sequences(); Type: COMMENT; Schema: passing_times; Owner: dbhasura
--

COMMENT ON FUNCTION passing_times.validate_passing_time_sequences() IS 'Perform validation of all passing time sequences that have been added to the temporary queue table.
    Raise an exception if the there are any inconsistencies in passing times and their stop point sequences,
    or if arrival_time or departure_time are not defined properly.';

--
-- Name: TABLE timetabled_passing_time; Type: COMMENT; Schema: passing_times; Owner: dbhasura
--

COMMENT ON TABLE passing_times.timetabled_passing_time IS 'Long-term planned time data concerning public transport vehicles passing a particular POINT IN JOURNEY PATTERN on a specified VEHICLE JOURNEY for a certain DAY TYPE. Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=3:4:946 ';

--
-- Name: TRIGGER process_queued_validation_on_pt_trigger ON timetabled_passing_time; Type: COMMENT; Schema: passing_times; Owner: dbhasura
--

COMMENT ON TRIGGER process_queued_validation_on_pt_trigger ON passing_times.timetabled_passing_time IS 'Trigger to execute queued validations at the end of the transaction that were registered earlier by statement level triggers';

--
-- Name: TRIGGER queue_vj_validation_on_pt_delete_trigger ON timetabled_passing_time; Type: COMMENT; Schema: passing_times; Owner: dbhasura
--

COMMENT ON TRIGGER queue_vj_validation_on_pt_delete_trigger ON passing_times.timetabled_passing_time IS 'Trigger to queue validation of parent vehicle_journey on timetabled_passing_times delete.
Actual validation is performed at the end of transaction by execute_queued_validations().';

--
-- Name: TRIGGER queue_vj_validation_on_pt_insert_trigger ON timetabled_passing_time; Type: COMMENT; Schema: passing_times; Owner: dbhasura
--

COMMENT ON TRIGGER queue_vj_validation_on_pt_insert_trigger ON passing_times.timetabled_passing_time IS 'Trigger to queue validation of parent vehicle_journey on timetabled_passing_times insert.
Actual validation is performed at the end of transaction by execute_queued_validations().';

--
-- Name: TRIGGER queue_vj_validation_on_pt_update_trigger ON timetabled_passing_time; Type: COMMENT; Schema: passing_times; Owner: dbhasura
--

COMMENT ON TRIGGER queue_vj_validation_on_pt_update_trigger ON passing_times.timetabled_passing_time IS 'Trigger to queue validation of parent vehicle_journey on timetabled_passing_times update.
Actual validation is performed at the end of transaction by execute_queued_validations().';

--
-- Name: COLUMN direction.direction; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.direction.direction IS 'The name of the route direction';

--
-- Name: COLUMN direction.the_opposite_of_direction; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.direction.the_opposite_of_direction IS 'The opposite direction';

--
-- Name: COLUMN type_of_line.type_of_line; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.type_of_line.type_of_line IS 'GTFS route type: https://developers.google.com/transit/gtfs/reference/extended-route-types';

--
-- Name: TABLE direction; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON TABLE route.direction IS 'The route directions from Transmodel';

--
-- Name: TABLE type_of_line; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON TABLE route.type_of_line IS 'Type of line. https://www.transmodel-cen.eu/model/index.htm?goto=2:1:3:424';

--
-- Name: COLUMN day_type.label; Type: COMMENT; Schema: service_calendar; Owner: dbhasura
--

COMMENT ON COLUMN service_calendar.day_type.label IS 'The label for the DAY TYPE. Used for identifying the DAY TYPE when importing data from Hastus. Includes both basic (e.g. "Monday-Thursday") and special ("Easter Sunday") day types';

--
-- Name: COLUMN day_type.name_i18n; Type: COMMENT; Schema: service_calendar; Owner: dbhasura
--

COMMENT ON COLUMN service_calendar.day_type.name_i18n IS 'Human-readable name for the DAY TYPE';

--
-- Name: COLUMN day_type_active_on_day_of_week.day_of_week; Type: COMMENT; Schema: service_calendar; Owner: dbhasura
--

COMMENT ON COLUMN service_calendar.day_type_active_on_day_of_week.day_of_week IS 'ISO week day definition (1 = Monday, 7 = Sunday)';

--
-- Name: COLUMN day_type_active_on_day_of_week.day_type_id; Type: COMMENT; Schema: service_calendar; Owner: dbhasura
--

COMMENT ON COLUMN service_calendar.day_type_active_on_day_of_week.day_type_id IS 'The DAY TYPE for which we define the activeness';

--
-- Name: TABLE day_type; Type: COMMENT; Schema: service_calendar; Owner: dbhasura
--

COMMENT ON TABLE service_calendar.day_type IS 'A type of day characterised by one or more properties which affect public transport operation. For example: weekday in school holidays. Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=1:6:3:299 ';

--
-- Name: TABLE day_type_active_on_day_of_week; Type: COMMENT; Schema: service_calendar; Owner: dbhasura
--

COMMENT ON TABLE service_calendar.day_type_active_on_day_of_week IS 'Tells on which days of week a particular DAY TYPE is active';

--
-- Name: COLUMN scheduled_stop_point_in_journey_pattern_ref.journey_pattern_ref_id; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.scheduled_stop_point_in_journey_pattern_ref.journey_pattern_ref_id IS 'JOURNEY PATTERN to which the SCHEDULED STOP POINT belongs';

--
-- Name: COLUMN scheduled_stop_point_in_journey_pattern_ref.scheduled_stop_point_label; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.scheduled_stop_point_in_journey_pattern_ref.scheduled_stop_point_label IS 'The label of the SCHEDULED STOP POINT';

--
-- Name: COLUMN scheduled_stop_point_in_journey_pattern_ref.scheduled_stop_point_sequence; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.scheduled_stop_point_in_journey_pattern_ref.scheduled_stop_point_sequence IS 'The order of the SCHEDULED STOP POINT within the JOURNEY PATTERN.';

--
-- Name: COLUMN scheduled_stop_point_in_journey_pattern_ref.timing_place_label; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.scheduled_stop_point_in_journey_pattern_ref.timing_place_label IS 'The label of the timing place associated with the referenced scheduled stop point in journey pattern';

--
-- Name: TABLE scheduled_stop_point_in_journey_pattern_ref; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON TABLE service_pattern.scheduled_stop_point_in_journey_pattern_ref IS 'Reference the a SCHEDULED STOP POINT within a JOURNEY PATTERN. Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:4:729 ';

--
-- Name: TRIGGER process_queued_validation_on_ssp_trigger ON scheduled_stop_point_in_journey_pattern_ref; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON TRIGGER process_queued_validation_on_ssp_trigger ON service_pattern.scheduled_stop_point_in_journey_pattern_ref IS 'Trigger to execute queued validations at the end of the transaction that were registered earlier by statement level triggers';

--
-- Name: TRIGGER queue_jpr_validation_on_ssp_insert_trigger ON scheduled_stop_point_in_journey_pattern_ref; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON TRIGGER queue_jpr_validation_on_ssp_insert_trigger ON service_pattern.scheduled_stop_point_in_journey_pattern_ref IS 'Trigger to queue validation of parent journey_pattern_ref on scheduled_stop_point_in_journey_pattern_ref insert.
Actual validation is performed at the end of transaction by execute_queued_validations().';

--
-- Name: TRIGGER queue_jpr_validation_on_ssp_update_trigger ON scheduled_stop_point_in_journey_pattern_ref; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON TRIGGER queue_jpr_validation_on_ssp_update_trigger ON service_pattern.scheduled_stop_point_in_journey_pattern_ref IS 'Trigger to queue validation of parent journey_pattern_ref on scheduled_stop_point_in_journey_pattern_ref update.
Actual validation is performed at the end of transaction by execute_queued_validations().';

--
-- Name: COLUMN vehicle_journey.block_id; Type: COMMENT; Schema: vehicle_journey; Owner: dbhasura
--

COMMENT ON COLUMN vehicle_journey.vehicle_journey.block_id IS 'The BLOCK to which this VEHICLE JOURNEY belongs';

--
-- Name: COLUMN vehicle_journey.journey_name_i18n; Type: COMMENT; Schema: vehicle_journey; Owner: dbhasura
--

COMMENT ON COLUMN vehicle_journey.vehicle_journey.journey_name_i18n IS 'Name that user can give to the vehicle journey.';

--
-- Name: COLUMN vehicle_journey.journey_pattern_ref_id; Type: COMMENT; Schema: vehicle_journey; Owner: dbhasura
--

COMMENT ON COLUMN vehicle_journey.vehicle_journey.journey_pattern_ref_id IS 'The JOURNEY PATTERN on which the VEHICLE JOURNEY travels';

--
-- Name: COLUMN vehicle_journey.journey_type; Type: COMMENT; Schema: vehicle_journey; Owner: dbhasura
--

COMMENT ON COLUMN vehicle_journey.vehicle_journey.journey_type IS 'STANDARD | DRY_RUN | SERVICE_JOURNEY';

--
-- Name: COLUMN vehicle_journey.layover_time; Type: COMMENT; Schema: vehicle_journey; Owner: dbhasura
--

COMMENT ON COLUMN vehicle_journey.vehicle_journey.layover_time IS 'LAYOVER TIMEs describe a certain time allowance that may be given at the end of each VEHICLE JOURNEY, before starting the next one, to compensate delays or for other purposes (e.g. rest time for the driver). This “layover time” can be regarded as a buffer time, which may or may not be actually consumed in real time operation.';

--
-- Name: COLUMN vehicle_journey.turnaround_time; Type: COMMENT; Schema: vehicle_journey; Owner: dbhasura
--

COMMENT ON COLUMN vehicle_journey.vehicle_journey.turnaround_time IS 'Turnaround time is the time taken by a vehicle to proceed from the end of a ROUTE to the start of another.';

--
-- Name: FUNCTION queue_validation_by_vj_id(); Type: COMMENT; Schema: vehicle_journey; Owner: dbhasura
--

COMMENT ON FUNCTION vehicle_journey.queue_validation_by_vj_id() IS 'Queue modified vehicle journeys for validation which is performed at the end of transaction.';

--
-- Name: TABLE journey_type; Type: COMMENT; Schema: vehicle_journey; Owner: dbhasura
--

COMMENT ON TABLE vehicle_journey.journey_type IS 'Enum table for defining allowed journey types.';

--
-- Name: TABLE vehicle_journey; Type: COMMENT; Schema: vehicle_journey; Owner: dbhasura
--

COMMENT ON TABLE vehicle_journey.vehicle_journey IS 'The planned movement of a public transport vehicle on a DAY TYPE from the start point to the end point of a JOURNEY PATTERN on a specified ROUTE. Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=3:1:1:831 ';

--
-- Name: TRIGGER process_queued_validation_on_vj_trigger ON vehicle_journey; Type: COMMENT; Schema: vehicle_journey; Owner: dbhasura
--

COMMENT ON TRIGGER process_queued_validation_on_vj_trigger ON vehicle_journey.vehicle_journey IS 'Trigger to execute queued validations at the end of the transaction that were registered earlier by statement level triggers';

--
-- Name: TRIGGER queue_vj_validation_on_insert_trigger ON vehicle_journey; Type: COMMENT; Schema: vehicle_journey; Owner: dbhasura
--

COMMENT ON TRIGGER queue_vj_validation_on_insert_trigger ON vehicle_journey.vehicle_journey IS 'Trigger for queuing inserted vehicle journeys for later validation.
Actual validation is performed at the end of transaction by execute_queued_validations().';

--
-- Name: TRIGGER queue_vj_validation_on_update_trigger ON vehicle_journey; Type: COMMENT; Schema: vehicle_journey; Owner: dbhasura
--

COMMENT ON TRIGGER queue_vj_validation_on_update_trigger ON vehicle_journey.vehicle_journey IS 'Trigger for queuing updated vehicle journeys for later validation.
Actual validation is performed at the end of transaction by execute_queued_validations().';

--
-- Name: COLUMN vehicle_schedule_frame.label; Type: COMMENT; Schema: vehicle_schedule; Owner: dbhasura
--

COMMENT ON COLUMN vehicle_schedule.vehicle_schedule_frame.label IS 'Label for the vehicle schedule frame. Comes from BookingRecord vsc_name field from Hastus.';

--
-- Name: COLUMN vehicle_schedule_frame.name_i18n; Type: COMMENT; Schema: vehicle_schedule; Owner: dbhasura
--

COMMENT ON COLUMN vehicle_schedule.vehicle_schedule_frame.name_i18n IS 'Human-readable name for the VEHICLE SCHEDULE FRAME';

--
-- Name: COLUMN vehicle_schedule_frame.priority; Type: COMMENT; Schema: vehicle_schedule; Owner: dbhasura
--

COMMENT ON COLUMN vehicle_schedule.vehicle_schedule_frame.priority IS 'The priority of the timetable definition. The definition may be overridden by higher priority definitions.';

--
-- Name: COLUMN vehicle_schedule_frame.validity_end; Type: COMMENT; Schema: vehicle_schedule; Owner: dbhasura
--

COMMENT ON COLUMN vehicle_schedule.vehicle_schedule_frame.validity_end IS 'OPERATING DAY when the VEHICLE SCHEDULE FRAME validity ends (inclusive). Null if always will be valid.';

--
-- Name: COLUMN vehicle_schedule_frame.validity_range; Type: COMMENT; Schema: vehicle_schedule; Owner: dbhasura
--

COMMENT ON COLUMN vehicle_schedule.vehicle_schedule_frame.validity_range IS '
A denormalized column for actual daterange when vehicle schedule frame is valid,
that is, a closed date range [validity_start, validity_end].
Added to make working with PostgreSQL functions easier:
they typically expect ranges to be half closed.';

--
-- Name: COLUMN vehicle_schedule_frame.validity_start; Type: COMMENT; Schema: vehicle_schedule; Owner: dbhasura
--

COMMENT ON COLUMN vehicle_schedule.vehicle_schedule_frame.validity_start IS 'OPERATING DAY when the VEHICLE SCHEDULE FRAME validity starts (inclusive). Null if always has been valid.';

--
-- Name: FUNCTION get_overlapping_schedules(filter_vehicle_schedule_frame_ids uuid[], filter_journey_pattern_ref_ids uuid[], ignore_priority boolean); Type: COMMENT; Schema: vehicle_schedule; Owner: dbhasura
--

COMMENT ON FUNCTION vehicle_schedule.get_overlapping_schedules(filter_vehicle_schedule_frame_ids uuid[], filter_journey_pattern_ref_ids uuid[], ignore_priority boolean) IS 'Returns information on all schedules that are overlapping.
  Two vehicle_schedule_frames will be considered overlapping if they have:
  - are valid on the same day (validity_range, active_on_day_of_week)
  - have any vehicle_journeys for same journey_patterns

  By default (ignore_priority = false) the schedules must also have same priority to be considered overlapping.
  Schedules with priority Draft or Staging are exempt from this constraint.
  To bypass these priority checks completely, ignore_priority = true can be used.
';

--
-- Name: FUNCTION queue_validation_by_vsf_id(); Type: COMMENT; Schema: vehicle_schedule; Owner: dbhasura
--

COMMENT ON FUNCTION vehicle_schedule.queue_validation_by_vsf_id() IS 'Queue modified vehicle schedule frames for validation which is performed at the end of transaction.';

--
-- Name: FUNCTION validate_queued_schedules_uniqueness(); Type: COMMENT; Schema: vehicle_schedule; Owner: dbhasura
--

COMMENT ON FUNCTION vehicle_schedule.validate_queued_schedules_uniqueness() IS 'Performs validation on schedules, checking that there are no overlapping schedules.
  Essentially runs get_overlapping_schedules for all modified rows
  and throws an error if any overlapping schedules are detected.';

--
-- Name: TABLE vehicle_schedule_frame; Type: COMMENT; Schema: vehicle_schedule; Owner: dbhasura
--

COMMENT ON TABLE vehicle_schedule.vehicle_schedule_frame IS 'A coherent set of BLOCKS, COMPOUND BLOCKs, COURSEs of JOURNEY and VEHICLE SCHEDULEs to which the same set of VALIDITY CONDITIONs have been assigned. Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=3:7:2:993 ';

--
-- Name: TRIGGER process_queued_validation_on_vsf_trigger ON vehicle_schedule_frame; Type: COMMENT; Schema: vehicle_schedule; Owner: dbhasura
--

COMMENT ON TRIGGER process_queued_validation_on_vsf_trigger ON vehicle_schedule.vehicle_schedule_frame IS 'Trigger to execute queued validations at the end of the transaction that were registered earlier by statement level triggers';

--
-- Name: TRIGGER queue_vsf_validation_on_insert_trigger ON vehicle_schedule_frame; Type: COMMENT; Schema: vehicle_schedule; Owner: dbhasura
--

COMMENT ON TRIGGER queue_vsf_validation_on_insert_trigger ON vehicle_schedule.vehicle_schedule_frame IS 'Trigger for queuing inserted vehicle schedule frames for later validation.
Actual validation is performed at the end of transaction by execute_queued_validations().';

--
-- Name: TRIGGER queue_vsf_validation_on_update_trigger ON vehicle_schedule_frame; Type: COMMENT; Schema: vehicle_schedule; Owner: dbhasura
--

COMMENT ON TRIGGER queue_vsf_validation_on_update_trigger ON vehicle_schedule.vehicle_schedule_frame IS 'Trigger for queuing updated vehicle schedule frames for later validation.
Actual validation is performed at the end of transaction by execute_queued_validations().';

--
-- Name: COLUMN block.finishing_time; Type: COMMENT; Schema: vehicle_service; Owner: dbhasura
--

COMMENT ON COLUMN vehicle_service.block.finishing_time IS 'Finishing time after end of vehicle service block.';

--
-- Name: COLUMN block.preparing_time; Type: COMMENT; Schema: vehicle_service; Owner: dbhasura
--

COMMENT ON COLUMN vehicle_service.block.preparing_time IS 'Preparation time before start of vehicle service block.';

--
-- Name: COLUMN block.vehicle_service_id; Type: COMMENT; Schema: vehicle_service; Owner: dbhasura
--

COMMENT ON COLUMN vehicle_service.block.vehicle_service_id IS 'The VEHICLE SERVICE to which this BLOCK belongs.';

--
-- Name: COLUMN block.vehicle_type_id; Type: COMMENT; Schema: vehicle_service; Owner: dbhasura
--

COMMENT ON COLUMN vehicle_service.block.vehicle_type_id IS 'Reference to vehicle_type.vehicle_type.';

--
-- Name: COLUMN journey_patterns_in_vehicle_service.journey_pattern_id; Type: COMMENT; Schema: vehicle_service; Owner: dbhasura
--

COMMENT ON COLUMN vehicle_service.journey_patterns_in_vehicle_service.journey_pattern_id IS 'The journey_pattern_id from journey_pattern.journey_pattern_ref.
 No foreign key reference is set because the target column is not unique.';

--
-- Name: COLUMN journey_patterns_in_vehicle_service.reference_count; Type: COMMENT; Schema: vehicle_service; Owner: dbhasura
--

COMMENT ON COLUMN vehicle_service.journey_patterns_in_vehicle_service.reference_count IS 'The amount of unique references between the journey_pattern and vehicle_service.
  When this reaches 0 the row will be deleted.';

--
-- Name: COLUMN vehicle_service.day_type_id; Type: COMMENT; Schema: vehicle_service; Owner: dbhasura
--

COMMENT ON COLUMN vehicle_service.vehicle_service.day_type_id IS 'The DAY TYPE for the VEHICLE SERVICE.';

--
-- Name: COLUMN vehicle_service.name_i18n; Type: COMMENT; Schema: vehicle_service; Owner: dbhasura
--

COMMENT ON COLUMN vehicle_service.vehicle_service.name_i18n IS 'Name for vehicle service.';

--
-- Name: COLUMN vehicle_service.vehicle_schedule_frame_id; Type: COMMENT; Schema: vehicle_service; Owner: dbhasura
--

COMMENT ON COLUMN vehicle_service.vehicle_service.vehicle_schedule_frame_id IS 'Human-readable name for the VEHICLE SCHEDULE FRAME';

--
-- Name: FUNCTION get_vehicle_service_timing_data(vehicle_service_ids uuid[]); Type: COMMENT; Schema: vehicle_service; Owner: dbhasura
--

COMMENT ON FUNCTION vehicle_service.get_vehicle_service_timing_data(vehicle_service_ids uuid[]) IS 'A helper function for sequential integrity validation.
For given vehicle_services, returns the blocks, journeys and timetabled passing times that they contain,
and start and end times for each level.';

--
-- Name: FUNCTION queue_validation_by_block_id(); Type: COMMENT; Schema: vehicle_service; Owner: dbhasura
--

COMMENT ON FUNCTION vehicle_service.queue_validation_by_block_id() IS 'Queue modified vehicle service blocks for validation which is performed at the end of transaction.';

--
-- Name: FUNCTION queue_validation_by_vs_id(); Type: COMMENT; Schema: vehicle_service; Owner: dbhasura
--

COMMENT ON FUNCTION vehicle_service.queue_validation_by_vs_id() IS 'Queue modified vehicle services for validation which is performed at the end of transaction.';

--
-- Name: FUNCTION refresh_journey_patterns_in_vehicle_service(); Type: COMMENT; Schema: vehicle_service; Owner: dbhasura
--

COMMENT ON FUNCTION vehicle_service.refresh_journey_patterns_in_vehicle_service() IS 'Rebuilds the whole journey_patterns_in_vehicle_service table.';

--
-- Name: FUNCTION validate_service_sequential_integrity(); Type: COMMENT; Schema: vehicle_service; Owner: dbhasura
--

COMMENT ON FUNCTION vehicle_service.validate_service_sequential_integrity() IS 'Performs validation of sequential integrity on modified vehicle_services:
    throws an error if there are any overlapping blocks or vehicle_journeys within a vehicle_service.
    The timing data is collected with vehicle_service.get_vehicle_service_timing_data function.';

--
-- Name: TABLE block; Type: COMMENT; Schema: vehicle_service; Owner: dbhasura
--

COMMENT ON TABLE vehicle_service.block IS 'The work of a vehicle from the time it leaves a PARKING POINT after parking until its next return to park at a PARKING POINT. Any subsequent departure from a PARKING POINT after parking marks the start of a new BLOCK. The period of a BLOCK has to be covered by DUTies. Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=3:5:958 ';

--
-- Name: TABLE journey_patterns_in_vehicle_service; Type: COMMENT; Schema: vehicle_service; Owner: dbhasura
--

COMMENT ON TABLE vehicle_service.journey_patterns_in_vehicle_service IS 'A denormalized table containing relationships between vehicle_services and journey_patterns (via journey_pattern_ref.journey_pattern_id).
 Without this table this relationship could be found via vehicle_service -> block -> vehicle_journey -> journey_pattern_ref.
 Kept up to date with triggers, should not be updated manually.';

--
-- Name: TABLE vehicle_service; Type: COMMENT; Schema: vehicle_service; Owner: dbhasura
--

COMMENT ON TABLE vehicle_service.vehicle_service IS 'A work plan for a single vehicle for a whole day, planned for a specific DAY TYPE. A VEHICLE SERVICE includes one or several BLOCKs. If there is no service on a given day, it does not include any BLOCKs. Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=3:5:965 ';

--
-- Name: TRIGGER process_queued_validation_on_block_trigger ON block; Type: COMMENT; Schema: vehicle_service; Owner: dbhasura
--

COMMENT ON TRIGGER process_queued_validation_on_block_trigger ON vehicle_service.block IS 'Trigger to execute queued validations at the end of the transaction that were registered earlier by statement level triggers';

--
-- Name: TRIGGER process_queued_validation_on_vs_trigger ON vehicle_service; Type: COMMENT; Schema: vehicle_service; Owner: dbhasura
--

COMMENT ON TRIGGER process_queued_validation_on_vs_trigger ON vehicle_service.vehicle_service IS 'Trigger to execute queued validations at the end of the transaction that were registered earlier by statement level triggers';

--
-- Name: TRIGGER queue_block_validation_on_update_trigger ON block; Type: COMMENT; Schema: vehicle_service; Owner: dbhasura
--

COMMENT ON TRIGGER queue_block_validation_on_update_trigger ON vehicle_service.block IS 'Trigger for queuing updated vehicle service blocks for later validation.
Actual validation is performed at the end of transaction by execute_queued_validations().';

--
-- Name: TRIGGER queue_vs_validation_on_update_trigger ON vehicle_service; Type: COMMENT; Schema: vehicle_service; Owner: dbhasura
--

COMMENT ON TRIGGER queue_vs_validation_on_update_trigger ON vehicle_service.vehicle_service IS 'Trigger for queuing updated vehicle services for later validation.
Actual validation is performed at the end of transaction by execute_queued_validations().';

--
-- Name: COLUMN vehicle_type.description_i18n; Type: COMMENT; Schema: vehicle_type; Owner: dbhasura
--

COMMENT ON COLUMN vehicle_type.vehicle_type.description_i18n IS 'Description of the vehicle type.';

--
-- Name: COLUMN vehicle_type.label; Type: COMMENT; Schema: vehicle_type; Owner: dbhasura
--

COMMENT ON COLUMN vehicle_type.vehicle_type.label IS 'Label of the vehicle type.';

--
-- Name: TABLE vehicle_type; Type: COMMENT; Schema: vehicle_type; Owner: dbhasura
--

COMMENT ON TABLE vehicle_type.vehicle_type IS 'The VEHICLE entity is used to describe the physical public transport vehicles available for short-term planning of operations and daily assignment (in contrast to logical vehicles considered for resource planning of operations and daily assignment (in contrast to logical vehicles cplanning). Each VEHICLE shall be classified as of a particular VEHICLE TYPE.';

--
-- Name: journey_pattern_ref journey_pattern_ref_pkey; Type: CONSTRAINT; Schema: journey_pattern; Owner: dbhasura
--

ALTER TABLE ONLY journey_pattern.journey_pattern_ref
    ADD CONSTRAINT journey_pattern_ref_pkey PRIMARY KEY (journey_pattern_ref_id);

--
-- Name: timetabled_passing_time timetabled_passing_time_pkey; Type: CONSTRAINT; Schema: passing_times; Owner: dbhasura
--

ALTER TABLE ONLY passing_times.timetabled_passing_time
    ADD CONSTRAINT timetabled_passing_time_pkey PRIMARY KEY (timetabled_passing_time_id);

--
-- Name: direction direction_pkey; Type: CONSTRAINT; Schema: route; Owner: dbhasura
--

ALTER TABLE ONLY route.direction
    ADD CONSTRAINT direction_pkey PRIMARY KEY (direction);

--
-- Name: type_of_line type_of_line_pkey; Type: CONSTRAINT; Schema: route; Owner: dbhasura
--

ALTER TABLE ONLY route.type_of_line
    ADD CONSTRAINT type_of_line_pkey PRIMARY KEY (type_of_line);

--
-- Name: day_type day_type_pkey; Type: CONSTRAINT; Schema: service_calendar; Owner: dbhasura
--

ALTER TABLE ONLY service_calendar.day_type
    ADD CONSTRAINT day_type_pkey PRIMARY KEY (day_type_id);

--
-- Name: day_type_active_on_day_of_week day_type_active_on_day_of_week_pkey; Type: CONSTRAINT; Schema: service_calendar; Owner: dbhasura
--

ALTER TABLE ONLY service_calendar.day_type_active_on_day_of_week
    ADD CONSTRAINT day_type_active_on_day_of_week_pkey PRIMARY KEY (day_type_id, day_of_week);

--
-- Name: scheduled_stop_point_in_journey_pattern_ref scheduled_stop_point_in_journey_pattern_ref_pkey; Type: CONSTRAINT; Schema: service_pattern; Owner: dbhasura
--

ALTER TABLE ONLY service_pattern.scheduled_stop_point_in_journey_pattern_ref
    ADD CONSTRAINT scheduled_stop_point_in_journey_pattern_ref_pkey PRIMARY KEY (scheduled_stop_point_in_journey_pattern_ref_id);

--
-- Name: journey_type journey_type_pkey; Type: CONSTRAINT; Schema: vehicle_journey; Owner: dbhasura
--

ALTER TABLE ONLY vehicle_journey.journey_type
    ADD CONSTRAINT journey_type_pkey PRIMARY KEY (type);

--
-- Name: vehicle_journey vehicle_journey_pkey; Type: CONSTRAINT; Schema: vehicle_journey; Owner: dbhasura
--

ALTER TABLE ONLY vehicle_journey.vehicle_journey
    ADD CONSTRAINT vehicle_journey_pkey PRIMARY KEY (vehicle_journey_id);

--
-- Name: vehicle_schedule_frame vehicle_schedule_frame_pkey; Type: CONSTRAINT; Schema: vehicle_schedule; Owner: dbhasura
--

ALTER TABLE ONLY vehicle_schedule.vehicle_schedule_frame
    ADD CONSTRAINT vehicle_schedule_frame_pkey PRIMARY KEY (vehicle_schedule_frame_id);

--
-- Name: block block_pkey; Type: CONSTRAINT; Schema: vehicle_service; Owner: dbhasura
--

ALTER TABLE ONLY vehicle_service.block
    ADD CONSTRAINT block_pkey PRIMARY KEY (block_id);

--
-- Name: journey_patterns_in_vehicle_service journey_patterns_in_vehicle_service_pkey; Type: CONSTRAINT; Schema: vehicle_service; Owner: dbhasura
--

ALTER TABLE ONLY vehicle_service.journey_patterns_in_vehicle_service
    ADD CONSTRAINT journey_patterns_in_vehicle_service_pkey PRIMARY KEY (vehicle_service_id, journey_pattern_id);

--
-- Name: vehicle_service vehicle_service_pkey; Type: CONSTRAINT; Schema: vehicle_service; Owner: dbhasura
--

ALTER TABLE ONLY vehicle_service.vehicle_service
    ADD CONSTRAINT vehicle_service_pkey PRIMARY KEY (vehicle_service_id);

--
-- Name: vehicle_type vehicle_type_pkey; Type: CONSTRAINT; Schema: vehicle_type; Owner: dbhasura
--

ALTER TABLE ONLY vehicle_type.vehicle_type
    ADD CONSTRAINT vehicle_type_pkey PRIMARY KEY (vehicle_type_id);

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: internal_service_calendar; Owner: dbhasura
--

ALTER DEFAULT PRIVILEGES FOR ROLE dbhasura IN SCHEMA internal_service_calendar GRANT SELECT ON TABLES  TO dbtimetablesapi;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: internal_utils; Owner: dbhasura
--

ALTER DEFAULT PRIVILEGES FOR ROLE dbhasura IN SCHEMA internal_utils GRANT SELECT ON TABLES  TO dbtimetablesapi;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: journey_pattern; Owner: dbhasura
--

ALTER DEFAULT PRIVILEGES FOR ROLE dbhasura IN SCHEMA journey_pattern GRANT SELECT ON TABLES  TO dbtimetablesapi;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: passing_times; Owner: dbhasura
--

ALTER DEFAULT PRIVILEGES FOR ROLE dbhasura IN SCHEMA passing_times GRANT SELECT ON TABLES  TO dbtimetablesapi;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: return_value; Owner: dbhasura
--

ALTER DEFAULT PRIVILEGES FOR ROLE dbhasura IN SCHEMA return_value GRANT SELECT ON TABLES  TO dbtimetablesapi;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: route; Owner: dbhasura
--

ALTER DEFAULT PRIVILEGES FOR ROLE dbhasura IN SCHEMA route GRANT SELECT ON TABLES  TO dbtimetablesapi;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: service_calendar; Owner: dbhasura
--

ALTER DEFAULT PRIVILEGES FOR ROLE dbhasura IN SCHEMA service_calendar GRANT SELECT ON TABLES  TO dbtimetablesapi;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: service_pattern; Owner: dbhasura
--

ALTER DEFAULT PRIVILEGES FOR ROLE dbhasura IN SCHEMA service_pattern GRANT SELECT ON TABLES  TO dbtimetablesapi;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: vehicle_journey; Owner: dbhasura
--

ALTER DEFAULT PRIVILEGES FOR ROLE dbhasura IN SCHEMA vehicle_journey GRANT SELECT ON TABLES  TO dbtimetablesapi;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: vehicle_schedule; Owner: dbhasura
--

ALTER DEFAULT PRIVILEGES FOR ROLE dbhasura IN SCHEMA vehicle_schedule GRANT SELECT ON TABLES  TO dbtimetablesapi;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: vehicle_service; Owner: dbhasura
--

ALTER DEFAULT PRIVILEGES FOR ROLE dbhasura IN SCHEMA vehicle_service GRANT SELECT ON TABLES  TO dbtimetablesapi;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: vehicle_type; Owner: dbhasura
--

ALTER DEFAULT PRIVILEGES FOR ROLE dbhasura IN SCHEMA vehicle_type GRANT SELECT ON TABLES  TO dbtimetablesapi;

--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;

--
-- Name: journey_pattern_ref journey_pattern_ref_route_direction_fkey; Type: FK CONSTRAINT; Schema: journey_pattern; Owner: dbhasura
--

ALTER TABLE ONLY journey_pattern.journey_pattern_ref
    ADD CONSTRAINT journey_pattern_ref_route_direction_fkey FOREIGN KEY (route_direction) REFERENCES route.direction(direction);

--
-- Name: journey_pattern_ref journey_pattern_ref_type_of_line_fkey; Type: FK CONSTRAINT; Schema: journey_pattern; Owner: dbhasura
--

ALTER TABLE ONLY journey_pattern.journey_pattern_ref
    ADD CONSTRAINT journey_pattern_ref_type_of_line_fkey FOREIGN KEY (type_of_line) REFERENCES route.type_of_line(type_of_line);

--
-- Name: timetabled_passing_time timetabled_passing_time_scheduled_stop_point_in_journey_pa_fkey; Type: FK CONSTRAINT; Schema: passing_times; Owner: dbhasura
--

ALTER TABLE ONLY passing_times.timetabled_passing_time
    ADD CONSTRAINT timetabled_passing_time_scheduled_stop_point_in_journey_pa_fkey FOREIGN KEY (scheduled_stop_point_in_journey_pattern_ref_id) REFERENCES service_pattern.scheduled_stop_point_in_journey_pattern_ref(scheduled_stop_point_in_journey_pattern_ref_id);

--
-- Name: timetabled_passing_time timetabled_passing_time_vehicle_journey_id_fkey; Type: FK CONSTRAINT; Schema: passing_times; Owner: dbhasura
--

ALTER TABLE ONLY passing_times.timetabled_passing_time
    ADD CONSTRAINT timetabled_passing_time_vehicle_journey_id_fkey FOREIGN KEY (vehicle_journey_id) REFERENCES vehicle_journey.vehicle_journey(vehicle_journey_id) ON DELETE CASCADE;

--
-- Name: direction direction_the_opposite_of_direction_fkey; Type: FK CONSTRAINT; Schema: route; Owner: dbhasura
--

ALTER TABLE ONLY route.direction
    ADD CONSTRAINT direction_the_opposite_of_direction_fkey FOREIGN KEY (the_opposite_of_direction) REFERENCES route.direction(direction);

--
-- Name: day_type_active_on_day_of_week day_type_active_on_day_of_week_day_type_id_fkey; Type: FK CONSTRAINT; Schema: service_calendar; Owner: dbhasura
--

ALTER TABLE ONLY service_calendar.day_type_active_on_day_of_week
    ADD CONSTRAINT day_type_active_on_day_of_week_day_type_id_fkey FOREIGN KEY (day_type_id) REFERENCES service_calendar.day_type(day_type_id);

--
-- Name: scheduled_stop_point_in_journey_pattern_ref scheduled_stop_point_in_journey_pat_journey_pattern_ref_id_fkey; Type: FK CONSTRAINT; Schema: service_pattern; Owner: dbhasura
--

ALTER TABLE ONLY service_pattern.scheduled_stop_point_in_journey_pattern_ref
    ADD CONSTRAINT scheduled_stop_point_in_journey_pat_journey_pattern_ref_id_fkey FOREIGN KEY (journey_pattern_ref_id) REFERENCES journey_pattern.journey_pattern_ref(journey_pattern_ref_id);

--
-- Name: vehicle_journey vehicle_journey_block_id_fkey; Type: FK CONSTRAINT; Schema: vehicle_journey; Owner: dbhasura
--

ALTER TABLE ONLY vehicle_journey.vehicle_journey
    ADD CONSTRAINT vehicle_journey_block_id_fkey FOREIGN KEY (block_id) REFERENCES vehicle_service.block(block_id) ON DELETE CASCADE;

--
-- Name: vehicle_journey vehicle_journey_journey_pattern_ref_id_fkey; Type: FK CONSTRAINT; Schema: vehicle_journey; Owner: dbhasura
--

ALTER TABLE ONLY vehicle_journey.vehicle_journey
    ADD CONSTRAINT vehicle_journey_journey_pattern_ref_id_fkey FOREIGN KEY (journey_pattern_ref_id) REFERENCES journey_pattern.journey_pattern_ref(journey_pattern_ref_id);

--
-- Name: vehicle_journey vehicle_journey_journey_type_fkey; Type: FK CONSTRAINT; Schema: vehicle_journey; Owner: dbhasura
--

ALTER TABLE ONLY vehicle_journey.vehicle_journey
    ADD CONSTRAINT vehicle_journey_journey_type_fkey FOREIGN KEY (journey_type) REFERENCES vehicle_journey.journey_type(type);

--
-- Name: block block_vehicle_service_id_fkey; Type: FK CONSTRAINT; Schema: vehicle_service; Owner: dbhasura
--

ALTER TABLE ONLY vehicle_service.block
    ADD CONSTRAINT block_vehicle_service_id_fkey FOREIGN KEY (vehicle_service_id) REFERENCES vehicle_service.vehicle_service(vehicle_service_id) ON DELETE CASCADE;

--
-- Name: block vehicle_type_fkey; Type: FK CONSTRAINT; Schema: vehicle_service; Owner: dbhasura
--

ALTER TABLE ONLY vehicle_service.block
    ADD CONSTRAINT vehicle_type_fkey FOREIGN KEY (vehicle_type_id) REFERENCES vehicle_type.vehicle_type(vehicle_type_id);

--
-- Name: journey_patterns_in_vehicle_service journey_patterns_in_vehicle_service_vehicle_service_id_fkey; Type: FK CONSTRAINT; Schema: vehicle_service; Owner: dbhasura
--

ALTER TABLE ONLY vehicle_service.journey_patterns_in_vehicle_service
    ADD CONSTRAINT journey_patterns_in_vehicle_service_vehicle_service_id_fkey FOREIGN KEY (vehicle_service_id) REFERENCES vehicle_service.vehicle_service(vehicle_service_id) ON DELETE CASCADE;

--
-- Name: vehicle_service vehicle_service_day_type_id_fkey; Type: FK CONSTRAINT; Schema: vehicle_service; Owner: dbhasura
--

ALTER TABLE ONLY vehicle_service.vehicle_service
    ADD CONSTRAINT vehicle_service_day_type_id_fkey FOREIGN KEY (day_type_id) REFERENCES service_calendar.day_type(day_type_id);

--
-- Name: vehicle_service vehicle_service_vehicle_schedule_frame_id_fkey; Type: FK CONSTRAINT; Schema: vehicle_service; Owner: dbhasura
--

ALTER TABLE ONLY vehicle_service.vehicle_service
    ADD CONSTRAINT vehicle_service_vehicle_schedule_frame_id_fkey FOREIGN KEY (vehicle_schedule_frame_id) REFERENCES vehicle_schedule.vehicle_schedule_frame(vehicle_schedule_frame_id) ON DELETE CASCADE;

--
-- Name: const_timetables_priority_draft(); Type: FUNCTION; Schema: internal_utils; Owner: dbhasura
--

CREATE FUNCTION internal_utils.const_timetables_priority_draft() RETURNS integer
    LANGUAGE sql IMMUTABLE PARALLEL SAFE
    AS $$SELECT 30$$;


ALTER FUNCTION internal_utils.const_timetables_priority_draft() OWNER TO dbhasura;

--
-- Name: const_timetables_priority_special(); Type: FUNCTION; Schema: internal_utils; Owner: dbhasura
--

CREATE FUNCTION internal_utils.const_timetables_priority_special() RETURNS integer
    LANGUAGE sql IMMUTABLE PARALLEL SAFE
    AS $$SELECT 25$$;


ALTER FUNCTION internal_utils.const_timetables_priority_special() OWNER TO dbhasura;

--
-- Name: const_timetables_priority_staging(); Type: FUNCTION; Schema: internal_utils; Owner: dbhasura
--

CREATE FUNCTION internal_utils.const_timetables_priority_staging() RETURNS integer
    LANGUAGE sql IMMUTABLE PARALLEL SAFE
    AS $$SELECT 40$$;


ALTER FUNCTION internal_utils.const_timetables_priority_staging() OWNER TO dbhasura;

--
-- Name: const_timetables_priority_substitute_by_line_type(); Type: FUNCTION; Schema: internal_utils; Owner: dbhasura
--

CREATE FUNCTION internal_utils.const_timetables_priority_substitute_by_line_type() RETURNS integer
    LANGUAGE sql IMMUTABLE PARALLEL SAFE
    AS $$SELECT 23$$;


ALTER FUNCTION internal_utils.const_timetables_priority_substitute_by_line_type() OWNER TO dbhasura;

--
-- Name: create_validation_queue_temp_tables(); Type: FUNCTION; Schema: internal_utils; Owner: dbhasura
--

CREATE FUNCTION internal_utils.create_validation_queue_temp_tables() RETURNS void
    LANGUAGE sql PARALLEL SAFE
    AS $$
    CREATE TEMP TABLE IF NOT EXISTS modified_vehicle_schedule_frame
    ( vehicle_schedule_frame_id UUID UNIQUE )
    ON COMMIT DELETE ROWS;

    CREATE TEMP TABLE IF NOT EXISTS modified_vehicle_service
    ( vehicle_service_id UUID UNIQUE )
    ON COMMIT DELETE ROWS;

    CREATE TEMP TABLE IF NOT EXISTS modified_block
    ( block_id UUID UNIQUE )
    ON COMMIT DELETE ROWS;

    CREATE TEMP TABLE IF NOT EXISTS modified_vehicle_journey
    ( vehicle_journey_id UUID UNIQUE )
    ON COMMIT DELETE ROWS;

    CREATE TEMP TABLE IF NOT EXISTS modified_journey_pattern_ref
    ( journey_pattern_ref_id UUID UNIQUE )
    ON COMMIT DELETE ROWS;
  $$;


ALTER FUNCTION internal_utils.create_validation_queue_temp_tables() OWNER TO dbhasura;

--
-- Name: execute_queued_validations(); Type: FUNCTION; Schema: internal_utils; Owner: dbhasura
--

CREATE FUNCTION internal_utils.execute_queued_validations() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- RAISE LOG 'internal_utils.execute_queued_validations() started';

  -- In case this is called without creating the tables.
  -- At least for refresh_journey_patterns_in_vehicle_service there is such case (vehicle_journey delete)
  PERFORM internal_utils.create_validation_queue_temp_tables();

  -- RAISE LOG 'before vehicle_service.refresh_journey_patterns_in_vehicle_service()';
  PERFORM vehicle_service.refresh_journey_patterns_in_vehicle_service();

  -- RAISE LOG 'before vehicle_schedule.validate_queued_schedules_uniqueness()';
  PERFORM vehicle_schedule.validate_queued_schedules_uniqueness();

  -- RAISE LOG 'before passing_times.validate_passing_time_sequences()';
  PERFORM passing_times.validate_passing_time_sequences();

  -- RAISE LOG 'before vehicle_service.validate_service_sequential_integrity()';
  PERFORM vehicle_service.validate_service_sequential_integrity();

  -- RAISE LOG 'internal_utils.execute_queued_validations() finished';

  RETURN NULL;
END;
$$;


ALTER FUNCTION internal_utils.execute_queued_validations() OWNER TO dbhasura;

--
-- Name: queued_validations_already_processed(); Type: FUNCTION; Schema: internal_utils; Owner: dbhasura
--

CREATE FUNCTION internal_utils.queued_validations_already_processed() RETURNS boolean
    LANGUAGE plpgsql
    AS $$
  DECLARE
    queued_validations_already_processed BOOLEAN;
  BEGIN
    queued_validations_already_processed := NULLIF(current_setting('internal_vars.queued_validations_already_processed', TRUE), '');
    IF queued_validations_already_processed IS TRUE THEN
      RETURN TRUE;
    ELSE
      -- SET LOCAL = only for this transaction. https://www.postgresql.org/docs/current/sql-set.html
      SET LOCAL internal_vars.queued_validations_already_processed = TRUE;
      RETURN FALSE;
    END IF;
  END
  $$;


ALTER FUNCTION internal_utils.queued_validations_already_processed() OWNER TO dbhasura;

--
-- Name: vehicle_journey_end_time_interval(vehicle_journey.vehicle_journey); Type: FUNCTION; Schema: internal_utils; Owner: dbhasura
--

CREATE FUNCTION internal_utils.vehicle_journey_end_time_interval(vj vehicle_journey.vehicle_journey) RETURNS interval
    LANGUAGE sql STABLE
    AS $$
  SELECT MAX (arrival_time) AS end_time
  FROM passing_times.timetabled_passing_time tpt
  WHERE tpt.vehicle_journey_id = vj.vehicle_journey_id;
$$;


ALTER FUNCTION internal_utils.vehicle_journey_end_time_interval(vj vehicle_journey.vehicle_journey) OWNER TO dbhasura;

--
-- Name: vehicle_journey_start_time_interval(vehicle_journey.vehicle_journey); Type: FUNCTION; Schema: internal_utils; Owner: dbhasura
--

CREATE FUNCTION internal_utils.vehicle_journey_start_time_interval(vj vehicle_journey.vehicle_journey) RETURNS interval
    LANGUAGE sql STABLE
    AS $$
  SELECT MIN (departure_time) AS start_time
  FROM passing_times.timetabled_passing_time tpt
  WHERE tpt.vehicle_journey_id = vj.vehicle_journey_id;
$$;


ALTER FUNCTION internal_utils.vehicle_journey_start_time_interval(vj vehicle_journey.vehicle_journey) OWNER TO dbhasura;

--
-- Name: queue_validation_by_jpr_id(); Type: FUNCTION; Schema: journey_pattern; Owner: dbhasura
--

CREATE FUNCTION journey_pattern.queue_validation_by_jpr_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    -- RAISE LOG 'journey_pattern.queue_validation_by_jpr_id()';

    PERFORM internal_utils.create_validation_queue_temp_tables();

    INSERT INTO modified_journey_pattern_ref (journey_pattern_ref_id)
    SELECT DISTINCT journey_pattern_ref_id
    FROM modified_table -- either the NEW TABLE on INSERT/UPDATE, or OLD TABLE on DELETE.
    ON CONFLICT DO NOTHING;

    RETURN NULL;
  END;
  $$;


ALTER FUNCTION journey_pattern.queue_validation_by_jpr_id() OWNER TO dbhasura;

--
-- Name: get_passing_time_order_validity_data(uuid[], uuid[]); Type: FUNCTION; Schema: passing_times; Owner: dbhasura
--

CREATE FUNCTION passing_times.get_passing_time_order_validity_data(filter_vehicle_journey_ids uuid[], filter_journey_pattern_ref_ids uuid[]) RETURNS TABLE(vehicle_journey_id uuid, first_passing_time_id uuid, last_passing_time_id uuid, stop_order_is_valid boolean, coherent_journey_pattern_refs boolean)
    LANGUAGE sql STABLE PARALLEL SAFE
    AS $$
WITH RECURSIVE
  -- Select data in a suitable format for passing time stop point validation.
  passing_time_sequence_combos AS (
    SELECT
      tpt.*,
      vj.journey_pattern_ref_id AS vehicle_journey_journey_pattern_ref_id,
      ssp.journey_pattern_ref_id AS stop_point_journey_pattern_ref_id,
      -- Create a continuous sequence number of the scheduled_stop_point_sequence
      -- (which is not required to be continuous, i.e. there can be gaps).
      ROW_NUMBER() OVER (PARTITION BY tpt.vehicle_journey_id ORDER BY ssp.scheduled_stop_point_sequence) stop_point_order
    FROM passing_times.timetabled_passing_time tpt
    JOIN service_pattern.scheduled_stop_point_in_journey_pattern_ref ssp USING (scheduled_stop_point_in_journey_pattern_ref_id)
    JOIN vehicle_journey.vehicle_journey vj USING (vehicle_journey_id)
    WHERE vehicle_journey_id = ANY(filter_vehicle_journey_ids)
    OR ssp.journey_pattern_ref_id = ANY(filter_journey_pattern_ref_ids)
  ),
  -- Try to go through passing times in sequence order,
  -- and mark if the passing times are in matching order.
  traversal AS (
    SELECT
      *,
      true AS is_after_previous
    FROM passing_time_sequence_combos combos
    WHERE combos.stop_point_order = 1
  UNION ALL
    SELECT
      combo.*,
      combo.arrival_time >= previous_combo.departure_time AS is_after_previous
    FROM traversal as previous_combo
    JOIN passing_time_sequence_combos combo USING (vehicle_journey_id)
    WHERE combo.stop_point_order = previous_combo.stop_point_order + 1
  ),
  -- Check validity of the whole stop point order sequence for each vehicle journey.
  stop_point_order_validity AS (
    SELECT
      DISTINCT vehicle_journey_id,
      EVERY(is_after_previous) AS stop_order_is_valid,
      -- There exists two paths between vehicle_journey and journey_pattern_ref:
      -- 1. directly from vehicle_journey -> journey_pattern_ref
      -- 2. via timetabled_passing_times and related scheduled_stop_point_in_journey_pattern_ref
      -- Let's ensure that vehicle_journey and its timetabled_passing_times reference same journey_pattern_ref
      EVERY(vehicle_journey_journey_pattern_ref_id = stop_point_journey_pattern_ref_id) AS coherent_journey_pattern_refs
    FROM traversal GROUP BY vehicle_journey_id
  ),
  -- Select ids of first and last passing times for journey, according to stop point order.
  first_last_passing_times AS (
    SELECT
      DISTINCT vehicle_journey_id,
      FIRST_VALUE(timetabled_passing_time_id) OVER stop_point_window AS first_passing_time_id,
      LAST_VALUE (timetabled_passing_time_id) OVER stop_point_window AS last_passing_time_id
    FROM passing_time_sequence_combos
    WINDOW stop_point_window AS (
      PARTITION BY vehicle_journey_id ORDER BY stop_point_order ASC
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )
  )
SELECT
  vehicle_journey_id,
  first_passing_time_id,
  last_passing_time_id,
  stop_order_is_valid,
  coherent_journey_pattern_refs
FROM stop_point_order_validity JOIN first_last_passing_times USING (vehicle_journey_id)
$$;


ALTER FUNCTION passing_times.get_passing_time_order_validity_data(filter_vehicle_journey_ids uuid[], filter_journey_pattern_ref_ids uuid[]) OWNER TO dbhasura;

--
-- Name: validate_passing_time_sequences(); Type: FUNCTION; Schema: passing_times; Owner: dbhasura
--

CREATE FUNCTION passing_times.validate_passing_time_sequences() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  row_validation_data RECORD;
BEGIN
  -- RAISE NOTICE 'passing_times.validate_passing_time_sequences()';

  -- Retrieve all the vehicle_journey_ids and journey_pattern_ref_ids
  -- from the queues and perform the validation for all included passing times.
  FOR row_validation_data IN (
    WITH filter_vehicle_journey_ids AS (
      SELECT array_agg(DISTINCT vehicle_journey_id) AS ids
      FROM modified_vehicle_journey
    ),
    filter_journey_pattern_ref_ids AS (
      SELECT array_agg(DISTINCT journey_pattern_ref_id) AS ids
      FROM modified_journey_pattern_ref
    )

    SELECT *
    FROM passing_times.get_passing_time_order_validity_data(
      (SELECT ids FROM filter_vehicle_journey_ids),
      (SELECT ids FROM filter_journey_pattern_ref_ids)
    )

    JOIN passing_times.timetabled_passing_time USING (vehicle_journey_id)
  )
  LOOP
    IF (row_validation_data.stop_order_is_valid = false)
    THEN
      RAISE EXCEPTION 'passing times and their matching stop points must be in same order: vehicle_journey_id %, timetabled_passing_time_id %',
        row_validation_data.vehicle_journey_id, row_validation_data.timetabled_passing_time_id;
    END IF;

    IF (
      row_validation_data.timetabled_passing_time_id = row_validation_data.first_passing_time_id
      AND row_validation_data.arrival_time IS NOT NULL
    )
    THEN
      RAISE EXCEPTION 'first passing time must not have arrival_time set: vehicle_journey_id %, timetabled_passing_time_id %',
        row_validation_data.vehicle_journey_id, row_validation_data.timetabled_passing_time_id;
    END IF;

    IF (
      row_validation_data.timetabled_passing_time_id = row_validation_data.last_passing_time_id
      AND row_validation_data.departure_time IS NOT NULL
    )
    THEN
      RAISE EXCEPTION 'last passing time must not have departure_time set: vehicle_journey_id %, timetabled_passing_time_id %',
        row_validation_data.vehicle_journey_id, row_validation_data.timetabled_passing_time_id;
    END IF;

    IF (
      row_validation_data.timetabled_passing_time_id != row_validation_data.first_passing_time_id
      AND
      row_validation_data.timetabled_passing_time_id != row_validation_data.last_passing_time_id
      AND (
        row_validation_data.departure_time IS NULL OR
        row_validation_data.arrival_time IS NULL
      )
    )
    THEN
      RAISE EXCEPTION 'all passing time that are not first or last in the sequence must have both departure and arrival time defined: vehicle_journey_id %, timetabled_passing_time_id %',
        row_validation_data.vehicle_journey_id, row_validation_data.timetabled_passing_time_id;
    END IF;

    IF (row_validation_data.coherent_journey_pattern_refs = false)
    THEN
      RAISE EXCEPTION 'inconsistent journey_pattern_ref within vehicle journey, all timetabled_passing_times must reference same journey_pattern_ref as the vehicle_journey: vehicle_journey_id %',
        row_validation_data.vehicle_journey_id;
    END IF;
  END LOOP;
END;
$$;


ALTER FUNCTION passing_times.validate_passing_time_sequences() OWNER TO dbhasura;

--
-- Name: queue_validation_by_vj_id(); Type: FUNCTION; Schema: vehicle_journey; Owner: dbhasura
--

CREATE FUNCTION vehicle_journey.queue_validation_by_vj_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    -- RAISE LOG 'vehicle_journey.queue_validation_by_vj_id()';

    PERFORM internal_utils.create_validation_queue_temp_tables();

    INSERT INTO modified_vehicle_journey (vehicle_journey_id)
    SELECT DISTINCT vehicle_journey_id
    FROM modified_table -- either the NEW TABLE on INSERT/UPDATE, or OLD TABLE on DELETE.
    ON CONFLICT DO NOTHING;

    RETURN NULL;
  END;
  $$;


ALTER FUNCTION vehicle_journey.queue_validation_by_vj_id() OWNER TO dbhasura;

--
-- Name: vehicle_journey_end_time(vehicle_journey.vehicle_journey); Type: FUNCTION; Schema: vehicle_journey; Owner: dbhasura
--

CREATE FUNCTION vehicle_journey.vehicle_journey_end_time(vj vehicle_journey.vehicle_journey) RETURNS text
    LANGUAGE sql STABLE
    AS $$
  SELECT MAX (arrival_time)::text AS end_time
  FROM passing_times.timetabled_passing_time tpt
  WHERE tpt.vehicle_journey_id = vj.vehicle_journey_id;
$$;


ALTER FUNCTION vehicle_journey.vehicle_journey_end_time(vj vehicle_journey.vehicle_journey) OWNER TO dbhasura;

--
-- Name: vehicle_journey_start_time(vehicle_journey.vehicle_journey); Type: FUNCTION; Schema: vehicle_journey; Owner: dbhasura
--

CREATE FUNCTION vehicle_journey.vehicle_journey_start_time(vj vehicle_journey.vehicle_journey) RETURNS text
    LANGUAGE sql STABLE
    AS $$
  SELECT MIN (departure_time)::text AS start_time
  FROM passing_times.timetabled_passing_time tpt
  WHERE tpt.vehicle_journey_id = vj.vehicle_journey_id;
$$;


ALTER FUNCTION vehicle_journey.vehicle_journey_start_time(vj vehicle_journey.vehicle_journey) OWNER TO dbhasura;

--
-- Name: get_overlapping_schedules(uuid[], uuid[], boolean); Type: FUNCTION; Schema: vehicle_schedule; Owner: dbhasura
--

CREATE FUNCTION vehicle_schedule.get_overlapping_schedules(filter_vehicle_schedule_frame_ids uuid[], filter_journey_pattern_ref_ids uuid[], ignore_priority boolean DEFAULT false) RETURNS TABLE(current_vehicle_schedule_frame_id uuid, other_vehicle_schedule_frame_id uuid, journey_pattern_id uuid, active_on_day_of_week integer, priority integer, current_validity_range daterange, other_validity_range daterange, validity_intersection daterange)
    LANGUAGE sql
    AS $$
  WITH
  -- Find out which rows we need to check.
  -- Only modified rows and those they could possibly conflict with need to be checked. This includes:
  -- 1. modified VSFs
  -- 2. all VSFs that have same JP as any of the modified ones
  -- 3. all VSFs that use any of the modified JPs
  -- Achieve this by filtering with journey_pattern_id,
  -- and include all JP ids that were either modified or relate to any modified VSFs.
  journey_patterns_to_check AS (
      SELECT journey_pattern_id
      FROM journey_pattern.journey_pattern_ref
      WHERE journey_pattern_ref_id = ANY(filter_journey_pattern_ref_ids)
    UNION
      SELECT DISTINCT journey_pattern_id
      FROM vehicle_schedule.vehicle_schedule_frame
      JOIN vehicle_service.vehicle_service vs  USING (vehicle_schedule_frame_id)
      JOIN vehicle_service.journey_patterns_in_vehicle_service USING (vehicle_service_id)
      WHERE vehicle_schedule_frame_id = ANY(filter_vehicle_schedule_frame_ids)
  ),
  -- Collect all relevant data about journey patterns for vehicle schedule frames.
  vehicle_schedule_frame_journey_patterns AS (
    SELECT DISTINCT
      vehicle_schedule_frame_id,
      journey_pattern_id,
      validity_range,
      day_of_week,
      priority
    FROM vehicle_service.journey_patterns_in_vehicle_service
    JOIN vehicle_service.vehicle_service USING (vehicle_service_id)
    JOIN vehicle_schedule.vehicle_schedule_frame USING (vehicle_schedule_frame_id)
    JOIN service_calendar.day_type_active_on_day_of_week USING (day_type_id)
    JOIN journey_patterns_to_check USING (journey_pattern_id)
    WHERE (
      ignore_priority = true OR
      priority < internal_utils.const_timetables_priority_draft() -- The restrictions should not apply for Draft and Staging priorities.
    )
  ),
  -- Select all schedules in DB that have conflicts with schedules_to_check.
  -- Note that this will contain each conflicting schedule frame pair twice.
  schedule_conflicts AS (
    SELECT DISTINCT
      current_schedule.vehicle_schedule_frame_id as current_vehicle_schedule_frame_id,
      other_schedule.vehicle_schedule_frame_id AS other_vehicle_schedule_frame_id,
      journey_pattern_id,
      day_of_week AS active_on_day_of_week,
      current_schedule.priority,
      current_schedule.validity_range AS current_validity_range,
      other_schedule.validity_range AS other_validity_range,
      current_schedule.validity_range * other_schedule.validity_range AS validity_intersection
    FROM vehicle_schedule_frame_journey_patterns current_schedule
    -- Check if the schedules conflict.
    JOIN vehicle_schedule_frame_journey_patterns other_schedule USING (journey_pattern_id, day_of_week)
    WHERE (current_schedule.validity_range && other_schedule.validity_range)
    AND current_schedule.vehicle_schedule_frame_id != other_schedule.vehicle_schedule_frame_id
    AND (
      ignore_priority = true OR
      current_schedule.priority = other_schedule.priority
    )
  )
SELECT * FROM schedule_conflicts;
$$;


ALTER FUNCTION vehicle_schedule.get_overlapping_schedules(filter_vehicle_schedule_frame_ids uuid[], filter_journey_pattern_ref_ids uuid[], ignore_priority boolean) OWNER TO dbhasura;

--
-- Name: queue_validation_by_vsf_id(); Type: FUNCTION; Schema: vehicle_schedule; Owner: dbhasura
--

CREATE FUNCTION vehicle_schedule.queue_validation_by_vsf_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    -- RAISE LOG 'vehicle_schedule.queue_validation_by_vsf_id()';

    PERFORM internal_utils.create_validation_queue_temp_tables();

    INSERT INTO modified_vehicle_schedule_frame (vehicle_schedule_frame_id)
    SELECT DISTINCT vehicle_schedule_frame_id
    FROM modified_table -- either the NEW TABLE on INSERT/UPDATE, or OLD TABLE on DELETE.
    ON CONFLICT DO NOTHING;

    RETURN NULL;
  END;
  $$;


ALTER FUNCTION vehicle_schedule.queue_validation_by_vsf_id() OWNER TO dbhasura;

--
-- Name: validate_queued_schedules_uniqueness(); Type: FUNCTION; Schema: vehicle_schedule; Owner: dbhasura
--

CREATE FUNCTION vehicle_schedule.validate_queued_schedules_uniqueness() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  overlapping_schedule RECORD;
  error_message TEXT;
BEGIN
  -- RAISE NOTICE 'vehicle_schedule.validate_queued_schedules_uniqueness()';

  -- Build modified_vehicle_schedule_frame_ids from modified_ tables,
  -- finding out which frames or their children were modified.
  -- Eg. if block_id is present in modified_block, it's parent vehicle_schedule_frame_id will be selected.
  WITH modified_vehicle_schedule_frame_ids AS (
    SELECT vehicle_schedule_frame_id
    FROM modified_vehicle_journey
    JOIN vehicle_journey.vehicle_journey USING (vehicle_journey_id)
    FULL OUTER JOIN modified_block USING (block_id)
    JOIN vehicle_service.block USING (block_id)
    FULL OUTER JOIN modified_vehicle_service USING (vehicle_service_id)
    JOIN vehicle_service.vehicle_service USING (vehicle_service_id)
    FULL OUTER JOIN modified_vehicle_schedule_frame USING (vehicle_schedule_frame_id)
  )
  SELECT * FROM vehicle_schedule.get_overlapping_schedules(
    (SELECT array_agg(vehicle_schedule_frame_id) FROM modified_vehicle_schedule_frame_ids),
    (SELECT array_agg(journey_pattern_ref_id) FROM modified_journey_pattern_ref)
  )
  LIMIT 1 -- RECORD type, so other rows are discarded anyway.
  INTO overlapping_schedule;

  IF FOUND THEN
    -- Note, this includes only one of the conflicting rows. There might be multiple.
    SELECT format(
      'vehicle schedule frame %s and vehicle schedule frame %s, priority %s, journey_pattern_id %s, overlapping on %s on day of week %s',
      overlapping_schedule.current_vehicle_schedule_frame_id,
      overlapping_schedule.other_vehicle_schedule_frame_id,
      overlapping_schedule.priority,
      overlapping_schedule.journey_pattern_id,
      overlapping_schedule.validity_intersection,
      overlapping_schedule.active_on_day_of_week
    ) INTO error_message;
    RAISE EXCEPTION 'conflicting schedules detected: %', error_message;
  END IF;
END;
$$;


ALTER FUNCTION vehicle_schedule.validate_queued_schedules_uniqueness() OWNER TO dbhasura;

--
-- Name: get_vehicle_service_timing_data(uuid[]); Type: FUNCTION; Schema: vehicle_service; Owner: dbhasura
--

CREATE FUNCTION vehicle_service.get_vehicle_service_timing_data(vehicle_service_ids uuid[]) RETURNS TABLE(vehicle_service_id uuid, service_start interval, service_end interval, block_id uuid, block_start interval, block_end interval, preparing_time interval, finishing_time interval, vehicle_journey_id uuid, journey_start interval, journey_end interval, journey_first_stop_departure interval, journey_last_stop_arrival interval, turnaround_time interval, layover_time interval, timetabled_passing_time_id uuid, stop_departure_time interval, stop_arrival_time interval)
    LANGUAGE sql STABLE PARALLEL SAFE
    AS $$
  -- Process goes like this:
  -- 1 (timing_data): collect all required columns from DB, coalesce to get rid off nulls
  -- 2 (with_journey_times): passing times -> start & end of each journey
  -- 3 (with_block_times): journey times -> start & end of each block
  -- 4 (with_service_times): block times -> start & end of each service
  -- 5: return all fetched and calculated columns.
  --
  -- Note: this could be written as many nested subqueries as well.
  -- Tried it, but there was no difference in performance and query plans were near identical.
  WITH timing_data AS (
    SELECT
      vehicle_service_id,
      MIN(tpt.departure_time) OVER (PARTITION BY vehicle_journey_id) AS journey_first_stop_departure,
      MAX(tpt.arrival_time) OVER (PARTITION BY vehicle_journey_id) AS journey_last_stop_arrival,
      block_id,
      COALESCE (block.preparing_time, INTERVAL '0') AS preparing_time,
      COALESCE (block.finishing_time, INTERVAL '0') AS finishing_time,
      vehicle_journey_id,
      COALESCE (journey.turnaround_time, INTERVAL '0') AS turnaround_time,
      COALESCE (journey.layover_time, INTERVAL '0') AS layover_time,
      timetabled_passing_time_id,
      COALESCE (tpt.departure_time, passing_time) AS stop_departure_time,
      COALESCE (tpt.arrival_time, passing_time) AS stop_arrival_time
    FROM vehicle_journey.vehicle_journey journey
    JOIN passing_times.timetabled_passing_time tpt USING (vehicle_journey_id)
    JOIN vehicle_service.block block USING (block_id)
    JOIN vehicle_service.vehicle_service service USING (vehicle_service_id)
    WHERE vehicle_service_id = ANY(vehicle_service_ids)
  ),
  with_journey_times AS (
    SELECT
      *,
      journey_first_stop_departure - turnaround_time AS journey_start,
      journey_last_stop_arrival + layover_time AS journey_end
    FROM timing_data
  ),
  with_block_times AS (
    SELECT
      *,
      (MIN(journey_start) OVER (PARTITION BY block_id) - preparing_time) AS block_start,
      (MAX(journey_end) OVER (PARTITION BY block_id) + finishing_time) AS block_end
    FROM with_journey_times
  ),
  with_service_times AS (
    SELECT
      *,
      MIN(block_start) OVER (PARTITION BY vehicle_service_id) AS service_start,
      MAX(block_end) OVER (PARTITION BY vehicle_service_id) AS service_end
    FROM with_block_times
  )
  SELECT
    vehicle_service_id,
    service_start,
    service_end,
    block_id,
    block_start,
    block_end,
    preparing_time,
    finishing_time,
    vehicle_journey_id,
    journey_start,
    journey_end,
    journey_first_stop_departure,
    journey_last_stop_arrival,
    turnaround_time as turnaround_time,
    layover_time as layover_time,
    timetabled_passing_time_id,
    stop_departure_time,
    stop_arrival_time
  FROM with_service_times;
$$;


ALTER FUNCTION vehicle_service.get_vehicle_service_timing_data(vehicle_service_ids uuid[]) OWNER TO dbhasura;

--
-- Name: queue_validation_by_block_id(); Type: FUNCTION; Schema: vehicle_service; Owner: dbhasura
--

CREATE FUNCTION vehicle_service.queue_validation_by_block_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    -- RAISE LOG 'vehicle_service.queue_validation_by_block_id()';

    PERFORM internal_utils.create_validation_queue_temp_tables();

    INSERT INTO modified_block (block_id)
    SELECT DISTINCT block_id
    FROM modified_table -- either the NEW TABLE on INSERT/UPDATE, or OLD TABLE on DELETE.
    ON CONFLICT DO NOTHING;

    RETURN NULL;
  END;
  $$;


ALTER FUNCTION vehicle_service.queue_validation_by_block_id() OWNER TO dbhasura;

--
-- Name: queue_validation_by_vs_id(); Type: FUNCTION; Schema: vehicle_service; Owner: dbhasura
--

CREATE FUNCTION vehicle_service.queue_validation_by_vs_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    -- RAISE LOG 'vehicle_service.queue_validation_by_vs_id()';

    PERFORM internal_utils.create_validation_queue_temp_tables();

    INSERT INTO modified_vehicle_service (vehicle_service_id)
    SELECT DISTINCT vehicle_service_id
    FROM modified_table -- either the NEW TABLE on INSERT/UPDATE, or OLD TABLE on DELETE.
    ON CONFLICT DO NOTHING;

    RETURN NULL;
  END;
  $$;


ALTER FUNCTION vehicle_service.queue_validation_by_vs_id() OWNER TO dbhasura;

--
-- Name: refresh_journey_patterns_in_vehicle_service(); Type: FUNCTION; Schema: vehicle_service; Owner: dbhasura
--

CREATE FUNCTION vehicle_service.refresh_journey_patterns_in_vehicle_service() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- RAISE LOG 'refresh_journey_patterns_in_vehicle_service()';

  -- Step 1: reset all counts.
  UPDATE vehicle_service.journey_patterns_in_vehicle_service
  SET reference_count = 0;

  -- Step 2: upsert new entries.
  INSERT INTO vehicle_service.journey_patterns_in_vehicle_service (journey_pattern_id, vehicle_service_id, reference_count)
    SELECT DISTINCT journey_pattern_id, vehicle_service_id, COUNT(journey_pattern_ref_id) AS ref_count
    FROM vehicle_service.vehicle_service
    JOIN vehicle_service.block USING (vehicle_service_id)
    JOIN vehicle_journey.vehicle_journey USING (block_id)
    JOIN journey_pattern.journey_pattern_ref USING (journey_pattern_ref_id)
    GROUP BY (journey_pattern_id, vehicle_service_id, journey_pattern_ref_id)
  ON CONFLICT (vehicle_service_id, journey_pattern_id) DO
    UPDATE SET reference_count = EXCLUDED.reference_count;

  -- Step 3: remove all rows that are no longer used,
  -- that is, where the reference between vehicle_service and journey_pattern no longer exists.
  DELETE FROM vehicle_service.journey_patterns_in_vehicle_service
  WHERE reference_count = 0;
END;
$$;


ALTER FUNCTION vehicle_service.refresh_journey_patterns_in_vehicle_service() OWNER TO dbhasura;

--
-- Name: validate_service_sequential_integrity(); Type: FUNCTION; Schema: vehicle_service; Owner: dbhasura
--

CREATE FUNCTION vehicle_service.validate_service_sequential_integrity() RETURNS void
    LANGUAGE plpgsql
    AS $$
  DECLARE
    error_message TEXT;
  BEGIN
    -- RAISE NOTICE 'vehicle_service.validate_service_sequential_integrity()';

    -- Build modified_vehicle_service_ids from modified_ tables,
    -- finding out which services or their children were modified.
    -- Eg. if block_id is present in modified_block, it's parent vehicle_service will be selected.
    WITH modified_vehicle_service_ids AS (
      SELECT DISTINCT vehicle_service_id
      FROM modified_vehicle_journey
      JOIN vehicle_journey.vehicle_journey USING (vehicle_journey_id)
      FULL OUTER JOIN modified_block USING (block_id)
      JOIN vehicle_service.block USING (block_id)
      FULL OUTER JOIN modified_vehicle_service USING (vehicle_service_id)
      -- Note: also needs to trigger if passing times are modified.
      -- But no need to join that table, because passing time modifications mark the whole vehicle journey as modified.
    ),
    timing_data AS (
      SELECT * FROM vehicle_service.get_vehicle_service_timing_data(
        (SELECT array_agg(vehicle_service_id) FROM modified_vehicle_service_ids)
      )
    ),
    in_temporal_order AS (
      SELECT
        -- Assign an index for each row according to their temporal order, per vehicle service. To be used as identifier.
        ROW_NUMBER() OVER (
          PARTITION BY vehicle_service_id
          ORDER BY service_start, block_start, journey_start, stop_departure_time
        ) order_number,
        *
      FROM timing_data
      ORDER BY vehicle_service_id, service_start, block_start, journey_start, stop_departure_time
    ),
    with_overlaps AS (
      -- For each timing data row, find the next row in (next_time).
      -- Select data from that into next_* columns.
      -- Based on these, check for sequential integrity issues in the sequence of blocks journeys:
      -- if next_time is from different block or journey and these times overlap, the sequence is not valid.
      SELECT
        -- Current timing data:
        in_temporal_order.*,
        -- Next timing data:
        next_time.block_id AS next_block_id,
        next_time.block_start AS next_block_start,
        next_time.block_end AS next_block_end,
        next_time.vehicle_journey_id AS next_vehicle_journey_id,
        next_time.journey_start AS next_journey_start,
        next_time.journey_end AS next_journey_end,
        -- Sequential integrity issues:
        (
          in_temporal_order.block_id <> next_time.block_id
          AND in_temporal_order.block_end > next_time.block_start
        ) AS block_overlaps_with_next,
        (
          in_temporal_order.vehicle_journey_id <> next_time.vehicle_journey_id
          AND in_temporal_order.journey_end > next_time.journey_start
        ) AS journey_overlaps_with_next
      FROM in_temporal_order
      JOIN in_temporal_order next_time
        ON in_temporal_order.vehicle_service_id = next_time.vehicle_service_id
        AND next_time.order_number = (in_temporal_order.order_number + 1)
        -- Note: the above join discards the last row. That is fine.
        -- It could be included, by LEFT JOINing instead, but this would be unnecessary
        -- since the last row can't have any next row it could have overlap issues with.
        -- The second last already checks overlap issues with last row.
    )
    -- For each overlap issue (if any), format a clear error message.
    SELECT string_agg(error_text, '. ')
      FROM (
        SELECT format(
          'vehicle_service %s: block %s (%s - %s) overlaps with block %s (%s - %s)',
          vehicle_service_id,
          block_id,
          block_start,
          block_end,
          next_block_id,
          next_block_start,
          next_block_end
        ) AS error_text
        FROM with_overlaps
        WHERE block_overlaps_with_next
      UNION
        SELECT format(
          'vehicle_service %s: journey %s (%s - %s) overlaps with journey %s (%s - %s)',
          vehicle_service_id,
          vehicle_journey_id,
          journey_start,
          journey_end,
          next_vehicle_journey_id,
          next_journey_start,
          next_journey_end
        ) AS error_text
        FROM with_overlaps
        WHERE journey_overlaps_with_next
      ) AS errors
    INTO error_message;

    IF error_message IS NOT NULL THEN
        RAISE EXCEPTION 'Sequential integrity issues detected: %', error_message;
    END IF;
  END
$$;


ALTER FUNCTION vehicle_service.validate_service_sequential_integrity() OWNER TO dbhasura;

--
-- Name: idx_journey_pattern_ref_journey_pattern_id; Type: INDEX; Schema: journey_pattern; Owner: dbhasura
--

CREATE INDEX idx_journey_pattern_ref_journey_pattern_id ON journey_pattern.journey_pattern_ref USING btree (journey_pattern_id);

--
-- Name: idx_journey_pattern_ref_route_direction; Type: INDEX; Schema: journey_pattern; Owner: dbhasura
--

CREATE INDEX idx_journey_pattern_ref_route_direction ON journey_pattern.journey_pattern_ref USING btree (route_direction);

--
-- Name: journey_pattern_ref_type_of_line; Type: INDEX; Schema: journey_pattern; Owner: dbhasura
--

CREATE INDEX journey_pattern_ref_type_of_line ON journey_pattern.journey_pattern_ref USING btree (type_of_line);

--
-- Name: idx_timetabled_passing_time_sspijp_ref; Type: INDEX; Schema: passing_times; Owner: dbhasura
--

CREATE INDEX idx_timetabled_passing_time_sspijp_ref ON passing_times.timetabled_passing_time USING btree (scheduled_stop_point_in_journey_pattern_ref_id);

--
-- Name: timetabled_passing_time_stop_point_unique_idx; Type: INDEX; Schema: passing_times; Owner: dbhasura
--

CREATE UNIQUE INDEX timetabled_passing_time_stop_point_unique_idx ON passing_times.timetabled_passing_time USING btree (vehicle_journey_id, scheduled_stop_point_in_journey_pattern_ref_id);

--
-- Name: idx_direction_the_opposite_of_direction; Type: INDEX; Schema: route; Owner: dbhasura
--

CREATE INDEX idx_direction_the_opposite_of_direction ON route.direction USING btree (the_opposite_of_direction);

--
-- Name: service_calendar_day_type_label_idx; Type: INDEX; Schema: service_calendar; Owner: dbhasura
--

CREATE UNIQUE INDEX service_calendar_day_type_label_idx ON service_calendar.day_type USING btree (label);

--
-- Name: service_pattern_scheduled_stop_point_in_journey_pattern_ref_idx; Type: INDEX; Schema: service_pattern; Owner: dbhasura
--

CREATE UNIQUE INDEX service_pattern_scheduled_stop_point_in_journey_pattern_ref_idx ON service_pattern.scheduled_stop_point_in_journey_pattern_ref USING btree (journey_pattern_ref_id, scheduled_stop_point_sequence);

--
-- Name: idx_vehicle_journey_block; Type: INDEX; Schema: vehicle_journey; Owner: dbhasura
--

CREATE INDEX idx_vehicle_journey_block ON vehicle_journey.vehicle_journey USING btree (block_id);

--
-- Name: idx_vehicle_journey_journey_pattern_ref; Type: INDEX; Schema: vehicle_journey; Owner: dbhasura
--

CREATE INDEX idx_vehicle_journey_journey_pattern_ref ON vehicle_journey.vehicle_journey USING btree (journey_pattern_ref_id);

--
-- Name: idx_vehicle_journey_journey_type; Type: INDEX; Schema: vehicle_journey; Owner: dbhasura
--

CREATE INDEX idx_vehicle_journey_journey_type ON vehicle_journey.vehicle_journey USING btree (journey_type);

--
-- Name: idx_block_vehicle_service; Type: INDEX; Schema: vehicle_service; Owner: dbhasura
--

CREATE INDEX idx_block_vehicle_service ON vehicle_service.block USING btree (vehicle_service_id);

--
-- Name: idx_block_vehicle_type_id; Type: INDEX; Schema: vehicle_service; Owner: dbhasura
--

CREATE INDEX idx_block_vehicle_type_id ON vehicle_service.block USING btree (vehicle_type_id);

--
-- Name: idx_journey_patterns_in_vehicle_service_journey_pattern_id; Type: INDEX; Schema: vehicle_service; Owner: dbhasura
--

CREATE INDEX idx_journey_patterns_in_vehicle_service_journey_pattern_id ON vehicle_service.journey_patterns_in_vehicle_service USING btree (journey_pattern_id);

--
-- Name: idx_vehicle_service_day_type; Type: INDEX; Schema: vehicle_service; Owner: dbhasura
--

CREATE INDEX idx_vehicle_service_day_type ON vehicle_service.vehicle_service USING btree (day_type_id);

--
-- Name: idx_vehicle_service_vehicle_schedule_frame; Type: INDEX; Schema: vehicle_service; Owner: dbhasura
--

CREATE INDEX idx_vehicle_service_vehicle_schedule_frame ON vehicle_service.vehicle_service USING btree (vehicle_schedule_frame_id);

--
-- Name: vehicle_type_label_idx; Type: INDEX; Schema: vehicle_type; Owner: dbhasura
--

CREATE UNIQUE INDEX vehicle_type_label_idx ON vehicle_type.vehicle_type USING btree (label);

--
-- Name: internal_service_calendar; Type: SCHEMA; Schema: -; Owner: dbhasura
--

CREATE SCHEMA internal_service_calendar;


ALTER SCHEMA internal_service_calendar OWNER TO dbhasura;

--
-- Name: internal_utils; Type: SCHEMA; Schema: -; Owner: dbhasura
--

CREATE SCHEMA internal_utils;


ALTER SCHEMA internal_utils OWNER TO dbhasura;

--
-- Name: journey_pattern; Type: SCHEMA; Schema: -; Owner: dbhasura
--

CREATE SCHEMA journey_pattern;


ALTER SCHEMA journey_pattern OWNER TO dbhasura;

--
-- Name: passing_times; Type: SCHEMA; Schema: -; Owner: dbhasura
--

CREATE SCHEMA passing_times;


ALTER SCHEMA passing_times OWNER TO dbhasura;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: dbadmin
--

ALTER SCHEMA public OWNER TO dbadmin;

--
-- Name: return_value; Type: SCHEMA; Schema: -; Owner: dbhasura
--

CREATE SCHEMA return_value;


ALTER SCHEMA return_value OWNER TO dbhasura;

--
-- Name: route; Type: SCHEMA; Schema: -; Owner: dbhasura
--

CREATE SCHEMA route;


ALTER SCHEMA route OWNER TO dbhasura;

--
-- Name: service_calendar; Type: SCHEMA; Schema: -; Owner: dbhasura
--

CREATE SCHEMA service_calendar;


ALTER SCHEMA service_calendar OWNER TO dbhasura;

--
-- Name: service_pattern; Type: SCHEMA; Schema: -; Owner: dbhasura
--

CREATE SCHEMA service_pattern;


ALTER SCHEMA service_pattern OWNER TO dbhasura;

--
-- Name: vehicle_journey; Type: SCHEMA; Schema: -; Owner: dbhasura
--

CREATE SCHEMA vehicle_journey;


ALTER SCHEMA vehicle_journey OWNER TO dbhasura;

--
-- Name: vehicle_schedule; Type: SCHEMA; Schema: -; Owner: dbhasura
--

CREATE SCHEMA vehicle_schedule;


ALTER SCHEMA vehicle_schedule OWNER TO dbhasura;

--
-- Name: vehicle_service; Type: SCHEMA; Schema: -; Owner: dbhasura
--

CREATE SCHEMA vehicle_service;


ALTER SCHEMA vehicle_service OWNER TO dbhasura;

--
-- Name: vehicle_type; Type: SCHEMA; Schema: -; Owner: dbhasura
--

CREATE SCHEMA vehicle_type;


ALTER SCHEMA vehicle_type OWNER TO dbhasura;

--
-- Name: journey_pattern_ref; Type: TABLE; Schema: journey_pattern; Owner: dbhasura
--

CREATE TABLE journey_pattern.journey_pattern_ref (
    journey_pattern_ref_id uuid DEFAULT gen_random_uuid() NOT NULL,
    journey_pattern_id uuid NOT NULL,
    observation_timestamp timestamp with time zone NOT NULL,
    snapshot_timestamp timestamp with time zone NOT NULL,
    type_of_line text NOT NULL,
    route_label text NOT NULL,
    route_direction text NOT NULL,
    route_validity_start date,
    route_validity_end date
);


ALTER TABLE journey_pattern.journey_pattern_ref OWNER TO dbhasura;

--
-- Name: timetabled_passing_time; Type: TABLE; Schema: passing_times; Owner: dbhasura
--

CREATE TABLE passing_times.timetabled_passing_time (
    timetabled_passing_time_id uuid DEFAULT gen_random_uuid() NOT NULL,
    vehicle_journey_id uuid NOT NULL,
    scheduled_stop_point_in_journey_pattern_ref_id uuid NOT NULL,
    arrival_time interval,
    departure_time interval,
    passing_time interval GENERATED ALWAYS AS (COALESCE(departure_time, arrival_time)) STORED NOT NULL,
    CONSTRAINT arrival_not_after_departure CHECK (((arrival_time IS NULL) OR (departure_time IS NULL) OR (arrival_time <= departure_time))),
    CONSTRAINT arrival_or_departure_time_exists CHECK (((arrival_time IS NOT NULL) OR (departure_time IS NOT NULL)))
);


ALTER TABLE passing_times.timetabled_passing_time OWNER TO dbhasura;

--
-- Name: direction; Type: TABLE; Schema: route; Owner: dbhasura
--

CREATE TABLE route.direction (
    direction text NOT NULL,
    the_opposite_of_direction text
);


ALTER TABLE route.direction OWNER TO dbhasura;

--
-- Name: type_of_line; Type: TABLE; Schema: route; Owner: dbhasura
--

CREATE TABLE route.type_of_line (
    type_of_line text NOT NULL
);


ALTER TABLE route.type_of_line OWNER TO dbhasura;

--
-- Name: day_type; Type: TABLE; Schema: service_calendar; Owner: dbhasura
--

CREATE TABLE service_calendar.day_type (
    day_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    label text NOT NULL,
    name_i18n jsonb NOT NULL
);


ALTER TABLE service_calendar.day_type OWNER TO dbhasura;

--
-- Name: day_type_active_on_day_of_week; Type: TABLE; Schema: service_calendar; Owner: dbhasura
--

CREATE TABLE service_calendar.day_type_active_on_day_of_week (
    day_type_id uuid NOT NULL,
    day_of_week integer NOT NULL,
    CONSTRAINT day_type_active_on_day_of_week_day_of_week_check CHECK (((day_of_week >= 1) AND (day_of_week <= 7)))
);


ALTER TABLE service_calendar.day_type_active_on_day_of_week OWNER TO dbhasura;

--
-- Name: scheduled_stop_point_in_journey_pattern_ref; Type: TABLE; Schema: service_pattern; Owner: dbhasura
--

CREATE TABLE service_pattern.scheduled_stop_point_in_journey_pattern_ref (
    scheduled_stop_point_in_journey_pattern_ref_id uuid DEFAULT gen_random_uuid() NOT NULL,
    journey_pattern_ref_id uuid NOT NULL,
    scheduled_stop_point_label text NOT NULL,
    scheduled_stop_point_sequence integer NOT NULL,
    timing_place_label text
);


ALTER TABLE service_pattern.scheduled_stop_point_in_journey_pattern_ref OWNER TO dbhasura;

--
-- Name: journey_type; Type: TABLE; Schema: vehicle_journey; Owner: dbhasura
--

CREATE TABLE vehicle_journey.journey_type (
    type text NOT NULL
);


ALTER TABLE vehicle_journey.journey_type OWNER TO dbhasura;

--
-- Name: vehicle_journey; Type: TABLE; Schema: vehicle_journey; Owner: dbhasura
--

CREATE TABLE vehicle_journey.vehicle_journey (
    vehicle_journey_id uuid DEFAULT gen_random_uuid() NOT NULL,
    journey_pattern_ref_id uuid NOT NULL,
    block_id uuid NOT NULL,
    journey_name_i18n jsonb,
    turnaround_time interval,
    layover_time interval,
    journey_type text DEFAULT 'STANDARD'::text NOT NULL
);


ALTER TABLE vehicle_journey.vehicle_journey OWNER TO dbhasura;

--
-- Name: vehicle_schedule_frame; Type: TABLE; Schema: vehicle_schedule; Owner: dbhasura
--

CREATE TABLE vehicle_schedule.vehicle_schedule_frame (
    vehicle_schedule_frame_id uuid DEFAULT gen_random_uuid() NOT NULL,
    name_i18n jsonb,
    validity_start date NOT NULL,
    validity_end date NOT NULL,
    priority integer NOT NULL,
    label text NOT NULL,
    validity_range daterange GENERATED ALWAYS AS (daterange(validity_start, validity_end, '[]'::text)) STORED NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_day_validity_priorities CHECK ((((priority = internal_utils.const_timetables_priority_special()) AND (validity_start = validity_end)) OR ((priority <> internal_utils.const_timetables_priority_special()) AND (validity_start <> validity_end)) OR (priority = internal_utils.const_timetables_priority_staging())))
);


ALTER TABLE vehicle_schedule.vehicle_schedule_frame OWNER TO dbhasura;

--
-- Name: block; Type: TABLE; Schema: vehicle_service; Owner: dbhasura
--

CREATE TABLE vehicle_service.block (
    block_id uuid DEFAULT gen_random_uuid() NOT NULL,
    vehicle_service_id uuid NOT NULL,
    preparing_time interval,
    finishing_time interval,
    vehicle_type_id uuid
);


ALTER TABLE vehicle_service.block OWNER TO dbhasura;

--
-- Name: journey_patterns_in_vehicle_service; Type: TABLE; Schema: vehicle_service; Owner: dbhasura
--

CREATE TABLE vehicle_service.journey_patterns_in_vehicle_service (
    vehicle_service_id uuid NOT NULL,
    journey_pattern_id uuid NOT NULL,
    reference_count integer NOT NULL,
    CONSTRAINT journey_patterns_in_vehicle_service_reference_count_check CHECK ((reference_count >= 0))
);


ALTER TABLE vehicle_service.journey_patterns_in_vehicle_service OWNER TO dbhasura;

--
-- Name: vehicle_service; Type: TABLE; Schema: vehicle_service; Owner: dbhasura
--

CREATE TABLE vehicle_service.vehicle_service (
    vehicle_service_id uuid DEFAULT gen_random_uuid() NOT NULL,
    day_type_id uuid NOT NULL,
    vehicle_schedule_frame_id uuid NOT NULL,
    name_i18n jsonb
);


ALTER TABLE vehicle_service.vehicle_service OWNER TO dbhasura;

--
-- Name: vehicle_type; Type: TABLE; Schema: vehicle_type; Owner: dbhasura
--

CREATE TABLE vehicle_type.vehicle_type (
    vehicle_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    label text NOT NULL,
    description_i18n jsonb
);


ALTER TABLE vehicle_type.vehicle_type OWNER TO dbhasura;

--
-- Name: journey_pattern_ref process_queued_validation_on_jpr_trigger; Type: TRIGGER; Schema: journey_pattern; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER process_queued_validation_on_jpr_trigger AFTER INSERT OR UPDATE ON journey_pattern.journey_pattern_ref DEFERRABLE INITIALLY DEFERRED FOR EACH ROW WHEN ((NOT internal_utils.queued_validations_already_processed())) EXECUTE FUNCTION internal_utils.execute_queued_validations();

--
-- Name: journey_pattern_ref queue_jpr_validation_on_insert_trigger; Type: TRIGGER; Schema: journey_pattern; Owner: dbhasura
--

CREATE TRIGGER queue_jpr_validation_on_insert_trigger AFTER INSERT ON journey_pattern.journey_pattern_ref REFERENCING NEW TABLE AS modified_table FOR EACH STATEMENT EXECUTE FUNCTION journey_pattern.queue_validation_by_jpr_id();

--
-- Name: journey_pattern_ref queue_jpr_validation_on_update_trigger; Type: TRIGGER; Schema: journey_pattern; Owner: dbhasura
--

CREATE TRIGGER queue_jpr_validation_on_update_trigger AFTER UPDATE ON journey_pattern.journey_pattern_ref REFERENCING NEW TABLE AS modified_table FOR EACH STATEMENT EXECUTE FUNCTION journey_pattern.queue_validation_by_jpr_id();

--
-- Name: timetabled_passing_time process_queued_validation_on_pt_trigger; Type: TRIGGER; Schema: passing_times; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER process_queued_validation_on_pt_trigger AFTER INSERT OR DELETE OR UPDATE ON passing_times.timetabled_passing_time DEFERRABLE INITIALLY DEFERRED FOR EACH ROW WHEN ((NOT internal_utils.queued_validations_already_processed())) EXECUTE FUNCTION internal_utils.execute_queued_validations();

--
-- Name: timetabled_passing_time queue_vj_validation_on_pt_delete_trigger; Type: TRIGGER; Schema: passing_times; Owner: dbhasura
--

CREATE TRIGGER queue_vj_validation_on_pt_delete_trigger AFTER DELETE ON passing_times.timetabled_passing_time REFERENCING OLD TABLE AS modified_table FOR EACH STATEMENT EXECUTE FUNCTION vehicle_journey.queue_validation_by_vj_id();

--
-- Name: timetabled_passing_time queue_vj_validation_on_pt_insert_trigger; Type: TRIGGER; Schema: passing_times; Owner: dbhasura
--

CREATE TRIGGER queue_vj_validation_on_pt_insert_trigger AFTER INSERT ON passing_times.timetabled_passing_time REFERENCING NEW TABLE AS modified_table FOR EACH STATEMENT EXECUTE FUNCTION vehicle_journey.queue_validation_by_vj_id();

--
-- Name: timetabled_passing_time queue_vj_validation_on_pt_update_trigger; Type: TRIGGER; Schema: passing_times; Owner: dbhasura
--

CREATE TRIGGER queue_vj_validation_on_pt_update_trigger AFTER UPDATE ON passing_times.timetabled_passing_time REFERENCING NEW TABLE AS modified_table FOR EACH STATEMENT EXECUTE FUNCTION vehicle_journey.queue_validation_by_vj_id();

--
-- Name: scheduled_stop_point_in_journey_pattern_ref process_queued_validation_on_ssp_trigger; Type: TRIGGER; Schema: service_pattern; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER process_queued_validation_on_ssp_trigger AFTER INSERT OR UPDATE ON service_pattern.scheduled_stop_point_in_journey_pattern_ref DEFERRABLE INITIALLY DEFERRED FOR EACH ROW WHEN ((NOT internal_utils.queued_validations_already_processed())) EXECUTE FUNCTION internal_utils.execute_queued_validations();

--
-- Name: scheduled_stop_point_in_journey_pattern_ref queue_jpr_validation_on_ssp_insert_trigger; Type: TRIGGER; Schema: service_pattern; Owner: dbhasura
--

CREATE TRIGGER queue_jpr_validation_on_ssp_insert_trigger AFTER INSERT ON service_pattern.scheduled_stop_point_in_journey_pattern_ref REFERENCING NEW TABLE AS modified_table FOR EACH STATEMENT EXECUTE FUNCTION journey_pattern.queue_validation_by_jpr_id();

--
-- Name: scheduled_stop_point_in_journey_pattern_ref queue_jpr_validation_on_ssp_update_trigger; Type: TRIGGER; Schema: service_pattern; Owner: dbhasura
--

CREATE TRIGGER queue_jpr_validation_on_ssp_update_trigger AFTER UPDATE ON service_pattern.scheduled_stop_point_in_journey_pattern_ref REFERENCING NEW TABLE AS modified_table FOR EACH STATEMENT EXECUTE FUNCTION journey_pattern.queue_validation_by_jpr_id();

--
-- Name: vehicle_journey process_queued_validation_on_vj_trigger; Type: TRIGGER; Schema: vehicle_journey; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER process_queued_validation_on_vj_trigger AFTER INSERT OR DELETE OR UPDATE ON vehicle_journey.vehicle_journey DEFERRABLE INITIALLY DEFERRED FOR EACH ROW WHEN ((NOT internal_utils.queued_validations_already_processed())) EXECUTE FUNCTION internal_utils.execute_queued_validations();

--
-- Name: vehicle_journey queue_vj_validation_on_insert_trigger; Type: TRIGGER; Schema: vehicle_journey; Owner: dbhasura
--

CREATE TRIGGER queue_vj_validation_on_insert_trigger AFTER INSERT ON vehicle_journey.vehicle_journey REFERENCING NEW TABLE AS modified_table FOR EACH STATEMENT EXECUTE FUNCTION vehicle_journey.queue_validation_by_vj_id();

--
-- Name: vehicle_journey queue_vj_validation_on_update_trigger; Type: TRIGGER; Schema: vehicle_journey; Owner: dbhasura
--

CREATE TRIGGER queue_vj_validation_on_update_trigger AFTER UPDATE ON vehicle_journey.vehicle_journey REFERENCING NEW TABLE AS modified_table FOR EACH STATEMENT EXECUTE FUNCTION vehicle_journey.queue_validation_by_vj_id();

--
-- Name: vehicle_schedule_frame process_queued_validation_on_vsf_trigger; Type: TRIGGER; Schema: vehicle_schedule; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER process_queued_validation_on_vsf_trigger AFTER INSERT OR UPDATE ON vehicle_schedule.vehicle_schedule_frame DEFERRABLE INITIALLY DEFERRED FOR EACH ROW WHEN ((NOT internal_utils.queued_validations_already_processed())) EXECUTE FUNCTION internal_utils.execute_queued_validations();

--
-- Name: vehicle_schedule_frame queue_vsf_validation_on_insert_trigger; Type: TRIGGER; Schema: vehicle_schedule; Owner: dbhasura
--

CREATE TRIGGER queue_vsf_validation_on_insert_trigger AFTER INSERT ON vehicle_schedule.vehicle_schedule_frame REFERENCING NEW TABLE AS modified_table FOR EACH STATEMENT EXECUTE FUNCTION vehicle_schedule.queue_validation_by_vsf_id();

--
-- Name: vehicle_schedule_frame queue_vsf_validation_on_update_trigger; Type: TRIGGER; Schema: vehicle_schedule; Owner: dbhasura
--

CREATE TRIGGER queue_vsf_validation_on_update_trigger AFTER UPDATE ON vehicle_schedule.vehicle_schedule_frame REFERENCING NEW TABLE AS modified_table FOR EACH STATEMENT EXECUTE FUNCTION vehicle_schedule.queue_validation_by_vsf_id();

--
-- Name: block process_queued_validation_on_block_trigger; Type: TRIGGER; Schema: vehicle_service; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER process_queued_validation_on_block_trigger AFTER UPDATE ON vehicle_service.block DEFERRABLE INITIALLY DEFERRED FOR EACH ROW WHEN ((NOT internal_utils.queued_validations_already_processed())) EXECUTE FUNCTION internal_utils.execute_queued_validations();

--
-- Name: block queue_block_validation_on_update_trigger; Type: TRIGGER; Schema: vehicle_service; Owner: dbhasura
--

CREATE TRIGGER queue_block_validation_on_update_trigger AFTER UPDATE ON vehicle_service.block REFERENCING NEW TABLE AS modified_table FOR EACH STATEMENT EXECUTE FUNCTION vehicle_service.queue_validation_by_block_id();

--
-- Name: vehicle_service process_queued_validation_on_vs_trigger; Type: TRIGGER; Schema: vehicle_service; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER process_queued_validation_on_vs_trigger AFTER UPDATE ON vehicle_service.vehicle_service DEFERRABLE INITIALLY DEFERRED FOR EACH ROW WHEN ((NOT internal_utils.queued_validations_already_processed())) EXECUTE FUNCTION internal_utils.execute_queued_validations();

--
-- Name: vehicle_service queue_vs_validation_on_update_trigger; Type: TRIGGER; Schema: vehicle_service; Owner: dbhasura
--

CREATE TRIGGER queue_vs_validation_on_update_trigger AFTER UPDATE ON vehicle_service.vehicle_service REFERENCING NEW TABLE AS modified_table FOR EACH STATEMENT EXECUTE FUNCTION vehicle_service.queue_validation_by_vs_id();

--
-- Sorted dump complete
--
