ALTER TABLE vehicle_journey.vehicle_journey
  ADD COLUMN contract_number text NOT NULL;

COMMENT ON COLUMN vehicle_journey.vehicle_journey.contract_number IS 'The contract number for this vehicle journey.';
