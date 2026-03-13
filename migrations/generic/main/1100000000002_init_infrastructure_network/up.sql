---------- Infrastructure Network ----------

CREATE TABLE infrastructure_network.external_source (
    value text NOT NULL
);
INSERT INTO infrastructure_network.external_source VALUES ('digiroad_r_mml'), ('fixup'), ('digiroad_r_supplementary');
COMMENT ON TABLE infrastructure_network.external_source IS 'An external source from which infrastructure network parts are imported';
ALTER TABLE ONLY infrastructure_network.external_source
    ADD CONSTRAINT external_source_pkey PRIMARY KEY (value);

CREATE TABLE infrastructure_network.direction (
    value text NOT NULL
);
COMMENT ON TABLE infrastructure_network.direction IS 'The direction in which an e.g. infrastructure link can be traversed';
ALTER TABLE ONLY infrastructure_network.direction
    ADD CONSTRAINT direction_pkey PRIMARY KEY (value);
INSERT INTO infrastructure_network.direction VALUES ('forward'), ('backward'), ('bidirectional');

CREATE TABLE infrastructure_network.infrastructure_link (
    infrastructure_link_id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    direction text NOT NULL,
    shape public.geography(LineStringZ,4326) NOT NULL,
    estimated_length_in_metres double precision,
    external_link_id text NOT NULL,
    external_link_source text NOT NULL
);
COMMENT ON TABLE infrastructure_network.infrastructure_link IS 'The infrastructure links, e.g. road or rail elements: https://www.transmodel-cen.eu/model/index.htm?goto=2:1:1:1:453';
COMMENT ON COLUMN infrastructure_network.infrastructure_link.infrastructure_link_id IS 'The ID of the infrastructure link.';
COMMENT ON COLUMN infrastructure_network.infrastructure_link.direction IS 'The direction(s) of traffic with respect to the digitization, i.e. the direction of the specified line string.';
COMMENT ON COLUMN infrastructure_network.infrastructure_link.shape IS 'A PostGIS LinestringZ geography in EPSG:4326 describing the infrastructure link.';
COMMENT ON COLUMN infrastructure_network.infrastructure_link.estimated_length_in_metres IS 'The estimated length of the infrastructure link in metres.';
ALTER TABLE ONLY infrastructure_network.infrastructure_link
    ADD CONSTRAINT infrastructure_link_pkey PRIMARY KEY (infrastructure_link_id);
ALTER TABLE ONLY infrastructure_network.infrastructure_link
    ADD CONSTRAINT infrastructure_link_direction_fkey FOREIGN KEY (direction) REFERENCES infrastructure_network.direction(value);
ALTER TABLE ONLY infrastructure_network.infrastructure_link
    ADD CONSTRAINT infrastructure_link_external_link_source_fkey FOREIGN KEY (external_link_source) REFERENCES infrastructure_network.external_source(value);
CREATE INDEX idx_infrastructure_link_external_link_source_fkey ON infrastructure_network.infrastructure_link USING btree (external_link_source);
CREATE UNIQUE INDEX infrastructure_link_external_link_id_external_link_source_idx ON infrastructure_network.infrastructure_link USING btree (external_link_id, external_link_source);
CREATE INDEX idx_infrastructure_link_direction ON infrastructure_network.infrastructure_link USING btree (direction);

CREATE TABLE infrastructure_network.vehicle_submode_on_infrastructure_link (
    infrastructure_link_id uuid NOT NULL,
    vehicle_submode text NOT NULL
);
COMMENT ON TABLE infrastructure_network.vehicle_submode_on_infrastructure_link IS 'Which infrastructure links are safely traversed by which vehicle submodes?';
COMMENT ON COLUMN infrastructure_network.vehicle_submode_on_infrastructure_link.infrastructure_link_id IS 'The infrastructure link that can be safely traversed by the vehicle submode.';
COMMENT ON COLUMN infrastructure_network.vehicle_submode_on_infrastructure_link.vehicle_submode IS 'The vehicle submode that can safely traverse the infrastructure link.';
ALTER TABLE ONLY infrastructure_network.vehicle_submode_on_infrastructure_link
    ADD CONSTRAINT vehicle_submode_on_infrastructure_link_pkey PRIMARY KEY (infrastructure_link_id, vehicle_submode);
ALTER TABLE ONLY infrastructure_network.vehicle_submode_on_infrastructure_link
    ADD CONSTRAINT vehicle_submode_on_infrastructure_link_infrastructure_link_id_f FOREIGN KEY (infrastructure_link_id) REFERENCES infrastructure_network.infrastructure_link(infrastructure_link_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY infrastructure_network.vehicle_submode_on_infrastructure_link
    ADD CONSTRAINT vehicle_submode_on_infrastructure_link_vehicle_submode_fkey FOREIGN KEY (vehicle_submode) REFERENCES reusable_components.vehicle_submode(vehicle_submode);
CREATE INDEX vehicle_submode_on_infrastruc_vehicle_submode_infrastructur_idx ON infrastructure_network.vehicle_submode_on_infrastructure_link USING btree (vehicle_submode, infrastructure_link_id);

---------- Route ----------

CREATE TABLE network.route_direction (
    direction text NOT NULL,
    the_opposite_of_direction text
);
COMMENT ON TABLE network.route_direction IS 'The route directions from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:1:3:480';
COMMENT ON COLUMN network.route_direction.direction IS 'The name of the route direction.';
COMMENT ON COLUMN network.route_direction.the_opposite_of_direction IS 'The opposite direction.';
ALTER TABLE ONLY network.route_direction
    ADD CONSTRAINT direction_pkey PRIMARY KEY (direction);
ALTER TABLE ONLY network.route_direction
    ADD CONSTRAINT direction_the_opposite_of_direction_fkey FOREIGN KEY (the_opposite_of_direction) REFERENCES network.route_direction(direction);
CREATE INDEX idx_direction_the_opposite_of_direction ON network.route_direction USING btree (the_opposite_of_direction);
INSERT INTO network.route_direction
  (direction, the_opposite_of_direction)
  VALUES
  ('inbound', 'outbound'),
  ('outbound', 'inbound'),
  ('clockwise', 'anticlockwise'),
  ('anticlockwise', 'clockwise'),
  ('northbound', 'southbound'),
  ('southbound', 'northbound'),
  ('eastbound', 'westbound'),
  ('westbound', 'eastbound')
  ON CONFLICT (direction)
    DO UPDATE SET the_opposite_of_direction = EXCLUDED.the_opposite_of_direction;

CREATE TABLE network.type_of_line (
    type_of_line text NOT NULL,
    belonging_to_vehicle_mode text NOT NULL
);
COMMENT ON TABLE network.type_of_line IS 'Type of line. https://www.transmodel-cen.eu/model/EARoot/EA2/EA1/EA3/EA491.htm';
COMMENT ON COLUMN network.type_of_line.type_of_line IS 'GTFS route type: https://developers.google.com/transit/gtfs/reference/extended-route-types';
ALTER TABLE ONLY network.type_of_line
    ADD CONSTRAINT type_of_line_pkey PRIMARY KEY (type_of_line);
ALTER TABLE ONLY network.type_of_line
    ADD CONSTRAINT type_of_line_belonging_to_vehicle_mode_fkey FOREIGN KEY (belonging_to_vehicle_mode) REFERENCES reusable_components.vehicle_mode(vehicle_mode);
CREATE INDEX type_of_line_belonging_to_vehicle_mode_idx ON network.type_of_line USING btree (belonging_to_vehicle_mode);
INSERT INTO network.type_of_line
  (type_of_line, belonging_to_vehicle_mode)
  VALUES
  ('regional_rail_service', 'train'),
  ('suburban_railway', 'train'),
  ('metro_service', 'metro'),
  ('regional_bus_service', 'bus'),
  ('express_bus_service', 'bus'),
  ('stopping_bus_service', 'bus'),
  ('special_needs_bus', 'bus'),
  ('demand_and_response_bus_service', 'bus'),
  ('city_tram_service', 'tram'),
  ('regional_tram_service', 'tram'),
  ('ferry_service', 'ferry')
  ON CONFLICT (type_of_line) DO NOTHING;

CREATE TABLE network.line (
    line_id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name_i18n jsonb NOT NULL,
    short_name_i18n jsonb NOT NULL,
    primary_vehicle_mode text NOT NULL,
    validity_start date,
    validity_end date,
    priority integer NOT NULL,
    label text NOT NULL,
    type_of_line text NOT NULL,
    description text
);
COMMENT ON TABLE network.line IS 'The line from Transmodel: http://www.transmodel-cen.eu/model/index.htm?goto=2:1:3:487';
COMMENT ON COLUMN network.line.line_id IS 'The ID of the line.';
COMMENT ON COLUMN network.line.name_i18n IS 'The name of the line. Placeholder for multilingual strings.';
COMMENT ON COLUMN network.line.short_name_i18n IS 'The shorted name of the line. Placeholder for multilingual strings.';
COMMENT ON COLUMN network.line.primary_vehicle_mode IS 'The mode of the vehicles used as primary on the line.';
COMMENT ON COLUMN network.line.validity_start IS 'The point in time when the line becomes valid (inclusive). If NULL, the line has been always valid.';
COMMENT ON COLUMN network.line.validity_end IS 'The point in time from which onwards the line is no longer valid (inclusive). If NULL, the line will be always valid.';
COMMENT ON COLUMN network.line.priority IS 'The priority of the line definition. The definition may be overridden by higher priority definitions.';
COMMENT ON COLUMN network.line.label IS 'The label of the line definition. The label is unique for a certain priority and validity period.';
COMMENT ON COLUMN network.line.type_of_line IS 'The type of the line.';
COMMENT ON COLUMN network.line.description IS 'The line text description of the line.';
ALTER TABLE ONLY network.line
    ADD CONSTRAINT line_pkey PRIMARY KEY (line_id);
ALTER TABLE ONLY network.line
    ADD CONSTRAINT line_primary_vehicle_mode_fkey FOREIGN KEY (primary_vehicle_mode) REFERENCES reusable_components.vehicle_mode(vehicle_mode);
ALTER TABLE ONLY network.line
    ADD CONSTRAINT line_type_of_line_fkey FOREIGN KEY (type_of_line) REFERENCES network.type_of_line(type_of_line);
CREATE INDEX idx_line_name_i18n ON network.line USING gin (name_i18n);
CREATE INDEX idx_line_primary_vehicle_mode ON network.line USING btree (primary_vehicle_mode);
CREATE INDEX idx_line_short_name_i18n ON network.line USING gin (short_name_i18n);
CREATE INDEX idx_line_type_of_line ON network.line USING btree (type_of_line);

CREATE TABLE network.route (
    route_id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    description_i18n jsonb,
    on_line_id uuid NOT NULL,
    validity_start date,
    validity_end date,
    priority integer NOT NULL,
    label text NOT NULL,
    direction text NOT NULL,
    name_i18n jsonb NOT NULL,
    origin_name_i18n jsonb,
    origin_short_name_i18n jsonb,
    destination_name_i18n jsonb,
    destination_short_name_i18n jsonb,
    unique_label text GENERATED ALWAYS AS (label) STORED
);
COMMENT ON TABLE network.route IS 'The routes from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:1:3:483';
COMMENT ON COLUMN network.route.route_id IS 'The ID of the route.';
COMMENT ON COLUMN network.route.description_i18n IS 'The description of the route in the form of starting location - destination. Placeholder for multilingual strings.';
COMMENT ON COLUMN network.route.on_line_id IS 'The line to which this route belongs.';
COMMENT ON COLUMN network.route.validity_start IS 'The point in time (inclusive) when the route becomes valid. If NULL, the route has been always valid before end time of validity period.';
COMMENT ON COLUMN network.route.validity_end IS 'The point in time (inclusive) from which onwards the route is no longer valid. If NULL, the route is valid indefinitely after the start time of the validity period.';
COMMENT ON COLUMN network.route.priority IS 'The priority of the route definition. The definition may be overridden by higher priority definitions.';
COMMENT ON COLUMN network.route.label IS 'The label of the route definition.';
COMMENT ON COLUMN network.route.direction IS 'The direction of the route definition.';
COMMENT ON COLUMN network.route.unique_label IS 'Derived from label. Routes are unique for each unique label for a certain direction, priority and validity period';
ALTER TABLE ONLY network.route
    ADD CONSTRAINT route_pkey PRIMARY KEY (route_id);
ALTER TABLE ONLY network.route
    ADD CONSTRAINT route_direction_fkey FOREIGN KEY (direction) REFERENCES network.route_direction(direction);
ALTER TABLE ONLY network.route
    ADD CONSTRAINT route_on_line_id_fkey FOREIGN KEY (on_line_id) REFERENCES network.line(line_id);
CREATE INDEX idx_route_destination_name_i18n ON network.route USING gin (destination_name_i18n);
CREATE INDEX idx_route_destination_short_name_i18n ON network.route USING gin (destination_short_name_i18n);
CREATE INDEX idx_route_direction ON network.route USING btree (direction);
CREATE INDEX idx_route_name_i18n ON network.route USING gin (name_i18n);
CREATE INDEX idx_route_on_line_id ON network.route USING btree (on_line_id);
CREATE INDEX idx_route_origin_name_i18n ON network.route USING gin (origin_name_i18n);
CREATE INDEX idx_route_origin_short_name_i18n ON network.route USING gin (origin_short_name_i18n);

CREATE TABLE network.infrastructure_link_along_route (
    route_id uuid NOT NULL,
    infrastructure_link_id uuid NOT NULL,
    infrastructure_link_sequence integer NOT NULL,
    is_traversal_forwards boolean NOT NULL
);
COMMENT ON TABLE network.infrastructure_link_along_route IS 'The infrastructure links along which the routes are defined.';
COMMENT ON COLUMN network.infrastructure_link_along_route.route_id IS 'The ID of the route.';
COMMENT ON COLUMN network.infrastructure_link_along_route.infrastructure_link_id IS 'The ID of the infrastructure link.';
COMMENT ON COLUMN network.infrastructure_link_along_route.infrastructure_link_sequence IS 'The order of the infrastructure link within the journey pattern.';
COMMENT ON COLUMN network.infrastructure_link_along_route.is_traversal_forwards IS 'Is the infrastructure link traversed in the direction of its linestring?';
ALTER TABLE ONLY network.infrastructure_link_along_route
    ADD CONSTRAINT infrastructure_link_along_route_pkey PRIMARY KEY (route_id, infrastructure_link_sequence);
ALTER TABLE ONLY network.infrastructure_link_along_route
    ADD CONSTRAINT infrastructure_link_along_route_infrastructure_link_id_fkey FOREIGN KEY (infrastructure_link_id) REFERENCES infrastructure_network.infrastructure_link(infrastructure_link_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY network.infrastructure_link_along_route
    ADD CONSTRAINT infrastructure_link_along_route_route_id_fkey FOREIGN KEY (route_id) REFERENCES network.route(route_id) ON UPDATE CASCADE ON DELETE CASCADE;
CREATE INDEX infrastructure_link_along_rou_infrastructure_link_sequence__idx ON network.infrastructure_link_along_route USING btree (infrastructure_link_sequence, route_id);
CREATE INDEX infrastructure_link_along_route_infrastructure_link_id_idx ON network.infrastructure_link_along_route USING btree (infrastructure_link_id);

---------- Timing Pattern ----------

CREATE TABLE network.timing_place (
    timing_place_id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    label text NOT NULL,
    description jsonb
);
COMMENT ON TABLE network.timing_place IS 'A set of SCHEDULED STOP POINTs against which the timing information necessary to build schedules may be recorded. In HSL context this is "Hastus paikka". Based on Transmodel entity TIMING POINT: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:2:709 ';
ALTER TABLE ONLY network.timing_place
    ADD CONSTRAINT timing_place_pkey PRIMARY KEY (timing_place_id);
CREATE UNIQUE INDEX timing_place_label_idx ON network.timing_place USING btree (label);

---------- Service Pattern ----------

CREATE TABLE network.scheduled_stop_point_invariant (
    label text NOT NULL
);
ALTER TABLE ONLY network.scheduled_stop_point_invariant
    ADD CONSTRAINT scheduled_stop_point_invariant_pkey PRIMARY KEY (label);

CREATE TABLE network.scheduled_stop_point (
    scheduled_stop_point_id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    measured_location public.geography(PointZ,4326) NOT NULL,
    located_on_infrastructure_link_id uuid NOT NULL,
    direction text NOT NULL,
    label text NOT NULL,
    validity_start date,
    validity_end date,
    priority integer NOT NULL,
    timing_place_id uuid,
    stop_place_ref text
);
COMMENT ON TABLE network.scheduled_stop_point IS 'The scheduled stop points: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:4:845 . Colloquially known as stops from the perspective of timetable planning.';
COMMENT ON COLUMN network.scheduled_stop_point.scheduled_stop_point_id IS 'The ID of the scheduled stop point.';
COMMENT ON COLUMN network.scheduled_stop_point.measured_location IS 'The measured location describes the physical location of the stop. For some stops this describes the location of the pole-mounted flag. A PostGIS PointZ geography in EPSG:4326.';
COMMENT ON COLUMN network.scheduled_stop_point.located_on_infrastructure_link_id IS 'The infrastructure link on which the stop is located.';
COMMENT ON COLUMN network.scheduled_stop_point.direction IS 'The direction(s) of traffic with respect to the digitization, i.e. the direction of the specified line string.';
COMMENT ON COLUMN network.scheduled_stop_point.label IS 'The label is the short code that identifies the stop to the passengers. There can be at most one stop with the same label at a time. The label matches the GTFS stop_code.';
COMMENT ON COLUMN network.scheduled_stop_point.validity_start IS 'start of the operating date span in the scheduled stop point''s local time (inclusive).';
COMMENT ON COLUMN network.scheduled_stop_point.validity_end IS 'end of the operating date span in the scheduled stop point''s local time (inclusive).';
COMMENT ON COLUMN network.scheduled_stop_point.timing_place_id IS 'Optional reference to a TIMING PLACE. If NULL, the SCHEDULED STOP POINT is not used for timing.';
COMMENT ON COLUMN network.scheduled_stop_point.stop_place_ref IS 'The id of the related stop place in stop registry schema.';
ALTER TABLE ONLY network.scheduled_stop_point
    ADD CONSTRAINT scheduled_stop_point_pkey PRIMARY KEY (scheduled_stop_point_id);
ALTER TABLE ONLY network.scheduled_stop_point
    ADD CONSTRAINT scheduled_stop_point_direction_fkey FOREIGN KEY (direction) REFERENCES infrastructure_network.direction(value);
ALTER TABLE ONLY network.scheduled_stop_point
    ADD CONSTRAINT scheduled_stop_point_located_on_infrastructure_link_id_fkey FOREIGN KEY (located_on_infrastructure_link_id) REFERENCES infrastructure_network.infrastructure_link(infrastructure_link_id);
ALTER TABLE ONLY network.scheduled_stop_point
    ADD CONSTRAINT scheduled_stop_point_scheduled_stop_point_invariant_label_fkey FOREIGN KEY (label) REFERENCES network.scheduled_stop_point_invariant(label);
ALTER TABLE ONLY network.scheduled_stop_point
    ADD CONSTRAINT scheduled_stop_point_timing_place_id_fkey FOREIGN KEY (timing_place_id) REFERENCES network.timing_place(timing_place_id);
CREATE INDEX idx_scheduled_stop_point_direction ON network.scheduled_stop_point USING btree (direction);
CREATE INDEX scheduled_stop_point_label_idx ON network.scheduled_stop_point USING btree (label);
CREATE INDEX scheduled_stop_point_located_on_infrastructure_link_id_idx ON network.scheduled_stop_point USING btree (located_on_infrastructure_link_id);
CREATE INDEX scheduled_stop_point_measured_location_idx ON network.scheduled_stop_point USING gist (measured_location);

-- Each scheduled stop point should have its own stop place.
CREATE UNIQUE INDEX scheduled_stop_point_stop_place_ref_idx ON network.scheduled_stop_point
USING btree (stop_place_ref)
WHERE (stop_place_ref IS NOT NULL);

CREATE INDEX idx_scheduled_stop_point_timing_place
  ON network.scheduled_stop_point USING btree (timing_place_id);


CREATE TABLE network.vehicle_mode_on_scheduled_stop_point (
    scheduled_stop_point_id uuid NOT NULL,
    vehicle_mode text NOT NULL
);
COMMENT ON TABLE network.vehicle_mode_on_scheduled_stop_point IS 'Which scheduled stop points are serviced by which vehicle modes?';
COMMENT ON COLUMN network.vehicle_mode_on_scheduled_stop_point.scheduled_stop_point_id IS 'The scheduled stop point that is serviced by the vehicle mode.';
COMMENT ON COLUMN network.vehicle_mode_on_scheduled_stop_point.vehicle_mode IS 'The vehicle mode servicing the scheduled stop point.';
ALTER TABLE ONLY network.vehicle_mode_on_scheduled_stop_point
    ADD CONSTRAINT scheduled_stop_point_serviced_by_vehicle_mode_pkey PRIMARY KEY (scheduled_stop_point_id, vehicle_mode);
ALTER TABLE ONLY network.vehicle_mode_on_scheduled_stop_point
    ADD CONSTRAINT scheduled_stop_point_serviced_by_vehicle_mode_vehicle_mode_fkey FOREIGN KEY (vehicle_mode) REFERENCES reusable_components.vehicle_mode(vehicle_mode);
ALTER TABLE ONLY network.vehicle_mode_on_scheduled_stop_point
    ADD CONSTRAINT vehicle_mode_on_scheduled_stop_point_scheduled_stop_point_id_fk FOREIGN KEY (scheduled_stop_point_id) REFERENCES network.scheduled_stop_point(scheduled_stop_point_id) ON UPDATE CASCADE ON DELETE CASCADE;
CREATE INDEX scheduled_stop_point_serviced_vehicle_mode_scheduled_stop_p_idx ON network.vehicle_mode_on_scheduled_stop_point USING btree (vehicle_mode, scheduled_stop_point_id);

---------- Journey Pattern ----------

CREATE TABLE network.journey_pattern (
    journey_pattern_id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    on_route_id uuid NOT NULL
);
COMMENT ON TABLE network.journey_pattern IS 'The journey patterns, i.e. the ordered lists of stops and timing points along routes: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:1:813';
COMMENT ON COLUMN network.journey_pattern.journey_pattern_id IS 'The ID of the journey pattern.';
COMMENT ON COLUMN network.journey_pattern.on_route_id IS 'The ID of the route the journey pattern is on.';
ALTER TABLE ONLY network.journey_pattern
    ADD CONSTRAINT journey_pattern_pkey PRIMARY KEY (journey_pattern_id);
ALTER TABLE ONLY network.journey_pattern
    ADD CONSTRAINT journey_pattern_on_route_id_fkey FOREIGN KEY (on_route_id) REFERENCES network.route(route_id) ON DELETE CASCADE;
CREATE UNIQUE INDEX journey_pattern_on_route_id_idx ON network.journey_pattern USING btree (on_route_id);

CREATE TABLE network.scheduled_stop_point_in_journey_pattern (
    journey_pattern_id uuid NOT NULL,
    scheduled_stop_point_sequence integer NOT NULL,
    is_used_as_timing_point boolean DEFAULT false NOT NULL,
    is_via_point boolean DEFAULT false NOT NULL,
    via_point_name_i18n jsonb,
    via_point_short_name_i18n jsonb,
    scheduled_stop_point_label text NOT NULL,
    is_loading_time_allowed boolean DEFAULT false NOT NULL,
    is_regulated_timing_point boolean DEFAULT false NOT NULL
);
COMMENT ON TABLE network.scheduled_stop_point_in_journey_pattern IS 'The scheduled stop points that form the journey pattern, in order: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:1:813 . For HSL, all timing points are stops, hence journey pattern instead of service pattern.';
COMMENT ON COLUMN network.scheduled_stop_point_in_journey_pattern.journey_pattern_id IS 'The ID of the journey pattern.';
COMMENT ON COLUMN network.scheduled_stop_point_in_journey_pattern.scheduled_stop_point_sequence IS 'The order of the scheduled stop point within the journey pattern.';
COMMENT ON COLUMN network.scheduled_stop_point_in_journey_pattern.is_used_as_timing_point IS 'Is this scheduled stop point used as a timing point in the journey pattern?';
COMMENT ON COLUMN network.scheduled_stop_point_in_journey_pattern.is_via_point IS 'Is this scheduled stop point a via point?';
COMMENT ON COLUMN network.scheduled_stop_point_in_journey_pattern.is_loading_time_allowed IS 'Is adding loading time to this scheduled stop point in the journey pattern allowed?';
COMMENT ON COLUMN network.scheduled_stop_point_in_journey_pattern.is_regulated_timing_point IS 'Is this stop point passing time regulated so that it cannot be passed before scheduled time?';
ALTER TABLE ONLY network.scheduled_stop_point_in_journey_pattern
    ADD CONSTRAINT scheduled_stop_point_in_journey_pattern_pkey PRIMARY KEY (journey_pattern_id, scheduled_stop_point_sequence);
ALTER TABLE ONLY network.scheduled_stop_point_in_journey_pattern
    ADD CONSTRAINT scheduled_stop_point_in_journe__scheduled_stop_point_label_fkey FOREIGN KEY (scheduled_stop_point_label) REFERENCES network.scheduled_stop_point_invariant(label) ON DELETE CASCADE;
ALTER TABLE ONLY network.scheduled_stop_point_in_journey_pattern
    ADD CONSTRAINT scheduled_stop_point_in_journey_pattern_journey_pattern_id_fkey FOREIGN KEY (journey_pattern_id) REFERENCES network.journey_pattern(journey_pattern_id) ON UPDATE CASCADE ON DELETE CASCADE;
CREATE INDEX idx_scheduled_stop_point_in_journey_pattern_via_point_name_i18n ON network.scheduled_stop_point_in_journey_pattern USING gin (via_point_name_i18n);
CREATE INDEX idx_scheduled_stop_point_in_journey_pattern_via_point_short_nam ON network.scheduled_stop_point_in_journey_pattern USING gin (via_point_short_name_i18n);
CREATE INDEX scheduled_stop_point_in_journ_scheduled_stop_point_sequence_idx ON network.scheduled_stop_point_in_journey_pattern USING btree (scheduled_stop_point_sequence, journey_pattern_id);
CREATE INDEX scheduled_stop_point_in_journey__scheduled_stop_point_label_idx ON network.scheduled_stop_point_in_journey_pattern USING btree (scheduled_stop_point_label);

CREATE TABLE network.distance_between_stops_calculation (
  journey_pattern_id      uuid NOT NULL,
  route_id                uuid NOT NULL,
  route_priority          integer NOT NULL,
  observation_date        date NOT NULL,
  stop_interval_sequence  integer NOT NULL,
  start_stop_label        text NOT NULL,
  end_stop_label          text NOT NULL,
  distance_in_metres      double precision NOT NULL
);

ALTER TABLE ONLY network.distance_between_stops_calculation
  ADD CONSTRAINT distance_between_stops_calculation_pkey PRIMARY KEY (journey_pattern_id, route_priority, observation_date, stop_interval_sequence);

COMMENT ON TABLE network.distance_between_stops_calculation IS
  'A dummy table that models the results of calculating the lengths of stop intervals from the given journey patterns. The table exists due to the limitations of Hasura and there is no intention to insert anything to it.';
COMMENT ON COLUMN network.distance_between_stops_calculation.journey_pattern_id IS
  'The ID of the journey pattern.';
COMMENT ON COLUMN network.distance_between_stops_calculation.route_id IS
  'The ID of the route related to the journey pattern.';
COMMENT ON COLUMN network.distance_between_stops_calculation.route_priority IS
  'The priority of the route related to the journey pattern.';
COMMENT ON COLUMN network.distance_between_stops_calculation.observation_date IS
  'The observation date for the state of the route related to the journey pattern.';
COMMENT ON COLUMN network.distance_between_stops_calculation.stop_interval_sequence IS
  'The sequence number of the stop interval within the journey pattern.';
COMMENT ON COLUMN network.distance_between_stops_calculation.start_stop_label IS
  'The label of the start stop of the stop interval.';
COMMENT ON COLUMN network.distance_between_stops_calculation.end_stop_label IS
  'The label of the end stop of the stop interval.';
COMMENT ON COLUMN network.distance_between_stops_calculation.distance_in_metres IS
  'The length of the stop interval in metres.';

-- note: ALTER DEFAULT PRIVILEGES IN SCHEMA only adds GRANTs to *new* tables created after this migration
-- if using GRANT, it'll only apply to the *existing* tables

GRANT USAGE ON SCHEMA network TO xxx_db_jore3importer_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA network TO xxx_db_jore3importer_username_xxx;
GRANT INSERT ON ALL TABLES IN SCHEMA network TO xxx_db_jore3importer_username_xxx;
GRANT UPDATE ON ALL TABLES IN SCHEMA network TO xxx_db_jore3importer_username_xxx;
GRANT DELETE ON ALL TABLES IN SCHEMA network TO xxx_db_jore3importer_username_xxx;
GRANT TRUNCATE ON ALL TABLES IN SCHEMA network TO xxx_db_jore3importer_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA network GRANT SELECT ON TABLES TO xxx_db_jore3importer_username_xxx;

GRANT USAGE ON SCHEMA reusable_components TO xxx_db_jore3importer_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA reusable_components TO xxx_db_jore3importer_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA reusable_components GRANT SELECT ON TABLES TO xxx_db_jore3importer_username_xxx;
