# dssview Schema Views — Working Plan

## This file is in the PR only for recreational purposes. It will be removed before merging to main.

## Overview

Create a repeatable migration under `migrations/hsl/main/` that generates `dssview.*` views mirroring all main database tables. Draft rows (priority ≥ 30) are excluded from **all** priority-aware views. Staging rows (priority = 40) are additionally excluded only from `vehicle_schedule_frame`, which is the only table that uses the staging priority. For `route` and `scheduled_stop_point`, overlapping validity periods are flattened into non-overlapping back-to-back spans using `network.maximum_priority_validity_spans()` — the view replaces the original `validity_start`/`validity_end` with the effective spans. For `line`, only draft filtering is needed (no overlapping non-draft priorities exist). For `vehicle_schedule_frame`, draft+staging filtering is needed (no overlapping non-draft priorities exist). Routes additionally exclude rows whose `on_line_id` points to a draft line. Views referencing draft-filterable parent tables (e.g. `vehicle_service` → `vehicle_schedule_frame`, `journey_pattern` → `route`) also exclude rows belonging to draft parents. View names use schema-prefixed table names (e.g. `dssview.network_line`). All dssview migrations reside under `hsl/`, not `generic/`. Views must be created in dependency order (parent views before child views that reference them). **All SELECT statements must explicitly list all columns — `SELECT *` is never used.**

## Steps

### Phase 1: Working document
1. ✅ Create this plan document

### Phase 2: Migration file
2. Create repeatable migration: `migrations/hsl/main/2000000010001_R_after_migrate_dssview/up.sql` and `down.sql`
3. For **simple tables** (enums, refs, non-priority tables): `CREATE OR REPLACE VIEW dssview.<schema>_<table> AS SELECT <explicit column list> FROM <schema>.<table>`
4. For **draft-filtered tables** (tables with a `priority` column, or referencing a draft-filterable parent): filter out rows with `priority >= internal_utils.const_priority_draft()` or whose parent has draft priority
5. For **flattened tables** (`route`, `scheduled_stop_point`): use `network.maximum_priority_validity_spans()` with `'-infinity'`/`'infinity'` as validity range, joined back to the source table. The effective `validity_start`/`validity_end` from spans **replace** the original columns.
6. For `line`: draft filter only (`WHERE priority < internal_utils.const_priority_draft()`). No flattening needed.
6b. For `vehicle_schedule_frame`: draft+staging filter (`WHERE priority < internal_utils.const_priority_draft() AND priority != internal_utils.const_priority_staging()`). No flattening needed.
7. For `route`: additionally filter out routes whose `on_line_id` references a draft line (via `EXISTS` against `dssview.network_line`).
8. `down.sql`: `SELECT 1;` (repeatable migration convention — objects dropped by before-migrate)

### Phase 3: Before-migrate integration
9. Create HSL-specific before-migrate at `migrations/hsl/main/0999999999999_R_before_migrate/up.sql` (runs before `generic/main/1000000000000_R_before_migrate`) to dynamically drop all views in the `dssview` schema by querying `information_schema.views`. `down.sql`: `SELECT 1;`. Must reside under `migrations/hsl/`, not `generic/`. The `dssview` schema itself is **not** dropped (it is created and owned by the external infrastructure repository).

### Phase 4: Verification
10. Apply migration against running testdb with `hasura migrate apply`
11. Query each `dssview.*` view to confirm they return data
12. Verify flattened views produce non-overlapping back-to-back validity spans
13. Verify no draft-priority rows appear in any view

## Key Decisions

| Decision | Choice | Rationale |
|---|---|---|
| Tables included | All (enums, data, `return_value.*`) | Full mirror of the database |
| i18n jsonb columns | Keep as-is | Consumer picks language |
| Geography columns | Keep as-is (PostGIS native) | No conversion overhead |
| Migration type | Repeatable (`_R_` prefix) | Views must stay in sync with table changes |
| Draft exclusion | `priority < internal_utils.const_priority_draft()` (= 30) | Drafts excluded from **all** priority-aware views, including dependent child tables |
| Staging exclusion | Only on `vehicle_schedule_frame` | Staging priority (= 40) is only used by `vehicle_schedule_frame`; other tables do not use it |
| Explicit column lists | **Always** list all columns explicitly; never use `SELECT *` | Design decision: ensures views break visibly when source tables change, and documents the expected schema |
| Permission grants | None in migration | Handled externally in DB setup repo |
| `dssview` schema creation | External | Created by external infrastructure repository; not managed here |
| View naming | Schema-prefixed: `dssview.<schema>_<table>` | Avoids collisions (e.g. `infrastructure_network_direction` vs `network_route_direction`) |
| Migration location | All under `migrations/hsl/`, never `generic/` | dssview is HSL-specific |
| `line` flattening | Draft filter only, no priority flattening | Non-draft lines never have overlapping validity for the same label. No staging priority on lines. |
| `vehicle_schedule_frame` flattening | Draft+staging filter only, no priority flattening | No overlapping non-draft priorities. Staging is used for VSF. |
| `route` line filtering | Routes must reference a non-draft line | `on_line_id` must exist in `dssview.network_line` |
| View creation order | Dependency order: parent views first | Child views reference parent dssview views via EXISTS |
| Before-migrate drop | Dynamic: query `information_schema.views` | Drop all views in `dssview` schema dynamically at runtime; do not drop the schema itself |

## Relevant Source Files

- `migrations/generic/main/1100000000002_init_infrastructure_network/up.sql` — all `network.*` and `infrastructure_network.*` table definitions
- `migrations/generic/main/1100000000003_init_timetables/up.sql` — all `timetables.*` table definitions
- `migrations/hsl/main/1100000000100_init_hsl_network/up.sql` — HSL additions to `line`, `route`
- `migrations/hsl/main/1100000000101_init_hsl_timetables/up.sql` — HSL timetable additions
- `migrations/hsl/main/1100000000102_init_hsl_timetables_2/up.sql` — `substitute_operating_period`, `return_value.*`
- `migrations/hsl/default/1772618500000_line_route_change_history/up.sql` — `route.line_change_history` table
- `migrations/generic/main/2000000000004_R_after_migrate_create_journey_pattern/up.sql` — `maximum_priority_validity_spans()` function
- `migrations/generic/main/1000000000000_R_before_migrate/up.sql` — schema creation and drop utilities

## View Categories

Views fall into four categories based on how they handle priority/validity:

### Category 1: Priority-flattened views
Overlapping validity periods resolved into non-overlapping back-to-back spans. Drafts excluded.

| Source Table | View Name | Flattening Key(s) | Method |
|---|---|---|---|
| `network.route` | `dssview.network_route` | `(label, direction)` | `maximum_priority_validity_spans('route', ...)` |
| `network.scheduled_stop_point` | `dssview.network_scheduled_stop_point` | `(label)` | `maximum_priority_validity_spans('scheduled_stop_point', ...)` |

### Category 2: Draft-filtered views
Tables with a `priority` column where only draft (and optionally staging) filtering is needed (no overlapping non-draft priorities).

| Source Table | View Name | Filter |
|---|---|---|
| `network.line` | `dssview.network_line` | `WHERE priority < internal_utils.const_priority_draft()` |
| `timetables.vehicle_schedule_frame` | `dssview.timetables_vehicle_schedule_frame` | `WHERE priority < internal_utils.const_priority_draft() AND priority != internal_utils.const_priority_staging()` |

> **Note:** Only `vehicle_schedule_frame` uses the staging priority. The `line` table does not have staging rows, so the staging filter is not applied there.

### Category 3: Parent-filtered views
Tables that reference a draft-filterable parent. Rows belonging to draft parents are excluded via JOIN/subquery.

| Source Table | View Name | Parent FK | Parent View |
|---|---|---|---|
| `network.route` (via `on_line_id`) | *(already in Cat 1)* | `line.line_id` | `dssview.network_line` |
| `network.infrastructure_link_along_route` | `dssview.network_infrastructure_link_along_route` | `route.route_id` | `dssview.network_route` |
| `timetables.vehicle_service` | `dssview.timetables_vehicle_service` | `vehicle_schedule_frame.vehicle_schedule_frame_id` | `dssview.timetables_vehicle_schedule_frame` |
| `timetables.block` | `dssview.timetables_block` | `vehicle_service.vehicle_service_id` | `dssview.timetables_vehicle_service` |
| `timetables.vehicle_journey` | `dssview.timetables_vehicle_journey` | `block.block_id` | `dssview.timetables_block` |
| `timetables.timetabled_passing_time` | `dssview.timetables_timetabled_passing_time` | `vehicle_journey.vehicle_journey_id` + `scheduled_stop_point_in_journey_pattern_ref.scheduled_stop_point_in_journey_pattern_ref_id` | `dssview.timetables_vehicle_journey` + `dssview.timetables_scheduled_stop_point_in_journey_pattern_ref` |
| `timetables.journey_patterns_in_vehicle_service` | `dssview.timetables_journey_patterns_in_vehicle_service` | `vehicle_service.vehicle_service_id` + `journey_pattern_ref.journey_pattern_ref_id` | `dssview.timetables_vehicle_service` + `dssview.timetables_journey_pattern_ref` |
| `timetables.journey_pattern_ref` | `dssview.timetables_journey_pattern_ref` | *(reverse FK)* `vehicle_journey.journey_pattern_ref_id` | `dssview.timetables_vehicle_journey` |
| `timetables.scheduled_stop_point_in_journey_pattern_ref` | `dssview.timetables_scheduled_stop_point_in_journey_pattern_ref` | `journey_pattern_ref.journey_pattern_ref_id` | `dssview.timetables_journey_pattern_ref` |
| `network.vehicle_mode_on_scheduled_stop_point` | `dssview.network_vehicle_mode_on_scheduled_stop_point` | `scheduled_stop_point.scheduled_stop_point_id` | `dssview.network_scheduled_stop_point` |
| `network.scheduled_stop_points_with_infra_link_data` *(view)* | `dssview.network_scheduled_stop_points_with_infra_link_data` | Sources from `dssview.network_scheduled_stop_point` | `dssview.network_scheduled_stop_point` |
| `network.journey_pattern` | `dssview.network_journey_pattern` | `route.route_id` (via `on_route_id`) | `dssview.network_route` |
| `network.scheduled_stop_point_in_journey_pattern` | `dssview.network_scheduled_stop_point_in_journey_pattern` | `journey_pattern.journey_pattern_id` | `dssview.network_journey_pattern` |
| `network.distance_between_stops_calculation` | `dssview.network_distance_between_stops_calculation` | `route.route_id` | `dssview.network_route` |
| `route.line_change_history` | `dssview.route_line_change_history` | `line.line_id` OR `route.route_id` | `dssview.network_line` + `dssview.network_route` |

### Category 4: Simple pass-through views
No priority or draft concerns. Explicit column lists (no `SELECT *`).

### Flattening approach for `route` and `scheduled_stop_point`

```sql
-- Example: dssview.network_route
-- Note: spans.validity_start/validity_end REPLACE the original columns
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
```

The view joins the flattened spans back to the source table, **replacing** the original `validity_start`/`validity_end` with the effective (non-overlapping) validity window. Routes whose `on_line_id` references a draft line are excluded via the `EXISTS` check.

```sql
-- Example: dssview.network_scheduled_stop_point
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
```

### `scheduled_stop_points_with_infra_link_data` view

The existing view `network.scheduled_stop_points_with_infra_link_data` joins `scheduled_stop_point` with `infrastructure_link`. The dssview version mirrors this but sources from the priority-flattened `dssview.network_scheduled_stop_point`:

```sql
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
```

### Approach for `line` (draft filter only)

Lines only have base priority and "draft" priority. Non-draft lines never have overlapping validity for the same label, so no priority flattening is needed — a simple `WHERE` filter suffices. Staging priority is not used for lines.

```sql
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
```

### Approach for `vehicle_schedule_frame` (draft+staging filter)

No overlapping non-draft priorities exist for `vehicle_schedule_frame`. Draft+staging filter (staging is used by this table):

```sql
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
```

### Views filtered based on non-draft vehicle_schedule_frames

```sql
-- 1. vehicle_schedule_frame (priority-filtered root — defined above)

-- 2. vehicle_service → vehicle_schedule_frame
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

-- 3. block → vehicle_service
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

-- 4. vehicle_journey → block
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

-- 5. journey_pattern_ref ← vehicle_journey (keep only those referenced by surviving journeys)
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

-- 6. scheduled_stop_point_in_journey_pattern_ref → journey_pattern_ref
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

-- 7. timetabled_passing_time → vehicle_journey AND → scheduled_stop_point_in_journey_pattern_ref
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

-- 8. journey_patterns_in_vehicle_service → vehicle_service AND → journey_pattern_ref
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
```

The chain:

# | View | Filters by
--|------|-----------
1 | vehicle_schedule_frame                      | priority directly
2 | vehicle_service                             | vehicle_schedule_frame_id ∈ dssview (1)
3 | block                                       | vehicle_service_id ∈ dssview (2)
4 | vehicle_journey                             | block_id ∈ dssview (3)
5 | journey_pattern_ref                         | referenced by journey_pattern_ref_id in dssview (4)
6 | scheduled_stop_point_in_journey_pattern_ref | journey_pattern_ref_id ∈ dssview (5)
7 | timetabled_passing_time                     | vehicle_journey_id ∈ dssview (4) AND scheduled_stop_point_in_journey_pattern_ref_id ∈ dssview (6)
8 | journey_patterns_in_vehicle_service         | vehicle_service_id ∈ dssview (2) AND journey_pattern_id ∈ dssview (5)

**Note that view 5** (`journey_pattern_ref`) **uses a reverse FK** — `vehicle_journey` points to `journey_pattern_ref`, so the view keeps only those `journey_pattern_ref` rows that are actually referenced by a surviving `vehicle_journey`. All others use direct FK filtering via EXISTS.

### Views filtered based on non-draft scheduled_stop_points

`vehicle_mode_on_scheduled_stop_point` has a direct FK to `scheduled_stop_point_id`.

```sql
-- vehicle_mode_on_scheduled_stop_point → scheduled_stop_point
CREATE OR REPLACE VIEW dssview.network_vehicle_mode_on_scheduled_stop_point AS
SELECT vmosp.scheduled_stop_point_id,
       vmosp.vehicle_mode
FROM network.vehicle_mode_on_scheduled_stop_point vmosp
WHERE EXISTS (
  SELECT 1 FROM dssview.network_scheduled_stop_point ssp
  WHERE ssp.scheduled_stop_point_id = vmosp.scheduled_stop_point_id
);
```

### Views filtered based on non-draft routes

```sql
-- infrastructure_link_along_route → route
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

-- journey_pattern → route
CREATE OR REPLACE VIEW dssview.network_journey_pattern AS
SELECT jp.journey_pattern_id,
       jp.on_route_id
FROM network.journey_pattern jp
WHERE EXISTS (
  SELECT 1 FROM dssview.network_route r
  WHERE r.route_id = jp.on_route_id
);

-- distance_between_stops_calculation → route
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

-- line_change_history → line OR route (keep row if either parent survives)
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
```

### Views filtered based on non-draft journey_patterns

```sql
-- scheduled_stop_point_in_journey_pattern → journey_pattern
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
```

## Required View Creation Order

Views must be created in dependency order in `up.sql`. Child views that reference parent dssview views via `EXISTS` will fail if the parent view does not yet exist. The `CREATE OR REPLACE VIEW` statements in `up.sql` must follow this ordering:

### Phase A: Pass-through views (no dependencies on other dssview views)
All Category 4 views can be created in any order.

### Phase B: Priority-filtered root views (no dssview dependencies)
1. `dssview.network_line` — draft filter only
2. `dssview.network_scheduled_stop_point` — priority-flattened via `maximum_priority_validity_spans`
3. `dssview.timetables_vehicle_schedule_frame` — draft+staging filter

### Phase C: Views depending on Phase B views
4. `dssview.network_route` — priority-flattened + `EXISTS` on `dssview.network_line` *(depends on 1)*
5. `dssview.network_scheduled_stop_points_with_infra_link_data` — sources from `dssview.network_scheduled_stop_point` *(depends on 2)*
6. `dssview.network_vehicle_mode_on_scheduled_stop_point` — `EXISTS` on `dssview.network_scheduled_stop_point` *(depends on 2)*
7. `dssview.timetables_vehicle_service` — `EXISTS` on `dssview.timetables_vehicle_schedule_frame` *(depends on 3)*

### Phase D: Views depending on Phase C views
8. `dssview.network_infrastructure_link_along_route` — `EXISTS` on `dssview.network_route` *(depends on 4)*
9. `dssview.network_journey_pattern` — `EXISTS` on `dssview.network_route` *(depends on 4)*
10. `dssview.network_distance_between_stops_calculation` — `EXISTS` on `dssview.network_route` *(depends on 4)*
10b. `dssview.route_line_change_history` — `EXISTS` on `dssview.network_line` OR `dssview.network_route` *(depends on 1, 4)*
11. `dssview.timetables_block` — `EXISTS` on `dssview.timetables_vehicle_service` *(depends on 7)*

### Phase E: Views depending on Phase D views
12. `dssview.network_scheduled_stop_point_in_journey_pattern` — `EXISTS` on `dssview.network_journey_pattern` *(depends on 9)*
13. `dssview.timetables_vehicle_journey` — `EXISTS` on `dssview.timetables_block` *(depends on 11)*

### Phase F: Views depending on Phase E views
14. `dssview.timetables_journey_pattern_ref` — `EXISTS` on `dssview.timetables_vehicle_journey` *(depends on 13)*

### Phase G: Views depending on Phase F views
15. `dssview.timetables_scheduled_stop_point_in_journey_pattern_ref` — `EXISTS` on `dssview.timetables_journey_pattern_ref` *(depends on 14)*
16. `dssview.timetables_journey_patterns_in_vehicle_service` — `EXISTS` on `dssview.timetables_vehicle_service` AND `dssview.timetables_journey_pattern_ref` *(depends on 7, 14)*
17. `dssview.timetables_timetabled_passing_time` — `EXISTS` on `dssview.timetables_vehicle_journey` AND `dssview.timetables_scheduled_stop_point_in_journey_pattern_ref` *(depends on 13, 15)*

### Dependency graph (DAG)

```
network_line ──────────────────────────────┐
                                           ▼
               network_route ◄─── (on_line_id EXISTS)
                   │
                   ├──► network_infrastructure_link_along_route
                   ├──► network_journey_pattern
                   │        │
                   │        ▼
                   │    network_scheduled_stop_point_in_journey_pattern
                   │
                   └──► network_distance_between_stops_calculation
                   │
network_line ──────┼──► route_line_change_history ◄── network_route
                   │
network_scheduled_stop_point
    │           │
    │           ▼
    │    network_scheduled_stop_points_with_infra_link_data
    ▼
  network_vehicle_mode_on_scheduled_stop_point

timetables_vehicle_schedule_frame
    │
    ▼
timetables_vehicle_service ──────────────┐
    │                                    │
    ▼                                    │
timetables_block                         │
    │                                    │
    ▼                                    │
timetables_vehicle_journey               │
    │           │                        │
    ▼           ▼                        │
timetables_  timetables_                 │
journey_     timetabled_                 │
pattern_ref  passing_time ◄──┐           │
    │   │                    │           │
    │   ▼                    │           │
    │ timetables_scheduled_  │           │
    │ stop_point_in_         │           │
    │ journey_pattern_ref ───┘           │
    │                                    │
    ▼                                    ▼
timetables_journey_patterns_in_vehicle_service
```

## Simple Pass-Through Views (Category 4)

These tables have no priority/draft concerns and get explicit column list views.

### Infrastructure Network

| Source Table | View Name |
|---|---|
| `infrastructure_network.external_source` | `dssview.infrastructure_network_external_source` |
| `infrastructure_network.direction` | `dssview.infrastructure_network_direction` |
| `infrastructure_network.infrastructure_link` | `dssview.infrastructure_network_infrastructure_link` |
| `infrastructure_network.vehicle_submode_on_infrastructure_link` | `dssview.infrastructure_network_vehicle_submode_on_infrastructure_link` |

### Reusable Components

| Source Table | View Name |
|---|---|
| `reusable_components.vehicle_mode` | `dssview.reusable_components_vehicle_mode` |
| `reusable_components.vehicle_submode` | `dssview.reusable_components_vehicle_submode` |

### Network (non-priority, non-dependent)

| Source Table | View Name |
|---|---|
| `network.route_direction` | `dssview.network_route_direction` |
| `network.type_of_line` | `dssview.network_type_of_line` |
| `network.transport_target` | `dssview.network_transport_target` |
| `network.legacy_hsl_municipality_code` | `dssview.network_legacy_hsl_municipality_code` |
| `network.timing_place` | `dssview.network_timing_place` |
| `network.scheduled_stop_point_invariant` | `dssview.network_scheduled_stop_point_invariant` |

### Timetables (non-dependent)

| Source Table | View Name |
|---|---|
| `timetables.day_type` | `dssview.timetables_day_type` |
| `timetables.vehicle_type` | `dssview.timetables_vehicle_type` |
| `timetables.journey_type` | `dssview.timetables_journey_type` |
| `timetables.day_type_active_on_day_of_week` | `dssview.timetables_day_type_active_on_day_of_week` |
| `timetables.substitute_operating_day_by_line_type` | `dssview.timetables_substitute_operating_day_by_line_type` |
| `timetables.substitute_operating_period` | `dssview.timetables_substitute_operating_period` |

### Return Value (dummy/function-return tables)

| Source Table | View Name |
|---|---|
| `return_value.timetable_version` | `dssview.return_value_timetable_version` |
| `return_value.vehicle_schedule` | `dssview.return_value_vehicle_schedule` |

## Resolved Questions

1. ✅ **`line` flattening**: No flattening needed. Non-draft lines never overlap for the same label. Simple `WHERE priority < const_priority_draft()` filter suffices. No staging priority on lines.
2. ✅ **`vehicle_schedule_frame` flattening**: No flattening needed. Same rationale as `line`. Draft+staging filter (staging is only used by this table).
3. ✅ **View naming**: Schema-prefixed table names: `dssview.<schema>_<table>` (e.g. `dssview.network_line`, `dssview.infrastructure_network_direction`).
4. ✅ **Before-migrate drop**: All dssview migrations reside under `migrations/hsl/`, not `generic/`. HSL-specific before-migrate script dynamically drops all views by querying `information_schema.views`.
5. ✅ **`infrastructure_link_along_route`**: Filtered — only include links for non-draft routes (Category 3: parent-filtered via `route_id`).
6. ✅ **Dependent tables**: Yes — `vehicle_service`, `block`, `vehicle_journey`, `timetabled_passing_time`, `journey_patterns_in_vehicle_service`, `journey_pattern_ref`, `scheduled_stop_point_in_journey_pattern_ref`, `vehicle_mode_on_scheduled_stop_point`, `journey_pattern`, `scheduled_stop_point_in_journey_pattern`, `distance_between_stops_calculation`, and `line_change_history` all filter out rows belonging to draft parents (Category 3).
7. ✅ **Route → line filtering**: Routes whose `on_line_id` references a draft line are excluded via `EXISTS` against `dssview.network_line`.
8. ✅ **`scheduled_stop_points_with_infra_link_data`**: Mirrored in dssview, sourced from `dssview.network_scheduled_stop_point` (inherits priority flattening).
9. ✅ **View creation order**: Views must be created in dependency order — parent views before child views. Full ordering specified in "Required View Creation Order" section.
10. ✅ **Staging priority scope**: `const_priority_staging()` is only used for `vehicle_schedule_frame`, which is the only table that actually uses the staging priority. Other tables use only `WHERE priority < const_priority_draft()`.
11. ✅ **`journey_patterns_in_vehicle_service`**: Filtered by EXISTS against both `dssview.timetables_vehicle_service` and `dssview.timetables_journey_pattern_ref`.
12. ✅ **Migration numbering**: Before-migrate: `0999999999999_R_before_migrate` (runs before generic). After-migrate: `2000000010001_R_after_migrate_dssview` (runs after all other migrations, since views depend on the final form of all tables and functions).
13. ✅ **`journey_pattern` filtering**: Parent-filtered via `on_route_id` against `dssview.network_route` (Category 3, not Category 4).
14. ✅ **`scheduled_stop_point_in_journey_pattern` filtering**: Parent-filtered via `journey_pattern_id` against `dssview.network_journey_pattern` (Category 3, not Category 4). Links to stop points by label via `scheduled_stop_point_invariant`, not by `scheduled_stop_point_id`, so stop point priority filtering does not affect it — only journey pattern parent filtering does.
15. ✅ **`distance_between_stops_calculation` filtering**: Parent-filtered via `route_id` against `dssview.network_route` (Category 3, not Category 4).
16. ✅ **Explicit column lists**: All SELECT statements explicitly list all columns. `SELECT *` is never used. This is a design decision to make views break visibly when source tables change.
17. ✅ **`dssview` schema creation**: Handled by external infrastructure repository, not in these migrations.

## Resolved Review Questions

| # | Question | Resolution |
|---|---|---|
| OQ-1 | Staging filter on `vehicle_schedule_frame` is logically redundant (`< 30` already excludes `= 40`) | **By design.** Priority values may change in future. Keep explicit staging exclusion. |
| OQ-2 | Exact migration directory names | **Before-migrate:** `migrations/hsl/main/0999999999999_R_before_migrate/` (runs before generic `1000000000000`). **After-migrate:** `migrations/hsl/main/2000000010001_R_after_migrate_dssview/` |
| OQ-3 | `down.sql` convention for `_R_` scripts | `SELECT 1;` suffices. |
| OQ-4 | `scheduled_stop_points_with_infra_link_data` had extra columns | **Fixed.** Extra columns removed from plan. View now matches original shape. |
| OQ-5 | `return_value.*` tables are function return type containers (always 0 rows) | **By design.** Include for completeness. |
| OQ-6 | No explicit SQL for Category 4 views | **Not needed.** Trivial pass-through views don't need SQL in the plan. |
| OQ-7 | `maximum_priority_validity_spans()` entity type strings | **Verified.** `'route'` and `'scheduled_stop_point'` are correct. |

### Verified Observations
- All explicit column lists verified correct against migration files.
- Dependency graph and view creation order are correct.
- Generated columns (`unique_label`, `validity_range`, `passing_time`, `begin_datetime`, `end_datetime`) are STORED and selectable through views.
- `journey_patterns_in_vehicle_service` filtering via `journey_pattern_id` (not `journey_pattern_ref_id`) is correct.

## Before-Migrate Approach

Location: `migrations/hsl/main/0999999999999_R_before_migrate/up.sql` (runs before generic `1000000000000_R_before_migrate`). `down.sql`: `SELECT 1;`.

The HSL before-migrate script dynamically drops all views in the `dssview` schema by querying the database catalog. The schema itself is **not** dropped.

```sql
-- Drop all views in the dssview schema dynamically
DO $$
DECLARE
  view_record RECORD;
BEGIN
  FOR view_record IN (
    SELECT table_schema, table_name
    FROM information_schema.views
    WHERE table_schema = 'dssview'
  )
  LOOP
    RAISE NOTICE 'Dropping view: %.%', view_record.table_schema, view_record.table_name;
    EXECUTE 'DROP VIEW IF EXISTS ' || quote_ident(view_record.table_schema) || '.' || quote_ident(view_record.table_name) || ' CASCADE;';
  END LOOP;
END;
$$;
```

> **Note:** `CASCADE` is used because child views depend on parent views. The ordering of drops does not matter with `CASCADE`. If the `dssview` schema contains functions in the future, `internal_utils.drop_functions(ARRAY['dssview'])` (from `1000000000000_R_before_migrate/up.sql`) can be reused.
