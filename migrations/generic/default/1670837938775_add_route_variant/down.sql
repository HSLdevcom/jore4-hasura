ALTER TABLE route.route
  DROP COLUMN variant CASCADE; -- TODO: Remove cascade after fixing repeatable down migrations

COMMENT ON COLUMN route.route.label IS 'The label of the route definition, label and direction together are unique for a certain priority and validity period.';
COMMENT ON COLUMN route.route.direction IS 'The direction of the route definition, label and direction together are unique for a certain priority and validity period.';
