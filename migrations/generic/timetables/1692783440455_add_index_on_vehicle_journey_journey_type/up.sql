CREATE INDEX idx_vehicle_journey_journey_type
  ON vehicle_journey.vehicle_journey USING btree (journey_type);
