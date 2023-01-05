ALTER TABLE route.route
  ADD COLUMN variant smallint;

COMMENT ON COLUMN route.route.variant IS 'The variant for route definition.';
