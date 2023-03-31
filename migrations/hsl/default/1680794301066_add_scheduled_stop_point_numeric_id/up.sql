ALTER TABLE service_pattern.scheduled_stop_point
  ADD COLUMN numeric_id serial NOT NULL;
COMMENT ON COLUMN service_pattern.scheduled_stop_point.numeric_id IS '
  A numeric identifier for the stop.
  Used mainly in exports.
  Old stop points (from Jore3) use numbers starting with 1-6 or 9.
  Numeric ids for new stop points will start with 7.';

-- Set the sequence parameters and restart it.
ALTER SEQUENCE service_pattern.scheduled_stop_point_numeric_id_seq
START    7000001
MINVALUE 7000001
MAXVALUE 8999999
RESTART;
