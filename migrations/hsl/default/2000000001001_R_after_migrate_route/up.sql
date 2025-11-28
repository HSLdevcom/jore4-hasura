ALTER TABLE route.route
  ADD CONSTRAINT route_variant_unsigned_check CHECK (variant >= 0);

ALTER TABLE hsl_route.legacy_hsl_municipality_code
  ADD CONSTRAINT hsl_route_legacy_hsl_muhnicipality_code_digit_check CHECK (jore3_code BETWEEN 0 AND 9);

ALTER TABLE route.line_external_id
  ADD CONSTRAINT route_line_external_id_range_check CHECK (external_id BETWEEN 1 AND 9999);

CREATE OR REPLACE FUNCTION route.insert_new_external_ids() RETURNS TRIGGER
  LANGUAGE plpgsql
  AS $$
  BEGIN
    -- RAISE LOG 'route.insert_new_external_ids()';

    -- Note: we can not use ON CONFLICT DO NOTHING for this:
    -- even if it would work correctly for the INSERT, it breaks the sequence because
    -- the sequence gets incremented even if conflict would happen and insert otherwise did nothing.
    -- See eg. https://stackoverflow.com/a/37206177
    INSERT INTO route.line_external_id (label)
    SELECT DISTINCT label
    FROM new_table
    WHERE NOT EXISTS (
      SELECT 1
      FROM route.line_external_id
      WHERE route.line_external_id.LABEL = new_table.label
    );

    RETURN NULL;
  END;
  $$;
COMMENT ON FUNCTION route.insert_new_external_ids
IS 'Create external ids (rows on route.line_external_id) for each INSERTed or UPDATEd line, if they do not exist yet.';

DROP TRIGGER IF EXISTS insert_new_external_id_on_line_insert_trigger ON route.line;
CREATE TRIGGER insert_new_external_id_on_line_insert_trigger
  AFTER INSERT ON route.line
  REFERENCING NEW TABLE AS new_table
  FOR EACH STATEMENT
  EXECUTE FUNCTION route.insert_new_external_ids();
COMMENT ON TRIGGER insert_new_external_id_on_line_insert_trigger ON route.line
IS 'Trigger to create new external ids for lines when new lines are inserted.';

DROP TRIGGER IF EXISTS insert_new_external_id_on_line_label_update_trigger ON route.line;
CREATE TRIGGER insert_new_external_id_on_line_label_update_trigger
  AFTER UPDATE ON route.line
  REFERENCING NEW TABLE AS new_table
  FOR EACH ROW
  WHEN (OLD.label IS DISTINCT FROM NEW.label)
  EXECUTE FUNCTION route.insert_new_external_ids();
COMMENT ON TRIGGER insert_new_external_id_on_line_label_update_trigger ON route.line
IS 'Trigger to create new external ids for lines when labels are possibly modified.';
