CREATE TABLE hsl_route.legacy_hsl_municipality_code (
  hsl_municipality text PRIMARY KEY,
  jore3_code smallint NOT NULL
);

COMMENT ON TABLE
  hsl_route.legacy_hsl_municipality_code IS
  'Legacy, avoid using. Main use nowadays is to enable support for eg. data exports that still need this. Originally this was used to represent the primary region for routes/lines.';
INSERT INTO hsl_route.legacy_hsl_municipality_code
  (jore3_code, hsl_municipality)
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
  ON CONFLICT (hsl_municipality) DO NOTHING;

-- Create the legacy_hsl_municipality_code column with constraints and fill it up with some default data.
-- Currently all routes in Jore3 have this so NOT NULL is okay.
-- Should probably be made nullable once there is a new mechanism in place to replace this.
ALTER TABLE route.route
  ADD COLUMN legacy_hsl_municipality_code text NOT NULL REFERENCES hsl_route.legacy_hsl_municipality_code (hsl_municipality) DEFAULT 'helsinki';

-- drop the default clause from legacy_hsl_municipality_code to make it mandatory to fill it in
ALTER TABLE route.route
  ALTER COLUMN legacy_hsl_municipality_code DROP DEFAULT;

CREATE INDEX idx_route_legacy_hsl_municipality_code ON route.route USING btree (legacy_hsl_municipality_code);

COMMENT ON COLUMN route.route.legacy_hsl_municipality_code IS 'Defines the legacy municipality that is mainly used for data exports.';
