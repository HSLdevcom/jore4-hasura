ALTER TABLE journey_pattern.scheduled_stop_point_in_journey_pattern
    ADD COLUMN via_point_name_i18n JSONB NULL,
    ADD COLUMN via_point_short_name_i18n JSONB NULL;
CREATE INDEX idx_scheduled_stop_point_in_journey_pattern_via_point_name_i18n
    ON journey_pattern.scheduled_stop_point_in_journey_pattern 
    USING gin (via_point_name_i18n);
CREATE INDEX idx_scheduled_stop_point_in_journey_pattern_via_point_short_name_i18n 
    ON journey_pattern.scheduled_stop_point_in_journey_pattern 
    USING gin (via_point_short_name_i18n);