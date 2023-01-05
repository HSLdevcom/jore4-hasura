ALTER TABLE route.route
  DROP COLUMN unique_label;

ALTER TABLE route.route
  ADD COLUMN unique_label text GENERATED ALWAYS AS (label) STORED;

COMMENT ON COLUMN route.route.unique_label IS 'Derived from label. Routes are unique for each unique label for a certain direction, priority and validity period';
