ALTER TABLE route.route
  ADD CONSTRAINT route_variant_unsigned_check CHECK (variant >= 0);

ALTER TABLE hsl_route.legacy_hsl_municipality_code
  ADD CONSTRAINT hsl_route_legacy_hsl_muhnicipality_code_digit_check CHECK (0 <= jore3_code AND jore3_code <= 9);
