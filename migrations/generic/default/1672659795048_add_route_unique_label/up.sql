ALTER TABLE route.route
  ADD COLUMN unique_label text GENERATED ALWAYS AS (label) STORED;

COMMENT ON COLUMN route.route.unique_label IS 'Derived from label. Routes are unique for each unique label for a certain direction, priority and validity period';
COMMENT ON COLUMN route.route.label IS 'The label of the route definition.';
COMMENT ON COLUMN route.route.variant IS 'The variant for route definition.';
COMMENT ON COLUMN route.route.direction IS 'The direction of the route definition.';
