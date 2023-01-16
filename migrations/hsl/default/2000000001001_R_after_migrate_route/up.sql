ALTER TABLE route.route
  ADD CONSTRAINT route_variant_unsigned_check CHECK (variant >= 0);

CREATE INDEX idx_route_hsl_municipality_code ON route.route USING btree (hsl_municipality_code);
