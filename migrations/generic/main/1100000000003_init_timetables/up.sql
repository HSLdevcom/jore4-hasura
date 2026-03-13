-------------------- Journey Pattern --------------------

CREATE TABLE timetables.journey_pattern_ref (
  journey_pattern_ref_id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  journey_pattern_id uuid NOT NULL,
  observation_timestamp timestamp with time zone NOT NULL,
  snapshot_timestamp timestamp with time zone NOT NULL,
  type_of_line text NOT NULL REFERENCES network.type_of_line (type_of_line),
  route_label text NOT NULL,
  route_direction text NOT NULL REFERENCES network.route_direction(direction),
  route_validity_start date,
  route_validity_end date
);
COMMENT ON TABLE timetables.journey_pattern_ref IS 'Reference to a given snapshot of a JOURNEY PATTERN for a given operating day. Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:4:729 ';
COMMENT ON COLUMN timetables.journey_pattern_ref.journey_pattern_id IS 'The ID of the referenced JOURNEY PATTERN';
COMMENT ON COLUMN timetables.journey_pattern_ref.observation_timestamp IS 'The user-given point of time used to pick one journey pattern (with route and scheduled stop points) among possibly many variants. The selected, unambiguous journey pattern variant is used as a basis for schedule planning.';
COMMENT ON COLUMN timetables.journey_pattern_ref.snapshot_timestamp IS 'The timestamp when the snapshot was taken';
COMMENT ON COLUMN timetables.journey_pattern_ref.type_of_line IS 'The type of line (GTFS route type): https://developers.google.com/transit/gtfs/reference/extended-route-types';
COMMENT ON COLUMN timetables.journey_pattern_ref.route_label IS 'The label of the route associated with the referenced journey pattern';
COMMENT ON COLUMN timetables.journey_pattern_ref.route_direction IS 'The direction of the route associated with the referenced journey pattern';
COMMENT ON COLUMN timetables.journey_pattern_ref.route_validity_start IS 'The start date of the validity period of the route associated with the referenced journey pattern. If NULL, then the start of the validity period is unbounded (-infinity).';
COMMENT ON COLUMN timetables.journey_pattern_ref.route_validity_end IS 'The end date of the validity period of the route associated with the referenced journey pattern. If NULL, then the end of the validity period is unbounded (infinity).';

-------------------- Service Pattern --------------------


CREATE TABLE timetables.scheduled_stop_point_in_journey_pattern_ref (
  scheduled_stop_point_in_journey_pattern_ref_id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  journey_pattern_ref_id uuid REFERENCES timetables.journey_pattern_ref (journey_pattern_ref_id) NOT NULL,
  scheduled_stop_point_label text NOT NULL,
  scheduled_stop_point_sequence int NOT NULL,
  timing_place_label text NULL
);
COMMENT ON TABLE timetables.scheduled_stop_point_in_journey_pattern_ref IS 'Reference the a SCHEDULED STOP POINT within a JOURNEY PATTERN. Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:4:729 ';
COMMENT ON COLUMN timetables.scheduled_stop_point_in_journey_pattern_ref.journey_pattern_ref_id IS 'JOURNEY PATTERN to which the SCHEDULED STOP POINT belongs';
COMMENT ON COLUMN timetables.scheduled_stop_point_in_journey_pattern_ref.scheduled_stop_point_label IS 'The label of the SCHEDULED STOP POINT';
COMMENT ON COLUMN timetables.scheduled_stop_point_in_journey_pattern_ref.scheduled_stop_point_sequence IS 'The order of the SCHEDULED STOP POINT within the JOURNEY PATTERN.';
COMMENT ON COLUMN timetables.scheduled_stop_point_in_journey_pattern_ref.timing_place_label IS 'The label of the timing place associated with the referenced scheduled stop point in journey pattern';
CREATE UNIQUE INDEX service_pattern_scheduled_stop_point_in_journey_pattern_ref_idx ON timetables.scheduled_stop_point_in_journey_pattern_ref USING btree (journey_pattern_ref_id, scheduled_stop_point_sequence);

-------------------- Service Calendar --------------------

-- = päivätyyppi, erikoispäivätyyppi. E.g. "Monday-Thursday" or "Christmas day"
CREATE TABLE timetables.day_type (
  day_type_id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  label text NOT NULL,
  name_i18n jsonb NOT NULL
);
COMMENT ON TABLE timetables.day_type IS 'A type of day characterised by one or more properties which affect public transport operation. For example: weekday in school holidays. Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=1:6:3:299 ';
COMMENT ON COLUMN timetables.day_type.label IS 'The label for the DAY TYPE. Used for identifying the DAY TYPE when importing data from Hastus. Includes both basic (e.g. "Monday-Thursday") and special ("Easter Sunday") day types';
COMMENT ON COLUMN timetables.day_type.name_i18n IS 'Human-readable name for the DAY TYPE';
CREATE UNIQUE INDEX service_calendar_day_type_label_idx ON timetables.day_type USING btree (label);

-- basic day types are built-in
INSERT INTO timetables.day_type
  (day_type_id, label, name_i18n)
VALUES
  ('6781bd06-08cf-489e-a2bb-be9a07b15752','MT','{"fi_FI": "Maanantai - Torstai", "sv_FI": "Måndag - Torsdag", "en_US": "Monday - Thursday"}'),
  ('38853b0d-ec36-4110-b4bc-f53218c6cdcd','MP','{"fi_FI": "Maanantai - Perjantai", "sv_FI": "Måndag - Fredag", "en_US": "Monday - Friday"}'),
  ('7176e238-d46e-4583-a567-b836b1ae2589','PE','{"fi_FI": "Perjantai", "sv_FI": "Fredag", "en_US": "Friday"}'),
  ('61374d2b-5cce-4a7d-b63a-d487f3a05e0d','LA','{"fi_FI": "Lauantai", "sv_FI": "Lördag", "en_US": "Saturday"}'),
  ('0e1855f1-dfca-4900-a118-f608aa07e939','SU','{"fi_FI": "Sunnuntai", "sv_FI": "Söndag", "en_US": "Sunday"}');

-------------------- Vehicle Schedule --------------------


-- = liikennöintikausi. E.g. 22KES
CREATE TABLE timetables.vehicle_schedule_frame (
  vehicle_schedule_frame_id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  name_i18n jsonb,
  label text NOT NULL,
  validity_start date NOT NULL,
  validity_end date NOT NULL,
  priority int NOT NULL,
  validity_range daterange GENERATED ALWAYS AS ( daterange(validity_start, validity_end, '[]') ) STORED NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);
COMMENT ON TABLE timetables.vehicle_schedule_frame IS 'A coherent set of BLOCKS, COMPOUND BLOCKs, COURSEs of JOURNEY and VEHICLE SCHEDULEs to which the same set of VALIDITY CONDITIONs have been assigned. Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=3:7:2:993 ';
COMMENT ON COLUMN timetables.vehicle_schedule_frame.name_i18n IS 'Human-readable name for the VEHICLE SCHEDULE FRAME';
COMMENT ON COLUMN timetables.vehicle_schedule_frame.label IS 'Label for the vehicle schedule frame. Comes from BookingRecord vsc_name field from Hastus.';
COMMENT ON COLUMN timetables.vehicle_schedule_frame.validity_start IS 'OPERATING DAY when the VEHICLE SCHEDULE FRAME validity starts (inclusive). Null if always has been valid.';
COMMENT ON COLUMN timetables.vehicle_schedule_frame.validity_end IS 'OPERATING DAY when the VEHICLE SCHEDULE FRAME validity ends (inclusive). Null if always will be valid.';
COMMENT ON COLUMN timetables.vehicle_schedule_frame.priority IS 'The priority of the timetable definition. The definition may be overridden by higher priority definitions.';
COMMENT ON COLUMN timetables.vehicle_schedule_frame.validity_range IS '
A denormalized column for actual daterange when vehicle schedule frame is valid,
that is, a closed date range [validity_start, validity_end].
Added to make working with PostgreSQL functions easier:
they typically expect ranges to be half closed.';

-------------------- Vehicle Service --------------------

CREATE TABLE timetables.vehicle_service (
  vehicle_service_id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  day_type_id uuid REFERENCES timetables.day_type (day_type_id) NOT NULL,
  vehicle_schedule_frame_id uuid NOT NULL REFERENCES timetables.vehicle_schedule_frame(vehicle_schedule_frame_id) ON DELETE CASCADE,
  name_i18n jsonb
);
COMMENT ON TABLE timetables.vehicle_service IS 'A work plan for a single vehicle for a whole day, planned for a specific DAY TYPE. A VEHICLE SERVICE includes one or several BLOCKs. If there is no service on a given day, it does not include any BLOCKs. Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=3:5:965 ';
COMMENT ON COLUMN timetables.vehicle_service.day_type_id IS 'The DAY TYPE for the VEHICLE SERVICE.';
COMMENT ON COLUMN timetables.vehicle_service.vehicle_schedule_frame_id IS 'Human-readable name for the VEHICLE SCHEDULE FRAME';
COMMENT ON COLUMN timetables.vehicle_service.name_i18n IS 'Name for vehicle service.';


CREATE TABLE timetables.vehicle_type (
  vehicle_type_id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  label text NOT NULL,
  description_i18n jsonb
);
COMMENT ON TABLE timetables.vehicle_type IS 'The VEHICLE entity is used to describe the physical public transport vehicles available for short-term planning of operations and daily assignment (in contrast to logical vehicles considered for resource planning of operations and daily assignment (in contrast to logical vehicles cplanning). Each VEHICLE shall be classified as of a particular VEHICLE TYPE.';
COMMENT ON COLUMN timetables.vehicle_type.label IS 'Label of the vehicle type.';
COMMENT ON COLUMN timetables.vehicle_type.description_i18n IS 'Description of the vehicle type.';


CREATE TABLE timetables.block (
  block_id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  vehicle_service_id uuid NOT NULL REFERENCES timetables.vehicle_service(vehicle_service_id) ON DELETE CASCADE,
  preparing_time interval,
  finishing_time interval,
  vehicle_type_id uuid REFERENCES timetables.vehicle_type(vehicle_type_id)
);
COMMENT ON TABLE timetables.block IS 'The work of a vehicle from the time it leaves a PARKING POINT after parking until its next return to park at a PARKING POINT. Any subsequent departure from a PARKING POINT after parking marks the start of a new BLOCK. The period of a BLOCK has to be covered by DUTies. Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=3:5:958 ';
COMMENT ON COLUMN timetables.block.vehicle_service_id IS 'The VEHICLE SERVICE to which this BLOCK belongs.';
COMMENT ON COLUMN timetables.block.preparing_time IS 'Preparation time before start of vehicle service block.';
COMMENT ON COLUMN timetables.block.finishing_time IS 'Finishing time after end of vehicle service block.';
COMMENT ON COLUMN timetables.block.vehicle_type_id IS 'Reference to vehicle_type.vehicle_type.';

-------------------- Vehicle Journey --------------------

CREATE TABLE timetables.journey_type (
  type text PRIMARY KEY
);
COMMENT ON TABLE timetables.journey_type IS 'Enum table for defining allowed journey types.';

INSERT INTO timetables.journey_type
  (type)
  VALUES
  ('STANDARD'),
  ('DRY_RUN'),
  ('SERVICE_JOURNEY')
  ON CONFLICT (type) DO NOTHING;

CREATE TABLE timetables.vehicle_journey (
  vehicle_journey_id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  journey_pattern_ref_id uuid NOT NULL REFERENCES timetables.journey_pattern_ref (journey_pattern_ref_id),
  block_id uuid NOT NULL REFERENCES timetables.block(block_id) ON DELETE CASCADE,
  journey_name_i18n jsonb,
  turnaround_time interval,
  layover_time interval,
  contract_number text NOT NULL,
  journey_type text NOT NULL DEFAULT 'STANDARD' REFERENCES timetables.journey_type (type)
);
COMMENT ON TABLE timetables.vehicle_journey IS 'The planned movement of a public transport vehicle on a DAY TYPE from the start point to the end point of a JOURNEY PATTERN on a specified ROUTE. Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=3:1:1:831 ';
COMMENT ON COLUMN timetables.vehicle_journey.journey_pattern_ref_id IS 'The JOURNEY PATTERN on which the VEHICLE JOURNEY travels';
COMMENT ON COLUMN timetables.vehicle_journey.block_id IS 'The BLOCK to which this VEHICLE JOURNEY belongs';
COMMENT ON COLUMN timetables.vehicle_journey.journey_name_i18n IS 'Name that user can give to the vehicle journey.';
COMMENT ON COLUMN timetables.vehicle_journey.turnaround_time IS 'Turnaround time is the time taken by a vehicle to proceed from the end of a ROUTE to the start of another.';
COMMENT ON COLUMN timetables.vehicle_journey.layover_time IS 'LAYOVER TIMEs describe a certain time allowance that may be given at the end of each VEHICLE JOURNEY, before starting the next one, to compensate delays or for other purposes (e.g. rest time for the driver). This “layover time” can be regarded as a buffer time, which may or may not be actually consumed in real time operation.';
COMMENT ON COLUMN timetables.vehicle_journey.contract_number IS 'The contract number for this vehicle journey.';
COMMENT ON COLUMN timetables.vehicle_journey.journey_type IS 'STANDARD | DRY_RUN | SERVICE_JOURNEY';

-------------------- Passing Times --------------------

CREATE TABLE timetables.timetabled_passing_time (
  timetabled_passing_time_id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  vehicle_journey_id uuid NOT NULL REFERENCES timetables.vehicle_journey(vehicle_journey_id) ON DELETE CASCADE,
  scheduled_stop_point_in_journey_pattern_ref_id uuid REFERENCES timetables.scheduled_stop_point_in_journey_pattern_ref (scheduled_stop_point_in_journey_pattern_ref_id) NOT NULL,
  arrival_time interval NULL,
  departure_time interval NULL,
  passing_time interval NOT NULL GENERATED ALWAYS AS (coalesce(departure_time, arrival_time)) STORED
);
COMMENT ON TABLE timetables.timetabled_passing_time IS 'Long-term planned time data concerning public transport vehicles passing a particular POINT IN JOURNEY PATTERN on a specified VEHICLE JOURNEY for a certain DAY TYPE. Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=3:4:946 ';
COMMENT ON COLUMN timetables.timetabled_passing_time.vehicle_journey_id IS 'The VEHICLE JOURNEY to which this TIMETABLED PASSING TIME belongs';
COMMENT ON COLUMN timetables.timetabled_passing_time.scheduled_stop_point_in_journey_pattern_ref_id IS 'The SCHEDULED STOP POINT of the JOURNEY PATTERN where the vehicle passes';
COMMENT ON COLUMN timetables.timetabled_passing_time.arrival_time IS 'The time when the vehicle arrives to the SCHEDULED STOP POINT. Measured as interval counted from the midnight of the OPERATING DAY. When NULL, only the departure time is defined for the passing time. E.g. in case this is the first SCHEDULED STOP POINT of the journey.';
COMMENT ON COLUMN timetables.timetabled_passing_time.departure_time IS 'The time when the vehicle departs from the SCHEDULED STOP POINT. Measured as interval counted from the midnight of the OPERATING DAY. When NULL, only the arrival time is defined for the passing time. E.g. in case this is the last SCHEDULED STOP POINT of the journey.';
COMMENT ON COLUMN timetables.timetabled_passing_time.passing_time IS 'The time when the vehicle can be considered as passing a SCHEDULED STOP POINT. Computed field to ease development; it can never be NULL.';
CREATE TABLE timetables.day_type_active_on_day_of_week (
  day_type_id uuid REFERENCES timetables.day_type (day_type_id) NOT NULL,
  day_of_week int NOT NULL,
  PRIMARY KEY(day_type_id, day_of_week)
);
COMMENT ON TABLE timetables.day_type_active_on_day_of_week IS 'Tells on which days of week a particular DAY TYPE is active';
COMMENT ON COLUMN timetables.day_type_active_on_day_of_week.day_type_id IS 'The DAY TYPE for which we define the activeness';
COMMENT ON COLUMN timetables.day_type_active_on_day_of_week.day_of_week IS 'ISO week day definition (1 = Monday, 7 = Sunday)';

-- adding basic day types for other single weekdays too
INSERT INTO timetables.day_type
  (day_type_id, label, name_i18n)
VALUES
  ('d3dfb71f-8ee1-41fd-ad49-c4968c043290','MA','{"fi_FI": "Maanantai", "sv_FI": "Måndag", "en_US": "Monday"}'),
  ('c1d27421-dd3b-43b6-a0b9-7387aae488c9','TI','{"fi_FI": "Tiistai", "sv_FI": "Tistag", "en_US": "Tuesday"}'),
  ('5ec086a3-343c-42f0-a050-3464fc3d63de','KE','{"fi_FI": "Keskiviikko", "sv_FI": "Onsdag", "en_US": "Wednesday"}'),
  ('9c708e58-fb49-440e-b4bd-736b9275f53f','TO','{"fi_FI": "Torstai", "sv_FI": "Torsdag", "en_US": "Thursday"}');

-- setting that basic day types are active on which day(s)
INSERT INTO timetables.day_type_active_on_day_of_week
  (day_type_id, day_of_week)
VALUES
  -- Monday-Thursday
  ('6781bd06-08cf-489e-a2bb-be9a07b15752',1),
  ('6781bd06-08cf-489e-a2bb-be9a07b15752',2),
  ('6781bd06-08cf-489e-a2bb-be9a07b15752',3),
  ('6781bd06-08cf-489e-a2bb-be9a07b15752',4),
  -- Monday-Friday
  ('38853b0d-ec36-4110-b4bc-f53218c6cdcd',1),
  ('38853b0d-ec36-4110-b4bc-f53218c6cdcd',2),
  ('38853b0d-ec36-4110-b4bc-f53218c6cdcd',3),
  ('38853b0d-ec36-4110-b4bc-f53218c6cdcd',4),
  ('38853b0d-ec36-4110-b4bc-f53218c6cdcd',5),
  -- Monday
  ('d3dfb71f-8ee1-41fd-ad49-c4968c043290',1),
  -- Tuesday
  ('c1d27421-dd3b-43b6-a0b9-7387aae488c9',2),
  -- Wednesday
  ('5ec086a3-343c-42f0-a050-3464fc3d63de',3),
  -- Thursday
  ('9c708e58-fb49-440e-b4bd-736b9275f53f',4),
  -- Friday
  ('7176e238-d46e-4583-a567-b836b1ae2589',5),
  -- Saturday
  ('61374d2b-5cce-4a7d-b63a-d487f3a05e0d',6),
  -- Sunday
  ('0e1855f1-dfca-4900-a118-f608aa07e939',7);
CREATE INDEX idx_vehicle_service_day_type ON timetables.vehicle_service USING btree (day_type_id);
CREATE INDEX idx_vehicle_service_vehicle_schedule_frame ON timetables.vehicle_service USING btree (vehicle_schedule_frame_id);
CREATE INDEX idx_block_vehicle_service ON timetables.block USING btree (vehicle_service_id);
CREATE INDEX idx_vehicle_journey_block ON timetables.vehicle_journey USING btree (block_id);
CREATE INDEX idx_vehicle_journey_journey_pattern_ref ON timetables.vehicle_journey USING btree (journey_pattern_ref_id);
CREATE INDEX idx_timetabled_passing_time_sspijp_ref ON timetables.timetabled_passing_time USING btree (scheduled_stop_point_in_journey_pattern_ref_id);
CREATE INDEX idx_block_vehicle_type_id ON timetables.block (vehicle_type_id);
CREATE INDEX journey_pattern_ref_type_of_line ON timetables.journey_pattern_ref USING btree (type_of_line);
CREATE INDEX idx_journey_pattern_ref_journey_pattern_id ON timetables.journey_pattern_ref (journey_pattern_id);
CREATE INDEX idx_journey_pattern_ref_route_direction ON timetables.journey_pattern_ref USING btree (route_direction);

-- The unique index makes sure that every stop in the journey pattern sequence can be used only once.
-- This however does not affect loops as those are separate rows within the journey pattern.
CREATE UNIQUE INDEX timetabled_passing_time_stop_point_unique_idx
ON timetables.timetabled_passing_time USING btree (vehicle_journey_id, scheduled_stop_point_in_journey_pattern_ref_id);

-------------------- Journey Pattern --------------------


CREATE TABLE timetables.journey_patterns_in_vehicle_service (
  vehicle_service_id uuid NOT NULL REFERENCES timetables.vehicle_service (vehicle_service_id) ON DELETE CASCADE,
  journey_pattern_id uuid NOT NULL, --"references" journey_pattern.journey_pattern_ref (journey_pattern_id),
  reference_count integer NOT NULL,
  PRIMARY KEY(vehicle_service_id, journey_pattern_id)
);
CREATE INDEX idx_journey_patterns_in_vehicle_service_journey_pattern_id ON timetables.journey_patterns_in_vehicle_service (journey_pattern_id);

COMMENT ON TABLE timetables.journey_patterns_in_vehicle_service IS
'A denormalized table containing relationships between vehicle_services and journey_patterns (via journey_pattern_ref.journey_pattern_id).
 Without this table this relationship could be found via vehicle_service -> block -> vehicle_journey -> journey_pattern_ref.
 Kept up to date with triggers, should not be updated manually.';
COMMENT ON COLUMN timetables.journey_patterns_in_vehicle_service.journey_pattern_id IS
'The journey_pattern_id from journey_pattern.journey_pattern_ref.
 No foreign key reference is set because the target column is not unique.';
COMMENT ON COLUMN timetables.journey_patterns_in_vehicle_service.reference_count IS
 'The amount of unique references between the journey_pattern and vehicle_service.
  When this reaches 0 the row will be deleted.';

CREATE UNIQUE INDEX vehicle_type_label_idx ON timetables.vehicle_type USING btree(label);

CREATE INDEX idx_vehicle_journey_journey_type
  ON timetables.vehicle_journey USING btree (journey_type);

GRANT USAGE ON SCHEMA timetables TO xxx_db_timetables_api_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA timetables TO xxx_db_timetables_api_username_xxx;
GRANT INSERT ON ALL TABLES IN SCHEMA timetables TO xxx_db_timetables_api_username_xxx;
GRANT UPDATE ON ALL TABLES IN SCHEMA timetables TO xxx_db_timetables_api_username_xxx;
GRANT DELETE ON ALL TABLES IN SCHEMA timetables TO xxx_db_timetables_api_username_xxx;

-- Note: ALTER DEFAULT PRIVILEGES IN SCHEMA only adds GRANTs to *new* tables created after this migration
-- if using GRANT, it'll only apply to the *existing* tables
ALTER DEFAULT PRIVILEGES IN SCHEMA timetables GRANT SELECT ON TABLES TO xxx_db_timetables_api_username_xxx;

GRANT USAGE ON SCHEMA internal_utils TO xxx_db_timetables_api_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA internal_utils TO xxx_db_timetables_api_username_xxx;
GRANT INSERT ON ALL TABLES IN SCHEMA internal_utils TO xxx_db_timetables_api_username_xxx;
GRANT UPDATE ON ALL TABLES IN SCHEMA internal_utils TO xxx_db_timetables_api_username_xxx;
GRANT DELETE ON ALL TABLES IN SCHEMA internal_utils TO xxx_db_timetables_api_username_xxx;

GRANT USAGE ON SCHEMA return_value TO xxx_db_timetables_api_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA return_value TO xxx_db_timetables_api_username_xxx;
GRANT INSERT ON ALL TABLES IN SCHEMA return_value TO xxx_db_timetables_api_username_xxx;
GRANT UPDATE ON ALL TABLES IN SCHEMA return_value TO xxx_db_timetables_api_username_xxx;
GRANT DELETE ON ALL TABLES IN SCHEMA return_value TO xxx_db_timetables_api_username_xxx;

ALTER DEFAULT PRIVILEGES IN SCHEMA internal_utils GRANT SELECT ON TABLES TO xxx_db_timetables_api_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA return_value GRANT SELECT ON TABLES TO xxx_db_timetables_api_username_xxx;
