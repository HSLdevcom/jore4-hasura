ALTER TABLE route.route
  DROP COLUMN unique_label;

ALTER TABLE route.route
  ADD COLUMN unique_label text GENERATED ALWAYS AS (label || (CASE WHEN variant IS NULL THEN '' ELSE '_' || variant::text END)) STORED;

COMMENT ON COLUMN route.route.unique_label IS 'Derived from label and variant. Routes are unique for each unique label for a certain direction, priority and validity period';

ALTER TABLE route.route
  DROP COLUMN hsl_municipality_code;

DROP TABLE hsl_route.hsl_municipality_code CASCADE;
