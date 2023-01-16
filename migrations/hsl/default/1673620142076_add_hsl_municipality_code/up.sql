CREATE TABLE hsl_route.hsl_municipality_code (
  hsl_municipality_code text PRIMARY KEY,
  jore3_code smallint DEFAULT NULL -- nullable, so we can possibly add other municipalities in the future that are not from jore3
);

COMMENT ON TABLE
  hsl_route.hsl_municipality_code IS
  'Mainly used to represent a region used for route label uniqueness: labels only have to be unique when they have same municipality code.';
INSERT INTO hsl_route.hsl_municipality_code
  (jore3_code, hsl_municipality_code)
  VALUES
  -- Based on https://github.com/HSLdevcom/jore4/blob/main/wiki/jore3_route_ids.md#first-number-9
  (0, 'legacy_not_used'), -- Not used. Some historical routes have this prefix
  (1, 'helsinki'), -- Helsinki
  (2, 'espoo'), -- Espoo
  (3, 'train_or_metro'), -- Train or metro
  (4, 'vantaa'), -- Vantaa
  (5, 'espoon_vantaa_regional'), -- Regional routes between Vantaa and Espoo
  (6, 'kirkkonummi_and_siuntio'), -- Kirkkonummi and Siuntio
  (7, 'u_lines'), -- U bus routes
  (8, 'testing_not_used'), -- for testing purposes, not used
  (9, 'tuusula_kerava_sipoo') -- Tuusula, Kerava and Sipoo
  ON CONFLICT (hsl_municipality_code) DO NOTHING;

-- create the hsl_municipality_code column with constraints and fill it up with some default data
ALTER TABLE route.route
  ADD COLUMN hsl_municipality_code text NOT NULL REFERENCES hsl_route.hsl_municipality_code (hsl_municipality_code) DEFAULT 'helsinki';

-- drop the default clause from hsl_municipality_code to make it mandatory to fill it in
ALTER TABLE route.route
  ALTER COLUMN hsl_municipality_code DROP DEFAULT;

-- Update unique_label definition
ALTER TABLE route.route
  DROP COLUMN unique_label;

ALTER TABLE route.route
  ADD COLUMN unique_label text GENERATED ALWAYS AS (hsl_municipality_code || '_' ||label || (CASE WHEN variant IS NULL THEN '' ELSE '_' || variant::text END)) STORED;

COMMENT ON COLUMN route.route.unique_label IS 'Derived from label, HSL municipality code and variant. Routes are unique for each unique label for a certain direction, priority and validity period';
