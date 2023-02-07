ALTER TABLE route.line
  ALTER COLUMN legacy_hsl_municipality_code SET NOT NULL;

ALTER TABLE route.route
  ALTER COLUMN legacy_hsl_municipality_code SET NOT NULL;
