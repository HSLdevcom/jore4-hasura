ALTER TABLE journey_pattern.scheduled_stop_point_in_journey_pattern
  DROP CONSTRAINT scheduled_stop_point_in_journey_pattern_journey_pattern_id_fkey,
  ADD CONSTRAINT scheduled_stop_point_in_journey_pattern_journey_pattern_id_fkey
    FOREIGN KEY (journey_pattern_id)
      REFERENCES journey_pattern.journey_pattern (journey_pattern_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE;
