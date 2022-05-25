DROP INDEX journey_pattern.idx_scheduled_stop_point_in_journey_pattern_via_point_name_i18n;
DROP INDEX journey_pattern.idx_scheduled_stop_point_in_journey_pattern_via_point_short_name_i18n;
ALTER TABLE journey_pattern.scheduled_stop_point_in_journey_pattern
    DROP CONSTRAINT is_via_point,
    DROP COLUMN via_point_name_i18n,
    DROP COLUMN via_point_short_name_i18n;
    
