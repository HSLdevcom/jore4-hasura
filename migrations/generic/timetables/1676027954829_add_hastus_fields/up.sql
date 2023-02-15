CREATE TABLE vehicle_journey.journey_type (
  type text PRIMARY KEY
);
COMMENT ON TABLE vehicle_journey.journey_type IS 'Enum table for defining allowed journey types.';

INSERT INTO vehicle_journey.journey_type
  (type)
  VALUES
  ('STANDARD'),
  ('DRY_RUN'),
  ('SERVICE_JOURNEY')
  ON CONFLICT (type) DO NOTHING;

ALTER TABLE vehicle_journey.vehicle_journey
  ADD COLUMN journey_name_i18n jsonb,
  ADD COLUMN turnaround_time interval,
  ADD COLUMN layover_time interval,
  ADD COLUMN journey_type text NOT NULL DEFAULT 'STANDARD' REFERENCES vehicle_journey.journey_type (type);
COMMENT ON COLUMN vehicle_journey.vehicle_journey.journey_name_i18n IS 'Name that user can give to the vehicle journey.';
COMMENT ON COLUMN vehicle_journey.vehicle_journey.turnaround_time IS 'Turnaround time. Means the time it takes to move vehicle to the starting stop and pick up the passengers.';
COMMENT ON COLUMN vehicle_journey.vehicle_journey.layover_time IS 'Layover time. 95% of the journeys should arrive to the terminal within journey time + recovery time so that they would be ready to start next journey in time.';
COMMENT ON COLUMN vehicle_journey.vehicle_journey.journey_type IS 'STANDARD | DRY_RUN | SERVICE_JOURNEY';

CREATE SCHEMA reusable_components;

CREATE TABLE reusable_components.vehicle_type (
  vehicle_type_id uuid PRIMARY KEY,
  label text NOT NULL,
  description_i18n jsonb
);
COMMENT ON TABLE reusable_components.vehicle_type IS 'The VEHICLE entity is used to describe the physical public transport vehicles available for short-term planning of operations and daily assignment (in contrast to logical vehicles considered for resource planning of operations and daily assignment (in contrast to logical vehicles cplanning). Each VEHICLE shall be classified as of a particular VEHICLE TYPE.';
COMMENT ON COLUMN reusable_components.vehicle_type.label IS 'Label of the vehicle type.';
COMMENT ON COLUMN reusable_components.vehicle_type.description_i18n IS 'Description of the vehicle type.';

ALTER TABLE vehicle_service.block
  ADD COLUMN preparing_time interval,
  ADD COLUMN finishing_time interval,
  ADD COLUMN vehicle_type uuid;
ALTER TABLE ONLY vehicle_service.block
  ADD CONSTRAINT vehicle_type_fkey FOREIGN KEY (vehicle_type) REFERENCES reusable_components.vehicle_type(vehicle_type_id);
COMMENT ON COLUMN vehicle_service.block.preparing_time IS 'Preparation time before start of vehicle service block.';
COMMENT ON COLUMN vehicle_service.block.finishing_time IS 'Finishing time after end of vehicle service block.';
COMMENT ON COLUMN vehicle_service.block.vehicle_type IS 'Reference to resuable_components.vehicle_type.';

ALTER TABLE vehicle_schedule.vehicle_schedule_frame
  ALTER COLUMN name_i18n DROP NOT NULL;

ALTER TABLE vehicle_schedule.vehicle_schedule_frame
  ADD COLUMN label text;
COMMENT ON COLUMN vehicle_schedule.vehicle_schedule_frame.label IS 'Label for the vehicle schedule frame. Comes from BookingRecord vsc_name field from Hastus.';

ALTER TABLE vehicle_service.vehicle_service
  ADD COLUMN name_i18n jsonb;
COMMENT ON COLUMN vehicle_service.vehicle_service.name_i18n IS 'Name for vehicle service.';
