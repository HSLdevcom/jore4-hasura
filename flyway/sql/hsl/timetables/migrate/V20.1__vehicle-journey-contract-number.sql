ALTER TABLE vehicle_journey.vehicle_journey
  ADD COLUMN contract_number text NOT NULL
  -- Include a default value so that the migration doesn't break with existing data.
  DEFAULT 'INVALID';

-- Now that existing data has a value, we can drop the default.
-- The field is mandatory and there is no real sensible default value we could use.
ALTER TABLE vehicle_journey.vehicle_journey
  ALTER COLUMN contract_number DROP DEFAULT;

COMMENT ON COLUMN vehicle_journey.vehicle_journey.contract_number IS 'The contract number for this vehicle journey.';
