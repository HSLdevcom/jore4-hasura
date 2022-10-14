-------------------- Timing Pattern --------------------

CREATE SCHEMA timing_pattern;
COMMENT ON SCHEMA timing_pattern IS 'The timing pattern model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:2:703 ';

CREATE TABLE timing_pattern.timing_point (
  timing_point_id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  label TEXT NOT NULL,
  description JSONB NULL,
  UNIQUE (label)
);
COMMENT ON TABLE timing_pattern.timing_point IS 'A POINT against which the timing information necessary to build schedules may be recorded. In HSL context this is "Hastus paikka". At HSL every TIMING POINT must also be a SCHEDULED STOP POINT. Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:2:709 ';

-------------------- Service Pattern --------------------

ALTER TABLE service_pattern.scheduled_stop_point
  ADD COLUMN timing_point_id UUID REFERENCES timing_pattern.timing_point (timing_point_id) NULL;
COMMENT ON COLUMN service_pattern.scheduled_stop_point.timing_point_id IS 'Optional reference to a TIMING POINT. If NULL, the SCHEDULED STOP POINT is not used for timing.';
