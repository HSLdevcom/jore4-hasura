---------- Reusable Components ----------

CREATE TABLE reusable_components.vehicle_mode (
    vehicle_mode text NOT NULL
);
COMMENT ON TABLE reusable_components.vehicle_mode IS 'The vehicle modes from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=1:6:1:283';
COMMENT ON COLUMN reusable_components.vehicle_mode.vehicle_mode IS 'The vehicle mode from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=1:6:1:283';
ALTER TABLE ONLY reusable_components.vehicle_mode
    ADD CONSTRAINT vehicle_mode_pkey PRIMARY KEY (vehicle_mode);
INSERT INTO reusable_components.vehicle_mode
  (vehicle_mode)
  VALUES
  ('bus'),
  ('tram'),
  ('train'),
  ('metro'),
  ('ferry')
  ON CONFLICT (vehicle_mode) DO NOTHING;

CREATE TABLE reusable_components.vehicle_submode (
    vehicle_submode text NOT NULL,
    belonging_to_vehicle_mode text NOT NULL
);
COMMENT ON TABLE reusable_components.vehicle_submode IS 'The vehicle submode, which may have implications on which infrastructure links the vehicle can traverse';
COMMENT ON COLUMN reusable_components.vehicle_submode.vehicle_submode IS 'The vehicle submode, which may have implications on which infrastructure links the vehicle can traverse';
COMMENT ON COLUMN reusable_components.vehicle_submode.belonging_to_vehicle_mode IS 'The vehicle mode the vehicle submode belongs to: https://www.transmodel-cen.eu/model/index.htm?goto=1:6:1:283';
CREATE INDEX vehicle_submode_belonging_to_vehicle_mode_idx ON reusable_components.vehicle_submode USING btree (belonging_to_vehicle_mode);
ALTER TABLE ONLY reusable_components.vehicle_submode
    ADD CONSTRAINT vehicle_submode_pkey PRIMARY KEY (vehicle_submode);
ALTER TABLE ONLY reusable_components.vehicle_submode
    ADD CONSTRAINT vehicle_submode_belonging_to_vehicle_mode_fkey FOREIGN KEY (belonging_to_vehicle_mode) REFERENCES reusable_components.vehicle_mode(vehicle_mode);
INSERT INTO reusable_components.vehicle_submode
  (vehicle_submode, belonging_to_vehicle_mode)
  VALUES
  ('generic_bus', 'bus'),
  ('generic_tram', 'tram'),
  ('generic_train', 'train'),
  ('generic_metro', 'metro'),
  ('generic_ferry', 'ferry'),
  ('tall_electric_bus', 'bus')
  ON CONFLICT (vehicle_submode)
    DO UPDATE SET belonging_to_vehicle_mode = EXCLUDED.belonging_to_vehicle_mode;

---------- Infrastructure Network ----------

CREATE TABLE infrastructure_network.external_source (
    value text NOT NULL
);
INSERT INTO infrastructure_network.external_source VALUES ('digiroad_r'), ('fixup');
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

CREATE TABLE route.direction (
    direction text NOT NULL,
    the_opposite_of_direction text
);
COMMENT ON TABLE route.direction IS 'The route directions from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:1:3:480';
COMMENT ON COLUMN route.direction.direction IS 'The name of the route direction.';
COMMENT ON COLUMN route.direction.the_opposite_of_direction IS 'The opposite direction.';
ALTER TABLE ONLY route.direction
    ADD CONSTRAINT direction_pkey PRIMARY KEY (direction);
ALTER TABLE ONLY route.direction
    ADD CONSTRAINT direction_the_opposite_of_direction_fkey FOREIGN KEY (the_opposite_of_direction) REFERENCES route.direction(direction);
CREATE INDEX idx_direction_the_opposite_of_direction ON route.direction USING btree (the_opposite_of_direction);
INSERT INTO route.direction
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

CREATE TABLE route.type_of_line (
    type_of_line text NOT NULL,
    belonging_to_vehicle_mode text NOT NULL
);
COMMENT ON TABLE route.type_of_line IS 'Type of line. https://www.transmodel-cen.eu/model/EARoot/EA2/EA1/EA3/EA491.htm';
COMMENT ON COLUMN route.type_of_line.type_of_line IS 'GTFS route type: https://developers.google.com/transit/gtfs/reference/extended-route-types';
ALTER TABLE ONLY route.type_of_line
    ADD CONSTRAINT type_of_line_pkey PRIMARY KEY (type_of_line);
ALTER TABLE ONLY route.type_of_line
    ADD CONSTRAINT type_of_line_belonging_to_vehicle_mode_fkey FOREIGN KEY (belonging_to_vehicle_mode) REFERENCES reusable_components.vehicle_mode(vehicle_mode);
CREATE INDEX type_of_line_belonging_to_vehicle_mode_idx ON route.type_of_line USING btree (belonging_to_vehicle_mode);
INSERT INTO route.type_of_line
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

CREATE TABLE route.line (
    line_id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name_i18n jsonb NOT NULL,
    short_name_i18n jsonb NOT NULL,
    primary_vehicle_mode text NOT NULL,
    validity_start date,
    validity_end date,
    priority integer NOT NULL,
    label text NOT NULL,
    type_of_line text NOT NULL
);
COMMENT ON TABLE route.line IS 'The line from Transmodel: http://www.transmodel-cen.eu/model/index.htm?goto=2:1:3:487';
COMMENT ON COLUMN route.line.line_id IS 'The ID of the line.';
COMMENT ON COLUMN route.line.name_i18n IS 'The name of the line. Placeholder for multilingual strings.';
COMMENT ON COLUMN route.line.short_name_i18n IS 'The shorted name of the line. Placeholder for multilingual strings.';
COMMENT ON COLUMN route.line.primary_vehicle_mode IS 'The mode of the vehicles used as primary on the line.';
COMMENT ON COLUMN route.line.validity_start IS 'The point in time when the line becomes valid. If NULL, the line has been always valid.';
COMMENT ON COLUMN route.line.validity_end IS 'The point in time from which onwards the line is no longer valid. If NULL, the line will be always valid.';
COMMENT ON COLUMN route.line.priority IS 'The priority of the line definition. The definition may be overridden by higher priority definitions.';
COMMENT ON COLUMN route.line.label IS 'The label of the line definition. The label is unique for a certain priority and validity period.';
COMMENT ON COLUMN route.line.type_of_line IS 'The type of the line.';
ALTER TABLE ONLY route.line
    ADD CONSTRAINT line_pkey PRIMARY KEY (line_id);
ALTER TABLE ONLY route.line
    ADD CONSTRAINT line_primary_vehicle_mode_fkey FOREIGN KEY (primary_vehicle_mode) REFERENCES reusable_components.vehicle_mode(vehicle_mode);
ALTER TABLE ONLY route.line
    ADD CONSTRAINT line_type_of_line_fkey FOREIGN KEY (type_of_line) REFERENCES route.type_of_line(type_of_line);
CREATE INDEX idx_line_name_i18n ON route.line USING gin (name_i18n);
CREATE INDEX idx_line_primary_vehicle_mode ON route.line USING btree (primary_vehicle_mode);
CREATE INDEX idx_line_short_name_i18n ON route.line USING gin (short_name_i18n);
CREATE INDEX idx_line_type_of_line ON route.line USING btree (type_of_line);

CREATE TABLE route.route (
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
    destination_short_name_i18n jsonb
);
COMMENT ON TABLE route.route IS 'The routes from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:1:3:483';
COMMENT ON COLUMN route.route.route_id IS 'The ID of the route.';
COMMENT ON COLUMN route.route.description_i18n IS 'The description of the route in the form of starting location - destination. Placeholder for multilingual strings.';
COMMENT ON COLUMN route.route.on_line_id IS 'The line to which this route belongs.';
COMMENT ON COLUMN route.route.validity_start IS 'The point in time when the route becomes valid. If NULL, the route has been always valid before end time of validity period.';
COMMENT ON COLUMN route.route.validity_end IS 'The point in time from which onwards the route is no longer valid. If NULL, the route is valid indefinitely after the start time of the validity period.';
COMMENT ON COLUMN route.route.priority IS 'The priority of the route definition. The definition may be overridden by higher priority definitions.';
COMMENT ON COLUMN route.route.label IS 'The label of the route definition, label and direction together are unique for a certain priority and validity period.';
COMMENT ON COLUMN route.route.direction IS 'The direction of the route definition, label and direction together are unique for a certain priority and validity period.';
ALTER TABLE ONLY route.route
    ADD CONSTRAINT route_pkey PRIMARY KEY (route_id);
ALTER TABLE ONLY route.route
    ADD CONSTRAINT route_direction_fkey FOREIGN KEY (direction) REFERENCES route.direction(direction);
ALTER TABLE ONLY route.route
    ADD CONSTRAINT route_on_line_id_fkey FOREIGN KEY (on_line_id) REFERENCES route.line(line_id);
CREATE INDEX idx_route_destination_name_i18n ON route.route USING gin (destination_name_i18n);
CREATE INDEX idx_route_destination_short_name_i18n ON route.route USING gin (destination_short_name_i18n);
CREATE INDEX idx_route_direction ON route.route USING btree (direction);
CREATE INDEX idx_route_name_i18n ON route.route USING gin (name_i18n);
CREATE INDEX idx_route_on_line_id ON route.route USING btree (on_line_id);
CREATE INDEX idx_route_origin_name_i18n ON route.route USING gin (origin_name_i18n);
CREATE INDEX idx_route_origin_short_name_i18n ON route.route USING gin (origin_short_name_i18n);

CREATE TABLE route.infrastructure_link_along_route (
    route_id uuid NOT NULL,
    infrastructure_link_id uuid NOT NULL,
    infrastructure_link_sequence integer NOT NULL,
    is_traversal_forwards boolean NOT NULL
);
COMMENT ON TABLE route.infrastructure_link_along_route IS 'The infrastructure links along which the routes are defined.';
COMMENT ON COLUMN route.infrastructure_link_along_route.route_id IS 'The ID of the route.';
COMMENT ON COLUMN route.infrastructure_link_along_route.infrastructure_link_id IS 'The ID of the infrastructure link.';
COMMENT ON COLUMN route.infrastructure_link_along_route.infrastructure_link_sequence IS 'The order of the infrastructure link within the journey pattern.';
COMMENT ON COLUMN route.infrastructure_link_along_route.is_traversal_forwards IS 'Is the infrastructure link traversed in the direction of its linestring?';
ALTER TABLE ONLY route.infrastructure_link_along_route
    ADD CONSTRAINT infrastructure_link_along_route_pkey PRIMARY KEY (route_id, infrastructure_link_sequence);
ALTER TABLE ONLY route.infrastructure_link_along_route
    ADD CONSTRAINT infrastructure_link_along_route_infrastructure_link_id_fkey FOREIGN KEY (infrastructure_link_id) REFERENCES infrastructure_network.infrastructure_link(infrastructure_link_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY route.infrastructure_link_along_route
    ADD CONSTRAINT infrastructure_link_along_route_route_id_fkey FOREIGN KEY (route_id) REFERENCES route.route(route_id) ON UPDATE CASCADE ON DELETE CASCADE;
CREATE INDEX infrastructure_link_along_rou_infrastructure_link_sequence__idx ON route.infrastructure_link_along_route USING btree (infrastructure_link_sequence, route_id);
CREATE INDEX infrastructure_link_along_route_infrastructure_link_id_idx ON route.infrastructure_link_along_route USING btree (infrastructure_link_id);

---------- Timing Pattern ----------

CREATE TABLE timing_pattern.timing_place (
    timing_place_id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    label text NOT NULL,
    description jsonb
);
COMMENT ON TABLE timing_pattern.timing_place IS 'A set of SCHEDULED STOP POINTs against which the timing information necessary to build schedules may be recorded. In HSL context this is "Hastus paikka". Based on Transmodel entity TIMING POINT: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:2:709 ';
ALTER TABLE ONLY timing_pattern.timing_place
    ADD CONSTRAINT timing_place_pkey PRIMARY KEY (timing_place_id);
CREATE UNIQUE INDEX timing_place_label_idx ON timing_pattern.timing_place USING btree (label);

---------- Service Pattern ----------

CREATE TABLE service_pattern.scheduled_stop_point_invariant (
    label text NOT NULL
);
ALTER TABLE ONLY service_pattern.scheduled_stop_point_invariant
    ADD CONSTRAINT scheduled_stop_point_invariant_pkey PRIMARY KEY (label);

CREATE TABLE service_pattern.scheduled_stop_point (
    scheduled_stop_point_id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    measured_location public.geography(PointZ,4326) NOT NULL,
    located_on_infrastructure_link_id uuid NOT NULL,
    direction text NOT NULL,
    label text NOT NULL,
    validity_start date,
    validity_end date,
    priority integer NOT NULL,
    timing_place_id uuid
);
COMMENT ON TABLE service_pattern.scheduled_stop_point IS 'The scheduled stop points: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:4:845 . Colloquially known as stops from the perspective of timetable planning.';
COMMENT ON COLUMN service_pattern.scheduled_stop_point.scheduled_stop_point_id IS 'The ID of the scheduled stop point.';
COMMENT ON COLUMN service_pattern.scheduled_stop_point.measured_location IS 'The measured location describes the physical location of the stop. For some stops this describes the location of the pole-mounted flag. A PostGIS PointZ geography in EPSG:4326.';
COMMENT ON COLUMN service_pattern.scheduled_stop_point.located_on_infrastructure_link_id IS 'The infrastructure link on which the stop is located.';
COMMENT ON COLUMN service_pattern.scheduled_stop_point.direction IS 'The direction(s) of traffic with respect to the digitization, i.e. the direction of the specified line string.';
COMMENT ON COLUMN service_pattern.scheduled_stop_point.label IS 'The label is the short code that identifies the stop to the passengers. There can be at most one stop with the same label at a time. The label matches the GTFS stop_code.';
COMMENT ON COLUMN service_pattern.scheduled_stop_point.validity_start IS 'end of the route''s operating date span in the route''s local time';
COMMENT ON COLUMN service_pattern.scheduled_stop_point.validity_end IS 'end of the operating date span in the scheduled stop point''s local time';
COMMENT ON COLUMN service_pattern.scheduled_stop_point.timing_place_id IS 'Optional reference to a TIMING PLACE. If NULL, the SCHEDULED STOP POINT is not used for timing.';
ALTER TABLE ONLY service_pattern.scheduled_stop_point
    ADD CONSTRAINT scheduled_stop_point_pkey PRIMARY KEY (scheduled_stop_point_id);
ALTER TABLE ONLY service_pattern.scheduled_stop_point
    ADD CONSTRAINT scheduled_stop_point_direction_fkey FOREIGN KEY (direction) REFERENCES infrastructure_network.direction(value);
ALTER TABLE ONLY service_pattern.scheduled_stop_point
    ADD CONSTRAINT scheduled_stop_point_located_on_infrastructure_link_id_fkey FOREIGN KEY (located_on_infrastructure_link_id) REFERENCES infrastructure_network.infrastructure_link(infrastructure_link_id);
ALTER TABLE ONLY service_pattern.scheduled_stop_point
    ADD CONSTRAINT scheduled_stop_point_scheduled_stop_point_invariant_label_fkey FOREIGN KEY (label) REFERENCES service_pattern.scheduled_stop_point_invariant(label);
ALTER TABLE ONLY service_pattern.scheduled_stop_point
    ADD CONSTRAINT scheduled_stop_point_timing_place_id_fkey FOREIGN KEY (timing_place_id) REFERENCES timing_pattern.timing_place(timing_place_id);
CREATE INDEX idx_scheduled_stop_point_direction ON service_pattern.scheduled_stop_point USING btree (direction);
CREATE INDEX scheduled_stop_point_label_idx ON service_pattern.scheduled_stop_point USING btree (label);
CREATE INDEX scheduled_stop_point_located_on_infrastructure_link_id_idx ON service_pattern.scheduled_stop_point USING btree (located_on_infrastructure_link_id);
CREATE INDEX scheduled_stop_point_measured_location_idx ON service_pattern.scheduled_stop_point USING gist (measured_location);

CREATE TABLE service_pattern.vehicle_mode_on_scheduled_stop_point (
    scheduled_stop_point_id uuid NOT NULL,
    vehicle_mode text NOT NULL
);
COMMENT ON TABLE service_pattern.vehicle_mode_on_scheduled_stop_point IS 'Which scheduled stop points are serviced by which vehicle modes?';
COMMENT ON COLUMN service_pattern.vehicle_mode_on_scheduled_stop_point.scheduled_stop_point_id IS 'The scheduled stop point that is serviced by the vehicle mode.';
COMMENT ON COLUMN service_pattern.vehicle_mode_on_scheduled_stop_point.vehicle_mode IS 'The vehicle mode servicing the scheduled stop point.';
ALTER TABLE ONLY service_pattern.vehicle_mode_on_scheduled_stop_point
    ADD CONSTRAINT scheduled_stop_point_serviced_by_vehicle_mode_pkey PRIMARY KEY (scheduled_stop_point_id, vehicle_mode);
ALTER TABLE ONLY service_pattern.vehicle_mode_on_scheduled_stop_point
    ADD CONSTRAINT scheduled_stop_point_serviced_by_vehicle_mode_vehicle_mode_fkey FOREIGN KEY (vehicle_mode) REFERENCES reusable_components.vehicle_mode(vehicle_mode);
ALTER TABLE ONLY service_pattern.vehicle_mode_on_scheduled_stop_point
    ADD CONSTRAINT vehicle_mode_on_scheduled_stop_point_scheduled_stop_point_id_fk FOREIGN KEY (scheduled_stop_point_id) REFERENCES service_pattern.scheduled_stop_point(scheduled_stop_point_id) ON UPDATE CASCADE ON DELETE CASCADE;
CREATE INDEX scheduled_stop_point_serviced_vehicle_mode_scheduled_stop_p_idx ON service_pattern.vehicle_mode_on_scheduled_stop_point USING btree (vehicle_mode, scheduled_stop_point_id);

---------- Journey Pattern ----------

CREATE TABLE journey_pattern.journey_pattern (
    journey_pattern_id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    on_route_id uuid NOT NULL
);
COMMENT ON TABLE journey_pattern.journey_pattern IS 'The journey patterns, i.e. the ordered lists of stops and timing points along routes: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:1:813';
COMMENT ON COLUMN journey_pattern.journey_pattern.journey_pattern_id IS 'The ID of the journey pattern.';
COMMENT ON COLUMN journey_pattern.journey_pattern.on_route_id IS 'The ID of the route the journey pattern is on.';
ALTER TABLE ONLY journey_pattern.journey_pattern
    ADD CONSTRAINT journey_pattern_pkey PRIMARY KEY (journey_pattern_id);
ALTER TABLE ONLY journey_pattern.journey_pattern
    ADD CONSTRAINT journey_pattern_on_route_id_fkey FOREIGN KEY (on_route_id) REFERENCES route.route(route_id) ON DELETE CASCADE;
CREATE UNIQUE INDEX journey_pattern_on_route_id_idx ON journey_pattern.journey_pattern USING btree (on_route_id);

CREATE TABLE journey_pattern.scheduled_stop_point_in_journey_pattern (
    journey_pattern_id uuid NOT NULL,
    scheduled_stop_point_sequence integer NOT NULL,
    is_timing_point boolean DEFAULT false NOT NULL,
    is_via_point boolean DEFAULT false NOT NULL,
    via_point_name_i18n jsonb,
    via_point_short_name_i18n jsonb,
    scheduled_stop_point_label text NOT NULL
);
COMMENT ON TABLE journey_pattern.scheduled_stop_point_in_journey_pattern IS 'The scheduled stop points that form the journey pattern, in order: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:1:813 . For HSL, all timing points are stops, hence journey pattern instead of service pattern.';
COMMENT ON COLUMN journey_pattern.scheduled_stop_point_in_journey_pattern.journey_pattern_id IS 'The ID of the journey pattern.';
COMMENT ON COLUMN journey_pattern.scheduled_stop_point_in_journey_pattern.scheduled_stop_point_sequence IS 'The order of the scheduled stop point within the journey pattern.';
COMMENT ON COLUMN journey_pattern.scheduled_stop_point_in_journey_pattern.is_timing_point IS 'Is this scheduled stop point a timing point?';
COMMENT ON COLUMN journey_pattern.scheduled_stop_point_in_journey_pattern.is_via_point IS 'Is this scheduled stop point a via point?';
ALTER TABLE ONLY journey_pattern.scheduled_stop_point_in_journey_pattern
    ADD CONSTRAINT scheduled_stop_point_in_journey_pattern_pkey PRIMARY KEY (journey_pattern_id, scheduled_stop_point_sequence);
ALTER TABLE ONLY journey_pattern.scheduled_stop_point_in_journey_pattern
    ADD CONSTRAINT scheduled_stop_point_in_journe__scheduled_stop_point_label_fkey FOREIGN KEY (scheduled_stop_point_label) REFERENCES service_pattern.scheduled_stop_point_invariant(label) ON DELETE CASCADE;
ALTER TABLE ONLY journey_pattern.scheduled_stop_point_in_journey_pattern
    ADD CONSTRAINT scheduled_stop_point_in_journey_pattern_journey_pattern_id_fkey FOREIGN KEY (journey_pattern_id) REFERENCES journey_pattern.journey_pattern(journey_pattern_id) ON UPDATE CASCADE ON DELETE CASCADE;
CREATE INDEX idx_scheduled_stop_point_in_journey_pattern_via_point_name_i18n ON journey_pattern.scheduled_stop_point_in_journey_pattern USING gin (via_point_name_i18n);
CREATE INDEX idx_scheduled_stop_point_in_journey_pattern_via_point_short_nam ON journey_pattern.scheduled_stop_point_in_journey_pattern USING gin (via_point_short_name_i18n);
CREATE INDEX scheduled_stop_point_in_journ_scheduled_stop_point_sequence_idx ON journey_pattern.scheduled_stop_point_in_journey_pattern USING btree (scheduled_stop_point_sequence, journey_pattern_id);
CREATE INDEX scheduled_stop_point_in_journey__scheduled_stop_point_label_idx ON journey_pattern.scheduled_stop_point_in_journey_pattern USING btree (scheduled_stop_point_label);
