CREATE TABLE network.transport_target (
  transport_target text PRIMARY KEY
);
COMMENT ON TABLE
  network.transport_target IS
  'Transport target, can be used e.g. for cost sharing.';
INSERT INTO network.transport_target
  (transport_target)
  VALUES
  ('helsinki_internal_traffic'),
  ('espoo_and_kauniainen_internal_traffic'),
  ('vantaa_internal_traffic'),
  ('kerava_internal_traffic'),
  ('kirkkonummi_internal_traffic'),
  ('sipoo_internal_traffic'),
  ('tuusula_internal_traffic'),
  ('siuntio_internal_traffic'),
  ('kerava_regional_traffic'),
  ('kirkkonummi_regional_traffic'),
  ('tuusula_regional_traffic'),
  ('siuntio_regional_traffic'),
  ('espoo_regional_traffic'),
  ('vantaa_regional_traffic'),
  ('transverse_regional')
  ON CONFLICT (transport_target) DO NOTHING;


-- create the transport_target column with constraints and fill it up with some default data
ALTER TABLE network.line
  ADD COLUMN transport_target text NOT NULL REFERENCES network.transport_target (transport_target) DEFAULT 'helsinki_internal_traffic';

-- drop the default clause from transport_target to make it mandatory to fill it in
ALTER TABLE network.line
  ALTER COLUMN transport_target DROP DEFAULT;

create index idx_line_transport_target on
  network.line (transport_target);

ALTER TABLE network.route
  ADD COLUMN variant smallint;

COMMENT ON COLUMN network.route.variant IS 'The variant for route definition.';

-- Can't modify computed columns, need to recreate with new definition.
ALTER TABLE network.route
  DROP COLUMN unique_label;

ALTER TABLE network.route
  ADD COLUMN unique_label text GENERATED ALWAYS AS (label || (CASE WHEN variant IS NULL THEN '' ELSE '_' || variant::text END)) STORED;

COMMENT ON COLUMN network.route.unique_label IS 'Derived from label and variant. Routes are unique for each unique label for a certain direction, priority and validity period';

CREATE TABLE network.legacy_hsl_municipality_code (
  hsl_municipality text PRIMARY KEY,
  jore3_code smallint NOT NULL
);

COMMENT ON TABLE
  network.legacy_hsl_municipality_code IS
  'Legacy, avoid using. Main use nowadays is to enable support for eg. data exports that still need this. Originally this was used to represent the primary region for routes/lines.';
INSERT INTO network.legacy_hsl_municipality_code
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
ALTER TABLE network.route
  ADD COLUMN legacy_hsl_municipality_code text REFERENCES network.legacy_hsl_municipality_code (hsl_municipality) DEFAULT 'helsinki';

-- drop the default clause from legacy_hsl_municipality_code to make it mandatory to fill it in
ALTER TABLE network.route
  ALTER COLUMN legacy_hsl_municipality_code DROP DEFAULT;

CREATE INDEX idx_route_legacy_hsl_municipality_code ON network.route USING btree (legacy_hsl_municipality_code);

COMMENT ON COLUMN network.route.legacy_hsl_municipality_code IS 'Defines the legacy municipality that is mainly used for data exports.';

-- Create the legacy_hsl_municipality_code column with constraints and fill it up with some default data.
-- Currently all lines in Jore3 have this so NOT NULL is okay.
-- Should probably be made nullable once there is a new mechanism in place to replace this.
ALTER TABLE network.line
  ADD COLUMN legacy_hsl_municipality_code text REFERENCES network.legacy_hsl_municipality_code (hsl_municipality) DEFAULT 'helsinki';

-- drop the default clause from legacy_hsl_municipality_code to make it mandatory to fill it in
ALTER TABLE network.line
  ALTER COLUMN legacy_hsl_municipality_code DROP DEFAULT;

CREATE INDEX idx_line_legacy_hsl_municipality_code ON network.line USING btree (legacy_hsl_municipality_code);

COMMENT ON COLUMN network.line.legacy_hsl_municipality_code IS 'Defines the legacy municipality that is mainly used for data exports.';

INSERT INTO infrastructure_network.external_source VALUES ('hsl_fixup');

UPDATE infrastructure_network.infrastructure_link
  SET external_link_source = 'hsl_fixup'
  WHERE external_link_source = 'fixup';

DELETE FROM infrastructure_network.external_source WHERE value = 'fixup';

INSERT INTO infrastructure_network.external_source VALUES ('hsl_tram');

ALTER TABLE network.route ADD COLUMN version_comment TEXT NULL DEFAULT NULL;
COMMENT ON COLUMN network.route.version_comment
  IS 'An extra comment describing the latest change to the Route''s details.';

ALTER TABLE network.line ADD COLUMN version_comment TEXT NULL DEFAULT NULL;
COMMENT ON COLUMN network.line.version_comment
  IS 'An extra comment describing the latest change to the Line''s details.';
