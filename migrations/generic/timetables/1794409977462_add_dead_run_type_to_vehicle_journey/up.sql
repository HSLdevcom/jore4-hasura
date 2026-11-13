CREATE TABLE vehicle_journey.dead_run_type (
  type text PRIMARY KEY
);

INSERT INTO vehicle_journey.dead_run_type
  (type)
  VALUES
  ('garageRunOut'),
  ('garageRunIn'),
  ('turningManoeuvre'),
  ('other')
  ON CONFLICT (type) DO NOTHING;

ALTER TABLE vehicle_journey.vehicle_journey
  ADD COLUMN dead_run_type text REFERENCES vehicle_journey.dead_run_type (type);

CREATE INDEX idx_vehicle_journey_dead_run_type
  ON vehicle_journey.vehicle_journey USING btree (dead_run_type)
  WHERE dead_run_type IS NOT NULL;
