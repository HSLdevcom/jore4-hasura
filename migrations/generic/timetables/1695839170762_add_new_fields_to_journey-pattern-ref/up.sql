---------- Add Route Direction ----------

CREATE TABLE route.direction (
  direction text NOT NULL,
  the_opposite_of_direction text
);

COMMENT ON TABLE route.direction IS 'The route directions from Transmodel';
COMMENT ON COLUMN route.direction.direction IS 'The name of the route direction';
COMMENT ON COLUMN route.direction.the_opposite_of_direction IS 'The opposite direction';

ALTER TABLE route.direction
  ADD CONSTRAINT direction_pkey PRIMARY KEY (direction);
ALTER TABLE route.direction
  ADD CONSTRAINT direction_the_opposite_of_direction_fkey
  FOREIGN KEY (the_opposite_of_direction) REFERENCES route.direction(direction);

CREATE INDEX idx_direction_the_opposite_of_direction ON route.direction USING btree (the_opposite_of_direction);

INSERT INTO route.direction (direction, the_opposite_of_direction)
  VALUES
  ('inbound', 'outbound'),
  ('outbound', 'inbound'),
  ('clockwise', 'anticlockwise'),
  ('anticlockwise', 'clockwise'),
  ('northbound', 'southbound'),
  ('southbound', 'northbound'),
  ('eastbound', 'westbound'),
  ('westbound', 'eastbound')
  ON CONFLICT (direction)
  DO UPDATE SET the_opposite_of_direction = EXCLUDED.the_opposite_of_direction;

---------- Add new columns to Journey Pattern Ref ----------

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

ALTER TABLE journey_pattern.journey_pattern_ref
  ADD CONSTRAINT journey_pattern_ref_route_direction_fkey
  FOREIGN KEY (route_direction) REFERENCES route.direction(direction);

CREATE INDEX idx_journey_pattern_ref_route_direction ON journey_pattern.journey_pattern_ref USING btree (route_direction);
