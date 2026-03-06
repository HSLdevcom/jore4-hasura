DROP TRIGGER IF EXISTS record_history_before_route_deleted ON route.route;
DROP FUNCTION IF EXISTS route.record_history_before_route_deleted;

DROP TRIGGER IF EXISTS record_history_after_route_upserted ON route.route;
DROP FUNCTION IF EXISTS route.record_history_after_route_upserted;

DROP TRIGGER IF EXISTS record_history_before_line_deleted ON route.line;
DROP FUNCTION IF EXISTS route.record_history_before_line_deleted;

DROP TRIGGER IF EXISTS record_history_after_line_upserted ON route.line;
DROP FUNCTION IF EXISTS route.record_history_after_line_upserted;

DROP FUNCTION IF EXISTS route.collect_line_info_for_history(UUID);

DROP TABLE IF EXISTS route.line_change_history;
