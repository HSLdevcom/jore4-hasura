ALTER TABLE route.route
  DROP COLUMN legacy_hsl_municipality_code;

DROP TABLE hsl_route.legacy_hsl_municipality_code CASCADE;
