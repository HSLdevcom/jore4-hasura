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
COMMENT ON COLUMN vehicle_journey.vehicle_journey.turnaround_time IS 'Turnaround time is the time taken by a vehicle to proceed from the end of a ROUTE to the start of another.';
COMMENT ON COLUMN vehicle_journey.vehicle_journey.layover_time IS 'LAYOVER TIMEs describe a certain time allowance that may be given at the end of each VEHICLE JOURNEY, before starting the next one, to compensate delays or for other purposes (e.g. rest time for the driver). This “layover time” can be regarded as a buffer time, which may or may not be actually consumed in real time operation.';
COMMENT ON COLUMN vehicle_journey.vehicle_journey.journey_type IS 'STANDARD | DRY_RUN | SERVICE_JOURNEY';

CREATE SCHEMA vehicle_type;

CREATE TABLE vehicle_type.vehicle_type (
  vehicle_type_id uuid PRIMARY KEY,
  label text NOT NULL,
  description_i18n jsonb
);
COMMENT ON TABLE vehicle_type.vehicle_type IS 'The VEHICLE entity is used to describe the physical public transport vehicles available for short-term planning of operations and daily assignment (in contrast to logical vehicles considered for resource planning of operations and daily assignment (in contrast to logical vehicles cplanning). Each VEHICLE shall be classified as of a particular VEHICLE TYPE.';
COMMENT ON COLUMN vehicle_type.vehicle_type.label IS 'Label of the vehicle type.';
COMMENT ON COLUMN vehicle_type.vehicle_type.description_i18n IS 'Description of the vehicle type.';

ALTER TABLE vehicle_service.block
  ADD COLUMN preparing_time interval,
  ADD COLUMN finishing_time interval,
  ADD COLUMN vehicle_type_id uuid;
ALTER TABLE ONLY vehicle_service.block
  ADD CONSTRAINT vehicle_type_fkey FOREIGN KEY (vehicle_type_id) REFERENCES vehicle_type.vehicle_type(vehicle_type_id);
COMMENT ON COLUMN vehicle_service.block.preparing_time IS 'Preparation time before start of vehicle service block.';
COMMENT ON COLUMN vehicle_service.block.finishing_time IS 'Finishing time after end of vehicle service block.';
COMMENT ON COLUMN vehicle_service.block.vehicle_type_id IS 'Reference to vehicle_type.vehicle_type.';

CREATE INDEX idx_block_vehicle_type_id ON
  vehicle_service.block (vehicle_type_id);

ALTER TABLE vehicle_schedule.vehicle_schedule_frame
  ALTER COLUMN name_i18n DROP NOT NULL,
  ADD COLUMN label text NOT NULL;
COMMENT ON COLUMN vehicle_schedule.vehicle_schedule_frame.label IS 'Label for the vehicle schedule frame. Comes from BookingRecord vsc_name field from Hastus.';

ALTER TABLE vehicle_service.vehicle_service
  ADD COLUMN name_i18n jsonb;
COMMENT ON COLUMN vehicle_service.vehicle_service.name_i18n IS 'Name for vehicle service.';
