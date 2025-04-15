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
-- Name: SCHEMA infrastructure_network; Type: ACL; Schema: -; Owner: dbhasura
--

GRANT USAGE ON SCHEMA infrastructure_network TO dbimporter;

--
-- Name: SCHEMA internal_service_pattern; Type: ACL; Schema: -; Owner: dbhasura
--

GRANT USAGE ON SCHEMA internal_service_pattern TO dbimporter;

--
-- Name: SCHEMA internal_utils; Type: ACL; Schema: -; Owner: dbhasura
--

GRANT USAGE ON SCHEMA internal_utils TO dbimporter;

--
-- Name: SCHEMA journey_pattern; Type: ACL; Schema: -; Owner: dbhasura
--

GRANT USAGE ON SCHEMA journey_pattern TO dbimporter;

--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: dbadmin
--

GRANT ALL ON SCHEMA public TO dbhasura;
GRANT USAGE ON SCHEMA public TO dbimporter;

--
-- Name: SCHEMA reusable_components; Type: ACL; Schema: -; Owner: dbhasura
--

GRANT USAGE ON SCHEMA reusable_components TO dbimporter;

--
-- Name: SCHEMA route; Type: ACL; Schema: -; Owner: dbhasura
--

GRANT USAGE ON SCHEMA route TO dbimporter;

--
-- Name: SCHEMA service_pattern; Type: ACL; Schema: -; Owner: dbhasura
--

GRANT USAGE ON SCHEMA service_pattern TO dbimporter;

--
-- Name: SCHEMA timing_pattern; Type: ACL; Schema: -; Owner: dbhasura
--

GRANT USAGE ON SCHEMA timing_pattern TO dbimporter;

--
-- Name: TABLE direction; Type: ACL; Schema: infrastructure_network; Owner: dbhasura
--

GRANT SELECT ON TABLE infrastructure_network.direction TO dbimporter;

--
-- Name: TABLE external_source; Type: ACL; Schema: infrastructure_network; Owner: dbhasura
--

GRANT SELECT ON TABLE infrastructure_network.external_source TO dbimporter;

--
-- Name: TABLE infrastructure_link; Type: ACL; Schema: infrastructure_network; Owner: dbhasura
--

GRANT SELECT ON TABLE infrastructure_network.infrastructure_link TO dbimporter;

--
-- Name: TABLE vehicle_submode_on_infrastructure_link; Type: ACL; Schema: infrastructure_network; Owner: dbhasura
--

GRANT SELECT ON TABLE infrastructure_network.vehicle_submode_on_infrastructure_link TO dbimporter;

--
-- Name: TABLE journey_pattern; Type: ACL; Schema: journey_pattern; Owner: dbhasura
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE journey_pattern.journey_pattern TO dbimporter;

--
-- Name: TABLE scheduled_stop_point_in_journey_pattern; Type: ACL; Schema: journey_pattern; Owner: dbhasura
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE journey_pattern.scheduled_stop_point_in_journey_pattern TO dbimporter;

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
-- Name: FUNCTION _postgis_deprecate(oldname text, newname text, version text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._postgis_deprecate(oldname text, newname text, version text) TO dbhasura;
GRANT ALL ON FUNCTION public._postgis_deprecate(oldname text, newname text, version text) TO dbimporter;

--
-- Name: FUNCTION _postgis_index_extent(tbl regclass, col text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._postgis_index_extent(tbl regclass, col text) TO dbhasura;
GRANT ALL ON FUNCTION public._postgis_index_extent(tbl regclass, col text) TO dbimporter;

--
-- Name: FUNCTION _postgis_join_selectivity(regclass, text, regclass, text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._postgis_join_selectivity(regclass, text, regclass, text, text) TO dbhasura;
GRANT ALL ON FUNCTION public._postgis_join_selectivity(regclass, text, regclass, text, text) TO dbimporter;

--
-- Name: FUNCTION _postgis_pgsql_version(); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._postgis_pgsql_version() TO dbhasura;
GRANT ALL ON FUNCTION public._postgis_pgsql_version() TO dbimporter;

--
-- Name: FUNCTION _postgis_scripts_pgsql_version(); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._postgis_scripts_pgsql_version() TO dbhasura;
GRANT ALL ON FUNCTION public._postgis_scripts_pgsql_version() TO dbimporter;

--
-- Name: FUNCTION _postgis_selectivity(tbl regclass, att_name text, geom public.geometry, mode text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._postgis_selectivity(tbl regclass, att_name text, geom public.geometry, mode text) TO dbhasura;
GRANT ALL ON FUNCTION public._postgis_selectivity(tbl regclass, att_name text, geom public.geometry, mode text) TO dbimporter;

--
-- Name: FUNCTION _postgis_stats(tbl regclass, att_name text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._postgis_stats(tbl regclass, att_name text, text) TO dbhasura;
GRANT ALL ON FUNCTION public._postgis_stats(tbl regclass, att_name text, text) TO dbimporter;

--
-- Name: FUNCTION _st_3ddfullywithin(geom1 public.geometry, geom2 public.geometry, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_3ddfullywithin(geom1 public.geometry, geom2 public.geometry, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public._st_3ddfullywithin(geom1 public.geometry, geom2 public.geometry, double precision) TO dbimporter;

--
-- Name: FUNCTION _st_3ddwithin(geom1 public.geometry, geom2 public.geometry, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_3ddwithin(geom1 public.geometry, geom2 public.geometry, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public._st_3ddwithin(geom1 public.geometry, geom2 public.geometry, double precision) TO dbimporter;

--
-- Name: FUNCTION _st_3dintersects(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_3dintersects(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public._st_3dintersects(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION _st_asgml(integer, public.geometry, integer, integer, text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_asgml(integer, public.geometry, integer, integer, text, text) TO dbhasura;
GRANT ALL ON FUNCTION public._st_asgml(integer, public.geometry, integer, integer, text, text) TO dbimporter;

--
-- Name: FUNCTION _st_asx3d(integer, public.geometry, integer, integer, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_asx3d(integer, public.geometry, integer, integer, text) TO dbhasura;
GRANT ALL ON FUNCTION public._st_asx3d(integer, public.geometry, integer, integer, text) TO dbimporter;

--
-- Name: FUNCTION _st_bestsrid(public.geography); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_bestsrid(public.geography) TO dbhasura;
GRANT ALL ON FUNCTION public._st_bestsrid(public.geography) TO dbimporter;

--
-- Name: FUNCTION _st_bestsrid(public.geography, public.geography); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_bestsrid(public.geography, public.geography) TO dbhasura;
GRANT ALL ON FUNCTION public._st_bestsrid(public.geography, public.geography) TO dbimporter;

--
-- Name: FUNCTION _st_concavehull(param_inputgeom public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_concavehull(param_inputgeom public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public._st_concavehull(param_inputgeom public.geometry) TO dbimporter;

--
-- Name: FUNCTION _st_contains(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_contains(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public._st_contains(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION _st_containsproperly(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_containsproperly(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public._st_containsproperly(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION _st_coveredby(geog1 public.geography, geog2 public.geography); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_coveredby(geog1 public.geography, geog2 public.geography) TO dbhasura;
GRANT ALL ON FUNCTION public._st_coveredby(geog1 public.geography, geog2 public.geography) TO dbimporter;

--
-- Name: FUNCTION _st_coveredby(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_coveredby(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public._st_coveredby(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION _st_covers(geog1 public.geography, geog2 public.geography); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_covers(geog1 public.geography, geog2 public.geography) TO dbhasura;
GRANT ALL ON FUNCTION public._st_covers(geog1 public.geography, geog2 public.geography) TO dbimporter;

--
-- Name: FUNCTION _st_covers(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_covers(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public._st_covers(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION _st_crosses(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_crosses(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public._st_crosses(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION _st_dfullywithin(geom1 public.geometry, geom2 public.geometry, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_dfullywithin(geom1 public.geometry, geom2 public.geometry, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public._st_dfullywithin(geom1 public.geometry, geom2 public.geometry, double precision) TO dbimporter;

--
-- Name: FUNCTION _st_distancetree(public.geography, public.geography); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_distancetree(public.geography, public.geography) TO dbhasura;
GRANT ALL ON FUNCTION public._st_distancetree(public.geography, public.geography) TO dbimporter;

--
-- Name: FUNCTION _st_distancetree(public.geography, public.geography, double precision, boolean); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_distancetree(public.geography, public.geography, double precision, boolean) TO dbhasura;
GRANT ALL ON FUNCTION public._st_distancetree(public.geography, public.geography, double precision, boolean) TO dbimporter;

--
-- Name: FUNCTION _st_distanceuncached(public.geography, public.geography); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_distanceuncached(public.geography, public.geography) TO dbhasura;
GRANT ALL ON FUNCTION public._st_distanceuncached(public.geography, public.geography) TO dbimporter;

--
-- Name: FUNCTION _st_distanceuncached(public.geography, public.geography, boolean); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_distanceuncached(public.geography, public.geography, boolean) TO dbhasura;
GRANT ALL ON FUNCTION public._st_distanceuncached(public.geography, public.geography, boolean) TO dbimporter;

--
-- Name: FUNCTION _st_distanceuncached(public.geography, public.geography, double precision, boolean); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_distanceuncached(public.geography, public.geography, double precision, boolean) TO dbhasura;
GRANT ALL ON FUNCTION public._st_distanceuncached(public.geography, public.geography, double precision, boolean) TO dbimporter;

--
-- Name: FUNCTION _st_dwithin(geog1 public.geography, geog2 public.geography, tolerance double precision, use_spheroid boolean); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_dwithin(geog1 public.geography, geog2 public.geography, tolerance double precision, use_spheroid boolean) TO dbhasura;
GRANT ALL ON FUNCTION public._st_dwithin(geog1 public.geography, geog2 public.geography, tolerance double precision, use_spheroid boolean) TO dbimporter;

--
-- Name: FUNCTION _st_dwithin(geom1 public.geometry, geom2 public.geometry, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_dwithin(geom1 public.geometry, geom2 public.geometry, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public._st_dwithin(geom1 public.geometry, geom2 public.geometry, double precision) TO dbimporter;

--
-- Name: FUNCTION _st_dwithinuncached(public.geography, public.geography, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_dwithinuncached(public.geography, public.geography, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public._st_dwithinuncached(public.geography, public.geography, double precision) TO dbimporter;

--
-- Name: FUNCTION _st_dwithinuncached(public.geography, public.geography, double precision, boolean); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_dwithinuncached(public.geography, public.geography, double precision, boolean) TO dbhasura;
GRANT ALL ON FUNCTION public._st_dwithinuncached(public.geography, public.geography, double precision, boolean) TO dbimporter;

--
-- Name: FUNCTION _st_equals(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_equals(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public._st_equals(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION _st_expand(public.geography, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_expand(public.geography, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public._st_expand(public.geography, double precision) TO dbimporter;

--
-- Name: FUNCTION _st_geomfromgml(text, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_geomfromgml(text, integer) TO dbhasura;
GRANT ALL ON FUNCTION public._st_geomfromgml(text, integer) TO dbimporter;

--
-- Name: FUNCTION _st_intersects(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_intersects(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public._st_intersects(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION _st_linecrossingdirection(line1 public.geometry, line2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_linecrossingdirection(line1 public.geometry, line2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public._st_linecrossingdirection(line1 public.geometry, line2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION _st_longestline(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_longestline(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public._st_longestline(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION _st_maxdistance(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_maxdistance(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public._st_maxdistance(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION _st_orderingequals(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_orderingequals(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public._st_orderingequals(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION _st_overlaps(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_overlaps(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public._st_overlaps(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION _st_pointoutside(public.geography); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_pointoutside(public.geography) TO dbhasura;
GRANT ALL ON FUNCTION public._st_pointoutside(public.geography) TO dbimporter;

--
-- Name: FUNCTION _st_sortablehash(geom public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_sortablehash(geom public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public._st_sortablehash(geom public.geometry) TO dbimporter;

--
-- Name: FUNCTION _st_touches(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_touches(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public._st_touches(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION _st_voronoi(g1 public.geometry, clip public.geometry, tolerance double precision, return_polygons boolean); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_voronoi(g1 public.geometry, clip public.geometry, tolerance double precision, return_polygons boolean) TO dbhasura;
GRANT ALL ON FUNCTION public._st_voronoi(g1 public.geometry, clip public.geometry, tolerance double precision, return_polygons boolean) TO dbimporter;

--
-- Name: FUNCTION _st_within(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public._st_within(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public._st_within(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION addauth(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.addauth(text) TO dbhasura;
GRANT ALL ON FUNCTION public.addauth(text) TO dbimporter;

--
-- Name: FUNCTION addgeometrycolumn(catalog_name character varying, schema_name character varying, table_name character varying, column_name character varying, new_srid_in integer, new_type character varying, new_dim integer, use_typmod boolean); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.addgeometrycolumn(catalog_name character varying, schema_name character varying, table_name character varying, column_name character varying, new_srid_in integer, new_type character varying, new_dim integer, use_typmod boolean) TO dbhasura;
GRANT ALL ON FUNCTION public.addgeometrycolumn(catalog_name character varying, schema_name character varying, table_name character varying, column_name character varying, new_srid_in integer, new_type character varying, new_dim integer, use_typmod boolean) TO dbimporter;

--
-- Name: FUNCTION addgeometrycolumn(schema_name character varying, table_name character varying, column_name character varying, new_srid integer, new_type character varying, new_dim integer, use_typmod boolean); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.addgeometrycolumn(schema_name character varying, table_name character varying, column_name character varying, new_srid integer, new_type character varying, new_dim integer, use_typmod boolean) TO dbhasura;
GRANT ALL ON FUNCTION public.addgeometrycolumn(schema_name character varying, table_name character varying, column_name character varying, new_srid integer, new_type character varying, new_dim integer, use_typmod boolean) TO dbimporter;

--
-- Name: FUNCTION addgeometrycolumn(table_name character varying, column_name character varying, new_srid integer, new_type character varying, new_dim integer, use_typmod boolean); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.addgeometrycolumn(table_name character varying, column_name character varying, new_srid integer, new_type character varying, new_dim integer, use_typmod boolean) TO dbhasura;
GRANT ALL ON FUNCTION public.addgeometrycolumn(table_name character varying, column_name character varying, new_srid integer, new_type character varying, new_dim integer, use_typmod boolean) TO dbimporter;

--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.armor(bytea) TO dbhasura;
GRANT ALL ON FUNCTION public.armor(bytea) TO dbimporter;

--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.armor(bytea, text[], text[]) TO dbhasura;
GRANT ALL ON FUNCTION public.armor(bytea, text[], text[]) TO dbimporter;

--
-- Name: FUNCTION box(public.box3d); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.box(public.box3d) TO dbhasura;
GRANT ALL ON FUNCTION public.box(public.box3d) TO dbimporter;

--
-- Name: FUNCTION box(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.box(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.box(public.geometry) TO dbimporter;

--
-- Name: FUNCTION box2d(public.box3d); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.box2d(public.box3d) TO dbhasura;
GRANT ALL ON FUNCTION public.box2d(public.box3d) TO dbimporter;

--
-- Name: FUNCTION box2d(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.box2d(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.box2d(public.geometry) TO dbimporter;

--
-- Name: FUNCTION box2d_in(cstring); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.box2d_in(cstring) TO dbhasura;
GRANT ALL ON FUNCTION public.box2d_in(cstring) TO dbimporter;

--
-- Name: FUNCTION box2d_out(public.box2d); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.box2d_out(public.box2d) TO dbhasura;
GRANT ALL ON FUNCTION public.box2d_out(public.box2d) TO dbimporter;

--
-- Name: FUNCTION box2df_in(cstring); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.box2df_in(cstring) TO dbhasura;
GRANT ALL ON FUNCTION public.box2df_in(cstring) TO dbimporter;

--
-- Name: FUNCTION box2df_out(public.box2df); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.box2df_out(public.box2df) TO dbhasura;
GRANT ALL ON FUNCTION public.box2df_out(public.box2df) TO dbimporter;

--
-- Name: FUNCTION box3d(public.box2d); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.box3d(public.box2d) TO dbhasura;
GRANT ALL ON FUNCTION public.box3d(public.box2d) TO dbimporter;

--
-- Name: FUNCTION box3d(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.box3d(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.box3d(public.geometry) TO dbimporter;

--
-- Name: FUNCTION box3d_in(cstring); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.box3d_in(cstring) TO dbhasura;
GRANT ALL ON FUNCTION public.box3d_in(cstring) TO dbimporter;

--
-- Name: FUNCTION box3d_out(public.box3d); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.box3d_out(public.box3d) TO dbhasura;
GRANT ALL ON FUNCTION public.box3d_out(public.box3d) TO dbimporter;

--
-- Name: FUNCTION box3dtobox(public.box3d); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.box3dtobox(public.box3d) TO dbhasura;
GRANT ALL ON FUNCTION public.box3dtobox(public.box3d) TO dbimporter;

--
-- Name: FUNCTION bytea(public.geography); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.bytea(public.geography) TO dbhasura;
GRANT ALL ON FUNCTION public.bytea(public.geography) TO dbimporter;

--
-- Name: FUNCTION bytea(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.bytea(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.bytea(public.geometry) TO dbimporter;

--
-- Name: FUNCTION cash_dist(money, money); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.cash_dist(money, money) TO dbhasura;
GRANT ALL ON FUNCTION public.cash_dist(money, money) TO dbimporter;

--
-- Name: FUNCTION checkauth(text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.checkauth(text, text) TO dbhasura;
GRANT ALL ON FUNCTION public.checkauth(text, text) TO dbimporter;

--
-- Name: FUNCTION checkauth(text, text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.checkauth(text, text, text) TO dbhasura;
GRANT ALL ON FUNCTION public.checkauth(text, text, text) TO dbimporter;

--
-- Name: FUNCTION checkauthtrigger(); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.checkauthtrigger() TO dbhasura;
GRANT ALL ON FUNCTION public.checkauthtrigger() TO dbimporter;

--
-- Name: FUNCTION contains_2d(public.box2df, public.box2df); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.contains_2d(public.box2df, public.box2df) TO dbhasura;
GRANT ALL ON FUNCTION public.contains_2d(public.box2df, public.box2df) TO dbimporter;

--
-- Name: FUNCTION contains_2d(public.box2df, public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.contains_2d(public.box2df, public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.contains_2d(public.box2df, public.geometry) TO dbimporter;

--
-- Name: FUNCTION contains_2d(public.geometry, public.box2df); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.contains_2d(public.geometry, public.box2df) TO dbhasura;
GRANT ALL ON FUNCTION public.contains_2d(public.geometry, public.box2df) TO dbimporter;

--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.crypt(text, text) TO dbhasura;
GRANT ALL ON FUNCTION public.crypt(text, text) TO dbimporter;

--
-- Name: FUNCTION date_dist(date, date); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.date_dist(date, date) TO dbhasura;
GRANT ALL ON FUNCTION public.date_dist(date, date) TO dbimporter;

--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.dearmor(text) TO dbhasura;
GRANT ALL ON FUNCTION public.dearmor(text) TO dbimporter;

--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.decrypt(bytea, bytea, text) TO dbhasura;
GRANT ALL ON FUNCTION public.decrypt(bytea, bytea, text) TO dbimporter;

--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.decrypt_iv(bytea, bytea, bytea, text) TO dbhasura;
GRANT ALL ON FUNCTION public.decrypt_iv(bytea, bytea, bytea, text) TO dbimporter;

--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.digest(bytea, text) TO dbhasura;
GRANT ALL ON FUNCTION public.digest(bytea, text) TO dbimporter;

--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.digest(text, text) TO dbhasura;
GRANT ALL ON FUNCTION public.digest(text, text) TO dbimporter;

--
-- Name: FUNCTION disablelongtransactions(); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.disablelongtransactions() TO dbhasura;
GRANT ALL ON FUNCTION public.disablelongtransactions() TO dbimporter;

--
-- Name: FUNCTION dropgeometrycolumn(catalog_name character varying, schema_name character varying, table_name character varying, column_name character varying); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.dropgeometrycolumn(catalog_name character varying, schema_name character varying, table_name character varying, column_name character varying) TO dbhasura;
GRANT ALL ON FUNCTION public.dropgeometrycolumn(catalog_name character varying, schema_name character varying, table_name character varying, column_name character varying) TO dbimporter;

--
-- Name: FUNCTION dropgeometrycolumn(schema_name character varying, table_name character varying, column_name character varying); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.dropgeometrycolumn(schema_name character varying, table_name character varying, column_name character varying) TO dbhasura;
GRANT ALL ON FUNCTION public.dropgeometrycolumn(schema_name character varying, table_name character varying, column_name character varying) TO dbimporter;

--
-- Name: FUNCTION dropgeometrycolumn(table_name character varying, column_name character varying); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.dropgeometrycolumn(table_name character varying, column_name character varying) TO dbhasura;
GRANT ALL ON FUNCTION public.dropgeometrycolumn(table_name character varying, column_name character varying) TO dbimporter;

--
-- Name: FUNCTION dropgeometrytable(catalog_name character varying, schema_name character varying, table_name character varying); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.dropgeometrytable(catalog_name character varying, schema_name character varying, table_name character varying) TO dbhasura;
GRANT ALL ON FUNCTION public.dropgeometrytable(catalog_name character varying, schema_name character varying, table_name character varying) TO dbimporter;

--
-- Name: FUNCTION dropgeometrytable(schema_name character varying, table_name character varying); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.dropgeometrytable(schema_name character varying, table_name character varying) TO dbhasura;
GRANT ALL ON FUNCTION public.dropgeometrytable(schema_name character varying, table_name character varying) TO dbimporter;

--
-- Name: FUNCTION dropgeometrytable(table_name character varying); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.dropgeometrytable(table_name character varying) TO dbhasura;
GRANT ALL ON FUNCTION public.dropgeometrytable(table_name character varying) TO dbimporter;

--
-- Name: FUNCTION enablelongtransactions(); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.enablelongtransactions() TO dbhasura;
GRANT ALL ON FUNCTION public.enablelongtransactions() TO dbimporter;

--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.encrypt(bytea, bytea, text) TO dbhasura;
GRANT ALL ON FUNCTION public.encrypt(bytea, bytea, text) TO dbimporter;

--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.encrypt_iv(bytea, bytea, bytea, text) TO dbhasura;
GRANT ALL ON FUNCTION public.encrypt_iv(bytea, bytea, bytea, text) TO dbimporter;

--
-- Name: FUNCTION equals(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.equals(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.equals(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION find_srid(character varying, character varying, character varying); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.find_srid(character varying, character varying, character varying) TO dbhasura;
GRANT ALL ON FUNCTION public.find_srid(character varying, character varying, character varying) TO dbimporter;

--
-- Name: FUNCTION float4_dist(real, real); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.float4_dist(real, real) TO dbhasura;
GRANT ALL ON FUNCTION public.float4_dist(real, real) TO dbimporter;

--
-- Name: FUNCTION float8_dist(double precision, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.float8_dist(double precision, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.float8_dist(double precision, double precision) TO dbimporter;

--
-- Name: FUNCTION gbt_bit_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bit_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bit_compress(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_bit_consistent(internal, bit, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bit_consistent(internal, bit, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bit_consistent(internal, bit, smallint, oid, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_bit_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bit_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bit_penalty(internal, internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_bit_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bit_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bit_picksplit(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_bit_same(public.gbtreekey_var, public.gbtreekey_var, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bit_same(public.gbtreekey_var, public.gbtreekey_var, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bit_same(public.gbtreekey_var, public.gbtreekey_var, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_bit_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bit_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bit_union(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_bool_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bool_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bool_compress(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_bool_consistent(internal, boolean, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bool_consistent(internal, boolean, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bool_consistent(internal, boolean, smallint, oid, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_bool_fetch(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bool_fetch(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bool_fetch(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_bool_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bool_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bool_penalty(internal, internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_bool_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bool_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bool_picksplit(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_bool_same(public.gbtreekey2, public.gbtreekey2, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bool_same(public.gbtreekey2, public.gbtreekey2, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bool_same(public.gbtreekey2, public.gbtreekey2, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_bool_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bool_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bool_union(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_bpchar_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bpchar_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bpchar_compress(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_bpchar_consistent(internal, character, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bpchar_consistent(internal, character, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bpchar_consistent(internal, character, smallint, oid, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_bytea_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bytea_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bytea_compress(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_bytea_consistent(internal, bytea, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bytea_consistent(internal, bytea, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bytea_consistent(internal, bytea, smallint, oid, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_bytea_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bytea_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bytea_penalty(internal, internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_bytea_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bytea_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bytea_picksplit(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_bytea_same(public.gbtreekey_var, public.gbtreekey_var, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bytea_same(public.gbtreekey_var, public.gbtreekey_var, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bytea_same(public.gbtreekey_var, public.gbtreekey_var, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_bytea_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_bytea_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_bytea_union(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_cash_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_cash_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_cash_compress(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_cash_consistent(internal, money, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_cash_consistent(internal, money, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_cash_consistent(internal, money, smallint, oid, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_cash_distance(internal, money, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_cash_distance(internal, money, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_cash_distance(internal, money, smallint, oid, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_cash_fetch(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_cash_fetch(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_cash_fetch(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_cash_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_cash_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_cash_penalty(internal, internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_cash_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_cash_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_cash_picksplit(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_cash_same(public.gbtreekey16, public.gbtreekey16, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_cash_same(public.gbtreekey16, public.gbtreekey16, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_cash_same(public.gbtreekey16, public.gbtreekey16, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_cash_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_cash_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_cash_union(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_date_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_date_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_date_compress(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_date_consistent(internal, date, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_date_consistent(internal, date, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_date_consistent(internal, date, smallint, oid, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_date_distance(internal, date, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_date_distance(internal, date, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_date_distance(internal, date, smallint, oid, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_date_fetch(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_date_fetch(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_date_fetch(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_date_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_date_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_date_penalty(internal, internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_date_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_date_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_date_picksplit(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_date_same(public.gbtreekey8, public.gbtreekey8, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_date_same(public.gbtreekey8, public.gbtreekey8, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_date_same(public.gbtreekey8, public.gbtreekey8, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_date_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_date_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_date_union(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_decompress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_decompress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_decompress(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_enum_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_enum_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_enum_compress(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_enum_consistent(internal, anyenum, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_enum_consistent(internal, anyenum, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_enum_consistent(internal, anyenum, smallint, oid, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_enum_fetch(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_enum_fetch(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_enum_fetch(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_enum_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_enum_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_enum_penalty(internal, internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_enum_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_enum_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_enum_picksplit(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_enum_same(public.gbtreekey8, public.gbtreekey8, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_enum_same(public.gbtreekey8, public.gbtreekey8, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_enum_same(public.gbtreekey8, public.gbtreekey8, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_enum_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_enum_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_enum_union(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_float4_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_float4_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_float4_compress(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_float4_consistent(internal, real, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_float4_consistent(internal, real, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_float4_consistent(internal, real, smallint, oid, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_float4_distance(internal, real, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_float4_distance(internal, real, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_float4_distance(internal, real, smallint, oid, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_float4_fetch(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_float4_fetch(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_float4_fetch(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_float4_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_float4_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_float4_penalty(internal, internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_float4_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_float4_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_float4_picksplit(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_float4_same(public.gbtreekey8, public.gbtreekey8, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_float4_same(public.gbtreekey8, public.gbtreekey8, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_float4_same(public.gbtreekey8, public.gbtreekey8, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_float4_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_float4_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_float4_union(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_float8_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_float8_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_float8_compress(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_float8_consistent(internal, double precision, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_float8_consistent(internal, double precision, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_float8_consistent(internal, double precision, smallint, oid, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_float8_distance(internal, double precision, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_float8_distance(internal, double precision, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_float8_distance(internal, double precision, smallint, oid, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_float8_fetch(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_float8_fetch(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_float8_fetch(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_float8_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_float8_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_float8_penalty(internal, internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_float8_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_float8_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_float8_picksplit(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_float8_same(public.gbtreekey16, public.gbtreekey16, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_float8_same(public.gbtreekey16, public.gbtreekey16, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_float8_same(public.gbtreekey16, public.gbtreekey16, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_float8_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_float8_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_float8_union(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_inet_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_inet_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_inet_compress(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_inet_consistent(internal, inet, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_inet_consistent(internal, inet, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_inet_consistent(internal, inet, smallint, oid, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_inet_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_inet_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_inet_penalty(internal, internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_inet_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_inet_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_inet_picksplit(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_inet_same(public.gbtreekey16, public.gbtreekey16, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_inet_same(public.gbtreekey16, public.gbtreekey16, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_inet_same(public.gbtreekey16, public.gbtreekey16, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_inet_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_inet_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_inet_union(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_int2_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int2_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int2_compress(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_int2_consistent(internal, smallint, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int2_consistent(internal, smallint, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int2_consistent(internal, smallint, smallint, oid, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_int2_distance(internal, smallint, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int2_distance(internal, smallint, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int2_distance(internal, smallint, smallint, oid, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_int2_fetch(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int2_fetch(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int2_fetch(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_int2_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int2_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int2_penalty(internal, internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_int2_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int2_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int2_picksplit(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_int2_same(public.gbtreekey4, public.gbtreekey4, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int2_same(public.gbtreekey4, public.gbtreekey4, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int2_same(public.gbtreekey4, public.gbtreekey4, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_int2_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int2_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int2_union(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_int4_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int4_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int4_compress(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_int4_consistent(internal, integer, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int4_consistent(internal, integer, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int4_consistent(internal, integer, smallint, oid, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_int4_distance(internal, integer, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int4_distance(internal, integer, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int4_distance(internal, integer, smallint, oid, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_int4_fetch(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int4_fetch(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int4_fetch(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_int4_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int4_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int4_penalty(internal, internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_int4_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int4_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int4_picksplit(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_int4_same(public.gbtreekey8, public.gbtreekey8, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int4_same(public.gbtreekey8, public.gbtreekey8, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int4_same(public.gbtreekey8, public.gbtreekey8, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_int4_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int4_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int4_union(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_int8_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int8_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int8_compress(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_int8_consistent(internal, bigint, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int8_consistent(internal, bigint, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int8_consistent(internal, bigint, smallint, oid, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_int8_distance(internal, bigint, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int8_distance(internal, bigint, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int8_distance(internal, bigint, smallint, oid, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_int8_fetch(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int8_fetch(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int8_fetch(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_int8_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int8_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int8_penalty(internal, internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_int8_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int8_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int8_picksplit(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_int8_same(public.gbtreekey16, public.gbtreekey16, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int8_same(public.gbtreekey16, public.gbtreekey16, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int8_same(public.gbtreekey16, public.gbtreekey16, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_int8_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_int8_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_int8_union(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_intv_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_intv_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_intv_compress(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_intv_consistent(internal, interval, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_intv_consistent(internal, interval, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_intv_consistent(internal, interval, smallint, oid, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_intv_decompress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_intv_decompress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_intv_decompress(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_intv_distance(internal, interval, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_intv_distance(internal, interval, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_intv_distance(internal, interval, smallint, oid, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_intv_fetch(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_intv_fetch(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_intv_fetch(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_intv_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_intv_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_intv_penalty(internal, internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_intv_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_intv_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_intv_picksplit(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_intv_same(public.gbtreekey32, public.gbtreekey32, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_intv_same(public.gbtreekey32, public.gbtreekey32, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_intv_same(public.gbtreekey32, public.gbtreekey32, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_intv_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_intv_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_intv_union(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_macad8_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_macad8_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_macad8_compress(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_macad8_consistent(internal, macaddr8, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_macad8_consistent(internal, macaddr8, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_macad8_consistent(internal, macaddr8, smallint, oid, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_macad8_fetch(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_macad8_fetch(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_macad8_fetch(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_macad8_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_macad8_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_macad8_penalty(internal, internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_macad8_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_macad8_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_macad8_picksplit(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_macad8_same(public.gbtreekey16, public.gbtreekey16, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_macad8_same(public.gbtreekey16, public.gbtreekey16, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_macad8_same(public.gbtreekey16, public.gbtreekey16, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_macad8_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_macad8_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_macad8_union(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_macad_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_macad_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_macad_compress(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_macad_consistent(internal, macaddr, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_macad_consistent(internal, macaddr, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_macad_consistent(internal, macaddr, smallint, oid, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_macad_fetch(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_macad_fetch(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_macad_fetch(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_macad_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_macad_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_macad_penalty(internal, internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_macad_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_macad_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_macad_picksplit(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_macad_same(public.gbtreekey16, public.gbtreekey16, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_macad_same(public.gbtreekey16, public.gbtreekey16, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_macad_same(public.gbtreekey16, public.gbtreekey16, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_macad_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_macad_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_macad_union(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_numeric_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_numeric_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_numeric_compress(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_numeric_consistent(internal, numeric, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_numeric_consistent(internal, numeric, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_numeric_consistent(internal, numeric, smallint, oid, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_numeric_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_numeric_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_numeric_penalty(internal, internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_numeric_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_numeric_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_numeric_picksplit(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_numeric_same(public.gbtreekey_var, public.gbtreekey_var, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_numeric_same(public.gbtreekey_var, public.gbtreekey_var, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_numeric_same(public.gbtreekey_var, public.gbtreekey_var, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_numeric_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_numeric_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_numeric_union(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_oid_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_oid_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_oid_compress(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_oid_consistent(internal, oid, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_oid_consistent(internal, oid, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_oid_consistent(internal, oid, smallint, oid, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_oid_distance(internal, oid, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_oid_distance(internal, oid, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_oid_distance(internal, oid, smallint, oid, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_oid_fetch(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_oid_fetch(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_oid_fetch(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_oid_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_oid_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_oid_penalty(internal, internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_oid_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_oid_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_oid_picksplit(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_oid_same(public.gbtreekey8, public.gbtreekey8, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_oid_same(public.gbtreekey8, public.gbtreekey8, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_oid_same(public.gbtreekey8, public.gbtreekey8, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_oid_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_oid_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_oid_union(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_text_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_text_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_text_compress(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_text_consistent(internal, text, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_text_consistent(internal, text, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_text_consistent(internal, text, smallint, oid, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_text_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_text_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_text_penalty(internal, internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_text_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_text_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_text_picksplit(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_text_same(public.gbtreekey_var, public.gbtreekey_var, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_text_same(public.gbtreekey_var, public.gbtreekey_var, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_text_same(public.gbtreekey_var, public.gbtreekey_var, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_text_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_text_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_text_union(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_time_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_time_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_time_compress(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_time_consistent(internal, time without time zone, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_time_consistent(internal, time without time zone, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_time_consistent(internal, time without time zone, smallint, oid, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_time_distance(internal, time without time zone, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_time_distance(internal, time without time zone, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_time_distance(internal, time without time zone, smallint, oid, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_time_fetch(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_time_fetch(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_time_fetch(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_time_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_time_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_time_penalty(internal, internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_time_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_time_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_time_picksplit(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_time_same(public.gbtreekey16, public.gbtreekey16, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_time_same(public.gbtreekey16, public.gbtreekey16, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_time_same(public.gbtreekey16, public.gbtreekey16, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_time_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_time_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_time_union(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_timetz_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_timetz_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_timetz_compress(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_timetz_consistent(internal, time with time zone, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_timetz_consistent(internal, time with time zone, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_timetz_consistent(internal, time with time zone, smallint, oid, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_ts_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_ts_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_ts_compress(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_ts_consistent(internal, timestamp without time zone, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_ts_consistent(internal, timestamp without time zone, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_ts_consistent(internal, timestamp without time zone, smallint, oid, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_ts_distance(internal, timestamp without time zone, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_ts_distance(internal, timestamp without time zone, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_ts_distance(internal, timestamp without time zone, smallint, oid, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_ts_fetch(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_ts_fetch(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_ts_fetch(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_ts_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_ts_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_ts_penalty(internal, internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_ts_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_ts_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_ts_picksplit(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_ts_same(public.gbtreekey16, public.gbtreekey16, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_ts_same(public.gbtreekey16, public.gbtreekey16, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_ts_same(public.gbtreekey16, public.gbtreekey16, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_ts_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_ts_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_ts_union(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_tstz_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_tstz_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_tstz_compress(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_tstz_consistent(internal, timestamp with time zone, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_tstz_consistent(internal, timestamp with time zone, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_tstz_consistent(internal, timestamp with time zone, smallint, oid, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_tstz_distance(internal, timestamp with time zone, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_tstz_distance(internal, timestamp with time zone, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_tstz_distance(internal, timestamp with time zone, smallint, oid, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_uuid_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_uuid_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_uuid_compress(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_uuid_consistent(internal, uuid, smallint, oid, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_uuid_consistent(internal, uuid, smallint, oid, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_uuid_consistent(internal, uuid, smallint, oid, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_uuid_fetch(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_uuid_fetch(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_uuid_fetch(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_uuid_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_uuid_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_uuid_penalty(internal, internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_uuid_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_uuid_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_uuid_picksplit(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_uuid_same(public.gbtreekey32, public.gbtreekey32, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_uuid_same(public.gbtreekey32, public.gbtreekey32, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_uuid_same(public.gbtreekey32, public.gbtreekey32, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_uuid_union(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_uuid_union(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_uuid_union(internal, internal) TO dbimporter;

--
-- Name: FUNCTION gbt_var_decompress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_var_decompress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_var_decompress(internal) TO dbimporter;

--
-- Name: FUNCTION gbt_var_fetch(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbt_var_fetch(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.gbt_var_fetch(internal) TO dbimporter;

--
-- Name: FUNCTION gbtreekey16_in(cstring); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbtreekey16_in(cstring) TO dbhasura;
GRANT ALL ON FUNCTION public.gbtreekey16_in(cstring) TO dbimporter;

--
-- Name: FUNCTION gbtreekey16_out(public.gbtreekey16); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbtreekey16_out(public.gbtreekey16) TO dbhasura;
GRANT ALL ON FUNCTION public.gbtreekey16_out(public.gbtreekey16) TO dbimporter;

--
-- Name: FUNCTION gbtreekey2_in(cstring); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbtreekey2_in(cstring) TO dbhasura;
GRANT ALL ON FUNCTION public.gbtreekey2_in(cstring) TO dbimporter;

--
-- Name: FUNCTION gbtreekey2_out(public.gbtreekey2); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbtreekey2_out(public.gbtreekey2) TO dbhasura;
GRANT ALL ON FUNCTION public.gbtreekey2_out(public.gbtreekey2) TO dbimporter;

--
-- Name: FUNCTION gbtreekey32_in(cstring); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbtreekey32_in(cstring) TO dbhasura;
GRANT ALL ON FUNCTION public.gbtreekey32_in(cstring) TO dbimporter;

--
-- Name: FUNCTION gbtreekey32_out(public.gbtreekey32); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbtreekey32_out(public.gbtreekey32) TO dbhasura;
GRANT ALL ON FUNCTION public.gbtreekey32_out(public.gbtreekey32) TO dbimporter;

--
-- Name: FUNCTION gbtreekey4_in(cstring); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbtreekey4_in(cstring) TO dbhasura;
GRANT ALL ON FUNCTION public.gbtreekey4_in(cstring) TO dbimporter;

--
-- Name: FUNCTION gbtreekey4_out(public.gbtreekey4); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbtreekey4_out(public.gbtreekey4) TO dbhasura;
GRANT ALL ON FUNCTION public.gbtreekey4_out(public.gbtreekey4) TO dbimporter;

--
-- Name: FUNCTION gbtreekey8_in(cstring); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbtreekey8_in(cstring) TO dbhasura;
GRANT ALL ON FUNCTION public.gbtreekey8_in(cstring) TO dbimporter;

--
-- Name: FUNCTION gbtreekey8_out(public.gbtreekey8); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbtreekey8_out(public.gbtreekey8) TO dbhasura;
GRANT ALL ON FUNCTION public.gbtreekey8_out(public.gbtreekey8) TO dbimporter;

--
-- Name: FUNCTION gbtreekey_var_in(cstring); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbtreekey_var_in(cstring) TO dbhasura;
GRANT ALL ON FUNCTION public.gbtreekey_var_in(cstring) TO dbimporter;

--
-- Name: FUNCTION gbtreekey_var_out(public.gbtreekey_var); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gbtreekey_var_out(public.gbtreekey_var) TO dbhasura;
GRANT ALL ON FUNCTION public.gbtreekey_var_out(public.gbtreekey_var) TO dbimporter;

--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gen_random_bytes(integer) TO dbhasura;
GRANT ALL ON FUNCTION public.gen_random_bytes(integer) TO dbimporter;

--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gen_random_uuid() TO dbhasura;
GRANT ALL ON FUNCTION public.gen_random_uuid() TO dbimporter;

--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gen_salt(text) TO dbhasura;
GRANT ALL ON FUNCTION public.gen_salt(text) TO dbimporter;

--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gen_salt(text, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.gen_salt(text, integer) TO dbimporter;

--
-- Name: FUNCTION geog_brin_inclusion_add_value(internal, internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geog_brin_inclusion_add_value(internal, internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geog_brin_inclusion_add_value(internal, internal, internal, internal) TO dbimporter;

--
-- Name: FUNCTION geography(bytea); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geography(bytea) TO dbhasura;
GRANT ALL ON FUNCTION public.geography(bytea) TO dbimporter;

--
-- Name: FUNCTION geography(public.geography, integer, boolean); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geography(public.geography, integer, boolean) TO dbhasura;
GRANT ALL ON FUNCTION public.geography(public.geography, integer, boolean) TO dbimporter;

--
-- Name: FUNCTION geography(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geography(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.geography(public.geometry) TO dbimporter;

--
-- Name: FUNCTION geography_analyze(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geography_analyze(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geography_analyze(internal) TO dbimporter;

--
-- Name: FUNCTION geography_cmp(public.geography, public.geography); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geography_cmp(public.geography, public.geography) TO dbhasura;
GRANT ALL ON FUNCTION public.geography_cmp(public.geography, public.geography) TO dbimporter;

--
-- Name: FUNCTION geography_distance_knn(public.geography, public.geography); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geography_distance_knn(public.geography, public.geography) TO dbhasura;
GRANT ALL ON FUNCTION public.geography_distance_knn(public.geography, public.geography) TO dbimporter;

--
-- Name: FUNCTION geography_eq(public.geography, public.geography); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geography_eq(public.geography, public.geography) TO dbhasura;
GRANT ALL ON FUNCTION public.geography_eq(public.geography, public.geography) TO dbimporter;

--
-- Name: FUNCTION geography_ge(public.geography, public.geography); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geography_ge(public.geography, public.geography) TO dbhasura;
GRANT ALL ON FUNCTION public.geography_ge(public.geography, public.geography) TO dbimporter;

--
-- Name: FUNCTION geography_gist_compress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geography_gist_compress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geography_gist_compress(internal) TO dbimporter;

--
-- Name: FUNCTION geography_gist_consistent(internal, public.geography, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geography_gist_consistent(internal, public.geography, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.geography_gist_consistent(internal, public.geography, integer) TO dbimporter;

--
-- Name: FUNCTION geography_gist_decompress(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geography_gist_decompress(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geography_gist_decompress(internal) TO dbimporter;

--
-- Name: FUNCTION geography_gist_distance(internal, public.geography, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geography_gist_distance(internal, public.geography, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.geography_gist_distance(internal, public.geography, integer) TO dbimporter;

--
-- Name: FUNCTION geography_gist_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geography_gist_penalty(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geography_gist_penalty(internal, internal, internal) TO dbimporter;

--
-- Name: FUNCTION geography_gist_picksplit(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geography_gist_picksplit(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geography_gist_picksplit(internal, internal) TO dbimporter;

--
-- Name: FUNCTION geography_gist_same(public.box2d, public.box2d, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geography_gist_same(public.box2d, public.box2d, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geography_gist_same(public.box2d, public.box2d, internal) TO dbimporter;

--
-- Name: FUNCTION geography_gist_union(bytea, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geography_gist_union(bytea, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geography_gist_union(bytea, internal) TO dbimporter;

--
-- Name: FUNCTION geography_gt(public.geography, public.geography); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geography_gt(public.geography, public.geography) TO dbhasura;
GRANT ALL ON FUNCTION public.geography_gt(public.geography, public.geography) TO dbimporter;

--
-- Name: FUNCTION geography_in(cstring, oid, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geography_in(cstring, oid, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.geography_in(cstring, oid, integer) TO dbimporter;

--
-- Name: FUNCTION geography_le(public.geography, public.geography); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geography_le(public.geography, public.geography) TO dbhasura;
GRANT ALL ON FUNCTION public.geography_le(public.geography, public.geography) TO dbimporter;

--
-- Name: FUNCTION geography_lt(public.geography, public.geography); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geography_lt(public.geography, public.geography) TO dbhasura;
GRANT ALL ON FUNCTION public.geography_lt(public.geography, public.geography) TO dbimporter;

--
-- Name: FUNCTION geography_out(public.geography); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geography_out(public.geography) TO dbhasura;
GRANT ALL ON FUNCTION public.geography_out(public.geography) TO dbimporter;

--
-- Name: FUNCTION geography_overlaps(public.geography, public.geography); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geography_overlaps(public.geography, public.geography) TO dbhasura;
GRANT ALL ON FUNCTION public.geography_overlaps(public.geography, public.geography) TO dbimporter;

--
-- Name: FUNCTION geography_recv(internal, oid, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geography_recv(internal, oid, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.geography_recv(internal, oid, integer) TO dbimporter;

--
-- Name: FUNCTION geography_send(public.geography); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geography_send(public.geography) TO dbhasura;
GRANT ALL ON FUNCTION public.geography_send(public.geography) TO dbimporter;

--
-- Name: FUNCTION geography_spgist_choose_nd(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geography_spgist_choose_nd(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geography_spgist_choose_nd(internal, internal) TO dbimporter;

--
-- Name: FUNCTION geography_spgist_compress_nd(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geography_spgist_compress_nd(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geography_spgist_compress_nd(internal) TO dbimporter;

--
-- Name: FUNCTION geography_spgist_config_nd(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geography_spgist_config_nd(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geography_spgist_config_nd(internal, internal) TO dbimporter;

--
-- Name: FUNCTION geography_spgist_inner_consistent_nd(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geography_spgist_inner_consistent_nd(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geography_spgist_inner_consistent_nd(internal, internal) TO dbimporter;

--
-- Name: FUNCTION geography_spgist_leaf_consistent_nd(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geography_spgist_leaf_consistent_nd(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geography_spgist_leaf_consistent_nd(internal, internal) TO dbimporter;

--
-- Name: FUNCTION geography_spgist_picksplit_nd(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geography_spgist_picksplit_nd(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geography_spgist_picksplit_nd(internal, internal) TO dbimporter;

--
-- Name: FUNCTION geography_typmod_in(cstring[]); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geography_typmod_in(cstring[]) TO dbhasura;
GRANT ALL ON FUNCTION public.geography_typmod_in(cstring[]) TO dbimporter;

--
-- Name: FUNCTION geography_typmod_out(integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geography_typmod_out(integer) TO dbhasura;
GRANT ALL ON FUNCTION public.geography_typmod_out(integer) TO dbimporter;

--
-- Name: FUNCTION geom2d_brin_inclusion_add_value(internal, internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geom2d_brin_inclusion_add_value(internal, internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geom2d_brin_inclusion_add_value(internal, internal, internal, internal) TO dbimporter;

--
-- Name: FUNCTION geom3d_brin_inclusion_add_value(internal, internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geom3d_brin_inclusion_add_value(internal, internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geom3d_brin_inclusion_add_value(internal, internal, internal, internal) TO dbimporter;

--
-- Name: FUNCTION geom4d_brin_inclusion_add_value(internal, internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geom4d_brin_inclusion_add_value(internal, internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geom4d_brin_inclusion_add_value(internal, internal, internal, internal) TO dbimporter;

--
-- Name: FUNCTION geometry(bytea); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry(bytea) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry(bytea) TO dbimporter;

--
-- Name: FUNCTION geometry(path); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry(path) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry(path) TO dbimporter;

--
-- Name: FUNCTION geometry(point); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry(point) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry(point) TO dbimporter;

--
-- Name: FUNCTION geometry(polygon); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry(polygon) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry(polygon) TO dbimporter;

--
-- Name: FUNCTION geometry(public.box2d); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry(public.box2d) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry(public.box2d) TO dbimporter;

--
-- Name: FUNCTION geometry(public.box3d); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry(public.box3d) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry(public.box3d) TO dbimporter;

--
-- Name: FUNCTION geometry(public.geography); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry(public.geography) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry(public.geography) TO dbimporter;

--
-- Name: FUNCTION geometry(public.geometry, integer, boolean); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry(public.geometry, integer, boolean) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry(public.geometry, integer, boolean) TO dbimporter;

--
-- Name: FUNCTION geometry(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry(text) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry(text) TO dbimporter;

--
-- Name: FUNCTION geometry_above(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_above(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_above(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION geometry_analyze(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_analyze(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_analyze(internal) TO dbimporter;

--
-- Name: FUNCTION geometry_below(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_below(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_below(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION geometry_cmp(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_cmp(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_cmp(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION geometry_contained_3d(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_contained_3d(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_contained_3d(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION geometry_contains(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_contains(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_contains(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION geometry_contains_3d(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_contains_3d(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_contains_3d(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION geometry_contains_nd(public.geometry, public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_contains_nd(public.geometry, public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_contains_nd(public.geometry, public.geometry) TO dbimporter;

--
-- Name: FUNCTION geometry_distance_box(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_distance_box(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_distance_box(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION geometry_distance_centroid(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_distance_centroid(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_distance_centroid(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION geometry_distance_centroid_nd(public.geometry, public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_distance_centroid_nd(public.geometry, public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_distance_centroid_nd(public.geometry, public.geometry) TO dbimporter;

--
-- Name: FUNCTION geometry_distance_cpa(public.geometry, public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_distance_cpa(public.geometry, public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_distance_cpa(public.geometry, public.geometry) TO dbimporter;

--
-- Name: FUNCTION geometry_eq(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_eq(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_eq(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION geometry_ge(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_ge(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_ge(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION geometry_gist_compress_2d(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_gist_compress_2d(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_gist_compress_2d(internal) TO dbimporter;

--
-- Name: FUNCTION geometry_gist_compress_nd(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_gist_compress_nd(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_gist_compress_nd(internal) TO dbimporter;

--
-- Name: FUNCTION geometry_gist_consistent_2d(internal, public.geometry, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_gist_consistent_2d(internal, public.geometry, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_gist_consistent_2d(internal, public.geometry, integer) TO dbimporter;

--
-- Name: FUNCTION geometry_gist_consistent_nd(internal, public.geometry, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_gist_consistent_nd(internal, public.geometry, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_gist_consistent_nd(internal, public.geometry, integer) TO dbimporter;

--
-- Name: FUNCTION geometry_gist_decompress_2d(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_gist_decompress_2d(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_gist_decompress_2d(internal) TO dbimporter;

--
-- Name: FUNCTION geometry_gist_decompress_nd(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_gist_decompress_nd(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_gist_decompress_nd(internal) TO dbimporter;

--
-- Name: FUNCTION geometry_gist_distance_2d(internal, public.geometry, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_gist_distance_2d(internal, public.geometry, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_gist_distance_2d(internal, public.geometry, integer) TO dbimporter;

--
-- Name: FUNCTION geometry_gist_distance_nd(internal, public.geometry, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_gist_distance_nd(internal, public.geometry, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_gist_distance_nd(internal, public.geometry, integer) TO dbimporter;

--
-- Name: FUNCTION geometry_gist_penalty_2d(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_gist_penalty_2d(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_gist_penalty_2d(internal, internal, internal) TO dbimporter;

--
-- Name: FUNCTION geometry_gist_penalty_nd(internal, internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_gist_penalty_nd(internal, internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_gist_penalty_nd(internal, internal, internal) TO dbimporter;

--
-- Name: FUNCTION geometry_gist_picksplit_2d(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_gist_picksplit_2d(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_gist_picksplit_2d(internal, internal) TO dbimporter;

--
-- Name: FUNCTION geometry_gist_picksplit_nd(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_gist_picksplit_nd(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_gist_picksplit_nd(internal, internal) TO dbimporter;

--
-- Name: FUNCTION geometry_gist_same_2d(geom1 public.geometry, geom2 public.geometry, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_gist_same_2d(geom1 public.geometry, geom2 public.geometry, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_gist_same_2d(geom1 public.geometry, geom2 public.geometry, internal) TO dbimporter;

--
-- Name: FUNCTION geometry_gist_same_nd(public.geometry, public.geometry, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_gist_same_nd(public.geometry, public.geometry, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_gist_same_nd(public.geometry, public.geometry, internal) TO dbimporter;

--
-- Name: FUNCTION geometry_gist_sortsupport_2d(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_gist_sortsupport_2d(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_gist_sortsupport_2d(internal) TO dbimporter;

--
-- Name: FUNCTION geometry_gist_union_2d(bytea, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_gist_union_2d(bytea, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_gist_union_2d(bytea, internal) TO dbimporter;

--
-- Name: FUNCTION geometry_gist_union_nd(bytea, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_gist_union_nd(bytea, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_gist_union_nd(bytea, internal) TO dbimporter;

--
-- Name: FUNCTION geometry_gt(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_gt(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_gt(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION geometry_hash(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_hash(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_hash(public.geometry) TO dbimporter;

--
-- Name: FUNCTION geometry_in(cstring); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_in(cstring) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_in(cstring) TO dbimporter;

--
-- Name: FUNCTION geometry_le(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_le(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_le(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION geometry_left(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_left(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_left(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION geometry_lt(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_lt(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_lt(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION geometry_out(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_out(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_out(public.geometry) TO dbimporter;

--
-- Name: FUNCTION geometry_overabove(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_overabove(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_overabove(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION geometry_overbelow(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_overbelow(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_overbelow(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION geometry_overlaps(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_overlaps(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_overlaps(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION geometry_overlaps_3d(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_overlaps_3d(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_overlaps_3d(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION geometry_overlaps_nd(public.geometry, public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_overlaps_nd(public.geometry, public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_overlaps_nd(public.geometry, public.geometry) TO dbimporter;

--
-- Name: FUNCTION geometry_overleft(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_overleft(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_overleft(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION geometry_overright(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_overright(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_overright(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION geometry_recv(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_recv(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_recv(internal) TO dbimporter;

--
-- Name: FUNCTION geometry_right(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_right(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_right(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION geometry_same(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_same(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_same(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION geometry_same_3d(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_same_3d(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_same_3d(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION geometry_same_nd(public.geometry, public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_same_nd(public.geometry, public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_same_nd(public.geometry, public.geometry) TO dbimporter;

--
-- Name: FUNCTION geometry_send(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_send(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_send(public.geometry) TO dbimporter;

--
-- Name: FUNCTION geometry_sortsupport(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_sortsupport(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_sortsupport(internal) TO dbimporter;

--
-- Name: FUNCTION geometry_spgist_choose_2d(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_spgist_choose_2d(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_spgist_choose_2d(internal, internal) TO dbimporter;

--
-- Name: FUNCTION geometry_spgist_choose_3d(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_spgist_choose_3d(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_spgist_choose_3d(internal, internal) TO dbimporter;

--
-- Name: FUNCTION geometry_spgist_choose_nd(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_spgist_choose_nd(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_spgist_choose_nd(internal, internal) TO dbimporter;

--
-- Name: FUNCTION geometry_spgist_compress_2d(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_spgist_compress_2d(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_spgist_compress_2d(internal) TO dbimporter;

--
-- Name: FUNCTION geometry_spgist_compress_3d(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_spgist_compress_3d(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_spgist_compress_3d(internal) TO dbimporter;

--
-- Name: FUNCTION geometry_spgist_compress_nd(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_spgist_compress_nd(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_spgist_compress_nd(internal) TO dbimporter;

--
-- Name: FUNCTION geometry_spgist_config_2d(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_spgist_config_2d(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_spgist_config_2d(internal, internal) TO dbimporter;

--
-- Name: FUNCTION geometry_spgist_config_3d(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_spgist_config_3d(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_spgist_config_3d(internal, internal) TO dbimporter;

--
-- Name: FUNCTION geometry_spgist_config_nd(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_spgist_config_nd(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_spgist_config_nd(internal, internal) TO dbimporter;

--
-- Name: FUNCTION geometry_spgist_inner_consistent_2d(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_spgist_inner_consistent_2d(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_spgist_inner_consistent_2d(internal, internal) TO dbimporter;

--
-- Name: FUNCTION geometry_spgist_inner_consistent_3d(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_spgist_inner_consistent_3d(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_spgist_inner_consistent_3d(internal, internal) TO dbimporter;

--
-- Name: FUNCTION geometry_spgist_inner_consistent_nd(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_spgist_inner_consistent_nd(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_spgist_inner_consistent_nd(internal, internal) TO dbimporter;

--
-- Name: FUNCTION geometry_spgist_leaf_consistent_2d(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_spgist_leaf_consistent_2d(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_spgist_leaf_consistent_2d(internal, internal) TO dbimporter;

--
-- Name: FUNCTION geometry_spgist_leaf_consistent_3d(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_spgist_leaf_consistent_3d(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_spgist_leaf_consistent_3d(internal, internal) TO dbimporter;

--
-- Name: FUNCTION geometry_spgist_leaf_consistent_nd(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_spgist_leaf_consistent_nd(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_spgist_leaf_consistent_nd(internal, internal) TO dbimporter;

--
-- Name: FUNCTION geometry_spgist_picksplit_2d(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_spgist_picksplit_2d(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_spgist_picksplit_2d(internal, internal) TO dbimporter;

--
-- Name: FUNCTION geometry_spgist_picksplit_3d(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_spgist_picksplit_3d(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_spgist_picksplit_3d(internal, internal) TO dbimporter;

--
-- Name: FUNCTION geometry_spgist_picksplit_nd(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_spgist_picksplit_nd(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_spgist_picksplit_nd(internal, internal) TO dbimporter;

--
-- Name: FUNCTION geometry_typmod_in(cstring[]); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_typmod_in(cstring[]) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_typmod_in(cstring[]) TO dbimporter;

--
-- Name: FUNCTION geometry_typmod_out(integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_typmod_out(integer) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_typmod_out(integer) TO dbimporter;

--
-- Name: FUNCTION geometry_within(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_within(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_within(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION geometry_within_nd(public.geometry, public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometry_within_nd(public.geometry, public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.geometry_within_nd(public.geometry, public.geometry) TO dbimporter;

--
-- Name: FUNCTION geometrytype(public.geography); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometrytype(public.geography) TO dbhasura;
GRANT ALL ON FUNCTION public.geometrytype(public.geography) TO dbimporter;

--
-- Name: FUNCTION geometrytype(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geometrytype(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.geometrytype(public.geometry) TO dbimporter;

--
-- Name: FUNCTION geomfromewkb(bytea); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geomfromewkb(bytea) TO dbhasura;
GRANT ALL ON FUNCTION public.geomfromewkb(bytea) TO dbimporter;

--
-- Name: FUNCTION geomfromewkt(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.geomfromewkt(text) TO dbhasura;
GRANT ALL ON FUNCTION public.geomfromewkt(text) TO dbimporter;

--
-- Name: FUNCTION get_proj4_from_srid(integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.get_proj4_from_srid(integer) TO dbhasura;
GRANT ALL ON FUNCTION public.get_proj4_from_srid(integer) TO dbimporter;

--
-- Name: FUNCTION gettransactionid(); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gettransactionid() TO dbhasura;
GRANT ALL ON FUNCTION public.gettransactionid() TO dbimporter;

--
-- Name: FUNCTION gidx_in(cstring); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gidx_in(cstring) TO dbhasura;
GRANT ALL ON FUNCTION public.gidx_in(cstring) TO dbimporter;

--
-- Name: FUNCTION gidx_out(public.gidx); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gidx_out(public.gidx) TO dbhasura;
GRANT ALL ON FUNCTION public.gidx_out(public.gidx) TO dbimporter;

--
-- Name: FUNCTION gserialized_gist_joinsel_2d(internal, oid, internal, smallint); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gserialized_gist_joinsel_2d(internal, oid, internal, smallint) TO dbhasura;
GRANT ALL ON FUNCTION public.gserialized_gist_joinsel_2d(internal, oid, internal, smallint) TO dbimporter;

--
-- Name: FUNCTION gserialized_gist_joinsel_nd(internal, oid, internal, smallint); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gserialized_gist_joinsel_nd(internal, oid, internal, smallint) TO dbhasura;
GRANT ALL ON FUNCTION public.gserialized_gist_joinsel_nd(internal, oid, internal, smallint) TO dbimporter;

--
-- Name: FUNCTION gserialized_gist_sel_2d(internal, oid, internal, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gserialized_gist_sel_2d(internal, oid, internal, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.gserialized_gist_sel_2d(internal, oid, internal, integer) TO dbimporter;

--
-- Name: FUNCTION gserialized_gist_sel_nd(internal, oid, internal, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.gserialized_gist_sel_nd(internal, oid, internal, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.gserialized_gist_sel_nd(internal, oid, internal, integer) TO dbimporter;

--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.hmac(bytea, bytea, text) TO dbhasura;
GRANT ALL ON FUNCTION public.hmac(bytea, bytea, text) TO dbimporter;

--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.hmac(text, text, text) TO dbhasura;
GRANT ALL ON FUNCTION public.hmac(text, text, text) TO dbimporter;

--
-- Name: FUNCTION int2_dist(smallint, smallint); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.int2_dist(smallint, smallint) TO dbhasura;
GRANT ALL ON FUNCTION public.int2_dist(smallint, smallint) TO dbimporter;

--
-- Name: FUNCTION int4_dist(integer, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.int4_dist(integer, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.int4_dist(integer, integer) TO dbimporter;

--
-- Name: FUNCTION int8_dist(bigint, bigint); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.int8_dist(bigint, bigint) TO dbhasura;
GRANT ALL ON FUNCTION public.int8_dist(bigint, bigint) TO dbimporter;

--
-- Name: FUNCTION interval_dist(interval, interval); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.interval_dist(interval, interval) TO dbhasura;
GRANT ALL ON FUNCTION public.interval_dist(interval, interval) TO dbimporter;

--
-- Name: FUNCTION is_contained_2d(public.box2df, public.box2df); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.is_contained_2d(public.box2df, public.box2df) TO dbhasura;
GRANT ALL ON FUNCTION public.is_contained_2d(public.box2df, public.box2df) TO dbimporter;

--
-- Name: FUNCTION is_contained_2d(public.box2df, public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.is_contained_2d(public.box2df, public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.is_contained_2d(public.box2df, public.geometry) TO dbimporter;

--
-- Name: FUNCTION is_contained_2d(public.geometry, public.box2df); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.is_contained_2d(public.geometry, public.box2df) TO dbhasura;
GRANT ALL ON FUNCTION public.is_contained_2d(public.geometry, public.box2df) TO dbimporter;

--
-- Name: FUNCTION json(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.json(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.json(public.geometry) TO dbimporter;

--
-- Name: FUNCTION jsonb(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.jsonb(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.jsonb(public.geometry) TO dbimporter;

--
-- Name: FUNCTION lockrow(text, text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.lockrow(text, text, text) TO dbhasura;
GRANT ALL ON FUNCTION public.lockrow(text, text, text) TO dbimporter;

--
-- Name: FUNCTION lockrow(text, text, text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.lockrow(text, text, text, text) TO dbhasura;
GRANT ALL ON FUNCTION public.lockrow(text, text, text, text) TO dbimporter;

--
-- Name: FUNCTION lockrow(text, text, text, text, timestamp without time zone); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.lockrow(text, text, text, text, timestamp without time zone) TO dbhasura;
GRANT ALL ON FUNCTION public.lockrow(text, text, text, text, timestamp without time zone) TO dbimporter;

--
-- Name: FUNCTION lockrow(text, text, text, timestamp without time zone); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.lockrow(text, text, text, timestamp without time zone) TO dbhasura;
GRANT ALL ON FUNCTION public.lockrow(text, text, text, timestamp without time zone) TO dbimporter;

--
-- Name: FUNCTION longtransactionsenabled(); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.longtransactionsenabled() TO dbhasura;
GRANT ALL ON FUNCTION public.longtransactionsenabled() TO dbimporter;

--
-- Name: FUNCTION oid_dist(oid, oid); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.oid_dist(oid, oid) TO dbhasura;
GRANT ALL ON FUNCTION public.oid_dist(oid, oid) TO dbimporter;

--
-- Name: FUNCTION overlaps_2d(public.box2df, public.box2df); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.overlaps_2d(public.box2df, public.box2df) TO dbhasura;
GRANT ALL ON FUNCTION public.overlaps_2d(public.box2df, public.box2df) TO dbimporter;

--
-- Name: FUNCTION overlaps_2d(public.box2df, public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.overlaps_2d(public.box2df, public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.overlaps_2d(public.box2df, public.geometry) TO dbimporter;

--
-- Name: FUNCTION overlaps_2d(public.geometry, public.box2df); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.overlaps_2d(public.geometry, public.box2df) TO dbhasura;
GRANT ALL ON FUNCTION public.overlaps_2d(public.geometry, public.box2df) TO dbimporter;

--
-- Name: FUNCTION overlaps_geog(public.geography, public.gidx); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.overlaps_geog(public.geography, public.gidx) TO dbhasura;
GRANT ALL ON FUNCTION public.overlaps_geog(public.geography, public.gidx) TO dbimporter;

--
-- Name: FUNCTION overlaps_geog(public.gidx, public.geography); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.overlaps_geog(public.gidx, public.geography) TO dbhasura;
GRANT ALL ON FUNCTION public.overlaps_geog(public.gidx, public.geography) TO dbimporter;

--
-- Name: FUNCTION overlaps_geog(public.gidx, public.gidx); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.overlaps_geog(public.gidx, public.gidx) TO dbhasura;
GRANT ALL ON FUNCTION public.overlaps_geog(public.gidx, public.gidx) TO dbimporter;

--
-- Name: FUNCTION overlaps_nd(public.geometry, public.gidx); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.overlaps_nd(public.geometry, public.gidx) TO dbhasura;
GRANT ALL ON FUNCTION public.overlaps_nd(public.geometry, public.gidx) TO dbimporter;

--
-- Name: FUNCTION overlaps_nd(public.gidx, public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.overlaps_nd(public.gidx, public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.overlaps_nd(public.gidx, public.geometry) TO dbimporter;

--
-- Name: FUNCTION overlaps_nd(public.gidx, public.gidx); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.overlaps_nd(public.gidx, public.gidx) TO dbhasura;
GRANT ALL ON FUNCTION public.overlaps_nd(public.gidx, public.gidx) TO dbimporter;

--
-- Name: FUNCTION path(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.path(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.path(public.geometry) TO dbimporter;

--
-- Name: FUNCTION pgis_asflatgeobuf_finalfn(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgis_asflatgeobuf_finalfn(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.pgis_asflatgeobuf_finalfn(internal) TO dbimporter;

--
-- Name: FUNCTION pgis_asflatgeobuf_transfn(internal, anyelement); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgis_asflatgeobuf_transfn(internal, anyelement) TO dbhasura;
GRANT ALL ON FUNCTION public.pgis_asflatgeobuf_transfn(internal, anyelement) TO dbimporter;

--
-- Name: FUNCTION pgis_asflatgeobuf_transfn(internal, anyelement, boolean); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgis_asflatgeobuf_transfn(internal, anyelement, boolean) TO dbhasura;
GRANT ALL ON FUNCTION public.pgis_asflatgeobuf_transfn(internal, anyelement, boolean) TO dbimporter;

--
-- Name: FUNCTION pgis_asflatgeobuf_transfn(internal, anyelement, boolean, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgis_asflatgeobuf_transfn(internal, anyelement, boolean, text) TO dbhasura;
GRANT ALL ON FUNCTION public.pgis_asflatgeobuf_transfn(internal, anyelement, boolean, text) TO dbimporter;

--
-- Name: FUNCTION pgis_asgeobuf_finalfn(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgis_asgeobuf_finalfn(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.pgis_asgeobuf_finalfn(internal) TO dbimporter;

--
-- Name: FUNCTION pgis_asgeobuf_transfn(internal, anyelement); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgis_asgeobuf_transfn(internal, anyelement) TO dbhasura;
GRANT ALL ON FUNCTION public.pgis_asgeobuf_transfn(internal, anyelement) TO dbimporter;

--
-- Name: FUNCTION pgis_asgeobuf_transfn(internal, anyelement, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgis_asgeobuf_transfn(internal, anyelement, text) TO dbhasura;
GRANT ALL ON FUNCTION public.pgis_asgeobuf_transfn(internal, anyelement, text) TO dbimporter;

--
-- Name: FUNCTION pgis_asmvt_combinefn(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgis_asmvt_combinefn(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.pgis_asmvt_combinefn(internal, internal) TO dbimporter;

--
-- Name: FUNCTION pgis_asmvt_deserialfn(bytea, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgis_asmvt_deserialfn(bytea, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.pgis_asmvt_deserialfn(bytea, internal) TO dbimporter;

--
-- Name: FUNCTION pgis_asmvt_finalfn(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgis_asmvt_finalfn(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.pgis_asmvt_finalfn(internal) TO dbimporter;

--
-- Name: FUNCTION pgis_asmvt_serialfn(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgis_asmvt_serialfn(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.pgis_asmvt_serialfn(internal) TO dbimporter;

--
-- Name: FUNCTION pgis_asmvt_transfn(internal, anyelement); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgis_asmvt_transfn(internal, anyelement) TO dbhasura;
GRANT ALL ON FUNCTION public.pgis_asmvt_transfn(internal, anyelement) TO dbimporter;

--
-- Name: FUNCTION pgis_asmvt_transfn(internal, anyelement, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgis_asmvt_transfn(internal, anyelement, text) TO dbhasura;
GRANT ALL ON FUNCTION public.pgis_asmvt_transfn(internal, anyelement, text) TO dbimporter;

--
-- Name: FUNCTION pgis_asmvt_transfn(internal, anyelement, text, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgis_asmvt_transfn(internal, anyelement, text, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.pgis_asmvt_transfn(internal, anyelement, text, integer) TO dbimporter;

--
-- Name: FUNCTION pgis_asmvt_transfn(internal, anyelement, text, integer, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgis_asmvt_transfn(internal, anyelement, text, integer, text) TO dbhasura;
GRANT ALL ON FUNCTION public.pgis_asmvt_transfn(internal, anyelement, text, integer, text) TO dbimporter;

--
-- Name: FUNCTION pgis_asmvt_transfn(internal, anyelement, text, integer, text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgis_asmvt_transfn(internal, anyelement, text, integer, text, text) TO dbhasura;
GRANT ALL ON FUNCTION public.pgis_asmvt_transfn(internal, anyelement, text, integer, text, text) TO dbimporter;

--
-- Name: FUNCTION pgis_geometry_accum_transfn(internal, public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgis_geometry_accum_transfn(internal, public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.pgis_geometry_accum_transfn(internal, public.geometry) TO dbimporter;

--
-- Name: FUNCTION pgis_geometry_accum_transfn(internal, public.geometry, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgis_geometry_accum_transfn(internal, public.geometry, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.pgis_geometry_accum_transfn(internal, public.geometry, double precision) TO dbimporter;

--
-- Name: FUNCTION pgis_geometry_accum_transfn(internal, public.geometry, double precision, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgis_geometry_accum_transfn(internal, public.geometry, double precision, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.pgis_geometry_accum_transfn(internal, public.geometry, double precision, integer) TO dbimporter;

--
-- Name: FUNCTION pgis_geometry_clusterintersecting_finalfn(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgis_geometry_clusterintersecting_finalfn(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.pgis_geometry_clusterintersecting_finalfn(internal) TO dbimporter;

--
-- Name: FUNCTION pgis_geometry_clusterwithin_finalfn(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgis_geometry_clusterwithin_finalfn(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.pgis_geometry_clusterwithin_finalfn(internal) TO dbimporter;

--
-- Name: FUNCTION pgis_geometry_collect_finalfn(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgis_geometry_collect_finalfn(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.pgis_geometry_collect_finalfn(internal) TO dbimporter;

--
-- Name: FUNCTION pgis_geometry_makeline_finalfn(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgis_geometry_makeline_finalfn(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.pgis_geometry_makeline_finalfn(internal) TO dbimporter;

--
-- Name: FUNCTION pgis_geometry_polygonize_finalfn(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgis_geometry_polygonize_finalfn(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.pgis_geometry_polygonize_finalfn(internal) TO dbimporter;

--
-- Name: FUNCTION pgis_geometry_union_parallel_combinefn(internal, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgis_geometry_union_parallel_combinefn(internal, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.pgis_geometry_union_parallel_combinefn(internal, internal) TO dbimporter;

--
-- Name: FUNCTION pgis_geometry_union_parallel_deserialfn(bytea, internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgis_geometry_union_parallel_deserialfn(bytea, internal) TO dbhasura;
GRANT ALL ON FUNCTION public.pgis_geometry_union_parallel_deserialfn(bytea, internal) TO dbimporter;

--
-- Name: FUNCTION pgis_geometry_union_parallel_finalfn(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgis_geometry_union_parallel_finalfn(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.pgis_geometry_union_parallel_finalfn(internal) TO dbimporter;

--
-- Name: FUNCTION pgis_geometry_union_parallel_serialfn(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgis_geometry_union_parallel_serialfn(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.pgis_geometry_union_parallel_serialfn(internal) TO dbimporter;

--
-- Name: FUNCTION pgis_geometry_union_parallel_transfn(internal, public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgis_geometry_union_parallel_transfn(internal, public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.pgis_geometry_union_parallel_transfn(internal, public.geometry) TO dbimporter;

--
-- Name: FUNCTION pgis_geometry_union_parallel_transfn(internal, public.geometry, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgis_geometry_union_parallel_transfn(internal, public.geometry, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.pgis_geometry_union_parallel_transfn(internal, public.geometry, double precision) TO dbimporter;

--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_armor_headers(text, OUT key text, OUT value text) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_armor_headers(text, OUT key text, OUT value text) TO dbimporter;

--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_key_id(bytea) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_key_id(bytea) TO dbimporter;

--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_pub_decrypt(bytea, bytea) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_pub_decrypt(bytea, bytea) TO dbimporter;

--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_pub_decrypt(bytea, bytea, text) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_pub_decrypt(bytea, bytea, text) TO dbimporter;

--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_pub_decrypt(bytea, bytea, text, text) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_pub_decrypt(bytea, bytea, text, text) TO dbimporter;

--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_pub_decrypt_bytea(bytea, bytea) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_pub_decrypt_bytea(bytea, bytea) TO dbimporter;

--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dbimporter;

--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dbimporter;

--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_pub_encrypt(text, bytea) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_pub_encrypt(text, bytea) TO dbimporter;

--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_pub_encrypt(text, bytea, text) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_pub_encrypt(text, bytea, text) TO dbimporter;

--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_pub_encrypt_bytea(bytea, bytea) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_pub_encrypt_bytea(bytea, bytea) TO dbimporter;

--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dbimporter;

--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_sym_decrypt(bytea, text) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_sym_decrypt(bytea, text) TO dbimporter;

--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_sym_decrypt(bytea, text, text) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_sym_decrypt(bytea, text, text) TO dbimporter;

--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_sym_decrypt_bytea(bytea, text) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_sym_decrypt_bytea(bytea, text) TO dbimporter;

--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_sym_decrypt_bytea(bytea, text, text) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_sym_decrypt_bytea(bytea, text, text) TO dbimporter;

--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_sym_encrypt(text, text) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_sym_encrypt(text, text) TO dbimporter;

--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_sym_encrypt(text, text, text) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_sym_encrypt(text, text, text) TO dbimporter;

--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_sym_encrypt_bytea(bytea, text) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_sym_encrypt_bytea(bytea, text) TO dbimporter;

--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.pgp_sym_encrypt_bytea(bytea, text, text) TO dbhasura;
GRANT ALL ON FUNCTION public.pgp_sym_encrypt_bytea(bytea, text, text) TO dbimporter;

--
-- Name: FUNCTION point(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.point(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.point(public.geometry) TO dbimporter;

--
-- Name: FUNCTION polygon(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.polygon(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.polygon(public.geometry) TO dbimporter;

--
-- Name: FUNCTION populate_geometry_columns(tbl_oid oid, use_typmod boolean); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.populate_geometry_columns(tbl_oid oid, use_typmod boolean) TO dbhasura;
GRANT ALL ON FUNCTION public.populate_geometry_columns(tbl_oid oid, use_typmod boolean) TO dbimporter;

--
-- Name: FUNCTION populate_geometry_columns(use_typmod boolean); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.populate_geometry_columns(use_typmod boolean) TO dbhasura;
GRANT ALL ON FUNCTION public.populate_geometry_columns(use_typmod boolean) TO dbimporter;

--
-- Name: FUNCTION postgis_addbbox(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.postgis_addbbox(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.postgis_addbbox(public.geometry) TO dbimporter;

--
-- Name: FUNCTION postgis_cache_bbox(); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.postgis_cache_bbox() TO dbhasura;
GRANT ALL ON FUNCTION public.postgis_cache_bbox() TO dbimporter;

--
-- Name: FUNCTION postgis_constraint_dims(geomschema text, geomtable text, geomcolumn text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.postgis_constraint_dims(geomschema text, geomtable text, geomcolumn text) TO dbhasura;
GRANT ALL ON FUNCTION public.postgis_constraint_dims(geomschema text, geomtable text, geomcolumn text) TO dbimporter;

--
-- Name: FUNCTION postgis_constraint_srid(geomschema text, geomtable text, geomcolumn text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.postgis_constraint_srid(geomschema text, geomtable text, geomcolumn text) TO dbhasura;
GRANT ALL ON FUNCTION public.postgis_constraint_srid(geomschema text, geomtable text, geomcolumn text) TO dbimporter;

--
-- Name: FUNCTION postgis_constraint_type(geomschema text, geomtable text, geomcolumn text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.postgis_constraint_type(geomschema text, geomtable text, geomcolumn text) TO dbhasura;
GRANT ALL ON FUNCTION public.postgis_constraint_type(geomschema text, geomtable text, geomcolumn text) TO dbimporter;

--
-- Name: FUNCTION postgis_dropbbox(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.postgis_dropbbox(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.postgis_dropbbox(public.geometry) TO dbimporter;

--
-- Name: FUNCTION postgis_extensions_upgrade(); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.postgis_extensions_upgrade() TO dbhasura;
GRANT ALL ON FUNCTION public.postgis_extensions_upgrade() TO dbimporter;

--
-- Name: FUNCTION postgis_full_version(); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.postgis_full_version() TO dbhasura;
GRANT ALL ON FUNCTION public.postgis_full_version() TO dbimporter;

--
-- Name: FUNCTION postgis_geos_noop(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.postgis_geos_noop(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.postgis_geos_noop(public.geometry) TO dbimporter;

--
-- Name: FUNCTION postgis_geos_version(); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.postgis_geos_version() TO dbhasura;
GRANT ALL ON FUNCTION public.postgis_geos_version() TO dbimporter;

--
-- Name: FUNCTION postgis_getbbox(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.postgis_getbbox(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.postgis_getbbox(public.geometry) TO dbimporter;

--
-- Name: FUNCTION postgis_hasbbox(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.postgis_hasbbox(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.postgis_hasbbox(public.geometry) TO dbimporter;

--
-- Name: FUNCTION postgis_index_supportfn(internal); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.postgis_index_supportfn(internal) TO dbhasura;
GRANT ALL ON FUNCTION public.postgis_index_supportfn(internal) TO dbimporter;

--
-- Name: FUNCTION postgis_lib_build_date(); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.postgis_lib_build_date() TO dbhasura;
GRANT ALL ON FUNCTION public.postgis_lib_build_date() TO dbimporter;

--
-- Name: FUNCTION postgis_lib_revision(); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.postgis_lib_revision() TO dbhasura;
GRANT ALL ON FUNCTION public.postgis_lib_revision() TO dbimporter;

--
-- Name: FUNCTION postgis_lib_version(); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.postgis_lib_version() TO dbhasura;
GRANT ALL ON FUNCTION public.postgis_lib_version() TO dbimporter;

--
-- Name: FUNCTION postgis_libjson_version(); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.postgis_libjson_version() TO dbhasura;
GRANT ALL ON FUNCTION public.postgis_libjson_version() TO dbimporter;

--
-- Name: FUNCTION postgis_liblwgeom_version(); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.postgis_liblwgeom_version() TO dbhasura;
GRANT ALL ON FUNCTION public.postgis_liblwgeom_version() TO dbimporter;

--
-- Name: FUNCTION postgis_libprotobuf_version(); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.postgis_libprotobuf_version() TO dbhasura;
GRANT ALL ON FUNCTION public.postgis_libprotobuf_version() TO dbimporter;

--
-- Name: FUNCTION postgis_libxml_version(); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.postgis_libxml_version() TO dbhasura;
GRANT ALL ON FUNCTION public.postgis_libxml_version() TO dbimporter;

--
-- Name: FUNCTION postgis_noop(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.postgis_noop(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.postgis_noop(public.geometry) TO dbimporter;

--
-- Name: FUNCTION postgis_proj_version(); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.postgis_proj_version() TO dbhasura;
GRANT ALL ON FUNCTION public.postgis_proj_version() TO dbimporter;

--
-- Name: FUNCTION postgis_scripts_build_date(); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.postgis_scripts_build_date() TO dbhasura;
GRANT ALL ON FUNCTION public.postgis_scripts_build_date() TO dbimporter;

--
-- Name: FUNCTION postgis_scripts_installed(); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.postgis_scripts_installed() TO dbhasura;
GRANT ALL ON FUNCTION public.postgis_scripts_installed() TO dbimporter;

--
-- Name: FUNCTION postgis_scripts_released(); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.postgis_scripts_released() TO dbhasura;
GRANT ALL ON FUNCTION public.postgis_scripts_released() TO dbimporter;

--
-- Name: FUNCTION postgis_svn_version(); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.postgis_svn_version() TO dbhasura;
GRANT ALL ON FUNCTION public.postgis_svn_version() TO dbimporter;

--
-- Name: FUNCTION postgis_transform_geometry(geom public.geometry, text, text, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.postgis_transform_geometry(geom public.geometry, text, text, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.postgis_transform_geometry(geom public.geometry, text, text, integer) TO dbimporter;

--
-- Name: FUNCTION postgis_type_name(geomname character varying, coord_dimension integer, use_new_name boolean); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.postgis_type_name(geomname character varying, coord_dimension integer, use_new_name boolean) TO dbhasura;
GRANT ALL ON FUNCTION public.postgis_type_name(geomname character varying, coord_dimension integer, use_new_name boolean) TO dbimporter;

--
-- Name: FUNCTION postgis_typmod_dims(integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.postgis_typmod_dims(integer) TO dbhasura;
GRANT ALL ON FUNCTION public.postgis_typmod_dims(integer) TO dbimporter;

--
-- Name: FUNCTION postgis_typmod_srid(integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.postgis_typmod_srid(integer) TO dbhasura;
GRANT ALL ON FUNCTION public.postgis_typmod_srid(integer) TO dbimporter;

--
-- Name: FUNCTION postgis_typmod_type(integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.postgis_typmod_type(integer) TO dbhasura;
GRANT ALL ON FUNCTION public.postgis_typmod_type(integer) TO dbimporter;

--
-- Name: FUNCTION postgis_version(); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.postgis_version() TO dbhasura;
GRANT ALL ON FUNCTION public.postgis_version() TO dbimporter;

--
-- Name: FUNCTION postgis_wagyu_version(); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.postgis_wagyu_version() TO dbhasura;
GRANT ALL ON FUNCTION public.postgis_wagyu_version() TO dbimporter;

--
-- Name: FUNCTION spheroid_in(cstring); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.spheroid_in(cstring) TO dbhasura;
GRANT ALL ON FUNCTION public.spheroid_in(cstring) TO dbimporter;

--
-- Name: FUNCTION spheroid_out(public.spheroid); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.spheroid_out(public.spheroid) TO dbhasura;
GRANT ALL ON FUNCTION public.spheroid_out(public.spheroid) TO dbimporter;

--
-- Name: FUNCTION st_3dclosestpoint(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_3dclosestpoint(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_3dclosestpoint(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_3ddfullywithin(geom1 public.geometry, geom2 public.geometry, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_3ddfullywithin(geom1 public.geometry, geom2 public.geometry, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_3ddfullywithin(geom1 public.geometry, geom2 public.geometry, double precision) TO dbimporter;

--
-- Name: FUNCTION st_3ddistance(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_3ddistance(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_3ddistance(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_3ddwithin(geom1 public.geometry, geom2 public.geometry, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_3ddwithin(geom1 public.geometry, geom2 public.geometry, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_3ddwithin(geom1 public.geometry, geom2 public.geometry, double precision) TO dbimporter;

--
-- Name: FUNCTION st_3dextent(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_3dextent(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_3dextent(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_3dintersects(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_3dintersects(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_3dintersects(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_3dlength(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_3dlength(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_3dlength(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_3dlineinterpolatepoint(public.geometry, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_3dlineinterpolatepoint(public.geometry, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_3dlineinterpolatepoint(public.geometry, double precision) TO dbimporter;

--
-- Name: FUNCTION st_3dlongestline(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_3dlongestline(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_3dlongestline(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_3dmakebox(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_3dmakebox(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_3dmakebox(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_3dmaxdistance(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_3dmaxdistance(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_3dmaxdistance(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_3dperimeter(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_3dperimeter(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_3dperimeter(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_3dshortestline(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_3dshortestline(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_3dshortestline(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_addmeasure(public.geometry, double precision, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_addmeasure(public.geometry, double precision, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_addmeasure(public.geometry, double precision, double precision) TO dbimporter;

--
-- Name: FUNCTION st_addpoint(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_addpoint(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_addpoint(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_addpoint(geom1 public.geometry, geom2 public.geometry, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_addpoint(geom1 public.geometry, geom2 public.geometry, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_addpoint(geom1 public.geometry, geom2 public.geometry, integer) TO dbimporter;

--
-- Name: FUNCTION st_affine(public.geometry, double precision, double precision, double precision, double precision, double precision, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_affine(public.geometry, double precision, double precision, double precision, double precision, double precision, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_affine(public.geometry, double precision, double precision, double precision, double precision, double precision, double precision) TO dbimporter;

--
-- Name: FUNCTION st_affine(public.geometry, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_affine(public.geometry, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_affine(public.geometry, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision) TO dbimporter;

--
-- Name: FUNCTION st_angle(line1 public.geometry, line2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_angle(line1 public.geometry, line2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_angle(line1 public.geometry, line2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_angle(pt1 public.geometry, pt2 public.geometry, pt3 public.geometry, pt4 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_angle(pt1 public.geometry, pt2 public.geometry, pt3 public.geometry, pt4 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_angle(pt1 public.geometry, pt2 public.geometry, pt3 public.geometry, pt4 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_area(geog public.geography, use_spheroid boolean); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_area(geog public.geography, use_spheroid boolean) TO dbhasura;
GRANT ALL ON FUNCTION public.st_area(geog public.geography, use_spheroid boolean) TO dbimporter;

--
-- Name: FUNCTION st_area(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_area(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_area(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_area(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_area(text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_area(text) TO dbimporter;

--
-- Name: FUNCTION st_area2d(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_area2d(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_area2d(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_asbinary(public.geography); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_asbinary(public.geography) TO dbhasura;
GRANT ALL ON FUNCTION public.st_asbinary(public.geography) TO dbimporter;

--
-- Name: FUNCTION st_asbinary(public.geography, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_asbinary(public.geography, text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_asbinary(public.geography, text) TO dbimporter;

--
-- Name: FUNCTION st_asbinary(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_asbinary(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_asbinary(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_asbinary(public.geometry, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_asbinary(public.geometry, text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_asbinary(public.geometry, text) TO dbimporter;

--
-- Name: FUNCTION st_asencodedpolyline(geom public.geometry, nprecision integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_asencodedpolyline(geom public.geometry, nprecision integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_asencodedpolyline(geom public.geometry, nprecision integer) TO dbimporter;

--
-- Name: FUNCTION st_asewkb(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_asewkb(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_asewkb(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_asewkb(public.geometry, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_asewkb(public.geometry, text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_asewkb(public.geometry, text) TO dbimporter;

--
-- Name: FUNCTION st_asewkt(public.geography); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_asewkt(public.geography) TO dbhasura;
GRANT ALL ON FUNCTION public.st_asewkt(public.geography) TO dbimporter;

--
-- Name: FUNCTION st_asewkt(public.geography, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_asewkt(public.geography, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_asewkt(public.geography, integer) TO dbimporter;

--
-- Name: FUNCTION st_asewkt(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_asewkt(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_asewkt(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_asewkt(public.geometry, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_asewkt(public.geometry, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_asewkt(public.geometry, integer) TO dbimporter;

--
-- Name: FUNCTION st_asewkt(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_asewkt(text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_asewkt(text) TO dbimporter;

--
-- Name: FUNCTION st_asflatgeobuf(anyelement); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_asflatgeobuf(anyelement) TO dbhasura;
GRANT ALL ON FUNCTION public.st_asflatgeobuf(anyelement) TO dbimporter;

--
-- Name: FUNCTION st_asflatgeobuf(anyelement, boolean); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_asflatgeobuf(anyelement, boolean) TO dbhasura;
GRANT ALL ON FUNCTION public.st_asflatgeobuf(anyelement, boolean) TO dbimporter;

--
-- Name: FUNCTION st_asflatgeobuf(anyelement, boolean, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_asflatgeobuf(anyelement, boolean, text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_asflatgeobuf(anyelement, boolean, text) TO dbimporter;

--
-- Name: FUNCTION st_asgeobuf(anyelement); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_asgeobuf(anyelement) TO dbhasura;
GRANT ALL ON FUNCTION public.st_asgeobuf(anyelement) TO dbimporter;

--
-- Name: FUNCTION st_asgeobuf(anyelement, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_asgeobuf(anyelement, text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_asgeobuf(anyelement, text) TO dbimporter;

--
-- Name: FUNCTION st_asgeojson(geog public.geography, maxdecimaldigits integer, options integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_asgeojson(geog public.geography, maxdecimaldigits integer, options integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_asgeojson(geog public.geography, maxdecimaldigits integer, options integer) TO dbimporter;

--
-- Name: FUNCTION st_asgeojson(geom public.geometry, maxdecimaldigits integer, options integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_asgeojson(geom public.geometry, maxdecimaldigits integer, options integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_asgeojson(geom public.geometry, maxdecimaldigits integer, options integer) TO dbimporter;

--
-- Name: FUNCTION st_asgeojson(r record, geom_column text, maxdecimaldigits integer, pretty_bool boolean); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_asgeojson(r record, geom_column text, maxdecimaldigits integer, pretty_bool boolean) TO dbhasura;
GRANT ALL ON FUNCTION public.st_asgeojson(r record, geom_column text, maxdecimaldigits integer, pretty_bool boolean) TO dbimporter;

--
-- Name: FUNCTION st_asgeojson(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_asgeojson(text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_asgeojson(text) TO dbimporter;

--
-- Name: FUNCTION st_asgml(geog public.geography, maxdecimaldigits integer, options integer, nprefix text, id text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_asgml(geog public.geography, maxdecimaldigits integer, options integer, nprefix text, id text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_asgml(geog public.geography, maxdecimaldigits integer, options integer, nprefix text, id text) TO dbimporter;

--
-- Name: FUNCTION st_asgml(geom public.geometry, maxdecimaldigits integer, options integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_asgml(geom public.geometry, maxdecimaldigits integer, options integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_asgml(geom public.geometry, maxdecimaldigits integer, options integer) TO dbimporter;

--
-- Name: FUNCTION st_asgml(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_asgml(text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_asgml(text) TO dbimporter;

--
-- Name: FUNCTION st_asgml(version integer, geog public.geography, maxdecimaldigits integer, options integer, nprefix text, id text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_asgml(version integer, geog public.geography, maxdecimaldigits integer, options integer, nprefix text, id text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_asgml(version integer, geog public.geography, maxdecimaldigits integer, options integer, nprefix text, id text) TO dbimporter;

--
-- Name: FUNCTION st_asgml(version integer, geom public.geometry, maxdecimaldigits integer, options integer, nprefix text, id text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_asgml(version integer, geom public.geometry, maxdecimaldigits integer, options integer, nprefix text, id text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_asgml(version integer, geom public.geometry, maxdecimaldigits integer, options integer, nprefix text, id text) TO dbimporter;

--
-- Name: FUNCTION st_ashexewkb(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_ashexewkb(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_ashexewkb(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_ashexewkb(public.geometry, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_ashexewkb(public.geometry, text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_ashexewkb(public.geometry, text) TO dbimporter;

--
-- Name: FUNCTION st_askml(geog public.geography, maxdecimaldigits integer, nprefix text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_askml(geog public.geography, maxdecimaldigits integer, nprefix text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_askml(geog public.geography, maxdecimaldigits integer, nprefix text) TO dbimporter;

--
-- Name: FUNCTION st_askml(geom public.geometry, maxdecimaldigits integer, nprefix text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_askml(geom public.geometry, maxdecimaldigits integer, nprefix text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_askml(geom public.geometry, maxdecimaldigits integer, nprefix text) TO dbimporter;

--
-- Name: FUNCTION st_askml(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_askml(text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_askml(text) TO dbimporter;

--
-- Name: FUNCTION st_aslatlontext(geom public.geometry, tmpl text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_aslatlontext(geom public.geometry, tmpl text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_aslatlontext(geom public.geometry, tmpl text) TO dbimporter;

--
-- Name: FUNCTION st_asmarc21(geom public.geometry, format text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_asmarc21(geom public.geometry, format text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_asmarc21(geom public.geometry, format text) TO dbimporter;

--
-- Name: FUNCTION st_asmvt(anyelement); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_asmvt(anyelement) TO dbhasura;
GRANT ALL ON FUNCTION public.st_asmvt(anyelement) TO dbimporter;

--
-- Name: FUNCTION st_asmvt(anyelement, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_asmvt(anyelement, text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_asmvt(anyelement, text) TO dbimporter;

--
-- Name: FUNCTION st_asmvt(anyelement, text, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_asmvt(anyelement, text, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_asmvt(anyelement, text, integer) TO dbimporter;

--
-- Name: FUNCTION st_asmvt(anyelement, text, integer, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_asmvt(anyelement, text, integer, text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_asmvt(anyelement, text, integer, text) TO dbimporter;

--
-- Name: FUNCTION st_asmvt(anyelement, text, integer, text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_asmvt(anyelement, text, integer, text, text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_asmvt(anyelement, text, integer, text, text) TO dbimporter;

--
-- Name: FUNCTION st_asmvtgeom(geom public.geometry, bounds public.box2d, extent integer, buffer integer, clip_geom boolean); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_asmvtgeom(geom public.geometry, bounds public.box2d, extent integer, buffer integer, clip_geom boolean) TO dbhasura;
GRANT ALL ON FUNCTION public.st_asmvtgeom(geom public.geometry, bounds public.box2d, extent integer, buffer integer, clip_geom boolean) TO dbimporter;

--
-- Name: FUNCTION st_assvg(geog public.geography, rel integer, maxdecimaldigits integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_assvg(geog public.geography, rel integer, maxdecimaldigits integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_assvg(geog public.geography, rel integer, maxdecimaldigits integer) TO dbimporter;

--
-- Name: FUNCTION st_assvg(geom public.geometry, rel integer, maxdecimaldigits integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_assvg(geom public.geometry, rel integer, maxdecimaldigits integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_assvg(geom public.geometry, rel integer, maxdecimaldigits integer) TO dbimporter;

--
-- Name: FUNCTION st_assvg(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_assvg(text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_assvg(text) TO dbimporter;

--
-- Name: FUNCTION st_astext(public.geography); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_astext(public.geography) TO dbhasura;
GRANT ALL ON FUNCTION public.st_astext(public.geography) TO dbimporter;

--
-- Name: FUNCTION st_astext(public.geography, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_astext(public.geography, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_astext(public.geography, integer) TO dbimporter;

--
-- Name: FUNCTION st_astext(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_astext(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_astext(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_astext(public.geometry, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_astext(public.geometry, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_astext(public.geometry, integer) TO dbimporter;

--
-- Name: FUNCTION st_astext(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_astext(text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_astext(text) TO dbimporter;

--
-- Name: FUNCTION st_astwkb(geom public.geometry, prec integer, prec_z integer, prec_m integer, with_sizes boolean, with_boxes boolean); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_astwkb(geom public.geometry, prec integer, prec_z integer, prec_m integer, with_sizes boolean, with_boxes boolean) TO dbhasura;
GRANT ALL ON FUNCTION public.st_astwkb(geom public.geometry, prec integer, prec_z integer, prec_m integer, with_sizes boolean, with_boxes boolean) TO dbimporter;

--
-- Name: FUNCTION st_astwkb(geom public.geometry[], ids bigint[], prec integer, prec_z integer, prec_m integer, with_sizes boolean, with_boxes boolean); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_astwkb(geom public.geometry[], ids bigint[], prec integer, prec_z integer, prec_m integer, with_sizes boolean, with_boxes boolean) TO dbhasura;
GRANT ALL ON FUNCTION public.st_astwkb(geom public.geometry[], ids bigint[], prec integer, prec_z integer, prec_m integer, with_sizes boolean, with_boxes boolean) TO dbimporter;

--
-- Name: FUNCTION st_asx3d(geom public.geometry, maxdecimaldigits integer, options integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_asx3d(geom public.geometry, maxdecimaldigits integer, options integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_asx3d(geom public.geometry, maxdecimaldigits integer, options integer) TO dbimporter;

--
-- Name: FUNCTION st_azimuth(geog1 public.geography, geog2 public.geography); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_azimuth(geog1 public.geography, geog2 public.geography) TO dbhasura;
GRANT ALL ON FUNCTION public.st_azimuth(geog1 public.geography, geog2 public.geography) TO dbimporter;

--
-- Name: FUNCTION st_azimuth(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_azimuth(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_azimuth(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_bdmpolyfromtext(text, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_bdmpolyfromtext(text, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_bdmpolyfromtext(text, integer) TO dbimporter;

--
-- Name: FUNCTION st_bdpolyfromtext(text, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_bdpolyfromtext(text, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_bdpolyfromtext(text, integer) TO dbimporter;

--
-- Name: FUNCTION st_boundary(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_boundary(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_boundary(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_boundingdiagonal(geom public.geometry, fits boolean); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_boundingdiagonal(geom public.geometry, fits boolean) TO dbhasura;
GRANT ALL ON FUNCTION public.st_boundingdiagonal(geom public.geometry, fits boolean) TO dbimporter;

--
-- Name: FUNCTION st_box2dfromgeohash(text, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_box2dfromgeohash(text, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_box2dfromgeohash(text, integer) TO dbimporter;

--
-- Name: FUNCTION st_buffer(geom public.geometry, radius double precision, options text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_buffer(geom public.geometry, radius double precision, options text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_buffer(geom public.geometry, radius double precision, options text) TO dbimporter;

--
-- Name: FUNCTION st_buffer(geom public.geometry, radius double precision, quadsegs integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_buffer(geom public.geometry, radius double precision, quadsegs integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_buffer(geom public.geometry, radius double precision, quadsegs integer) TO dbimporter;

--
-- Name: FUNCTION st_buffer(public.geography, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_buffer(public.geography, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_buffer(public.geography, double precision) TO dbimporter;

--
-- Name: FUNCTION st_buffer(public.geography, double precision, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_buffer(public.geography, double precision, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_buffer(public.geography, double precision, integer) TO dbimporter;

--
-- Name: FUNCTION st_buffer(public.geography, double precision, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_buffer(public.geography, double precision, text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_buffer(public.geography, double precision, text) TO dbimporter;

--
-- Name: FUNCTION st_buffer(text, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_buffer(text, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_buffer(text, double precision) TO dbimporter;

--
-- Name: FUNCTION st_buffer(text, double precision, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_buffer(text, double precision, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_buffer(text, double precision, integer) TO dbimporter;

--
-- Name: FUNCTION st_buffer(text, double precision, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_buffer(text, double precision, text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_buffer(text, double precision, text) TO dbimporter;

--
-- Name: FUNCTION st_buildarea(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_buildarea(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_buildarea(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_centroid(public.geography, use_spheroid boolean); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_centroid(public.geography, use_spheroid boolean) TO dbhasura;
GRANT ALL ON FUNCTION public.st_centroid(public.geography, use_spheroid boolean) TO dbimporter;

--
-- Name: FUNCTION st_centroid(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_centroid(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_centroid(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_centroid(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_centroid(text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_centroid(text) TO dbimporter;

--
-- Name: FUNCTION st_chaikinsmoothing(public.geometry, integer, boolean); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_chaikinsmoothing(public.geometry, integer, boolean) TO dbhasura;
GRANT ALL ON FUNCTION public.st_chaikinsmoothing(public.geometry, integer, boolean) TO dbimporter;

--
-- Name: FUNCTION st_cleangeometry(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_cleangeometry(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_cleangeometry(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_clipbybox2d(geom public.geometry, box public.box2d); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_clipbybox2d(geom public.geometry, box public.box2d) TO dbhasura;
GRANT ALL ON FUNCTION public.st_clipbybox2d(geom public.geometry, box public.box2d) TO dbimporter;

--
-- Name: FUNCTION st_closestpoint(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_closestpoint(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_closestpoint(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_closestpointofapproach(public.geometry, public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_closestpointofapproach(public.geometry, public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_closestpointofapproach(public.geometry, public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_clusterdbscan(public.geometry, eps double precision, minpoints integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_clusterdbscan(public.geometry, eps double precision, minpoints integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_clusterdbscan(public.geometry, eps double precision, minpoints integer) TO dbimporter;

--
-- Name: FUNCTION st_clusterintersecting(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_clusterintersecting(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_clusterintersecting(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_clusterintersecting(public.geometry[]); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_clusterintersecting(public.geometry[]) TO dbhasura;
GRANT ALL ON FUNCTION public.st_clusterintersecting(public.geometry[]) TO dbimporter;

--
-- Name: FUNCTION st_clusterkmeans(geom public.geometry, k integer, max_radius double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_clusterkmeans(geom public.geometry, k integer, max_radius double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_clusterkmeans(geom public.geometry, k integer, max_radius double precision) TO dbimporter;

--
-- Name: FUNCTION st_clusterwithin(public.geometry, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_clusterwithin(public.geometry, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_clusterwithin(public.geometry, double precision) TO dbimporter;

--
-- Name: FUNCTION st_clusterwithin(public.geometry[], double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_clusterwithin(public.geometry[], double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_clusterwithin(public.geometry[], double precision) TO dbimporter;

--
-- Name: FUNCTION st_collect(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_collect(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_collect(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_collect(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_collect(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_collect(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_collect(public.geometry[]); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_collect(public.geometry[]) TO dbhasura;
GRANT ALL ON FUNCTION public.st_collect(public.geometry[]) TO dbimporter;

--
-- Name: FUNCTION st_collectionextract(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_collectionextract(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_collectionextract(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_collectionextract(public.geometry, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_collectionextract(public.geometry, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_collectionextract(public.geometry, integer) TO dbimporter;

--
-- Name: FUNCTION st_collectionhomogenize(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_collectionhomogenize(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_collectionhomogenize(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_combinebbox(public.box2d, public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_combinebbox(public.box2d, public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_combinebbox(public.box2d, public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_combinebbox(public.box3d, public.box3d); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_combinebbox(public.box3d, public.box3d) TO dbhasura;
GRANT ALL ON FUNCTION public.st_combinebbox(public.box3d, public.box3d) TO dbimporter;

--
-- Name: FUNCTION st_combinebbox(public.box3d, public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_combinebbox(public.box3d, public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_combinebbox(public.box3d, public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_concavehull(param_geom public.geometry, param_pctconvex double precision, param_allow_holes boolean); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_concavehull(param_geom public.geometry, param_pctconvex double precision, param_allow_holes boolean) TO dbhasura;
GRANT ALL ON FUNCTION public.st_concavehull(param_geom public.geometry, param_pctconvex double precision, param_allow_holes boolean) TO dbimporter;

--
-- Name: FUNCTION st_contains(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_contains(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_contains(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_containsproperly(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_containsproperly(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_containsproperly(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_convexhull(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_convexhull(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_convexhull(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_coorddim(geometry public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_coorddim(geometry public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_coorddim(geometry public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_coveredby(geog1 public.geography, geog2 public.geography); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_coveredby(geog1 public.geography, geog2 public.geography) TO dbhasura;
GRANT ALL ON FUNCTION public.st_coveredby(geog1 public.geography, geog2 public.geography) TO dbimporter;

--
-- Name: FUNCTION st_coveredby(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_coveredby(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_coveredby(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_coveredby(text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_coveredby(text, text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_coveredby(text, text) TO dbimporter;

--
-- Name: FUNCTION st_covers(geog1 public.geography, geog2 public.geography); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_covers(geog1 public.geography, geog2 public.geography) TO dbhasura;
GRANT ALL ON FUNCTION public.st_covers(geog1 public.geography, geog2 public.geography) TO dbimporter;

--
-- Name: FUNCTION st_covers(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_covers(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_covers(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_covers(text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_covers(text, text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_covers(text, text) TO dbimporter;

--
-- Name: FUNCTION st_cpawithin(public.geometry, public.geometry, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_cpawithin(public.geometry, public.geometry, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_cpawithin(public.geometry, public.geometry, double precision) TO dbimporter;

--
-- Name: FUNCTION st_crosses(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_crosses(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_crosses(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_curvetoline(geom public.geometry, tol double precision, toltype integer, flags integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_curvetoline(geom public.geometry, tol double precision, toltype integer, flags integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_curvetoline(geom public.geometry, tol double precision, toltype integer, flags integer) TO dbimporter;

--
-- Name: FUNCTION st_delaunaytriangles(g1 public.geometry, tolerance double precision, flags integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_delaunaytriangles(g1 public.geometry, tolerance double precision, flags integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_delaunaytriangles(g1 public.geometry, tolerance double precision, flags integer) TO dbimporter;

--
-- Name: FUNCTION st_dfullywithin(geom1 public.geometry, geom2 public.geometry, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_dfullywithin(geom1 public.geometry, geom2 public.geometry, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_dfullywithin(geom1 public.geometry, geom2 public.geometry, double precision) TO dbimporter;

--
-- Name: FUNCTION st_difference(geom1 public.geometry, geom2 public.geometry, gridsize double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_difference(geom1 public.geometry, geom2 public.geometry, gridsize double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_difference(geom1 public.geometry, geom2 public.geometry, gridsize double precision) TO dbimporter;

--
-- Name: FUNCTION st_dimension(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_dimension(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_dimension(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_disjoint(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_disjoint(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_disjoint(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_distance(geog1 public.geography, geog2 public.geography, use_spheroid boolean); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_distance(geog1 public.geography, geog2 public.geography, use_spheroid boolean) TO dbhasura;
GRANT ALL ON FUNCTION public.st_distance(geog1 public.geography, geog2 public.geography, use_spheroid boolean) TO dbimporter;

--
-- Name: FUNCTION st_distance(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_distance(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_distance(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_distance(text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_distance(text, text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_distance(text, text) TO dbimporter;

--
-- Name: FUNCTION st_distancecpa(public.geometry, public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_distancecpa(public.geometry, public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_distancecpa(public.geometry, public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_distancesphere(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_distancesphere(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_distancesphere(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_distancesphere(geom1 public.geometry, geom2 public.geometry, radius double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_distancesphere(geom1 public.geometry, geom2 public.geometry, radius double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_distancesphere(geom1 public.geometry, geom2 public.geometry, radius double precision) TO dbimporter;

--
-- Name: FUNCTION st_distancespheroid(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_distancespheroid(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_distancespheroid(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_distancespheroid(geom1 public.geometry, geom2 public.geometry, public.spheroid); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_distancespheroid(geom1 public.geometry, geom2 public.geometry, public.spheroid) TO dbhasura;
GRANT ALL ON FUNCTION public.st_distancespheroid(geom1 public.geometry, geom2 public.geometry, public.spheroid) TO dbimporter;

--
-- Name: FUNCTION st_dump(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_dump(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_dump(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_dumppoints(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_dumppoints(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_dumppoints(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_dumprings(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_dumprings(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_dumprings(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_dumpsegments(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_dumpsegments(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_dumpsegments(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_dwithin(geog1 public.geography, geog2 public.geography, tolerance double precision, use_spheroid boolean); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_dwithin(geog1 public.geography, geog2 public.geography, tolerance double precision, use_spheroid boolean) TO dbhasura;
GRANT ALL ON FUNCTION public.st_dwithin(geog1 public.geography, geog2 public.geography, tolerance double precision, use_spheroid boolean) TO dbimporter;

--
-- Name: FUNCTION st_dwithin(geom1 public.geometry, geom2 public.geometry, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_dwithin(geom1 public.geometry, geom2 public.geometry, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_dwithin(geom1 public.geometry, geom2 public.geometry, double precision) TO dbimporter;

--
-- Name: FUNCTION st_dwithin(text, text, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_dwithin(text, text, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_dwithin(text, text, double precision) TO dbimporter;

--
-- Name: FUNCTION st_endpoint(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_endpoint(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_endpoint(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_envelope(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_envelope(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_envelope(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_equals(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_equals(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_equals(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_estimatedextent(text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_estimatedextent(text, text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_estimatedextent(text, text) TO dbimporter;

--
-- Name: FUNCTION st_estimatedextent(text, text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_estimatedextent(text, text, text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_estimatedextent(text, text, text) TO dbimporter;

--
-- Name: FUNCTION st_estimatedextent(text, text, text, boolean); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_estimatedextent(text, text, text, boolean) TO dbhasura;
GRANT ALL ON FUNCTION public.st_estimatedextent(text, text, text, boolean) TO dbimporter;

--
-- Name: FUNCTION st_expand(box public.box2d, dx double precision, dy double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_expand(box public.box2d, dx double precision, dy double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_expand(box public.box2d, dx double precision, dy double precision) TO dbimporter;

--
-- Name: FUNCTION st_expand(box public.box3d, dx double precision, dy double precision, dz double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_expand(box public.box3d, dx double precision, dy double precision, dz double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_expand(box public.box3d, dx double precision, dy double precision, dz double precision) TO dbimporter;

--
-- Name: FUNCTION st_expand(geom public.geometry, dx double precision, dy double precision, dz double precision, dm double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_expand(geom public.geometry, dx double precision, dy double precision, dz double precision, dm double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_expand(geom public.geometry, dx double precision, dy double precision, dz double precision, dm double precision) TO dbimporter;

--
-- Name: FUNCTION st_expand(public.box2d, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_expand(public.box2d, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_expand(public.box2d, double precision) TO dbimporter;

--
-- Name: FUNCTION st_expand(public.box3d, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_expand(public.box3d, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_expand(public.box3d, double precision) TO dbimporter;

--
-- Name: FUNCTION st_expand(public.geometry, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_expand(public.geometry, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_expand(public.geometry, double precision) TO dbimporter;

--
-- Name: FUNCTION st_extent(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_extent(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_extent(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_exteriorring(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_exteriorring(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_exteriorring(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_filterbym(public.geometry, double precision, double precision, boolean); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_filterbym(public.geometry, double precision, double precision, boolean) TO dbhasura;
GRANT ALL ON FUNCTION public.st_filterbym(public.geometry, double precision, double precision, boolean) TO dbimporter;

--
-- Name: FUNCTION st_findextent(text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_findextent(text, text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_findextent(text, text) TO dbimporter;

--
-- Name: FUNCTION st_findextent(text, text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_findextent(text, text, text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_findextent(text, text, text) TO dbimporter;

--
-- Name: FUNCTION st_flipcoordinates(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_flipcoordinates(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_flipcoordinates(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_force2d(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_force2d(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_force2d(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_force3d(geom public.geometry, zvalue double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_force3d(geom public.geometry, zvalue double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_force3d(geom public.geometry, zvalue double precision) TO dbimporter;

--
-- Name: FUNCTION st_force3dm(geom public.geometry, mvalue double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_force3dm(geom public.geometry, mvalue double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_force3dm(geom public.geometry, mvalue double precision) TO dbimporter;

--
-- Name: FUNCTION st_force3dz(geom public.geometry, zvalue double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_force3dz(geom public.geometry, zvalue double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_force3dz(geom public.geometry, zvalue double precision) TO dbimporter;

--
-- Name: FUNCTION st_force4d(geom public.geometry, zvalue double precision, mvalue double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_force4d(geom public.geometry, zvalue double precision, mvalue double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_force4d(geom public.geometry, zvalue double precision, mvalue double precision) TO dbimporter;

--
-- Name: FUNCTION st_forcecollection(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_forcecollection(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_forcecollection(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_forcecurve(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_forcecurve(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_forcecurve(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_forcepolygonccw(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_forcepolygonccw(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_forcepolygonccw(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_forcepolygoncw(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_forcepolygoncw(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_forcepolygoncw(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_forcerhr(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_forcerhr(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_forcerhr(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_forcesfs(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_forcesfs(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_forcesfs(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_forcesfs(public.geometry, version text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_forcesfs(public.geometry, version text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_forcesfs(public.geometry, version text) TO dbimporter;

--
-- Name: FUNCTION st_frechetdistance(geom1 public.geometry, geom2 public.geometry, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_frechetdistance(geom1 public.geometry, geom2 public.geometry, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_frechetdistance(geom1 public.geometry, geom2 public.geometry, double precision) TO dbimporter;

--
-- Name: FUNCTION st_fromflatgeobuf(anyelement, bytea); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_fromflatgeobuf(anyelement, bytea) TO dbhasura;
GRANT ALL ON FUNCTION public.st_fromflatgeobuf(anyelement, bytea) TO dbimporter;

--
-- Name: FUNCTION st_fromflatgeobuftotable(text, text, bytea); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_fromflatgeobuftotable(text, text, bytea) TO dbhasura;
GRANT ALL ON FUNCTION public.st_fromflatgeobuftotable(text, text, bytea) TO dbimporter;

--
-- Name: FUNCTION st_generatepoints(area public.geometry, npoints integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_generatepoints(area public.geometry, npoints integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_generatepoints(area public.geometry, npoints integer) TO dbimporter;

--
-- Name: FUNCTION st_generatepoints(area public.geometry, npoints integer, seed integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_generatepoints(area public.geometry, npoints integer, seed integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_generatepoints(area public.geometry, npoints integer, seed integer) TO dbimporter;

--
-- Name: FUNCTION st_geogfromtext(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_geogfromtext(text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_geogfromtext(text) TO dbimporter;

--
-- Name: FUNCTION st_geogfromwkb(bytea); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_geogfromwkb(bytea) TO dbhasura;
GRANT ALL ON FUNCTION public.st_geogfromwkb(bytea) TO dbimporter;

--
-- Name: FUNCTION st_geographyfromtext(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_geographyfromtext(text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_geographyfromtext(text) TO dbimporter;

--
-- Name: FUNCTION st_geohash(geog public.geography, maxchars integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_geohash(geog public.geography, maxchars integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_geohash(geog public.geography, maxchars integer) TO dbimporter;

--
-- Name: FUNCTION st_geohash(geom public.geometry, maxchars integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_geohash(geom public.geometry, maxchars integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_geohash(geom public.geometry, maxchars integer) TO dbimporter;

--
-- Name: FUNCTION st_geomcollfromtext(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_geomcollfromtext(text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_geomcollfromtext(text) TO dbimporter;

--
-- Name: FUNCTION st_geomcollfromtext(text, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_geomcollfromtext(text, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_geomcollfromtext(text, integer) TO dbimporter;

--
-- Name: FUNCTION st_geomcollfromwkb(bytea); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_geomcollfromwkb(bytea) TO dbhasura;
GRANT ALL ON FUNCTION public.st_geomcollfromwkb(bytea) TO dbimporter;

--
-- Name: FUNCTION st_geomcollfromwkb(bytea, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_geomcollfromwkb(bytea, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_geomcollfromwkb(bytea, integer) TO dbimporter;

--
-- Name: FUNCTION st_geometricmedian(g public.geometry, tolerance double precision, max_iter integer, fail_if_not_converged boolean); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_geometricmedian(g public.geometry, tolerance double precision, max_iter integer, fail_if_not_converged boolean) TO dbhasura;
GRANT ALL ON FUNCTION public.st_geometricmedian(g public.geometry, tolerance double precision, max_iter integer, fail_if_not_converged boolean) TO dbimporter;

--
-- Name: FUNCTION st_geometryfromtext(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_geometryfromtext(text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_geometryfromtext(text) TO dbimporter;

--
-- Name: FUNCTION st_geometryfromtext(text, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_geometryfromtext(text, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_geometryfromtext(text, integer) TO dbimporter;

--
-- Name: FUNCTION st_geometryn(public.geometry, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_geometryn(public.geometry, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_geometryn(public.geometry, integer) TO dbimporter;

--
-- Name: FUNCTION st_geometrytype(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_geometrytype(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_geometrytype(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_geomfromewkb(bytea); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_geomfromewkb(bytea) TO dbhasura;
GRANT ALL ON FUNCTION public.st_geomfromewkb(bytea) TO dbimporter;

--
-- Name: FUNCTION st_geomfromewkt(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_geomfromewkt(text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_geomfromewkt(text) TO dbimporter;

--
-- Name: FUNCTION st_geomfromgeohash(text, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_geomfromgeohash(text, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_geomfromgeohash(text, integer) TO dbimporter;

--
-- Name: FUNCTION st_geomfromgeojson(json); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_geomfromgeojson(json) TO dbhasura;
GRANT ALL ON FUNCTION public.st_geomfromgeojson(json) TO dbimporter;

--
-- Name: FUNCTION st_geomfromgeojson(jsonb); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_geomfromgeojson(jsonb) TO dbhasura;
GRANT ALL ON FUNCTION public.st_geomfromgeojson(jsonb) TO dbimporter;

--
-- Name: FUNCTION st_geomfromgeojson(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_geomfromgeojson(text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_geomfromgeojson(text) TO dbimporter;

--
-- Name: FUNCTION st_geomfromgml(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_geomfromgml(text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_geomfromgml(text) TO dbimporter;

--
-- Name: FUNCTION st_geomfromgml(text, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_geomfromgml(text, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_geomfromgml(text, integer) TO dbimporter;

--
-- Name: FUNCTION st_geomfromkml(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_geomfromkml(text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_geomfromkml(text) TO dbimporter;

--
-- Name: FUNCTION st_geomfrommarc21(marc21xml text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_geomfrommarc21(marc21xml text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_geomfrommarc21(marc21xml text) TO dbimporter;

--
-- Name: FUNCTION st_geomfromtext(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_geomfromtext(text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_geomfromtext(text) TO dbimporter;

--
-- Name: FUNCTION st_geomfromtext(text, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_geomfromtext(text, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_geomfromtext(text, integer) TO dbimporter;

--
-- Name: FUNCTION st_geomfromtwkb(bytea); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_geomfromtwkb(bytea) TO dbhasura;
GRANT ALL ON FUNCTION public.st_geomfromtwkb(bytea) TO dbimporter;

--
-- Name: FUNCTION st_geomfromwkb(bytea); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_geomfromwkb(bytea) TO dbhasura;
GRANT ALL ON FUNCTION public.st_geomfromwkb(bytea) TO dbimporter;

--
-- Name: FUNCTION st_geomfromwkb(bytea, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_geomfromwkb(bytea, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_geomfromwkb(bytea, integer) TO dbimporter;

--
-- Name: FUNCTION st_gmltosql(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_gmltosql(text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_gmltosql(text) TO dbimporter;

--
-- Name: FUNCTION st_gmltosql(text, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_gmltosql(text, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_gmltosql(text, integer) TO dbimporter;

--
-- Name: FUNCTION st_hasarc(geometry public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_hasarc(geometry public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_hasarc(geometry public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_hausdorffdistance(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_hausdorffdistance(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_hausdorffdistance(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_hausdorffdistance(geom1 public.geometry, geom2 public.geometry, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_hausdorffdistance(geom1 public.geometry, geom2 public.geometry, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_hausdorffdistance(geom1 public.geometry, geom2 public.geometry, double precision) TO dbimporter;

--
-- Name: FUNCTION st_hexagon(size double precision, cell_i integer, cell_j integer, origin public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_hexagon(size double precision, cell_i integer, cell_j integer, origin public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_hexagon(size double precision, cell_i integer, cell_j integer, origin public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_hexagongrid(size double precision, bounds public.geometry, OUT geom public.geometry, OUT i integer, OUT j integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_hexagongrid(size double precision, bounds public.geometry, OUT geom public.geometry, OUT i integer, OUT j integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_hexagongrid(size double precision, bounds public.geometry, OUT geom public.geometry, OUT i integer, OUT j integer) TO dbimporter;

--
-- Name: FUNCTION st_interiorringn(public.geometry, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_interiorringn(public.geometry, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_interiorringn(public.geometry, integer) TO dbimporter;

--
-- Name: FUNCTION st_interpolatepoint(line public.geometry, point public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_interpolatepoint(line public.geometry, point public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_interpolatepoint(line public.geometry, point public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_intersection(geom1 public.geometry, geom2 public.geometry, gridsize double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_intersection(geom1 public.geometry, geom2 public.geometry, gridsize double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_intersection(geom1 public.geometry, geom2 public.geometry, gridsize double precision) TO dbimporter;

--
-- Name: FUNCTION st_intersection(public.geography, public.geography); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_intersection(public.geography, public.geography) TO dbhasura;
GRANT ALL ON FUNCTION public.st_intersection(public.geography, public.geography) TO dbimporter;

--
-- Name: FUNCTION st_intersection(text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_intersection(text, text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_intersection(text, text) TO dbimporter;

--
-- Name: FUNCTION st_intersects(geog1 public.geography, geog2 public.geography); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_intersects(geog1 public.geography, geog2 public.geography) TO dbhasura;
GRANT ALL ON FUNCTION public.st_intersects(geog1 public.geography, geog2 public.geography) TO dbimporter;

--
-- Name: FUNCTION st_intersects(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_intersects(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_intersects(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_intersects(text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_intersects(text, text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_intersects(text, text) TO dbimporter;

--
-- Name: FUNCTION st_isclosed(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_isclosed(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_isclosed(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_iscollection(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_iscollection(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_iscollection(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_isempty(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_isempty(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_isempty(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_ispolygonccw(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_ispolygonccw(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_ispolygonccw(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_ispolygoncw(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_ispolygoncw(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_ispolygoncw(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_isring(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_isring(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_isring(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_issimple(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_issimple(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_issimple(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_isvalid(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_isvalid(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_isvalid(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_isvalid(public.geometry, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_isvalid(public.geometry, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_isvalid(public.geometry, integer) TO dbimporter;

--
-- Name: FUNCTION st_isvaliddetail(geom public.geometry, flags integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_isvaliddetail(geom public.geometry, flags integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_isvaliddetail(geom public.geometry, flags integer) TO dbimporter;

--
-- Name: FUNCTION st_isvalidreason(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_isvalidreason(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_isvalidreason(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_isvalidreason(public.geometry, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_isvalidreason(public.geometry, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_isvalidreason(public.geometry, integer) TO dbimporter;

--
-- Name: FUNCTION st_isvalidtrajectory(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_isvalidtrajectory(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_isvalidtrajectory(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_length(geog public.geography, use_spheroid boolean); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_length(geog public.geography, use_spheroid boolean) TO dbhasura;
GRANT ALL ON FUNCTION public.st_length(geog public.geography, use_spheroid boolean) TO dbimporter;

--
-- Name: FUNCTION st_length(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_length(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_length(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_length(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_length(text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_length(text) TO dbimporter;

--
-- Name: FUNCTION st_length2d(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_length2d(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_length2d(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_length2dspheroid(public.geometry, public.spheroid); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_length2dspheroid(public.geometry, public.spheroid) TO dbhasura;
GRANT ALL ON FUNCTION public.st_length2dspheroid(public.geometry, public.spheroid) TO dbimporter;

--
-- Name: FUNCTION st_lengthspheroid(public.geometry, public.spheroid); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_lengthspheroid(public.geometry, public.spheroid) TO dbhasura;
GRANT ALL ON FUNCTION public.st_lengthspheroid(public.geometry, public.spheroid) TO dbimporter;

--
-- Name: FUNCTION st_letters(letters text, font json); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_letters(letters text, font json) TO dbhasura;
GRANT ALL ON FUNCTION public.st_letters(letters text, font json) TO dbimporter;

--
-- Name: FUNCTION st_linecrossingdirection(line1 public.geometry, line2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_linecrossingdirection(line1 public.geometry, line2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_linecrossingdirection(line1 public.geometry, line2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_linefromencodedpolyline(txtin text, nprecision integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_linefromencodedpolyline(txtin text, nprecision integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_linefromencodedpolyline(txtin text, nprecision integer) TO dbimporter;

--
-- Name: FUNCTION st_linefrommultipoint(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_linefrommultipoint(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_linefrommultipoint(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_linefromtext(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_linefromtext(text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_linefromtext(text) TO dbimporter;

--
-- Name: FUNCTION st_linefromtext(text, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_linefromtext(text, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_linefromtext(text, integer) TO dbimporter;

--
-- Name: FUNCTION st_linefromwkb(bytea); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_linefromwkb(bytea) TO dbhasura;
GRANT ALL ON FUNCTION public.st_linefromwkb(bytea) TO dbimporter;

--
-- Name: FUNCTION st_linefromwkb(bytea, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_linefromwkb(bytea, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_linefromwkb(bytea, integer) TO dbimporter;

--
-- Name: FUNCTION st_lineinterpolatepoint(public.geometry, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_lineinterpolatepoint(public.geometry, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_lineinterpolatepoint(public.geometry, double precision) TO dbimporter;

--
-- Name: FUNCTION st_lineinterpolatepoints(public.geometry, double precision, repeat boolean); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_lineinterpolatepoints(public.geometry, double precision, repeat boolean) TO dbhasura;
GRANT ALL ON FUNCTION public.st_lineinterpolatepoints(public.geometry, double precision, repeat boolean) TO dbimporter;

--
-- Name: FUNCTION st_linelocatepoint(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_linelocatepoint(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_linelocatepoint(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_linemerge(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_linemerge(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_linemerge(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_linemerge(public.geometry, boolean); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_linemerge(public.geometry, boolean) TO dbhasura;
GRANT ALL ON FUNCTION public.st_linemerge(public.geometry, boolean) TO dbimporter;

--
-- Name: FUNCTION st_linestringfromwkb(bytea); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_linestringfromwkb(bytea) TO dbhasura;
GRANT ALL ON FUNCTION public.st_linestringfromwkb(bytea) TO dbimporter;

--
-- Name: FUNCTION st_linestringfromwkb(bytea, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_linestringfromwkb(bytea, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_linestringfromwkb(bytea, integer) TO dbimporter;

--
-- Name: FUNCTION st_linesubstring(public.geometry, double precision, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_linesubstring(public.geometry, double precision, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_linesubstring(public.geometry, double precision, double precision) TO dbimporter;

--
-- Name: FUNCTION st_linetocurve(geometry public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_linetocurve(geometry public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_linetocurve(geometry public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_locatealong(geometry public.geometry, measure double precision, leftrightoffset double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_locatealong(geometry public.geometry, measure double precision, leftrightoffset double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_locatealong(geometry public.geometry, measure double precision, leftrightoffset double precision) TO dbimporter;

--
-- Name: FUNCTION st_locatebetween(geometry public.geometry, frommeasure double precision, tomeasure double precision, leftrightoffset double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_locatebetween(geometry public.geometry, frommeasure double precision, tomeasure double precision, leftrightoffset double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_locatebetween(geometry public.geometry, frommeasure double precision, tomeasure double precision, leftrightoffset double precision) TO dbimporter;

--
-- Name: FUNCTION st_locatebetweenelevations(geometry public.geometry, fromelevation double precision, toelevation double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_locatebetweenelevations(geometry public.geometry, fromelevation double precision, toelevation double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_locatebetweenelevations(geometry public.geometry, fromelevation double precision, toelevation double precision) TO dbimporter;

--
-- Name: FUNCTION st_longestline(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_longestline(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_longestline(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_m(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_m(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_m(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_makebox2d(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_makebox2d(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_makebox2d(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_makeenvelope(double precision, double precision, double precision, double precision, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_makeenvelope(double precision, double precision, double precision, double precision, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_makeenvelope(double precision, double precision, double precision, double precision, integer) TO dbimporter;

--
-- Name: FUNCTION st_makeline(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_makeline(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_makeline(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_makeline(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_makeline(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_makeline(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_makeline(public.geometry[]); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_makeline(public.geometry[]) TO dbhasura;
GRANT ALL ON FUNCTION public.st_makeline(public.geometry[]) TO dbimporter;

--
-- Name: FUNCTION st_makepoint(double precision, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_makepoint(double precision, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_makepoint(double precision, double precision) TO dbimporter;

--
-- Name: FUNCTION st_makepoint(double precision, double precision, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_makepoint(double precision, double precision, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_makepoint(double precision, double precision, double precision) TO dbimporter;

--
-- Name: FUNCTION st_makepoint(double precision, double precision, double precision, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_makepoint(double precision, double precision, double precision, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_makepoint(double precision, double precision, double precision, double precision) TO dbimporter;

--
-- Name: FUNCTION st_makepointm(double precision, double precision, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_makepointm(double precision, double precision, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_makepointm(double precision, double precision, double precision) TO dbimporter;

--
-- Name: FUNCTION st_makepolygon(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_makepolygon(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_makepolygon(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_makepolygon(public.geometry, public.geometry[]); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_makepolygon(public.geometry, public.geometry[]) TO dbhasura;
GRANT ALL ON FUNCTION public.st_makepolygon(public.geometry, public.geometry[]) TO dbimporter;

--
-- Name: FUNCTION st_makevalid(geom public.geometry, params text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_makevalid(geom public.geometry, params text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_makevalid(geom public.geometry, params text) TO dbimporter;

--
-- Name: FUNCTION st_makevalid(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_makevalid(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_makevalid(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_maxdistance(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_maxdistance(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_maxdistance(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_maximuminscribedcircle(public.geometry, OUT center public.geometry, OUT nearest public.geometry, OUT radius double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_maximuminscribedcircle(public.geometry, OUT center public.geometry, OUT nearest public.geometry, OUT radius double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_maximuminscribedcircle(public.geometry, OUT center public.geometry, OUT nearest public.geometry, OUT radius double precision) TO dbimporter;

--
-- Name: FUNCTION st_memcollect(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_memcollect(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_memcollect(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_memsize(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_memsize(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_memsize(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_memunion(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_memunion(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_memunion(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_minimumboundingcircle(inputgeom public.geometry, segs_per_quarter integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_minimumboundingcircle(inputgeom public.geometry, segs_per_quarter integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_minimumboundingcircle(inputgeom public.geometry, segs_per_quarter integer) TO dbimporter;

--
-- Name: FUNCTION st_minimumboundingradius(public.geometry, OUT center public.geometry, OUT radius double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_minimumboundingradius(public.geometry, OUT center public.geometry, OUT radius double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_minimumboundingradius(public.geometry, OUT center public.geometry, OUT radius double precision) TO dbimporter;

--
-- Name: FUNCTION st_minimumclearance(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_minimumclearance(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_minimumclearance(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_minimumclearanceline(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_minimumclearanceline(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_minimumclearanceline(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_mlinefromtext(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_mlinefromtext(text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_mlinefromtext(text) TO dbimporter;

--
-- Name: FUNCTION st_mlinefromtext(text, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_mlinefromtext(text, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_mlinefromtext(text, integer) TO dbimporter;

--
-- Name: FUNCTION st_mlinefromwkb(bytea); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_mlinefromwkb(bytea) TO dbhasura;
GRANT ALL ON FUNCTION public.st_mlinefromwkb(bytea) TO dbimporter;

--
-- Name: FUNCTION st_mlinefromwkb(bytea, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_mlinefromwkb(bytea, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_mlinefromwkb(bytea, integer) TO dbimporter;

--
-- Name: FUNCTION st_mpointfromtext(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_mpointfromtext(text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_mpointfromtext(text) TO dbimporter;

--
-- Name: FUNCTION st_mpointfromtext(text, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_mpointfromtext(text, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_mpointfromtext(text, integer) TO dbimporter;

--
-- Name: FUNCTION st_mpointfromwkb(bytea); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_mpointfromwkb(bytea) TO dbhasura;
GRANT ALL ON FUNCTION public.st_mpointfromwkb(bytea) TO dbimporter;

--
-- Name: FUNCTION st_mpointfromwkb(bytea, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_mpointfromwkb(bytea, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_mpointfromwkb(bytea, integer) TO dbimporter;

--
-- Name: FUNCTION st_mpolyfromtext(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_mpolyfromtext(text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_mpolyfromtext(text) TO dbimporter;

--
-- Name: FUNCTION st_mpolyfromtext(text, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_mpolyfromtext(text, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_mpolyfromtext(text, integer) TO dbimporter;

--
-- Name: FUNCTION st_mpolyfromwkb(bytea); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_mpolyfromwkb(bytea) TO dbhasura;
GRANT ALL ON FUNCTION public.st_mpolyfromwkb(bytea) TO dbimporter;

--
-- Name: FUNCTION st_mpolyfromwkb(bytea, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_mpolyfromwkb(bytea, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_mpolyfromwkb(bytea, integer) TO dbimporter;

--
-- Name: FUNCTION st_multi(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_multi(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_multi(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_multilinefromwkb(bytea); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_multilinefromwkb(bytea) TO dbhasura;
GRANT ALL ON FUNCTION public.st_multilinefromwkb(bytea) TO dbimporter;

--
-- Name: FUNCTION st_multilinestringfromtext(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_multilinestringfromtext(text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_multilinestringfromtext(text) TO dbimporter;

--
-- Name: FUNCTION st_multilinestringfromtext(text, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_multilinestringfromtext(text, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_multilinestringfromtext(text, integer) TO dbimporter;

--
-- Name: FUNCTION st_multipointfromtext(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_multipointfromtext(text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_multipointfromtext(text) TO dbimporter;

--
-- Name: FUNCTION st_multipointfromwkb(bytea); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_multipointfromwkb(bytea) TO dbhasura;
GRANT ALL ON FUNCTION public.st_multipointfromwkb(bytea) TO dbimporter;

--
-- Name: FUNCTION st_multipointfromwkb(bytea, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_multipointfromwkb(bytea, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_multipointfromwkb(bytea, integer) TO dbimporter;

--
-- Name: FUNCTION st_multipolyfromwkb(bytea); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_multipolyfromwkb(bytea) TO dbhasura;
GRANT ALL ON FUNCTION public.st_multipolyfromwkb(bytea) TO dbimporter;

--
-- Name: FUNCTION st_multipolyfromwkb(bytea, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_multipolyfromwkb(bytea, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_multipolyfromwkb(bytea, integer) TO dbimporter;

--
-- Name: FUNCTION st_multipolygonfromtext(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_multipolygonfromtext(text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_multipolygonfromtext(text) TO dbimporter;

--
-- Name: FUNCTION st_multipolygonfromtext(text, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_multipolygonfromtext(text, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_multipolygonfromtext(text, integer) TO dbimporter;

--
-- Name: FUNCTION st_ndims(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_ndims(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_ndims(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_node(g public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_node(g public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_node(g public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_normalize(geom public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_normalize(geom public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_normalize(geom public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_npoints(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_npoints(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_npoints(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_nrings(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_nrings(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_nrings(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_numgeometries(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_numgeometries(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_numgeometries(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_numinteriorring(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_numinteriorring(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_numinteriorring(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_numinteriorrings(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_numinteriorrings(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_numinteriorrings(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_numpatches(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_numpatches(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_numpatches(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_numpoints(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_numpoints(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_numpoints(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_offsetcurve(line public.geometry, distance double precision, params text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_offsetcurve(line public.geometry, distance double precision, params text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_offsetcurve(line public.geometry, distance double precision, params text) TO dbimporter;

--
-- Name: FUNCTION st_orderingequals(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_orderingequals(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_orderingequals(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_orientedenvelope(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_orientedenvelope(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_orientedenvelope(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_overlaps(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_overlaps(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_overlaps(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_patchn(public.geometry, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_patchn(public.geometry, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_patchn(public.geometry, integer) TO dbimporter;

--
-- Name: FUNCTION st_perimeter(geog public.geography, use_spheroid boolean); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_perimeter(geog public.geography, use_spheroid boolean) TO dbhasura;
GRANT ALL ON FUNCTION public.st_perimeter(geog public.geography, use_spheroid boolean) TO dbimporter;

--
-- Name: FUNCTION st_perimeter(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_perimeter(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_perimeter(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_perimeter2d(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_perimeter2d(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_perimeter2d(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_point(double precision, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_point(double precision, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_point(double precision, double precision) TO dbimporter;

--
-- Name: FUNCTION st_point(double precision, double precision, srid integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_point(double precision, double precision, srid integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_point(double precision, double precision, srid integer) TO dbimporter;

--
-- Name: FUNCTION st_pointfromgeohash(text, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_pointfromgeohash(text, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_pointfromgeohash(text, integer) TO dbimporter;

--
-- Name: FUNCTION st_pointfromtext(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_pointfromtext(text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_pointfromtext(text) TO dbimporter;

--
-- Name: FUNCTION st_pointfromtext(text, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_pointfromtext(text, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_pointfromtext(text, integer) TO dbimporter;

--
-- Name: FUNCTION st_pointfromwkb(bytea); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_pointfromwkb(bytea) TO dbhasura;
GRANT ALL ON FUNCTION public.st_pointfromwkb(bytea) TO dbimporter;

--
-- Name: FUNCTION st_pointfromwkb(bytea, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_pointfromwkb(bytea, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_pointfromwkb(bytea, integer) TO dbimporter;

--
-- Name: FUNCTION st_pointinsidecircle(public.geometry, double precision, double precision, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_pointinsidecircle(public.geometry, double precision, double precision, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_pointinsidecircle(public.geometry, double precision, double precision, double precision) TO dbimporter;

--
-- Name: FUNCTION st_pointm(xcoordinate double precision, ycoordinate double precision, mcoordinate double precision, srid integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_pointm(xcoordinate double precision, ycoordinate double precision, mcoordinate double precision, srid integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_pointm(xcoordinate double precision, ycoordinate double precision, mcoordinate double precision, srid integer) TO dbimporter;

--
-- Name: FUNCTION st_pointn(public.geometry, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_pointn(public.geometry, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_pointn(public.geometry, integer) TO dbimporter;

--
-- Name: FUNCTION st_pointonsurface(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_pointonsurface(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_pointonsurface(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_points(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_points(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_points(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_pointz(xcoordinate double precision, ycoordinate double precision, zcoordinate double precision, srid integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_pointz(xcoordinate double precision, ycoordinate double precision, zcoordinate double precision, srid integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_pointz(xcoordinate double precision, ycoordinate double precision, zcoordinate double precision, srid integer) TO dbimporter;

--
-- Name: FUNCTION st_pointzm(xcoordinate double precision, ycoordinate double precision, zcoordinate double precision, mcoordinate double precision, srid integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_pointzm(xcoordinate double precision, ycoordinate double precision, zcoordinate double precision, mcoordinate double precision, srid integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_pointzm(xcoordinate double precision, ycoordinate double precision, zcoordinate double precision, mcoordinate double precision, srid integer) TO dbimporter;

--
-- Name: FUNCTION st_polyfromtext(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_polyfromtext(text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_polyfromtext(text) TO dbimporter;

--
-- Name: FUNCTION st_polyfromtext(text, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_polyfromtext(text, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_polyfromtext(text, integer) TO dbimporter;

--
-- Name: FUNCTION st_polyfromwkb(bytea); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_polyfromwkb(bytea) TO dbhasura;
GRANT ALL ON FUNCTION public.st_polyfromwkb(bytea) TO dbimporter;

--
-- Name: FUNCTION st_polyfromwkb(bytea, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_polyfromwkb(bytea, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_polyfromwkb(bytea, integer) TO dbimporter;

--
-- Name: FUNCTION st_polygon(public.geometry, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_polygon(public.geometry, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_polygon(public.geometry, integer) TO dbimporter;

--
-- Name: FUNCTION st_polygonfromtext(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_polygonfromtext(text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_polygonfromtext(text) TO dbimporter;

--
-- Name: FUNCTION st_polygonfromtext(text, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_polygonfromtext(text, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_polygonfromtext(text, integer) TO dbimporter;

--
-- Name: FUNCTION st_polygonfromwkb(bytea); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_polygonfromwkb(bytea) TO dbhasura;
GRANT ALL ON FUNCTION public.st_polygonfromwkb(bytea) TO dbimporter;

--
-- Name: FUNCTION st_polygonfromwkb(bytea, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_polygonfromwkb(bytea, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_polygonfromwkb(bytea, integer) TO dbimporter;

--
-- Name: FUNCTION st_polygonize(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_polygonize(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_polygonize(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_polygonize(public.geometry[]); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_polygonize(public.geometry[]) TO dbhasura;
GRANT ALL ON FUNCTION public.st_polygonize(public.geometry[]) TO dbimporter;

--
-- Name: FUNCTION st_project(geog public.geography, distance double precision, azimuth double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_project(geog public.geography, distance double precision, azimuth double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_project(geog public.geography, distance double precision, azimuth double precision) TO dbimporter;

--
-- Name: FUNCTION st_quantizecoordinates(g public.geometry, prec_x integer, prec_y integer, prec_z integer, prec_m integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_quantizecoordinates(g public.geometry, prec_x integer, prec_y integer, prec_z integer, prec_m integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_quantizecoordinates(g public.geometry, prec_x integer, prec_y integer, prec_z integer, prec_m integer) TO dbimporter;

--
-- Name: FUNCTION st_reduceprecision(geom public.geometry, gridsize double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_reduceprecision(geom public.geometry, gridsize double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_reduceprecision(geom public.geometry, gridsize double precision) TO dbimporter;

--
-- Name: FUNCTION st_relate(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_relate(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_relate(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_relate(geom1 public.geometry, geom2 public.geometry, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_relate(geom1 public.geometry, geom2 public.geometry, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_relate(geom1 public.geometry, geom2 public.geometry, integer) TO dbimporter;

--
-- Name: FUNCTION st_relate(geom1 public.geometry, geom2 public.geometry, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_relate(geom1 public.geometry, geom2 public.geometry, text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_relate(geom1 public.geometry, geom2 public.geometry, text) TO dbimporter;

--
-- Name: FUNCTION st_relatematch(text, text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_relatematch(text, text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_relatematch(text, text) TO dbimporter;

--
-- Name: FUNCTION st_removepoint(public.geometry, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_removepoint(public.geometry, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_removepoint(public.geometry, integer) TO dbimporter;

--
-- Name: FUNCTION st_removerepeatedpoints(geom public.geometry, tolerance double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_removerepeatedpoints(geom public.geometry, tolerance double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_removerepeatedpoints(geom public.geometry, tolerance double precision) TO dbimporter;

--
-- Name: FUNCTION st_reverse(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_reverse(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_reverse(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_rotate(public.geometry, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_rotate(public.geometry, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_rotate(public.geometry, double precision) TO dbimporter;

--
-- Name: FUNCTION st_rotate(public.geometry, double precision, double precision, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_rotate(public.geometry, double precision, double precision, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_rotate(public.geometry, double precision, double precision, double precision) TO dbimporter;

--
-- Name: FUNCTION st_rotate(public.geometry, double precision, public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_rotate(public.geometry, double precision, public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_rotate(public.geometry, double precision, public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_rotatex(public.geometry, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_rotatex(public.geometry, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_rotatex(public.geometry, double precision) TO dbimporter;

--
-- Name: FUNCTION st_rotatey(public.geometry, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_rotatey(public.geometry, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_rotatey(public.geometry, double precision) TO dbimporter;

--
-- Name: FUNCTION st_rotatez(public.geometry, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_rotatez(public.geometry, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_rotatez(public.geometry, double precision) TO dbimporter;

--
-- Name: FUNCTION st_scale(public.geometry, double precision, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_scale(public.geometry, double precision, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_scale(public.geometry, double precision, double precision) TO dbimporter;

--
-- Name: FUNCTION st_scale(public.geometry, double precision, double precision, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_scale(public.geometry, double precision, double precision, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_scale(public.geometry, double precision, double precision, double precision) TO dbimporter;

--
-- Name: FUNCTION st_scale(public.geometry, public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_scale(public.geometry, public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_scale(public.geometry, public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_scale(public.geometry, public.geometry, origin public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_scale(public.geometry, public.geometry, origin public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_scale(public.geometry, public.geometry, origin public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_scroll(public.geometry, public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_scroll(public.geometry, public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_scroll(public.geometry, public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_segmentize(geog public.geography, max_segment_length double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_segmentize(geog public.geography, max_segment_length double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_segmentize(geog public.geography, max_segment_length double precision) TO dbimporter;

--
-- Name: FUNCTION st_segmentize(public.geometry, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_segmentize(public.geometry, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_segmentize(public.geometry, double precision) TO dbimporter;

--
-- Name: FUNCTION st_seteffectivearea(public.geometry, double precision, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_seteffectivearea(public.geometry, double precision, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_seteffectivearea(public.geometry, double precision, integer) TO dbimporter;

--
-- Name: FUNCTION st_setpoint(public.geometry, integer, public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_setpoint(public.geometry, integer, public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_setpoint(public.geometry, integer, public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_setsrid(geog public.geography, srid integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_setsrid(geog public.geography, srid integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_setsrid(geog public.geography, srid integer) TO dbimporter;

--
-- Name: FUNCTION st_setsrid(geom public.geometry, srid integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_setsrid(geom public.geometry, srid integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_setsrid(geom public.geometry, srid integer) TO dbimporter;

--
-- Name: FUNCTION st_sharedpaths(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_sharedpaths(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_sharedpaths(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_shiftlongitude(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_shiftlongitude(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_shiftlongitude(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_shortestline(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_shortestline(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_shortestline(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_simplify(public.geometry, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_simplify(public.geometry, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_simplify(public.geometry, double precision) TO dbimporter;

--
-- Name: FUNCTION st_simplify(public.geometry, double precision, boolean); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_simplify(public.geometry, double precision, boolean) TO dbhasura;
GRANT ALL ON FUNCTION public.st_simplify(public.geometry, double precision, boolean) TO dbimporter;

--
-- Name: FUNCTION st_simplifypolygonhull(geom public.geometry, vertex_fraction double precision, is_outer boolean); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_simplifypolygonhull(geom public.geometry, vertex_fraction double precision, is_outer boolean) TO dbhasura;
GRANT ALL ON FUNCTION public.st_simplifypolygonhull(geom public.geometry, vertex_fraction double precision, is_outer boolean) TO dbimporter;

--
-- Name: FUNCTION st_simplifypreservetopology(public.geometry, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_simplifypreservetopology(public.geometry, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_simplifypreservetopology(public.geometry, double precision) TO dbimporter;

--
-- Name: FUNCTION st_simplifyvw(public.geometry, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_simplifyvw(public.geometry, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_simplifyvw(public.geometry, double precision) TO dbimporter;

--
-- Name: FUNCTION st_snap(geom1 public.geometry, geom2 public.geometry, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_snap(geom1 public.geometry, geom2 public.geometry, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_snap(geom1 public.geometry, geom2 public.geometry, double precision) TO dbimporter;

--
-- Name: FUNCTION st_snaptogrid(geom1 public.geometry, geom2 public.geometry, double precision, double precision, double precision, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_snaptogrid(geom1 public.geometry, geom2 public.geometry, double precision, double precision, double precision, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_snaptogrid(geom1 public.geometry, geom2 public.geometry, double precision, double precision, double precision, double precision) TO dbimporter;

--
-- Name: FUNCTION st_snaptogrid(public.geometry, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_snaptogrid(public.geometry, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_snaptogrid(public.geometry, double precision) TO dbimporter;

--
-- Name: FUNCTION st_snaptogrid(public.geometry, double precision, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_snaptogrid(public.geometry, double precision, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_snaptogrid(public.geometry, double precision, double precision) TO dbimporter;

--
-- Name: FUNCTION st_snaptogrid(public.geometry, double precision, double precision, double precision, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_snaptogrid(public.geometry, double precision, double precision, double precision, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_snaptogrid(public.geometry, double precision, double precision, double precision, double precision) TO dbimporter;

--
-- Name: FUNCTION st_split(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_split(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_split(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_square(size double precision, cell_i integer, cell_j integer, origin public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_square(size double precision, cell_i integer, cell_j integer, origin public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_square(size double precision, cell_i integer, cell_j integer, origin public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_squaregrid(size double precision, bounds public.geometry, OUT geom public.geometry, OUT i integer, OUT j integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_squaregrid(size double precision, bounds public.geometry, OUT geom public.geometry, OUT i integer, OUT j integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_squaregrid(size double precision, bounds public.geometry, OUT geom public.geometry, OUT i integer, OUT j integer) TO dbimporter;

--
-- Name: FUNCTION st_srid(geog public.geography); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_srid(geog public.geography) TO dbhasura;
GRANT ALL ON FUNCTION public.st_srid(geog public.geography) TO dbimporter;

--
-- Name: FUNCTION st_srid(geom public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_srid(geom public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_srid(geom public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_startpoint(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_startpoint(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_startpoint(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_subdivide(geom public.geometry, maxvertices integer, gridsize double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_subdivide(geom public.geometry, maxvertices integer, gridsize double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_subdivide(geom public.geometry, maxvertices integer, gridsize double precision) TO dbimporter;

--
-- Name: FUNCTION st_summary(public.geography); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_summary(public.geography) TO dbhasura;
GRANT ALL ON FUNCTION public.st_summary(public.geography) TO dbimporter;

--
-- Name: FUNCTION st_summary(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_summary(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_summary(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_swapordinates(geom public.geometry, ords cstring); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_swapordinates(geom public.geometry, ords cstring) TO dbhasura;
GRANT ALL ON FUNCTION public.st_swapordinates(geom public.geometry, ords cstring) TO dbimporter;

--
-- Name: FUNCTION st_symdifference(geom1 public.geometry, geom2 public.geometry, gridsize double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_symdifference(geom1 public.geometry, geom2 public.geometry, gridsize double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_symdifference(geom1 public.geometry, geom2 public.geometry, gridsize double precision) TO dbimporter;

--
-- Name: FUNCTION st_symmetricdifference(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_symmetricdifference(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_symmetricdifference(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_tileenvelope(zoom integer, x integer, y integer, bounds public.geometry, margin double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_tileenvelope(zoom integer, x integer, y integer, bounds public.geometry, margin double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_tileenvelope(zoom integer, x integer, y integer, bounds public.geometry, margin double precision) TO dbimporter;

--
-- Name: FUNCTION st_touches(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_touches(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_touches(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_transform(geom public.geometry, from_proj text, to_proj text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_transform(geom public.geometry, from_proj text, to_proj text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_transform(geom public.geometry, from_proj text, to_proj text) TO dbimporter;

--
-- Name: FUNCTION st_transform(geom public.geometry, from_proj text, to_srid integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_transform(geom public.geometry, from_proj text, to_srid integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_transform(geom public.geometry, from_proj text, to_srid integer) TO dbimporter;

--
-- Name: FUNCTION st_transform(geom public.geometry, to_proj text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_transform(geom public.geometry, to_proj text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_transform(geom public.geometry, to_proj text) TO dbimporter;

--
-- Name: FUNCTION st_transform(public.geometry, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_transform(public.geometry, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.st_transform(public.geometry, integer) TO dbimporter;

--
-- Name: FUNCTION st_translate(public.geometry, double precision, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_translate(public.geometry, double precision, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_translate(public.geometry, double precision, double precision) TO dbimporter;

--
-- Name: FUNCTION st_translate(public.geometry, double precision, double precision, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_translate(public.geometry, double precision, double precision, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_translate(public.geometry, double precision, double precision, double precision) TO dbimporter;

--
-- Name: FUNCTION st_transscale(public.geometry, double precision, double precision, double precision, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_transscale(public.geometry, double precision, double precision, double precision, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_transscale(public.geometry, double precision, double precision, double precision, double precision) TO dbimporter;

--
-- Name: FUNCTION st_triangulatepolygon(g1 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_triangulatepolygon(g1 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_triangulatepolygon(g1 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_unaryunion(public.geometry, gridsize double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_unaryunion(public.geometry, gridsize double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_unaryunion(public.geometry, gridsize double precision) TO dbimporter;

--
-- Name: FUNCTION st_union(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_union(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_union(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_union(geom1 public.geometry, geom2 public.geometry, gridsize double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_union(geom1 public.geometry, geom2 public.geometry, gridsize double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_union(geom1 public.geometry, geom2 public.geometry, gridsize double precision) TO dbimporter;

--
-- Name: FUNCTION st_union(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_union(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_union(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_union(public.geometry, double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_union(public.geometry, double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_union(public.geometry, double precision) TO dbimporter;

--
-- Name: FUNCTION st_union(public.geometry[]); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_union(public.geometry[]) TO dbhasura;
GRANT ALL ON FUNCTION public.st_union(public.geometry[]) TO dbimporter;

--
-- Name: FUNCTION st_voronoilines(g1 public.geometry, tolerance double precision, extend_to public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_voronoilines(g1 public.geometry, tolerance double precision, extend_to public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_voronoilines(g1 public.geometry, tolerance double precision, extend_to public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_voronoipolygons(g1 public.geometry, tolerance double precision, extend_to public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_voronoipolygons(g1 public.geometry, tolerance double precision, extend_to public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_voronoipolygons(g1 public.geometry, tolerance double precision, extend_to public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_within(geom1 public.geometry, geom2 public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_within(geom1 public.geometry, geom2 public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_within(geom1 public.geometry, geom2 public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_wkbtosql(wkb bytea); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_wkbtosql(wkb bytea) TO dbhasura;
GRANT ALL ON FUNCTION public.st_wkbtosql(wkb bytea) TO dbimporter;

--
-- Name: FUNCTION st_wkttosql(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_wkttosql(text) TO dbhasura;
GRANT ALL ON FUNCTION public.st_wkttosql(text) TO dbimporter;

--
-- Name: FUNCTION st_wrapx(geom public.geometry, wrap double precision, move double precision); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_wrapx(geom public.geometry, wrap double precision, move double precision) TO dbhasura;
GRANT ALL ON FUNCTION public.st_wrapx(geom public.geometry, wrap double precision, move double precision) TO dbimporter;

--
-- Name: FUNCTION st_x(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_x(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_x(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_xmax(public.box3d); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_xmax(public.box3d) TO dbhasura;
GRANT ALL ON FUNCTION public.st_xmax(public.box3d) TO dbimporter;

--
-- Name: FUNCTION st_xmin(public.box3d); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_xmin(public.box3d) TO dbhasura;
GRANT ALL ON FUNCTION public.st_xmin(public.box3d) TO dbimporter;

--
-- Name: FUNCTION st_y(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_y(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_y(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_ymax(public.box3d); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_ymax(public.box3d) TO dbhasura;
GRANT ALL ON FUNCTION public.st_ymax(public.box3d) TO dbimporter;

--
-- Name: FUNCTION st_ymin(public.box3d); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_ymin(public.box3d) TO dbhasura;
GRANT ALL ON FUNCTION public.st_ymin(public.box3d) TO dbimporter;

--
-- Name: FUNCTION st_z(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_z(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_z(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_zmax(public.box3d); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_zmax(public.box3d) TO dbhasura;
GRANT ALL ON FUNCTION public.st_zmax(public.box3d) TO dbimporter;

--
-- Name: FUNCTION st_zmflag(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_zmflag(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.st_zmflag(public.geometry) TO dbimporter;

--
-- Name: FUNCTION st_zmin(public.box3d); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.st_zmin(public.box3d) TO dbhasura;
GRANT ALL ON FUNCTION public.st_zmin(public.box3d) TO dbimporter;

--
-- Name: FUNCTION text(public.geometry); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.text(public.geometry) TO dbhasura;
GRANT ALL ON FUNCTION public.text(public.geometry) TO dbimporter;

--
-- Name: FUNCTION time_dist(time without time zone, time without time zone); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.time_dist(time without time zone, time without time zone) TO dbhasura;
GRANT ALL ON FUNCTION public.time_dist(time without time zone, time without time zone) TO dbimporter;

--
-- Name: FUNCTION ts_dist(timestamp without time zone, timestamp without time zone); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.ts_dist(timestamp without time zone, timestamp without time zone) TO dbhasura;
GRANT ALL ON FUNCTION public.ts_dist(timestamp without time zone, timestamp without time zone) TO dbimporter;

--
-- Name: FUNCTION tstz_dist(timestamp with time zone, timestamp with time zone); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.tstz_dist(timestamp with time zone, timestamp with time zone) TO dbhasura;
GRANT ALL ON FUNCTION public.tstz_dist(timestamp with time zone, timestamp with time zone) TO dbimporter;

--
-- Name: FUNCTION unlockrows(text); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.unlockrows(text) TO dbhasura;
GRANT ALL ON FUNCTION public.unlockrows(text) TO dbimporter;

--
-- Name: FUNCTION updategeometrysrid(catalogn_name character varying, schema_name character varying, table_name character varying, column_name character varying, new_srid_in integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.updategeometrysrid(catalogn_name character varying, schema_name character varying, table_name character varying, column_name character varying, new_srid_in integer) TO dbhasura;
GRANT ALL ON FUNCTION public.updategeometrysrid(catalogn_name character varying, schema_name character varying, table_name character varying, column_name character varying, new_srid_in integer) TO dbimporter;

--
-- Name: FUNCTION updategeometrysrid(character varying, character varying, character varying, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.updategeometrysrid(character varying, character varying, character varying, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.updategeometrysrid(character varying, character varying, character varying, integer) TO dbimporter;

--
-- Name: FUNCTION updategeometrysrid(character varying, character varying, integer); Type: ACL; Schema: public; Owner: dbadmin
--

GRANT ALL ON FUNCTION public.updategeometrysrid(character varying, character varying, integer) TO dbhasura;
GRANT ALL ON FUNCTION public.updategeometrysrid(character varying, character varying, integer) TO dbimporter;

--
-- Name: TABLE geography_columns; Type: ACL; Schema: public; Owner: dbadmin
--

GRANT SELECT ON TABLE public.geography_columns TO dbhasura;
GRANT SELECT ON TABLE public.geography_columns TO dbimporter;

--
-- Name: TABLE geometry_columns; Type: ACL; Schema: public; Owner: dbadmin
--

GRANT SELECT ON TABLE public.geometry_columns TO dbhasura;
GRANT SELECT ON TABLE public.geometry_columns TO dbimporter;

--
-- Name: TABLE spatial_ref_sys; Type: ACL; Schema: public; Owner: dbadmin
--

GRANT SELECT ON TABLE public.spatial_ref_sys TO dbhasura;
GRANT SELECT ON TABLE public.spatial_ref_sys TO dbimporter;

--
-- Name: TABLE vehicle_mode; Type: ACL; Schema: reusable_components; Owner: dbhasura
--

GRANT SELECT ON TABLE reusable_components.vehicle_mode TO dbimporter;

--
-- Name: TABLE vehicle_submode; Type: ACL; Schema: reusable_components; Owner: dbhasura
--

GRANT SELECT ON TABLE reusable_components.vehicle_submode TO dbimporter;

--
-- Name: TABLE direction; Type: ACL; Schema: route; Owner: dbhasura
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE route.direction TO dbimporter;

--
-- Name: TABLE infrastructure_link_along_route; Type: ACL; Schema: route; Owner: dbhasura
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE route.infrastructure_link_along_route TO dbimporter;

--
-- Name: TABLE line; Type: ACL; Schema: route; Owner: dbhasura
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE route.line TO dbimporter;

--
-- Name: TABLE route; Type: ACL; Schema: route; Owner: dbhasura
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE route.route TO dbimporter;

--
-- Name: TABLE type_of_line; Type: ACL; Schema: route; Owner: dbhasura
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE route.type_of_line TO dbimporter;

--
-- Name: TABLE distance_between_stops_calculation; Type: ACL; Schema: service_pattern; Owner: dbhasura
--

GRANT SELECT ON TABLE service_pattern.distance_between_stops_calculation TO dbimporter;

--
-- Name: TABLE scheduled_stop_point; Type: ACL; Schema: service_pattern; Owner: dbhasura
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE service_pattern.scheduled_stop_point TO dbimporter;

--
-- Name: TABLE scheduled_stop_point_invariant; Type: ACL; Schema: service_pattern; Owner: dbhasura
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE service_pattern.scheduled_stop_point_invariant TO dbimporter;

--
-- Name: TABLE scheduled_stop_points_with_infra_link_data; Type: ACL; Schema: service_pattern; Owner: dbhasura
--

GRANT SELECT ON TABLE service_pattern.scheduled_stop_points_with_infra_link_data TO dbimporter;

--
-- Name: TABLE vehicle_mode_on_scheduled_stop_point; Type: ACL; Schema: service_pattern; Owner: dbhasura
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE service_pattern.vehicle_mode_on_scheduled_stop_point TO dbimporter;

--
-- Name: TABLE timing_place; Type: ACL; Schema: timing_pattern; Owner: dbhasura
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE timing_pattern.timing_place TO dbimporter;

--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';

--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';

--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';

--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';

--
-- Name: EXTENSION postgis_tiger_geocoder; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_tiger_geocoder IS 'PostGIS tiger geocoder and reverse geocoder';

--
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';

--
-- Name: SCHEMA infrastructure_network; Type: COMMENT; Schema: -; Owner: dbhasura
--

COMMENT ON SCHEMA infrastructure_network IS 'The infrastructure network model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:1:1:1:445';

--
-- Name: SCHEMA internal_utils; Type: COMMENT; Schema: -; Owner: dbhasura
--

COMMENT ON SCHEMA internal_utils IS 'General utilities';

--
-- Name: SCHEMA journey_pattern; Type: COMMENT; Schema: -; Owner: dbhasura
--

COMMENT ON SCHEMA journey_pattern IS 'The journey pattern model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:1:799';

--
-- Name: SCHEMA reusable_components; Type: COMMENT; Schema: -; Owner: dbhasura
--

COMMENT ON SCHEMA reusable_components IS 'The reusable components model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=1:6:260';

--
-- Name: SCHEMA route; Type: COMMENT; Schema: -; Owner: dbhasura
--

COMMENT ON SCHEMA route IS 'The route model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:1:3:475';

--
-- Name: SCHEMA service_pattern; Type: COMMENT; Schema: -; Owner: dbhasura
--

COMMENT ON SCHEMA service_pattern IS 'The service pattern model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:4:840';

--
-- Name: SCHEMA timing_pattern; Type: COMMENT; Schema: -; Owner: dbhasura
--

COMMENT ON SCHEMA timing_pattern IS 'The timing pattern model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:2:703 ';

--
-- Name: SCHEMA topology; Type: COMMENT; Schema: -; Owner: dbadmin
--

COMMENT ON SCHEMA topology IS 'PostGIS Topology schema';

--
-- Name: COLUMN infrastructure_link.direction; Type: COMMENT; Schema: infrastructure_network; Owner: dbhasura
--

COMMENT ON COLUMN infrastructure_network.infrastructure_link.direction IS 'The direction(s) of traffic with respect to the digitization, i.e. the direction of the specified line string.';

--
-- Name: COLUMN infrastructure_link.estimated_length_in_metres; Type: COMMENT; Schema: infrastructure_network; Owner: dbhasura
--

COMMENT ON COLUMN infrastructure_network.infrastructure_link.estimated_length_in_metres IS 'The estimated length of the infrastructure link in metres.';

--
-- Name: COLUMN infrastructure_link.infrastructure_link_id; Type: COMMENT; Schema: infrastructure_network; Owner: dbhasura
--

COMMENT ON COLUMN infrastructure_network.infrastructure_link.infrastructure_link_id IS 'The ID of the infrastructure link.';

--
-- Name: COLUMN infrastructure_link.shape; Type: COMMENT; Schema: infrastructure_network; Owner: dbhasura
--

COMMENT ON COLUMN infrastructure_network.infrastructure_link.shape IS 'A PostGIS LinestringZ geography in EPSG:4326 describing the infrastructure link.';

--
-- Name: COLUMN vehicle_submode_on_infrastructure_link.infrastructure_link_id; Type: COMMENT; Schema: infrastructure_network; Owner: dbhasura
--

COMMENT ON COLUMN infrastructure_network.vehicle_submode_on_infrastructure_link.infrastructure_link_id IS 'The infrastructure link that can be safely traversed by the vehicle submode.';

--
-- Name: COLUMN vehicle_submode_on_infrastructure_link.vehicle_submode; Type: COMMENT; Schema: infrastructure_network; Owner: dbhasura
--

COMMENT ON COLUMN infrastructure_network.vehicle_submode_on_infrastructure_link.vehicle_submode IS 'The vehicle submode that can safely traverse the infrastructure link.';

--
-- Name: FUNCTION find_point_direction_on_link(point_of_interest public.geography, infrastructure_link_uuid uuid, point_max_distance_in_meters double precision); Type: COMMENT; Schema: infrastructure_network; Owner: dbhasura
--

COMMENT ON FUNCTION infrastructure_network.find_point_direction_on_link(point_of_interest public.geography, infrastructure_link_uuid uuid, point_max_distance_in_meters double precision) IS 'Function for resolving point direction relative to given infrastructure link.
  Recommended upper limit for point_max_distance_in_meters parameter is 50 as increasing distance increases odds of matching errors.
  Returns null if direction could not be resolved.';

--
-- Name: FUNCTION resolve_point_to_closest_link(geog public.geography); Type: COMMENT; Schema: infrastructure_network; Owner: dbhasura
--

COMMENT ON FUNCTION infrastructure_network.resolve_point_to_closest_link(geog public.geography) IS 'Function for resolving closest infrastructure link to the given point of interest.';

--
-- Name: TABLE direction; Type: COMMENT; Schema: infrastructure_network; Owner: dbhasura
--

COMMENT ON TABLE infrastructure_network.direction IS 'The direction in which an e.g. infrastructure link can be traversed';

--
-- Name: TABLE external_source; Type: COMMENT; Schema: infrastructure_network; Owner: dbhasura
--

COMMENT ON TABLE infrastructure_network.external_source IS 'An external source from which infrastructure network parts are imported';

--
-- Name: TABLE infrastructure_link; Type: COMMENT; Schema: infrastructure_network; Owner: dbhasura
--

COMMENT ON TABLE infrastructure_network.infrastructure_link IS 'The infrastructure links, e.g. road or rail elements: https://www.transmodel-cen.eu/model/index.htm?goto=2:1:1:1:453';

--
-- Name: TABLE vehicle_submode_on_infrastructure_link; Type: COMMENT; Schema: infrastructure_network; Owner: dbhasura
--

COMMENT ON TABLE infrastructure_network.vehicle_submode_on_infrastructure_link IS 'Which infrastructure links are safely traversed by which vehicle submodes?';

--
-- Name: FUNCTION date_closed_upper(range daterange); Type: COMMENT; Schema: internal_utils; Owner: dbhasura
--

COMMENT ON FUNCTION internal_utils.date_closed_upper(range daterange) IS 'This function calculates the upper bound of a date range created by the
  internal_utils.daterange_closed_upper function.';

--
-- Name: FUNCTION daterange_closed_upper(lower_bound date, closed_upper_bound date); Type: COMMENT; Schema: internal_utils; Owner: dbhasura
--

COMMENT ON FUNCTION internal_utils.daterange_closed_upper(lower_bound date, closed_upper_bound date) IS 'In postgresql, date ranges are handled using lower bound closed and upper bound open. In order
  to be able to check for overlapping ranges when using closed upper bounds, this function constructs
  a daterange with the upper bound interpreted as a closed bound. This function behaves the same way
  as "daterange(lower_bound, upper_bound, ''[]'')", but because we also need to access the bounds (and
  this would anyway require manual addition / subtraction of 1 day), we rather do all processing in
  custom functions.

  Note that the range returned by this function will work well for calculating overlaps and merging,
  but does not contain the correct logical upper bound. In order to calculate the upper bound of a range
  created by this function, use the internal_utils.date_closed_upper function.';

--
-- Name: FUNCTION determine_srid(geog public.geography); Type: COMMENT; Schema: internal_utils; Owner: dbhasura
--

COMMENT ON FUNCTION internal_utils.determine_srid(geog public.geography) IS 'Determine the most suitable SRID to be used for the given geography when converting it to a geometry.
   At the moment, this function serves as a wrapper for the internal _ST_BestSRID function, which is poorly
   documented and may be removed in the future.
   If needed, modify this function and its overloads to return the correct SRID(s) for your use case(s). For many
   projects, returning a constant may be a good choice.';

--
-- Name: FUNCTION determine_srid(geog1 public.geography, geog2 public.geography); Type: COMMENT; Schema: internal_utils; Owner: dbhasura
--

COMMENT ON FUNCTION internal_utils.determine_srid(geog1 public.geography, geog2 public.geography) IS 'Determine the most suitable common SRID to be used for the given geographies when converting them into geometries.
   At the moment, this function serves as a wrapper for the internal _ST_BestSRID function, which is poorly
   documented and may be removed in the future.
   If needed, modify this function and its overloads to return the correct SRID(s) for your use case(s). For many
   projects, returning a constant may be a good choice.';

--
-- Name: FUNCTION st_closestpoint(a_linestring public.geography, a_point public.geography); Type: COMMENT; Schema: internal_utils; Owner: dbhasura
--

COMMENT ON FUNCTION internal_utils.st_closestpoint(a_linestring public.geography, a_point public.geography) IS 'ST_ClosestPoint for geography';

--
-- Name: FUNCTION st_lineinterpolatepoint(a_linestring public.geography, a_fraction double precision); Type: COMMENT; Schema: internal_utils; Owner: dbhasura
--

COMMENT ON FUNCTION internal_utils.st_lineinterpolatepoint(a_linestring public.geography, a_fraction double precision) IS 'ST_LineInterpolatePoint for geography';

--
-- Name: FUNCTION st_linelocatepoint(a_linestring public.geography, a_point public.geography); Type: COMMENT; Schema: internal_utils; Owner: dbhasura
--

COMMENT ON FUNCTION internal_utils.st_linelocatepoint(a_linestring public.geography, a_point public.geography) IS 'ST_LineLocatePoint for geography';

--
-- Name: COLUMN journey_pattern.journey_pattern_id; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON COLUMN journey_pattern.journey_pattern.journey_pattern_id IS 'The ID of the journey pattern.';

--
-- Name: COLUMN journey_pattern.on_route_id; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON COLUMN journey_pattern.journey_pattern.on_route_id IS 'The ID of the route the journey pattern is on.';

--
-- Name: COLUMN scheduled_stop_point_in_journey_pattern.is_loading_time_allowed; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON COLUMN journey_pattern.scheduled_stop_point_in_journey_pattern.is_loading_time_allowed IS 'Is adding loading time to this scheduled stop point in the journey pattern allowed?';

--
-- Name: COLUMN scheduled_stop_point_in_journey_pattern.is_regulated_timing_point; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON COLUMN journey_pattern.scheduled_stop_point_in_journey_pattern.is_regulated_timing_point IS 'Is this stop point passing time regulated so that it cannot be passed before scheduled time?';

--
-- Name: COLUMN scheduled_stop_point_in_journey_pattern.is_used_as_timing_point; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON COLUMN journey_pattern.scheduled_stop_point_in_journey_pattern.is_used_as_timing_point IS 'Is this scheduled stop point used as a timing point in the journey pattern?';

--
-- Name: COLUMN scheduled_stop_point_in_journey_pattern.is_via_point; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON COLUMN journey_pattern.scheduled_stop_point_in_journey_pattern.is_via_point IS 'Is this scheduled stop point a via point?';

--
-- Name: COLUMN scheduled_stop_point_in_journey_pattern.journey_pattern_id; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON COLUMN journey_pattern.scheduled_stop_point_in_journey_pattern.journey_pattern_id IS 'The ID of the journey pattern.';

--
-- Name: COLUMN scheduled_stop_point_in_journey_pattern.scheduled_stop_point_sequence; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON COLUMN journey_pattern.scheduled_stop_point_in_journey_pattern.scheduled_stop_point_sequence IS 'The order of the scheduled stop point within the journey pattern.';

--
-- Name: FUNCTION check_infra_link_stop_refs_with_new_scheduled_stop_point(replace_scheduled_stop_point_id uuid, new_located_on_infrastructure_link_id uuid, new_measured_location public.geography, new_direction text, new_label text, new_validity_start date, new_validity_end date, new_priority integer); Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON FUNCTION journey_pattern.check_infra_link_stop_refs_with_new_scheduled_stop_point(replace_scheduled_stop_point_id uuid, new_located_on_infrastructure_link_id uuid, new_measured_location public.geography, new_direction text, new_label text, new_validity_start date, new_validity_end date, new_priority integer) IS 'Check whether the journey pattern''s / route''s links and stop points still correspond to each other
     if a new stop point would be inserted (defined by arguments new_xxx). If replace_scheduled_stop_point_id
     is specified, the new stop point is thought to replace the stop point with that ID.
     This function returns a list of journey pattern and route ids, in which the links
     and stop points would conflict with each other.';

--
-- Name: FUNCTION create_verify_infra_link_stop_refs_queue_temp_table(); Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON FUNCTION journey_pattern.create_verify_infra_link_stop_refs_queue_temp_table() IS 'Create the temp table used to enqueue verification of the changed routes from
  statement-level triggers';

--
-- Name: FUNCTION get_broken_route_check_filters(filter_route_ids uuid[]); Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON FUNCTION journey_pattern.get_broken_route_check_filters(filter_route_ids uuid[]) IS 'Gather the filter parameters (route labels and validity range to check) for the broken route check.';

--
-- Name: FUNCTION get_broken_route_journey_patterns(filter_route_ids uuid[], replace_scheduled_stop_point_id uuid, new_located_on_infrastructure_link_id uuid, new_measured_location public.geography, new_direction text, new_label text, new_validity_start date, new_validity_end date, new_priority integer); Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON FUNCTION journey_pattern.get_broken_route_journey_patterns(filter_route_ids uuid[], replace_scheduled_stop_point_id uuid, new_located_on_infrastructure_link_id uuid, new_measured_location public.geography, new_direction text, new_label text, new_validity_start date, new_validity_end date, new_priority integer) IS 'Check if it is possible to visit all stops of journey patterns in such a fashion that all links, on which
     the stops reside, are visited in an order matching the corresponding routes'' link order. Additionally it is
     checked that there are no stop points on the route''s journey pattern, whose validity span does not overlap with
     the route''s validity span at all. Only the links / stops on the routes with the specified filter_route_ids are
     taken into account for the checks.

     If replace_scheduled_stop_point_id is not null, the stop with that id is left out of the check.
     If the new_xxx arguments are specified, the check is also performed for an imaginary stop defined by those
     arguments, which is not yet present in the table data.

     This functions returns those journey pattern / route combinations, which are broken (either in actual
     table data or with the proposed scheduled stop point changes).';

--
-- Name: FUNCTION infra_link_stop_refs_already_verified(); Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON FUNCTION journey_pattern.infra_link_stop_refs_already_verified() IS 'Keep track of whether the infra link <-> stop ref verification has already been performed in this transaction';

--
-- Name: FUNCTION maximum_priority_validity_spans(entity_type text, filter_route_labels text[], filter_validity_start date, filter_validity_end date, upper_priority_limit integer, replace_scheduled_stop_point_id uuid, new_scheduled_stop_point_id uuid, new_located_on_infrastructure_link_id uuid, new_measured_location public.geography, new_direction text, new_label text, new_validity_start date, new_validity_end date, new_priority integer); Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON FUNCTION journey_pattern.maximum_priority_validity_spans(entity_type text, filter_route_labels text[], filter_validity_start date, filter_validity_end date, upper_priority_limit integer, replace_scheduled_stop_point_id uuid, new_scheduled_stop_point_id uuid, new_located_on_infrastructure_link_id uuid, new_measured_location public.geography, new_direction text, new_label text, new_validity_start date, new_validity_end date, new_priority integer) IS 'Find the validity time spans of highest priority in the given time span for entities of the given type (routes or
    scheduled stop points), which are related to routes with any of the given labels.

    Consider the validity times of two overlapping route instances with label A:
    A* (prio 20):        |--------|
    A (prio 10):   |---------|

    These would be split into the following maximum priority validity time spans:
                   |--A--|--A*----|

    Similarly, the following route instances with label B
    B* (prio 20):        |-------|
    B (prio 10):   |-------------------------|

    would be split into the following maximum priority validity time spans:
                   |--B--|--B*---|----B------|

    For scheduled stop points the splitting is performed in the same fashion, except that if
    replace_scheduled_stop_point_id is not null, the stop with that id is left out. If the new_xxx arguments are
    specified, the check is also performed for a stop defined by those arguments, which is not yet present in the
    table data.';

--
-- Name: FUNCTION scheduled_stop_point_has_timing_place_if_used_as_timing_point(); Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON FUNCTION journey_pattern.scheduled_stop_point_has_timing_place_if_used_as_timing_point() IS 'If scheduled stop point in journey pattern is marked to be used as timing point, a timing place must be attached to each instance of the scheduled stop point.';

--
-- Name: FUNCTION truncate_scheduled_stop_point_in_journey_pattern(); Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON FUNCTION journey_pattern.truncate_scheduled_stop_point_in_journey_pattern() IS 'Truncate the scheduled_stop_point_in_journey_pattern if it contains any rows. It must not be truncated if it
  does not contain data to prevent errors if it was truncated ("touched") within the same transaction.';

--
-- Name: FUNCTION verify_infra_link_stop_refs(); Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON FUNCTION journey_pattern.verify_infra_link_stop_refs() IS 'Perform verification of all queued route entries.
   Raise an exception if the specified journey pattern''s / route''s links and stop points do not
   correspond to each other.';

--
-- Name: FUNCTION verify_route_journey_pattern_refs(filter_journey_pattern_id uuid, filter_route_id uuid); Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON FUNCTION journey_pattern.verify_route_journey_pattern_refs(filter_journey_pattern_id uuid, filter_route_id uuid) IS 'Raise an exception if the specified journey pattern''s / route''s links and stop points do not
   correspond to each other.';

--
-- Name: TABLE journey_pattern; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON TABLE journey_pattern.journey_pattern IS 'The journey patterns, i.e. the ordered lists of stops and timing points along routes: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:1:813';

--
-- Name: TABLE scheduled_stop_point_in_journey_pattern; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON TABLE journey_pattern.scheduled_stop_point_in_journey_pattern IS 'The scheduled stop points that form the journey pattern, in order: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:1:813 . For HSL, all timing points are stops, hence journey pattern instead of service pattern.';

--
-- Name: TRIGGER queue_verify_infra_link_stop_refs_on_jp_update_trigger ON journey_pattern; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON TRIGGER queue_verify_infra_link_stop_refs_on_jp_update_trigger ON journey_pattern.journey_pattern IS 'Trigger to verify the infra link <-> scheduled stop point references.
      Updating a journey_pattern''s reference to a route (on_route_id) can break the route consistency in a way that
      the new route is in violation with the journey pattern''s stop points in one of the following ways:
      1. A stop point of the journey pattern might be located on an infra link which is not part of the journey
         pattern''s new route.
      2. The journey pattern may contain a stop point located at a position in the journey pattern, which does not
         correspond to the position of the stop point''s infra link within the new route.
      3. A stop point might not have any instances whose validity time would at all overlap with the journey
         pattern''s new route''s validity time ("ghost stop").';

--
-- Name: TRIGGER queue_verify_infra_link_stop_refs_on_sspijp_insert_trigger ON scheduled_stop_point_in_journey_pattern; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON TRIGGER queue_verify_infra_link_stop_refs_on_sspijp_insert_trigger ON journey_pattern.scheduled_stop_point_in_journey_pattern IS 'Trigger to verify the infra link <-> scheduled stop point references.
      Inserting a new scheduled_stop_point_in_journey_pattern -row can break the route consistency in the following
      ways:
      1. The inserted stop point might be located on an infra link which is not part of the journey pattern''s route.
      2. The stop point might be inserted at a position in the journey pattern, which does not correspond to the
         position of the stop point''s infra link within the route.
      3. The stop point might not have any instances whose validity time would at all overlap with the journey
         pattern''s route''s validity time ("ghost stop").';

--
-- Name: TRIGGER queue_verify_infra_link_stop_refs_on_sspijp_update_trigger ON scheduled_stop_point_in_journey_pattern; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON TRIGGER queue_verify_infra_link_stop_refs_on_sspijp_update_trigger ON journey_pattern.scheduled_stop_point_in_journey_pattern IS 'Trigger to verify the infra link <-> scheduled stop point references.
      Updating a scheduled_stop_point_in_journey_pattern -row can break the route consistency in the following
      ways:
      1. The updated stop point might be located on an infra link which is not part of the journey pattern''s route.
      2. The stop point might be moved to a position in the journey pattern, which does not correspond to the
         position of the stop point''s infra link within the route.
      3. The updated stop point might not have any instances whose validity time would at all overlap with the journey
         pattern''s route''s validity time ("ghost stop").';

--
-- Name: TRIGGER verify_infra_link_stop_refs_on_journey_pattern_trigger ON journey_pattern; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON TRIGGER verify_infra_link_stop_refs_on_journey_pattern_trigger ON journey_pattern.journey_pattern IS 'Trigger to verify the infra link <-> stop references after a delete on the
   route table.

   This trigger will cause those routes to be checked, whose ID was queued to be checked by a statement
   level trigger.';

--
-- Name: TRIGGER verify_infra_link_stop_refs_on_sspijp_trigger ON scheduled_stop_point_in_journey_pattern; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON TRIGGER verify_infra_link_stop_refs_on_sspijp_trigger ON journey_pattern.scheduled_stop_point_in_journey_pattern IS 'Trigger to verify the infra link <-> stop references after an insert or update on the
   scheduled_stop_point_in_journey_pattern table.

   This trigger will cause those routes to be checked, whose ID was queued to be checked by a statement
   level trigger.';

--
-- Name: COLUMN vehicle_mode.vehicle_mode; Type: COMMENT; Schema: reusable_components; Owner: dbhasura
--

COMMENT ON COLUMN reusable_components.vehicle_mode.vehicle_mode IS 'The vehicle mode from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=1:6:1:283';

--
-- Name: COLUMN vehicle_submode.belonging_to_vehicle_mode; Type: COMMENT; Schema: reusable_components; Owner: dbhasura
--

COMMENT ON COLUMN reusable_components.vehicle_submode.belonging_to_vehicle_mode IS 'The vehicle mode the vehicle submode belongs to: https://www.transmodel-cen.eu/model/index.htm?goto=1:6:1:283';

--
-- Name: COLUMN vehicle_submode.vehicle_submode; Type: COMMENT; Schema: reusable_components; Owner: dbhasura
--

COMMENT ON COLUMN reusable_components.vehicle_submode.vehicle_submode IS 'The vehicle submode, which may have implications on which infrastructure links the vehicle can traverse';

--
-- Name: TABLE vehicle_mode; Type: COMMENT; Schema: reusable_components; Owner: dbhasura
--

COMMENT ON TABLE reusable_components.vehicle_mode IS 'The vehicle modes from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=1:6:1:283';

--
-- Name: TABLE vehicle_submode; Type: COMMENT; Schema: reusable_components; Owner: dbhasura
--

COMMENT ON TABLE reusable_components.vehicle_submode IS 'The vehicle submode, which may have implications on which infrastructure links the vehicle can traverse';

--
-- Name: COLUMN direction.direction; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.direction.direction IS 'The name of the route direction.';

--
-- Name: COLUMN direction.the_opposite_of_direction; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.direction.the_opposite_of_direction IS 'The opposite direction.';

--
-- Name: COLUMN infrastructure_link_along_route.infrastructure_link_id; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.infrastructure_link_along_route.infrastructure_link_id IS 'The ID of the infrastructure link.';

--
-- Name: COLUMN infrastructure_link_along_route.infrastructure_link_sequence; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.infrastructure_link_along_route.infrastructure_link_sequence IS 'The order of the infrastructure link within the journey pattern.';

--
-- Name: COLUMN infrastructure_link_along_route.is_traversal_forwards; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.infrastructure_link_along_route.is_traversal_forwards IS 'Is the infrastructure link traversed in the direction of its linestring?';

--
-- Name: COLUMN infrastructure_link_along_route.route_id; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.infrastructure_link_along_route.route_id IS 'The ID of the route.';

--
-- Name: COLUMN line.label; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.line.label IS 'The label of the line definition. The label is unique for a certain priority and validity period.';

--
-- Name: COLUMN line.line_id; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.line.line_id IS 'The ID of the line.';

--
-- Name: COLUMN line.name_i18n; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.line.name_i18n IS 'The name of the line. Placeholder for multilingual strings.';

--
-- Name: COLUMN line.primary_vehicle_mode; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.line.primary_vehicle_mode IS 'The mode of the vehicles used as primary on the line.';

--
-- Name: COLUMN line.priority; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.line.priority IS 'The priority of the line definition. The definition may be overridden by higher priority definitions.';

--
-- Name: COLUMN line.short_name_i18n; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.line.short_name_i18n IS 'The shorted name of the line. Placeholder for multilingual strings.';

--
-- Name: COLUMN line.type_of_line; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.line.type_of_line IS 'The type of the line.';

--
-- Name: COLUMN line.validity_end; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.line.validity_end IS 'The point in time from which onwards the line is no longer valid (inclusive). If NULL, the line will be always valid.';

--
-- Name: COLUMN line.validity_start; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.line.validity_start IS 'The point in time when the line becomes valid (inclusive). If NULL, the line has been always valid.';

--
-- Name: COLUMN route.description_i18n; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.route.description_i18n IS 'The description of the route in the form of starting location - destination. Placeholder for multilingual strings.';

--
-- Name: COLUMN route.direction; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.route.direction IS 'The direction of the route definition.';

--
-- Name: COLUMN route.label; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.route.label IS 'The label of the route definition.';

--
-- Name: COLUMN route.on_line_id; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.route.on_line_id IS 'The line to which this route belongs.';

--
-- Name: COLUMN route.priority; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.route.priority IS 'The priority of the route definition. The definition may be overridden by higher priority definitions.';

--
-- Name: COLUMN route.route_id; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.route.route_id IS 'The ID of the route.';

--
-- Name: COLUMN route.unique_label; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.route.unique_label IS 'Derived from label. Routes are unique for each unique label for a certain direction, priority and validity period';

--
-- Name: COLUMN route.validity_end; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.route.validity_end IS 'The point in time (inclusive) from which onwards the route is no longer valid. If NULL, the route is valid indefinitely after the start time of the validity period.';

--
-- Name: COLUMN route.validity_start; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.route.validity_start IS 'The point in time (inclusive) when the route becomes valid. If NULL, the route has been always valid before end time of validity period.';

--
-- Name: COLUMN type_of_line.type_of_line; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.type_of_line.type_of_line IS 'GTFS route type: https://developers.google.com/transit/gtfs/reference/extended-route-types';

--
-- Name: TABLE direction; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON TABLE route.direction IS 'The route directions from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:1:3:480';

--
-- Name: TABLE infrastructure_link_along_route; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON TABLE route.infrastructure_link_along_route IS 'The infrastructure links along which the routes are defined.';

--
-- Name: TABLE line; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON TABLE route.line IS 'The line from Transmodel: http://www.transmodel-cen.eu/model/index.htm?goto=2:1:3:487';

--
-- Name: TABLE route; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON TABLE route.route IS 'The routes from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:1:3:483';

--
-- Name: TABLE type_of_line; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON TABLE route.type_of_line IS 'Type of line. https://www.transmodel-cen.eu/model/EARoot/EA2/EA1/EA3/EA491.htm';

--
-- Name: TRIGGER queue_verify_infra_link_stop_refs_on_ilar_delete_trigger ON infrastructure_link_along_route; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON TRIGGER queue_verify_infra_link_stop_refs_on_ilar_delete_trigger ON route.infrastructure_link_along_route IS 'Trigger to verify the infra link <-> scheduled stop point references.
      Deleting an infrastructure_link_along_route -row can break the route consistency in such a way that
      an infra link associated with a stop point on journey pattern might not be part of the route anymore.';

--
-- Name: TRIGGER queue_verify_infra_link_stop_refs_on_ilar_update_trigger ON infrastructure_link_along_route; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON TRIGGER queue_verify_infra_link_stop_refs_on_ilar_update_trigger ON route.infrastructure_link_along_route IS 'Trigger to verify the infra link <-> scheduled stop point references.
      Updating an infrastructure_link_along_route -row can break the route consistency in such a way that
      an infra link associated with a stop point on a journey pattern might not be part of the (journey pattern''s)
      route anymore.';

--
-- Name: TRIGGER queue_verify_infra_link_stop_refs_on_route_delete_trigger ON route; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON TRIGGER queue_verify_infra_link_stop_refs_on_route_delete_trigger ON route.route IS 'Trigger to verify the infra link <-> scheduled stop point references.
      Deleting a route row can "reveal" a lower priority route instance (which was not valid before), which may be
      break the route consistency such that:
      1. The revealed route''s journey pattern may contain a stop point, which is located on an infra link not part of
         the revealed route.
      2. The revealed route''s journey pattern may contain a stop point located at a position in the journey pattern,
         which does not correspond to the position of the stop point''s infra link within the revealed route.
      3. A stop point of the revealed route''s journey pattern might not have any instances whose validity time overlap
         at all with the revealed route''s validity time ("ghost stop").';

--
-- Name: TRIGGER verify_infra_link_stop_refs_on_ilar_trigger ON infrastructure_link_along_route; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON TRIGGER verify_infra_link_stop_refs_on_ilar_trigger ON route.infrastructure_link_along_route IS 'Trigger to verify the infra link <-> stop references after an update or delete on the
   infrastructure_link_along_route table.

   This trigger will cause those routes to be checked, whose ID was queued to be checked by a statement
   level trigger.';

--
-- Name: COLUMN distance_between_stops_calculation.distance_in_metres; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.distance_between_stops_calculation.distance_in_metres IS 'The length of the stop interval in metres.';

--
-- Name: COLUMN distance_between_stops_calculation.end_stop_label; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.distance_between_stops_calculation.end_stop_label IS 'The label of the end stop of the stop interval.';

--
-- Name: COLUMN distance_between_stops_calculation.journey_pattern_id; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.distance_between_stops_calculation.journey_pattern_id IS 'The ID of the journey pattern.';

--
-- Name: COLUMN distance_between_stops_calculation.observation_date; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.distance_between_stops_calculation.observation_date IS 'The observation date for the state of the route related to the journey pattern.';

--
-- Name: COLUMN distance_between_stops_calculation.route_id; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.distance_between_stops_calculation.route_id IS 'The ID of the route related to the journey pattern.';

--
-- Name: COLUMN distance_between_stops_calculation.route_priority; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.distance_between_stops_calculation.route_priority IS 'The priority of the route related to the journey pattern.';

--
-- Name: COLUMN distance_between_stops_calculation.start_stop_label; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.distance_between_stops_calculation.start_stop_label IS 'The label of the start stop of the stop interval.';

--
-- Name: COLUMN distance_between_stops_calculation.stop_interval_sequence; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.distance_between_stops_calculation.stop_interval_sequence IS 'The sequence number of the stop interval within the journey pattern.';

--
-- Name: COLUMN scheduled_stop_point.direction; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.scheduled_stop_point.direction IS 'The direction(s) of traffic with respect to the digitization, i.e. the direction of the specified line string.';

--
-- Name: COLUMN scheduled_stop_point.label; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.scheduled_stop_point.label IS 'The label is the short code that identifies the stop to the passengers. There can be at most one stop with the same label at a time. The label matches the GTFS stop_code.';

--
-- Name: COLUMN scheduled_stop_point.located_on_infrastructure_link_id; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.scheduled_stop_point.located_on_infrastructure_link_id IS 'The infrastructure link on which the stop is located.';

--
-- Name: COLUMN scheduled_stop_point.measured_location; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.scheduled_stop_point.measured_location IS 'The measured location describes the physical location of the stop. For some stops this describes the location of the pole-mounted flag. A PostGIS PointZ geography in EPSG:4326.';

--
-- Name: COLUMN scheduled_stop_point.scheduled_stop_point_id; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.scheduled_stop_point.scheduled_stop_point_id IS 'The ID of the scheduled stop point.';

--
-- Name: COLUMN scheduled_stop_point.stop_place_ref; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.scheduled_stop_point.stop_place_ref IS 'The id of the related stop place in stop registry database.';

--
-- Name: COLUMN scheduled_stop_point.timing_place_id; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.scheduled_stop_point.timing_place_id IS 'Optional reference to a TIMING PLACE. If NULL, the SCHEDULED STOP POINT is not used for timing.';

--
-- Name: COLUMN scheduled_stop_point.validity_end; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.scheduled_stop_point.validity_end IS 'end of the operating date span in the scheduled stop point''s local time (inclusive).';

--
-- Name: COLUMN scheduled_stop_point.validity_start; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.scheduled_stop_point.validity_start IS 'start of the operating date span in the scheduled stop point''s local time (inclusive).';

--
-- Name: COLUMN vehicle_mode_on_scheduled_stop_point.scheduled_stop_point_id; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.vehicle_mode_on_scheduled_stop_point.scheduled_stop_point_id IS 'The scheduled stop point that is serviced by the vehicle mode.';

--
-- Name: COLUMN vehicle_mode_on_scheduled_stop_point.vehicle_mode; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.vehicle_mode_on_scheduled_stop_point.vehicle_mode IS 'The vehicle mode servicing the scheduled stop point.';

--
-- Name: FUNCTION find_effective_scheduled_stop_points_in_journey_pattern(filter_journey_pattern_id uuid, observation_date date, include_draft_stops boolean); Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON FUNCTION service_pattern.find_effective_scheduled_stop_points_in_journey_pattern(filter_journey_pattern_id uuid, observation_date date, include_draft_stops boolean) IS 'Find effective scheduled stop points in journey/service pattern.';

--
-- Name: FUNCTION find_scheduled_stop_point_locations_in_journey_pattern(filter_journey_pattern_id uuid, observation_date date, include_draft_stops boolean); Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON FUNCTION service_pattern.find_scheduled_stop_point_locations_in_journey_pattern(filter_journey_pattern_id uuid, observation_date date, include_draft_stops boolean) IS 'Find location information for scheduled stop points in journey/service pattern.';

--
-- Name: FUNCTION get_distances_between_stop_points_by_routes(route_ids uuid[], observation_date date); Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON FUNCTION service_pattern.get_distances_between_stop_points_by_routes(route_ids uuid[], observation_date date) IS 'Get the distances between scheduled stop points (in metres) for the journey/service patterns resolved from the route identifiers.';

--
-- Name: FUNCTION get_distances_between_stop_points_in_journey_pattern(journey_pattern_id uuid, observation_date date, include_draft_stops boolean); Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON FUNCTION service_pattern.get_distances_between_stop_points_in_journey_pattern(journey_pattern_id uuid, observation_date date, include_draft_stops boolean) IS 'Get the distances between scheduled stop points (in metres) for the given journey/service pattern.';

--
-- Name: FUNCTION get_distances_between_stop_points_in_journey_patterns(journey_pattern_ids uuid[], observation_date date, include_draft_stops boolean); Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON FUNCTION service_pattern.get_distances_between_stop_points_in_journey_patterns(journey_pattern_ids uuid[], observation_date date, include_draft_stops boolean) IS 'Get the distances between scheduled stop points (in metres) for the given journey/service patterns.';

--
-- Name: FUNCTION new_scheduled_stop_point_if_id_given(new_scheduled_stop_point_id uuid, new_located_on_infrastructure_link_id uuid, new_measured_location public.geography, new_direction text, new_label text, new_validity_start date, new_validity_end date, new_priority integer); Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON FUNCTION service_pattern.new_scheduled_stop_point_if_id_given(new_scheduled_stop_point_id uuid, new_located_on_infrastructure_link_id uuid, new_measured_location public.geography, new_direction text, new_label text, new_validity_start date, new_validity_end date, new_priority integer) IS 'Conditionally returns a row representing a new scheduled_stop_point, or nothing.
  Intended to be used in conjunction with service_pattern.scheduled_stop_points_with_infra_link_data view.
  If value for new_scheduled_stop_point_id parameter is given,
  returns a row representing that scheduled_stop_point.
  The structure matches the service_pattern.scheduled_stop_points_with_infra_link_data view.
  In case new_scheduled_stop_point_id is null, returns nothing.
';

--
-- Name: FUNCTION scheduled_stop_point_closest_point_on_infrastructure_link(ssp service_pattern.scheduled_stop_point); Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON FUNCTION service_pattern.scheduled_stop_point_closest_point_on_infrastructure_link(ssp service_pattern.scheduled_stop_point) IS 'The point on the infrastructure link closest to measured_location. A PostGIS PointZ geography in EPSG:4326.';

--
-- Name: FUNCTION ssp_relative_distance_from_infrastructure_link_start(ssp service_pattern.scheduled_stop_point); Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON FUNCTION service_pattern.ssp_relative_distance_from_infrastructure_link_start(ssp service_pattern.scheduled_stop_point) IS 'The relative distance of the stop from the start of the linestring along the infrastructure link. Regardless of the specified direction, this value is the distance from the beginning of the linestring. The distance is normalized to the closed interval [0, 1].';

--
-- Name: TABLE distance_between_stops_calculation; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON TABLE service_pattern.distance_between_stops_calculation IS 'A dummy table that models the results of calculating the lengths of stop intervals from the given journey patterns. The table exists due to the limitations of Hasura and there is no intention to insert anything to it.';

--
-- Name: TABLE scheduled_stop_point; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON TABLE service_pattern.scheduled_stop_point IS 'The scheduled stop points: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:4:845 . Colloquially known as stops from the perspective of timetable planning.';

--
-- Name: TABLE vehicle_mode_on_scheduled_stop_point; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON TABLE service_pattern.vehicle_mode_on_scheduled_stop_point IS 'Which scheduled stop points are serviced by which vehicle modes?';

--
-- Name: TRIGGER queue_verify_infra_link_stop_refs_on_ssp_delete_trigger ON scheduled_stop_point; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON TRIGGER queue_verify_infra_link_stop_refs_on_ssp_delete_trigger ON service_pattern.scheduled_stop_point IS 'Trigger to verify the infra link <-> scheduled stop point references.
      Deleting a scheduled_stop_point instance can break the route consistency in the following ways:
      1. The deleted stop point instance may "reveal" a lower priority stop point instance, which may make the route and
         journey pattern conflict in the ways described above (see trigger for insertion of a row in the
         scheduled_stop_point table).
      2. The updated stop point might not anymore have any instances whose validity time would at all overlap with the
         journey pattern''s route''s validity time ("ghost stop").';

--
-- Name: TRIGGER queue_verify_infra_link_stop_refs_on_ssp_insert_trigger ON scheduled_stop_point; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON TRIGGER queue_verify_infra_link_stop_refs_on_ssp_insert_trigger ON service_pattern.scheduled_stop_point IS 'Trigger to verify the infra link <-> scheduled stop point references.
      Inserting a scheduled_stop_point instance can break the route consistency in the following ways:
      1. The new stop point instance might be located on an infra link which is not part of all of its journey
         pattern''s routes.
      2. The stop point instance might be located on an infra link, whose position in a route does not correspond to the
         position of the stop point in the corresponding journey pattern.';

--
-- Name: TRIGGER queue_verify_infra_link_stop_refs_on_ssp_update_trigger ON scheduled_stop_point; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON TRIGGER queue_verify_infra_link_stop_refs_on_ssp_update_trigger ON service_pattern.scheduled_stop_point IS 'Trigger to verify the infra link <-> scheduled stop point references.
      Updating a scheduled_stop_point instance can break the route consistency in the following ways:
      1. The updated stop point instance might be located on an infra link which is not part of all of its journey
         pattern''s routes.
      2. The updated stop point instance might be located on an infra link, whose position in a route does not
         correspond to the position of the stop point in the corresponding journey pattern.
      3. The deleted stop point instance may "reveal" a lower priority stop point instance (by change of validity time),
         which may make the route and journey pattern conflict in the ways described above with regard to the revealed
         stop point.
      4. The updated stop point might not anymore have any instances whose validity time would at all overlap with the
         journey pattern''s route''s validity time ("ghost stop").';

--
-- Name: TRIGGER verify_infra_link_stop_refs_on_scheduled_stop_point_trigger ON scheduled_stop_point; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON TRIGGER verify_infra_link_stop_refs_on_scheduled_stop_point_trigger ON service_pattern.scheduled_stop_point IS 'Trigger to verify the infra link <-> stop references after an insert, update, or delete on the
   scheduled_stop_point table.

   This trigger will cause those routes to be checked, whose ID was queued to be checked by a statement
   level trigger.';

--
-- Name: VIEW scheduled_stop_points_with_infra_link_data; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON VIEW service_pattern.scheduled_stop_points_with_infra_link_data IS 'Contains scheduled_stop_points enriched with some infra link data.';

--
-- Name: TABLE timing_place; Type: COMMENT; Schema: timing_pattern; Owner: dbhasura
--

COMMENT ON TABLE timing_pattern.timing_place IS 'A set of SCHEDULED STOP POINTs against which the timing information necessary to build schedules may be recorded. In HSL context this is "Hastus paikka". Based on Transmodel entity TIMING POINT: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:2:709 ';

--
-- Name: hdb_action_log hdb_action_log_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: dbhasura
--

ALTER TABLE ONLY hdb_catalog.hdb_action_log
    ADD CONSTRAINT hdb_action_log_pkey PRIMARY KEY (id);

--
-- Name: hdb_cron_event_invocation_logs hdb_cron_event_invocation_logs_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: dbhasura
--

ALTER TABLE ONLY hdb_catalog.hdb_cron_event_invocation_logs
    ADD CONSTRAINT hdb_cron_event_invocation_logs_pkey PRIMARY KEY (id);

--
-- Name: hdb_cron_events hdb_cron_events_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: dbhasura
--

ALTER TABLE ONLY hdb_catalog.hdb_cron_events
    ADD CONSTRAINT hdb_cron_events_pkey PRIMARY KEY (id);

--
-- Name: hdb_metadata hdb_metadata_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: dbhasura
--

ALTER TABLE ONLY hdb_catalog.hdb_metadata
    ADD CONSTRAINT hdb_metadata_pkey PRIMARY KEY (id);

--
-- Name: hdb_metadata hdb_metadata_resource_version_key; Type: CONSTRAINT; Schema: hdb_catalog; Owner: dbhasura
--

ALTER TABLE ONLY hdb_catalog.hdb_metadata
    ADD CONSTRAINT hdb_metadata_resource_version_key UNIQUE (resource_version);

--
-- Name: hdb_scheduled_event_invocation_logs hdb_scheduled_event_invocation_logs_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: dbhasura
--

ALTER TABLE ONLY hdb_catalog.hdb_scheduled_event_invocation_logs
    ADD CONSTRAINT hdb_scheduled_event_invocation_logs_pkey PRIMARY KEY (id);

--
-- Name: hdb_scheduled_events hdb_scheduled_events_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: dbhasura
--

ALTER TABLE ONLY hdb_catalog.hdb_scheduled_events
    ADD CONSTRAINT hdb_scheduled_events_pkey PRIMARY KEY (id);

--
-- Name: hdb_schema_notifications hdb_schema_notifications_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: dbhasura
--

ALTER TABLE ONLY hdb_catalog.hdb_schema_notifications
    ADD CONSTRAINT hdb_schema_notifications_pkey PRIMARY KEY (id);

--
-- Name: hdb_version hdb_version_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: dbhasura
--

ALTER TABLE ONLY hdb_catalog.hdb_version
    ADD CONSTRAINT hdb_version_pkey PRIMARY KEY (hasura_uuid);

--
-- Name: direction direction_pkey; Type: CONSTRAINT; Schema: infrastructure_network; Owner: dbhasura
--

ALTER TABLE ONLY infrastructure_network.direction
    ADD CONSTRAINT direction_pkey PRIMARY KEY (value);

--
-- Name: external_source external_source_pkey; Type: CONSTRAINT; Schema: infrastructure_network; Owner: dbhasura
--

ALTER TABLE ONLY infrastructure_network.external_source
    ADD CONSTRAINT external_source_pkey PRIMARY KEY (value);

--
-- Name: infrastructure_link infrastructure_link_pkey; Type: CONSTRAINT; Schema: infrastructure_network; Owner: dbhasura
--

ALTER TABLE ONLY infrastructure_network.infrastructure_link
    ADD CONSTRAINT infrastructure_link_pkey PRIMARY KEY (infrastructure_link_id);

--
-- Name: vehicle_submode_on_infrastructure_link vehicle_submode_on_infrastructure_link_pkey; Type: CONSTRAINT; Schema: infrastructure_network; Owner: dbhasura
--

ALTER TABLE ONLY infrastructure_network.vehicle_submode_on_infrastructure_link
    ADD CONSTRAINT vehicle_submode_on_infrastructure_link_pkey PRIMARY KEY (infrastructure_link_id, vehicle_submode);

--
-- Name: journey_pattern journey_pattern_pkey; Type: CONSTRAINT; Schema: journey_pattern; Owner: dbhasura
--

ALTER TABLE ONLY journey_pattern.journey_pattern
    ADD CONSTRAINT journey_pattern_pkey PRIMARY KEY (journey_pattern_id);

--
-- Name: scheduled_stop_point_in_journey_pattern scheduled_stop_point_in_journey_pattern_pkey; Type: CONSTRAINT; Schema: journey_pattern; Owner: dbhasura
--

ALTER TABLE ONLY journey_pattern.scheduled_stop_point_in_journey_pattern
    ADD CONSTRAINT scheduled_stop_point_in_journey_pattern_pkey PRIMARY KEY (journey_pattern_id, scheduled_stop_point_sequence);

--
-- Name: vehicle_mode vehicle_mode_pkey; Type: CONSTRAINT; Schema: reusable_components; Owner: dbhasura
--

ALTER TABLE ONLY reusable_components.vehicle_mode
    ADD CONSTRAINT vehicle_mode_pkey PRIMARY KEY (vehicle_mode);

--
-- Name: vehicle_submode vehicle_submode_pkey; Type: CONSTRAINT; Schema: reusable_components; Owner: dbhasura
--

ALTER TABLE ONLY reusable_components.vehicle_submode
    ADD CONSTRAINT vehicle_submode_pkey PRIMARY KEY (vehicle_submode);

--
-- Name: direction direction_pkey; Type: CONSTRAINT; Schema: route; Owner: dbhasura
--

ALTER TABLE ONLY route.direction
    ADD CONSTRAINT direction_pkey PRIMARY KEY (direction);

--
-- Name: infrastructure_link_along_route infrastructure_link_along_route_pkey; Type: CONSTRAINT; Schema: route; Owner: dbhasura
--

ALTER TABLE ONLY route.infrastructure_link_along_route
    ADD CONSTRAINT infrastructure_link_along_route_pkey PRIMARY KEY (route_id, infrastructure_link_sequence);

--
-- Name: line line_pkey; Type: CONSTRAINT; Schema: route; Owner: dbhasura
--

ALTER TABLE ONLY route.line
    ADD CONSTRAINT line_pkey PRIMARY KEY (line_id);

--
-- Name: line line_unique_validity_period; Type: CONSTRAINT; Schema: route; Owner: dbhasura
--

ALTER TABLE ONLY route.line
    ADD CONSTRAINT line_unique_validity_period EXCLUDE USING gist (label WITH =, priority WITH =, internal_utils.daterange_closed_upper(validity_start, validity_end) WITH &&) WHERE ((priority < internal_utils.const_priority_draft()));

--
-- Name: route route_pkey; Type: CONSTRAINT; Schema: route; Owner: dbhasura
--

ALTER TABLE ONLY route.route
    ADD CONSTRAINT route_pkey PRIMARY KEY (route_id);

--
-- Name: route route_unique_validity_period; Type: CONSTRAINT; Schema: route; Owner: dbhasura
--

ALTER TABLE ONLY route.route
    ADD CONSTRAINT route_unique_validity_period EXCLUDE USING gist (unique_label WITH =, direction WITH =, priority WITH =, internal_utils.daterange_closed_upper(validity_start, validity_end) WITH &&) WHERE ((priority < internal_utils.const_priority_draft()));

--
-- Name: type_of_line type_of_line_pkey; Type: CONSTRAINT; Schema: route; Owner: dbhasura
--

ALTER TABLE ONLY route.type_of_line
    ADD CONSTRAINT type_of_line_pkey PRIMARY KEY (type_of_line);

--
-- Name: distance_between_stops_calculation distance_between_stops_calculation_pkey; Type: CONSTRAINT; Schema: service_pattern; Owner: dbhasura
--

ALTER TABLE ONLY service_pattern.distance_between_stops_calculation
    ADD CONSTRAINT distance_between_stops_calculation_pkey PRIMARY KEY (journey_pattern_id, route_priority, observation_date, stop_interval_sequence);

--
-- Name: scheduled_stop_point scheduled_stop_point_pkey; Type: CONSTRAINT; Schema: service_pattern; Owner: dbhasura
--

ALTER TABLE ONLY service_pattern.scheduled_stop_point
    ADD CONSTRAINT scheduled_stop_point_pkey PRIMARY KEY (scheduled_stop_point_id);

--
-- Name: scheduled_stop_point unique_validity_period; Type: CONSTRAINT; Schema: service_pattern; Owner: dbhasura
--

ALTER TABLE ONLY service_pattern.scheduled_stop_point
    ADD CONSTRAINT unique_validity_period EXCLUDE USING gist (label WITH =, priority WITH =, internal_utils.daterange_closed_upper(validity_start, validity_end) WITH &&) WHERE ((priority < internal_utils.const_priority_draft()));

--
-- Name: scheduled_stop_point_invariant scheduled_stop_point_invariant_pkey; Type: CONSTRAINT; Schema: service_pattern; Owner: dbhasura
--

ALTER TABLE ONLY service_pattern.scheduled_stop_point_invariant
    ADD CONSTRAINT scheduled_stop_point_invariant_pkey PRIMARY KEY (label);

--
-- Name: vehicle_mode_on_scheduled_stop_point scheduled_stop_point_serviced_by_vehicle_mode_pkey; Type: CONSTRAINT; Schema: service_pattern; Owner: dbhasura
--

ALTER TABLE ONLY service_pattern.vehicle_mode_on_scheduled_stop_point
    ADD CONSTRAINT scheduled_stop_point_serviced_by_vehicle_mode_pkey PRIMARY KEY (scheduled_stop_point_id, vehicle_mode);

--
-- Name: timing_place timing_place_pkey; Type: CONSTRAINT; Schema: timing_pattern; Owner: dbhasura
--

ALTER TABLE ONLY timing_pattern.timing_place
    ADD CONSTRAINT timing_place_pkey PRIMARY KEY (timing_place_id);

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: infrastructure_network; Owner: dbhasura
--

ALTER DEFAULT PRIVILEGES FOR ROLE dbhasura IN SCHEMA infrastructure_network GRANT SELECT ON TABLES  TO dbimporter;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: internal_service_pattern; Owner: dbhasura
--

ALTER DEFAULT PRIVILEGES FOR ROLE dbhasura IN SCHEMA internal_service_pattern GRANT SELECT ON TABLES  TO dbimporter;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: internal_utils; Owner: dbhasura
--

ALTER DEFAULT PRIVILEGES FOR ROLE dbhasura IN SCHEMA internal_utils GRANT SELECT ON TABLES  TO dbimporter;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: journey_pattern; Owner: dbhasura
--

ALTER DEFAULT PRIVILEGES FOR ROLE dbhasura IN SCHEMA journey_pattern GRANT SELECT ON TABLES  TO dbimporter;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: reusable_components; Owner: dbhasura
--

ALTER DEFAULT PRIVILEGES FOR ROLE dbhasura IN SCHEMA reusable_components GRANT SELECT ON TABLES  TO dbimporter;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: route; Owner: dbhasura
--

ALTER DEFAULT PRIVILEGES FOR ROLE dbhasura IN SCHEMA route GRANT SELECT ON TABLES  TO dbimporter;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: service_pattern; Owner: dbhasura
--

ALTER DEFAULT PRIVILEGES FOR ROLE dbhasura IN SCHEMA service_pattern GRANT SELECT ON TABLES  TO dbimporter;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: timing_pattern; Owner: dbhasura
--

ALTER DEFAULT PRIVILEGES FOR ROLE dbhasura IN SCHEMA timing_pattern GRANT SELECT ON TABLES  TO dbimporter;

--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;

--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;

--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;

--
-- Name: postgis_tiger_geocoder; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder WITH SCHEMA tiger;

--
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;

--
-- Name: hdb_cron_event_invocation_logs hdb_cron_event_invocation_logs_event_id_fkey; Type: FK CONSTRAINT; Schema: hdb_catalog; Owner: dbhasura
--

ALTER TABLE ONLY hdb_catalog.hdb_cron_event_invocation_logs
    ADD CONSTRAINT hdb_cron_event_invocation_logs_event_id_fkey FOREIGN KEY (event_id) REFERENCES hdb_catalog.hdb_cron_events(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- Name: hdb_scheduled_event_invocation_logs hdb_scheduled_event_invocation_logs_event_id_fkey; Type: FK CONSTRAINT; Schema: hdb_catalog; Owner: dbhasura
--

ALTER TABLE ONLY hdb_catalog.hdb_scheduled_event_invocation_logs
    ADD CONSTRAINT hdb_scheduled_event_invocation_logs_event_id_fkey FOREIGN KEY (event_id) REFERENCES hdb_catalog.hdb_scheduled_events(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- Name: infrastructure_link infrastructure_link_direction_fkey; Type: FK CONSTRAINT; Schema: infrastructure_network; Owner: dbhasura
--

ALTER TABLE ONLY infrastructure_network.infrastructure_link
    ADD CONSTRAINT infrastructure_link_direction_fkey FOREIGN KEY (direction) REFERENCES infrastructure_network.direction(value);

--
-- Name: infrastructure_link infrastructure_link_external_link_source_fkey; Type: FK CONSTRAINT; Schema: infrastructure_network; Owner: dbhasura
--

ALTER TABLE ONLY infrastructure_network.infrastructure_link
    ADD CONSTRAINT infrastructure_link_external_link_source_fkey FOREIGN KEY (external_link_source) REFERENCES infrastructure_network.external_source(value);

--
-- Name: vehicle_submode_on_infrastructure_link vehicle_submode_on_infrastructure_link_infrastructure_link_id_f; Type: FK CONSTRAINT; Schema: infrastructure_network; Owner: dbhasura
--

ALTER TABLE ONLY infrastructure_network.vehicle_submode_on_infrastructure_link
    ADD CONSTRAINT vehicle_submode_on_infrastructure_link_infrastructure_link_id_f FOREIGN KEY (infrastructure_link_id) REFERENCES infrastructure_network.infrastructure_link(infrastructure_link_id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- Name: vehicle_submode_on_infrastructure_link vehicle_submode_on_infrastructure_link_vehicle_submode_fkey; Type: FK CONSTRAINT; Schema: infrastructure_network; Owner: dbhasura
--

ALTER TABLE ONLY infrastructure_network.vehicle_submode_on_infrastructure_link
    ADD CONSTRAINT vehicle_submode_on_infrastructure_link_vehicle_submode_fkey FOREIGN KEY (vehicle_submode) REFERENCES reusable_components.vehicle_submode(vehicle_submode);

--
-- Name: journey_pattern journey_pattern_on_route_id_fkey; Type: FK CONSTRAINT; Schema: journey_pattern; Owner: dbhasura
--

ALTER TABLE ONLY journey_pattern.journey_pattern
    ADD CONSTRAINT journey_pattern_on_route_id_fkey FOREIGN KEY (on_route_id) REFERENCES route.route(route_id) ON DELETE CASCADE;

--
-- Name: scheduled_stop_point_in_journey_pattern scheduled_stop_point_in_journe__scheduled_stop_point_label_fkey; Type: FK CONSTRAINT; Schema: journey_pattern; Owner: dbhasura
--

ALTER TABLE ONLY journey_pattern.scheduled_stop_point_in_journey_pattern
    ADD CONSTRAINT scheduled_stop_point_in_journe__scheduled_stop_point_label_fkey FOREIGN KEY (scheduled_stop_point_label) REFERENCES service_pattern.scheduled_stop_point_invariant(label) ON DELETE CASCADE;

--
-- Name: scheduled_stop_point_in_journey_pattern scheduled_stop_point_in_journey_pattern_journey_pattern_id_fkey; Type: FK CONSTRAINT; Schema: journey_pattern; Owner: dbhasura
--

ALTER TABLE ONLY journey_pattern.scheduled_stop_point_in_journey_pattern
    ADD CONSTRAINT scheduled_stop_point_in_journey_pattern_journey_pattern_id_fkey FOREIGN KEY (journey_pattern_id) REFERENCES journey_pattern.journey_pattern(journey_pattern_id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- Name: vehicle_submode vehicle_submode_belonging_to_vehicle_mode_fkey; Type: FK CONSTRAINT; Schema: reusable_components; Owner: dbhasura
--

ALTER TABLE ONLY reusable_components.vehicle_submode
    ADD CONSTRAINT vehicle_submode_belonging_to_vehicle_mode_fkey FOREIGN KEY (belonging_to_vehicle_mode) REFERENCES reusable_components.vehicle_mode(vehicle_mode);

--
-- Name: direction direction_the_opposite_of_direction_fkey; Type: FK CONSTRAINT; Schema: route; Owner: dbhasura
--

ALTER TABLE ONLY route.direction
    ADD CONSTRAINT direction_the_opposite_of_direction_fkey FOREIGN KEY (the_opposite_of_direction) REFERENCES route.direction(direction);

--
-- Name: infrastructure_link_along_route infrastructure_link_along_route_infrastructure_link_id_fkey; Type: FK CONSTRAINT; Schema: route; Owner: dbhasura
--

ALTER TABLE ONLY route.infrastructure_link_along_route
    ADD CONSTRAINT infrastructure_link_along_route_infrastructure_link_id_fkey FOREIGN KEY (infrastructure_link_id) REFERENCES infrastructure_network.infrastructure_link(infrastructure_link_id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- Name: infrastructure_link_along_route infrastructure_link_along_route_route_id_fkey; Type: FK CONSTRAINT; Schema: route; Owner: dbhasura
--

ALTER TABLE ONLY route.infrastructure_link_along_route
    ADD CONSTRAINT infrastructure_link_along_route_route_id_fkey FOREIGN KEY (route_id) REFERENCES route.route(route_id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- Name: line line_primary_vehicle_mode_fkey; Type: FK CONSTRAINT; Schema: route; Owner: dbhasura
--

ALTER TABLE ONLY route.line
    ADD CONSTRAINT line_primary_vehicle_mode_fkey FOREIGN KEY (primary_vehicle_mode) REFERENCES reusable_components.vehicle_mode(vehicle_mode);

--
-- Name: line line_type_of_line_fkey; Type: FK CONSTRAINT; Schema: route; Owner: dbhasura
--

ALTER TABLE ONLY route.line
    ADD CONSTRAINT line_type_of_line_fkey FOREIGN KEY (type_of_line) REFERENCES route.type_of_line(type_of_line);

--
-- Name: route route_direction_fkey; Type: FK CONSTRAINT; Schema: route; Owner: dbhasura
--

ALTER TABLE ONLY route.route
    ADD CONSTRAINT route_direction_fkey FOREIGN KEY (direction) REFERENCES route.direction(direction);

--
-- Name: route route_on_line_id_fkey; Type: FK CONSTRAINT; Schema: route; Owner: dbhasura
--

ALTER TABLE ONLY route.route
    ADD CONSTRAINT route_on_line_id_fkey FOREIGN KEY (on_line_id) REFERENCES route.line(line_id);

--
-- Name: type_of_line type_of_line_belonging_to_vehicle_mode_fkey; Type: FK CONSTRAINT; Schema: route; Owner: dbhasura
--

ALTER TABLE ONLY route.type_of_line
    ADD CONSTRAINT type_of_line_belonging_to_vehicle_mode_fkey FOREIGN KEY (belonging_to_vehicle_mode) REFERENCES reusable_components.vehicle_mode(vehicle_mode);

--
-- Name: scheduled_stop_point scheduled_stop_point_direction_fkey; Type: FK CONSTRAINT; Schema: service_pattern; Owner: dbhasura
--

ALTER TABLE ONLY service_pattern.scheduled_stop_point
    ADD CONSTRAINT scheduled_stop_point_direction_fkey FOREIGN KEY (direction) REFERENCES infrastructure_network.direction(value);

--
-- Name: scheduled_stop_point scheduled_stop_point_located_on_infrastructure_link_id_fkey; Type: FK CONSTRAINT; Schema: service_pattern; Owner: dbhasura
--

ALTER TABLE ONLY service_pattern.scheduled_stop_point
    ADD CONSTRAINT scheduled_stop_point_located_on_infrastructure_link_id_fkey FOREIGN KEY (located_on_infrastructure_link_id) REFERENCES infrastructure_network.infrastructure_link(infrastructure_link_id);

--
-- Name: scheduled_stop_point scheduled_stop_point_scheduled_stop_point_invariant_label_fkey; Type: FK CONSTRAINT; Schema: service_pattern; Owner: dbhasura
--

ALTER TABLE ONLY service_pattern.scheduled_stop_point
    ADD CONSTRAINT scheduled_stop_point_scheduled_stop_point_invariant_label_fkey FOREIGN KEY (label) REFERENCES service_pattern.scheduled_stop_point_invariant(label);

--
-- Name: scheduled_stop_point scheduled_stop_point_timing_place_id_fkey; Type: FK CONSTRAINT; Schema: service_pattern; Owner: dbhasura
--

ALTER TABLE ONLY service_pattern.scheduled_stop_point
    ADD CONSTRAINT scheduled_stop_point_timing_place_id_fkey FOREIGN KEY (timing_place_id) REFERENCES timing_pattern.timing_place(timing_place_id);

--
-- Name: vehicle_mode_on_scheduled_stop_point scheduled_stop_point_serviced_by_vehicle_mode_vehicle_mode_fkey; Type: FK CONSTRAINT; Schema: service_pattern; Owner: dbhasura
--

ALTER TABLE ONLY service_pattern.vehicle_mode_on_scheduled_stop_point
    ADD CONSTRAINT scheduled_stop_point_serviced_by_vehicle_mode_vehicle_mode_fkey FOREIGN KEY (vehicle_mode) REFERENCES reusable_components.vehicle_mode(vehicle_mode);

--
-- Name: vehicle_mode_on_scheduled_stop_point vehicle_mode_on_scheduled_stop_point_scheduled_stop_point_id_fk; Type: FK CONSTRAINT; Schema: service_pattern; Owner: dbhasura
--

ALTER TABLE ONLY service_pattern.vehicle_mode_on_scheduled_stop_point
    ADD CONSTRAINT vehicle_mode_on_scheduled_stop_point_scheduled_stop_point_id_fk FOREIGN KEY (scheduled_stop_point_id) REFERENCES service_pattern.scheduled_stop_point(scheduled_stop_point_id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- Name: gen_hasura_uuid(); Type: FUNCTION; Schema: hdb_catalog; Owner: dbhasura
--

CREATE FUNCTION hdb_catalog.gen_hasura_uuid() RETURNS uuid
    LANGUAGE sql
    AS $$select gen_random_uuid()$$;


ALTER FUNCTION hdb_catalog.gen_hasura_uuid() OWNER TO dbhasura;

--
-- Name: check_infrastructure_link_route_link_direction(); Type: FUNCTION; Schema: infrastructure_network; Owner: dbhasura
--

CREATE FUNCTION infrastructure_network.check_infrastructure_link_route_link_direction() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS(
    SELECT 1
    FROM route.infrastructure_link_along_route
           JOIN infrastructure_network.infrastructure_link
                ON infrastructure_network.infrastructure_link.infrastructure_link_id =
                   route.infrastructure_link_along_route.infrastructure_link_id
    WHERE route.infrastructure_link_along_route.infrastructure_link_id = NEW.infrastructure_link_id
      AND (
      -- NB: NEW.direction = 'bidirectional' allows both traversal directions
        (route.infrastructure_link_along_route.is_traversal_forwards = TRUE AND NEW.direction = 'backward') OR
        (route.infrastructure_link_along_route.is_traversal_forwards = FALSE AND NEW.direction = 'forward')
      )
    )
  THEN
    RAISE EXCEPTION 'route link direction must be compatible with infrastructure link direction';
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION infrastructure_network.check_infrastructure_link_route_link_direction() OWNER TO dbhasura;

--
-- Name: check_infrastructure_link_scheduled_stop_points_direction_trigg(); Type: FUNCTION; Schema: infrastructure_network; Owner: dbhasura
--

CREATE FUNCTION infrastructure_network.check_infrastructure_link_scheduled_stop_points_direction_trigg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS(
    SELECT 1
    FROM service_pattern.scheduled_stop_point
    JOIN infrastructure_network.infrastructure_link
      ON infrastructure_network.infrastructure_link.infrastructure_link_id =
         service_pattern.scheduled_stop_point.located_on_infrastructure_link_id
    WHERE service_pattern.scheduled_stop_point.located_on_infrastructure_link_id = NEW.infrastructure_link_id
    AND (
      (service_pattern.scheduled_stop_point.direction = 'forward' AND NEW.direction = 'backward') OR
      (service_pattern.scheduled_stop_point.direction = 'backward' AND NEW.direction = 'forward') OR
      (service_pattern.scheduled_stop_point.direction = 'bidirectional' AND NEW.direction != 'bidirectional')
    )
  )
  THEN
    RAISE EXCEPTION 'infrastructure link direction must be compatible with the directions of the stop points residing on it';
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION infrastructure_network.check_infrastructure_link_scheduled_stop_points_direction_trigg() OWNER TO dbhasura;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: find_point_direction_on_link(public.geography, uuid, double precision); Type: FUNCTION; Schema: infrastructure_network; Owner: dbhasura
--

CREATE FUNCTION infrastructure_network.find_point_direction_on_link(point_of_interest public.geography, infrastructure_link_uuid uuid, point_max_distance_in_meters double precision DEFAULT 50.0) RETURNS SETOF infrastructure_network.direction
    LANGUAGE sql STABLE STRICT PARALLEL SAFE
    AS $$
SELECT direction.*
FROM (
    SELECT shape
    FROM infrastructure_network.infrastructure_link
    WHERE infrastructure_link_id = infrastructure_link_uuid
) link
CROSS JOIN LATERAL (
    SELECT
        ST_Transform(ST_Force2D(point_of_interest::geometry), srid) AS point_geom,
        ST_Transform(ST_Force2D(link.shape::geometry), srid) AS link_geom
    FROM (
        SELECT internal_utils.determine_srid(link.shape, point_of_interest) AS srid
    ) best
) geom_2d
CROSS JOIN LATERAL (
    SELECT
        ST_Buffer(link_geom, capped_radius, 'side=left' ) AS lhs_side_buf_geom,
        ST_Buffer(link_geom, capped_radius, 'side=right') AS rhs_side_buf_geom
    FROM (
        -- Buffer radius is capped by link length in order to have sensible side buffer areas.
        SELECT least(point_max_distance_in_meters, floor(ST_Length(link_geom))) AS capped_radius
    ) buf_radius
) side_buf
CROSS JOIN LATERAL (
    SELECT
        CASE
            WHEN in_left = false AND in_right = true THEN 'forward'
            WHEN in_left = true AND in_right = false THEN 'backward'
            ELSE null
        END AS value
    FROM (
        SELECT
            ST_Contains(lhs_side_buf_geom, point_geom) AS in_left,
            ST_Contains(rhs_side_buf_geom, point_geom) AS in_right
    ) direction_test
) calculated_direction
INNER JOIN infrastructure_network.direction direction ON direction.value = calculated_direction.value;
$$;


ALTER FUNCTION infrastructure_network.find_point_direction_on_link(point_of_interest public.geography, infrastructure_link_uuid uuid, point_max_distance_in_meters double precision) OWNER TO dbhasura;

--
-- Name: resolve_point_to_closest_link(public.geography); Type: FUNCTION; Schema: infrastructure_network; Owner: dbhasura
--

CREATE FUNCTION infrastructure_network.resolve_point_to_closest_link(geog public.geography) RETURNS SETOF infrastructure_network.infrastructure_link
    LANGUAGE sql STABLE STRICT PARALLEL SAFE
    AS $$
SELECT link.*
FROM (
    SELECT geog
) point_of_interest
CROSS JOIN LATERAL (
    SELECT
        link.infrastructure_link_id,
        point_of_interest.geog <-> link.shape AS distance
    FROM infrastructure_network.infrastructure_link link
    WHERE ST_DWithin(point_of_interest.geog, link.shape, 100) -- link filtering radius set to 100 m
    ORDER BY distance
    LIMIT 1
) closest_link_result
INNER JOIN infrastructure_network.infrastructure_link link ON link.infrastructure_link_id = closest_link_result.infrastructure_link_id;
$$;


ALTER FUNCTION infrastructure_network.resolve_point_to_closest_link(geog public.geography) OWNER TO dbhasura;

--
-- Name: insert_scheduled_stop_point_with_vehicle_mode(uuid, public.geography, uuid, text, text, date, date, integer, text, uuid); Type: FUNCTION; Schema: internal_service_pattern; Owner: dbhasura
--

CREATE FUNCTION internal_service_pattern.insert_scheduled_stop_point_with_vehicle_mode(scheduled_stop_point_id uuid, measured_location public.geography, located_on_infrastructure_link_id uuid, direction text, label text, validity_start date, validity_end date, priority integer, supported_vehicle_mode text, timing_place_id uuid DEFAULT NULL::uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO service_pattern.scheduled_stop_point (scheduled_stop_point_id,
                                                    measured_location,
                                                    located_on_infrastructure_link_id,
                                                    direction,
                                                    label,
                                                    timing_place_id,
                                                    validity_start,
                                                    validity_end,
                                                    priority)
  VALUES (scheduled_stop_point_id,
          measured_location,
          located_on_infrastructure_link_id,
          direction,
          label,
          timing_place_id,
          validity_start,
          validity_end,
          priority);

  INSERT INTO service_pattern.vehicle_mode_on_scheduled_stop_point(scheduled_stop_point_id,
                                                                   vehicle_mode)
  VALUES (scheduled_stop_point_id,
          supported_vehicle_mode);
END;
$$;


ALTER FUNCTION internal_service_pattern.insert_scheduled_stop_point_with_vehicle_mode(scheduled_stop_point_id uuid, measured_location public.geography, located_on_infrastructure_link_id uuid, direction text, label text, validity_start date, validity_end date, priority integer, supported_vehicle_mode text, timing_place_id uuid) OWNER TO dbhasura;

--
-- Name: const_priority_draft(); Type: FUNCTION; Schema: internal_utils; Owner: dbhasura
--

CREATE FUNCTION internal_utils.const_priority_draft() RETURNS integer
    LANGUAGE sql IMMUTABLE PARALLEL SAFE
    AS $$SELECT 30$$;


ALTER FUNCTION internal_utils.const_priority_draft() OWNER TO dbhasura;

--
-- Name: date_closed_upper(daterange); Type: FUNCTION; Schema: internal_utils; Owner: dbhasura
--

CREATE FUNCTION internal_utils.date_closed_upper(range daterange) RETURNS date
    LANGUAGE sql IMMUTABLE PARALLEL SAFE
    AS $$
SELECT internal_utils.prev_day(upper(range));
$$;


ALTER FUNCTION internal_utils.date_closed_upper(range daterange) OWNER TO dbhasura;

--
-- Name: daterange_closed_upper(date, date); Type: FUNCTION; Schema: internal_utils; Owner: dbhasura
--

CREATE FUNCTION internal_utils.daterange_closed_upper(lower_bound date, closed_upper_bound date) RETURNS daterange
    LANGUAGE sql IMMUTABLE PARALLEL SAFE
    AS $$
SELECT daterange(lower_bound, internal_utils.next_day(closed_upper_bound));
$$;


ALTER FUNCTION internal_utils.daterange_closed_upper(lower_bound date, closed_upper_bound date) OWNER TO dbhasura;

--
-- Name: determine_srid(public.geography); Type: FUNCTION; Schema: internal_utils; Owner: dbhasura
--

CREATE FUNCTION internal_utils.determine_srid(geog public.geography) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
    AS $$
  SELECT _ST_BestSRID(geog)
$$;


ALTER FUNCTION internal_utils.determine_srid(geog public.geography) OWNER TO dbhasura;

--
-- Name: determine_srid(public.geography, public.geography); Type: FUNCTION; Schema: internal_utils; Owner: dbhasura
--

CREATE FUNCTION internal_utils.determine_srid(geog1 public.geography, geog2 public.geography) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
    AS $$
  SELECT _ST_BestSRID(geog1, geog2)
$$;


ALTER FUNCTION internal_utils.determine_srid(geog1 public.geography, geog2 public.geography) OWNER TO dbhasura;

--
-- Name: next_day(date); Type: FUNCTION; Schema: internal_utils; Owner: dbhasura
--

CREATE FUNCTION internal_utils.next_day(bound date) RETURNS date
    LANGUAGE sql IMMUTABLE PARALLEL SAFE
    AS $$
SELECT CASE WHEN bound IS NULL THEN NULL::date ELSE (bound + INTERVAL '1 day')::date END;
$$;


ALTER FUNCTION internal_utils.next_day(bound date) OWNER TO dbhasura;

--
-- Name: prev_day(date); Type: FUNCTION; Schema: internal_utils; Owner: dbhasura
--

CREATE FUNCTION internal_utils.prev_day(bound date) RETURNS date
    LANGUAGE sql IMMUTABLE PARALLEL SAFE
    AS $$
SELECT CASE WHEN bound IS NULL THEN NULL::date ELSE (bound - INTERVAL '1 day')::date END;
$$;


ALTER FUNCTION internal_utils.prev_day(bound date) OWNER TO dbhasura;

--
-- Name: prevent_update(); Type: FUNCTION; Schema: internal_utils; Owner: dbhasura
--

CREATE FUNCTION internal_utils.prevent_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  RAISE EXCEPTION 'update of table not allowed';
END;
$$;


ALTER FUNCTION internal_utils.prevent_update() OWNER TO dbhasura;

--
-- Name: st_closestpoint(public.geography, public.geography); Type: FUNCTION; Schema: internal_utils; Owner: dbhasura
--

CREATE FUNCTION internal_utils.st_closestpoint(a_linestring public.geography, a_point public.geography) RETURNS public.geography
    LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
    AS $$
WITH local_srid AS (
  SELECT internal_utils.determine_SRID(a_linestring, a_point) AS srid
)
SELECT
  ST_Transform(
    ST_ClosestPoint(
      ST_Transform(a_linestring::geometry, srid),
      ST_Transform(a_point::geometry, srid)
    ),
    ST_SRID(a_linestring::geometry)
  )::geography
FROM
  local_srid
$$;


ALTER FUNCTION internal_utils.st_closestpoint(a_linestring public.geography, a_point public.geography) OWNER TO dbhasura;

--
-- Name: st_lineinterpolatepoint(public.geography, double precision); Type: FUNCTION; Schema: internal_utils; Owner: dbhasura
--

CREATE FUNCTION internal_utils.st_lineinterpolatepoint(a_linestring public.geography, a_fraction double precision) RETURNS public.geography
    LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
    AS $$
  WITH local_srid AS (
    SELECT internal_utils.determine_SRID(a_linestring) AS srid
  )
  SELECT
    ST_Transform(
      ST_LineInterpolatePoint(
        ST_Transform(a_linestring::geometry, srid),
        a_fraction
      ),
      ST_SRID(a_linestring::geometry)
    )::geography
  FROM
    local_srid
$$;


ALTER FUNCTION internal_utils.st_lineinterpolatepoint(a_linestring public.geography, a_fraction double precision) OWNER TO dbhasura;

--
-- Name: st_linelocatepoint(public.geography, public.geography); Type: FUNCTION; Schema: internal_utils; Owner: dbhasura
--

CREATE FUNCTION internal_utils.st_linelocatepoint(a_linestring public.geography, a_point public.geography) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
    AS $$
  WITH local_srid AS (
    SELECT internal_utils.determine_SRID(a_linestring, a_point) AS srid
  )
  SELECT
    ST_LineLocatePoint(
      ST_Transform(a_linestring::geometry, srid),
      ST_Transform(a_point::geometry, srid)
    )
  FROM
    local_srid
$$;


ALTER FUNCTION internal_utils.st_linelocatepoint(a_linestring public.geography, a_point public.geography) OWNER TO dbhasura;

--
-- Name: check_infra_link_stop_refs_with_new_scheduled_stop_point(uuid, uuid, public.geography, text, text, date, date, integer); Type: FUNCTION; Schema: journey_pattern; Owner: dbhasura
--

CREATE FUNCTION journey_pattern.check_infra_link_stop_refs_with_new_scheduled_stop_point(replace_scheduled_stop_point_id uuid, new_located_on_infrastructure_link_id uuid, new_measured_location public.geography, new_direction text, new_label text, new_validity_start date, new_validity_end date, new_priority integer) RETURNS SETOF journey_pattern.journey_pattern
    LANGUAGE sql STABLE PARALLEL SAFE
    AS $$
WITH filter_route_ids AS (
  SELECT array_agg(DISTINCT r.route_id) AS arr
  FROM route.route r
         LEFT JOIN journey_pattern.journey_pattern jp ON jp.on_route_id = r.route_id
         LEFT JOIN journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
                   ON sspijp.journey_pattern_id = jp.journey_pattern_id
         LEFT JOIN service_pattern.scheduled_stop_point ssp
                   ON ssp.label = sspijp.scheduled_stop_point_label
       -- 1. the scheduled stop point instance to be inserted (defined by the new_... arguments) or
  WHERE ((sspijp.scheduled_stop_point_label = new_label AND
          internal_utils.daterange_closed_upper(r.validity_start, r.validity_end) &&
          internal_utils.daterange_closed_upper(new_validity_start, new_validity_end))
    -- 2. the scheduled stop point instance to be replaced (identified by the replace_scheduled_stop_point_id argument)
    OR (ssp.scheduled_stop_point_id = replace_scheduled_stop_point_id AND
        internal_utils.daterange_closed_upper(r.validity_start, r.validity_end) &&
        internal_utils.daterange_closed_upper(ssp.validity_start, ssp.validity_end)))
)
SELECT *
FROM journey_pattern.get_broken_route_journey_patterns(
  (SELECT arr FROM filter_route_ids),
  replace_scheduled_stop_point_id,
  new_located_on_infrastructure_link_id,
  new_measured_location,
  new_direction,
  new_label,
  new_validity_start,
  new_validity_end,
  new_priority
  );
$$;


ALTER FUNCTION journey_pattern.check_infra_link_stop_refs_with_new_scheduled_stop_point(replace_scheduled_stop_point_id uuid, new_located_on_infrastructure_link_id uuid, new_measured_location public.geography, new_direction text, new_label text, new_validity_start date, new_validity_end date, new_priority integer) OWNER TO dbhasura;

--
-- Name: create_verify_infra_link_stop_refs_queue_temp_table(); Type: FUNCTION; Schema: journey_pattern; Owner: dbhasura
--

CREATE FUNCTION journey_pattern.create_verify_infra_link_stop_refs_queue_temp_table() RETURNS void
    LANGUAGE sql PARALLEL SAFE
    AS $$
  CREATE TEMP TABLE IF NOT EXISTS updated_route
  (
    route_id UUID UNIQUE
  )
    ON COMMIT DELETE ROWS;
  $$;


ALTER FUNCTION journey_pattern.create_verify_infra_link_stop_refs_queue_temp_table() OWNER TO dbhasura;

--
-- Name: get_broken_route_check_filters(uuid[]); Type: FUNCTION; Schema: journey_pattern; Owner: dbhasura
--

CREATE FUNCTION journey_pattern.get_broken_route_check_filters(filter_route_ids uuid[]) RETURNS TABLE(labels text[], validity_start date, validity_end date)
    LANGUAGE sql STABLE PARALLEL SAFE
    AS $$
WITH RECURSIVE
  route_param AS (
    SELECT label,
           internal_utils.daterange_closed_upper(r.validity_start, r.validity_end) AS validity_range,
           row_number() OVER (ORDER BY r.validity_start)                           AS ord
    FROM route.route r
    WHERE r.route_id = ANY (filter_route_ids)
  ),
  -- Merge the route ranges to be checked into one. In common use cases, there should not be any (significant)
  -- gaps between the ranges, but with future versions of postgresql it will be possible and might be good to change
  -- this to use tsmultirange instead of merging the ranges.
  merged_route_range AS (
    SELECT validity_range, ord
    FROM route_param
    WHERE ord = 1
    UNION ALL
    SELECT range_merge(prev.validity_range, cur.validity_range), cur.ord
    FROM merged_route_range prev
           JOIN route_param cur ON cur.ord = prev.ord + 1
  )
  -- gather the array of route labels to check and the merged route validity range
SELECT (SELECT array_agg(DISTINCT label) FROM route_param) AS labels,
       lower(validity_range)                               AS validity_start,
       -- since the upper bound was extended by the internal_utils.daterange_closed_upper function above, we need
       -- to subtract the extended day here again
       internal_utils.date_closed_upper(validity_range) AS validity_end
FROM merged_route_range
WHERE ord = (SELECT max(ord) FROM merged_route_range);
$$;


ALTER FUNCTION journey_pattern.get_broken_route_check_filters(filter_route_ids uuid[]) OWNER TO dbhasura;

--
-- Name: get_broken_route_journey_patterns(uuid[], uuid, uuid, public.geography, text, text, date, date, integer); Type: FUNCTION; Schema: journey_pattern; Owner: dbhasura
--

CREATE FUNCTION journey_pattern.get_broken_route_journey_patterns(filter_route_ids uuid[], replace_scheduled_stop_point_id uuid DEFAULT NULL::uuid, new_located_on_infrastructure_link_id uuid DEFAULT NULL::uuid, new_measured_location public.geography DEFAULT NULL::public.geography, new_direction text DEFAULT NULL::text, new_label text DEFAULT NULL::text, new_validity_start date DEFAULT NULL::date, new_validity_end date DEFAULT NULL::date, new_priority integer DEFAULT NULL::integer) RETURNS SETOF journey_pattern.journey_pattern
    LANGUAGE sql STABLE PARALLEL SAFE
    AS $$
WITH RECURSIVE
  new_ssp_param AS (
    SELECT CASE WHEN new_located_on_infrastructure_link_id IS NOT NULL THEN gen_random_uuid() END
             AS new_scheduled_stop_point_id
  ),
  filter_route AS (
    SELECT labels, validity_start, validity_end
    FROM journey_pattern.get_broken_route_check_filters(filter_route_ids)
  ),
  -- fetch the route entities with their prioritized validity times
  prioritized_route AS (
    SELECT r.route_id,
           r.label,
           r.direction,
           r.priority,
           priority_validity_spans.validity_start,
           priority_validity_spans.validity_end
    FROM route.route r
           JOIN journey_pattern.maximum_priority_validity_spans(
      'route',
      (SELECT labels FROM filter_route),
      (SELECT validity_start FROM filter_route),
      (SELECT validity_end FROM filter_route),
      internal_utils.const_priority_draft()
      ) priority_validity_spans
                ON priority_validity_spans.id = r.route_id
  ),
  ssp_with_new AS (
      SELECT * FROM service_pattern.scheduled_stop_points_with_infra_link_data ssp
        WHERE replace_scheduled_stop_point_id IS DISTINCT FROM ssp.scheduled_stop_point_id
      UNION ALL
        SELECT * FROM service_pattern.new_scheduled_stop_point_if_id_given(
          (SELECT new_scheduled_stop_point_id FROM new_ssp_param),
          new_located_on_infrastructure_link_id,
          new_measured_location,
          new_direction,
          new_label,
          new_validity_start,
          new_validity_end,
          new_priority
      )
  ),
  priority_validity_spans AS (
    SELECT * FROM journey_pattern.maximum_priority_validity_spans(
      'scheduled_stop_point',
      (SELECT labels FROM filter_route),
      (SELECT validity_start FROM filter_route),
      (SELECT validity_end FROM filter_route),
      internal_utils.const_priority_draft(),
      replace_scheduled_stop_point_id,
      (SELECT new_scheduled_stop_point_id FROM new_ssp_param),
      new_located_on_infrastructure_link_id,
      new_measured_location,
      new_direction,
      new_label,
      new_validity_start,
      new_validity_end,
      new_priority
    )
  ),
  -- fetch the stop point entities with their prioritized validity times
  prioritized_ssp_with_new AS (
    SELECT prioritized_ssp.scheduled_stop_point_id,
           prioritized_ssp.located_on_infrastructure_link_id,
           prioritized_ssp.measured_location,
           prioritized_ssp.relative_distance_from_infrastructure_link_start,
           prioritized_ssp.direction,
           prioritized_ssp.label,
           prioritized_ssp.priority,
           prioritized_ssp.priority_span_validity_start,
           prioritized_ssp.priority_span_validity_end
    FROM (
      SELECT
        ssp.*,
           priority_validity_spans.validity_start AS priority_span_validity_start,
           priority_validity_spans.validity_end AS priority_span_validity_end
        FROM service_pattern.scheduled_stop_points_with_infra_link_data ssp
        JOIN priority_validity_spans ON priority_validity_spans.id = ssp.scheduled_stop_point_id
        WHERE replace_scheduled_stop_point_id IS DISTINCT FROM ssp.scheduled_stop_point_id
      -- Safe to use UNION ALL here rather than plain UNION since the following row does not exist in previous SELECT result.
      -- Also faster since no sorting associated with plain UNION is needed.
      UNION ALL
        SELECT
           ssp.*,
           priority_validity_spans.validity_start AS priority_span_validity_start,
           priority_validity_spans.validity_end AS priority_span_validity_end
        FROM service_pattern.new_scheduled_stop_point_if_id_given(
          (SELECT new_scheduled_stop_point_id FROM new_ssp_param),
          new_located_on_infrastructure_link_id,
          new_measured_location,
          new_direction,
          new_label,
          new_validity_start,
          new_validity_end,
          new_priority
      ) ssp
      JOIN priority_validity_spans ON priority_validity_spans.id = ssp.scheduled_stop_point_id
    ) prioritized_ssp
  ),
  -- For all stops in the journey patterns, list all visits of the stop's infra link. (But only include
  -- visits happening in a direction matching the stop's allowed directions - if the direction is wrong,
  -- we cannot approach the stop point on that particular link visit. Similarly, include only those stop
  -- instances, whose validity period overlaps with the route's priority span's validity period.)
  sspijp_ilar_combos AS (
    -- DISTINCT because in some cases the JOINs below might produce duplicate rows.
    -- Seems to be caused by at least prioritized_route having many rows for same route, with different validity periods though.
    -- This can happen at least when there are multiple routes with same label (but different unique label) and their validity times overlap.
    -- Eliminate those duplicates: they would cause severe performance issues in the following recursive CTE.
    SELECT DISTINCT
           sspijp.journey_pattern_id,
           ssp.scheduled_stop_point_id,
           sspijp.scheduled_stop_point_sequence,
           sspijp.stop_point_order,
           ssp.relative_distance_from_infrastructure_link_start,
           ilar.route_id,
           ilar.infrastructure_link_id,
           ilar.infrastructure_link_sequence,
           ilar.is_traversal_forwards
    FROM (
           SELECT r.route_id,
                  jp.journey_pattern_id,
                  sspijp.scheduled_stop_point_label,
                  sspijp.scheduled_stop_point_sequence,
                  -- Create a continuous sequence number of the scheduled_stop_point_sequence (which is not
                  -- required to be continuous, i.e. there can be gaps).
                  -- Note that the sequence number is assigned for the whole journey pattern, not for individual
                  -- route validity spans. This means that the route verification is performed for all stops in the
                  -- journey pattern at once, i.e. it is intentionally not possible to have a stop order in one route
                  -- validity span that is in conflict with the stop order in another route validity span. This is to
                  -- prevent situations in which it would be impossible to remove a higher priority route due to the
                  -- adjacent lower priority route spans having incompatible stop orders.
                  ROW_NUMBER()
                  OVER (PARTITION BY sspijp.journey_pattern_id ORDER BY sspijp.scheduled_stop_point_sequence) AS stop_point_order
           FROM route.route r
                  JOIN journey_pattern.journey_pattern jp ON jp.on_route_id = r.route_id
                  JOIN journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
                       ON sspijp.journey_pattern_id = jp.journey_pattern_id
           WHERE r.route_id = ANY (filter_route_ids)
         ) AS sspijp
           JOIN prioritized_ssp_with_new ssp
                ON ssp.label = sspijp.scheduled_stop_point_label
           JOIN prioritized_route r
                ON r.route_id = sspijp.route_id
                  -- scheduled stop point instances, whose validity period does not overlap with the
                  -- route's validity period, are filtered out here
                  AND internal_utils.daterange_closed_upper(ssp.priority_span_validity_start, ssp.priority_span_validity_end) &&
                      internal_utils.daterange_closed_upper(r.validity_start, r.validity_end)
           JOIN route.infrastructure_link_along_route ilar
                ON ilar.route_id = r.route_id
                  AND ilar.infrastructure_link_id = ssp.located_on_infrastructure_link_id
                  -- visits of the link in a direction not matching the stop's possible directions are
                  -- filtered out here
                  AND (ssp.direction = 'bidirectional' OR
                       ((ssp.direction = 'forward' AND ilar.is_traversal_forwards = true)
                         OR (ssp.direction = 'backward' AND ilar.is_traversal_forwards = false)))
  ),
  -- Iteratively try to traverse the journey patterns in their specified order one stop point at a time, such
  -- that all visited links appear in ascending order on each journey pattern's route.
  -- Note that this CTE will contain more rows than only the ones depicting actual traversals. To find
  -- actual possible traversals, choose the row with min(infrastructure_link_sequence) for every listed stop
  -- visit, as done below.
  traversal AS (
    SELECT *
    FROM sspijp_ilar_combos
    WHERE stop_point_order = 1
    UNION ALL
    SELECT sspijp_ilar_combos.*
    FROM traversal
           JOIN sspijp_ilar_combos ON sspijp_ilar_combos.journey_pattern_id = traversal.journey_pattern_id
         -- select the next stop
    WHERE sspijp_ilar_combos.stop_point_order = traversal.stop_point_order + 1
      -- Only allow visiting the route links in ascending route link order. If two stops are on the same
      -- link, check that they are traversed in accordance with their location on the link.
      AND (sspijp_ilar_combos.infrastructure_link_sequence > traversal.infrastructure_link_sequence
      OR (sspijp_ilar_combos.infrastructure_link_sequence = traversal.infrastructure_link_sequence
        AND ((sspijp_ilar_combos.is_traversal_forwards AND
              sspijp_ilar_combos.relative_distance_from_infrastructure_link_start >=
              traversal.relative_distance_from_infrastructure_link_start)
          OR (NOT sspijp_ilar_combos.is_traversal_forwards AND
              sspijp_ilar_combos.relative_distance_from_infrastructure_link_start <=
              traversal.relative_distance_from_infrastructure_link_start)
            )
             )
      )
  ),
  -- List all stops of the journey pattern and left-join their visits in the traversal performed above.
  infra_link_seq AS (
    SELECT route_id,
           infrastructure_link_sequence,
           -- also order by scheduled_stop_point_id to get a deterministic order between stops with the same
           -- label
           ROW_NUMBER() OVER (
             PARTITION BY journey_pattern_id
             ORDER BY
               stop_point_order,
               infrastructure_link_sequence,
               CASE
                 WHEN is_traversal_forwards THEN relative_distance_from_infrastructure_link_start
                 ELSE -relative_distance_from_infrastructure_link_start END,
               scheduled_stop_point_id)
             AS stop_point_order,
           ROW_NUMBER() OVER (
             PARTITION BY journey_pattern_id
             ORDER BY
               infrastructure_link_sequence,
               CASE
                 WHEN is_traversal_forwards THEN relative_distance_from_infrastructure_link_start
                 ELSE -relative_distance_from_infrastructure_link_start END,
               stop_point_order,
               scheduled_stop_point_id)
             AS infra_link_order
    FROM (
           SELECT t.journey_pattern_id,
                  t.stop_point_order,
                  t.infrastructure_link_sequence,
                  t.is_traversal_forwards,
                  t.relative_distance_from_infrastructure_link_start,
                  t.scheduled_stop_point_id,
                  ROW_NUMBER() OVER (
                    PARTITION BY sspijp.journey_pattern_id, ssp.scheduled_stop_point_id, r.route_id, infrastructure_link_id, stop_point_order
                    ORDER BY infrastructure_link_sequence
                  ) AS order_by_min,
                  r.route_id,
                  ssp.scheduled_stop_point_id IS NOT NULL AS ssp_match,
                  -- if there is no matching stop point within the validity span in question, check if there is a
                  -- matching ssp at all on the entire route
                  (ssp.scheduled_stop_point_id IS NULL
                    AND NOT EXISTS(
                      SELECT 1
                      FROM route.route full_route
                             JOIN ssp_with_new any_ssp ON any_ssp.label = sspijp.scheduled_stop_point_label
                      WHERE full_route.route_id = jp.on_route_id
                        AND internal_utils.daterange_closed_upper(full_route.validity_start, full_route.validity_end) &&
                            internal_utils.daterange_closed_upper(any_ssp.validity_start, any_ssp.validity_end)
                      )
                    )                                     AS is_ghost_ssp
           FROM prioritized_route r
                  JOIN journey_pattern.journey_pattern jp ON jp.on_route_id = r.route_id
                  JOIN journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
                       ON sspijp.journey_pattern_id = jp.journey_pattern_id
                  LEFT JOIN prioritized_ssp_with_new ssp -- left join to be able to find the ghost ssp
                            ON ssp.label = sspijp.scheduled_stop_point_label
                              AND internal_utils.daterange_closed_upper(ssp.priority_span_validity_start, ssp.priority_span_validity_end) &&
                                  internal_utils.daterange_closed_upper(r.validity_start, r.validity_end)
                  LEFT JOIN traversal t
                            ON t.journey_pattern_id = sspijp.journey_pattern_id
                              AND t.scheduled_stop_point_id = ssp.scheduled_stop_point_id
                              AND t.scheduled_stop_point_sequence = sspijp.scheduled_stop_point_sequence
           WHERE r.route_id = ANY (filter_route_ids)
         ) AS ordered_sspijp_ilar_combos
    WHERE (ordered_sspijp_ilar_combos.order_by_min = 1 AND ssp_match)
       OR is_ghost_ssp -- by keeping the ghost ssp lines, we will trigger an exception if any are present
  )
  -- Perform the final route integrity check:
  -- 1. In case no visit is present for any row (infrastructure_link_sequence is null), it was not possible to
  --    visit all stops in a way matching the route's link order.
  -- 2. In case the order of the stops' infra link visits is not the same as the stop order for all stops, this
  --    means that there are stops with the same ordinal number (same label), which have to be visited in a
  --    different order to cover all stops. This in turn means that the stops subsequent to these exceptions cannot
  --    be reached via all combinations of stops.
SELECT jp.*
FROM journey_pattern.journey_pattern jp
WHERE EXISTS(
        SELECT 1
        FROM infra_link_seq ils
        WHERE ils.route_id = jp.on_route_id
          AND (ils.infrastructure_link_sequence IS NULL -- this is also true for any ghost ssp occurrence
          OR ils.stop_point_order != ils.infra_link_order)
        );
$$;


ALTER FUNCTION journey_pattern.get_broken_route_journey_patterns(filter_route_ids uuid[], replace_scheduled_stop_point_id uuid, new_located_on_infrastructure_link_id uuid, new_measured_location public.geography, new_direction text, new_label text, new_validity_start date, new_validity_end date, new_priority integer) OWNER TO dbhasura;

--
-- Name: infra_link_stop_refs_already_verified(); Type: FUNCTION; Schema: journey_pattern; Owner: dbhasura
--

CREATE FUNCTION journey_pattern.infra_link_stop_refs_already_verified() RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
  infra_link_stop_refs_already_verified BOOLEAN;
BEGIN
  infra_link_stop_refs_already_verified := NULLIF(current_setting('journey_pattern_vars.infra_link_stop_refs_already_verified', TRUE), '');
  IF infra_link_stop_refs_already_verified IS TRUE THEN
    RETURN TRUE;
  ELSE
    SET LOCAL journey_pattern_vars.infra_link_stop_refs_already_verified = TRUE;
    RETURN FALSE;
  END IF;
END
$$;


ALTER FUNCTION journey_pattern.infra_link_stop_refs_already_verified() OWNER TO dbhasura;

--
-- Name: maximum_priority_validity_spans(text, text[], date, date, integer, uuid, uuid, uuid, public.geography, text, text, date, date, integer); Type: FUNCTION; Schema: journey_pattern; Owner: dbhasura
--

CREATE FUNCTION journey_pattern.maximum_priority_validity_spans(entity_type text, filter_route_labels text[], filter_validity_start date DEFAULT NULL::date, filter_validity_end date DEFAULT NULL::date, upper_priority_limit integer DEFAULT NULL::integer, replace_scheduled_stop_point_id uuid DEFAULT NULL::uuid, new_scheduled_stop_point_id uuid DEFAULT NULL::uuid, new_located_on_infrastructure_link_id uuid DEFAULT NULL::uuid, new_measured_location public.geography DEFAULT NULL::public.geography, new_direction text DEFAULT NULL::text, new_label text DEFAULT NULL::text, new_validity_start date DEFAULT NULL::date, new_validity_end date DEFAULT NULL::date, new_priority integer DEFAULT NULL::integer) RETURNS TABLE(id uuid, validity_start date, validity_end date)
    LANGUAGE sql STABLE PARALLEL SAFE
    AS $$
WITH RECURSIVE
  -- collect the entities matching the given parameters
  -- e.g.
  -- id, validity_start, validity_end, key, prio
  ----------------------------------------------
  --  1,     2020-01-01,   2025-01-01,   A,   10
  --  2,     2022-01-01,   2027-01-01,   A,   20
  entity AS (
    SELECT r.route_id AS id, r.validity_start, r.validity_end, r.label AS key1, r.direction AS key2, r.priority
    FROM route.route r
    WHERE entity_type = 'route'
      AND internal_utils.daterange_closed_upper(r.validity_start, r.validity_end) &&
          internal_utils.daterange_closed_upper(filter_validity_start, filter_validity_end)
      AND (r.label = ANY (filter_route_labels) OR filter_route_labels IS NULL)
      AND (r.priority < upper_priority_limit OR upper_priority_limit IS NULL)
    UNION ALL
    SELECT ssp.scheduled_stop_point_id AS id,
           ssp.validity_start,
           ssp.validity_end,
           ssp.label                   AS key1,
           NULL                        AS key2,
           ssp.priority
    FROM (
      SELECT * FROM service_pattern.scheduled_stop_points_with_infra_link_data ssp
        WHERE replace_scheduled_stop_point_id IS DISTINCT FROM ssp.scheduled_stop_point_id
      UNION ALL
        SELECT * FROM service_pattern.new_scheduled_stop_point_if_id_given(
          new_scheduled_stop_point_id,
          new_located_on_infrastructure_link_id,
          new_measured_location,
          new_direction,
          new_label,
          new_validity_start,
          new_validity_end,
          new_priority
      )
    ) AS ssp
    WHERE entity_type = 'scheduled_stop_point'
      AND internal_utils.daterange_closed_upper(ssp.validity_start, ssp.validity_end) &&
          internal_utils.daterange_closed_upper(filter_validity_start, filter_validity_end)
      AND (ssp.priority < upper_priority_limit OR upper_priority_limit IS NULL)
      AND (EXISTS(
             SELECT 1
             FROM journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
                    JOIN journey_pattern.journey_pattern jp ON jp.journey_pattern_id = sspijp.journey_pattern_id
                    JOIN route.route r
                         ON r.route_id = jp.on_route_id
                           AND r.label = ANY (filter_route_labels)
             WHERE sspijp.scheduled_stop_point_label = ssp.label
             ) OR filter_route_labels IS NULL)
  ),
  -- form the list of potential validity span boundaries
  -- e.g.
  -- id, validity_start, is_start, key, prio
  ------------------------------------------
  --  1,     2020-01-01,     true,   A,   10
  --  1,     2025-01-01,    false,   A,   10
  --  2,     2022-01-01,     true,   A,   20
  --  2,     2027-01-01,    false,   A,   20
  boundary AS (
    SELECT e.validity_start, TRUE AS is_start, e.key1, e.key2, e.priority
    FROM entity e
    UNION ALL
    SELECT internal_utils.next_day(e.validity_end), FALSE AS is_start, e.key1, e.key2, e.priority
    FROM entity e
  ),
  -- Order the list both ascending and descending, because it has to be traversed both ways below. By traversing the
  -- list in both directions, we can find the validity span boundaries with highest priority without using fifos or
  -- similar.
  -- e.g.
  -- id, validity_start, is_start, key, prio, start_order, end_order
  ------------------------------------------------------------------
  --  1,     2020-01-01,     true,   A,   10,           1,         4
  --  2,     2022-01-01,     true,   A,   20,           2,         3
  --  1,     2025-01-01,    false,   A,   10,           3,         2
  --  2,     2027-01-01,    false,   A,   20,           4,         1
  ordered_boundary AS (
    SELECT *,
           -- The "validity_start IS NULL" cases have to be interpreted together with "is_start". Depending on the latter value,
           -- "validity_start IS NULL" can mean "negative inf" or "positive inf"
           row_number()
           OVER (PARTITION BY key1, key2 ORDER BY is_start AND validity_start IS NULL DESC, validity_start ASC)      AS start_order,
           row_number()
           OVER (PARTITION BY key1, key2 ORDER BY NOT is_start AND validity_start IS NULL DESC, validity_start DESC) AS end_order
    FROM boundary
  ),
  -- mark the minimum priority for each row, at which a start validity boundary is relevant (i.e. not overlapped by a higher priority),
  -- traverse the list of boundaries from start to end
  -- e.g.
  -- id, validity_start, is_start, key, prio, start_order, end_order, cur_start_priority
  --------------------------------------------------------------------------------------
  --  1,     2020-01-01,     true,   A,   10,           1,         4,                 10
  --  2,     2022-01-01,     true,   A,   20,           2,         3,                 20
  --  1,     2025-01-01,    false,   A,   10,           3,         2,                 20
  --  2,     2027-01-01,    false,   A,   20,           4,         1,                  0
  marked_min_start_priority AS (
    SELECT *, priority AS cur_start_priority
    FROM ordered_boundary
    WHERE start_order = 1
    UNION ALL
    SELECT next_boundary.*,
           CASE
             -- if the boundary marks the beginning of a validity span and the span's priority is higher than the
             -- previously marked priority, this span is valid from now on
             WHEN next_boundary.is_start AND next_boundary.priority > cur_start_priority THEN next_boundary.priority
             -- if the boundary marks the end of a validity span and the span's priority is higher or equal than the
             -- previously marked priority, the currently valid span is ending and any span starting further down may
             -- potentially be the new valid one
             WHEN NOT next_boundary.is_start AND next_boundary.priority >= cur_start_priority THEN 0
             -- otherwise, any previously discovered validity span stays valid
             ELSE cur_start_priority
             END AS cur_start_priority
    FROM marked_min_start_priority marked
           JOIN ordered_boundary next_boundary
                ON next_boundary.start_order = marked.start_order + 1 AND next_boundary.key1 = marked.key1 AND
                   (next_boundary.key2 = marked.key2 OR next_boundary.key2 IS NULL)
  ),
  -- mark the minimum priority for each row, at which an end validity boundary is relevant (i.e. not overlapped by a higher priority),
  -- traverse the list of boundaries from end to start
  -- e.g.
  -- id, validity_start, is_start, key, prio, start_order, end_order, cur_start_priority, cur_end_priority
  --------------------------------------------------------------------------------------------------------
  --  2,     2027-01-01,    false,   A,   20,           4,         1,                  0,               20
  --  1,     2025-01-01,    false,   A,   10,           3,         2,                 20,               20
  --  2,     2022-01-01,     true,   A,   20,           2,         3,                 20,                0
  --  1,     2020-01-01,     true,   A,   10,           1,         4,                 10,               10
  marked_min_start_end_priority AS (
    SELECT *, priority AS cur_end_priority
    FROM marked_min_start_priority
    WHERE end_order = 1
    UNION ALL
    SELECT next_boundary.*,
           CASE
             -- if the boundary marks the end of a validity span and the span's priority is higher than the
             -- previously marked priority, this span is valid from now on
             WHEN NOT next_boundary.is_start AND next_boundary.priority > cur_end_priority THEN next_boundary.priority
             -- if the boundary marks the start of a validity span and the span's priority is higher or equal than the
             -- previously marked priority, the currently valid span is ending and any span ending further down may
             -- potentially be the new valid one
             WHEN next_boundary.is_start AND next_boundary.priority >= cur_end_priority THEN 0
             -- otherwise, any previously discovered validity span stays valid
             ELSE cur_end_priority
             END AS cur_end_priority
    FROM marked_min_start_end_priority marked
           JOIN marked_min_start_priority next_boundary
                ON next_boundary.end_order = marked.end_order + 1 AND next_boundary.key1 = marked.key1 AND
                   (next_boundary.key2 = marked.key2 OR next_boundary.key2 IS NULL)
  ),
  -- filter only the highest priority boundaries and connect them to form validity spans (with both start and end)
  -- e.g.
  -- key, has_next, validity_start, validity_end
  ----------------------------------------------
  --   A,     true,     2020-01-01,   2022-01-01
  --   A,     true,     2022-01-01,   2027-01-01
  -----A,-----true,-----2025-01-01,--------------- (removed by WHERE clause)
  --   A,    false,     2027-01-01,         null
  reduced_boundary AS (
    SELECT key1,
           key2,
           -- The last row will have has_next = FALSE. This is needed because we cannot rely on validity_end being NULL
           -- in ONLY the last row, since NULL in timestamps depicts infinity.
           lead(TRUE, 1, FALSE) OVER entity_window AS has_next,
           validity_start,
           lead(internal_utils.prev_day(validity_start)) OVER entity_window AS validity_end
    FROM marked_min_start_end_priority
    WHERE priority >= cur_end_priority
      AND priority >= cur_start_priority
    WINDOW entity_window AS (PARTITION BY key1, key2 ORDER BY start_order)
  ),
  -- find the instances which are valid in the validity spans
  -- e.g.
  -- key, has_next, validity_start, validity_end, id, priority
  ------------------------------------------------------------
  --   A,     true,     2020-01-01,   2022-01-01,  1,       10
  --   A,     true,     2022-01-01,   2027-01-01,  1,       10
  --   A,     true,     2022-01-01,   2027-01-01,  2,       20
  -----A,----false,-----2027-01-01,---------null,--------------- (removed by WHERE clause)
  boundary_with_entities AS (
    SELECT rb.key1, rb.key2, rb.has_next, rb.validity_start, rb.validity_end, e.id, e.priority
    FROM reduced_boundary rb
           JOIN entity e ON e.key1 = rb.key1 AND (e.key2 = rb.key2 OR e.key2 IS NULL) AND
                            internal_utils.daterange_closed_upper(e.validity_start, e.validity_end) &&
                            internal_utils.daterange_closed_upper(rb.validity_start, rb.validity_end)
    WHERE rb.has_next
  )
SELECT id, validity_start, validity_end
FROM (SELECT id,
             validity_start,
             validity_end,
             priority,
             max(priority) OVER (PARTITION BY key1, key2, validity_start) AS max_priority
      FROM boundary_with_entities) bwe
WHERE priority = max_priority
$$;


ALTER FUNCTION journey_pattern.maximum_priority_validity_spans(entity_type text, filter_route_labels text[], filter_validity_start date, filter_validity_end date, upper_priority_limit integer, replace_scheduled_stop_point_id uuid, new_scheduled_stop_point_id uuid, new_located_on_infrastructure_link_id uuid, new_measured_location public.geography, new_direction text, new_label text, new_validity_start date, new_validity_end date, new_priority integer) OWNER TO dbhasura;

--
-- Name: queue_verify_infra_link_stop_refs_by_new_journey_pattern_id(); Type: FUNCTION; Schema: journey_pattern; Owner: dbhasura
--

CREATE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_journey_pattern_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- RAISE NOTICE 'journey_pattern.queue_verify_infra_link_stop_refs_by_new_journey_pattern_id()';

  PERFORM journey_pattern.create_verify_infra_link_stop_refs_queue_temp_table();

  INSERT INTO updated_route (route_id)
  SELECT r.route_id
  FROM new_table
         JOIN journey_pattern.journey_pattern jp ON jp.journey_pattern_id = new_table.journey_pattern_id
         JOIN route.route r ON r.route_id = jp.on_route_id
  ON CONFLICT DO NOTHING;

  RETURN NULL;
END;
$$;


ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_journey_pattern_id() OWNER TO dbhasura;

--
-- Name: queue_verify_infra_link_stop_refs_by_new_ssp_label(); Type: FUNCTION; Schema: journey_pattern; Owner: dbhasura
--

CREATE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_ssp_label() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- RAISE NOTICE 'journey_pattern.queue_verify_infra_link_stop_refs_by_new_ssp_label()';

  PERFORM journey_pattern.create_verify_infra_link_stop_refs_queue_temp_table();

  INSERT INTO updated_route (route_id)
  SELECT r.route_id
  FROM new_table
         JOIN route.route r ON EXISTS(
    SELECT 1
    FROM journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
           JOIN journey_pattern.journey_pattern jp ON jp.journey_pattern_id = sspijp.journey_pattern_id
    WHERE sspijp.scheduled_stop_point_label = new_table.label
      AND internal_utils.daterange_closed_upper(r.validity_start, r.validity_end) &&
          internal_utils.daterange_closed_upper(new_table.validity_start, new_table.validity_end)
      AND jp.on_route_id = r.route_id
    )
  ON CONFLICT DO NOTHING;

  RETURN NULL;
END;
$$;


ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_ssp_label() OWNER TO dbhasura;

--
-- Name: queue_verify_infra_link_stop_refs_by_old_route_id(); Type: FUNCTION; Schema: journey_pattern; Owner: dbhasura
--

CREATE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- RAISE NOTICE 'journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_id()';

  PERFORM journey_pattern.create_verify_infra_link_stop_refs_queue_temp_table();

  INSERT INTO updated_route (route_id)
  SELECT r.route_id
  FROM old_table
         JOIN route.route r ON r.route_id = old_table.route_id
  ON CONFLICT DO NOTHING;

  RETURN NULL;
END;
$$;


ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_id() OWNER TO dbhasura;

--
-- Name: queue_verify_infra_link_stop_refs_by_old_route_label(); Type: FUNCTION; Schema: journey_pattern; Owner: dbhasura
--

CREATE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_label() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- RAISE NOTICE 'journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_label()';

  PERFORM journey_pattern.create_verify_infra_link_stop_refs_queue_temp_table();

  INSERT INTO updated_route (route_id)
  SELECT route_id
  FROM old_table
  ON CONFLICT DO NOTHING;

  RETURN NULL;
END;
$$;


ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_label() OWNER TO dbhasura;

--
-- Name: queue_verify_infra_link_stop_refs_by_old_ssp_label(); Type: FUNCTION; Schema: journey_pattern; Owner: dbhasura
--

CREATE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_ssp_label() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- RAISE NOTICE 'journey_pattern.queue_verify_infra_link_stop_refs_by_old_ssp_label()';

  PERFORM journey_pattern.create_verify_infra_link_stop_refs_queue_temp_table();

  INSERT INTO updated_route (route_id)
  SELECT r.route_id
  FROM old_table
         JOIN route.route r ON EXISTS(
    SELECT 1
    FROM journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
           JOIN journey_pattern.journey_pattern jp ON jp.journey_pattern_id = sspijp.journey_pattern_id
    WHERE sspijp.scheduled_stop_point_label = old_table.label
      AND internal_utils.daterange_closed_upper(r.validity_start, r.validity_end) &&
          internal_utils.daterange_closed_upper(old_table.validity_start, old_table.validity_end)
      AND jp.on_route_id = r.route_id
    )
  ON CONFLICT DO NOTHING;

  RETURN NULL;
END;
$$;


ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_ssp_label() OWNER TO dbhasura;

--
-- Name: scheduled_stop_point_has_timing_place_if_used_as_timing_point(); Type: FUNCTION; Schema: journey_pattern; Owner: dbhasura
--

CREATE FUNCTION journey_pattern.scheduled_stop_point_has_timing_place_if_used_as_timing_point() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- RAISE NOTICE 'journey_pattern.scheduled_stop_point_has_timing_place_if_used_as_timing_point()';

  IF EXISTS(
    SELECT 1
      FROM journey_pattern.scheduled_stop_point_in_journey_pattern as sspijp
      JOIN service_pattern.scheduled_stop_point AS ssp ON sspijp.scheduled_stop_point_label = ssp.label
      WHERE ssp.timing_place_id IS NULL
        AND sspijp.is_used_as_timing_point = true
    )
  THEN
    RAISE EXCEPTION 'scheduled stop point must have a timing place attached if it is used as a timing point in a journey pattern';
  END IF;

  RETURN NULL;
END;
$$;


ALTER FUNCTION journey_pattern.scheduled_stop_point_has_timing_place_if_used_as_timing_point() OWNER TO dbhasura;

--
-- Name: truncate_scheduled_stop_point_in_journey_pattern(); Type: FUNCTION; Schema: journey_pattern; Owner: dbhasura
--

CREATE FUNCTION journey_pattern.truncate_scheduled_stop_point_in_journey_pattern() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  --RAISE NOTICE 'journey_pattern.truncate_scheduled_stop_point_in_journey_pattern()';

  IF (SELECT COUNT(*) FROM journey_pattern.scheduled_stop_point_in_journey_pattern) > 0 THEN
    RAISE WARNING 'TRUNCATING journey_pattern.scheduled_stop_point_in_journey_pattern to ensure data consistency';
    TRUNCATE journey_pattern.scheduled_stop_point_in_journey_pattern CASCADE;
  END IF;

  RETURN NULL;
END;
$$;


ALTER FUNCTION journey_pattern.truncate_scheduled_stop_point_in_journey_pattern() OWNER TO dbhasura;

--
-- Name: verify_infra_link_stop_refs(); Type: FUNCTION; Schema: journey_pattern; Owner: dbhasura
--

CREATE FUNCTION journey_pattern.verify_infra_link_stop_refs() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- RAISE NOTICE 'journey_pattern.verify_infra_link_stop_refs()';

  IF EXISTS(
    WITH filter_route_ids AS (
      SELECT array_agg(DISTINCT ur.route_id) AS arr
      FROM updated_route ur
    )
    SELECT 1
    FROM journey_pattern.get_broken_route_journey_patterns(
        (SELECT arr FROM filter_route_ids)
      )
      -- ensure there is something to be checked at all
    WHERE EXISTS(SELECT 1 FROM updated_route)
    )
  THEN
    RAISE EXCEPTION 'route''s and journey pattern''s traversal paths must match each other';
  END IF;

  RETURN NULL;
END;
$$;


ALTER FUNCTION journey_pattern.verify_infra_link_stop_refs() OWNER TO dbhasura;

--
-- Name: verify_route_journey_pattern_refs(uuid, uuid); Type: FUNCTION; Schema: journey_pattern; Owner: dbhasura
--

CREATE FUNCTION journey_pattern.verify_route_journey_pattern_refs(filter_journey_pattern_id uuid, filter_route_id uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NOT journey_pattern.check_route_journey_pattern_refs(
    filter_journey_pattern_id,
    filter_route_id
    )
  THEN
    RAISE EXCEPTION 'route''s and journey pattern''s traversal paths must match each other';
  END IF;
END;
$$;


ALTER FUNCTION journey_pattern.verify_route_journey_pattern_refs(filter_journey_pattern_id uuid, filter_route_id uuid) OWNER TO dbhasura;

--
-- Name: drop_constraints(text[]); Type: FUNCTION; Schema: public; Owner: dbhasura
--

CREATE FUNCTION public.drop_constraints(target_schemas text[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  constraint_record RECORD;
BEGIN
  FOR constraint_record IN (
    SELECT
      n.nspname as schema_name,
      t.relname as table_name,
      c.conname as constraint_name
    FROM pg_constraint c
      JOIN pg_class t on c.conrelid = t.oid
      JOIN pg_namespace n on t.relnamespace = n.oid
    WHERE
      -- c = check constraint, f = foreign key constraint, p = primary key constraint, u = unique constraint, t = constraint trigger, x = exclusion constraint
      c.contype IN ('c', 'u', 't', 'x') AND
      n.nspname = ANY(target_schemas)
  )
  LOOP
    RAISE NOTICE 'Dropping constraint: %.%.%', constraint_record.schema_name, constraint_record.table_name, constraint_record.constraint_name;
    EXECUTE 'ALTER TABLE ' || quote_ident(constraint_record.schema_name) || '.' || quote_ident(constraint_record.table_name) || ' DROP CONSTRAINT ' || quote_ident(constraint_record.constraint_name) || ';';
  END LOOP;
END;
$$;


ALTER FUNCTION public.drop_constraints(target_schemas text[]) OWNER TO dbhasura;

--
-- Name: drop_functions(text[]); Type: FUNCTION; Schema: public; Owner: dbhasura
--

CREATE FUNCTION public.drop_functions(target_schemas text[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  sql_command text;
BEGIN
  SELECT INTO sql_command
    string_agg(
      format('DROP %s %s;',
        CASE prokind
          WHEN 'f' THEN 'FUNCTION'
          WHEN 'a' THEN 'AGGREGATE'
          WHEN 'p' THEN 'PROCEDURE'
          WHEN 'w' THEN 'FUNCTION'
          ELSE NULL
        END,
        oid::regprocedure),
      E'\n')
  FROM pg_proc
  WHERE pronamespace = ANY(target_schemas::regnamespace[])
  AND provolatile NOT IN ('i');

  IF sql_command IS NOT NULL THEN
    EXECUTE sql_command;
  ELSE
    RAISE NOTICE 'No functions found';
  END IF;
END;
$$;


ALTER FUNCTION public.drop_functions(target_schemas text[]) OWNER TO dbhasura;

--
-- Name: drop_triggers(text[]); Type: FUNCTION; Schema: public; Owner: dbhasura
--

CREATE FUNCTION public.drop_triggers(target_schemas text[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  trigger_record RECORD;
BEGIN
  FOR trigger_record IN
    (
      -- CRUD triggers
      SELECT
        trigger_schema AS schema_name,
        event_object_table AS table_name,
        trigger_name
      FROM information_schema.triggers
      WHERE
        trigger_schema = ANY(target_schemas)
    UNION (
      -- TRUNCATE triggers
      SELECT
        n.nspname as schema_name,
        c.relname as table_name,
        t.tgname AS trigger_name
      FROM pg_trigger t
        JOIN pg_class c on t.tgrelid = c.oid
        JOIN pg_namespace n on c.relnamespace = n.oid
      WHERE
        t.tgtype = 32 AND -- TRUNCATE triggers only
        n.nspname = ANY(target_schemas)
    )
  )
  LOOP
    -- note: if the same trigger function is executed e.g. both on INSERT and UPDATE, there are two rows with the same trigger name
    -- This results in the DROP command being executed twice below, thus we use IF EXISTS here
    RAISE NOTICE 'Dropping trigger: %.%.%', trigger_record.schema_name, trigger_record.table_name, trigger_record.trigger_name;
    EXECUTE 'DROP TRIGGER IF EXISTS ' || quote_ident(trigger_record.trigger_name) || ' ON ' || quote_ident(trigger_record.schema_name) || '.' || quote_ident(trigger_record.table_name) || ';';
  END LOOP;
END;
$$;


ALTER FUNCTION public.drop_triggers(target_schemas text[]) OWNER TO dbhasura;

--
-- Name: check_line_routes_priorities(); Type: FUNCTION; Schema: route; Owner: dbhasura
--

CREATE FUNCTION route.check_line_routes_priorities() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS(
    SELECT 1
    FROM route.line
    JOIN route.route ON route.route.on_line_id = route.line.line_id
    WHERE route.line.line_id = NEW.line_id
    AND route.line.priority > route.route.priority
  )
  THEN
    RAISE EXCEPTION 'route priority must be >= line priority';
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION route.check_line_routes_priorities() OWNER TO dbhasura;

--
-- Name: check_line_validity_against_all_associated_routes(); Type: FUNCTION; Schema: route; Owner: dbhasura
--

CREATE FUNCTION route.check_line_validity_against_all_associated_routes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS(
    SELECT 1
    FROM route.route r
    WHERE r.on_line_id = NEW.line_id
      AND ((NEW.validity_start IS NOT NULL AND (NEW.validity_start > r.validity_start OR r.validity_start IS NULL)) OR
           (NEW.validity_end IS NOT NULL AND (NEW.validity_end < r.validity_end OR r.validity_end IS NULL)))
    )
  THEN
    RAISE EXCEPTION 'line validity period must span all its routes'' validity periods';
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION route.check_line_validity_against_all_associated_routes() OWNER TO dbhasura;

--
-- Name: check_route_line_priorities(); Type: FUNCTION; Schema: route; Owner: dbhasura
--

CREATE FUNCTION route.check_route_line_priorities() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  line_prio INT;
BEGIN
  SELECT route.line.priority
  FROM route.line
  INTO line_prio
  WHERE route.line.line_id = NEW.on_line_id;

  IF NEW.priority < line_prio
  THEN
    RAISE EXCEPTION 'route priority must be >= line priority';
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION route.check_route_line_priorities() OWNER TO dbhasura;

--
-- Name: check_route_link_infrastructure_link_direction(); Type: FUNCTION; Schema: route; Owner: dbhasura
--

CREATE FUNCTION route.check_route_link_infrastructure_link_direction() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  link_dir TEXT;
BEGIN
  SELECT infrastructure_network.infrastructure_link.direction
  FROM infrastructure_network.infrastructure_link
  INTO link_dir WHERE infrastructure_network.infrastructure_link.
  infrastructure_link_id = NEW.infrastructure_link_id;

  -- NB: link_dir = 'bidirectional' allows both traversal directions
  IF (NEW.is_traversal_forwards = TRUE AND link_dir = 'backward') OR
     (NEW.is_traversal_forwards = FALSE AND link_dir = 'forward')
  THEN
    RAISE EXCEPTION 'route link direction must be compatible with infrastructure link direction';
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION route.check_route_link_infrastructure_link_direction() OWNER TO dbhasura;

--
-- Name: check_route_validity_is_within_line_validity(); Type: FUNCTION; Schema: route; Owner: dbhasura
--

CREATE FUNCTION route.check_route_validity_is_within_line_validity() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  line_validity_start date;
  line_validity_end   date;
BEGIN
  SELECT l.validity_start, l.validity_end
  FROM route.line l
  INTO line_validity_start, line_validity_end
    WHERE l.line_id = NEW.on_line_id;

  IF (line_validity_start IS NOT NULL AND (NEW.validity_start < line_validity_start OR NEW.validity_start IS NULL)) OR
     (line_validity_end IS NOT NULL AND (NEW.validity_end > line_validity_end OR NEW.validity_end IS NULL))
  THEN
    RAISE EXCEPTION 'route validity period must lie within its line''s validity period';
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION route.check_route_validity_is_within_line_validity() OWNER TO dbhasura;

--
-- Name: check_type_of_line_vehicle_mode(); Type: FUNCTION; Schema: route; Owner: dbhasura
--

CREATE FUNCTION route.check_type_of_line_vehicle_mode() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NOT EXISTS(
    SELECT 1
    FROM route.line
           JOIN route.type_of_line
                ON route.type_of_line.type_of_line = NEW.type_of_line
    WHERE route.type_of_line.belonging_to_vehicle_mode = NEW.primary_vehicle_mode
    )
  THEN
    RAISE EXCEPTION 'type of line must match lines primary vehicle mode';
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION route.check_type_of_line_vehicle_mode() OWNER TO dbhasura;

--
-- Name: route_shape(route.route); Type: FUNCTION; Schema: route; Owner: dbhasura
--

CREATE FUNCTION route.route_shape(route_row route.route) RETURNS public.geography
    LANGUAGE sql STABLE
    AS $$
  SELECT
    ST_MakeLine(
      CASE
        WHEN ilar.is_traversal_forwards THEN il.shape::geometry
        ELSE ST_Reverse(il.shape::geometry)
      END
        ORDER BY ilar.infrastructure_link_sequence
    )::geography AS route_shape
  FROM
    route.route r
      LEFT JOIN (
      route.infrastructure_link_along_route AS ilar
        INNER JOIN infrastructure_network.infrastructure_link AS il
        ON (ilar.infrastructure_link_id = il.infrastructure_link_id)
      ) ON (route_row.route_id = ilar.route_id)
    WHERE r.route_id = route_row.route_id;
$$;


ALTER FUNCTION route.route_shape(route_row route.route) OWNER TO dbhasura;

--
-- Name: check_scheduled_stop_point_infrastructure_link_direction(); Type: FUNCTION; Schema: service_pattern; Owner: dbhasura
--

CREATE FUNCTION service_pattern.check_scheduled_stop_point_infrastructure_link_direction() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  link_dir TEXT;
BEGIN
  SELECT infrastructure_network.infrastructure_link.direction
  FROM infrastructure_network.infrastructure_link
  INTO link_dir
  WHERE infrastructure_network.infrastructure_link.infrastructure_link_id = NEW.located_on_infrastructure_link_id;

  IF (NEW.direction = 'forward' AND link_dir = 'backward') OR
     (NEW.direction = 'backward' AND link_dir = 'forward') OR
     (NEW.direction = 'bidirectional' AND link_dir != 'bidirectional')
  THEN
    RAISE EXCEPTION 'scheduled stop point direction must be compatible with infrastructure link direction';
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION service_pattern.check_scheduled_stop_point_infrastructure_link_direction() OWNER TO dbhasura;

--
-- Name: check_scheduled_stop_point_vehicle_mode_by_infra_link(); Type: FUNCTION; Schema: service_pattern; Owner: dbhasura
--

CREATE FUNCTION service_pattern.check_scheduled_stop_point_vehicle_mode_by_infra_link() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS(
    SELECT 1
    FROM reusable_components.vehicle_submode
           JOIN service_pattern.vehicle_mode_on_scheduled_stop_point
                ON service_pattern.vehicle_mode_on_scheduled_stop_point.vehicle_mode =
                   reusable_components.vehicle_submode.belonging_to_vehicle_mode
           JOIN service_pattern.scheduled_stop_point
                ON service_pattern.scheduled_stop_point.scheduled_stop_point_id =
                   service_pattern.vehicle_mode_on_scheduled_stop_point.scheduled_stop_point_id
    WHERE reusable_components.vehicle_submode.vehicle_submode = OLD.vehicle_submode
      AND service_pattern.scheduled_stop_point.located_on_infrastructure_link_id = OLD.infrastructure_link_id
    )
  THEN
    RAISE
      EXCEPTION 'cannot remove relationship between scheduled stop point vehicle mode and infrastructure link vehicle submodes';
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION service_pattern.check_scheduled_stop_point_vehicle_mode_by_infra_link() OWNER TO dbhasura;

--
-- Name: check_scheduled_stop_point_vehicle_mode_by_scheduled_stop_point(); Type: FUNCTION; Schema: service_pattern; Owner: dbhasura
--

CREATE FUNCTION service_pattern.check_scheduled_stop_point_vehicle_mode_by_scheduled_stop_point() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NOT EXISTS(
    SELECT 1
    FROM service_pattern.vehicle_mode_on_scheduled_stop_point
           JOIN service_pattern.scheduled_stop_point
                ON service_pattern.scheduled_stop_point.scheduled_stop_point_id =
                   service_pattern.vehicle_mode_on_scheduled_stop_point.scheduled_stop_point_id
           JOIN infrastructure_network.infrastructure_link
                ON infrastructure_network.infrastructure_link.infrastructure_link_id =
                   service_pattern.scheduled_stop_point.located_on_infrastructure_link_id
           JOIN infrastructure_network.vehicle_submode_on_infrastructure_link
                ON infrastructure_network.vehicle_submode_on_infrastructure_link.infrastructure_link_id =
                   infrastructure_network.infrastructure_link.infrastructure_link_id
           JOIN reusable_components.vehicle_submode ON reusable_components.vehicle_submode.vehicle_submode =
                                                       infrastructure_network.vehicle_submode_on_infrastructure_link.vehicle_submode
    WHERE service_pattern.vehicle_mode_on_scheduled_stop_point.vehicle_mode =
          reusable_components.vehicle_submode.belonging_to_vehicle_mode
      AND service_pattern.scheduled_stop_point.scheduled_stop_point_id = NEW.scheduled_stop_point_id
    )
  THEN
    RAISE EXCEPTION 'scheduled stop point vehicle mode must be compatible with allowed infrastructure link vehicle submodes';
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION service_pattern.check_scheduled_stop_point_vehicle_mode_by_scheduled_stop_point() OWNER TO dbhasura;

--
-- Name: check_scheduled_stop_point_vehicle_mode_by_vehicle_mode(); Type: FUNCTION; Schema: service_pattern; Owner: dbhasura
--

CREATE FUNCTION service_pattern.check_scheduled_stop_point_vehicle_mode_by_vehicle_mode() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS(
       SELECT 1
       FROM service_pattern.vehicle_mode_on_scheduled_stop_point
              JOIN service_pattern.scheduled_stop_point
                   ON service_pattern.scheduled_stop_point.scheduled_stop_point_id =
                      service_pattern.vehicle_mode_on_scheduled_stop_point.scheduled_stop_point_id
              JOIN infrastructure_network.infrastructure_link
                   ON infrastructure_network.infrastructure_link.infrastructure_link_id =
                      service_pattern.scheduled_stop_point.located_on_infrastructure_link_id
              JOIN infrastructure_network.vehicle_submode_on_infrastructure_link
                   ON infrastructure_network.vehicle_submode_on_infrastructure_link.infrastructure_link_id =
                      infrastructure_network.infrastructure_link.infrastructure_link_id
              JOIN reusable_components.vehicle_submode ON reusable_components.vehicle_submode.vehicle_submode =
                                                          infrastructure_network.vehicle_submode_on_infrastructure_link.vehicle_submode
       WHERE service_pattern.vehicle_mode_on_scheduled_stop_point.vehicle_mode =
             reusable_components.vehicle_submode.belonging_to_vehicle_mode
         AND service_pattern.scheduled_stop_point.scheduled_stop_point_id = OLD.scheduled_stop_point_id
       )
    !=
     EXISTS(
       SELECT 1
       FROM service_pattern.scheduled_stop_point
       WHERE service_pattern.scheduled_stop_point.scheduled_stop_point_id = OLD.scheduled_stop_point_id
       )
  THEN
    RAISE EXCEPTION 'scheduled stop point must be assigned a vehicle mode which is compatible with allowed infrastructure link vehicle submodes';
  END IF;

  RETURN OLD;
END;
$$;


ALTER FUNCTION service_pattern.check_scheduled_stop_point_vehicle_mode_by_vehicle_mode() OWNER TO dbhasura;

--
-- Name: delete_scheduled_stop_point_label(text); Type: FUNCTION; Schema: service_pattern; Owner: dbhasura
--

CREATE FUNCTION service_pattern.delete_scheduled_stop_point_label(old_label text) RETURNS void
    LANGUAGE sql
    AS $$
DELETE FROM service_pattern.scheduled_stop_point_invariant
WHERE label = old_label
  AND NOT EXISTS (SELECT 1 FROM service_pattern.scheduled_stop_point WHERE label = old_label);
$$;


ALTER FUNCTION service_pattern.delete_scheduled_stop_point_label(old_label text) OWNER TO dbhasura;

--
-- Name: find_effective_scheduled_stop_points_in_journey_pattern(uuid, date, boolean); Type: FUNCTION; Schema: service_pattern; Owner: dbhasura
--

CREATE FUNCTION service_pattern.find_effective_scheduled_stop_points_in_journey_pattern(filter_journey_pattern_id uuid, observation_date date, include_draft_stops boolean) RETURNS TABLE(journey_pattern_id uuid, scheduled_stop_point_sequence integer, is_used_as_timing_point boolean, is_loading_time_allowed boolean, is_regulated_timing_point boolean, is_via_point boolean, via_point_name_i18n jsonb, via_point_short_name_i18n jsonb, effective_scheduled_stop_point_id uuid)
    LANGUAGE sql STABLE PARALLEL SAFE
    AS $$
WITH unambiguous_sspijp AS (
  SELECT DISTINCT
    sspijp.journey_pattern_id,
    sspijp.scheduled_stop_point_sequence,
    -- Pick the stop point instance with the highest priority.
    first_value(ssp.scheduled_stop_point_id) OVER (
      PARTITION BY sspijp.scheduled_stop_point_sequence
      ORDER BY ssp.priority DESC
    ) AS effective_scheduled_stop_point_id
  FROM journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
  JOIN service_pattern.scheduled_stop_point_invariant sspi ON sspi.label = sspijp.scheduled_stop_point_label
  JOIN service_pattern.scheduled_stop_point ssp USING (label)
  WHERE sspijp.journey_pattern_id = filter_journey_pattern_id
    AND (include_draft_stops OR ssp.priority < internal_utils.const_priority_draft())
    AND internal_utils.daterange_closed_upper(ssp.validity_start, ssp.validity_end) @> observation_date
)
SELECT
  journey_pattern_id,
  scheduled_stop_point_sequence,
  is_used_as_timing_point,
  is_loading_time_allowed,
  is_regulated_timing_point,
  is_via_point,
  via_point_name_i18n,
  via_point_short_name_i18n,
  effective_scheduled_stop_point_id
FROM unambiguous_sspijp
JOIN journey_pattern.scheduled_stop_point_in_journey_pattern USING (journey_pattern_id, scheduled_stop_point_sequence)
$$;


ALTER FUNCTION service_pattern.find_effective_scheduled_stop_points_in_journey_pattern(filter_journey_pattern_id uuid, observation_date date, include_draft_stops boolean) OWNER TO dbhasura;

--
-- Name: find_scheduled_stop_point_locations_in_journey_pattern(uuid, date, boolean); Type: FUNCTION; Schema: service_pattern; Owner: dbhasura
--

CREATE FUNCTION service_pattern.find_scheduled_stop_point_locations_in_journey_pattern(filter_journey_pattern_id uuid, observation_date date, include_draft_stops boolean) RETURNS TABLE(journey_pattern_id uuid, scheduled_stop_point_sequence integer, scheduled_stop_point_id uuid, label text, measured_location public.geography, located_on_infrastructure_link_id uuid, direction text, relative_distance_from_link_start double precision, timing_place_id uuid)
    LANGUAGE sql STABLE PARALLEL SAFE
    AS $$
SELECT
  sspijp.journey_pattern_id,
  sspijp.scheduled_stop_point_sequence,
  ssp.scheduled_stop_point_id,
  ssp.label,
  ssp.measured_location,
  ssp.located_on_infrastructure_link_id,
  ssp.direction,
  internal_utils.ST_LineLocatePoint(il.shape, ssp.measured_location) AS relative_distance_from_link_start,
  ssp.timing_place_id
FROM service_pattern.find_effective_scheduled_stop_points_in_journey_pattern(
  filter_journey_pattern_id,
  observation_date,
  include_draft_stops
) sspijp
JOIN service_pattern.scheduled_stop_point ssp ON ssp.scheduled_stop_point_id = sspijp.effective_scheduled_stop_point_id
JOIN infrastructure_network.infrastructure_link il ON il.infrastructure_link_id = ssp.located_on_infrastructure_link_id
$$;


ALTER FUNCTION service_pattern.find_scheduled_stop_point_locations_in_journey_pattern(filter_journey_pattern_id uuid, observation_date date, include_draft_stops boolean) OWNER TO dbhasura;

--
-- Name: get_distances_between_stop_points_by_routes(uuid[], date); Type: FUNCTION; Schema: service_pattern; Owner: dbhasura
--

CREATE FUNCTION service_pattern.get_distances_between_stop_points_by_routes(route_ids uuid[], observation_date date) RETURNS SETOF service_pattern.distance_between_stops_calculation
    LANGUAGE sql STABLE PARALLEL SAFE
    AS $$
SELECT stop_interval_length.*
FROM (
  SELECT
    r.route_id,
    array_agg(jp.journey_pattern_id) AS journey_pattern_ids
  FROM route.route r
  JOIN journey_pattern.journey_pattern jp ON jp.on_route_id = r.route_id
  WHERE
    r.route_id = ANY(route_ids)
    AND internal_utils.daterange_closed_upper(r.validity_start, r.validity_end) @> observation_date
  GROUP BY r.route_id
) ids
JOIN LATERAL (
  SELECT *
  FROM service_pattern.get_distances_between_stop_points_in_journey_patterns(ids.journey_pattern_ids, observation_date, false)
) stop_interval_length USING (route_id)
ORDER BY journey_pattern_id ASC, stop_interval_sequence ASC
$$;


ALTER FUNCTION service_pattern.get_distances_between_stop_points_by_routes(route_ids uuid[], observation_date date) OWNER TO dbhasura;

--
-- Name: get_distances_between_stop_points_in_journey_pattern(uuid, date, boolean); Type: FUNCTION; Schema: service_pattern; Owner: dbhasura
--

CREATE FUNCTION service_pattern.get_distances_between_stop_points_in_journey_pattern(journey_pattern_id uuid, observation_date date, include_draft_stops boolean) RETURNS SETOF service_pattern.distance_between_stops_calculation
    LANGUAGE sql STABLE PARALLEL SAFE
    AS $$
SELECT *
FROM service_pattern.get_distances_between_stop_points_in_journey_patterns(ARRAY[journey_pattern_id], observation_date, include_draft_stops)
$$;


ALTER FUNCTION service_pattern.get_distances_between_stop_points_in_journey_pattern(journey_pattern_id uuid, observation_date date, include_draft_stops boolean) OWNER TO dbhasura;

--
-- Name: get_distances_between_stop_points_in_journey_patterns(uuid[], date, boolean); Type: FUNCTION; Schema: service_pattern; Owner: dbhasura
--

CREATE FUNCTION service_pattern.get_distances_between_stop_points_in_journey_patterns(journey_pattern_ids uuid[], observation_date date, include_draft_stops boolean) RETURNS SETOF service_pattern.distance_between_stops_calculation
    LANGUAGE sql STABLE PARALLEL SAFE
    AS $$
WITH RECURSIVE
scheduled_stop_point_info AS (
  SELECT
    jp.on_route_id                         AS route_id,
    jp.journey_pattern_id,
    -- Generate continuous (gapless) sequence number starting from 1.
    row_number() OVER(
      PARTITION BY jp.journey_pattern_id
      ORDER BY ssp.scheduled_stop_point_sequence ASC
    )::integer                             AS stop_point_sequence,
    ssp.label                              AS stop_point_label,
    ssp.located_on_infrastructure_link_id  AS infrastructure_link_id,
    ssp.direction                          AS stop_point_direction,
    ssp.relative_distance_from_link_start  AS stop_distance_from_link_start
  FROM journey_pattern.journey_pattern jp
  JOIN LATERAL (
    SELECT *
    FROM service_pattern.find_scheduled_stop_point_locations_in_journey_pattern(jp.journey_pattern_id, observation_date, include_draft_stops)
  ) ssp USING (journey_pattern_id)
  WHERE jp.journey_pattern_id = ANY(journey_pattern_ids)
),
ssp_merged_with_ilar AS ( -- contains recursive term
  SELECT
    sspi.route_id,
    sspi.journey_pattern_id,
    sspi.stop_point_sequence,
    sspi.stop_point_label,
    sspi.stop_distance_from_link_start,

    -- It is assumed, that we stop at the first matching infrastructure link.
    -- 
    -- Our data model does not properly support going around a loop multiple
    -- times without stopping at the same stop point in each loop.
    -- 
    -- Also, if we make a U-turn at the end of a bi-directional link and there
    -- is a two-way stop point along it, it is not possible with this logic to
    -- stop only once and in the return direction. The data model lacks the
    -- possibility to unequivocally define with which individual link visit we
    -- should stop at a stop point along it.
    -- 
    -- Therefore, there is an inherent indeterminism in the distance calculation
    -- for these corner cases. In practice, this may not cause problems.
    -- 
    first_value(ilar.infrastructure_link_sequence) OVER (
      PARTITION BY sspi.journey_pattern_id
      ORDER BY ilar.infrastructure_link_sequence ASC
    ) AS route_link_sequence_start

  FROM scheduled_stop_point_info sspi
  JOIN route.infrastructure_link_along_route ilar USING (route_id, infrastructure_link_id)
  WHERE sspi.stop_point_sequence = 1
    AND (
      sspi.stop_point_direction = 'bidirectional'
      OR sspi.stop_point_direction = 'forward' AND ilar.is_traversal_forwards
      OR sspi.stop_point_direction = 'backward' AND NOT ilar.is_traversal_forwards
    )
  UNION
  -- recursive term begins
  SELECT
    sspi.route_id,
    sspi.journey_pattern_id,
    sspi.stop_point_sequence,
    sspi.stop_point_label,
    sspi.stop_distance_from_link_start,

    -- It is assumed, that we stop at the first matching infrastructure link.
    -- See more remarks above (in the non-recursive term).
    first_value(ilar.infrastructure_link_sequence) OVER (
      PARTITION BY sspi.journey_pattern_id
      ORDER BY ilar.infrastructure_link_sequence ASC
    ) AS route_link_sequence_start

  FROM ssp_merged_with_ilar prev
  JOIN scheduled_stop_point_info sspi
    ON sspi.journey_pattern_id = prev.journey_pattern_id
      AND sspi.stop_point_sequence = prev.stop_point_sequence + 1
  JOIN route.infrastructure_link_along_route ilar
    ON ilar.route_id = sspi.route_id
      AND ilar.infrastructure_link_id = sspi.infrastructure_link_id
  WHERE
    (
      ilar.infrastructure_link_sequence > prev.route_link_sequence_start
      OR (
        ilar.infrastructure_link_sequence = prev.route_link_sequence_start
        AND (
          ilar.is_traversal_forwards AND sspi.stop_distance_from_link_start > prev.stop_distance_from_link_start
          OR NOT ilar.is_traversal_forwards AND sspi.stop_distance_from_link_start < prev.stop_distance_from_link_start
        )
      )
    )
    AND (
      sspi.stop_point_direction = 'bidirectional'
      OR sspi.stop_point_direction = 'forward' AND ilar.is_traversal_forwards
      OR sspi.stop_point_direction = 'backward' AND NOT ilar.is_traversal_forwards
    )
),
stop_interval AS (
  SELECT *
  FROM (
    SELECT
      journey_pattern_id,
      stop_point_sequence AS stop_interval_sequence,
      stop_point_label AS start_stop_label,
      lead(stop_point_label) OVER (
        PARTITION BY journey_pattern_id
        ORDER BY stop_point_sequence ASC
      ) AS end_stop_label,
      stop_distance_from_link_start::numeric AS start_stop_distance_from_link_start,
      lead(stop_distance_from_link_start) OVER (
        PARTITION BY journey_pattern_id
        ORDER BY stop_point_sequence ASC
      )::numeric AS end_stop_distance_from_link_start,
      route_id,
      route_link_sequence_start,
      lead(route_link_sequence_start) OVER (
        PARTITION BY journey_pattern_id
        ORDER BY stop_point_sequence ASC
      ) AS route_link_sequence_end
    FROM ssp_merged_with_ilar
  ) t
   -- Filter out last item, because N stops make N-1 stop intervals.
  WHERE route_link_sequence_end IS NOT NULL
),
route_link_traversal AS (
  SELECT
    si.journey_pattern_id,
    si.stop_interval_sequence,
    ilar.infrastructure_link_sequence,

    -- When the estimated length exists, scale the length of the link section by
    -- the ratio of the estimated length to the geometry length.
    -- 
    -- Take elevation changes into account, hence using 3D lengths.
    CASE
      WHEN il.estimated_length_in_metres IS NOT NULL THEN
        il.estimated_length_in_metres / ST_3DLength(transformed_link_shape.geom) * ST_3DLength(link_section_used.geom)
      ELSE
        ST_3DLength(link_section_used.geom)
    END AS distance_in_metres

  FROM stop_interval si
  JOIN route.infrastructure_link_along_route ilar
    ON ilar.route_id = si.route_id
      AND ilar.infrastructure_link_sequence
        BETWEEN si.route_link_sequence_start AND si.route_link_sequence_end
  JOIN infrastructure_network.infrastructure_link il USING (infrastructure_link_id)
  CROSS JOIN LATERAL (
    -- CRS transformations should result in a metric coordinate system.
    -- E.g. EPSG:4326 is not like one.
    SELECT ST_Transform(il.shape::geometry, internal_utils.determine_srid(il.shape)) AS geom
  ) transformed_link_shape
  CROSS JOIN LATERAL (
    SELECT
      CASE
        WHEN numrange IS NULL THEN transformed_link_shape.geom
        ELSE ST_LineSubstring(transformed_link_shape.geom, lower(numrange), upper(numrange))
      END AS geom
    FROM (
      -- Resolve start/end point on the first/last infra link in stop interval.
      SELECT CASE
        -- both stop points along same single link
        WHEN si.route_link_sequence_start = si.route_link_sequence_end THEN
          CASE
            WHEN ilar.is_traversal_forwards THEN
              numrange(start_stop_distance_from_link_start, end_stop_distance_from_link_start, '[]')
            ELSE
              numrange(end_stop_distance_from_link_start, start_stop_distance_from_link_start, '[]')
          END
        WHEN ilar.infrastructure_link_sequence = si.route_link_sequence_start THEN
          CASE
            WHEN ilar.is_traversal_forwards THEN
              numrange(start_stop_distance_from_link_start, 1.0, '[]')
            ELSE
              numrange(0.0, start_stop_distance_from_link_start, '[]')
          END
        WHEN ilar.infrastructure_link_sequence = si.route_link_sequence_end THEN
          CASE
            WHEN ilar.is_traversal_forwards THEN
              numrange(0.0, end_stop_distance_from_link_start, '[]')
            ELSE
              numrange(end_stop_distance_from_link_start, 1.0, '[]')
          END
        ELSE NULL
      END AS numrange
    ) line_endpoints
  ) link_section_used
),
stop_interval_distance AS (
  SELECT journey_pattern_id, stop_interval_sequence, sum(distance_in_metres) AS total_distance_in_metres
  FROM route_link_traversal
  GROUP BY journey_pattern_id, stop_interval_sequence
)
SELECT
  journey_pattern_id,
  route_id,
  priority AS route_priority,
  observation_date,
  stop_interval_sequence,
  start_stop_label,
  end_stop_label,
  total_distance_in_metres AS distance_in_metres
FROM stop_interval
JOIN stop_interval_distance USING (journey_pattern_id, stop_interval_sequence)
JOIN route.route USING (route_id)
ORDER BY route_id, journey_pattern_id, stop_interval_sequence
$$;


ALTER FUNCTION service_pattern.get_distances_between_stop_points_in_journey_patterns(journey_pattern_ids uuid[], observation_date date, include_draft_stops boolean) OWNER TO dbhasura;

--
-- Name: insert_scheduled_stop_point_label(text); Type: FUNCTION; Schema: service_pattern; Owner: dbhasura
--

CREATE FUNCTION service_pattern.insert_scheduled_stop_point_label(new_label text) RETURNS void
    LANGUAGE sql
    AS $$
INSERT INTO service_pattern.scheduled_stop_point_invariant (label)
VALUES (new_label)
ON CONFLICT (label)
  DO NOTHING;
$$;


ALTER FUNCTION service_pattern.insert_scheduled_stop_point_label(new_label text) OWNER TO dbhasura;

--
-- Name: new_scheduled_stop_point_if_id_given(uuid, uuid, public.geography, text, text, date, date, integer); Type: FUNCTION; Schema: service_pattern; Owner: dbhasura
--

CREATE FUNCTION service_pattern.new_scheduled_stop_point_if_id_given(new_scheduled_stop_point_id uuid DEFAULT NULL::uuid, new_located_on_infrastructure_link_id uuid DEFAULT NULL::uuid, new_measured_location public.geography DEFAULT NULL::public.geography, new_direction text DEFAULT NULL::text, new_label text DEFAULT NULL::text, new_validity_start date DEFAULT NULL::date, new_validity_end date DEFAULT NULL::date, new_priority integer DEFAULT NULL::integer) RETURNS TABLE(scheduled_stop_point_id uuid, measured_location public.geography, located_on_infrastructure_link_id uuid, direction text, label text, validity_start date, validity_end date, priority integer, relative_distance_from_infrastructure_link_start double precision)
    LANGUAGE sql STABLE
    AS $$
  SELECT new_scheduled_stop_point_id,
         new_measured_location::geography(PointZ, 4326),
         new_located_on_infrastructure_link_id,
         new_direction,
         new_label,
         new_validity_start,
         new_validity_end,
         new_priority,
         internal_utils.st_linelocatepoint(il.shape, new_measured_location) AS relative_distance_from_infrastructure_link_start
  FROM infrastructure_network.infrastructure_link il
  WHERE new_scheduled_stop_point_id IS NOT NULL
  AND new_located_on_infrastructure_link_id = il.infrastructure_link_id;
$$;


ALTER FUNCTION service_pattern.new_scheduled_stop_point_if_id_given(new_scheduled_stop_point_id uuid, new_located_on_infrastructure_link_id uuid, new_measured_location public.geography, new_direction text, new_label text, new_validity_start date, new_validity_end date, new_priority integer) OWNER TO dbhasura;

--
-- Name: on_delete_scheduled_stop_point(); Type: FUNCTION; Schema: service_pattern; Owner: dbhasura
--

CREATE FUNCTION service_pattern.on_delete_scheduled_stop_point() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM service_pattern.delete_scheduled_stop_point_label(OLD.label);
  RETURN OLD;
END;
$$;


ALTER FUNCTION service_pattern.on_delete_scheduled_stop_point() OWNER TO dbhasura;

--
-- Name: on_insert_scheduled_stop_point(); Type: FUNCTION; Schema: service_pattern; Owner: dbhasura
--

CREATE FUNCTION service_pattern.on_insert_scheduled_stop_point() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM service_pattern.insert_scheduled_stop_point_label(NEW.label);
  RETURN NEW;
END;
$$;


ALTER FUNCTION service_pattern.on_insert_scheduled_stop_point() OWNER TO dbhasura;

--
-- Name: on_update_scheduled_stop_point(); Type: FUNCTION; Schema: service_pattern; Owner: dbhasura
--

CREATE FUNCTION service_pattern.on_update_scheduled_stop_point() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM service_pattern.insert_scheduled_stop_point_label(NEW.label);
  PERFORM service_pattern.delete_scheduled_stop_point_label(OLD.label);
  RETURN NEW;
END;
$$;


ALTER FUNCTION service_pattern.on_update_scheduled_stop_point() OWNER TO dbhasura;

--
-- Name: prevent_inserting_distance_between_stops_calculation(); Type: FUNCTION; Schema: service_pattern; Owner: dbhasura
--

CREATE FUNCTION service_pattern.prevent_inserting_distance_between_stops_calculation() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN NULL;
END;
$$;


ALTER FUNCTION service_pattern.prevent_inserting_distance_between_stops_calculation() OWNER TO dbhasura;

--
-- Name: scheduled_stop_point_closest_point_on_infrastructure_link(service_pattern.scheduled_stop_point); Type: FUNCTION; Schema: service_pattern; Owner: dbhasura
--

CREATE FUNCTION service_pattern.scheduled_stop_point_closest_point_on_infrastructure_link(ssp service_pattern.scheduled_stop_point) RETURNS public.geography
    LANGUAGE sql STABLE
    AS $$
  SELECT
    internal_utils.st_closestpoint(il.shape, ssp.measured_location) AS closest_point_on_infrastructure_link
  FROM infrastructure_network.infrastructure_link il
  WHERE ssp.located_on_infrastructure_link_id = il.infrastructure_link_id;
$$;


ALTER FUNCTION service_pattern.scheduled_stop_point_closest_point_on_infrastructure_link(ssp service_pattern.scheduled_stop_point) OWNER TO dbhasura;

--
-- Name: ssp_relative_distance_from_infrastructure_link_start(service_pattern.scheduled_stop_point); Type: FUNCTION; Schema: service_pattern; Owner: dbhasura
--

CREATE FUNCTION service_pattern.ssp_relative_distance_from_infrastructure_link_start(ssp service_pattern.scheduled_stop_point) RETURNS double precision
    LANGUAGE sql STABLE
    AS $$
  SELECT
    internal_utils.st_linelocatepoint(il.shape, ssp.measured_location) AS relative_distance_from_infrastructure_link_start
  FROM infrastructure_network.infrastructure_link il
  WHERE ssp.located_on_infrastructure_link_id = il.infrastructure_link_id;
$$;


ALTER FUNCTION service_pattern.ssp_relative_distance_from_infrastructure_link_start(ssp service_pattern.scheduled_stop_point) OWNER TO dbhasura;

--
-- Name: hdb_cron_event_invocation_event_id; Type: INDEX; Schema: hdb_catalog; Owner: dbhasura
--

CREATE INDEX hdb_cron_event_invocation_event_id ON hdb_catalog.hdb_cron_event_invocation_logs USING btree (event_id);

--
-- Name: hdb_cron_event_status; Type: INDEX; Schema: hdb_catalog; Owner: dbhasura
--

CREATE INDEX hdb_cron_event_status ON hdb_catalog.hdb_cron_events USING btree (status);

--
-- Name: hdb_cron_events_unique_scheduled; Type: INDEX; Schema: hdb_catalog; Owner: dbhasura
--

CREATE UNIQUE INDEX hdb_cron_events_unique_scheduled ON hdb_catalog.hdb_cron_events USING btree (trigger_name, scheduled_time) WHERE (status = 'scheduled'::text);

--
-- Name: hdb_scheduled_event_status; Type: INDEX; Schema: hdb_catalog; Owner: dbhasura
--

CREATE INDEX hdb_scheduled_event_status ON hdb_catalog.hdb_scheduled_events USING btree (status);

--
-- Name: hdb_version_one_row; Type: INDEX; Schema: hdb_catalog; Owner: dbhasura
--

CREATE UNIQUE INDEX hdb_version_one_row ON hdb_catalog.hdb_version USING btree (((version IS NOT NULL)));

--
-- Name: idx_infrastructure_link_direction; Type: INDEX; Schema: infrastructure_network; Owner: dbhasura
--

CREATE INDEX idx_infrastructure_link_direction ON infrastructure_network.infrastructure_link USING btree (direction);

--
-- Name: idx_infrastructure_link_external_link_source_fkey; Type: INDEX; Schema: infrastructure_network; Owner: dbhasura
--

CREATE INDEX idx_infrastructure_link_external_link_source_fkey ON infrastructure_network.infrastructure_link USING btree (external_link_source);

--
-- Name: infrastructure_link_external_link_id_external_link_source_idx; Type: INDEX; Schema: infrastructure_network; Owner: dbhasura
--

CREATE UNIQUE INDEX infrastructure_link_external_link_id_external_link_source_idx ON infrastructure_network.infrastructure_link USING btree (external_link_id, external_link_source);

--
-- Name: vehicle_submode_on_infrastruc_vehicle_submode_infrastructur_idx; Type: INDEX; Schema: infrastructure_network; Owner: dbhasura
--

CREATE INDEX vehicle_submode_on_infrastruc_vehicle_submode_infrastructur_idx ON infrastructure_network.vehicle_submode_on_infrastructure_link USING btree (vehicle_submode, infrastructure_link_id);

--
-- Name: idx_scheduled_stop_point_in_journey_pattern_via_point_name_i18n; Type: INDEX; Schema: journey_pattern; Owner: dbhasura
--

CREATE INDEX idx_scheduled_stop_point_in_journey_pattern_via_point_name_i18n ON journey_pattern.scheduled_stop_point_in_journey_pattern USING gin (via_point_name_i18n);

--
-- Name: idx_scheduled_stop_point_in_journey_pattern_via_point_short_nam; Type: INDEX; Schema: journey_pattern; Owner: dbhasura
--

CREATE INDEX idx_scheduled_stop_point_in_journey_pattern_via_point_short_nam ON journey_pattern.scheduled_stop_point_in_journey_pattern USING gin (via_point_short_name_i18n);

--
-- Name: journey_pattern_on_route_id_idx; Type: INDEX; Schema: journey_pattern; Owner: dbhasura
--

CREATE UNIQUE INDEX journey_pattern_on_route_id_idx ON journey_pattern.journey_pattern USING btree (on_route_id);

--
-- Name: scheduled_stop_point_in_journ_scheduled_stop_point_sequence_idx; Type: INDEX; Schema: journey_pattern; Owner: dbhasura
--

CREATE INDEX scheduled_stop_point_in_journ_scheduled_stop_point_sequence_idx ON journey_pattern.scheduled_stop_point_in_journey_pattern USING btree (scheduled_stop_point_sequence, journey_pattern_id);

--
-- Name: scheduled_stop_point_in_journey__scheduled_stop_point_label_idx; Type: INDEX; Schema: journey_pattern; Owner: dbhasura
--

CREATE INDEX scheduled_stop_point_in_journey__scheduled_stop_point_label_idx ON journey_pattern.scheduled_stop_point_in_journey_pattern USING btree (scheduled_stop_point_label);

--
-- Name: vehicle_submode_belonging_to_vehicle_mode_idx; Type: INDEX; Schema: reusable_components; Owner: dbhasura
--

CREATE INDEX vehicle_submode_belonging_to_vehicle_mode_idx ON reusable_components.vehicle_submode USING btree (belonging_to_vehicle_mode);

--
-- Name: idx_direction_the_opposite_of_direction; Type: INDEX; Schema: route; Owner: dbhasura
--

CREATE INDEX idx_direction_the_opposite_of_direction ON route.direction USING btree (the_opposite_of_direction);

--
-- Name: idx_line_name_i18n; Type: INDEX; Schema: route; Owner: dbhasura
--

CREATE INDEX idx_line_name_i18n ON route.line USING gin (name_i18n);

--
-- Name: idx_line_primary_vehicle_mode; Type: INDEX; Schema: route; Owner: dbhasura
--

CREATE INDEX idx_line_primary_vehicle_mode ON route.line USING btree (primary_vehicle_mode);

--
-- Name: idx_line_short_name_i18n; Type: INDEX; Schema: route; Owner: dbhasura
--

CREATE INDEX idx_line_short_name_i18n ON route.line USING gin (short_name_i18n);

--
-- Name: idx_line_type_of_line; Type: INDEX; Schema: route; Owner: dbhasura
--

CREATE INDEX idx_line_type_of_line ON route.line USING btree (type_of_line);

--
-- Name: idx_route_destination_name_i18n; Type: INDEX; Schema: route; Owner: dbhasura
--

CREATE INDEX idx_route_destination_name_i18n ON route.route USING gin (destination_name_i18n);

--
-- Name: idx_route_destination_short_name_i18n; Type: INDEX; Schema: route; Owner: dbhasura
--

CREATE INDEX idx_route_destination_short_name_i18n ON route.route USING gin (destination_short_name_i18n);

--
-- Name: idx_route_direction; Type: INDEX; Schema: route; Owner: dbhasura
--

CREATE INDEX idx_route_direction ON route.route USING btree (direction);

--
-- Name: idx_route_name_i18n; Type: INDEX; Schema: route; Owner: dbhasura
--

CREATE INDEX idx_route_name_i18n ON route.route USING gin (name_i18n);

--
-- Name: idx_route_on_line_id; Type: INDEX; Schema: route; Owner: dbhasura
--

CREATE INDEX idx_route_on_line_id ON route.route USING btree (on_line_id);

--
-- Name: idx_route_origin_name_i18n; Type: INDEX; Schema: route; Owner: dbhasura
--

CREATE INDEX idx_route_origin_name_i18n ON route.route USING gin (origin_name_i18n);

--
-- Name: idx_route_origin_short_name_i18n; Type: INDEX; Schema: route; Owner: dbhasura
--

CREATE INDEX idx_route_origin_short_name_i18n ON route.route USING gin (origin_short_name_i18n);

--
-- Name: infrastructure_link_along_rou_infrastructure_link_sequence__idx; Type: INDEX; Schema: route; Owner: dbhasura
--

CREATE INDEX infrastructure_link_along_rou_infrastructure_link_sequence__idx ON route.infrastructure_link_along_route USING btree (infrastructure_link_sequence, route_id);

--
-- Name: infrastructure_link_along_route_infrastructure_link_id_idx; Type: INDEX; Schema: route; Owner: dbhasura
--

CREATE INDEX infrastructure_link_along_route_infrastructure_link_id_idx ON route.infrastructure_link_along_route USING btree (infrastructure_link_id);

--
-- Name: type_of_line_belonging_to_vehicle_mode_idx; Type: INDEX; Schema: route; Owner: dbhasura
--

CREATE INDEX type_of_line_belonging_to_vehicle_mode_idx ON route.type_of_line USING btree (belonging_to_vehicle_mode);

--
-- Name: idx_scheduled_stop_point_direction; Type: INDEX; Schema: service_pattern; Owner: dbhasura
--

CREATE INDEX idx_scheduled_stop_point_direction ON service_pattern.scheduled_stop_point USING btree (direction);

--
-- Name: idx_scheduled_stop_point_timing_place; Type: INDEX; Schema: service_pattern; Owner: dbhasura
--

CREATE INDEX idx_scheduled_stop_point_timing_place ON service_pattern.scheduled_stop_point USING btree (timing_place_id);

--
-- Name: scheduled_stop_point_label_idx; Type: INDEX; Schema: service_pattern; Owner: dbhasura
--

CREATE INDEX scheduled_stop_point_label_idx ON service_pattern.scheduled_stop_point USING btree (label);

--
-- Name: scheduled_stop_point_located_on_infrastructure_link_id_idx; Type: INDEX; Schema: service_pattern; Owner: dbhasura
--

CREATE INDEX scheduled_stop_point_located_on_infrastructure_link_id_idx ON service_pattern.scheduled_stop_point USING btree (located_on_infrastructure_link_id);

--
-- Name: scheduled_stop_point_measured_location_idx; Type: INDEX; Schema: service_pattern; Owner: dbhasura
--

CREATE INDEX scheduled_stop_point_measured_location_idx ON service_pattern.scheduled_stop_point USING gist (measured_location);

--
-- Name: scheduled_stop_point_serviced_vehicle_mode_scheduled_stop_p_idx; Type: INDEX; Schema: service_pattern; Owner: dbhasura
--

CREATE INDEX scheduled_stop_point_serviced_vehicle_mode_scheduled_stop_p_idx ON service_pattern.vehicle_mode_on_scheduled_stop_point USING btree (vehicle_mode, scheduled_stop_point_id);

--
-- Name: scheduled_stop_point_stop_place_ref_idx; Type: INDEX; Schema: service_pattern; Owner: dbhasura
--

CREATE UNIQUE INDEX scheduled_stop_point_stop_place_ref_idx ON service_pattern.scheduled_stop_point USING btree (stop_place_ref) WHERE (stop_place_ref IS NOT NULL);

--
-- Name: timing_place_label_idx; Type: INDEX; Schema: timing_pattern; Owner: dbhasura
--

CREATE UNIQUE INDEX timing_place_label_idx ON timing_pattern.timing_place USING btree (label);

--
-- Name: hdb_catalog; Type: SCHEMA; Schema: -; Owner: dbhasura
--

CREATE SCHEMA hdb_catalog;


ALTER SCHEMA hdb_catalog OWNER TO dbhasura;

--
-- Name: infrastructure_network; Type: SCHEMA; Schema: -; Owner: dbhasura
--

CREATE SCHEMA infrastructure_network;


ALTER SCHEMA infrastructure_network OWNER TO dbhasura;

--
-- Name: internal_service_pattern; Type: SCHEMA; Schema: -; Owner: dbhasura
--

CREATE SCHEMA internal_service_pattern;


ALTER SCHEMA internal_service_pattern OWNER TO dbhasura;

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: dbadmin
--

ALTER SCHEMA public OWNER TO dbadmin;

--
-- Name: reusable_components; Type: SCHEMA; Schema: -; Owner: dbhasura
--

CREATE SCHEMA reusable_components;


ALTER SCHEMA reusable_components OWNER TO dbhasura;

--
-- Name: route; Type: SCHEMA; Schema: -; Owner: dbhasura
--

CREATE SCHEMA route;


ALTER SCHEMA route OWNER TO dbhasura;

--
-- Name: service_pattern; Type: SCHEMA; Schema: -; Owner: dbhasura
--

CREATE SCHEMA service_pattern;


ALTER SCHEMA service_pattern OWNER TO dbhasura;

--
-- Name: tiger; Type: SCHEMA; Schema: -; Owner: dbadmin
--

CREATE SCHEMA tiger;


ALTER SCHEMA tiger OWNER TO dbadmin;

--
-- Name: tiger_data; Type: SCHEMA; Schema: -; Owner: dbadmin
--

CREATE SCHEMA tiger_data;


ALTER SCHEMA tiger_data OWNER TO dbadmin;

--
-- Name: timing_pattern; Type: SCHEMA; Schema: -; Owner: dbhasura
--

CREATE SCHEMA timing_pattern;


ALTER SCHEMA timing_pattern OWNER TO dbhasura;

--
-- Name: topology; Type: SCHEMA; Schema: -; Owner: dbadmin
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO dbadmin;

--
-- Name: hdb_action_log; Type: TABLE; Schema: hdb_catalog; Owner: dbhasura
--

CREATE TABLE hdb_catalog.hdb_action_log (
    id uuid DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    action_name text,
    input_payload jsonb NOT NULL,
    request_headers jsonb NOT NULL,
    session_variables jsonb NOT NULL,
    response_payload jsonb,
    errors jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    response_received_at timestamp with time zone,
    status text NOT NULL,
    CONSTRAINT hdb_action_log_status_check CHECK ((status = ANY (ARRAY['created'::text, 'processing'::text, 'completed'::text, 'error'::text])))
);


ALTER TABLE hdb_catalog.hdb_action_log OWNER TO dbhasura;

--
-- Name: hdb_cron_event_invocation_logs; Type: TABLE; Schema: hdb_catalog; Owner: dbhasura
--

CREATE TABLE hdb_catalog.hdb_cron_event_invocation_logs (
    id text DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    event_id text,
    status integer,
    request json,
    response json,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE hdb_catalog.hdb_cron_event_invocation_logs OWNER TO dbhasura;

--
-- Name: hdb_cron_events; Type: TABLE; Schema: hdb_catalog; Owner: dbhasura
--

CREATE TABLE hdb_catalog.hdb_cron_events (
    id text DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    trigger_name text NOT NULL,
    scheduled_time timestamp with time zone NOT NULL,
    status text DEFAULT 'scheduled'::text NOT NULL,
    tries integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    next_retry_at timestamp with time zone,
    CONSTRAINT valid_status CHECK ((status = ANY (ARRAY['scheduled'::text, 'locked'::text, 'delivered'::text, 'error'::text, 'dead'::text])))
);


ALTER TABLE hdb_catalog.hdb_cron_events OWNER TO dbhasura;

--
-- Name: hdb_metadata; Type: TABLE; Schema: hdb_catalog; Owner: dbhasura
--

CREATE TABLE hdb_catalog.hdb_metadata (
    id integer NOT NULL,
    metadata json NOT NULL,
    resource_version integer DEFAULT 1 NOT NULL
);


ALTER TABLE hdb_catalog.hdb_metadata OWNER TO dbhasura;

--
-- Name: hdb_scheduled_event_invocation_logs; Type: TABLE; Schema: hdb_catalog; Owner: dbhasura
--

CREATE TABLE hdb_catalog.hdb_scheduled_event_invocation_logs (
    id text DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    event_id text,
    status integer,
    request json,
    response json,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE hdb_catalog.hdb_scheduled_event_invocation_logs OWNER TO dbhasura;

--
-- Name: hdb_scheduled_events; Type: TABLE; Schema: hdb_catalog; Owner: dbhasura
--

CREATE TABLE hdb_catalog.hdb_scheduled_events (
    id text DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    webhook_conf json NOT NULL,
    scheduled_time timestamp with time zone NOT NULL,
    retry_conf json,
    payload json,
    header_conf json,
    status text DEFAULT 'scheduled'::text NOT NULL,
    tries integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    next_retry_at timestamp with time zone,
    comment text,
    CONSTRAINT valid_status CHECK ((status = ANY (ARRAY['scheduled'::text, 'locked'::text, 'delivered'::text, 'error'::text, 'dead'::text])))
);


ALTER TABLE hdb_catalog.hdb_scheduled_events OWNER TO dbhasura;

--
-- Name: hdb_schema_notifications; Type: TABLE; Schema: hdb_catalog; Owner: dbhasura
--

CREATE TABLE hdb_catalog.hdb_schema_notifications (
    id integer NOT NULL,
    notification json NOT NULL,
    resource_version integer DEFAULT 1 NOT NULL,
    instance_id uuid NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT hdb_schema_notifications_id_check CHECK ((id = 1))
);


ALTER TABLE hdb_catalog.hdb_schema_notifications OWNER TO dbhasura;

--
-- Name: hdb_version; Type: TABLE; Schema: hdb_catalog; Owner: dbhasura
--

CREATE TABLE hdb_catalog.hdb_version (
    hasura_uuid uuid DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    version text NOT NULL,
    upgraded_on timestamp with time zone NOT NULL,
    cli_state jsonb DEFAULT '{}'::jsonb NOT NULL,
    console_state jsonb DEFAULT '{}'::jsonb NOT NULL,
    ee_client_id text,
    ee_client_secret text
);


ALTER TABLE hdb_catalog.hdb_version OWNER TO dbhasura;

--
-- Name: direction; Type: TABLE; Schema: infrastructure_network; Owner: dbhasura
--

CREATE TABLE infrastructure_network.direction (
    value text NOT NULL
);


ALTER TABLE infrastructure_network.direction OWNER TO dbhasura;

--
-- Name: external_source; Type: TABLE; Schema: infrastructure_network; Owner: dbhasura
--

CREATE TABLE infrastructure_network.external_source (
    value text NOT NULL
);


ALTER TABLE infrastructure_network.external_source OWNER TO dbhasura;

--
-- Name: infrastructure_link; Type: TABLE; Schema: infrastructure_network; Owner: dbhasura
--

CREATE TABLE infrastructure_network.infrastructure_link (
    infrastructure_link_id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    direction text NOT NULL,
    shape public.geography(LineStringZ,4326) NOT NULL,
    estimated_length_in_metres double precision,
    external_link_id text NOT NULL,
    external_link_source text NOT NULL
);


ALTER TABLE infrastructure_network.infrastructure_link OWNER TO dbhasura;

--
-- Name: vehicle_submode_on_infrastructure_link; Type: TABLE; Schema: infrastructure_network; Owner: dbhasura
--

CREATE TABLE infrastructure_network.vehicle_submode_on_infrastructure_link (
    infrastructure_link_id uuid NOT NULL,
    vehicle_submode text NOT NULL
);


ALTER TABLE infrastructure_network.vehicle_submode_on_infrastructure_link OWNER TO dbhasura;

--
-- Name: journey_pattern; Type: TABLE; Schema: journey_pattern; Owner: dbhasura
--

CREATE TABLE journey_pattern.journey_pattern (
    journey_pattern_id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    on_route_id uuid NOT NULL
);


ALTER TABLE journey_pattern.journey_pattern OWNER TO dbhasura;

--
-- Name: scheduled_stop_point_in_journey_pattern; Type: TABLE; Schema: journey_pattern; Owner: dbhasura
--

CREATE TABLE journey_pattern.scheduled_stop_point_in_journey_pattern (
    journey_pattern_id uuid NOT NULL,
    scheduled_stop_point_sequence integer NOT NULL,
    is_used_as_timing_point boolean DEFAULT false NOT NULL,
    is_via_point boolean DEFAULT false NOT NULL,
    via_point_name_i18n jsonb,
    via_point_short_name_i18n jsonb,
    scheduled_stop_point_label text NOT NULL,
    is_loading_time_allowed boolean DEFAULT false NOT NULL,
    is_regulated_timing_point boolean DEFAULT false NOT NULL,
    CONSTRAINT ck_is_regulated_timing_point_state CHECK ((NOT ((is_regulated_timing_point = false) AND (is_loading_time_allowed = true)))),
    CONSTRAINT ck_is_used_as_timing_point_state CHECK ((NOT ((is_used_as_timing_point = false) AND (is_regulated_timing_point = true)))),
    CONSTRAINT ck_is_via_point_state CHECK ((((is_via_point = false) AND (via_point_name_i18n IS NULL) AND (via_point_short_name_i18n IS NULL)) OR ((is_via_point = true) AND (via_point_name_i18n IS NOT NULL) AND (via_point_short_name_i18n IS NOT NULL))))
);


ALTER TABLE journey_pattern.scheduled_stop_point_in_journey_pattern OWNER TO dbhasura;

--
-- Name: vehicle_mode; Type: TABLE; Schema: reusable_components; Owner: dbhasura
--

CREATE TABLE reusable_components.vehicle_mode (
    vehicle_mode text NOT NULL
);


ALTER TABLE reusable_components.vehicle_mode OWNER TO dbhasura;

--
-- Name: vehicle_submode; Type: TABLE; Schema: reusable_components; Owner: dbhasura
--

CREATE TABLE reusable_components.vehicle_submode (
    vehicle_submode text NOT NULL,
    belonging_to_vehicle_mode text NOT NULL
);


ALTER TABLE reusable_components.vehicle_submode OWNER TO dbhasura;

--
-- Name: direction; Type: TABLE; Schema: route; Owner: dbhasura
--

CREATE TABLE route.direction (
    direction text NOT NULL,
    the_opposite_of_direction text
);


ALTER TABLE route.direction OWNER TO dbhasura;

--
-- Name: infrastructure_link_along_route; Type: TABLE; Schema: route; Owner: dbhasura
--

CREATE TABLE route.infrastructure_link_along_route (
    route_id uuid NOT NULL,
    infrastructure_link_id uuid NOT NULL,
    infrastructure_link_sequence integer NOT NULL,
    is_traversal_forwards boolean NOT NULL
);


ALTER TABLE route.infrastructure_link_along_route OWNER TO dbhasura;

--
-- Name: line; Type: TABLE; Schema: route; Owner: dbhasura
--

CREATE TABLE route.line (
    line_id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name_i18n jsonb NOT NULL,
    short_name_i18n jsonb NOT NULL,
    primary_vehicle_mode text NOT NULL,
    validity_start date,
    validity_end date,
    priority integer NOT NULL,
    label text NOT NULL,
    type_of_line text NOT NULL
);


ALTER TABLE route.line OWNER TO dbhasura;

--
-- Name: route; Type: TABLE; Schema: route; Owner: dbhasura
--

CREATE TABLE route.route (
    route_id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    description_i18n jsonb,
    on_line_id uuid NOT NULL,
    validity_start date,
    validity_end date,
    priority integer NOT NULL,
    label text NOT NULL,
    direction text NOT NULL,
    name_i18n jsonb NOT NULL,
    origin_name_i18n jsonb,
    origin_short_name_i18n jsonb,
    destination_name_i18n jsonb,
    destination_short_name_i18n jsonb,
    unique_label text GENERATED ALWAYS AS (label) STORED
);


ALTER TABLE route.route OWNER TO dbhasura;

--
-- Name: type_of_line; Type: TABLE; Schema: route; Owner: dbhasura
--

CREATE TABLE route.type_of_line (
    type_of_line text NOT NULL,
    belonging_to_vehicle_mode text NOT NULL
);


ALTER TABLE route.type_of_line OWNER TO dbhasura;

--
-- Name: distance_between_stops_calculation; Type: TABLE; Schema: service_pattern; Owner: dbhasura
--

CREATE TABLE service_pattern.distance_between_stops_calculation (
    journey_pattern_id uuid NOT NULL,
    route_id uuid NOT NULL,
    route_priority integer NOT NULL,
    observation_date date NOT NULL,
    stop_interval_sequence integer NOT NULL,
    start_stop_label text NOT NULL,
    end_stop_label text NOT NULL,
    distance_in_metres double precision NOT NULL
);


ALTER TABLE service_pattern.distance_between_stops_calculation OWNER TO dbhasura;

--
-- Name: scheduled_stop_point; Type: TABLE; Schema: service_pattern; Owner: dbhasura
--

CREATE TABLE service_pattern.scheduled_stop_point (
    scheduled_stop_point_id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    measured_location public.geography(PointZ,4326) NOT NULL,
    located_on_infrastructure_link_id uuid NOT NULL,
    direction text NOT NULL,
    label text NOT NULL,
    validity_start date,
    validity_end date,
    priority integer NOT NULL,
    timing_place_id uuid,
    stop_place_ref text
);


ALTER TABLE service_pattern.scheduled_stop_point OWNER TO dbhasura;

--
-- Name: scheduled_stop_point_invariant; Type: TABLE; Schema: service_pattern; Owner: dbhasura
--

CREATE TABLE service_pattern.scheduled_stop_point_invariant (
    label text NOT NULL
);


ALTER TABLE service_pattern.scheduled_stop_point_invariant OWNER TO dbhasura;

--
-- Name: vehicle_mode_on_scheduled_stop_point; Type: TABLE; Schema: service_pattern; Owner: dbhasura
--

CREATE TABLE service_pattern.vehicle_mode_on_scheduled_stop_point (
    scheduled_stop_point_id uuid NOT NULL,
    vehicle_mode text NOT NULL
);


ALTER TABLE service_pattern.vehicle_mode_on_scheduled_stop_point OWNER TO dbhasura;

--
-- Name: timing_place; Type: TABLE; Schema: timing_pattern; Owner: dbhasura
--

CREATE TABLE timing_pattern.timing_place (
    timing_place_id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    label text NOT NULL,
    description jsonb
);


ALTER TABLE timing_pattern.timing_place OWNER TO dbhasura;

--
-- Name: infrastructure_link check_infrastructure_link_route_link_direction_trigger; Type: TRIGGER; Schema: infrastructure_network; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER check_infrastructure_link_route_link_direction_trigger AFTER UPDATE ON infrastructure_network.infrastructure_link DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION infrastructure_network.check_infrastructure_link_route_link_direction();

--
-- Name: infrastructure_link check_infrastructure_link_scheduled_stop_points_direction_trigg; Type: TRIGGER; Schema: infrastructure_network; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER check_infrastructure_link_scheduled_stop_points_direction_trigg AFTER UPDATE ON infrastructure_network.infrastructure_link DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION infrastructure_network.check_infrastructure_link_scheduled_stop_points_direction_trigg();

--
-- Name: vehicle_submode_on_infrastructure_link prevent_update_of_vehicle_submode_on_infrastructure_link; Type: TRIGGER; Schema: infrastructure_network; Owner: dbhasura
--

CREATE TRIGGER prevent_update_of_vehicle_submode_on_infrastructure_link BEFORE UPDATE ON infrastructure_network.vehicle_submode_on_infrastructure_link FOR EACH ROW EXECUTE FUNCTION internal_utils.prevent_update();

--
-- Name: vehicle_submode_on_infrastructure_link scheduled_stop_point_vehicle_mode_by_infra_link_trigger; Type: TRIGGER; Schema: infrastructure_network; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER scheduled_stop_point_vehicle_mode_by_infra_link_trigger AFTER DELETE ON infrastructure_network.vehicle_submode_on_infrastructure_link DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION service_pattern.check_scheduled_stop_point_vehicle_mode_by_infra_link();

--
-- Name: journey_pattern queue_verify_infra_link_stop_refs_on_jp_update_trigger; Type: TRIGGER; Schema: journey_pattern; Owner: dbhasura
--

CREATE TRIGGER queue_verify_infra_link_stop_refs_on_jp_update_trigger AFTER UPDATE ON journey_pattern.journey_pattern REFERENCING NEW TABLE AS new_table FOR EACH STATEMENT EXECUTE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_journey_pattern_id();

--
-- Name: journey_pattern verify_infra_link_stop_refs_on_journey_pattern_trigger; Type: TRIGGER; Schema: journey_pattern; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER verify_infra_link_stop_refs_on_journey_pattern_trigger AFTER UPDATE ON journey_pattern.journey_pattern DEFERRABLE INITIALLY DEFERRED FOR EACH ROW WHEN ((NOT journey_pattern.infra_link_stop_refs_already_verified())) EXECUTE FUNCTION journey_pattern.verify_infra_link_stop_refs();

--
-- Name: scheduled_stop_point_in_journey_pattern queue_verify_infra_link_stop_refs_on_sspijp_insert_trigger; Type: TRIGGER; Schema: journey_pattern; Owner: dbhasura
--

CREATE TRIGGER queue_verify_infra_link_stop_refs_on_sspijp_insert_trigger AFTER INSERT ON journey_pattern.scheduled_stop_point_in_journey_pattern REFERENCING NEW TABLE AS new_table FOR EACH STATEMENT EXECUTE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_journey_pattern_id();

--
-- Name: scheduled_stop_point_in_journey_pattern queue_verify_infra_link_stop_refs_on_sspijp_update_trigger; Type: TRIGGER; Schema: journey_pattern; Owner: dbhasura
--

CREATE TRIGGER queue_verify_infra_link_stop_refs_on_sspijp_update_trigger AFTER UPDATE ON journey_pattern.scheduled_stop_point_in_journey_pattern REFERENCING NEW TABLE AS new_table FOR EACH STATEMENT EXECUTE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_journey_pattern_id();

--
-- Name: scheduled_stop_point_in_journey_pattern scheduled_stop_point_has_timing_place_if_used_as_timing_point_t; Type: TRIGGER; Schema: journey_pattern; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER scheduled_stop_point_has_timing_place_if_used_as_timing_point_t AFTER INSERT OR UPDATE ON journey_pattern.scheduled_stop_point_in_journey_pattern DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION journey_pattern.scheduled_stop_point_has_timing_place_if_used_as_timing_point();

--
-- Name: scheduled_stop_point_in_journey_pattern verify_infra_link_stop_refs_on_sspijp_trigger; Type: TRIGGER; Schema: journey_pattern; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER verify_infra_link_stop_refs_on_sspijp_trigger AFTER INSERT OR UPDATE ON journey_pattern.scheduled_stop_point_in_journey_pattern DEFERRABLE INITIALLY DEFERRED FOR EACH ROW WHEN ((NOT journey_pattern.infra_link_stop_refs_already_verified())) EXECUTE FUNCTION journey_pattern.verify_infra_link_stop_refs();

--
-- Name: infrastructure_link_along_route check_route_link_infrastructure_link_direction_trigger; Type: TRIGGER; Schema: route; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER check_route_link_infrastructure_link_direction_trigger AFTER INSERT OR UPDATE ON route.infrastructure_link_along_route DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION route.check_route_link_infrastructure_link_direction();

--
-- Name: infrastructure_link_along_route queue_verify_infra_link_stop_refs_on_ilar_delete_trigger; Type: TRIGGER; Schema: route; Owner: dbhasura
--

CREATE TRIGGER queue_verify_infra_link_stop_refs_on_ilar_delete_trigger AFTER DELETE ON route.infrastructure_link_along_route REFERENCING OLD TABLE AS old_table FOR EACH STATEMENT EXECUTE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_id();

--
-- Name: infrastructure_link_along_route queue_verify_infra_link_stop_refs_on_ilar_update_trigger; Type: TRIGGER; Schema: route; Owner: dbhasura
--

CREATE TRIGGER queue_verify_infra_link_stop_refs_on_ilar_update_trigger AFTER UPDATE ON route.infrastructure_link_along_route REFERENCING OLD TABLE AS old_table FOR EACH STATEMENT EXECUTE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_id();

--
-- Name: infrastructure_link_along_route truncate_sspijp_on_ilar_truncate_trigger; Type: TRIGGER; Schema: route; Owner: dbhasura
--

CREATE TRIGGER truncate_sspijp_on_ilar_truncate_trigger AFTER TRUNCATE ON route.infrastructure_link_along_route FOR EACH STATEMENT EXECUTE FUNCTION journey_pattern.truncate_scheduled_stop_point_in_journey_pattern();

--
-- Name: infrastructure_link_along_route verify_infra_link_stop_refs_on_ilar_trigger; Type: TRIGGER; Schema: route; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER verify_infra_link_stop_refs_on_ilar_trigger AFTER DELETE OR UPDATE ON route.infrastructure_link_along_route DEFERRABLE INITIALLY DEFERRED FOR EACH ROW WHEN ((NOT journey_pattern.infra_link_stop_refs_already_verified())) EXECUTE FUNCTION journey_pattern.verify_infra_link_stop_refs();

--
-- Name: line check_line_routes_priorities_trigger; Type: TRIGGER; Schema: route; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER check_line_routes_priorities_trigger AFTER UPDATE ON route.line DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION route.check_line_routes_priorities();

--
-- Name: line check_line_validity_against_all_associated_routes_trigger; Type: TRIGGER; Schema: route; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER check_line_validity_against_all_associated_routes_trigger AFTER UPDATE ON route.line DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION route.check_line_validity_against_all_associated_routes();

--
-- Name: line check_type_of_line_vehicle_mode_trigger; Type: TRIGGER; Schema: route; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER check_type_of_line_vehicle_mode_trigger AFTER INSERT OR UPDATE ON route.line DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION route.check_type_of_line_vehicle_mode();

--
-- Name: route check_route_line_priorities_trigger; Type: TRIGGER; Schema: route; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER check_route_line_priorities_trigger AFTER INSERT OR UPDATE ON route.route DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION route.check_route_line_priorities();

--
-- Name: route check_route_validity_is_within_line_validity_trigger; Type: TRIGGER; Schema: route; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER check_route_validity_is_within_line_validity_trigger AFTER INSERT OR UPDATE ON route.route DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION route.check_route_validity_is_within_line_validity();

--
-- Name: route queue_verify_infra_link_stop_refs_on_route_delete_trigger; Type: TRIGGER; Schema: route; Owner: dbhasura
--

CREATE TRIGGER queue_verify_infra_link_stop_refs_on_route_delete_trigger AFTER DELETE ON route.route REFERENCING OLD TABLE AS old_table FOR EACH STATEMENT EXECUTE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_label();

--
-- Name: route verify_infra_link_stop_refs_on_route_trigger; Type: TRIGGER; Schema: route; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER verify_infra_link_stop_refs_on_route_trigger AFTER DELETE ON route.route DEFERRABLE INITIALLY DEFERRED FOR EACH ROW WHEN ((NOT journey_pattern.infra_link_stop_refs_already_verified())) EXECUTE FUNCTION journey_pattern.verify_infra_link_stop_refs();

--
-- Name: distance_between_stops_calculation prevent_insertion_to_distance_between_stops_calculation; Type: TRIGGER; Schema: service_pattern; Owner: dbhasura
--

CREATE TRIGGER prevent_insertion_to_distance_between_stops_calculation BEFORE INSERT ON service_pattern.distance_between_stops_calculation FOR EACH ROW EXECUTE FUNCTION service_pattern.prevent_inserting_distance_between_stops_calculation();

--
-- Name: scheduled_stop_point check_scheduled_stop_point_infrastructure_link_direction_trigge; Type: TRIGGER; Schema: service_pattern; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER check_scheduled_stop_point_infrastructure_link_direction_trigge AFTER INSERT OR UPDATE ON service_pattern.scheduled_stop_point DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION service_pattern.check_scheduled_stop_point_infrastructure_link_direction();

--
-- Name: scheduled_stop_point queue_verify_infra_link_stop_refs_on_ssp_delete_trigger; Type: TRIGGER; Schema: service_pattern; Owner: dbhasura
--

CREATE TRIGGER queue_verify_infra_link_stop_refs_on_ssp_delete_trigger AFTER DELETE ON service_pattern.scheduled_stop_point REFERENCING OLD TABLE AS old_table FOR EACH STATEMENT EXECUTE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_ssp_label();

--
-- Name: scheduled_stop_point queue_verify_infra_link_stop_refs_on_ssp_insert_trigger; Type: TRIGGER; Schema: service_pattern; Owner: dbhasura
--

CREATE TRIGGER queue_verify_infra_link_stop_refs_on_ssp_insert_trigger AFTER INSERT ON service_pattern.scheduled_stop_point REFERENCING NEW TABLE AS new_table FOR EACH STATEMENT EXECUTE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_ssp_label();

--
-- Name: scheduled_stop_point queue_verify_infra_link_stop_refs_on_ssp_update_trigger; Type: TRIGGER; Schema: service_pattern; Owner: dbhasura
--

CREATE TRIGGER queue_verify_infra_link_stop_refs_on_ssp_update_trigger AFTER UPDATE ON service_pattern.scheduled_stop_point REFERENCING NEW TABLE AS new_table FOR EACH STATEMENT EXECUTE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_ssp_label();

--
-- Name: scheduled_stop_point scheduled_stop_point_has_timing_place_if_used_as_timing_point_t; Type: TRIGGER; Schema: service_pattern; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER scheduled_stop_point_has_timing_place_if_used_as_timing_point_t AFTER INSERT OR UPDATE ON service_pattern.scheduled_stop_point DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION journey_pattern.scheduled_stop_point_has_timing_place_if_used_as_timing_point();

--
-- Name: scheduled_stop_point scheduled_stop_point_vehicle_mode_by_scheduled_stop_point_trigg; Type: TRIGGER; Schema: service_pattern; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER scheduled_stop_point_vehicle_mode_by_scheduled_stop_point_trigg AFTER INSERT OR UPDATE ON service_pattern.scheduled_stop_point DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION service_pattern.check_scheduled_stop_point_vehicle_mode_by_scheduled_stop_point();

--
-- Name: scheduled_stop_point service_pattern_delete_scheduled_stop_point_trigger; Type: TRIGGER; Schema: service_pattern; Owner: dbhasura
--

CREATE TRIGGER service_pattern_delete_scheduled_stop_point_trigger AFTER DELETE ON service_pattern.scheduled_stop_point FOR EACH ROW EXECUTE FUNCTION service_pattern.on_delete_scheduled_stop_point();

--
-- Name: scheduled_stop_point service_pattern_insert_scheduled_stop_point_trigger; Type: TRIGGER; Schema: service_pattern; Owner: dbhasura
--

CREATE TRIGGER service_pattern_insert_scheduled_stop_point_trigger BEFORE INSERT ON service_pattern.scheduled_stop_point FOR EACH ROW EXECUTE FUNCTION service_pattern.on_insert_scheduled_stop_point();

--
-- Name: scheduled_stop_point service_pattern_update_scheduled_stop_point_trigger; Type: TRIGGER; Schema: service_pattern; Owner: dbhasura
--

CREATE TRIGGER service_pattern_update_scheduled_stop_point_trigger BEFORE UPDATE ON service_pattern.scheduled_stop_point FOR EACH ROW EXECUTE FUNCTION service_pattern.on_update_scheduled_stop_point();

--
-- Name: scheduled_stop_point verify_infra_link_stop_refs_on_scheduled_stop_point_trigger; Type: TRIGGER; Schema: service_pattern; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER verify_infra_link_stop_refs_on_scheduled_stop_point_trigger AFTER INSERT OR DELETE OR UPDATE ON service_pattern.scheduled_stop_point DEFERRABLE INITIALLY DEFERRED FOR EACH ROW WHEN ((NOT journey_pattern.infra_link_stop_refs_already_verified())) EXECUTE FUNCTION journey_pattern.verify_infra_link_stop_refs();

--
-- Name: vehicle_mode_on_scheduled_stop_point prevent_update_of_vehicle_mode_on_scheduled_stop_point; Type: TRIGGER; Schema: service_pattern; Owner: dbhasura
--

CREATE TRIGGER prevent_update_of_vehicle_mode_on_scheduled_stop_point BEFORE UPDATE ON service_pattern.vehicle_mode_on_scheduled_stop_point FOR EACH ROW EXECUTE FUNCTION internal_utils.prevent_update();

--
-- Name: vehicle_mode_on_scheduled_stop_point scheduled_stop_point_vehicle_mode_by_vehicle_mode_trigger; Type: TRIGGER; Schema: service_pattern; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER scheduled_stop_point_vehicle_mode_by_vehicle_mode_trigger AFTER DELETE ON service_pattern.vehicle_mode_on_scheduled_stop_point DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION service_pattern.check_scheduled_stop_point_vehicle_mode_by_vehicle_mode();

--
-- Name: scheduled_stop_points_with_infra_link_data; Type: VIEW; Schema: service_pattern; Owner: dbhasura
--

CREATE VIEW service_pattern.scheduled_stop_points_with_infra_link_data AS
 SELECT ssp.scheduled_stop_point_id,
    ssp.measured_location,
    ssp.located_on_infrastructure_link_id,
    ssp.direction,
    ssp.label,
    ssp.validity_start,
    ssp.validity_end,
    ssp.priority,
    internal_utils.st_linelocatepoint(il.shape, ssp.measured_location) AS relative_distance_from_infrastructure_link_start
   FROM (service_pattern.scheduled_stop_point ssp
     JOIN infrastructure_network.infrastructure_link il ON ((ssp.located_on_infrastructure_link_id = il.infrastructure_link_id)));


ALTER TABLE service_pattern.scheduled_stop_points_with_infra_link_data OWNER TO dbhasura;

--
-- Sorted dump complete
--
