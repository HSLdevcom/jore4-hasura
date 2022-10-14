-------------------- Timing Pattern --------------------

CREATE SCHEMA timing_pattern;
COMMENT ON SCHEMA timing_pattern IS 'The timing pattern model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:2:703 ';

CREATE TABLE timing_pattern.timing_place (
  timing_place_id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  label TEXT NOT NULL,
  description JSONB NULL,
  UNIQUE (label)
);
COMMENT ON TABLE timing_pattern.timing_place IS 'A set of SCHEDULED STOP POINTs against which the timing information necessary to build schedules may be recorded. In HSL context this is "Hastus paikka". Based on Transmodel entity TIMING POINT: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:2:709 ';

-------------------- Service Pattern --------------------

ALTER TABLE service_pattern.scheduled_stop_point
  ADD COLUMN timing_place_id UUID REFERENCES timing_pattern.timing_place (timing_place_id) NULL;
COMMENT ON COLUMN service_pattern.scheduled_stop_point.timing_place_id IS 'Optional reference to a TIMING PLACE. If NULL, the SCHEDULED STOP POINT is not used for timing.';
