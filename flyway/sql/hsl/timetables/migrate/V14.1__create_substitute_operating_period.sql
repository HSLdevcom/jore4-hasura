CREATE TABLE service_calendar.substitute_operating_period (
    substitute_operating_period_id uuid DEFAULT gen_random_uuid(),
    period_name text NOT NULL,
    is_preset boolean NOT NULL DEFAULT FALSE
);

ALTER TABLE ONLY service_calendar.substitute_operating_period
ADD CONSTRAINT substitute_operating_period_pkey PRIMARY KEY (substitute_operating_period_id);

COMMENT ON TABLE service_calendar.substitute_operating_period IS 'Models substitute operating period that consists of substitute operating days by line types.';
COMMENT ON COLUMN service_calendar.substitute_operating_period.period_name IS 'Substitute operating period''s name';
COMMENT ON COLUMN service_calendar.substitute_operating_period.is_preset IS 'Flag indicating whether operating period is preset or not. Preset operating periods have restrictions on the UI';

ALTER TABLE ONLY service_calendar.substitute_operating_day_by_line_type
ADD COLUMN substitute_operating_period_id uuid NOT NULL;

ALTER TABLE ONLY service_calendar.substitute_operating_day_by_line_type
ADD CONSTRAINT substitute_operating_day_by_line_type_substitute_period_fkey FOREIGN KEY (substitute_operating_period_id) REFERENCES service_calendar.substitute_operating_period(substitute_operating_period_id) ON DELETE CASCADE;

CREATE INDEX substitute_operating_day_by_line_type_substitute_period
ON service_calendar.substitute_operating_day_by_line_type USING btree (substitute_operating_period_id);

COMMENT ON COLUMN service_calendar.substitute_operating_day_by_line_type.substitute_operating_period_id IS 'The id of the substitute operating period';
