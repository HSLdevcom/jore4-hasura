DROP TRIGGER IF EXISTS record_history_after_route_journey_pattern_stop_points_inserted
  ON journey_pattern.scheduled_stop_point_in_journey_pattern;
DROP TRIGGER IF EXISTS record_history_after_route_journey_pattern_stop_points_updated
  ON journey_pattern.scheduled_stop_point_in_journey_pattern;
DROP TRIGGER IF EXISTS record_history_after_route_journey_pattern_stop_points_deleted
  ON journey_pattern.scheduled_stop_point_in_journey_pattern;
DROP FUNCTION IF EXISTS journey_pattern.record_history_after_route_journey_pattern_stop_points_changed();

DROP TRIGGER IF EXISTS record_history_after_route_infra_links_inserted
  ON route.infrastructure_link_along_route;
DROP TRIGGER IF EXISTS record_history_after_route_infra_links_updated
  ON route.infrastructure_link_along_route;
DROP TRIGGER IF EXISTS record_history_after_route_infra_links_deleted
  ON route.infrastructure_link_along_route;
DROP FUNCTION IF EXISTS route.record_history_after_route_infra_links_changed();

DROP TRIGGER IF EXISTS record_history_before_route_deleted ON route.route;
DROP FUNCTION IF EXISTS route.record_history_before_route_deleted();

DROP TRIGGER IF EXISTS record_history_after_route_upserted ON route.route;
DROP FUNCTION IF EXISTS route.record_history_after_route_upserted();

DROP TRIGGER IF EXISTS record_history_before_line_deleted ON route.line;
DROP FUNCTION IF EXISTS route.record_history_before_line_deleted();

DROP TRIGGER IF EXISTS record_history_after_line_upserted ON route.line;
DROP FUNCTION IF EXISTS route.record_history_after_line_upserted();

DROP FUNCTION IF EXISTS route.record_history_for_changed_route(tgOperation TEXT, routeId UUID);
DROP FUNCTION IF EXISTS route.record_history_for_changed_line(tgOperation TEXT, lineId UUID);
DROP FUNCTION IF EXISTS route.get_higher_priority_operation(previousOperation TEXT, nextOperation TEXT);
DROP FUNCTION IF EXISTS route.collect_line_info_for_history(UUID);

DROP TABLE IF EXISTS route.line_change_history;
