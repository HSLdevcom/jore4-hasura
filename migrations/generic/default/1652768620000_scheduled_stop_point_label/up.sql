
-- changes need to be made in separate transactions because of existing constraints

BEGIN;

CREATE TABLE internal_service_pattern.scheduled_stop_point_invariant (
  label TEXT NOT NULL,
  PRIMARY KEY (label)
);

INSERT INTO internal_service_pattern.scheduled_stop_point_invariant (label)
SELECT DISTINCT "label" FROM internal_service_pattern.scheduled_stop_point;

ALTER TABLE internal_service_pattern.scheduled_stop_point
  ADD CONSTRAINT scheduled_stop_point_scheduled_stop_point_invariant_label_fkey
    FOREIGN KEY (label) REFERENCES internal_service_pattern.scheduled_stop_point_invariant (label);

CREATE INDEX scheduled_stop_point_label_idx ON internal_service_pattern.scheduled_stop_point (label);

COMMIT;


BEGIN;

ALTER TABLE journey_pattern.scheduled_stop_point_in_journey_pattern
  ADD COLUMN scheduled_stop_point_label TEXT REFERENCES internal_service_pattern.scheduled_stop_point_invariant (label);

CREATE INDEX scheduled_stop_point_in_journey__scheduled_stop_point_label_idx
  ON journey_pattern.scheduled_stop_point_in_journey_pattern (scheduled_stop_point_label);

UPDATE journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
  SET scheduled_stop_point_label = (
    SELECT "label"
    FROM internal_service_pattern.scheduled_stop_point ssp
    WHERE ssp.scheduled_stop_point_id = sspijp.scheduled_stop_point_id
  );

COMMIT;


BEGIN;

ALTER TABLE journey_pattern.scheduled_stop_point_in_journey_pattern
  ALTER COLUMN scheduled_stop_point_label SET NOT NULL,
  DROP COLUMN scheduled_stop_point_id;

END;
