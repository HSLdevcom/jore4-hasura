ALTER TABLE route.route
  ADD COLUMN variant smallint;

COMMENT ON COLUMN route.route.variant IS 'The variant for route definition.';

ALTER TABLE route.route
    ADD CONSTRAINT route_variant_unsigned_check CHECK (variant >= 0);
