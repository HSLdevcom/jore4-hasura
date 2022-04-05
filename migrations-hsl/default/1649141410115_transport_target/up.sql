CREATE TABLE route.transport_target (
  transport_target text PRIMARY KEY
);
COMMENT ON TABLE
  route.transport_target IS
  'Transport target, can be used e.g. for cost sharing.';
INSERT INTO route.transport_target
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

ALTER TABLE route.line
  ADD COLUMN transport_target text NOT NULL REFERENCES route.transport_target (transport_target);

COMMENT ON COLUMN
  route.line.transport_target IS
  'Transport target.';