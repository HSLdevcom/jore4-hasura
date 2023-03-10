CREATE INDEX idx_journey_pattern_ref_journey_pattern_id ON journey_pattern.journey_pattern_ref (journey_pattern_id);

CREATE TABLE vehicle_service.journey_patterns_in_vehicle_service (
  vehicle_service_id uuid NOT NULL REFERENCES vehicle_service.vehicle_service (vehicle_service_id) ON DELETE CASCADE,
  journey_pattern_id uuid NOT NULL, --"references" journey_pattern.journey_pattern_ref (journey_pattern_id),
  reference_count integer NOT NULL,
  PRIMARY KEY(vehicle_service_id, journey_pattern_id)
);

COMMENT ON TABLE vehicle_service.journey_patterns_in_vehicle_service IS
'A denormalized table containing relationships between vehicle_services and journey_patterns (via journey_pattern_ref.journey_pattern_id).
 Without this table this relationship could be found via vehicle_service -> block -> vehicle_journey -> journey_pattern_ref.
 Kept up to date with triggers, should not be updated manually.';
COMMENT ON COLUMN vehicle_service.journey_patterns_in_vehicle_service.journey_pattern_id IS
'The journey_pattern_id from journey_pattern.journey_pattern_ref.
 No foreign key reference is set because the target column is not unique.';
COMMENT ON COLUMN vehicle_service.journey_patterns_in_vehicle_service.reference_count IS
 'The amount of unique references between the journey_pattern and vehicle_service.
  When this reaches 0 the row will be deleted.';

-- Add journey_patterns_in_vehicle_service rows based on current data.
INSERT INTO vehicle_service.journey_patterns_in_vehicle_service (journey_pattern_id, vehicle_service_id, reference_count)
SELECT DISTINCT journey_pattern_id, vehicle_service_id, COUNT(journey_pattern_ref_id)
FROM vehicle_service.vehicle_service
JOIN vehicle_service.block USING (vehicle_service_id)
JOIN vehicle_journey.vehicle_journey USING (block_id)
JOIN journey_pattern.journey_pattern_ref USING (journey_pattern_ref_id)
GROUP BY (journey_pattern_id, vehicle_service_id, journey_pattern_ref_id);
