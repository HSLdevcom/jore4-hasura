ALTER TABLE service_pattern.scheduled_stop_point
  ADD COLUMN stop_place_ref text;

COMMENT ON COLUMN service_pattern.scheduled_stop_point.stop_place_ref
IS 'The id of the related stop place in stop registry database.';

-- Each scheduled stop point should have its own stop place.
CREATE UNIQUE INDEX scheduled_stop_point_stop_place_ref_idx ON service_pattern.scheduled_stop_point
USING btree (stop_place_ref)
WHERE (stop_place_ref IS NOT NULL);
