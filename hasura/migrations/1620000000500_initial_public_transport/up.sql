--
-- Public transport schemas
--

--
-- Reusable components
--

CREATE SCHEMA reusable_components;
COMMENT ON SCHEMA
  reusable_components IS
  'The reusable components model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=1:6:260';

CREATE TABLE reusable_components.vehicle_mode (
  vehicle_mode text PRIMARY KEY
);
COMMENT ON TABLE
  reusable_components.vehicle_mode IS
  'The vehicle modes from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=1:6:1:283';
COMMENT ON COLUMN
  reusable_components.vehicle_mode.vehicle_mode IS
  'The vehicle mode from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=1:6:1:283';
INSERT INTO reusable_components.vehicle_mode
  (vehicle_mode)
  VALUES
  ('bus'),
  ('tram'),
  ('train'),
  ('metro'),
  ('ferry')
  ON CONFLICT (vehicle_mode) DO NOTHING;

CREATE TABLE reusable_components.vehicle_sub_mode (
  vehicle_sub_mode text PRIMARY KEY,
  belonging_to_vehicle_mode text NOT NULL REFERENCES reusable_components.vehicle_mode (vehicle_mode)
);
COMMENT ON TABLE
  reusable_components.vehicle_sub_mode IS
  'The vehicle sub mode, which may have implications on which infrastructure links the vehicle can traverse';
COMMENT ON COLUMN
  reusable_components.vehicle_sub_mode.vehicle_sub_mode IS
  'The vehicle sub mode, which may have implications on which infrastructure links the vehicle can traverse';
COMMENT ON COLUMN
  reusable_components.vehicle_sub_mode.belonging_to_vehicle_mode IS
  'The vehicle mode the vehicle sub mode belongs to: https://www.transmodel-cen.eu/model/index.htm?goto=1:6:1:283';
INSERT INTO reusable_components.vehicle_sub_mode
  (vehicle_sub_mode, belonging_to_vehicle_mode)
  VALUES
  ('generic_bus', 'bus'),
  ('generic_tram', 'tram'),
  ('generic_train', 'train'),
  ('generic_metro', 'metro'),
  ('generic_ferry', 'ferry'),
  ('tall_electric_bus', 'bus')
  ON CONFLICT (vehicle_sub_mode)
    DO UPDATE SET belonging_to_vehicle_mode = EXCLUDED.belonging_to_vehicle_mode;
CREATE INDEX ON
  reusable_components.vehicle_sub_mode
  (belonging_to_vehicle_mode);



--
-- Infrastructure network
--

CREATE SCHEMA infrastructure_network;
COMMENT ON SCHEMA
  infrastructure_network IS
  'The infrastructure network model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:1:1:1:445';

CREATE TABLE infrastructure_network.infrastructure_link (
  infrastructure_link_id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  is_direction_forwards boolean DEFAULT NULL,
  shape geography(LinestringZ, 4326) NOT NULL,
  estimated_length_in_metres double precision
);
COMMENT ON TABLE
  infrastructure_network.infrastructure_link IS
  'The infrastructure links, e.g. road or rail elements: https://www.transmodel-cen.eu/model/index.htm?goto=2:1:1:1:453';
COMMENT ON COLUMN
  infrastructure_network.infrastructure_link.infrastructure_link_id IS
  'The ID of the infrastructure link.';
COMMENT ON COLUMN
  infrastructure_network.infrastructure_link.is_direction_forwards IS
  'Is the direction of traffic the same as the direction of the linestring? If NULL, both directions are allowed for traffic. If TRUE, the only allowed direction of traffic is from the beginning of the infrastructure link to the end. If FALSE, the only allowed direction of traffic is from the end of the infrastructure link to the beginning.';
COMMENT ON COLUMN
  infrastructure_network.infrastructure_link.shape IS
  'A PostGIS LinestringZ geography in EPSG:4326 describing the infrastructure link.';
COMMENT ON COLUMN
  infrastructure_network.infrastructure_link.estimated_length_in_metres IS
  'The estimated length of the infrastructure link in metres.';

CREATE TABLE infrastructure_network.infrastructure_link_safely_traversed_by_vehicle_sub_mode (
  infrastructure_link_id uuid REFERENCES infrastructure_network.infrastructure_link (infrastructure_link_id),
  vehicle_sub_mode text REFERENCES reusable_components.vehicle_sub_mode (vehicle_sub_mode),
  PRIMARY KEY (infrastructure_link_id, vehicle_sub_mode)
);
COMMENT ON TABLE
  infrastructure_network.infrastructure_link_safely_traversed_by_vehicle_sub_mode IS
  'Which infrastructure links are safely traversed by which vehicle sub modes?';
COMMENT ON COLUMN
  infrastructure_network.infrastructure_link_safely_traversed_by_vehicle_sub_mode.infrastructure_link_id IS
  'The infrastructure link that can be safely traversed by the vehicle sub mode.';
COMMENT ON COLUMN
  infrastructure_network.infrastructure_link_safely_traversed_by_vehicle_sub_mode.vehicle_sub_mode IS
  'The vehicle sub mode that can safely traverse the infrastructure link.';
-- The primary key constraint handles the other multicolumn index.
CREATE INDEX ON
  infrastructure_network.infrastructure_link_safely_traversed_by_vehicle_sub_mode
  (vehicle_sub_mode, infrastructure_link_id);



--
-- Service pattern
--

CREATE SCHEMA internal_service_pattern;

CREATE TABLE internal_service_pattern.scheduled_stop_point (
  scheduled_stop_point_id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  measured_location geography(PointZ, 4326) NOT NULL,
  located_on_infrastructure_link_id uuid NOT NULL REFERENCES infrastructure_network.infrastructure_link (infrastructure_link_id),
  is_direction_forwards_on_infrastructure_link boolean NOT NULL,
  label text NOT NULL
);
CREATE INDEX ON
  internal_service_pattern.scheduled_stop_point
  (located_on_infrastructure_link_id);
CREATE INDEX ON
  internal_service_pattern.scheduled_stop_point
  USING GIST (measured_location);
-- FIXME: constraint: allow only one copy of label to be valid at the same time. add after adding valid time intervals
-- FIXME: trigger constraint: direction of stop must match allowed directions of infrastructure link



CREATE SCHEMA service_pattern;
COMMENT ON SCHEMA
  service_pattern IS
  'The service pattern model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:4:840';

-- FIXME: functions for updating and deleting
CREATE FUNCTION service_pattern.insert_scheduled_stop_point (
  measured_location geography(PointZ, 4326),
  located_on_infrastructure_link_id uuid,
  is_direction_forwards_on_infrastructure_link boolean,
  label text
)
RETURNS uuid
LANGUAGE sql
VOLATILE
STRICT
AS $service_pattern_insert_scheduled_stop_point$
  INSERT INTO internal_service_pattern.scheduled_stop_point (
    measured_location,
    located_on_infrastructure_link_id,
    is_direction_forwards_on_infrastructure_link,
    label
  ) VALUES (
    measured_location,
    located_on_infrastructure_link_id,
    is_direction_forwards_on_infrastructure_link,
    label
  ) RETURNING scheduled_stop_point_id
$service_pattern_insert_scheduled_stop_point$;

CREATE VIEW service_pattern.scheduled_stop_point AS
  WITH everything_but_closest_point AS (
    SELECT
      ssp.scheduled_stop_point_id,
      ssp.label,
      ssp.measured_location,
      ssp.located_on_infrastructure_link_id,
      ssp.is_direction_forwards_on_infrastructure_link,
      il.shape,
      internal_utils.ST_LineLocatePoint(il.shape, ssp.measured_location) AS relative_distance_from_infrastructure_link_start
    FROM
      internal_service_pattern.scheduled_stop_point AS ssp
      INNER JOIN infrastructure_network.infrastructure_link AS il ON (ssp.located_on_infrastructure_link_id = il.infrastructure_link_id)
  )
  SELECT
    scheduled_stop_point_id,
    label,
    measured_location,
    located_on_infrastructure_link_id,
    is_direction_forwards_on_infrastructure_link,
    relative_distance_from_infrastructure_link_start,
    internal_utils.ST_LineInterpolatePoint(shape, relative_distance_from_infrastructure_link_start) AS closest_point_on_infrastructure_link
  FROM
    everything_but_closest_point;
COMMENT ON VIEW
  service_pattern.scheduled_stop_point IS
  'The scheduled stop points: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:4:845 . Colloquially known as stops from the perspective of timetable planning.';
COMMENT ON COLUMN
  service_pattern.scheduled_stop_point.scheduled_stop_point_id IS
  'The ID of the scheduled stop point.';
COMMENT ON COLUMN
  service_pattern.scheduled_stop_point.label IS
  'The label is the short code that identifies the stop to the passengers. There can be at most one stop with the same label at a time. The label matches the GTFS stop_code.';
COMMENT ON COLUMN
  service_pattern.scheduled_stop_point.measured_location IS
  'The measured location describes the physical location of the stop. For some stops this describes the location of the pole-mounted flag. A PostGIS PointZ geography in EPSG:4326.';
COMMENT ON COLUMN
  service_pattern.scheduled_stop_point.located_on_infrastructure_link_id IS
  'The infrastructure link on which the stop is located.';
COMMENT ON COLUMN
  service_pattern.scheduled_stop_point.is_direction_forwards_on_infrastructure_link IS
  'Is the direction of traffic on this stop the same as the direction of the linestring describing the infrastructure link? If TRUE, the stop lies in the direction of the linestring. If FALSE, the stop lies in the direction opposite to the linestring.';

COMMENT ON COLUMN
  service_pattern.scheduled_stop_point.relative_distance_from_infrastructure_link_start IS
  'The relative distance of the stop from the start of the linestring along the infrastructure link. Regardless of the value of is_direction_forwards_on_infrastructure_link, this value is the distance from the beginning of the linestring. The distance is normalized to the closed interval [0, 1].';
COMMENT ON COLUMN
  service_pattern.scheduled_stop_point.closest_point_on_infrastructure_link IS
  'The point on the infrastructure link closest to measured_location. A PostGIS PointZ geography in EPSG:4326.';

CREATE TABLE service_pattern.scheduled_stop_point_serviced_by_vehicle_mode (
  scheduled_stop_point_id uuid REFERENCES internal_service_pattern.scheduled_stop_point (scheduled_stop_point_id),
  vehicle_mode text REFERENCES reusable_components.vehicle_mode (vehicle_mode),
  PRIMARY KEY (scheduled_stop_point_id, vehicle_mode)
);
COMMENT ON TABLE
  service_pattern.scheduled_stop_point_serviced_by_vehicle_mode IS
  'Which scheduled stop points are serviced by which vehicle modes?';
COMMENT ON COLUMN
  service_pattern.scheduled_stop_point_serviced_by_vehicle_mode.scheduled_stop_point_id IS
  'The scheduled stop point that is serviced by the vehicle mode.';
COMMENT ON COLUMN
  service_pattern.scheduled_stop_point_serviced_by_vehicle_mode.vehicle_mode IS
  'The vehicle mode servicing the scheduled stop point.';
-- The primary key constraint handles the other multicolumn index.
CREATE INDEX ON
  service_pattern.scheduled_stop_point_serviced_by_vehicle_mode
  (vehicle_mode, scheduled_stop_point_id);
-- FIXME: constraint: The vehicle modes must match the vehicle sub mode safe to traverse the infrastructure link on which the scheduled stop point is located. i.e. vehicle mode must be available on infrastructure_link -> vehicle_sub_mode -> vehicle_mode



--
-- Route
--

CREATE SCHEMA internal_route;

CREATE TABLE internal_route.route (
  route_id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  -- FIXME: starting location and destination might become separate tables referred to from each scheduled stop point, e.g. "Erottaja". If that happens and description has form "starting loction - destination", normalize description out of this table.
  description_i18n text,
  starts_from_scheduled_stop_point_id uuid NOT NULL REFERENCES internal_service_pattern.scheduled_stop_point (scheduled_stop_point_id),
  ends_at_scheduled_stop_point_id uuid NOT NULL REFERENCES internal_service_pattern.scheduled_stop_point (scheduled_stop_point_id)
);
CREATE INDEX ON
  internal_route.route
  (starts_from_scheduled_stop_point_id);
CREATE INDEX ON
  internal_route.route
  (ends_at_scheduled_stop_point_id);



CREATE SCHEMA route;
COMMENT ON SCHEMA
  route IS
  'The route model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:1:3:475';

CREATE TABLE route.infrastructure_link_along_route (
  route_id uuid REFERENCES internal_route.route (route_id),
  infrastructure_link_id uuid NOT NULL REFERENCES infrastructure_network.infrastructure_link (infrastructure_link_id),
  infrastructure_link_sequence int,
  is_traversal_forwards boolean NOT NULL,
  PRIMARY KEY (route_id, infrastructure_link_sequence)
);
COMMENT ON TABLE
  route.infrastructure_link_along_route IS
  'The infrastructure links along which the routes are defined.';
COMMENT ON COLUMN
  route.infrastructure_link_along_route.route_id IS
  'The ID of the route.';
COMMENT ON COLUMN
  route.infrastructure_link_along_route.infrastructure_link_id IS
  'The ID of the infrastructure link.';
COMMENT ON COLUMN
  route.infrastructure_link_along_route.infrastructure_link_sequence IS
  'The order of the infrastruture link within the journey pattern.';
COMMENT ON COLUMN
  route.infrastructure_link_along_route.is_traversal_forwards IS
  'Is the infrastructure link traversed in the direction of its linestring?';
-- The primary key constraint handles the other multicolumn index.
CREATE INDEX ON
  route.infrastructure_link_along_route
  (infrastructure_link_sequence, route_id);
CREATE INDEX ON
  route.infrastructure_link_along_route
  (infrastructure_link_id);
-- FIXME: view constraint: try the no-gap window approach to sequence numbers: https://dba.stackexchange.com/a/135446 . then expose only the view and rename route.infrastructure_link_along_route to internal_route.infrastructure_link_along_route. Same applies to other sequence numbers.
-- FIXME: trigger constraint: is_traversal_forwards must match available directions in infrastructure_link

CREATE TABLE route.direction (
  direction text PRIMARY KEY,
  the_opposite_of_direction text REFERENCES route.direction (direction)
);
COMMENT ON TABLE
  route.direction IS
  'The route directions from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:1:3:480';
COMMENT ON COLUMN
  route.direction.direction IS
  'The name of the route direction.';
COMMENT ON COLUMN
  route.direction.the_opposite_of_direction IS
  'The opposite direction.';
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

CREATE VIEW route.route AS
  SELECT
    r.route_id,
    r.description_i18n,
    r.starts_from_scheduled_stop_point_id,
    r.ends_at_scheduled_stop_point_id,
    -- FIXME: clamp with start and end stops: join on scheduled stop point view, ST_LineSubstring, consider direction
    ST_LineMerge(
      ST_Collect(
        CASE
          WHEN ilar.is_traversal_forwards THEN il.shape::geometry
          ELSE ST_Reverse(il.shape::geometry)
        END
      )
    )::geography AS route_shape
  FROM
    internal_route.route AS r
    INNER JOIN route.infrastructure_link_along_route AS ilar
      ON (r.route_id = ilar.route_id)
    INNER JOIN infrastructure_network.infrastructure_link AS il
      ON (ilar.infrastructure_link_id = il.infrastructure_link_id)
  GROUP BY r.route_id;
COMMENT ON VIEW
  route.route IS
  'The routes from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:1:3:483';
COMMENT ON COLUMN
  route.route.route_id IS
  'The ID of the route.';
COMMENT ON COLUMN
  route.route.description_i18n IS
  'The description of the route in the form of starting location - destination. Placeholder for multilingual strings.';
COMMENT ON COLUMN
  route.route.starts_from_scheduled_stop_point_id IS
  'The scheduled stop point where the route starts from.';
COMMENT ON COLUMN
  route.route.ends_at_scheduled_stop_point_id IS
  'The scheduled stop point where the route ends at.';
COMMENT ON COLUMN
  route.route.route_shape IS
  'A PostGIS LinestringZ geography in EPSG:4326 describing the shape of the route.';



--
-- Journey pattern
--

CREATE SCHEMA journey_pattern;
COMMENT ON SCHEMA
  journey_pattern IS
  'The journey pattern model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:1:799';

CREATE TABLE journey_pattern.journey_pattern (
  journey_pattern_id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  on_route_id uuid NOT NULL REFERENCES internal_route.route (route_id)
);
COMMENT ON TABLE
  journey_pattern.journey_pattern IS
  'The journey patterns, i.e. the ordered lists of stops and timing points along routes: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:1:813';
COMMENT ON COLUMN
  journey_pattern.journey_pattern.journey_pattern_id IS
  'The ID of the journey pattern.';
COMMENT ON COLUMN
  journey_pattern.journey_pattern.on_route_id IS
  'The ID of the route the journey pattern is on.';
CREATE INDEX ON
  journey_pattern.journey_pattern
  (on_route_id);

CREATE TABLE journey_pattern.scheduled_stop_point_in_journey_pattern (
  journey_pattern_id uuid REFERENCES journey_pattern.journey_pattern (journey_pattern_id),
  scheduled_stop_point_id uuid NOT NULL REFERENCES internal_service_pattern.scheduled_stop_point (scheduled_stop_point_id),
  scheduled_stop_point_sequence int,
  is_timing_point boolean DEFAULT false NOT NULL,
  is_via_point boolean DEFAULT false NOT NULL,
  PRIMARY KEY (journey_pattern_id, scheduled_stop_point_sequence)
);
COMMENT ON TABLE
  journey_pattern.scheduled_stop_point_in_journey_pattern IS
  'The scheduled stop points that form the journey pattern, in order: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:1:813 . For HSL, all timing points are stops, hence journey pattern instead of service pattern.';
COMMENT ON COLUMN
  journey_pattern.scheduled_stop_point_in_journey_pattern.journey_pattern_id IS
  'The ID of the journey pattern.';
COMMENT ON COLUMN
  journey_pattern.scheduled_stop_point_in_journey_pattern.scheduled_stop_point_id IS
  'The ID of the scheduled stop point.';
COMMENT ON COLUMN
  journey_pattern.scheduled_stop_point_in_journey_pattern.scheduled_stop_point_sequence IS
  'The order of the scheduled stop point within the journey pattern.';
COMMENT ON COLUMN
  journey_pattern.scheduled_stop_point_in_journey_pattern.is_timing_point IS
  'Is this scheduled stop point a timing point?';
COMMENT ON COLUMN
  journey_pattern.scheduled_stop_point_in_journey_pattern.is_via_point IS
  'Is this scheduled stop point a via point?';
-- The primary key constraint handles the other multicolumn index.
CREATE INDEX ON
  journey_pattern.scheduled_stop_point_in_journey_pattern
  (scheduled_stop_point_sequence, journey_pattern_id);
CREATE INDEX ON
  journey_pattern.scheduled_stop_point_in_journey_pattern
  (scheduled_stop_point_id);
-- FIXME: constraint: allow only stops that are positioned along the route of the journey pattern
