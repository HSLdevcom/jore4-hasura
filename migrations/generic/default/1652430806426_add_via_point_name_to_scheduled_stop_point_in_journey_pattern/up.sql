BEGIN;
  -- Add nullable via columns
  ALTER TABLE journey_pattern.scheduled_stop_point_in_journey_pattern
    ADD COLUMN via_point_name_i18n jsonb NULL DEFAULT NULL,
    ADD COLUMN via_point_short_name_i18n jsonb NULL DEFAULT NULL;
END;

BEGIN;
  -- Set default names for stops that are marked as via points
  UPDATE journey_pattern.scheduled_stop_point_in_journey_pattern
    SET via_point_name_i18n = '{"fi_FI":"VIA","sv_FI":"VIA"}',
        via_point_short_name_i18n = '{"fi_FI":"VIA","sv_FI":"VIA"}'
    WHERE is_via_point = TRUE;
END;

BEGIN;
  -- Add check constraint that is_via_point flag is set exactly when via point names are set
  ALTER TABLE journey_pattern.scheduled_stop_point_in_journey_pattern
    ADD CONSTRAINT ck_is_via_point_state
      CHECK((is_via_point = FALSE AND via_point_name_i18n IS NULL AND via_point_short_name_i18n IS NULL)
          OR (is_via_point = TRUE AND via_point_name_i18n IS NOT NULL AND via_point_short_name_i18n IS NOT NULL));

  -- Creation of indexes to be prepared to include names and short names in the name suggestion scheme.
  CREATE INDEX idx_scheduled_stop_point_in_journey_pattern_via_point_name_i18n
      ON journey_pattern.scheduled_stop_point_in_journey_pattern
      USING gin(via_point_name_i18n);
  CREATE INDEX idx_scheduled_stop_point_in_journey_pattern_via_point_short_name_i18n
      ON journey_pattern.scheduled_stop_point_in_journey_pattern
      USING gin(via_point_short_name_i18n);
END;
