-- changes need to be made in separate transactions because of existing constraints

-- create table for scheduled stop point invariants and fill it up with the distinct stop labels
BEGIN;

CREATE TABLE internal_service_pattern.scheduled_stop_point_invariant (
  label text NOT NULL,
  PRIMARY KEY (label)
);

INSERT INTO internal_service_pattern.scheduled_stop_point_invariant (label)
SELECT DISTINCT "label" FROM internal_service_pattern.scheduled_stop_point;

ALTER TABLE internal_service_pattern.scheduled_stop_point
  ADD CONSTRAINT scheduled_stop_point_scheduled_stop_point_invariant_label_fkey
    FOREIGN KEY (label) REFERENCES internal_service_pattern.scheduled_stop_point_invariant (label);

CREATE INDEX scheduled_stop_point_label_idx ON internal_service_pattern.scheduled_stop_point (label);

COMMIT;


-- add label column to scheduled_stop_point_in_journey_pattern table and fill it up with the referenced stops' labels
BEGIN;

ALTER TABLE journey_pattern.scheduled_stop_point_in_journey_pattern
  ADD COLUMN scheduled_stop_point_label text,
  ADD CONSTRAINT scheduled_stop_point_in_journe__scheduled_stop_point_label_fkey
    FOREIGN KEY (scheduled_stop_point_label) REFERENCES internal_service_pattern.scheduled_stop_point_invariant (label)
      ON DELETE CASCADE;

CREATE INDEX scheduled_stop_point_in_journey__scheduled_stop_point_label_idx
  ON journey_pattern.scheduled_stop_point_in_journey_pattern (scheduled_stop_point_label);

UPDATE journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
  SET scheduled_stop_point_label = (
    SELECT internal_service_pattern.scheduled_stop_point."label"
    FROM internal_service_pattern.scheduled_stop_point
    WHERE internal_service_pattern.scheduled_stop_point.scheduled_stop_point_id = sspijp.scheduled_stop_point_id
  );

COMMIT;


-- remove the stop id column as the label is used as foreign key from now on
BEGIN;

ALTER TABLE journey_pattern.scheduled_stop_point_in_journey_pattern
  ALTER COLUMN scheduled_stop_point_label SET NOT NULL,
  DROP COLUMN scheduled_stop_point_id;

END;
