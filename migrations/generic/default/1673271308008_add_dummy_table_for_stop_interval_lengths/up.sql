CREATE TABLE service_pattern.stop_interval_length (
  journey_pattern_id      uuid NOT NULL,
  route_id                uuid NOT NULL,
  route_priority          integer NOT NULL,
  observation_date        date NOT NULL,
  stop_interval_sequence  integer NOT NULL,
  start_stop_label        text NOT NULL,
  end_stop_label          text NOT NULL,
  distance_in_metres      double precision NOT NULL
);

ALTER TABLE ONLY service_pattern.stop_interval_length 
  ADD CONSTRAINT stop_interval_length_pkey PRIMARY KEY (journey_pattern_id, route_priority, observation_date, stop_interval_sequence);
