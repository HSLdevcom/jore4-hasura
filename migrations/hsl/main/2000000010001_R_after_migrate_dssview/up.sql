--
-- dssview schema views
--
-- Mirrors all main database tables into the dssview schema.
-- Draft rows (priority >= 30) are excluded from all priority-aware views.
-- Staging rows (priority = 40) are additionally excluded from vehicle_schedule_frame.
-- Views are created in dependency order (parent views before child views).
--

--------------------------------------------------------------------------------
-- Phase A: Simple pass-through views (Category 4)
-- No priority or draft concerns. No dependencies on other dssview views.
--------------------------------------------------------------------------------

-- Infrastructure Network

CREATE OR REPLACE VIEW dssview.infrastructure_network_external_source AS
SELECT es.value
FROM infrastructure_network.external_source es;

CREATE OR REPLACE VIEW dssview.infrastructure_network_direction AS
SELECT d.value
FROM infrastructure_network.direction d;

CREATE OR REPLACE VIEW dssview.infrastructure_network_infrastructure_link AS
SELECT il.infrastructure_link_id,
       il.direction,
       il.shape,
       il.estimated_length_in_metres,
       il.external_link_id,
       il.external_link_source
FROM infrastructure_network.infrastructure_link il;

CREATE OR REPLACE VIEW dssview.infrastructure_network_vehicle_submode_on_infrastructure_link AS
SELECT vsil.infrastructure_link_id,
       vsil.vehicle_submode
FROM infrastructure_network.vehicle_submode_on_infrastructure_link vsil;

-- Reusable Components

CREATE OR REPLACE VIEW dssview.reusable_components_vehicle_mode AS
SELECT vm.vehicle_mode
FROM reusable_components.vehicle_mode vm;

CREATE OR REPLACE VIEW dssview.reusable_components_vehicle_submode AS
SELECT vs.vehicle_submode,
       vs.belonging_to_vehicle_mode
FROM reusable_components.vehicle_submode vs;

-- Network (non-priority, non-dependent)

CREATE OR REPLACE VIEW dssview.network_route_direction AS
SELECT rd.direction,
       rd.the_opposite_of_direction
FROM network.route_direction rd;

CREATE OR REPLACE VIEW dssview.network_type_of_line AS
SELECT tol.type_of_line,
       tol.belonging_to_vehicle_mode
FROM network.type_of_line tol;

CREATE OR REPLACE VIEW dssview.network_transport_target AS
SELECT tt.transport_target
FROM network.transport_target tt;

CREATE OR REPLACE VIEW dssview.network_legacy_hsl_municipality_code AS
SELECT lhmc.hsl_municipality,
       lhmc.jore3_code
FROM network.legacy_hsl_municipality_code lhmc;

CREATE OR REPLACE VIEW dssview.network_timing_place AS
SELECT tp.timing_place_id,
       tp.label,
       tp.description
FROM network.timing_place tp;

CREATE OR REPLACE VIEW dssview.network_scheduled_stop_point_invariant AS
SELECT sspi.label
FROM network.scheduled_stop_point_invariant sspi;

-- Timetables (non-dependent)

CREATE OR REPLACE VIEW dssview.timetables_day_type AS
SELECT dt.day_type_id,
       dt.label,
       dt.name_i18n
FROM timetables.day_type dt;

CREATE OR REPLACE VIEW dssview.timetables_vehicle_type AS
SELECT vt.vehicle_type_id,
       vt.label,
       vt.description_i18n,
       vt.hsl_id
FROM timetables.vehicle_type vt;

CREATE OR REPLACE VIEW dssview.timetables_journey_type AS
SELECT jt.type
FROM timetables.journey_type jt;

CREATE OR REPLACE VIEW dssview.timetables_day_type_active_on_day_of_week AS
SELECT dtadow.day_type_id,
       dtadow.day_of_week
FROM timetables.day_type_active_on_day_of_week dtadow;

CREATE OR REPLACE VIEW dssview.timetables_substitute_operating_day_by_line_type AS
SELECT sodblt.substitute_operating_day_by_line_type_id,
       sodblt.type_of_line,
       sodblt.superseded_date,
       sodblt.substitute_day_of_week,
       sodblt.begin_time,
       sodblt.end_time,
       sodblt.timezone,
       sodblt.begin_datetime,
       sodblt.end_datetime,
       sodblt.substitute_operating_period_id,
       sodblt.created_at
FROM timetables.substitute_operating_day_by_line_type sodblt;

CREATE OR REPLACE VIEW dssview.timetables_substitute_operating_period AS
SELECT sop.substitute_operating_period_id,
       sop.period_name,
       sop.is_preset
FROM timetables.substitute_operating_period sop;

-- Return Value (function-return tables)

CREATE OR REPLACE VIEW dssview.return_value_timetable_version AS
SELECT tv.vehicle_schedule_frame_id,
       tv.substitute_operating_day_by_line_type_id,
       tv.validity_start,
       tv.validity_end,
       tv.priority,
       tv.in_effect,
       tv.day_type_id
FROM return_value.timetable_version tv;

CREATE OR REPLACE VIEW dssview.return_value_vehicle_schedule AS
SELECT vs.vehicle_journey_id,
       vs.validity_start,
       vs.validity_end,
       vs.priority,
       vs.day_type_id,
       vs.vehicle_schedule_frame_id,
       vs.substitute_operating_day_by_line_type_id,
       vs.created_at
FROM return_value.vehicle_schedule vs;

--------------------------------------------------------------------------------
-- Phase B: Priority-filtered root views (no dssview dependencies)
--------------------------------------------------------------------------------

-- 1. network.line — draft filter only
CREATE OR REPLACE VIEW dssview.network_line AS
SELECT l.line_id,
       l.name_i18n,
       l.short_name_i18n,
       l.primary_vehicle_mode,
       l.validity_start,
       l.validity_end,
       l.priority,
       l.label,
       l.type_of_line,
       l.description,
       l.transport_target,
       l.legacy_hsl_municipality_code,
       l.version_comment
FROM network.line l
WHERE l.priority < internal_utils.const_priority_draft();

-- 2. network.scheduled_stop_point — priority-flattened
CREATE OR REPLACE VIEW dssview.network_scheduled_stop_point AS
SELECT ssp.scheduled_stop_point_id,
       ssp.measured_location,
       ssp.located_on_infrastructure_link_id,
       ssp.direction,
       ssp.label,
       spans.validity_start,
       spans.validity_end,
       ssp.priority,
       ssp.timing_place_id,
       ssp.stop_place_ref
FROM network.maximum_priority_validity_spans(
  'scheduled_stop_point', NULL, '-infinity'::date, 'infinity'::date, internal_utils.const_priority_draft()
) spans
JOIN network.scheduled_stop_point ssp ON ssp.scheduled_stop_point_id = spans.id;

-- 3. timetables.vehicle_schedule_frame — draft+staging filter
CREATE OR REPLACE VIEW dssview.timetables_vehicle_schedule_frame AS
SELECT vsf.vehicle_schedule_frame_id,
       vsf.name_i18n,
       vsf.label,
       vsf.validity_start,
       vsf.validity_end,
       vsf.priority,
       vsf.validity_range,
       vsf.created_at,
       vsf.booking_label,
       vsf.booking_description_i18n
FROM timetables.vehicle_schedule_frame vsf
WHERE vsf.priority < internal_utils.const_priority_draft()
  AND vsf.priority != internal_utils.const_priority_staging();

--------------------------------------------------------------------------------
-- Phase C: Views depending on Phase B views
--------------------------------------------------------------------------------

-- 4. network.route — priority-flattened + EXISTS on dssview.network_line
CREATE OR REPLACE VIEW dssview.network_route AS
SELECT r.route_id,
       r.description_i18n,
       r.on_line_id,
       spans.validity_start,
       spans.validity_end,
       r.priority,
       r.label,
       r.direction,
       r.name_i18n,
       r.origin_name_i18n,
       r.origin_short_name_i18n,
       r.destination_name_i18n,
       r.destination_short_name_i18n,
       r.unique_label,
       r.variant,
       r.legacy_hsl_municipality_code,
       r.version_comment
FROM network.maximum_priority_validity_spans(
  'route', NULL, '-infinity'::date, 'infinity'::date, internal_utils.const_priority_draft()
) spans
JOIN network.route r ON r.route_id = spans.id
WHERE EXISTS (
  SELECT 1 FROM dssview.network_line l WHERE l.line_id = r.on_line_id
);

-- 5. network.scheduled_stop_points_with_infra_link_data — sources from dssview.network_scheduled_stop_point
CREATE OR REPLACE VIEW dssview.network_scheduled_stop_points_with_infra_link_data AS
SELECT ssp.scheduled_stop_point_id,
       ssp.measured_location,
       ssp.located_on_infrastructure_link_id,
       ssp.direction,
       ssp.label,
       ssp.validity_start,
       ssp.validity_end,
       ssp.priority,
       internal_utils.st_linelocatepoint(il.shape, ssp.measured_location) AS relative_distance_from_infrastructure_link_start
FROM dssview.network_scheduled_stop_point ssp
JOIN infrastructure_network.infrastructure_link il ON ssp.located_on_infrastructure_link_id = il.infrastructure_link_id;

-- 6. network.vehicle_mode_on_scheduled_stop_point — EXISTS on dssview.network_scheduled_stop_point
CREATE OR REPLACE VIEW dssview.network_vehicle_mode_on_scheduled_stop_point AS
SELECT vmosp.scheduled_stop_point_id,
       vmosp.vehicle_mode
FROM network.vehicle_mode_on_scheduled_stop_point vmosp
WHERE EXISTS (
  SELECT 1 FROM dssview.network_scheduled_stop_point ssp
  WHERE ssp.scheduled_stop_point_id = vmosp.scheduled_stop_point_id
);

-- 7. timetables.vehicle_service — EXISTS on dssview.timetables_vehicle_schedule_frame
CREATE OR REPLACE VIEW dssview.timetables_vehicle_service AS
SELECT vs.vehicle_service_id,
       vs.day_type_id,
       vs.vehicle_schedule_frame_id,
       vs.name_i18n
FROM timetables.vehicle_service vs
WHERE EXISTS (
  SELECT 1 FROM dssview.timetables_vehicle_schedule_frame vsf
  WHERE vsf.vehicle_schedule_frame_id = vs.vehicle_schedule_frame_id
);

--------------------------------------------------------------------------------
-- Phase D: Views depending on Phase C views
--------------------------------------------------------------------------------

-- 8. network.infrastructure_link_along_route — EXISTS on dssview.network_route
CREATE OR REPLACE VIEW dssview.network_infrastructure_link_along_route AS
SELECT ilar.route_id,
       ilar.infrastructure_link_id,
       ilar.infrastructure_link_sequence,
       ilar.is_traversal_forwards
FROM network.infrastructure_link_along_route ilar
WHERE EXISTS (
  SELECT 1 FROM dssview.network_route r
  WHERE r.route_id = ilar.route_id
);

-- 9. network.journey_pattern — EXISTS on dssview.network_route
CREATE OR REPLACE VIEW dssview.network_journey_pattern AS
SELECT jp.journey_pattern_id,
       jp.on_route_id
FROM network.journey_pattern jp
WHERE EXISTS (
  SELECT 1 FROM dssview.network_route r
  WHERE r.route_id = jp.on_route_id
);

-- 10. network.distance_between_stops_calculation — EXISTS on dssview.network_route
CREATE OR REPLACE VIEW dssview.network_distance_between_stops_calculation AS
SELECT dbs.journey_pattern_id,
       dbs.route_id,
       dbs.route_priority,
       dbs.observation_date,
       dbs.stop_interval_sequence,
       dbs.start_stop_label,
       dbs.end_stop_label,
       dbs.distance_in_metres
FROM network.distance_between_stops_calculation dbs
WHERE EXISTS (
  SELECT 1 FROM dssview.network_route r
  WHERE r.route_id = dbs.route_id
);

-- 10b. route.line_change_history — EXISTS on dssview.network_line OR dssview.network_route
CREATE OR REPLACE VIEW dssview.route_line_change_history AS
SELECT lch.id,
       lch.tg_operation,
       lch.line_id,
       lch.line_label,
       lch.line_priority,
       lch.line_validity_start,
       lch.line_validity_end,
       lch.route_id,
       lch.route_label,
       lch.route_direction,
       lch.route_validity_start,
       lch.route_validity_end,
       lch.name,
       lch.version_comment,
       lch.changed,
       lch.changed_by,
       lch.data
FROM route.line_change_history lch
WHERE EXISTS (
  SELECT 1 FROM dssview.network_line l WHERE l.line_id = lch.line_id
)
OR EXISTS (
  SELECT 1 FROM dssview.network_route r WHERE r.route_id = lch.route_id
);

-- 11. timetables.block — EXISTS on dssview.timetables_vehicle_service
CREATE OR REPLACE VIEW dssview.timetables_block AS
SELECT b.block_id,
       b.vehicle_service_id,
       b.preparing_time,
       b.finishing_time,
       b.vehicle_type_id
FROM timetables.block b
WHERE EXISTS (
  SELECT 1 FROM dssview.timetables_vehicle_service vs
  WHERE vs.vehicle_service_id = b.vehicle_service_id
);

--------------------------------------------------------------------------------
-- Phase E: Views depending on Phase D views
--------------------------------------------------------------------------------

-- 12. network.scheduled_stop_point_in_journey_pattern — EXISTS on dssview.network_journey_pattern
CREATE OR REPLACE VIEW dssview.network_scheduled_stop_point_in_journey_pattern AS
SELECT sspjp.journey_pattern_id,
       sspjp.scheduled_stop_point_sequence,
       sspjp.is_used_as_timing_point,
       sspjp.is_via_point,
       sspjp.via_point_name_i18n,
       sspjp.via_point_short_name_i18n,
       sspjp.scheduled_stop_point_label,
       sspjp.is_loading_time_allowed,
       sspjp.is_regulated_timing_point
FROM network.scheduled_stop_point_in_journey_pattern sspjp
WHERE EXISTS (
  SELECT 1 FROM dssview.network_journey_pattern jp
  WHERE jp.journey_pattern_id = sspjp.journey_pattern_id
);

-- 13. timetables.vehicle_journey — EXISTS on dssview.timetables_block
CREATE OR REPLACE VIEW dssview.timetables_vehicle_journey AS
SELECT vj.vehicle_journey_id,
       vj.journey_pattern_ref_id,
       vj.block_id,
       vj.journey_name_i18n,
       vj.turnaround_time,
       vj.layover_time,
       vj.journey_type,
       vj.displayed_name,
       vj.is_vehicle_type_mandatory,
       vj.is_backup_journey,
       vj.is_extra_journey,
       vj.contract_number
FROM timetables.vehicle_journey vj
WHERE EXISTS (
  SELECT 1 FROM dssview.timetables_block b
  WHERE b.block_id = vj.block_id
);

--------------------------------------------------------------------------------
-- Phase F: Views depending on Phase E views
--------------------------------------------------------------------------------

-- 14. timetables.journey_pattern_ref — EXISTS on dssview.timetables_vehicle_journey (reverse FK)
CREATE OR REPLACE VIEW dssview.timetables_journey_pattern_ref AS
SELECT jpr.journey_pattern_ref_id,
       jpr.journey_pattern_id,
       jpr.observation_timestamp,
       jpr.snapshot_timestamp,
       jpr.type_of_line,
       jpr.route_label,
       jpr.route_direction,
       jpr.route_validity_start,
       jpr.route_validity_end
FROM timetables.journey_pattern_ref jpr
WHERE EXISTS (
  SELECT 1 FROM dssview.timetables_vehicle_journey vj
  WHERE vj.journey_pattern_ref_id = jpr.journey_pattern_ref_id
);

--------------------------------------------------------------------------------
-- Phase G: Views depending on Phase F views
--------------------------------------------------------------------------------

-- 15. timetables.scheduled_stop_point_in_journey_pattern_ref — EXISTS on dssview.timetables_journey_pattern_ref
CREATE OR REPLACE VIEW dssview.timetables_scheduled_stop_point_in_journey_pattern_ref AS
SELECT sspjpr.scheduled_stop_point_in_journey_pattern_ref_id,
       sspjpr.journey_pattern_ref_id,
       sspjpr.scheduled_stop_point_label,
       sspjpr.scheduled_stop_point_sequence,
       sspjpr.timing_place_label
FROM timetables.scheduled_stop_point_in_journey_pattern_ref sspjpr
WHERE EXISTS (
  SELECT 1 FROM dssview.timetables_journey_pattern_ref jpr
  WHERE jpr.journey_pattern_ref_id = sspjpr.journey_pattern_ref_id
);

-- 16. timetables.journey_patterns_in_vehicle_service — EXISTS on dssview.timetables_vehicle_service AND dssview.timetables_journey_pattern_ref
CREATE OR REPLACE VIEW dssview.timetables_journey_patterns_in_vehicle_service AS
SELECT jpvs.vehicle_service_id,
       jpvs.journey_pattern_id,
       jpvs.reference_count
FROM timetables.journey_patterns_in_vehicle_service jpvs
WHERE EXISTS (
  SELECT 1 FROM dssview.timetables_vehicle_service vs
  WHERE vs.vehicle_service_id = jpvs.vehicle_service_id
)
AND EXISTS (
  SELECT 1 FROM dssview.timetables_journey_pattern_ref jpr
  WHERE jpr.journey_pattern_id = jpvs.journey_pattern_id
);

-- 17. timetables.timetabled_passing_time — EXISTS on dssview.timetables_vehicle_journey AND dssview.timetables_scheduled_stop_point_in_journey_pattern_ref
CREATE OR REPLACE VIEW dssview.timetables_timetabled_passing_time AS
SELECT tpt.timetabled_passing_time_id,
       tpt.vehicle_journey_id,
       tpt.scheduled_stop_point_in_journey_pattern_ref_id,
       tpt.arrival_time,
       tpt.departure_time,
       tpt.passing_time
FROM timetables.timetabled_passing_time tpt
WHERE EXISTS (
  SELECT 1 FROM dssview.timetables_vehicle_journey vj
  WHERE vj.vehicle_journey_id = tpt.vehicle_journey_id
)
AND EXISTS (
  SELECT 1 FROM dssview.timetables_scheduled_stop_point_in_journey_pattern_ref sspjpr
  WHERE sspjpr.scheduled_stop_point_in_journey_pattern_ref_id = tpt.scheduled_stop_point_in_journey_pattern_ref_id
);
