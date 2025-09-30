ALTER TABLE route.line
  ADD COLUMN description text;

COMMENT ON COLUMN route.line.description
IS 'The line text description of the line.';
