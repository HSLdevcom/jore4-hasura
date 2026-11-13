CREATE TABLE network.point_type (
  type text PRIMARY KEY
);

INSERT INTO network.point_type
  VALUES
  ('timing_point'),
  ('garage_point');

ALTER TABLE network.scheduled_stop_point
  ADD COLUMN point_type text NOT NULL DEFAULT 'timing_point';

ALTER TABLE network.scheduled_stop_point
  ADD CONSTRAINT scheduled_stop_point_point_type_fkey FOREIGN KEY (point_type) REFERENCES network.point_type;
