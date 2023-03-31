ALTER TABLE service_pattern.scheduled_stop_point
  ADD COLUMN numeric_id serial NOT NULL;
COMMENT ON COLUMN service_pattern.scheduled_stop_point.numeric_id IS '
  A numeric identifier for the stop.
  Used mainly in exports.
  Old stop points (from Jore3) use numbers starting with 1-6 or 9.
  Numeric ids for new stop points will start with 7.';

-- Reset the sequence, so first id will be 7000001.
SELECT setval('service_pattern.scheduled_stop_point_numeric_id_seq', 7000000);
