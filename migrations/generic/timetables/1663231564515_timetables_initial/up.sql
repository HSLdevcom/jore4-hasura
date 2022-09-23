-------------------- Journey Pattern --------------------

CREATE SCHEMA journey_pattern;
COMMENT ON SCHEMA journey_pattern IS 'The journey pattern model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:1:683 ';

CREATE TABLE journey_pattern.journey_pattern_ref (
  journey_pattern_ref_id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  journey_pattern_id UUID NOT NULL,
  observation_date_timestamp TIMESTAMP WITH TIME ZONE NOT NULL,
  snapshot_timestamp TIMESTAMP WITH TIME ZONE NOT NULL
);
COMMENT ON TABLE journey_pattern.journey_pattern_ref IS 'Reference to a given snapshot of a JOURNEY PATTERN for a given operating day. Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:4:729 ';
COMMENT ON COLUMN journey_pattern.journey_pattern_ref.journey_pattern_id IS 'The ID of the referenced JOURNEY PATTERN';
COMMENT ON COLUMN journey_pattern.journey_pattern_ref.observation_date_timestamp IS 'The observation date of which the JOURNEY PATTERN snapshot was taken for';
COMMENT ON COLUMN journey_pattern.journey_pattern_ref.snapshot_timestamp IS 'The date when the snapshot was taken';

-------------------- Service Pattern --------------------

CREATE SCHEMA service_pattern;
COMMENT ON SCHEMA service_pattern IS 'The service pattern model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:4:723 ';

CREATE TABLE service_pattern.scheduled_stop_point_in_journey_pattern_ref (
  scheduled_stop_point_in_journey_pattern_ref_id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  journey_pattern_ref_id UUID REFERENCES journey_pattern.journey_pattern_ref (journey_pattern_ref_id),
  scheduled_stop_point_label TEXT NOT NULL,
  scheduled_stop_point_label_passing INT NOT NULL DEFAULT 1
);
COMMENT ON TABLE service_pattern.scheduled_stop_point_in_journey_pattern_ref IS 'Reference the a SCHEDULED STOP POINT within a JOURNEY PATTERN. Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:4:729 ';
COMMENT ON COLUMN service_pattern.scheduled_stop_point_in_journey_pattern_ref.journey_pattern_ref_id IS 'JOURNEY PATTERN to which the SCHEDULED STOP POINT belongs';
COMMENT ON COLUMN service_pattern.scheduled_stop_point_in_journey_pattern_ref.scheduled_stop_point_label IS 'The label of the SCHEDULED STOP POINT';
COMMENT ON COLUMN service_pattern.scheduled_stop_point_in_journey_pattern_ref.scheduled_stop_point_label_passing IS 'The occurrence of the same SCHEDULED STOP POINT within the JOURNEY PATTERN. "1" marks first passing, "2" marks the second passing and so on';

-------------------- Service Calendar --------------------

CREATE SCHEMA service_calendar;
COMMENT ON SCHEMA service_calendar IS 'The service calendar model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=1:6:3:294 ';

-- = päivätyyppi, erikoispäivätyyppi. E.g. "Monday-Thursday" or "Christmas day"
CREATE TABLE service_calendar.day_type (
  day_type_id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  label TEXT NOT NULL,
  name JSONB NOT NULL,
  priority int NOT NULL,
  UNIQUE (label)
);
COMMENT ON TABLE service_calendar.day_type IS 'A type of day characterised by one or more properties which affect public transport operation. For example: weekday in school holidays. Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=1:6:3:299 ';
COMMENT ON COLUMN service_calendar.day_type.label IS 'The label for the DAY TYPE. Used for identifying the DAY TYPE when importing data from Hastus. Includes both basic (e.g. "Monday-Thursday") and special ("Easter Sunday") day types';
COMMENT ON COLUMN service_calendar.day_type.name IS 'Human-readable name for the DAY TYPE';
COMMENT ON COLUMN service_calendar.day_type.priority IS 'The priority of the DAY TYPE definition. The definition may be overridden by higher priority definitions.';

-- basic day types are built-in
INSERT INTO service_calendar.day_type
  (day_type_id, label, name, priority)
VALUES
  ('6781bd06-08cf-489e-a2bb-be9a07b15752', 'MT','{"fi_FI": "Maanantai - Torstai", "sv_FI": "Måndag - Torsdag"}', 10),
  ('38853b0d-ec36-4110-b4bc-f53218c6cdcd', 'MP','{"fi_FI": "Maanantai - Perjantai", "sv_FI": "Måndag - Fredag"}', 10),
  ('7176e238-d46e-4583-a567-b836b1ae2589', 'PE','{"fi_FI": "Perjantai", "sv_FI": "Fredag"}', 10),
  ('61374d2b-5cce-4a7d-b63a-d487f3a05e0d', 'LA','{"fi_FI": "Lauantai", "sv_FI": "Lördag"}', 10),
  ('0e1855f1-dfca-4900-a118-f608aa07e939', 'SU','{"fi_FI": "Sunnuntai", "sv_FI": "Söndag"}', 10);

-------------------- Vehicle Schedule --------------------

CREATE SCHEMA vehicle_schedule;
COMMENT ON SCHEMA vehicle_schedule IS 'The vehicle schedule frame adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=3:7:2:993 ';

-- = liikennöintikausi. E.g. 22KES
CREATE TABLE vehicle_schedule.vehicle_schedule_frame (
  vehicle_schedule_frame_id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  label TEXT NOT NULL,
  name JSONB NOT NULL,
  validity_start DATE NULL,
  validity_end DATE NULL,
  UNIQUE (label)
);
COMMENT ON TABLE vehicle_schedule.vehicle_schedule_frame IS 'A coherent set of BLOCKS, COMPOUND BLOCKs, COURSEs of JOURNEY and VEHICLE SCHEDULEs to which the same set of VALIDITY CONDITIONs have been assigned. Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=3:7:2:993 ';
COMMENT ON COLUMN vehicle_schedule.vehicle_schedule_frame.label IS 'The label for the VEHICLE SCHEDULE FRAME';
COMMENT ON COLUMN vehicle_schedule.vehicle_schedule_frame.name IS 'Human-readable name for the VEHICLE SCHEDULE FRAME';
COMMENT ON COLUMN vehicle_schedule.vehicle_schedule_frame.validity_start IS 'OPERATING DAY when the VEHICLE SCHEDULE FRAME validity starts. Null if always has been valid.';
COMMENT ON COLUMN vehicle_schedule.vehicle_schedule_frame.validity_end IS 'OPERATING DAY when the VEHICLE SCHEDULE FRAME validity end. Null if always will be valid.';

-------------------- Vehicle Service --------------------

CREATE SCHEMA vehicle_service;
COMMENT ON SCHEMA vehicle_service IS 'The vehicle service model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=3:5:947 ';

CREATE TABLE vehicle_service.vehicle_service (
  vehicle_service_id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  day_type_id UUID REFERENCES service_calendar.day_type (day_type_id),
  vehicle_schedule_frame_id UUID REFERENCES vehicle_schedule.vehicle_schedule_frame (vehicle_schedule_frame_id)
);
COMMENT ON TABLE vehicle_service.vehicle_service IS 'A work plan for a single vehicle for a whole day, planned for a specific DAY TYPE. A VEHICLE SERVICE includes one or several VEHICLE SERVICE PARTs. Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=3:5:965 ';
COMMENT ON COLUMN vehicle_service.vehicle_service.day_type_id IS 'The DAY TYPE for the VEHICLE SERVICE.';
COMMENT ON COLUMN vehicle_service.vehicle_service.vehicle_schedule_frame_id IS 'Human-readable name for the VEHICLE SCHEDULE FRAME';

CREATE TABLE vehicle_service.block (
  block_id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  vehicle_service_id UUID REFERENCES vehicle_service.vehicle_service (vehicle_service_id)
);
COMMENT ON TABLE vehicle_service.block IS 'The work of a vehicle from the time it leaves a PARKING POINT after parking until its next return to park at a PARKING POINT. Any subsequent departure from a PARKING POINT after parking marks the start of a new BLOCK. The period of a BLOCK has to be covered by DUTies. Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=3:5:958 ';
COMMENT ON COLUMN vehicle_service.block.vehicle_service_id IS 'The VEHICLE SERVICE to which this BLOCK belongs.';

-------------------- Vehicle Journey --------------------

CREATE SCHEMA vehicle_journey;
COMMENT ON SCHEMA vehicle_journey IS 'The vehicle journey model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=3:1:1:824 ';

CREATE TABLE vehicle_journey.vehicle_journey (
  vehicle_journey_id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  journey_pattern_ref_id uuid REFERENCES journey_pattern.journey_pattern_ref (journey_pattern_ref_id),
  block_id UUID REFERENCES vehicle_service.block (block_id)
);
COMMENT ON TABLE vehicle_journey.vehicle_journey IS 'The planned movement of a public transport vehicle on a DAY TYPE from the start point to the end point of a JOURNEY PATTERN on a specified ROUTE. Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=3:1:1:831 ';
COMMENT ON COLUMN vehicle_journey.vehicle_journey.journey_pattern_ref_id IS 'The JOURNEY PATTERN on which the VEHICLE JOURNEY travels';
COMMENT ON COLUMN vehicle_journey.vehicle_journey.block_id IS 'The BLOCK to which this VEHICLE JOURNEY belongs';

-------------------- Passing Times --------------------

CREATE SCHEMA passing_times;
COMMENT ON SCHEMA passing_times IS 'The passing times model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=3:4:939 ';

CREATE TABLE passing_times.timetabled_passing_time (
  timetabled_passing_time_id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  vehicle_journey_id UUID REFERENCES vehicle_journey.vehicle_journey (vehicle_journey_id),
  scheduled_stop_point_in_journey_pattern_ref_id UUID REFERENCES service_pattern.scheduled_stop_point_in_journey_pattern_ref (scheduled_stop_point_in_journey_pattern_ref_id),
  arrival_time INTERVAL NOT NULL,
  departure_time INTERVAL NULL
);
COMMENT ON TABLE passing_times.timetabled_passing_time IS 'Long-term planned time data concerning public transport vehicles passing a particular POINT IN JOURNEY PATTERN on a specified VEHICLE JOURNEY for a certain DAY TYPE. Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=3:4:946 ';
COMMENT ON COLUMN passing_times.timetabled_passing_time.vehicle_journey_id IS 'The VEHICLE JOURNEY to which this TIMETABLED PASSING TIME belongs';
COMMENT ON COLUMN passing_times.timetabled_passing_time.scheduled_stop_point_in_journey_pattern_ref_id IS 'The SCHEDULED STOP POINT of the JOURNEY PATTERN where the vehicle passes';
COMMENT ON COLUMN passing_times.timetabled_passing_time.arrival_time IS 'The time when the vehicle arrives to the SCHEDULED STOP POINT. Measured as interval counted from the midnight of the OPERATING DAY';
COMMENT ON COLUMN passing_times.timetabled_passing_time.departure_time IS 'The time when the vehicle departs from the SCHEDULED STOP POINT. Measured as interval counted from the midnight of the OPERATING DAY';
