ALTER TABLE route.route
  ADD COLUMN variant smallint;

COMMENT ON COLUMN route.route.label IS 'The label of the route definition, label, variant and direction together are unique for a certain priority and validity period.';
COMMENT ON COLUMN route.route.variant IS 'The variant for route definition, label, variant and direction together are unique for a certain priority and validity period.';
COMMENT ON COLUMN route.route.direction IS 'The direction of the route definition, label, variant and direction together are unique for a certain priority and validity period.';
