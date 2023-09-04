ALTER TABLE journey_pattern.journey_pattern_ref
  ADD COLUMN route_label text NOT NULL;

ALTER TABLE journey_pattern.journey_pattern_ref
  ADD COLUMN route_direction text NOT NULL;

ALTER TABLE journey_pattern.journey_pattern_ref
  ADD COLUMN route_validity_start date;

ALTER TABLE journey_pattern.journey_pattern_ref
  ADD COLUMN route_validity_end date;

COMMENT ON COLUMN journey_pattern.journey_pattern_ref.route_label IS 'The label of the route associated with the referenced journey pattern';
COMMENT ON COLUMN journey_pattern.journey_pattern_ref.route_direction IS 'The direction of the route associated with the referenced journey pattern';
COMMENT ON COLUMN journey_pattern.journey_pattern_ref.route_validity_start IS 'The start date of the validity period of the route associated with the referenced journey pattern. If NULL, then the start of the validity period is unbounded (-infinity).';
COMMENT ON COLUMN journey_pattern.journey_pattern_ref.route_validity_end IS 'The end date of the validity period of the route associated with the referenced journey pattern. If NULL, then the end of the validity period is unbounded (infinity).';
