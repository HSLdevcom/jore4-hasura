---------- Drop columns from Scheduled Stop Point in Journey Pattern Ref ----------

ALTER TABLE service_pattern.scheduled_stop_point_in_journey_pattern_ref
  DROP COLUMN timing_place_label;

---------- Drop columns from Journey Pattern Ref ----------

ALTER TABLE journey_pattern.journey_pattern_ref
  DROP COLUMN route_validity_end;

ALTER TABLE journey_pattern.journey_pattern_ref
  DROP COLUMN route_validity_start;

ALTER TABLE journey_pattern.journey_pattern_ref
  DROP COLUMN route_direction;

ALTER TABLE journey_pattern.journey_pattern_ref
  DROP COLUMN route_label;

---------- Drop table Route Direction ----------

DROP TABLE route.direction;
