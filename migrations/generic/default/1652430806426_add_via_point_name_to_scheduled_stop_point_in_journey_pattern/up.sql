ALTER TABLE journey_pattern.scheduled_stop_point_in_journey_pattern
    ADD COLUMN via_point_name_i18n JSONB NULL DEFAULT NULL,
    ADD COLUMN via_point_short_name_i18n JSONB NULL DEFAULT NULL,
    ADD CONSTRAINT ck_is_via_point_state
        CHECK((is_via_point = false AND via_point_name_i18n IS NULL AND via_point_short_name_i18n IS NULL) OR 
        (is_via_point = true AND via_point_name_i18n IS NOT NULL AND via_point_short_name_i18n IS NOT NULL));
-- Creation of indexes to be prepared to include names and short names in the name suggestion scheme.
CREATE INDEX idx_scheduled_stop_point_in_journey_pattern_via_point_name_i18n
    ON journey_pattern.scheduled_stop_point_in_journey_pattern 
    USING gin (via_point_name_i18n);
CREATE INDEX idx_scheduled_stop_point_in_journey_pattern_via_point_short_name_i18n 
    ON journey_pattern.scheduled_stop_point_in_journey_pattern 
    USING gin (via_point_short_name_i18n);