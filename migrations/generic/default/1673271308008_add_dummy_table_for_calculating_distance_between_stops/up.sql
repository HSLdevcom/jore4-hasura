CREATE TABLE service_pattern.distance_between_stops_calculation (
  journey_pattern_id      uuid NOT NULL,
  route_id                uuid NOT NULL,
  route_priority          integer NOT NULL,
  observation_date        date NOT NULL,
  stop_interval_sequence  integer NOT NULL,
  start_stop_label        text NOT NULL,
  end_stop_label          text NOT NULL,
  distance_in_metres      double precision NOT NULL
);

ALTER TABLE ONLY service_pattern.distance_between_stops_calculation
  ADD CONSTRAINT distance_between_stops_calculation_pkey PRIMARY KEY (journey_pattern_id, route_priority, observation_date, stop_interval_sequence);

COMMENT ON TABLE service_pattern.distance_between_stops_calculation IS
  'A dummy table that models the results of calculating the lengths of stop intervals from the given journey patterns. The table exists due to the limitations of Hasura and there is no intention to insert anything to it.';
COMMENT ON COLUMN service_pattern.distance_between_stops_calculation.journey_pattern_id IS
  'The ID of the journey pattern.';
COMMENT ON COLUMN service_pattern.distance_between_stops_calculation.route_id IS
  'The ID of the route related to the journey pattern.';
COMMENT ON COLUMN service_pattern.distance_between_stops_calculation.route_priority IS
  'The priority of the route related to the journey pattern.';
COMMENT ON COLUMN service_pattern.distance_between_stops_calculation.observation_date IS
  'The observation date for the state of the route related to the journey pattern.';
COMMENT ON COLUMN service_pattern.distance_between_stops_calculation.stop_interval_sequence IS
  'The sequence number of the stop interval within the journey pattern.';
COMMENT ON COLUMN service_pattern.distance_between_stops_calculation.start_stop_label IS
  'The label of the start stop of the stop interval.';
COMMENT ON COLUMN service_pattern.distance_between_stops_calculation.end_stop_label IS
  'The label of the end stop of the stop interval.';
COMMENT ON COLUMN service_pattern.distance_between_stops_calculation.distance_in_metres IS
  'The length of the stop interval in metres.';
