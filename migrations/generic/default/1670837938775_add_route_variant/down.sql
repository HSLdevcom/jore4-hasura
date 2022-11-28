ALTER TABLE route.route
  DROP COLUMN variant;

COMMENT ON COLUMN route.route.label IS 'The label of the route definition, label and direction together are unique for a certain priority and validity period.';
COMMENT ON COLUMN route.route.direction IS 'The direction of the route definition, label and direction together are unique for a certain priority and validity period.';
