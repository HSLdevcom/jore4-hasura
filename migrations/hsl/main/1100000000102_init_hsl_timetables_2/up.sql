
ALTER TABLE ONLY timetables.substitute_operating_day_by_line_type
  ADD CONSTRAINT substitute_operating_day_by_line_type_pkey
  PRIMARY KEY (substitute_operating_day_by_line_type_id);

ALTER TABLE ONLY timetables.substitute_operating_day_by_line_type
  ADD CONSTRAINT substitute_operating_day_by_line_type_type_of_line_fkey
  FOREIGN KEY (type_of_line) REFERENCES network.type_of_line(type_of_line);

CREATE INDEX substitute_operating_day_by_line_type_type_of_line
  ON timetables.substitute_operating_day_by_line_type USING btree (type_of_line);

COMMENT ON TABLE timetables.substitute_operating_day_by_line_type IS
  'Models substitute public transit as (1) a reference day or (2) indicating that public transit does not occur on certain date. Substitute operating days are always bound to a type of line.';
COMMENT ON COLUMN timetables.substitute_operating_day_by_line_type.type_of_line IS 'The type of line this substitute operating day is bound to.';
COMMENT ON COLUMN timetables.substitute_operating_day_by_line_type.superseded_date IS 'The date of operating day being superseded.';
COMMENT ON COLUMN timetables.substitute_operating_day_by_line_type.substitute_day_of_week IS
  'The ISO day of week (1=Monday, ... , 7=Sunday) of the day type used as the basis for operating day substitution. A NULL value indicates that there is no public transit at all, i.e. no vehicle journeys are operated within the given time period.';
COMMENT ON COLUMN timetables.substitute_operating_day_by_line_type.begin_time IS
  'The time from which the substituting public transit comes into effect. If NULL, the substitution is in effect from the start of the operating day. When substitute_day_of_week is not NULL (reference day case), vehicle journeys prior to this time are not operated. When substitute_day_of_week is NULL (no traffic case), the vehicle journeys before this time are operated as usual.';
COMMENT ON COLUMN timetables.substitute_operating_day_by_line_type.end_time IS
  'The time (exclusive) until which the substituting public transit is valid. If NULL, the substitution is in effect until the end of the operating day. When substitute_day_of_week is not NULL (reference day case), vehicle journeys starting from this time are not operated. When substitute_day_of_week is NULL (no traffic case), the vehicle journeys starting from this time are operated as usual.';
COMMENT ON COLUMN timetables.substitute_operating_day_by_line_type.begin_datetime IS 'Calculated timestamp for the instant from which the substituting public transit comes into effect.';
COMMENT ON COLUMN timetables.substitute_operating_day_by_line_type.end_datetime IS 'Calculated timestamp for the instant (exclusive) until which the substituting public transit is in effect.';

CREATE UNIQUE INDEX vehicle_type_hsl_id_idx ON timetables.vehicle_type USING btree(hsl_id);

INSERT INTO timetables.vehicle_type
  (vehicle_type_id, hsl_id, label, description_i18n)
VALUES
  ('27ed17a8-ac64-4f6a-b3e8-41c95d8ab153', 0, 'Low multi-axle bus', '{"fi_FI": "Matala telibussi"}'),
  ('b51470c1-8cc7-4508-ac83-eaf8976d67e0', 1, 'High 2-axle bus', '{"fi_FI": "Korkea 2-akselinen bussi"}'),
  ('5705e3de-bea4-4cb3-ac50-76c6332898d1', 2, 'High articulated bus', '{"fi_FI": "Korkea nivelbussi"}'),
  ('9e431f63-1925-45a6-a222-cad58d339da9', 3, 'Low A1 bus', '{"fi_FI": "Matala A1 -bussi"}'),
  ('60db118d-db21-44da-acf5-08f569372373', 7, 'Euro 4 2-axle', '{"fi_FI": "Euro 4 2-aks"}'),
  ('91f63622-044f-4280-be6a-f75cb8311557', 8, 'Low articulated bus', '{"fi_FI": "Matala nivelbussi"}'),
  ('5cb94060-73db-41b6-a892-23cbc13da816', 9, 'Low midibus', '{"fi_FI": "Matala midibussi"}'),
  ('92d8179d-1f79-424d-97b8-688be3f2e85d', 10, 'Euro 4 multi-axle', '{"fi_FI": "Euro 4 teli"}'),
  ('0942ff2e-d3ba-4652-b4aa-911835c60011', 11, 'High gasbus', '{"fi_FI": "Korkea kaasubussi"}'),
  ('b24f8f2d-bb9e-48ed-a9e8-96abe27a4549', 12, 'Mini A', '{"fi_FI": "Mini A"}'),
  ('78162473-168b-487e-a4d7-2195e90ac1b7', 13, 'Mini B', '{"fi_FI": "Mini B"}'),
  ('67cf53ca-7edb-4ed1-a8b1-71d6d58afbc9', 14, 'Mini Dab', '{"fi_FI": "Mini Dab"}'),
  ('3dc05ccb-d3d8-431e-911f-9e8bf4de9b82', 15, 'EEV 2-axle A1', '{"fi_FI": "EEV 2-akselinen A1"}'),
  ('6acaa0a6-d260-453c-a7a4-d7be3714d26a', 16, 'EEV Multi-axle bus', '{"fi_FI": "EEV Telibussi"}'),
  ('e3475423-c8ae-4a41-b9ac-0dce4a29ba25', 17, 'Low A2 Bus', '{"fi_FI": "Matala A2 -bussi"}'),
  ('bdf8bd2c-7166-4b60-b8cd-0eb95bba6919', 18, 'High 43 seated', '{"fi_FI": "Korkea 43-paikkainen"}'),
  ('5a053aa9-e4d7-4a6e-8586-06645f8be8c2', 20, '2-Axled hybrid A1', '{"fi_FI": "2-akselinen hybridi A1"}'),
  ('3590c14b-8a05-449c-bf74-2031ec277651', 21, 'A1 electrical bus', '{"fi_FI": "A1 sähköbussi"}'),
  ('55b5784f-5805-46eb-a842-a25fce9eb560', 22, 'A2 electrical bus', '{"fi_FI": "A2 sähköbussi"}');

CREATE TABLE return_value.timetable_version (
  vehicle_schedule_frame_id uuid NULL,
  substitute_operating_day_by_line_type_id uuid NULL,
  validity_start date NOT NULL,
  validity_end date NOT NULL,
  priority integer NOT NULL,
  in_effect boolean NOT NULL,
  day_type_id uuid NOT NULL
);

COMMENT ON TABLE return_value.timetable_version 
IS 'This return value is used for functions that determine what timetable versions are in effect. In effect will be true for all the timetable version rows that
are valid on given observation day and are the highest priority of that day type. As an example if we have:
Saturday Standard priority valid for 1.1.2023 - 30.6.2023
Saturday Temporary priority valid for 1.5.2023 - 31.5.2023
Saturday Special priority valid for 20.5.2023 - 20.5.2023

If we check the timetable versions for the date 1.2.2023, for Saturday we only get the Standard priority, beacuse it is the only one valid on that time. So that 
row would have in_effect = true. 
If we check the timetable versions for the date 1.5.2023, for Saturday we would get the Standard and the Temporary priority for this date, as they are both valid.
But only the higher priority is in effect on this date. So the Saturday Temporary priority would have in_effect = true, and the Saturday Standard priority would 
have in_effect = false.
If we check the timetable versions for the date 20.5.2023, for Saturday we have all three valid, but only one can be in_effect, and that would be the Special 
priority in this case.
';

CREATE TABLE timetables.substitute_operating_period (
    substitute_operating_period_id uuid DEFAULT gen_random_uuid(),
    period_name text NOT NULL,
    is_preset boolean NOT NULL DEFAULT FALSE
);

ALTER TABLE ONLY timetables.substitute_operating_period
ADD CONSTRAINT substitute_operating_period_pkey PRIMARY KEY (substitute_operating_period_id);

COMMENT ON TABLE timetables.substitute_operating_period IS 'Models substitute operating period that consists of substitute operating days by line types.';
COMMENT ON COLUMN timetables.substitute_operating_period.period_name IS 'Substitute operating period''s name';
COMMENT ON COLUMN timetables.substitute_operating_period.is_preset IS 'Flag indicating whether operating period is preset or not. Preset operating periods have restrictions on the UI';

ALTER TABLE ONLY timetables.substitute_operating_day_by_line_type
ADD COLUMN substitute_operating_period_id uuid NOT NULL;

ALTER TABLE ONLY timetables.substitute_operating_day_by_line_type
ADD CONSTRAINT substitute_operating_day_by_line_type_substitute_period_fkey FOREIGN KEY (substitute_operating_period_id) REFERENCES timetables.substitute_operating_period(substitute_operating_period_id) ON DELETE CASCADE;

CREATE INDEX substitute_operating_day_by_line_type_substitute_period
ON timetables.substitute_operating_day_by_line_type USING btree (substitute_operating_period_id);

COMMENT ON COLUMN timetables.substitute_operating_day_by_line_type.substitute_operating_period_id IS 'The id of the substitute operating period';

ALTER TABLE timetables.substitute_operating_day_by_line_type
  ADD COLUMN created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW();

CREATE TABLE return_value.vehicle_schedule (
  vehicle_journey_id uuid,
  validity_start date NOT NULL,
  validity_end date NOT NULL,
  priority integer NOT NULL,
  day_type_id uuid NOT NULL,
  vehicle_schedule_frame_id uuid,
  substitute_operating_day_by_line_type_id uuid,
  created_at timestamp with time zone
);

COMMENT ON TABLE return_value.vehicle_schedule
IS 'This return value table is used in function vehicle_journey.get_vehicle_schedules_on_date. It consists of vehicle_journey_id, vehicle_schedule_frame_id or
substitute_operating_day_by_line_type_id and also enriched with data, which are used in the UI side.';

