ALTER TABLE route.route
  ADD CONSTRAINT route_variant_unsigned_check CHECK (variant >= 0);
