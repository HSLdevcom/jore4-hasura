CREATE OR REPLACE VIEW network.route_search AS
WITH
  latest_change AS (
    SELECT DISTINCT ON (line_id, route_id) *
    FROM network.line_change_history
    -- Include line_id & route_id in the order by, so that it matches the index
    -- history_unique_line_route_combo_per_transaction, that way we can do a
    -- direct lookup from the index, without having to do a full table scan.
    ORDER BY line_id, route_id, changed DESC
  )

SELECT
  ---- Route fields
  -- Route — ID fields
  route.route_id,

  -- Route — Name field
  route.label AS route_label,
  route.variant AS route_variant,
  route.direction AS route_direction,
  route.name_i18n->>'fi_FI' AS route_name_fi,
  route.unique_label AS route_unique_label,

  -- Route — Validity fields
  route.validity_start AS route_validity_start,
  route.validity_end AS route_validity_end,
  route.priority AS route_priority,

  -- Route — Last changed fields
  lrc.changed AS route_last_changed,
  lrc.changed_by AS route_last_changed_by,
  lrc.version_comment AS route_version_comment,


  ---- Line fields
  -- Line — ID fields
  line.line_id,

  -- Line — Name fields
  line.label AS line_label,
  substring(line.label, '^\d+' )::INT AS line_number,
  line.name_i18n->>'fi_FI' AS line_name_fi,

  -- Line — Detail fields
  line.primary_vehicle_mode AS line_primary_vehicle_mode,
  line.type_of_line AS line_type_of_line,

  -- Line — Validity fields
  line.validity_start AS line_validity_start,
  line.validity_end AS line_validity_end,
  line.priority AS line_priority,

  -- Line — Last changed fields
  llc.changed AS line_last_changed,
  llc.changed_by AS line_last_changed_by,
  llc.version_comment AS line_version_comment

FROM network.route
INNER JOIN network.line ON line.line_id = route.on_line_id

-- Include line ID in the JOIN, so we can leverage the row uniqueness index.
LEFT JOIN latest_change AS lrc ON lrc.line_id = route.on_line_id AND lrc.route_id = route.route_id
LEFT JOIN latest_change AS llc ON llc.line_id = route.on_line_id AND llc.route_id IS NULL;
