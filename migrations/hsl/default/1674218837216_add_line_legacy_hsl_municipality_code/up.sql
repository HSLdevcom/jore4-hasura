-- Create the legacy_hsl_municipality_code column with constraints and fill it up with some default data.
-- Currently all lines in Jore3 have this so NOT NULL is okay.
-- Should probably be made nullable once there is a new mechanism in place to replace this.
ALTER TABLE route.line
  ADD COLUMN legacy_hsl_municipality_code text NOT NULL REFERENCES hsl_route.legacy_hsl_municipality_code (hsl_municipality) DEFAULT 'helsinki';

-- drop the default clause from legacy_hsl_municipality_code to make it mandatory to fill it in
ALTER TABLE route.line
  ALTER COLUMN legacy_hsl_municipality_code DROP DEFAULT;

CREATE INDEX idx_line_legacy_hsl_municipality_code ON route.line USING btree (legacy_hsl_municipality_code);

COMMENT ON COLUMN route.line.legacy_hsl_municipality_code IS 'Defines the legacy municipality that is mainly used for data exports.';
