ALTER TABLE network.scheduled_stop_point_in_journey_pattern
  ADD COLUMN is_destination_point boolean NOT NULL DEFAULT false,
  ADD COLUMN destination_point_name_i18n jsonb,
  ADD COLUMN destination_point_short_name_i18n jsonb;
