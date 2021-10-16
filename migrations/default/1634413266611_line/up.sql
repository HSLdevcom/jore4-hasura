
CREATE TABLE journey_pattern.line (
  line_id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  description_i18n text
);
COMMENT ON TABLE
  journey_pattern.line IS
  'The lines, to which a service journey pattern can belong.';
COMMENT ON COLUMN
  journey_pattern.line.line_id IS
  'The ID of the line.';
COMMENT ON COLUMN
  journey_pattern.line.description_i18n IS
  'The description of the line. Placeholder for multilingual strings.';

ALTER TABLE journey_pattern.journey_pattern
  ADD COLUMN line_id uuid REFERENCES journey_pattern.line (line_id);
COMMENT ON COLUMN
  journey_pattern.journey_pattern.line_id IS
  'The line to which this journey pattern belongs (if any).';
