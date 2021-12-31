ALTER TABLE journey_pattern.scheduled_stop_point_in_journey_pattern
  DROP CONSTRAINT scheduled_stop_point_in_journey_pattern_scheduled_stop_point_id_fkey,
  ADD CONSTRAINT scheduled_stop_point_in_journey_pa_scheduled_stop_point_id_fkey
    FOREIGN KEY (scheduled_stop_point_id)
      REFERENCES internal_service_pattern.scheduled_stop_point (scheduled_stop_point_id)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION;
