ALTER TABLE network.route
  ADD CONSTRAINT route_variant_unsigned_check CHECK (variant >= 0);

ALTER TABLE network.legacy_hsl_municipality_code
  ADD CONSTRAINT network_legacy_hsl_municipality_code_digit_check CHECK (0 <= jore3_code AND jore3_code <= 9);
