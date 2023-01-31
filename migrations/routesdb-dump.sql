--
-- Sorted PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: SCHEMA infrastructure_network; Type: ACL; Schema: -; Owner: dbhasura
--

GRANT USAGE ON SCHEMA infrastructure_network TO dbimporter;

--
-- Name: SCHEMA internal_service_pattern; Type: ACL; Schema: -; Owner: dbhasura
--

GRANT USAGE ON SCHEMA internal_service_pattern TO dbimporter;

--
-- Name: SCHEMA internal_utils; Type: ACL; Schema: -; Owner: dbhasura
--

GRANT USAGE ON SCHEMA internal_utils TO dbimporter;

--
-- Name: SCHEMA journey_pattern; Type: ACL; Schema: -; Owner: dbhasura
--

GRANT USAGE ON SCHEMA journey_pattern TO dbimporter;

--
-- Name: SCHEMA reusable_components; Type: ACL; Schema: -; Owner: dbhasura
--

GRANT USAGE ON SCHEMA reusable_components TO dbimporter;

--
-- Name: SCHEMA route; Type: ACL; Schema: -; Owner: dbhasura
--

GRANT USAGE ON SCHEMA route TO dbimporter;

--
-- Name: SCHEMA service_pattern; Type: ACL; Schema: -; Owner: dbhasura
--

GRANT USAGE ON SCHEMA service_pattern TO dbimporter;

--
-- Name: TABLE direction; Type: ACL; Schema: infrastructure_network; Owner: dbhasura
--

GRANT SELECT ON TABLE infrastructure_network.direction TO dbimporter;

--
-- Name: TABLE external_source; Type: ACL; Schema: infrastructure_network; Owner: dbhasura
--

GRANT SELECT ON TABLE infrastructure_network.external_source TO dbimporter;

--
-- Name: TABLE infrastructure_link; Type: ACL; Schema: infrastructure_network; Owner: dbhasura
--

GRANT SELECT ON TABLE infrastructure_network.infrastructure_link TO dbimporter;

--
-- Name: TABLE vehicle_submode_on_infrastructure_link; Type: ACL; Schema: infrastructure_network; Owner: dbhasura
--

GRANT SELECT ON TABLE infrastructure_network.vehicle_submode_on_infrastructure_link TO dbimporter;

--
-- Name: TABLE journey_pattern; Type: ACL; Schema: journey_pattern; Owner: dbhasura
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE journey_pattern.journey_pattern TO dbimporter;

--
-- Name: TABLE scheduled_stop_point_in_journey_pattern; Type: ACL; Schema: journey_pattern; Owner: dbhasura
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE journey_pattern.scheduled_stop_point_in_journey_pattern TO dbimporter;

--
-- Name: TABLE vehicle_mode; Type: ACL; Schema: reusable_components; Owner: dbhasura
--

GRANT SELECT ON TABLE reusable_components.vehicle_mode TO dbimporter;

--
-- Name: TABLE vehicle_submode; Type: ACL; Schema: reusable_components; Owner: dbhasura
--

GRANT SELECT ON TABLE reusable_components.vehicle_submode TO dbimporter;

--
-- Name: TABLE direction; Type: ACL; Schema: route; Owner: dbhasura
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE route.direction TO dbimporter;

--
-- Name: TABLE infrastructure_link_along_route; Type: ACL; Schema: route; Owner: dbhasura
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE route.infrastructure_link_along_route TO dbimporter;

--
-- Name: TABLE line; Type: ACL; Schema: route; Owner: dbhasura
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE route.line TO dbimporter;

--
-- Name: TABLE route; Type: ACL; Schema: route; Owner: dbhasura
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE route.route TO dbimporter;

--
-- Name: TABLE type_of_line; Type: ACL; Schema: route; Owner: dbhasura
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE route.type_of_line TO dbimporter;

--
-- Name: TABLE distance_between_stops_calculation; Type: ACL; Schema: service_pattern; Owner: dbhasura
--

GRANT SELECT ON TABLE service_pattern.distance_between_stops_calculation TO dbimporter;

--
-- Name: TABLE scheduled_stop_point; Type: ACL; Schema: service_pattern; Owner: dbhasura
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE service_pattern.scheduled_stop_point TO dbimporter;

--
-- Name: TABLE scheduled_stop_point_invariant; Type: ACL; Schema: service_pattern; Owner: dbhasura
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE service_pattern.scheduled_stop_point_invariant TO dbimporter;

--
-- Name: TABLE vehicle_mode_on_scheduled_stop_point; Type: ACL; Schema: service_pattern; Owner: dbhasura
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE service_pattern.vehicle_mode_on_scheduled_stop_point TO dbimporter;

--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';

--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';

--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';

--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';

--
-- Name: EXTENSION postgis_tiger_geocoder; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_tiger_geocoder IS 'PostGIS tiger geocoder and reverse geocoder';

--
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';

--
-- Name: SCHEMA infrastructure_network; Type: COMMENT; Schema: -; Owner: dbhasura
--

COMMENT ON SCHEMA infrastructure_network IS 'The infrastructure network model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:1:1:1:445';

--
-- Name: SCHEMA internal_utils; Type: COMMENT; Schema: -; Owner: dbhasura
--

COMMENT ON SCHEMA internal_utils IS 'General utilities';

--
-- Name: SCHEMA journey_pattern; Type: COMMENT; Schema: -; Owner: dbhasura
--

COMMENT ON SCHEMA journey_pattern IS 'The journey pattern model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:1:799';

--
-- Name: SCHEMA reusable_components; Type: COMMENT; Schema: -; Owner: dbhasura
--

COMMENT ON SCHEMA reusable_components IS 'The reusable components model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=1:6:260';

--
-- Name: SCHEMA route; Type: COMMENT; Schema: -; Owner: dbhasura
--

COMMENT ON SCHEMA route IS 'The route model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:1:3:475';

--
-- Name: SCHEMA service_pattern; Type: COMMENT; Schema: -; Owner: dbhasura
--

COMMENT ON SCHEMA service_pattern IS 'The service pattern model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:4:840';

--
-- Name: SCHEMA timing_pattern; Type: COMMENT; Schema: -; Owner: dbhasura
--

COMMENT ON SCHEMA timing_pattern IS 'The timing pattern model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:2:703 ';

--
-- Name: SCHEMA topology; Type: COMMENT; Schema: -; Owner: dbadmin
--

COMMENT ON SCHEMA topology IS 'PostGIS Topology schema';

--
-- Name: COLUMN infrastructure_link.direction; Type: COMMENT; Schema: infrastructure_network; Owner: dbhasura
--

COMMENT ON COLUMN infrastructure_network.infrastructure_link.direction IS 'The direction(s) of traffic with respect to the digitization, i.e. the direction of the specified line string.';

--
-- Name: COLUMN infrastructure_link.estimated_length_in_metres; Type: COMMENT; Schema: infrastructure_network; Owner: dbhasura
--

COMMENT ON COLUMN infrastructure_network.infrastructure_link.estimated_length_in_metres IS 'The estimated length of the infrastructure link in metres.';

--
-- Name: COLUMN infrastructure_link.infrastructure_link_id; Type: COMMENT; Schema: infrastructure_network; Owner: dbhasura
--

COMMENT ON COLUMN infrastructure_network.infrastructure_link.infrastructure_link_id IS 'The ID of the infrastructure link.';

--
-- Name: COLUMN infrastructure_link.shape; Type: COMMENT; Schema: infrastructure_network; Owner: dbhasura
--

COMMENT ON COLUMN infrastructure_network.infrastructure_link.shape IS 'A PostGIS LinestringZ geography in EPSG:4326 describing the infrastructure link.';

--
-- Name: COLUMN vehicle_submode_on_infrastructure_link.infrastructure_link_id; Type: COMMENT; Schema: infrastructure_network; Owner: dbhasura
--

COMMENT ON COLUMN infrastructure_network.vehicle_submode_on_infrastructure_link.infrastructure_link_id IS 'The infrastructure link that can be safely traversed by the vehicle submode.';

--
-- Name: COLUMN vehicle_submode_on_infrastructure_link.vehicle_submode; Type: COMMENT; Schema: infrastructure_network; Owner: dbhasura
--

COMMENT ON COLUMN infrastructure_network.vehicle_submode_on_infrastructure_link.vehicle_submode IS 'The vehicle submode that can safely traverse the infrastructure link.';

--
-- Name: FUNCTION find_point_direction_on_link(point_of_interest public.geography, infrastructure_link_uuid uuid, point_max_distance_in_meters double precision); Type: COMMENT; Schema: infrastructure_network; Owner: dbhasura
--

COMMENT ON FUNCTION infrastructure_network.find_point_direction_on_link(point_of_interest public.geography, infrastructure_link_uuid uuid, point_max_distance_in_meters double precision) IS 'Function for resolving point direction relative to given infrastructure link.
  Recommended upper limit for point_max_distance_in_meters parameter is 50 as increasing distance increases odds of matching errors.
  Returns null if direction could not be resolved.';

--
-- Name: FUNCTION resolve_point_to_closest_link(geog public.geography); Type: COMMENT; Schema: infrastructure_network; Owner: dbhasura
--

COMMENT ON FUNCTION infrastructure_network.resolve_point_to_closest_link(geog public.geography) IS 'Function for resolving closest infrastructure link to the given point of interest.';

--
-- Name: TABLE direction; Type: COMMENT; Schema: infrastructure_network; Owner: dbhasura
--

COMMENT ON TABLE infrastructure_network.direction IS 'The direction in which an e.g. infrastructure link can be traversed';

--
-- Name: TABLE external_source; Type: COMMENT; Schema: infrastructure_network; Owner: dbhasura
--

COMMENT ON TABLE infrastructure_network.external_source IS 'An external source from which infrastructure network parts are imported';

--
-- Name: TABLE infrastructure_link; Type: COMMENT; Schema: infrastructure_network; Owner: dbhasura
--

COMMENT ON TABLE infrastructure_network.infrastructure_link IS 'The infrastructure links, e.g. road or rail elements: https://www.transmodel-cen.eu/model/index.htm?goto=2:1:1:1:453';

--
-- Name: TABLE vehicle_submode_on_infrastructure_link; Type: COMMENT; Schema: infrastructure_network; Owner: dbhasura
--

COMMENT ON TABLE infrastructure_network.vehicle_submode_on_infrastructure_link IS 'Which infrastructure links are safely traversed by which vehicle submodes?';

--
-- Name: FUNCTION date_closed_upper(range daterange); Type: COMMENT; Schema: internal_utils; Owner: dbhasura
--

COMMENT ON FUNCTION internal_utils.date_closed_upper(range daterange) IS 'This function calculates the upper bound of a date range created by the
  internal_utils.daterange_closed_upper function.';

--
-- Name: FUNCTION daterange_closed_upper(lower_bound date, closed_upper_bound date); Type: COMMENT; Schema: internal_utils; Owner: dbhasura
--

COMMENT ON FUNCTION internal_utils.daterange_closed_upper(lower_bound date, closed_upper_bound date) IS 'In postgresql, date ranges are handled using lower bound closed and upper bound open. In order
  to be able to check for overlapping ranges when using closed upper bounds, this function constructs
  a daterange with the upper bound interpreted as a closed bound. This function behaves the same way
  as "daterange(lower_bound, upper_bound, ''[]'')", but because we also need to access the bounds (and
  this would anyway require manual addition / subtraction of 1 day), we rather do all processing in
  custom functions.

  Note that the range returned by this function will work well for calculating overlaps and merging,
  but does not contain the correct logical upper bound. In order to calculate the upper bound of a range
  created by this function, use the internal_utils.date_closed_upper function.';

--
-- Name: FUNCTION determine_srid(geog public.geography); Type: COMMENT; Schema: internal_utils; Owner: dbhasura
--

COMMENT ON FUNCTION internal_utils.determine_srid(geog public.geography) IS 'Determine the most suitable SRID to be used for the given geography when converting it to a geometry.
   At the moment, this function serves as a wrapper for the internal _ST_BestSRID function, which is poorly
   documented and may be removed in the future.
   If needed, modify this function and its overloads to return the correct SRID(s) for your use case(s). For many
   projects, returning a constant may be a good choice.';

--
-- Name: FUNCTION determine_srid(geog1 public.geography, geog2 public.geography); Type: COMMENT; Schema: internal_utils; Owner: dbhasura
--

COMMENT ON FUNCTION internal_utils.determine_srid(geog1 public.geography, geog2 public.geography) IS 'Determine the most suitable common SRID to be used for the given geographies when converting them into geometries.
   At the moment, this function serves as a wrapper for the internal _ST_BestSRID function, which is poorly
   documented and may be removed in the future.
   If needed, modify this function and its overloads to return the correct SRID(s) for your use case(s). For many
   projects, returning a constant may be a good choice.';

--
-- Name: FUNCTION st_closestpoint(a_linestring public.geography, a_point public.geography); Type: COMMENT; Schema: internal_utils; Owner: dbhasura
--

COMMENT ON FUNCTION internal_utils.st_closestpoint(a_linestring public.geography, a_point public.geography) IS 'ST_ClosestPoint for geography';

--
-- Name: FUNCTION st_lineinterpolatepoint(a_linestring public.geography, a_fraction double precision); Type: COMMENT; Schema: internal_utils; Owner: dbhasura
--

COMMENT ON FUNCTION internal_utils.st_lineinterpolatepoint(a_linestring public.geography, a_fraction double precision) IS 'ST_LineInterpolatePoint for geography';

--
-- Name: FUNCTION st_linelocatepoint(a_linestring public.geography, a_point public.geography); Type: COMMENT; Schema: internal_utils; Owner: dbhasura
--

COMMENT ON FUNCTION internal_utils.st_linelocatepoint(a_linestring public.geography, a_point public.geography) IS 'ST_LineLocatePoint for geography';

--
-- Name: COLUMN journey_pattern.journey_pattern_id; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON COLUMN journey_pattern.journey_pattern.journey_pattern_id IS 'The ID of the journey pattern.';

--
-- Name: COLUMN journey_pattern.on_route_id; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON COLUMN journey_pattern.journey_pattern.on_route_id IS 'The ID of the route the journey pattern is on.';

--
-- Name: COLUMN scheduled_stop_point_in_journey_pattern.is_loading_time_allowed; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON COLUMN journey_pattern.scheduled_stop_point_in_journey_pattern.is_loading_time_allowed IS 'Is adding loading time to this scheduled stop point in the journey pattern allowed?';

--
-- Name: COLUMN scheduled_stop_point_in_journey_pattern.is_regulated_timing_point; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON COLUMN journey_pattern.scheduled_stop_point_in_journey_pattern.is_regulated_timing_point IS 'Is this stop point passing time regulated so that it cannot be passed before scheduled time?';

--
-- Name: COLUMN scheduled_stop_point_in_journey_pattern.is_used_as_timing_point; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON COLUMN journey_pattern.scheduled_stop_point_in_journey_pattern.is_used_as_timing_point IS 'Is this scheduled stop point used as a timing point in the journey pattern?';

--
-- Name: COLUMN scheduled_stop_point_in_journey_pattern.is_via_point; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON COLUMN journey_pattern.scheduled_stop_point_in_journey_pattern.is_via_point IS 'Is this scheduled stop point a via point?';

--
-- Name: COLUMN scheduled_stop_point_in_journey_pattern.journey_pattern_id; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON COLUMN journey_pattern.scheduled_stop_point_in_journey_pattern.journey_pattern_id IS 'The ID of the journey pattern.';

--
-- Name: COLUMN scheduled_stop_point_in_journey_pattern.scheduled_stop_point_sequence; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON COLUMN journey_pattern.scheduled_stop_point_in_journey_pattern.scheduled_stop_point_sequence IS 'The order of the scheduled stop point within the journey pattern.';

--
-- Name: FUNCTION check_infra_link_stop_refs_with_new_scheduled_stop_point(replace_scheduled_stop_point_id uuid, new_located_on_infrastructure_link_id uuid, new_measured_location public.geography, new_direction text, new_label text, new_validity_start date, new_validity_end date, new_priority integer); Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON FUNCTION journey_pattern.check_infra_link_stop_refs_with_new_scheduled_stop_point(replace_scheduled_stop_point_id uuid, new_located_on_infrastructure_link_id uuid, new_measured_location public.geography, new_direction text, new_label text, new_validity_start date, new_validity_end date, new_priority integer) IS 'Check whether the journey pattern''s / route''s links and stop points still correspond to each other
     if a new stop point would be inserted (defined by arguments new_xxx). If replace_scheduled_stop_point_id
     is specified, the new stop point is thought to replace the stop point with that ID.
     This function returns a list of journey pattern and route ids, in which the links
     and stop points would conflict with each other.';

--
-- Name: FUNCTION create_verify_infra_link_stop_refs_queue_temp_table(); Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON FUNCTION journey_pattern.create_verify_infra_link_stop_refs_queue_temp_table() IS 'Create the temp table used to enqueue verification of the changed routes from
  statement-level triggers';

--
-- Name: FUNCTION get_broken_route_check_filters(filter_route_ids uuid[]); Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON FUNCTION journey_pattern.get_broken_route_check_filters(filter_route_ids uuid[]) IS 'Gather the filter parameters (route labels and validity range to check) for the broken route check.';

--
-- Name: FUNCTION get_broken_route_journey_patterns(filter_route_ids uuid[], replace_scheduled_stop_point_id uuid, new_located_on_infrastructure_link_id uuid, new_measured_location public.geography, new_direction text, new_label text, new_validity_start date, new_validity_end date, new_priority integer); Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON FUNCTION journey_pattern.get_broken_route_journey_patterns(filter_route_ids uuid[], replace_scheduled_stop_point_id uuid, new_located_on_infrastructure_link_id uuid, new_measured_location public.geography, new_direction text, new_label text, new_validity_start date, new_validity_end date, new_priority integer) IS 'Check if it is possible to visit all stops of journey patterns in such a fashion that all links, on which
     the stops reside, are visited in an order matching the corresponding routes'' link order. Additionally it is
     checked that there are no stop points on the route''s journey pattern, whose validity span does not overlap with
     the route''s validity span at all. Only the links / stops on the routes with the specified filter_route_ids are
     taken into account for the checks.

     If replace_scheduled_stop_point_id is not null, the stop with that id is left out of the check.
     If the new_xxx arguments are specified, the check is also performed for an imaginary stop defined by those
     arguments, which is not yet present in the table data.

     This functions returns those journey pattern / route combinations, which are broken (either in actual
     table data or with the proposed scheduled stop point changes).';

--
-- Name: FUNCTION infra_link_stop_refs_already_verified(); Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON FUNCTION journey_pattern.infra_link_stop_refs_already_verified() IS 'Keep track of whether the infra link <-> stop ref verification has already been performed in this transaction';

--
-- Name: FUNCTION maximum_priority_validity_spans(entity_type text, filter_route_labels text[], filter_validity_start date, filter_validity_end date, upper_priority_limit integer, replace_scheduled_stop_point_id uuid, new_scheduled_stop_point_id uuid, new_located_on_infrastructure_link_id uuid, new_measured_location public.geography, new_direction text, new_label text, new_validity_start date, new_validity_end date, new_priority integer); Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON FUNCTION journey_pattern.maximum_priority_validity_spans(entity_type text, filter_route_labels text[], filter_validity_start date, filter_validity_end date, upper_priority_limit integer, replace_scheduled_stop_point_id uuid, new_scheduled_stop_point_id uuid, new_located_on_infrastructure_link_id uuid, new_measured_location public.geography, new_direction text, new_label text, new_validity_start date, new_validity_end date, new_priority integer) IS 'Find the validity time spans of highest priority in the given time span for entities of the given type (routes or
    scheduled stop points), which are related to routes with any of the given labels.

    Consider the validity times of two overlapping route instances with label A:
    A* (prio 20):        |--------|
    A (prio 10):   |---------|

    These would be split into the following maximum priority validity time spans:
                   |--A--|--A*----|

    Similarly, the following route instances with label B
    B* (prio 20):        |-------|
    B (prio 10):   |-------------------------|

    would be split into the following maximum priority validity time spans:
                   |--B--|--B*---|----B------|

    For scheduled stop points the splitting is performed in the same fashion, except that if
    replace_scheduled_stop_point_id is not null, the stop with that id is left out. If the new_xxx arguments are
    specified, the check is also performed for a stop defined by those arguments, which is not yet present in the
    table data.';

--
-- Name: FUNCTION scheduled_stop_point_has_timing_place_if_used_as_timing_point(); Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON FUNCTION journey_pattern.scheduled_stop_point_has_timing_place_if_used_as_timing_point() IS 'If scheduled stop point in journey pattern is marked to be used as timing point, a timing place must be attached to each instance of the scheduled stop point.';

--
-- Name: FUNCTION truncate_scheduled_stop_point_in_journey_pattern(); Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON FUNCTION journey_pattern.truncate_scheduled_stop_point_in_journey_pattern() IS '''Truncate the scheduled_stop_point_in_journey_pattern if it contains any rows. It must not be truncated if it
  does not contain data to prevent errors if it was truncated ("touched") within the same transaction.''';

--
-- Name: FUNCTION verify_infra_link_stop_refs(); Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON FUNCTION journey_pattern.verify_infra_link_stop_refs() IS 'Perform verification of all queued route entries.
   Raise an exception if the specified journey pattern''s / route''s links and stop points do not
   correspond to each other.';

--
-- Name: FUNCTION verify_route_journey_pattern_refs(filter_journey_pattern_id uuid, filter_route_id uuid); Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON FUNCTION journey_pattern.verify_route_journey_pattern_refs(filter_journey_pattern_id uuid, filter_route_id uuid) IS 'Raise an exception if the specified journey pattern''s / route''s links and stop points do not
   correspond to each other.';

--
-- Name: TABLE journey_pattern; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON TABLE journey_pattern.journey_pattern IS 'The journey patterns, i.e. the ordered lists of stops and timing points along routes: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:1:813';

--
-- Name: TABLE scheduled_stop_point_in_journey_pattern; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON TABLE journey_pattern.scheduled_stop_point_in_journey_pattern IS 'The scheduled stop points that form the journey pattern, in order: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:1:813 . For HSL, all timing points are stops, hence journey pattern instead of service pattern.';

--
-- Name: TRIGGER queue_verify_infra_link_stop_refs_on_jp_update_trigger ON journey_pattern; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON TRIGGER queue_verify_infra_link_stop_refs_on_jp_update_trigger ON journey_pattern.journey_pattern IS 'Trigger to verify the infra link <-> scheduled stop point references.
      Updating a journey_pattern''s reference to a route (on_route_id) can break the route consistency in a way that
      the new route is in violation with the journey pattern''s stop points in one of the following ways:
      1. A stop point of the journey pattern might be located on an infra link which is not part of the journey
         pattern''s new route.
      2. The journey pattern may contain a stop point located at a position in the journey pattern, which does not
         correspond to the position of the stop point''s infra link within the new route.
      3. A stop point might not have any instances whose validity time would at all overlap with the journey
         pattern''s new route''s validity time ("ghost stop").';

--
-- Name: TRIGGER queue_verify_infra_link_stop_refs_on_sspijp_insert_trigger ON scheduled_stop_point_in_journey_pattern; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON TRIGGER queue_verify_infra_link_stop_refs_on_sspijp_insert_trigger ON journey_pattern.scheduled_stop_point_in_journey_pattern IS 'Trigger to verify the infra link <-> scheduled stop point references.
      Inserting a new scheduled_stop_point_in_journey_pattern -row can break the route consistency in the following
      ways:
      1. The inserted stop point might be located on an infra link which is not part of the journey pattern''s route.
      2. The stop point might be inserted at a position in the journey pattern, which does not correspond to the
         position of the stop point''s infra link within the route.
      3. The stop point might not have any instances whose validity time would at all overlap with the journey
         pattern''s route''s validity time ("ghost stop").';

--
-- Name: TRIGGER queue_verify_infra_link_stop_refs_on_sspijp_update_trigger ON scheduled_stop_point_in_journey_pattern; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON TRIGGER queue_verify_infra_link_stop_refs_on_sspijp_update_trigger ON journey_pattern.scheduled_stop_point_in_journey_pattern IS 'Trigger to verify the infra link <-> scheduled stop point references.
      Updating a scheduled_stop_point_in_journey_pattern -row can break the route consistency in the following
      ways:
      1. The updated stop point might be located on an infra link which is not part of the journey pattern''s route.
      2. The stop point might be moved to a position in the journey pattern, which does not correspond to the
         position of the stop point''s infra link within the route.
      3. The updated stop point might not have any instances whose validity time would at all overlap with the journey
         pattern''s route''s validity time ("ghost stop").';

--
-- Name: TRIGGER verify_infra_link_stop_refs_on_journey_pattern_trigger ON journey_pattern; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON TRIGGER verify_infra_link_stop_refs_on_journey_pattern_trigger ON journey_pattern.journey_pattern IS 'Trigger to verify the infra link <-> stop references after a delete on the
   route table.

   This trigger will cause those routes to be checked, whose ID was queued to be checked by a statement
   level trigger.';

--
-- Name: TRIGGER verify_infra_link_stop_refs_on_sspijp_trigger ON scheduled_stop_point_in_journey_pattern; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON TRIGGER verify_infra_link_stop_refs_on_sspijp_trigger ON journey_pattern.scheduled_stop_point_in_journey_pattern IS 'Trigger to verify the infra link <-> stop references after an insert or update on the
   scheduled_stop_point_in_journey_pattern table.

   This trigger will cause those routes to be checked, whose ID was queued to be checked by a statement
   level trigger.';

--
-- Name: COLUMN vehicle_mode.vehicle_mode; Type: COMMENT; Schema: reusable_components; Owner: dbhasura
--

COMMENT ON COLUMN reusable_components.vehicle_mode.vehicle_mode IS 'The vehicle mode from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=1:6:1:283';

--
-- Name: COLUMN vehicle_submode.belonging_to_vehicle_mode; Type: COMMENT; Schema: reusable_components; Owner: dbhasura
--

COMMENT ON COLUMN reusable_components.vehicle_submode.belonging_to_vehicle_mode IS 'The vehicle mode the vehicle submode belongs to: https://www.transmodel-cen.eu/model/index.htm?goto=1:6:1:283';

--
-- Name: COLUMN vehicle_submode.vehicle_submode; Type: COMMENT; Schema: reusable_components; Owner: dbhasura
--

COMMENT ON COLUMN reusable_components.vehicle_submode.vehicle_submode IS 'The vehicle submode, which may have implications on which infrastructure links the vehicle can traverse';

--
-- Name: TABLE vehicle_mode; Type: COMMENT; Schema: reusable_components; Owner: dbhasura
--

COMMENT ON TABLE reusable_components.vehicle_mode IS 'The vehicle modes from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=1:6:1:283';

--
-- Name: TABLE vehicle_submode; Type: COMMENT; Schema: reusable_components; Owner: dbhasura
--

COMMENT ON TABLE reusable_components.vehicle_submode IS 'The vehicle submode, which may have implications on which infrastructure links the vehicle can traverse';

--
-- Name: COLUMN direction.direction; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.direction.direction IS 'The name of the route direction.';

--
-- Name: COLUMN direction.the_opposite_of_direction; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.direction.the_opposite_of_direction IS 'The opposite direction.';

--
-- Name: COLUMN infrastructure_link_along_route.infrastructure_link_id; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.infrastructure_link_along_route.infrastructure_link_id IS 'The ID of the infrastructure link.';

--
-- Name: COLUMN infrastructure_link_along_route.infrastructure_link_sequence; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.infrastructure_link_along_route.infrastructure_link_sequence IS 'The order of the infrastructure link within the journey pattern.';

--
-- Name: COLUMN infrastructure_link_along_route.is_traversal_forwards; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.infrastructure_link_along_route.is_traversal_forwards IS 'Is the infrastructure link traversed in the direction of its linestring?';

--
-- Name: COLUMN infrastructure_link_along_route.route_id; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.infrastructure_link_along_route.route_id IS 'The ID of the route.';

--
-- Name: COLUMN line.label; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.line.label IS 'The label of the line definition. The label is unique for a certain priority and validity period.';

--
-- Name: COLUMN line.line_id; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.line.line_id IS 'The ID of the line.';

--
-- Name: COLUMN line.name_i18n; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.line.name_i18n IS 'The name of the line. Placeholder for multilingual strings.';

--
-- Name: COLUMN line.primary_vehicle_mode; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.line.primary_vehicle_mode IS 'The mode of the vehicles used as primary on the line.';

--
-- Name: COLUMN line.priority; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.line.priority IS 'The priority of the line definition. The definition may be overridden by higher priority definitions.';

--
-- Name: COLUMN line.short_name_i18n; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.line.short_name_i18n IS 'The shorted name of the line. Placeholder for multilingual strings.';

--
-- Name: COLUMN line.type_of_line; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.line.type_of_line IS 'The type of the line.';

--
-- Name: COLUMN line.validity_end; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.line.validity_end IS 'The point in time from which onwards the line is no longer valid. If NULL, the line will be always valid.';

--
-- Name: COLUMN line.validity_start; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.line.validity_start IS 'The point in time when the line becomes valid. If NULL, the line has been always valid.';

--
-- Name: COLUMN route.description_i18n; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.route.description_i18n IS 'The description of the route in the form of starting location - destination. Placeholder for multilingual strings.';

--
-- Name: COLUMN route.direction; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.route.direction IS 'The direction of the route definition.';

--
-- Name: COLUMN route.label; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.route.label IS 'The label of the route definition.';

--
-- Name: COLUMN route.on_line_id; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.route.on_line_id IS 'The line to which this route belongs.';

--
-- Name: COLUMN route.priority; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.route.priority IS 'The priority of the route definition. The definition may be overridden by higher priority definitions.';

--
-- Name: COLUMN route.route_id; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.route.route_id IS 'The ID of the route.';

--
-- Name: COLUMN route.unique_label; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.route.unique_label IS 'Derived from label. Routes are unique for each unique label for a certain direction, priority and validity period';

--
-- Name: COLUMN route.validity_end; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.route.validity_end IS 'The point in time from which onwards the route is no longer valid. If NULL, the route is valid indefinitely after the start time of the validity period.';

--
-- Name: COLUMN route.validity_start; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.route.validity_start IS 'The point in time when the route becomes valid. If NULL, the route has been always valid before end time of validity period.';

--
-- Name: COLUMN type_of_line.type_of_line; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON COLUMN route.type_of_line.type_of_line IS 'GTFS route type: https://developers.google.com/transit/gtfs/reference/extended-route-types';

--
-- Name: TABLE direction; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON TABLE route.direction IS 'The route directions from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:1:3:480';

--
-- Name: TABLE infrastructure_link_along_route; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON TABLE route.infrastructure_link_along_route IS 'The infrastructure links along which the routes are defined.';

--
-- Name: TABLE line; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON TABLE route.line IS 'The line from Transmodel: http://www.transmodel-cen.eu/model/index.htm?goto=2:1:3:487';

--
-- Name: TABLE route; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON TABLE route.route IS 'The routes from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:1:3:483';

--
-- Name: TABLE type_of_line; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON TABLE route.type_of_line IS 'Type of line. https://www.transmodel-cen.eu/model/EARoot/EA2/EA1/EA3/EA491.htm';

--
-- Name: TRIGGER queue_verify_infra_link_stop_refs_on_ilar_delete_trigger ON infrastructure_link_along_route; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON TRIGGER queue_verify_infra_link_stop_refs_on_ilar_delete_trigger ON route.infrastructure_link_along_route IS 'Trigger to verify the infra link <-> scheduled stop point references.
      Deleting an infrastructure_link_along_route -row can break the route consistency in such a way that
      an infra link associated with a stop point on journey pattern might not be part of the route anymore.';

--
-- Name: TRIGGER queue_verify_infra_link_stop_refs_on_ilar_update_trigger ON infrastructure_link_along_route; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON TRIGGER queue_verify_infra_link_stop_refs_on_ilar_update_trigger ON route.infrastructure_link_along_route IS 'Trigger to verify the infra link <-> scheduled stop point references.
      Updating an infrastructure_link_along_route -row can break the route consistency in such a way that
      an infra link associated with a stop point on a journey pattern might not be part of the (journey pattern''s)
      route anymore.';

--
-- Name: TRIGGER queue_verify_infra_link_stop_refs_on_route_delete_trigger ON route; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON TRIGGER queue_verify_infra_link_stop_refs_on_route_delete_trigger ON route.route IS 'Trigger to verify the infra link <-> scheduled stop point references.
      Deleting a route row can "reveal" a lower priority route instance (which was not valid before), which may be
      break the route consistency such that:
      1. The revealed route''s journey pattern may contain a stop point, which is located on an infra link not part of
         the revealed route.
      2. The revealed route''s journey pattern may contain a stop point located at a position in the journey pattern,
         which does not correspond to the position of the stop point''s infra link within the revealed route.
      3. A stop point of the revealed route''s journey pattern might not have any instances whose validity time overlap
         at all with the revealed route''s validity time ("ghost stop").';

--
-- Name: TRIGGER verify_infra_link_stop_refs_on_ilar_trigger ON infrastructure_link_along_route; Type: COMMENT; Schema: route; Owner: dbhasura
--

COMMENT ON TRIGGER verify_infra_link_stop_refs_on_ilar_trigger ON route.infrastructure_link_along_route IS 'Trigger to verify the infra link <-> stop references after an update or delete on the
   infrastructure_link_along_route table.

   This trigger will cause those routes to be checked, whose ID was queued to be checked by a statement
   level trigger.';

--
-- Name: COLUMN distance_between_stops_calculation.distance_in_metres; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.distance_between_stops_calculation.distance_in_metres IS 'The length of the stop interval in metres.';

--
-- Name: COLUMN distance_between_stops_calculation.end_stop_label; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.distance_between_stops_calculation.end_stop_label IS 'The label of the end stop of the stop interval.';

--
-- Name: COLUMN distance_between_stops_calculation.journey_pattern_id; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.distance_between_stops_calculation.journey_pattern_id IS 'The ID of the journey pattern.';

--
-- Name: COLUMN distance_between_stops_calculation.observation_date; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.distance_between_stops_calculation.observation_date IS 'The observation date for the state of the route related to the journey pattern.';

--
-- Name: COLUMN distance_between_stops_calculation.route_id; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.distance_between_stops_calculation.route_id IS 'The ID of the route related to the journey pattern.';

--
-- Name: COLUMN distance_between_stops_calculation.route_priority; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.distance_between_stops_calculation.route_priority IS 'The priority of the route related to the journey pattern.';

--
-- Name: COLUMN distance_between_stops_calculation.start_stop_label; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.distance_between_stops_calculation.start_stop_label IS 'The label of the start stop of the stop interval.';

--
-- Name: COLUMN distance_between_stops_calculation.stop_interval_sequence; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.distance_between_stops_calculation.stop_interval_sequence IS 'The sequence number of the stop interval within the journey pattern.';

--
-- Name: COLUMN scheduled_stop_point.direction; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.scheduled_stop_point.direction IS 'The direction(s) of traffic with respect to the digitization, i.e. the direction of the specified line string.';

--
-- Name: COLUMN scheduled_stop_point.label; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.scheduled_stop_point.label IS 'The label is the short code that identifies the stop to the passengers. There can be at most one stop with the same label at a time. The label matches the GTFS stop_code.';

--
-- Name: COLUMN scheduled_stop_point.located_on_infrastructure_link_id; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.scheduled_stop_point.located_on_infrastructure_link_id IS 'The infrastructure link on which the stop is located.';

--
-- Name: COLUMN scheduled_stop_point.measured_location; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.scheduled_stop_point.measured_location IS 'The measured location describes the physical location of the stop. For some stops this describes the location of the pole-mounted flag. A PostGIS PointZ geography in EPSG:4326.';

--
-- Name: COLUMN scheduled_stop_point.scheduled_stop_point_id; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.scheduled_stop_point.scheduled_stop_point_id IS 'The ID of the scheduled stop point.';

--
-- Name: COLUMN scheduled_stop_point.timing_place_id; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.scheduled_stop_point.timing_place_id IS 'Optional reference to a TIMING PLACE. If NULL, the SCHEDULED STOP POINT is not used for timing.';

--
-- Name: COLUMN scheduled_stop_point.validity_end; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.scheduled_stop_point.validity_end IS 'end of the operating date span in the scheduled stop point''s local time';

--
-- Name: COLUMN scheduled_stop_point.validity_start; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.scheduled_stop_point.validity_start IS 'end of the route''s operating date span in the route''s local time';

--
-- Name: COLUMN vehicle_mode_on_scheduled_stop_point.scheduled_stop_point_id; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.vehicle_mode_on_scheduled_stop_point.scheduled_stop_point_id IS 'The scheduled stop point that is serviced by the vehicle mode.';

--
-- Name: COLUMN vehicle_mode_on_scheduled_stop_point.vehicle_mode; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.vehicle_mode_on_scheduled_stop_point.vehicle_mode IS 'The vehicle mode servicing the scheduled stop point.';

--
-- Name: FUNCTION find_effective_scheduled_stop_points_in_journey_pattern(filter_journey_pattern_id uuid, observation_date date, include_draft_stops boolean); Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON FUNCTION service_pattern.find_effective_scheduled_stop_points_in_journey_pattern(filter_journey_pattern_id uuid, observation_date date, include_draft_stops boolean) IS 'Find effective scheduled stop points in journey/service pattern.';

--
-- Name: FUNCTION find_scheduled_stop_point_locations_in_journey_pattern(filter_journey_pattern_id uuid, observation_date date, include_draft_stops boolean); Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON FUNCTION service_pattern.find_scheduled_stop_point_locations_in_journey_pattern(filter_journey_pattern_id uuid, observation_date date, include_draft_stops boolean) IS 'Find location information for scheduled stop points in journey/service pattern.';

--
-- Name: FUNCTION get_distances_between_stop_points_by_routes(route_ids uuid[], observation_date date); Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON FUNCTION service_pattern.get_distances_between_stop_points_by_routes(route_ids uuid[], observation_date date) IS 'Get the distances between scheduled stop points (in metres) for the journey/service patterns resolved from the route identifiers.';

--
-- Name: FUNCTION get_distances_between_stop_points_in_journey_pattern(journey_pattern_id uuid, observation_date date, include_draft_stops boolean); Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON FUNCTION service_pattern.get_distances_between_stop_points_in_journey_pattern(journey_pattern_id uuid, observation_date date, include_draft_stops boolean) IS 'Get the distances between scheduled stop points (in metres) for the given journey/service pattern.';

--
-- Name: FUNCTION get_distances_between_stop_points_in_journey_patterns(journey_pattern_ids uuid[], observation_date date, include_draft_stops boolean); Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON FUNCTION service_pattern.get_distances_between_stop_points_in_journey_patterns(journey_pattern_ids uuid[], observation_date date, include_draft_stops boolean) IS 'Get the distances between scheduled stop points (in metres) for the given journey/service patterns.';

--
-- Name: FUNCTION get_scheduled_stop_points_with_new(replace_scheduled_stop_point_id uuid, new_scheduled_stop_point_id uuid, new_located_on_infrastructure_link_id uuid, new_measured_location public.geography, new_direction text, new_label text, new_validity_start date, new_validity_end date, new_priority integer); Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON FUNCTION service_pattern.get_scheduled_stop_points_with_new(replace_scheduled_stop_point_id uuid, new_scheduled_stop_point_id uuid, new_located_on_infrastructure_link_id uuid, new_measured_location public.geography, new_direction text, new_label text, new_validity_start date, new_validity_end date, new_priority integer) IS 'Returns the scheduled stop points from the service_pattern.scheduled_stop_point table.
     If replace_scheduled_stop_point_id is not null, the stop point with that ID is filtered out.
     Similarly, if the new_xxx arguments are specified, a scheduled stop point with those values is
     appended to the result (it is not inserted into the table).';

--
-- Name: FUNCTION scheduled_stop_point_closest_point_on_infrastructure_link(ssp service_pattern.scheduled_stop_point); Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON FUNCTION service_pattern.scheduled_stop_point_closest_point_on_infrastructure_link(ssp service_pattern.scheduled_stop_point) IS 'The point on the infrastructure link closest to measured_location. A PostGIS PointZ geography in EPSG:4326.';

--
-- Name: FUNCTION ssp_relative_distance_from_infrastructure_link_start(ssp service_pattern.scheduled_stop_point); Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON FUNCTION service_pattern.ssp_relative_distance_from_infrastructure_link_start(ssp service_pattern.scheduled_stop_point) IS 'The relative distance of the stop from the start of the linestring along the infrastructure link. Regardless of the specified direction, this value is the distance from the beginning of the linestring. The distance is normalized to the closed interval [0, 1].';

--
-- Name: TABLE distance_between_stops_calculation; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON TABLE service_pattern.distance_between_stops_calculation IS 'A dummy table that models the results of calculating the lengths of stop intervals from the given journey patterns. The table exists due to the limitations of Hasura and there is no intention to insert anything to it.';

--
-- Name: TABLE scheduled_stop_point; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON TABLE service_pattern.scheduled_stop_point IS 'The scheduled stop points: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:4:845 . Colloquially known as stops from the perspective of timetable planning.';

--
-- Name: TABLE vehicle_mode_on_scheduled_stop_point; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON TABLE service_pattern.vehicle_mode_on_scheduled_stop_point IS 'Which scheduled stop points are serviced by which vehicle modes?';

--
-- Name: TRIGGER queue_verify_infra_link_stop_refs_on_ssp_delete_trigger ON scheduled_stop_point; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON TRIGGER queue_verify_infra_link_stop_refs_on_ssp_delete_trigger ON service_pattern.scheduled_stop_point IS 'Trigger to verify the infra link <-> scheduled stop point references.
      Deleting a scheduled_stop_point instance can break the route consistency in the following ways:
      1. The deleted stop point instance may "reveal" a lower priority stop point instance, which may make the route and
         journey pattern conflict in the ways described above (see trigger for insertion of a row in the
         scheduled_stop_point table).
      2. The updated stop point might not anymore have any instances whose validity time would at all overlap with the
         journey pattern''s route''s validity time ("ghost stop").';

--
-- Name: TRIGGER queue_verify_infra_link_stop_refs_on_ssp_insert_trigger ON scheduled_stop_point; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON TRIGGER queue_verify_infra_link_stop_refs_on_ssp_insert_trigger ON service_pattern.scheduled_stop_point IS 'Trigger to verify the infra link <-> scheduled stop point references.
      Inserting a scheduled_stop_point instance can break the route consistency in the following ways:
      1. The new stop point instance might be located on an infra link which is not part of all of its journey
         pattern''s routes.
      2. The stop point instance might be located on an infra link, whose position in a route does not correspond to the
         position of the stop point in the corresponding journey pattern.';

--
-- Name: TRIGGER queue_verify_infra_link_stop_refs_on_ssp_update_trigger ON scheduled_stop_point; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON TRIGGER queue_verify_infra_link_stop_refs_on_ssp_update_trigger ON service_pattern.scheduled_stop_point IS 'Trigger to verify the infra link <-> scheduled stop point references.
      Updating a scheduled_stop_point instance can break the route consistency in the following ways:
      1. The updated stop point instance might be located on an infra link which is not part of all of its journey
         pattern''s routes.
      2. The updated stop point instance might be located on an infra link, whose position in a route does not
         correspond to the position of the stop point in the corresponding journey pattern.
      3. The deleted stop point instance may "reveal" a lower priority stop point instance (by change of validity time),
         which may make the route and journey pattern conflict in the ways described above with regard to the revealed
         stop point.
      4. The updated stop point might not anymore have any instances whose validity time would at all overlap with the
         journey pattern''s route''s validity time ("ghost stop").';

--
-- Name: TRIGGER verify_infra_link_stop_refs_on_scheduled_stop_point_trigger ON scheduled_stop_point; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON TRIGGER verify_infra_link_stop_refs_on_scheduled_stop_point_trigger ON service_pattern.scheduled_stop_point IS 'Trigger to verify the infra link <-> stop references after an insert, update, or delete on the
   scheduled_stop_point table.

   This trigger will cause those routes to be checked, whose ID was queued to be checked by a statement
   level trigger.';

--
-- Name: TABLE timing_place; Type: COMMENT; Schema: timing_pattern; Owner: dbhasura
--

COMMENT ON TABLE timing_pattern.timing_place IS 'A set of SCHEDULED STOP POINTs against which the timing information necessary to build schedules may be recorded. In HSL context this is "Hastus paikka". Based on Transmodel entity TIMING POINT: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:2:709 ';

--
-- Name: hdb_action_log hdb_action_log_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: dbhasura
--

ALTER TABLE ONLY hdb_catalog.hdb_action_log
    ADD CONSTRAINT hdb_action_log_pkey PRIMARY KEY (id);

--
-- Name: hdb_cron_event_invocation_logs hdb_cron_event_invocation_logs_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: dbhasura
--

ALTER TABLE ONLY hdb_catalog.hdb_cron_event_invocation_logs
    ADD CONSTRAINT hdb_cron_event_invocation_logs_pkey PRIMARY KEY (id);

--
-- Name: hdb_cron_events hdb_cron_events_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: dbhasura
--

ALTER TABLE ONLY hdb_catalog.hdb_cron_events
    ADD CONSTRAINT hdb_cron_events_pkey PRIMARY KEY (id);

--
-- Name: hdb_metadata hdb_metadata_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: dbhasura
--

ALTER TABLE ONLY hdb_catalog.hdb_metadata
    ADD CONSTRAINT hdb_metadata_pkey PRIMARY KEY (id);

--
-- Name: hdb_metadata hdb_metadata_resource_version_key; Type: CONSTRAINT; Schema: hdb_catalog; Owner: dbhasura
--

ALTER TABLE ONLY hdb_catalog.hdb_metadata
    ADD CONSTRAINT hdb_metadata_resource_version_key UNIQUE (resource_version);

--
-- Name: hdb_scheduled_event_invocation_logs hdb_scheduled_event_invocation_logs_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: dbhasura
--

ALTER TABLE ONLY hdb_catalog.hdb_scheduled_event_invocation_logs
    ADD CONSTRAINT hdb_scheduled_event_invocation_logs_pkey PRIMARY KEY (id);

--
-- Name: hdb_scheduled_events hdb_scheduled_events_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: dbhasura
--

ALTER TABLE ONLY hdb_catalog.hdb_scheduled_events
    ADD CONSTRAINT hdb_scheduled_events_pkey PRIMARY KEY (id);

--
-- Name: hdb_schema_notifications hdb_schema_notifications_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: dbhasura
--

ALTER TABLE ONLY hdb_catalog.hdb_schema_notifications
    ADD CONSTRAINT hdb_schema_notifications_pkey PRIMARY KEY (id);

--
-- Name: hdb_version hdb_version_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: dbhasura
--

ALTER TABLE ONLY hdb_catalog.hdb_version
    ADD CONSTRAINT hdb_version_pkey PRIMARY KEY (hasura_uuid);

--
-- Name: direction direction_pkey; Type: CONSTRAINT; Schema: infrastructure_network; Owner: dbhasura
--

ALTER TABLE ONLY infrastructure_network.direction
    ADD CONSTRAINT direction_pkey PRIMARY KEY (value);

--
-- Name: external_source external_source_pkey; Type: CONSTRAINT; Schema: infrastructure_network; Owner: dbhasura
--

ALTER TABLE ONLY infrastructure_network.external_source
    ADD CONSTRAINT external_source_pkey PRIMARY KEY (value);

--
-- Name: infrastructure_link infrastructure_link_pkey; Type: CONSTRAINT; Schema: infrastructure_network; Owner: dbhasura
--

ALTER TABLE ONLY infrastructure_network.infrastructure_link
    ADD CONSTRAINT infrastructure_link_pkey PRIMARY KEY (infrastructure_link_id);

--
-- Name: vehicle_submode_on_infrastructure_link vehicle_submode_on_infrastructure_link_pkey; Type: CONSTRAINT; Schema: infrastructure_network; Owner: dbhasura
--

ALTER TABLE ONLY infrastructure_network.vehicle_submode_on_infrastructure_link
    ADD CONSTRAINT vehicle_submode_on_infrastructure_link_pkey PRIMARY KEY (infrastructure_link_id, vehicle_submode);

--
-- Name: journey_pattern journey_pattern_pkey; Type: CONSTRAINT; Schema: journey_pattern; Owner: dbhasura
--

ALTER TABLE ONLY journey_pattern.journey_pattern
    ADD CONSTRAINT journey_pattern_pkey PRIMARY KEY (journey_pattern_id);

--
-- Name: scheduled_stop_point_in_journey_pattern scheduled_stop_point_in_journey_pattern_pkey; Type: CONSTRAINT; Schema: journey_pattern; Owner: dbhasura
--

ALTER TABLE ONLY journey_pattern.scheduled_stop_point_in_journey_pattern
    ADD CONSTRAINT scheduled_stop_point_in_journey_pattern_pkey PRIMARY KEY (journey_pattern_id, scheduled_stop_point_sequence);

--
-- Name: vehicle_mode vehicle_mode_pkey; Type: CONSTRAINT; Schema: reusable_components; Owner: dbhasura
--

ALTER TABLE ONLY reusable_components.vehicle_mode
    ADD CONSTRAINT vehicle_mode_pkey PRIMARY KEY (vehicle_mode);

--
-- Name: vehicle_submode vehicle_submode_pkey; Type: CONSTRAINT; Schema: reusable_components; Owner: dbhasura
--

ALTER TABLE ONLY reusable_components.vehicle_submode
    ADD CONSTRAINT vehicle_submode_pkey PRIMARY KEY (vehicle_submode);

--
-- Name: direction direction_pkey; Type: CONSTRAINT; Schema: route; Owner: dbhasura
--

ALTER TABLE ONLY route.direction
    ADD CONSTRAINT direction_pkey PRIMARY KEY (direction);

--
-- Name: infrastructure_link_along_route infrastructure_link_along_route_pkey; Type: CONSTRAINT; Schema: route; Owner: dbhasura
--

ALTER TABLE ONLY route.infrastructure_link_along_route
    ADD CONSTRAINT infrastructure_link_along_route_pkey PRIMARY KEY (route_id, infrastructure_link_sequence);

--
-- Name: line line_pkey; Type: CONSTRAINT; Schema: route; Owner: dbhasura
--

ALTER TABLE ONLY route.line
    ADD CONSTRAINT line_pkey PRIMARY KEY (line_id);

--
-- Name: line line_unique_validity_period; Type: CONSTRAINT; Schema: route; Owner: dbhasura
--

ALTER TABLE ONLY route.line
    ADD CONSTRAINT line_unique_validity_period EXCLUDE USING gist (label WITH =, priority WITH =, internal_utils.daterange_closed_upper(validity_start, validity_end) WITH &&) WHERE ((priority < internal_utils.const_priority_draft()));

--
-- Name: route route_pkey; Type: CONSTRAINT; Schema: route; Owner: dbhasura
--

ALTER TABLE ONLY route.route
    ADD CONSTRAINT route_pkey PRIMARY KEY (route_id);

--
-- Name: route route_unique_validity_period; Type: CONSTRAINT; Schema: route; Owner: dbhasura
--

ALTER TABLE ONLY route.route
    ADD CONSTRAINT route_unique_validity_period EXCLUDE USING gist (unique_label WITH =, direction WITH =, priority WITH =, internal_utils.daterange_closed_upper(validity_start, validity_end) WITH &&) WHERE ((priority < internal_utils.const_priority_draft()));

--
-- Name: type_of_line type_of_line_pkey; Type: CONSTRAINT; Schema: route; Owner: dbhasura
--

ALTER TABLE ONLY route.type_of_line
    ADD CONSTRAINT type_of_line_pkey PRIMARY KEY (type_of_line);

--
-- Name: distance_between_stops_calculation distance_between_stops_calculation_pkey; Type: CONSTRAINT; Schema: service_pattern; Owner: dbhasura
--

ALTER TABLE ONLY service_pattern.distance_between_stops_calculation
    ADD CONSTRAINT distance_between_stops_calculation_pkey PRIMARY KEY (journey_pattern_id, route_priority, observation_date, stop_interval_sequence);

--
-- Name: scheduled_stop_point scheduled_stop_point_pkey; Type: CONSTRAINT; Schema: service_pattern; Owner: dbhasura
--

ALTER TABLE ONLY service_pattern.scheduled_stop_point
    ADD CONSTRAINT scheduled_stop_point_pkey PRIMARY KEY (scheduled_stop_point_id);

--
-- Name: scheduled_stop_point unique_validity_period; Type: CONSTRAINT; Schema: service_pattern; Owner: dbhasura
--

ALTER TABLE ONLY service_pattern.scheduled_stop_point
    ADD CONSTRAINT unique_validity_period EXCLUDE USING gist (label WITH =, priority WITH =, internal_utils.daterange_closed_upper(validity_start, validity_end) WITH &&) WHERE ((priority < internal_utils.const_priority_draft()));

--
-- Name: scheduled_stop_point_invariant scheduled_stop_point_invariant_pkey; Type: CONSTRAINT; Schema: service_pattern; Owner: dbhasura
--

ALTER TABLE ONLY service_pattern.scheduled_stop_point_invariant
    ADD CONSTRAINT scheduled_stop_point_invariant_pkey PRIMARY KEY (label);

--
-- Name: vehicle_mode_on_scheduled_stop_point scheduled_stop_point_serviced_by_vehicle_mode_pkey; Type: CONSTRAINT; Schema: service_pattern; Owner: dbhasura
--

ALTER TABLE ONLY service_pattern.vehicle_mode_on_scheduled_stop_point
    ADD CONSTRAINT scheduled_stop_point_serviced_by_vehicle_mode_pkey PRIMARY KEY (scheduled_stop_point_id, vehicle_mode);

--
-- Name: timing_place timing_place_pkey; Type: CONSTRAINT; Schema: timing_pattern; Owner: dbhasura
--

ALTER TABLE ONLY timing_pattern.timing_place
    ADD CONSTRAINT timing_place_pkey PRIMARY KEY (timing_place_id);

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: infrastructure_network; Owner: dbhasura
--

ALTER DEFAULT PRIVILEGES FOR ROLE dbhasura IN SCHEMA infrastructure_network GRANT SELECT ON TABLES  TO dbimporter;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: internal_service_pattern; Owner: dbhasura
--

ALTER DEFAULT PRIVILEGES FOR ROLE dbhasura IN SCHEMA internal_service_pattern GRANT SELECT ON TABLES  TO dbimporter;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: internal_utils; Owner: dbhasura
--

ALTER DEFAULT PRIVILEGES FOR ROLE dbhasura IN SCHEMA internal_utils GRANT SELECT ON TABLES  TO dbimporter;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: journey_pattern; Owner: dbhasura
--

ALTER DEFAULT PRIVILEGES FOR ROLE dbhasura IN SCHEMA journey_pattern GRANT SELECT ON TABLES  TO dbimporter;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: reusable_components; Owner: dbhasura
--

ALTER DEFAULT PRIVILEGES FOR ROLE dbhasura IN SCHEMA reusable_components GRANT SELECT ON TABLES  TO dbimporter;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: route; Owner: dbhasura
--

ALTER DEFAULT PRIVILEGES FOR ROLE dbhasura IN SCHEMA route GRANT SELECT ON TABLES  TO dbimporter;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: service_pattern; Owner: dbhasura
--

ALTER DEFAULT PRIVILEGES FOR ROLE dbhasura IN SCHEMA service_pattern GRANT SELECT ON TABLES  TO dbimporter;

--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;

--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;

--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;

--
-- Name: postgis_tiger_geocoder; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder WITH SCHEMA tiger;

--
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;

--
-- Name: hdb_cron_event_invocation_logs hdb_cron_event_invocation_logs_event_id_fkey; Type: FK CONSTRAINT; Schema: hdb_catalog; Owner: dbhasura
--

ALTER TABLE ONLY hdb_catalog.hdb_cron_event_invocation_logs
    ADD CONSTRAINT hdb_cron_event_invocation_logs_event_id_fkey FOREIGN KEY (event_id) REFERENCES hdb_catalog.hdb_cron_events(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- Name: hdb_scheduled_event_invocation_logs hdb_scheduled_event_invocation_logs_event_id_fkey; Type: FK CONSTRAINT; Schema: hdb_catalog; Owner: dbhasura
--

ALTER TABLE ONLY hdb_catalog.hdb_scheduled_event_invocation_logs
    ADD CONSTRAINT hdb_scheduled_event_invocation_logs_event_id_fkey FOREIGN KEY (event_id) REFERENCES hdb_catalog.hdb_scheduled_events(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- Name: infrastructure_link infrastructure_link_direction_fkey; Type: FK CONSTRAINT; Schema: infrastructure_network; Owner: dbhasura
--

ALTER TABLE ONLY infrastructure_network.infrastructure_link
    ADD CONSTRAINT infrastructure_link_direction_fkey FOREIGN KEY (direction) REFERENCES infrastructure_network.direction(value);

--
-- Name: infrastructure_link infrastructure_link_external_link_source_fkey; Type: FK CONSTRAINT; Schema: infrastructure_network; Owner: dbhasura
--

ALTER TABLE ONLY infrastructure_network.infrastructure_link
    ADD CONSTRAINT infrastructure_link_external_link_source_fkey FOREIGN KEY (external_link_source) REFERENCES infrastructure_network.external_source(value);

--
-- Name: vehicle_submode_on_infrastructure_link vehicle_submode_on_infrastructure_link_infrastructure_link_id_f; Type: FK CONSTRAINT; Schema: infrastructure_network; Owner: dbhasura
--

ALTER TABLE ONLY infrastructure_network.vehicle_submode_on_infrastructure_link
    ADD CONSTRAINT vehicle_submode_on_infrastructure_link_infrastructure_link_id_f FOREIGN KEY (infrastructure_link_id) REFERENCES infrastructure_network.infrastructure_link(infrastructure_link_id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- Name: vehicle_submode_on_infrastructure_link vehicle_submode_on_infrastructure_link_vehicle_submode_fkey; Type: FK CONSTRAINT; Schema: infrastructure_network; Owner: dbhasura
--

ALTER TABLE ONLY infrastructure_network.vehicle_submode_on_infrastructure_link
    ADD CONSTRAINT vehicle_submode_on_infrastructure_link_vehicle_submode_fkey FOREIGN KEY (vehicle_submode) REFERENCES reusable_components.vehicle_submode(vehicle_submode);

--
-- Name: journey_pattern journey_pattern_on_route_id_fkey; Type: FK CONSTRAINT; Schema: journey_pattern; Owner: dbhasura
--

ALTER TABLE ONLY journey_pattern.journey_pattern
    ADD CONSTRAINT journey_pattern_on_route_id_fkey FOREIGN KEY (on_route_id) REFERENCES route.route(route_id) ON DELETE CASCADE;

--
-- Name: scheduled_stop_point_in_journey_pattern scheduled_stop_point_in_journe__scheduled_stop_point_label_fkey; Type: FK CONSTRAINT; Schema: journey_pattern; Owner: dbhasura
--

ALTER TABLE ONLY journey_pattern.scheduled_stop_point_in_journey_pattern
    ADD CONSTRAINT scheduled_stop_point_in_journe__scheduled_stop_point_label_fkey FOREIGN KEY (scheduled_stop_point_label) REFERENCES service_pattern.scheduled_stop_point_invariant(label) ON DELETE CASCADE;

--
-- Name: scheduled_stop_point_in_journey_pattern scheduled_stop_point_in_journey_pattern_journey_pattern_id_fkey; Type: FK CONSTRAINT; Schema: journey_pattern; Owner: dbhasura
--

ALTER TABLE ONLY journey_pattern.scheduled_stop_point_in_journey_pattern
    ADD CONSTRAINT scheduled_stop_point_in_journey_pattern_journey_pattern_id_fkey FOREIGN KEY (journey_pattern_id) REFERENCES journey_pattern.journey_pattern(journey_pattern_id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- Name: vehicle_submode vehicle_submode_belonging_to_vehicle_mode_fkey; Type: FK CONSTRAINT; Schema: reusable_components; Owner: dbhasura
--

ALTER TABLE ONLY reusable_components.vehicle_submode
    ADD CONSTRAINT vehicle_submode_belonging_to_vehicle_mode_fkey FOREIGN KEY (belonging_to_vehicle_mode) REFERENCES reusable_components.vehicle_mode(vehicle_mode);

--
-- Name: direction direction_the_opposite_of_direction_fkey; Type: FK CONSTRAINT; Schema: route; Owner: dbhasura
--

ALTER TABLE ONLY route.direction
    ADD CONSTRAINT direction_the_opposite_of_direction_fkey FOREIGN KEY (the_opposite_of_direction) REFERENCES route.direction(direction);

--
-- Name: infrastructure_link_along_route infrastructure_link_along_route_infrastructure_link_id_fkey; Type: FK CONSTRAINT; Schema: route; Owner: dbhasura
--

ALTER TABLE ONLY route.infrastructure_link_along_route
    ADD CONSTRAINT infrastructure_link_along_route_infrastructure_link_id_fkey FOREIGN KEY (infrastructure_link_id) REFERENCES infrastructure_network.infrastructure_link(infrastructure_link_id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- Name: infrastructure_link_along_route infrastructure_link_along_route_route_id_fkey; Type: FK CONSTRAINT; Schema: route; Owner: dbhasura
--

ALTER TABLE ONLY route.infrastructure_link_along_route
    ADD CONSTRAINT infrastructure_link_along_route_route_id_fkey FOREIGN KEY (route_id) REFERENCES route.route(route_id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- Name: line line_primary_vehicle_mode_fkey; Type: FK CONSTRAINT; Schema: route; Owner: dbhasura
--

ALTER TABLE ONLY route.line
    ADD CONSTRAINT line_primary_vehicle_mode_fkey FOREIGN KEY (primary_vehicle_mode) REFERENCES reusable_components.vehicle_mode(vehicle_mode);

--
-- Name: line line_type_of_line_fkey; Type: FK CONSTRAINT; Schema: route; Owner: dbhasura
--

ALTER TABLE ONLY route.line
    ADD CONSTRAINT line_type_of_line_fkey FOREIGN KEY (type_of_line) REFERENCES route.type_of_line(type_of_line);

--
-- Name: route route_direction_fkey; Type: FK CONSTRAINT; Schema: route; Owner: dbhasura
--

ALTER TABLE ONLY route.route
    ADD CONSTRAINT route_direction_fkey FOREIGN KEY (direction) REFERENCES route.direction(direction);

--
-- Name: route route_on_line_id_fkey; Type: FK CONSTRAINT; Schema: route; Owner: dbhasura
--

ALTER TABLE ONLY route.route
    ADD CONSTRAINT route_on_line_id_fkey FOREIGN KEY (on_line_id) REFERENCES route.line(line_id);

--
-- Name: type_of_line type_of_line_belonging_to_vehicle_mode_fkey; Type: FK CONSTRAINT; Schema: route; Owner: dbhasura
--

ALTER TABLE ONLY route.type_of_line
    ADD CONSTRAINT type_of_line_belonging_to_vehicle_mode_fkey FOREIGN KEY (belonging_to_vehicle_mode) REFERENCES reusable_components.vehicle_mode(vehicle_mode);

--
-- Name: scheduled_stop_point scheduled_stop_point_direction_fkey; Type: FK CONSTRAINT; Schema: service_pattern; Owner: dbhasura
--

ALTER TABLE ONLY service_pattern.scheduled_stop_point
    ADD CONSTRAINT scheduled_stop_point_direction_fkey FOREIGN KEY (direction) REFERENCES infrastructure_network.direction(value);

--
-- Name: scheduled_stop_point scheduled_stop_point_located_on_infrastructure_link_id_fkey; Type: FK CONSTRAINT; Schema: service_pattern; Owner: dbhasura
--

ALTER TABLE ONLY service_pattern.scheduled_stop_point
    ADD CONSTRAINT scheduled_stop_point_located_on_infrastructure_link_id_fkey FOREIGN KEY (located_on_infrastructure_link_id) REFERENCES infrastructure_network.infrastructure_link(infrastructure_link_id);

--
-- Name: scheduled_stop_point scheduled_stop_point_scheduled_stop_point_invariant_label_fkey; Type: FK CONSTRAINT; Schema: service_pattern; Owner: dbhasura
--

ALTER TABLE ONLY service_pattern.scheduled_stop_point
    ADD CONSTRAINT scheduled_stop_point_scheduled_stop_point_invariant_label_fkey FOREIGN KEY (label) REFERENCES service_pattern.scheduled_stop_point_invariant(label);

--
-- Name: scheduled_stop_point scheduled_stop_point_timing_place_id_fkey; Type: FK CONSTRAINT; Schema: service_pattern; Owner: dbhasura
--

ALTER TABLE ONLY service_pattern.scheduled_stop_point
    ADD CONSTRAINT scheduled_stop_point_timing_place_id_fkey FOREIGN KEY (timing_place_id) REFERENCES timing_pattern.timing_place(timing_place_id);

--
-- Name: vehicle_mode_on_scheduled_stop_point scheduled_stop_point_serviced_by_vehicle_mode_vehicle_mode_fkey; Type: FK CONSTRAINT; Schema: service_pattern; Owner: dbhasura
--

ALTER TABLE ONLY service_pattern.vehicle_mode_on_scheduled_stop_point
    ADD CONSTRAINT scheduled_stop_point_serviced_by_vehicle_mode_vehicle_mode_fkey FOREIGN KEY (vehicle_mode) REFERENCES reusable_components.vehicle_mode(vehicle_mode);

--
-- Name: vehicle_mode_on_scheduled_stop_point vehicle_mode_on_scheduled_stop_point_scheduled_stop_point_id_fk; Type: FK CONSTRAINT; Schema: service_pattern; Owner: dbhasura
--

ALTER TABLE ONLY service_pattern.vehicle_mode_on_scheduled_stop_point
    ADD CONSTRAINT vehicle_mode_on_scheduled_stop_point_scheduled_stop_point_id_fk FOREIGN KEY (scheduled_stop_point_id) REFERENCES service_pattern.scheduled_stop_point(scheduled_stop_point_id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- Name: gen_hasura_uuid(); Type: FUNCTION; Schema: hdb_catalog; Owner: dbhasura
--

CREATE FUNCTION hdb_catalog.gen_hasura_uuid() RETURNS uuid
    LANGUAGE sql
    AS $$select gen_random_uuid()$$;


ALTER FUNCTION hdb_catalog.gen_hasura_uuid() OWNER TO dbhasura;

--
-- Name: check_infrastructure_link_route_link_direction(); Type: FUNCTION; Schema: infrastructure_network; Owner: dbhasura
--

CREATE FUNCTION infrastructure_network.check_infrastructure_link_route_link_direction() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS(
    SELECT 1
    FROM route.infrastructure_link_along_route
           JOIN infrastructure_network.infrastructure_link
                ON infrastructure_network.infrastructure_link.infrastructure_link_id =
                   route.infrastructure_link_along_route.infrastructure_link_id
    WHERE route.infrastructure_link_along_route.infrastructure_link_id = NEW.infrastructure_link_id
      AND (
      -- NB: NEW.direction = 'bidirectional' allows both traversal directions
        (route.infrastructure_link_along_route.is_traversal_forwards = TRUE AND NEW.direction = 'backward') OR
        (route.infrastructure_link_along_route.is_traversal_forwards = FALSE AND NEW.direction = 'forward')
      )
    )
  THEN
    RAISE EXCEPTION 'route link direction must be compatible with infrastructure link direction';
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION infrastructure_network.check_infrastructure_link_route_link_direction() OWNER TO dbhasura;

--
-- Name: check_infrastructure_link_scheduled_stop_points_direction_trigg(); Type: FUNCTION; Schema: infrastructure_network; Owner: dbhasura
--

CREATE FUNCTION infrastructure_network.check_infrastructure_link_scheduled_stop_points_direction_trigg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS(
    SELECT 1
    FROM service_pattern.scheduled_stop_point
    JOIN infrastructure_network.infrastructure_link
      ON infrastructure_network.infrastructure_link.infrastructure_link_id =
         service_pattern.scheduled_stop_point.located_on_infrastructure_link_id
    WHERE service_pattern.scheduled_stop_point.located_on_infrastructure_link_id = NEW.infrastructure_link_id
    AND (
      (service_pattern.scheduled_stop_point.direction = 'forward' AND NEW.direction = 'backward') OR
      (service_pattern.scheduled_stop_point.direction = 'backward' AND NEW.direction = 'forward') OR
      (service_pattern.scheduled_stop_point.direction = 'bidirectional' AND NEW.direction != 'bidirectional')
    )
  )
  THEN
    RAISE EXCEPTION 'infrastructure link direction must be compatible with the directions of the stop points residing on it';
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION infrastructure_network.check_infrastructure_link_scheduled_stop_points_direction_trigg() OWNER TO dbhasura;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: find_point_direction_on_link(public.geography, uuid, double precision); Type: FUNCTION; Schema: infrastructure_network; Owner: dbhasura
--

CREATE FUNCTION infrastructure_network.find_point_direction_on_link(point_of_interest public.geography, infrastructure_link_uuid uuid, point_max_distance_in_meters double precision DEFAULT 50.0) RETURNS SETOF infrastructure_network.direction
    LANGUAGE sql STABLE STRICT PARALLEL SAFE
    AS $$
SELECT direction.*
FROM (
    SELECT shape
    FROM infrastructure_network.infrastructure_link
    WHERE infrastructure_link_id = infrastructure_link_uuid
) link
CROSS JOIN LATERAL (
    SELECT
        ST_Transform(ST_Force2D(point_of_interest::geometry), srid) AS point_geom,
        ST_Transform(ST_Force2D(link.shape::geometry), srid) AS link_geom
    FROM (
        SELECT internal_utils.determine_srid(link.shape, point_of_interest) AS srid
    ) best
) geom_2d
CROSS JOIN LATERAL (
    SELECT
        ST_Buffer(link_geom, capped_radius, 'side=left' ) AS lhs_side_buf_geom,
        ST_Buffer(link_geom, capped_radius, 'side=right') AS rhs_side_buf_geom
    FROM (
        -- Buffer radius is capped by link length in order to have sensible side buffer areas.
        SELECT least(point_max_distance_in_meters, floor(ST_Length(link_geom))) AS capped_radius
    ) buf_radius
) side_buf
CROSS JOIN LATERAL (
    SELECT
        CASE
            WHEN in_left = false AND in_right = true THEN 'forward'
            WHEN in_left = true AND in_right = false THEN 'backward'
            ELSE null
        END AS value
    FROM (
        SELECT
            ST_Contains(lhs_side_buf_geom, point_geom) AS in_left,
            ST_Contains(rhs_side_buf_geom, point_geom) AS in_right
    ) direction_test
) calculated_direction
INNER JOIN infrastructure_network.direction direction ON direction.value = calculated_direction.value;
$$;


ALTER FUNCTION infrastructure_network.find_point_direction_on_link(point_of_interest public.geography, infrastructure_link_uuid uuid, point_max_distance_in_meters double precision) OWNER TO dbhasura;

--
-- Name: resolve_point_to_closest_link(public.geography); Type: FUNCTION; Schema: infrastructure_network; Owner: dbhasura
--

CREATE FUNCTION infrastructure_network.resolve_point_to_closest_link(geog public.geography) RETURNS SETOF infrastructure_network.infrastructure_link
    LANGUAGE sql STABLE STRICT PARALLEL SAFE
    AS $$
SELECT link.*
FROM (
    SELECT geog
) point_of_interest
CROSS JOIN LATERAL (
    SELECT
        link.infrastructure_link_id,
        point_of_interest.geog <-> link.shape AS distance
    FROM infrastructure_network.infrastructure_link link
    WHERE ST_DWithin(point_of_interest.geog, link.shape, 100) -- link filtering radius set to 100 m
    ORDER BY distance
    LIMIT 1
) closest_link_result
INNER JOIN infrastructure_network.infrastructure_link link ON link.infrastructure_link_id = closest_link_result.infrastructure_link_id;
$$;


ALTER FUNCTION infrastructure_network.resolve_point_to_closest_link(geog public.geography) OWNER TO dbhasura;

--
-- Name: insert_scheduled_stop_point_with_vehicle_mode(uuid, public.geography, uuid, text, text, date, date, integer, text); Type: FUNCTION; Schema: internal_service_pattern; Owner: dbhasura
--

CREATE FUNCTION internal_service_pattern.insert_scheduled_stop_point_with_vehicle_mode(scheduled_stop_point_id uuid, measured_location public.geography, located_on_infrastructure_link_id uuid, direction text, label text, validity_start date, validity_end date, priority integer, supported_vehicle_mode text) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO service_pattern.scheduled_stop_point (scheduled_stop_point_id,
                                                             measured_location,
                                                             located_on_infrastructure_link_id,
                                                             direction,
                                                             label,
                                                             validity_start,
                                                             validity_end,
                                                             priority)
  VALUES (scheduled_stop_point_id,
          measured_location,
          located_on_infrastructure_link_id,
          direction,
          label,
          validity_start,
          validity_end,
          priority);

  INSERT INTO service_pattern.vehicle_mode_on_scheduled_stop_point(scheduled_stop_point_id,
                                                                   vehicle_mode)
  VALUES (scheduled_stop_point_id,
          supported_vehicle_mode);
END;
$$;


ALTER FUNCTION internal_service_pattern.insert_scheduled_stop_point_with_vehicle_mode(scheduled_stop_point_id uuid, measured_location public.geography, located_on_infrastructure_link_id uuid, direction text, label text, validity_start date, validity_end date, priority integer, supported_vehicle_mode text) OWNER TO dbhasura;

--
-- Name: const_priority_draft(); Type: FUNCTION; Schema: internal_utils; Owner: dbhasura
--

CREATE FUNCTION internal_utils.const_priority_draft() RETURNS integer
    LANGUAGE sql IMMUTABLE PARALLEL SAFE
    AS $$SELECT 30$$;


ALTER FUNCTION internal_utils.const_priority_draft() OWNER TO dbhasura;

--
-- Name: date_closed_upper(daterange); Type: FUNCTION; Schema: internal_utils; Owner: dbhasura
--

CREATE FUNCTION internal_utils.date_closed_upper(range daterange) RETURNS date
    LANGUAGE sql IMMUTABLE PARALLEL SAFE
    AS $$
SELECT internal_utils.prev_day(upper(range));
$$;


ALTER FUNCTION internal_utils.date_closed_upper(range daterange) OWNER TO dbhasura;

--
-- Name: daterange_closed_upper(date, date); Type: FUNCTION; Schema: internal_utils; Owner: dbhasura
--

CREATE FUNCTION internal_utils.daterange_closed_upper(lower_bound date, closed_upper_bound date) RETURNS daterange
    LANGUAGE sql IMMUTABLE PARALLEL SAFE
    AS $$
SELECT daterange(lower_bound, internal_utils.next_day(closed_upper_bound));
$$;


ALTER FUNCTION internal_utils.daterange_closed_upper(lower_bound date, closed_upper_bound date) OWNER TO dbhasura;

--
-- Name: determine_srid(public.geography); Type: FUNCTION; Schema: internal_utils; Owner: dbhasura
--

CREATE FUNCTION internal_utils.determine_srid(geog public.geography) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
    AS $$
  SELECT _ST_BestSRID(geog)
$$;


ALTER FUNCTION internal_utils.determine_srid(geog public.geography) OWNER TO dbhasura;

--
-- Name: determine_srid(public.geography, public.geography); Type: FUNCTION; Schema: internal_utils; Owner: dbhasura
--

CREATE FUNCTION internal_utils.determine_srid(geog1 public.geography, geog2 public.geography) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
    AS $$
  SELECT _ST_BestSRID(geog1, geog2)
$$;


ALTER FUNCTION internal_utils.determine_srid(geog1 public.geography, geog2 public.geography) OWNER TO dbhasura;

--
-- Name: next_day(date); Type: FUNCTION; Schema: internal_utils; Owner: dbhasura
--

CREATE FUNCTION internal_utils.next_day(bound date) RETURNS date
    LANGUAGE sql IMMUTABLE PARALLEL SAFE
    AS $$
SELECT CASE WHEN bound IS NULL THEN NULL::date ELSE (bound + INTERVAL '1 day')::date END;
$$;


ALTER FUNCTION internal_utils.next_day(bound date) OWNER TO dbhasura;

--
-- Name: prev_day(date); Type: FUNCTION; Schema: internal_utils; Owner: dbhasura
--

CREATE FUNCTION internal_utils.prev_day(bound date) RETURNS date
    LANGUAGE sql IMMUTABLE PARALLEL SAFE
    AS $$
SELECT CASE WHEN bound IS NULL THEN NULL::date ELSE (bound - INTERVAL '1 day')::date END;
$$;


ALTER FUNCTION internal_utils.prev_day(bound date) OWNER TO dbhasura;

--
-- Name: prevent_update(); Type: FUNCTION; Schema: internal_utils; Owner: dbhasura
--

CREATE FUNCTION internal_utils.prevent_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  RAISE EXCEPTION 'update of table not allowed';
END;
$$;


ALTER FUNCTION internal_utils.prevent_update() OWNER TO dbhasura;

--
-- Name: st_closestpoint(public.geography, public.geography); Type: FUNCTION; Schema: internal_utils; Owner: dbhasura
--

CREATE FUNCTION internal_utils.st_closestpoint(a_linestring public.geography, a_point public.geography) RETURNS public.geography
    LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
    AS $$
WITH local_srid AS (
  SELECT internal_utils.determine_SRID(a_linestring, a_point) AS srid
)
SELECT
  ST_Transform(
    ST_ClosestPoint(
      ST_Transform(a_linestring::geometry, srid),
      ST_Transform(a_point::geometry, srid)
    ),
    ST_SRID(a_linestring::geometry)
  )::geography
FROM
  local_srid
$$;


ALTER FUNCTION internal_utils.st_closestpoint(a_linestring public.geography, a_point public.geography) OWNER TO dbhasura;

--
-- Name: st_lineinterpolatepoint(public.geography, double precision); Type: FUNCTION; Schema: internal_utils; Owner: dbhasura
--

CREATE FUNCTION internal_utils.st_lineinterpolatepoint(a_linestring public.geography, a_fraction double precision) RETURNS public.geography
    LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
    AS $$
  WITH local_srid AS (
    SELECT internal_utils.determine_SRID(a_linestring) AS srid
  )
  SELECT
    ST_Transform(
      ST_LineInterpolatePoint(
        ST_Transform(a_linestring::geometry, srid),
        a_fraction
      ),
      ST_SRID(a_linestring::geometry)
    )::geography
  FROM
    local_srid
$$;


ALTER FUNCTION internal_utils.st_lineinterpolatepoint(a_linestring public.geography, a_fraction double precision) OWNER TO dbhasura;

--
-- Name: st_linelocatepoint(public.geography, public.geography); Type: FUNCTION; Schema: internal_utils; Owner: dbhasura
--

CREATE FUNCTION internal_utils.st_linelocatepoint(a_linestring public.geography, a_point public.geography) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
    AS $$
  WITH local_srid AS (
    SELECT internal_utils.determine_SRID(a_linestring, a_point) AS srid
  )
  SELECT
    ST_LineLocatePoint(
      ST_Transform(a_linestring::geometry, srid),
      ST_Transform(a_point::geometry, srid)
    )
  FROM
    local_srid
$$;


ALTER FUNCTION internal_utils.st_linelocatepoint(a_linestring public.geography, a_point public.geography) OWNER TO dbhasura;

--
-- Name: check_infra_link_stop_refs_with_new_scheduled_stop_point(uuid, uuid, public.geography, text, text, date, date, integer); Type: FUNCTION; Schema: journey_pattern; Owner: dbhasura
--

CREATE FUNCTION journey_pattern.check_infra_link_stop_refs_with_new_scheduled_stop_point(replace_scheduled_stop_point_id uuid, new_located_on_infrastructure_link_id uuid, new_measured_location public.geography, new_direction text, new_label text, new_validity_start date, new_validity_end date, new_priority integer) RETURNS SETOF journey_pattern.journey_pattern
    LANGUAGE sql STABLE PARALLEL SAFE
    AS $$
WITH filter_route_ids AS (
  SELECT array_agg(DISTINCT r.route_id) AS arr
  FROM route.route r
         LEFT JOIN journey_pattern.journey_pattern jp ON jp.on_route_id = r.route_id
         LEFT JOIN journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
                   ON sspijp.journey_pattern_id = jp.journey_pattern_id
         LEFT JOIN service_pattern.scheduled_stop_point ssp
                   ON ssp.label = sspijp.scheduled_stop_point_label
       -- 1. the scheduled stop point instance to be inserted (defined by the new_... arguments) or
  WHERE ((sspijp.scheduled_stop_point_label = new_label AND
          internal_utils.daterange_closed_upper(r.validity_start, r.validity_end) &&
          internal_utils.daterange_closed_upper(new_validity_start, new_validity_end))
    -- 2. the scheduled stop point instance to be replaced (identified by the replace_scheduled_stop_point_id argument)
    OR (ssp.scheduled_stop_point_id = replace_scheduled_stop_point_id AND
        internal_utils.daterange_closed_upper(r.validity_start, r.validity_end) &&
        internal_utils.daterange_closed_upper(ssp.validity_start, ssp.validity_end)))
)
SELECT *
FROM journey_pattern.get_broken_route_journey_patterns(
  (SELECT arr FROM filter_route_ids),
  replace_scheduled_stop_point_id,
  new_located_on_infrastructure_link_id,
  new_measured_location,
  new_direction,
  new_label,
  new_validity_start,
  new_validity_end,
  new_priority
  );
$$;


ALTER FUNCTION journey_pattern.check_infra_link_stop_refs_with_new_scheduled_stop_point(replace_scheduled_stop_point_id uuid, new_located_on_infrastructure_link_id uuid, new_measured_location public.geography, new_direction text, new_label text, new_validity_start date, new_validity_end date, new_priority integer) OWNER TO dbhasura;

--
-- Name: create_verify_infra_link_stop_refs_queue_temp_table(); Type: FUNCTION; Schema: journey_pattern; Owner: dbhasura
--

CREATE FUNCTION journey_pattern.create_verify_infra_link_stop_refs_queue_temp_table() RETURNS void
    LANGUAGE sql PARALLEL SAFE
    AS $$
  CREATE TEMP TABLE IF NOT EXISTS updated_route
  (
    route_id UUID UNIQUE
  )
    ON COMMIT DELETE ROWS;
  $$;


ALTER FUNCTION journey_pattern.create_verify_infra_link_stop_refs_queue_temp_table() OWNER TO dbhasura;

--
-- Name: get_broken_route_check_filters(uuid[]); Type: FUNCTION; Schema: journey_pattern; Owner: dbhasura
--

CREATE FUNCTION journey_pattern.get_broken_route_check_filters(filter_route_ids uuid[]) RETURNS TABLE(labels text[], validity_start date, validity_end date)
    LANGUAGE sql STABLE PARALLEL SAFE
    AS $$
WITH RECURSIVE
  route_param AS (
    SELECT label,
           internal_utils.daterange_closed_upper(r.validity_start, r.validity_end) AS validity_range,
           row_number() OVER (ORDER BY r.validity_start)                           AS ord
    FROM route.route r
    WHERE r.route_id = ANY (filter_route_ids)
  ),
  -- Merge the route ranges to be checked into one. In common use cases, there should not be any (significant)
  -- gaps between the ranges, but with future versions of postgresql it will be possible and might be good to change
  -- this to use tsmultirange instead of merging the ranges.
  merged_route_range AS (
    SELECT validity_range, ord
    FROM route_param
    WHERE ord = 1
    UNION ALL
    SELECT range_merge(prev.validity_range, cur.validity_range), cur.ord
    FROM merged_route_range prev
           JOIN route_param cur ON cur.ord = prev.ord + 1
  )
  -- gather the array of route labels to check and the merged route validity range
SELECT (SELECT array_agg(DISTINCT label) FROM route_param) AS labels,
       lower(validity_range)                               AS validity_start,
       -- since the upper bound was extended by the internal_utils.daterange_closed_upper function above, we need
       -- to subtract the extended day here again
       internal_utils.date_closed_upper(validity_range) AS validity_end
FROM merged_route_range
WHERE ord = (SELECT max(ord) FROM merged_route_range);
$$;


ALTER FUNCTION journey_pattern.get_broken_route_check_filters(filter_route_ids uuid[]) OWNER TO dbhasura;

--
-- Name: get_broken_route_journey_patterns(uuid[], uuid, uuid, public.geography, text, text, date, date, integer); Type: FUNCTION; Schema: journey_pattern; Owner: dbhasura
--

CREATE FUNCTION journey_pattern.get_broken_route_journey_patterns(filter_route_ids uuid[], replace_scheduled_stop_point_id uuid DEFAULT NULL::uuid, new_located_on_infrastructure_link_id uuid DEFAULT NULL::uuid, new_measured_location public.geography DEFAULT NULL::public.geography, new_direction text DEFAULT NULL::text, new_label text DEFAULT NULL::text, new_validity_start date DEFAULT NULL::date, new_validity_end date DEFAULT NULL::date, new_priority integer DEFAULT NULL::integer) RETURNS SETOF journey_pattern.journey_pattern
    LANGUAGE sql STABLE PARALLEL SAFE
    AS $$
WITH RECURSIVE
  new_ssp_param AS (
    SELECT CASE WHEN new_located_on_infrastructure_link_id IS NOT NULL THEN gen_random_uuid() END
             AS new_scheduled_stop_point_id
  ),
  filter_route AS (
    SELECT labels, validity_start, validity_end
    FROM journey_pattern.get_broken_route_check_filters(filter_route_ids)
  ),
  -- fetch the route entities with their prioritized validity times
  prioritized_route AS (
    SELECT r.route_id,
           r.label,
           r.direction,
           r.priority,
           priority_validity_spans.validity_start,
           priority_validity_spans.validity_end
    FROM route.route r
           JOIN journey_pattern.maximum_priority_validity_spans(
      'route',
      (SELECT labels FROM filter_route),
      (SELECT validity_start FROM filter_route),
      (SELECT validity_end FROM filter_route),
      internal_utils.const_priority_draft()
      ) priority_validity_spans
                ON priority_validity_spans.id = r.route_id
  ),
  ssp_with_new AS (
    SELECT *
    FROM service_pattern.get_scheduled_stop_points_with_new(
      replace_scheduled_stop_point_id,
      (SELECT new_scheduled_stop_point_id FROM new_ssp_param),
      new_located_on_infrastructure_link_id,
      new_measured_location,
      new_direction,
      new_label,
      new_validity_start,
      new_validity_end,
      new_priority
      )
  ),
  -- fetch the stop point entities with their prioritized validity times
  prioritized_ssp_with_new AS (
    SELECT ssp.scheduled_stop_point_id,
           ssp.located_on_infrastructure_link_id,
           ssp.measured_location,
           ssp.relative_distance_from_infrastructure_link_start,
           ssp.direction,
           ssp.label,
           ssp.priority,
           priority_validity_spans.validity_start,
           priority_validity_spans.validity_end
    FROM ssp_with_new ssp
           JOIN journey_pattern.maximum_priority_validity_spans(
      'scheduled_stop_point',
      (SELECT labels FROM filter_route),
      (SELECT validity_start FROM filter_route),
      (SELECT validity_end FROM filter_route),
      internal_utils.const_priority_draft(),
      replace_scheduled_stop_point_id,
      (SELECT new_scheduled_stop_point_id FROM new_ssp_param),
      new_located_on_infrastructure_link_id,
      new_measured_location,
      new_direction,
      new_label,
      new_validity_start,
      new_validity_end,
      new_priority
      ) priority_validity_spans
                ON priority_validity_spans.id = ssp.scheduled_stop_point_id
  ),
  -- For all stops in the journey patterns, list all visits of the stop's infra link. (But only include
  -- visits happening in a direction matching the stop's allowed directions - if the direction is wrong,
  -- we cannot approach the stop point on that particular link visit. Similarly, include only those stop
  -- instances, whose validity period overlaps with the route's priority span's validity period.)
  sspijp_ilar_combos AS (
    SELECT sspijp.journey_pattern_id,
           ssp.scheduled_stop_point_id,
           sspijp.scheduled_stop_point_sequence,
           sspijp.stop_point_order,
           ssp.relative_distance_from_infrastructure_link_start,
           ilar.route_id,
           ilar.infrastructure_link_id,
           ilar.infrastructure_link_sequence,
           ilar.is_traversal_forwards
    FROM (
           SELECT r.route_id,
                  jp.journey_pattern_id,
                  sspijp.scheduled_stop_point_label,
                  sspijp.scheduled_stop_point_sequence,
                  -- Create a continuous sequence number of the scheduled_stop_point_sequence (which is not
                  -- required to be continuous, i.e. there can be gaps).
                  -- Note that the sequence number is assigned for the whole journey pattern, not for individual
                  -- route validity spans. This means that the route verification is performed for all stops in the
                  -- journey pattern at once, i.e. it is intentionally not possible to have a stop order in one route
                  -- validity span that is in conflict with the stop order in another route validity span. This is to
                  -- prevent situations in which it would be impossible to remove a higher priority route due to the
                  -- adjacent lower priority route spans having incompatible stop orders.
                  ROW_NUMBER()
                  OVER (PARTITION BY sspijp.journey_pattern_id ORDER BY sspijp.scheduled_stop_point_sequence) AS stop_point_order
           FROM route.route r
                  JOIN journey_pattern.journey_pattern jp ON jp.on_route_id = r.route_id
                  JOIN journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
                       ON sspijp.journey_pattern_id = jp.journey_pattern_id
           WHERE r.route_id = ANY (filter_route_ids)
         ) AS sspijp
           JOIN prioritized_ssp_with_new ssp
                ON ssp.label = sspijp.scheduled_stop_point_label
           JOIN prioritized_route r
                ON r.route_id = sspijp.route_id
                  -- scheduled stop point instances, whose validity period does not overlap with the
                  -- route's validity period, are filtered out here
                  AND internal_utils.daterange_closed_upper(ssp.validity_start, ssp.validity_end) &&
                      internal_utils.daterange_closed_upper(r.validity_start, r.validity_end)
           JOIN route.infrastructure_link_along_route ilar
                ON ilar.route_id = r.route_id
                  AND ilar.infrastructure_link_id = ssp.located_on_infrastructure_link_id
                  -- visits of the link in a direction not matching the stop's possible directions are
                  -- filtered out here
                  AND (ssp.direction = 'bidirectional' OR
                       ((ssp.direction = 'forward' AND ilar.is_traversal_forwards = true)
                         OR (ssp.direction = 'backward' AND ilar.is_traversal_forwards = false)))
  ),
  -- Iteratively try to traverse the journey patterns in their specified order one stop point at a time, such
  -- that all visited links appear in ascending order on each journey pattern's route.
  -- Note that this CTE will contain more rows than only the ones depicting actual traversals. To find
  -- actual possible traversals, choose the row with min(infrastructure_link_sequence) for every listed stop
  -- visit, as done below.
  traversal AS (
    SELECT *
    FROM sspijp_ilar_combos
    WHERE stop_point_order = 1
    UNION ALL
    SELECT sspijp_ilar_combos.*
    FROM traversal
           JOIN sspijp_ilar_combos ON sspijp_ilar_combos.journey_pattern_id = traversal.journey_pattern_id
         -- select the next stop
    WHERE sspijp_ilar_combos.stop_point_order = traversal.stop_point_order + 1
      -- Only allow visiting the route links in ascending route link order. If two stops are on the same
      -- link, check that they are traversed in accordance with their location on the link.
      AND (sspijp_ilar_combos.infrastructure_link_sequence > traversal.infrastructure_link_sequence
      OR (sspijp_ilar_combos.infrastructure_link_sequence = traversal.infrastructure_link_sequence
        AND ((sspijp_ilar_combos.is_traversal_forwards AND
              sspijp_ilar_combos.relative_distance_from_infrastructure_link_start >=
              traversal.relative_distance_from_infrastructure_link_start)
          OR (NOT sspijp_ilar_combos.is_traversal_forwards AND
              sspijp_ilar_combos.relative_distance_from_infrastructure_link_start <=
              traversal.relative_distance_from_infrastructure_link_start)
            )
             )
      )
  ),
  -- List all stops of the journey pattern and left-join their visits in the traversal performed above.
  infra_link_seq AS (
    SELECT route_id,
           infrastructure_link_sequence,
           -- also order by scheduled_stop_point_id to get a deterministic order between stops with the same
           -- label
           ROW_NUMBER() OVER (
             PARTITION BY journey_pattern_id
             ORDER BY
               stop_point_order,
               infrastructure_link_sequence,
               CASE
                 WHEN is_traversal_forwards THEN relative_distance_from_infrastructure_link_start
                 ELSE -relative_distance_from_infrastructure_link_start END,
               scheduled_stop_point_id)
             AS stop_point_order,
           ROW_NUMBER() OVER (
             PARTITION BY journey_pattern_id
             ORDER BY
               infrastructure_link_sequence,
               CASE
                 WHEN is_traversal_forwards THEN relative_distance_from_infrastructure_link_start
                 ELSE -relative_distance_from_infrastructure_link_start END,
               stop_point_order,
               scheduled_stop_point_id)
             AS infra_link_order
    FROM (
           SELECT t.journey_pattern_id,
                  t.stop_point_order,
                  t.infrastructure_link_sequence,
                  t.is_traversal_forwards,
                  t.relative_distance_from_infrastructure_link_start,
                  t.scheduled_stop_point_id,
                  ROW_NUMBER()
                  OVER (PARTITION BY sspijp.journey_pattern_id, ssp.scheduled_stop_point_id, r.route_id, infrastructure_link_id, stop_point_order ORDER BY infrastructure_link_sequence)
                                                          AS order_by_min,
                  r.route_id,
                  ssp.scheduled_stop_point_id IS NOT NULL AS ssp_match,
                  -- if there is no matching stop point within the validity span in question, check if there is a
                  -- matching ssp at all on the entire route
                  (ssp.scheduled_stop_point_id IS NULL
                    AND NOT EXISTS(
                      SELECT 1
                      FROM route.route full_route
                             JOIN ssp_with_new any_ssp ON any_ssp.label = sspijp.scheduled_stop_point_label
                      WHERE full_route.route_id = jp.on_route_id
                        AND internal_utils.daterange_closed_upper(full_route.validity_start, full_route.validity_end) &&
                            internal_utils.daterange_closed_upper(any_ssp.validity_start, any_ssp.validity_end)
                      )
                    )                                     AS is_ghost_ssp
           FROM prioritized_route r
                  JOIN journey_pattern.journey_pattern jp ON jp.on_route_id = r.route_id
                  JOIN journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
                       ON sspijp.journey_pattern_id = jp.journey_pattern_id
                  LEFT JOIN prioritized_ssp_with_new ssp -- left join to be able to find the ghost ssp
                            ON ssp.label = sspijp.scheduled_stop_point_label
                              AND internal_utils.daterange_closed_upper(ssp.validity_start, ssp.validity_end) &&
                                  internal_utils.daterange_closed_upper(r.validity_start, r.validity_end)
                  LEFT JOIN traversal t
                            ON t.journey_pattern_id = sspijp.journey_pattern_id
                              AND t.scheduled_stop_point_id = ssp.scheduled_stop_point_id
                              AND t.scheduled_stop_point_sequence = sspijp.scheduled_stop_point_sequence
           WHERE r.route_id = ANY (filter_route_ids)
         ) AS ordered_sspijp_ilar_combos
    WHERE (ordered_sspijp_ilar_combos.order_by_min = 1 AND ssp_match)
       OR is_ghost_ssp -- by keeping the ghost ssp lines, we will trigger an exception if any are present
  )
  -- Perform the final route integrity check:
  -- 1. In case no visit is present for any row (infrastructure_link_sequence is null), it was not possible to
  --    visit all stops in a way matching the route's link order.
  -- 2. In case the order of the stops' infra link visits is not the same as the stop order for all stops, this
  --    means that there are stops with the same ordinal number (same label), which have to be visited in a
  --    different order to cover all stops. This in turn means that the stops subsequent to these exceptions cannot
  --    be reached via all combinations of stops.
SELECT jp.*
FROM journey_pattern.journey_pattern jp
WHERE EXISTS(
        SELECT 1
        FROM infra_link_seq ils
        WHERE ils.route_id = jp.on_route_id
          AND (ils.infrastructure_link_sequence IS NULL -- this is also true for any ghost ssp occurrence
          OR ils.stop_point_order != ils.infra_link_order)
        );
$$;


ALTER FUNCTION journey_pattern.get_broken_route_journey_patterns(filter_route_ids uuid[], replace_scheduled_stop_point_id uuid, new_located_on_infrastructure_link_id uuid, new_measured_location public.geography, new_direction text, new_label text, new_validity_start date, new_validity_end date, new_priority integer) OWNER TO dbhasura;

--
-- Name: infra_link_stop_refs_already_verified(); Type: FUNCTION; Schema: journey_pattern; Owner: dbhasura
--

CREATE FUNCTION journey_pattern.infra_link_stop_refs_already_verified() RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
  infra_link_stop_refs_already_verified BOOLEAN;
BEGIN
  infra_link_stop_refs_already_verified := NULLIF(current_setting('journey_pattern_vars.infra_link_stop_refs_already_verified', TRUE), '');
  IF infra_link_stop_refs_already_verified IS TRUE THEN
    RETURN TRUE;
  ELSE
    SET LOCAL journey_pattern_vars.infra_link_stop_refs_already_verified = TRUE;
    RETURN FALSE;
  END IF;
END
$$;


ALTER FUNCTION journey_pattern.infra_link_stop_refs_already_verified() OWNER TO dbhasura;

--
-- Name: maximum_priority_validity_spans(text, text[], date, date, integer, uuid, uuid, uuid, public.geography, text, text, date, date, integer); Type: FUNCTION; Schema: journey_pattern; Owner: dbhasura
--

CREATE FUNCTION journey_pattern.maximum_priority_validity_spans(entity_type text, filter_route_labels text[], filter_validity_start date DEFAULT NULL::date, filter_validity_end date DEFAULT NULL::date, upper_priority_limit integer DEFAULT NULL::integer, replace_scheduled_stop_point_id uuid DEFAULT NULL::uuid, new_scheduled_stop_point_id uuid DEFAULT NULL::uuid, new_located_on_infrastructure_link_id uuid DEFAULT NULL::uuid, new_measured_location public.geography DEFAULT NULL::public.geography, new_direction text DEFAULT NULL::text, new_label text DEFAULT NULL::text, new_validity_start date DEFAULT NULL::date, new_validity_end date DEFAULT NULL::date, new_priority integer DEFAULT NULL::integer) RETURNS TABLE(id uuid, validity_start date, validity_end date)
    LANGUAGE sql STABLE PARALLEL SAFE
    AS $$
WITH RECURSIVE
  -- collect the entities matching the given parameters
  -- e.g.
  -- id, validity_start, validity_end, key, prio
  ----------------------------------------------
  --  1,     2020-01-01,   2025-01-01,   A,   10
  --  2,     2022-01-01,   2027-01-01,   A,   20
  entity AS (
    SELECT r.route_id AS id, r.validity_start, r.validity_end, r.label AS key1, r.direction AS key2, r.priority
    FROM route.route r
    WHERE entity_type = 'route'
      AND internal_utils.daterange_closed_upper(r.validity_start, r.validity_end) &&
          internal_utils.daterange_closed_upper(filter_validity_start, filter_validity_end)
      AND (r.label = ANY (filter_route_labels) OR filter_route_labels IS NULL)
      AND (r.priority < upper_priority_limit OR upper_priority_limit IS NULL)
    UNION ALL
    SELECT ssp.scheduled_stop_point_id AS id,
           ssp.validity_start,
           ssp.validity_end,
           ssp.label                   AS key1,
           NULL                        AS key2,
           ssp.priority
    FROM service_pattern.get_scheduled_stop_points_with_new(
           replace_scheduled_stop_point_id,
           new_scheduled_stop_point_id,
           new_located_on_infrastructure_link_id,
           new_measured_location,
           new_direction,
           new_label,
           new_validity_start,
           new_validity_end,
           new_priority) ssp
    WHERE entity_type = 'scheduled_stop_point'
      AND internal_utils.daterange_closed_upper(ssp.validity_start, ssp.validity_end) &&
          internal_utils.daterange_closed_upper(filter_validity_start, filter_validity_end)
      AND (ssp.priority < upper_priority_limit OR upper_priority_limit IS NULL)
      AND (EXISTS(
             SELECT 1
             FROM journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
                    JOIN journey_pattern.journey_pattern jp ON jp.journey_pattern_id = sspijp.journey_pattern_id
                    JOIN route.route r
                         ON r.route_id = jp.on_route_id
                           AND r.label = ANY (filter_route_labels)
             WHERE sspijp.scheduled_stop_point_label = ssp.label
             ) OR filter_route_labels IS NULL)
  ),
  -- form the list of potential validity span boundaries
  -- e.g.
  -- id, validity_start, is_start, key, prio
  ------------------------------------------
  --  1,     2020-01-01,     true,   A,   10
  --  1,     2025-01-01,    false,   A,   10
  --  2,     2022-01-01,     true,   A,   20
  --  2,     2027-01-01,    false,   A,   20
  boundary AS (
    SELECT e.validity_start, TRUE AS is_start, e.key1, e.key2, e.priority
    FROM entity e
    UNION ALL
    SELECT internal_utils.next_day(e.validity_end), FALSE AS is_start, e.key1, e.key2, e.priority
    FROM entity e
  ),
  -- Order the list both ascending and descending, because it has to be traversed both ways below. By traversing the
  -- list in both directions, we can find the validity span boundaries with highest priority without using fifos or
  -- similar.
  -- e.g.
  -- id, validity_start, is_start, key, prio, start_order, end_order
  ------------------------------------------------------------------
  --  1,     2020-01-01,     true,   A,   10,           1,         4
  --  2,     2022-01-01,     true,   A,   20,           2,         3
  --  1,     2025-01-01,    false,   A,   10,           3,         2
  --  2,     2027-01-01,    false,   A,   20,           4,         1
  ordered_boundary AS (
    SELECT *,
           -- The "validity_start IS NULL" cases have to be interpreted together with "is_start". Depending on the latter value,
           -- "validity_start IS NULL" can mean "negative inf" or "positive inf"
           row_number()
           OVER (PARTITION BY key1, key2 ORDER BY is_start AND validity_start IS NULL DESC, validity_start ASC)      AS start_order,
           row_number()
           OVER (PARTITION BY key1, key2 ORDER BY NOT is_start AND validity_start IS NULL DESC, validity_start DESC) AS end_order
    FROM boundary
  ),
  -- mark the minimum priority for each row, at which a start validity boundary is relevant (i.e. not overlapped by a higher priority),
  -- traverse the list of boundaries from start to end
  -- e.g.
  -- id, validity_start, is_start, key, prio, start_order, end_order, cur_start_priority
  --------------------------------------------------------------------------------------
  --  1,     2020-01-01,     true,   A,   10,           1,         4,                 10
  --  2,     2022-01-01,     true,   A,   20,           2,         3,                 20
  --  1,     2025-01-01,    false,   A,   10,           3,         2,                 20
  --  2,     2027-01-01,    false,   A,   20,           4,         1,                  0
  marked_min_start_priority AS (
    SELECT *, priority AS cur_start_priority
    FROM ordered_boundary
    WHERE start_order = 1
    UNION ALL
    SELECT next_boundary.*,
           CASE
             -- if the boundary marks the beginning of a validity span and the span's priority is higher than the
             -- previously marked priority, this span is valid from now on
             WHEN next_boundary.is_start AND next_boundary.priority > cur_start_priority THEN next_boundary.priority
             -- if the boundary marks the end of a validity span and the span's priority is higher or equal than the
             -- previously marked priority, the currently valid span is ending and any span starting further down may
             -- potentially be the new valid one
             WHEN NOT next_boundary.is_start AND next_boundary.priority >= cur_start_priority THEN 0
             -- otherwise, any previously discovered validity span stays valid
             ELSE cur_start_priority
             END AS cur_start_priority
    FROM marked_min_start_priority marked
           JOIN ordered_boundary next_boundary
                ON next_boundary.start_order = marked.start_order + 1 AND next_boundary.key1 = marked.key1 AND
                   (next_boundary.key2 = marked.key2 OR next_boundary.key2 IS NULL)
  ),
  -- mark the minimum priority for each row, at which an end validity boundary is relevant (i.e. not overlapped by a higher priority),
  -- traverse the list of boundaries from end to start
  -- e.g.
  -- id, validity_start, is_start, key, prio, start_order, end_order, cur_start_priority, cur_end_priority
  --------------------------------------------------------------------------------------------------------
  --  2,     2027-01-01,    false,   A,   20,           4,         1,                  0,               20
  --  1,     2025-01-01,    false,   A,   10,           3,         2,                 20,               20
  --  2,     2022-01-01,     true,   A,   20,           2,         3,                 20,                0
  --  1,     2020-01-01,     true,   A,   10,           1,         4,                 10,               10
  marked_min_start_end_priority AS (
    SELECT *, priority AS cur_end_priority
    FROM marked_min_start_priority
    WHERE end_order = 1
    UNION ALL
    SELECT next_boundary.*,
           CASE
             -- if the boundary marks the end of a validity span and the span's priority is higher than the
             -- previously marked priority, this span is valid from now on
             WHEN NOT next_boundary.is_start AND next_boundary.priority > cur_end_priority THEN next_boundary.priority
             -- if the boundary marks the start of a validity span and the span's priority is higher or equal than the
             -- previously marked priority, the currently valid span is ending and any span ending further down may
             -- potentially be the new valid one
             WHEN next_boundary.is_start AND next_boundary.priority >= cur_end_priority THEN 0
             -- otherwise, any previously discovered validity span stays valid
             ELSE cur_end_priority
             END AS cur_end_priority
    FROM marked_min_start_end_priority marked
           JOIN marked_min_start_priority next_boundary
                ON next_boundary.end_order = marked.end_order + 1 AND next_boundary.key1 = marked.key1 AND
                   (next_boundary.key2 = marked.key2 OR next_boundary.key2 IS NULL)
  ),
  -- filter only the highest priority boundaries and connect them to form validity spans (with both start and end)
  -- e.g.
  -- key, has_next, validity_start, validity_end
  ----------------------------------------------
  --   A,     true,     2020-01-01,   2022-01-01
  --   A,     true,     2022-01-01,   2027-01-01
  -----A,-----true,-----2025-01-01,--------------- (removed by WHERE clause)
  --   A,    false,     2027-01-01,         null
  reduced_boundary AS (
    SELECT key1,
           key2,
           -- The last row will have has_next = FALSE. This is needed because we cannot rely on validity_end being NULL
           -- in ONLY the last row, since NULL in timestamps depicts infinity.
           lead(TRUE, 1, FALSE) OVER entity_window AS has_next,
           validity_start,
           lead(internal_utils.prev_day(validity_start)) OVER entity_window AS validity_end
    FROM marked_min_start_end_priority
    WHERE priority >= cur_end_priority
      AND priority >= cur_start_priority
    WINDOW entity_window AS (PARTITION BY key1, key2 ORDER BY start_order)
  ),
  -- find the instances which are valid in the validity spans
  -- e.g.
  -- key, has_next, validity_start, validity_end, id, priority
  ------------------------------------------------------------
  --   A,     true,     2020-01-01,   2022-01-01,  1,       10
  --   A,     true,     2022-01-01,   2027-01-01,  1,       10
  --   A,     true,     2022-01-01,   2027-01-01,  2,       20
  -----A,----false,-----2027-01-01,---------null,--------------- (removed by WHERE clause)
  boundary_with_entities AS (
    SELECT rb.key1, rb.key2, rb.has_next, rb.validity_start, rb.validity_end, e.id, e.priority
    FROM reduced_boundary rb
           JOIN entity e ON e.key1 = rb.key1 AND (e.key2 = rb.key2 OR e.key2 IS NULL) AND
                            internal_utils.daterange_closed_upper(e.validity_start, e.validity_end) &&
                            internal_utils.daterange_closed_upper(rb.validity_start, rb.validity_end)
    WHERE rb.has_next
  )
SELECT id, validity_start, validity_end
FROM (SELECT id,
             validity_start,
             validity_end,
             priority,
             max(priority) OVER (PARTITION BY key1, key2, validity_start) AS max_priority
      FROM boundary_with_entities) bwe
WHERE priority = max_priority
$$;


ALTER FUNCTION journey_pattern.maximum_priority_validity_spans(entity_type text, filter_route_labels text[], filter_validity_start date, filter_validity_end date, upper_priority_limit integer, replace_scheduled_stop_point_id uuid, new_scheduled_stop_point_id uuid, new_located_on_infrastructure_link_id uuid, new_measured_location public.geography, new_direction text, new_label text, new_validity_start date, new_validity_end date, new_priority integer) OWNER TO dbhasura;

--
-- Name: queue_verify_infra_link_stop_refs_by_new_journey_pattern_id(); Type: FUNCTION; Schema: journey_pattern; Owner: dbhasura
--

CREATE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_journey_pattern_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- RAISE NOTICE 'journey_pattern.queue_verify_infra_link_stop_refs_by_new_journey_pattern_id()';

  PERFORM journey_pattern.create_verify_infra_link_stop_refs_queue_temp_table();

  INSERT INTO updated_route (route_id)
  SELECT r.route_id
  FROM new_table
         JOIN journey_pattern.journey_pattern jp ON jp.journey_pattern_id = new_table.journey_pattern_id
         JOIN route.route r ON r.route_id = jp.on_route_id
  ON CONFLICT DO NOTHING;

  RETURN NULL;
END;
$$;


ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_journey_pattern_id() OWNER TO dbhasura;

--
-- Name: queue_verify_infra_link_stop_refs_by_new_ssp_label(); Type: FUNCTION; Schema: journey_pattern; Owner: dbhasura
--

CREATE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_ssp_label() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- RAISE NOTICE 'journey_pattern.queue_verify_infra_link_stop_refs_by_new_ssp_label()';

  PERFORM journey_pattern.create_verify_infra_link_stop_refs_queue_temp_table();

  INSERT INTO updated_route (route_id)
  SELECT r.route_id
  FROM new_table
         JOIN route.route r ON EXISTS(
    SELECT 1
    FROM journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
           JOIN journey_pattern.journey_pattern jp ON jp.journey_pattern_id = sspijp.journey_pattern_id
    WHERE sspijp.scheduled_stop_point_label = new_table.label
      AND internal_utils.daterange_closed_upper(r.validity_start, r.validity_end) &&
          internal_utils.daterange_closed_upper(new_table.validity_start, new_table.validity_end)
      AND jp.on_route_id = r.route_id
    )
  ON CONFLICT DO NOTHING;

  RETURN NULL;
END;
$$;


ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_ssp_label() OWNER TO dbhasura;

--
-- Name: queue_verify_infra_link_stop_refs_by_old_route_id(); Type: FUNCTION; Schema: journey_pattern; Owner: dbhasura
--

CREATE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- RAISE NOTICE 'journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_id()';

  PERFORM journey_pattern.create_verify_infra_link_stop_refs_queue_temp_table();

  INSERT INTO updated_route (route_id)
  SELECT r.route_id
  FROM old_table
         JOIN route.route r ON r.route_id = old_table.route_id
  ON CONFLICT DO NOTHING;

  RETURN NULL;
END;
$$;


ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_id() OWNER TO dbhasura;

--
-- Name: queue_verify_infra_link_stop_refs_by_old_route_label(); Type: FUNCTION; Schema: journey_pattern; Owner: dbhasura
--

CREATE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_label() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- RAISE NOTICE 'journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_label()';

  PERFORM journey_pattern.create_verify_infra_link_stop_refs_queue_temp_table();

  INSERT INTO updated_route (route_id)
  SELECT route_id
  FROM old_table
  ON CONFLICT DO NOTHING;

  RETURN NULL;
END;
$$;


ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_label() OWNER TO dbhasura;

--
-- Name: queue_verify_infra_link_stop_refs_by_old_ssp_label(); Type: FUNCTION; Schema: journey_pattern; Owner: dbhasura
--

CREATE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_ssp_label() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- RAISE NOTICE 'journey_pattern.queue_verify_infra_link_stop_refs_by_old_ssp_label()';

  PERFORM journey_pattern.create_verify_infra_link_stop_refs_queue_temp_table();

  INSERT INTO updated_route (route_id)
  SELECT r.route_id
  FROM old_table
         JOIN route.route r ON EXISTS(
    SELECT 1
    FROM journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
           JOIN journey_pattern.journey_pattern jp ON jp.journey_pattern_id = sspijp.journey_pattern_id
    WHERE sspijp.scheduled_stop_point_label = old_table.label
      AND internal_utils.daterange_closed_upper(r.validity_start, r.validity_end) &&
          internal_utils.daterange_closed_upper(old_table.validity_start, old_table.validity_end)
      AND jp.on_route_id = r.route_id
    )
  ON CONFLICT DO NOTHING;

  RETURN NULL;
END;
$$;


ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_ssp_label() OWNER TO dbhasura;

--
-- Name: scheduled_stop_point_has_timing_place_if_used_as_timing_point(); Type: FUNCTION; Schema: journey_pattern; Owner: dbhasura
--

CREATE FUNCTION journey_pattern.scheduled_stop_point_has_timing_place_if_used_as_timing_point() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- RAISE NOTICE 'journey_pattern.scheduled_stop_point_has_timing_place_if_used_as_timing_point()';

  IF EXISTS(
    SELECT 1
      FROM journey_pattern.scheduled_stop_point_in_journey_pattern as sspijp
      JOIN service_pattern.scheduled_stop_point AS ssp ON sspijp.scheduled_stop_point_label = ssp.label
      WHERE ssp.timing_place_id IS NULL
        AND sspijp.is_used_as_timing_point = true
    )
  THEN
    RAISE EXCEPTION 'scheduled stop point must have a timing place attached if it is used as a timing point in a journey pattern';
  END IF;

  RETURN NULL;
END;
$$;


ALTER FUNCTION journey_pattern.scheduled_stop_point_has_timing_place_if_used_as_timing_point() OWNER TO dbhasura;

--
-- Name: truncate_scheduled_stop_point_in_journey_pattern(); Type: FUNCTION; Schema: journey_pattern; Owner: dbhasura
--

CREATE FUNCTION journey_pattern.truncate_scheduled_stop_point_in_journey_pattern() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  --RAISE NOTICE 'journey_pattern.truncate_scheduled_stop_point_in_journey_pattern()';

  IF (SELECT COUNT(*) FROM journey_pattern.scheduled_stop_point_in_journey_pattern) > 0 THEN
    RAISE WARNING 'TRUNCATING journey_pattern.scheduled_stop_point_in_journey_pattern to ensure data consistency';
    TRUNCATE journey_pattern.scheduled_stop_point_in_journey_pattern CASCADE;
  END IF;

  RETURN NULL;
END;
$$;


ALTER FUNCTION journey_pattern.truncate_scheduled_stop_point_in_journey_pattern() OWNER TO dbhasura;

--
-- Name: verify_infra_link_stop_refs(); Type: FUNCTION; Schema: journey_pattern; Owner: dbhasura
--

CREATE FUNCTION journey_pattern.verify_infra_link_stop_refs() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- RAISE NOTICE 'journey_pattern.verify_infra_link_stop_refs()';

  IF EXISTS(
    WITH filter_route_ids AS (
      SELECT array_agg(DISTINCT ur.route_id) AS arr
      FROM updated_route ur
    )
    SELECT 1
    FROM journey_pattern.get_broken_route_journey_patterns(
        (SELECT arr FROM filter_route_ids)
      )
      -- ensure there is something to be checked at all
    WHERE EXISTS(SELECT 1 FROM updated_route)
    )
  THEN
    RAISE EXCEPTION 'route''s and journey pattern''s traversal paths must match each other';
  END IF;

  RETURN NULL;
END;
$$;


ALTER FUNCTION journey_pattern.verify_infra_link_stop_refs() OWNER TO dbhasura;

--
-- Name: verify_route_journey_pattern_refs(uuid, uuid); Type: FUNCTION; Schema: journey_pattern; Owner: dbhasura
--

CREATE FUNCTION journey_pattern.verify_route_journey_pattern_refs(filter_journey_pattern_id uuid, filter_route_id uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NOT journey_pattern.check_route_journey_pattern_refs(
    filter_journey_pattern_id,
    filter_route_id
    )
  THEN
    RAISE EXCEPTION 'route''s and journey pattern''s traversal paths must match each other';
  END IF;
END;
$$;


ALTER FUNCTION journey_pattern.verify_route_journey_pattern_refs(filter_journey_pattern_id uuid, filter_route_id uuid) OWNER TO dbhasura;

--
-- Name: drop_constraints(text[]); Type: FUNCTION; Schema: public; Owner: dbhasura
--

CREATE FUNCTION public.drop_constraints(target_schemas text[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  constraint_record RECORD;
BEGIN
  FOR constraint_record IN (
    SELECT
      n.nspname as schema_name,
      t.relname as table_name,
      c.conname as constraint_name
    FROM pg_constraint c
      JOIN pg_class t on c.conrelid = t.oid
      JOIN pg_namespace n on t.relnamespace = n.oid
    WHERE
      -- c = check constraint, f = foreign key constraint, p = primary key constraint, u = unique constraint, t = constraint trigger, x = exclusion constraint
      c.contype IN ('c', 'u', 't', 'x') AND
      n.nspname = ANY(target_schemas)
  )
  LOOP
    RAISE NOTICE 'Dropping constraint: %.%.%', constraint_record.schema_name, constraint_record.table_name, constraint_record.constraint_name;
    EXECUTE 'ALTER TABLE ' || quote_ident(constraint_record.schema_name) || '.' || quote_ident(constraint_record.table_name) || ' DROP CONSTRAINT ' || quote_ident(constraint_record.constraint_name) || ';';
  END LOOP;
END;
$$;


ALTER FUNCTION public.drop_constraints(target_schemas text[]) OWNER TO dbhasura;

--
-- Name: drop_functions(text[]); Type: FUNCTION; Schema: public; Owner: dbhasura
--

CREATE FUNCTION public.drop_functions(target_schemas text[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  sql_command text;
BEGIN
  SELECT INTO sql_command
    string_agg(
      format('DROP %s %s;',
        CASE prokind
          WHEN 'f' THEN 'FUNCTION'
          WHEN 'a' THEN 'AGGREGATE'
          WHEN 'p' THEN 'PROCEDURE'
          WHEN 'w' THEN 'FUNCTION'
          ELSE NULL
        END,
        oid::regprocedure),
      E'\n')
  FROM pg_proc
  WHERE pronamespace = ANY(target_schemas::regnamespace[]);

  IF sql_command IS NOT NULL THEN
    EXECUTE sql_command;
  ELSE
    RAISE NOTICE 'No functions found';
  END IF;
END;
$$;


ALTER FUNCTION public.drop_functions(target_schemas text[]) OWNER TO dbhasura;

--
-- Name: drop_triggers(text[]); Type: FUNCTION; Schema: public; Owner: dbhasura
--

CREATE FUNCTION public.drop_triggers(target_schemas text[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  trigger_record RECORD;
BEGIN
  FOR trigger_record IN
    (
      -- CRUD triggers
      SELECT
        trigger_schema AS schema_name,
        event_object_table AS table_name,
        trigger_name
      FROM information_schema.triggers
      WHERE
        trigger_schema = ANY(target_schemas)
    UNION (
      -- TRUNCATE triggers
      SELECT
        n.nspname as schema_name,
        c.relname as table_name,
        t.tgname AS trigger_name
      FROM pg_trigger t
        JOIN pg_class c on t.tgrelid = c.oid
        JOIN pg_namespace n on c.relnamespace = n.oid
      WHERE
        t.tgtype = 32 AND -- TRUNCATE triggers only
        n.nspname = ANY(target_schemas)
    )
  )
  LOOP
    -- note: if the same trigger function is executed e.g. both on INSERT and UPDATE, there are two rows with the same trigger name
    -- This results in the DROP command being executed twice below, thus we use IF EXISTS here
    RAISE NOTICE 'Dropping trigger: %.%.%', trigger_record.schema_name, trigger_record.table_name, trigger_record.trigger_name;
    EXECUTE 'DROP TRIGGER IF EXISTS ' || quote_ident(trigger_record.trigger_name) || ' ON ' || quote_ident(trigger_record.schema_name) || '.' || quote_ident(trigger_record.table_name) || ';';
  END LOOP;
END;
$$;


ALTER FUNCTION public.drop_triggers(target_schemas text[]) OWNER TO dbhasura;

--
-- Name: check_line_routes_priorities(); Type: FUNCTION; Schema: route; Owner: dbhasura
--

CREATE FUNCTION route.check_line_routes_priorities() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS(
    SELECT 1
    FROM route.line
    JOIN route.route ON route.route.on_line_id = route.line.line_id
    WHERE route.line.line_id = NEW.line_id
    AND route.line.priority > route.route.priority
  )
  THEN
    RAISE EXCEPTION 'route priority must be >= line priority';
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION route.check_line_routes_priorities() OWNER TO dbhasura;

--
-- Name: check_line_validity_against_all_associated_routes(); Type: FUNCTION; Schema: route; Owner: dbhasura
--

CREATE FUNCTION route.check_line_validity_against_all_associated_routes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS(
    SELECT 1
    FROM route.route r
    WHERE r.on_line_id = NEW.line_id
      AND ((NEW.validity_start IS NOT NULL AND (NEW.validity_start > r.validity_start OR r.validity_start IS NULL)) OR
           (NEW.validity_end IS NOT NULL AND (NEW.validity_end < r.validity_end OR r.validity_end IS NULL)))
    )
  THEN
    RAISE EXCEPTION 'line validity period must span all its routes'' validity periods';
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION route.check_line_validity_against_all_associated_routes() OWNER TO dbhasura;

--
-- Name: check_route_line_priorities(); Type: FUNCTION; Schema: route; Owner: dbhasura
--

CREATE FUNCTION route.check_route_line_priorities() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  line_prio INT;
BEGIN
  SELECT route.line.priority
  FROM route.line
  INTO line_prio
  WHERE route.line.line_id = NEW.on_line_id;

  IF NEW.priority < line_prio
  THEN
    RAISE EXCEPTION 'route priority must be >= line priority';
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION route.check_route_line_priorities() OWNER TO dbhasura;

--
-- Name: check_route_link_infrastructure_link_direction(); Type: FUNCTION; Schema: route; Owner: dbhasura
--

CREATE FUNCTION route.check_route_link_infrastructure_link_direction() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  link_dir TEXT;
BEGIN
  SELECT infrastructure_network.infrastructure_link.direction
  FROM infrastructure_network.infrastructure_link
  INTO link_dir WHERE infrastructure_network.infrastructure_link.
  infrastructure_link_id = NEW.infrastructure_link_id;

  -- NB: link_dir = 'bidirectional' allows both traversal directions
  IF (NEW.is_traversal_forwards = TRUE AND link_dir = 'backward') OR
     (NEW.is_traversal_forwards = FALSE AND link_dir = 'forward')
  THEN
    RAISE EXCEPTION 'route link direction must be compatible with infrastructure link direction';
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION route.check_route_link_infrastructure_link_direction() OWNER TO dbhasura;

--
-- Name: check_route_validity_is_within_line_validity(); Type: FUNCTION; Schema: route; Owner: dbhasura
--

CREATE FUNCTION route.check_route_validity_is_within_line_validity() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  line_validity_start date;
  line_validity_end   date;
BEGIN
  SELECT l.validity_start, l.validity_end
  FROM route.line l
  INTO line_validity_start, line_validity_end
    WHERE l.line_id = NEW.on_line_id;

  IF (line_validity_start IS NOT NULL AND (NEW.validity_start < line_validity_start OR NEW.validity_start IS NULL)) OR
     (line_validity_end IS NOT NULL AND (NEW.validity_end > line_validity_end OR NEW.validity_end IS NULL))
  THEN
    RAISE EXCEPTION 'route validity period must lie within its line''s validity period';
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION route.check_route_validity_is_within_line_validity() OWNER TO dbhasura;

--
-- Name: check_type_of_line_vehicle_mode(); Type: FUNCTION; Schema: route; Owner: dbhasura
--

CREATE FUNCTION route.check_type_of_line_vehicle_mode() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NOT EXISTS(
    SELECT 1
    FROM route.line
           JOIN route.type_of_line
                ON route.type_of_line.type_of_line = NEW.type_of_line
    WHERE route.type_of_line.belonging_to_vehicle_mode = NEW.primary_vehicle_mode
    )
  THEN
    RAISE EXCEPTION 'type of line must match lines primary vehicle mode';
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION route.check_type_of_line_vehicle_mode() OWNER TO dbhasura;

--
-- Name: route_shape(route.route); Type: FUNCTION; Schema: route; Owner: dbhasura
--

CREATE FUNCTION route.route_shape(route_row route.route) RETURNS public.geography
    LANGUAGE sql STABLE
    AS $$
  SELECT
    ST_MakeLine(
      CASE
        WHEN ilar.is_traversal_forwards THEN il.shape::geometry
        ELSE ST_Reverse(il.shape::geometry)
      END
        ORDER BY ilar.infrastructure_link_sequence
    )::geography AS route_shape
  FROM
    route.route r
      LEFT JOIN (
      route.infrastructure_link_along_route AS ilar
        INNER JOIN infrastructure_network.infrastructure_link AS il
        ON (ilar.infrastructure_link_id = il.infrastructure_link_id)
      ) ON (route_row.route_id = ilar.route_id)
    WHERE r.route_id = route_row.route_id;
$$;


ALTER FUNCTION route.route_shape(route_row route.route) OWNER TO dbhasura;

--
-- Name: check_scheduled_stop_point_infrastructure_link_direction(); Type: FUNCTION; Schema: service_pattern; Owner: dbhasura
--

CREATE FUNCTION service_pattern.check_scheduled_stop_point_infrastructure_link_direction() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  link_dir TEXT;
BEGIN
  SELECT infrastructure_network.infrastructure_link.direction
  FROM infrastructure_network.infrastructure_link
  INTO link_dir
  WHERE infrastructure_network.infrastructure_link.infrastructure_link_id = NEW.located_on_infrastructure_link_id;

  IF (NEW.direction = 'forward' AND link_dir = 'backward') OR
     (NEW.direction = 'backward' AND link_dir = 'forward') OR
     (NEW.direction = 'bidirectional' AND link_dir != 'bidirectional')
  THEN
    RAISE EXCEPTION 'scheduled stop point direction must be compatible with infrastructure link direction';
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION service_pattern.check_scheduled_stop_point_infrastructure_link_direction() OWNER TO dbhasura;

--
-- Name: check_scheduled_stop_point_vehicle_mode_by_infra_link(); Type: FUNCTION; Schema: service_pattern; Owner: dbhasura
--

CREATE FUNCTION service_pattern.check_scheduled_stop_point_vehicle_mode_by_infra_link() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS(
    SELECT 1
    FROM reusable_components.vehicle_submode
           JOIN service_pattern.vehicle_mode_on_scheduled_stop_point
                ON service_pattern.vehicle_mode_on_scheduled_stop_point.vehicle_mode =
                   reusable_components.vehicle_submode.belonging_to_vehicle_mode
           JOIN service_pattern.scheduled_stop_point
                ON service_pattern.scheduled_stop_point.scheduled_stop_point_id =
                   service_pattern.vehicle_mode_on_scheduled_stop_point.scheduled_stop_point_id
    WHERE reusable_components.vehicle_submode.vehicle_submode = OLD.vehicle_submode
      AND service_pattern.scheduled_stop_point.located_on_infrastructure_link_id = OLD.infrastructure_link_id
    )
  THEN
    RAISE
      EXCEPTION 'cannot remove relationship between scheduled stop point vehicle mode and infrastructure link vehicle submodes';
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION service_pattern.check_scheduled_stop_point_vehicle_mode_by_infra_link() OWNER TO dbhasura;

--
-- Name: check_scheduled_stop_point_vehicle_mode_by_scheduled_stop_point(); Type: FUNCTION; Schema: service_pattern; Owner: dbhasura
--

CREATE FUNCTION service_pattern.check_scheduled_stop_point_vehicle_mode_by_scheduled_stop_point() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NOT EXISTS(
    SELECT 1
    FROM service_pattern.vehicle_mode_on_scheduled_stop_point
           JOIN service_pattern.scheduled_stop_point
                ON service_pattern.scheduled_stop_point.scheduled_stop_point_id =
                   service_pattern.vehicle_mode_on_scheduled_stop_point.scheduled_stop_point_id
           JOIN infrastructure_network.infrastructure_link
                ON infrastructure_network.infrastructure_link.infrastructure_link_id =
                   service_pattern.scheduled_stop_point.located_on_infrastructure_link_id
           JOIN infrastructure_network.vehicle_submode_on_infrastructure_link
                ON infrastructure_network.vehicle_submode_on_infrastructure_link.infrastructure_link_id =
                   infrastructure_network.infrastructure_link.infrastructure_link_id
           JOIN reusable_components.vehicle_submode ON reusable_components.vehicle_submode.vehicle_submode =
                                                       infrastructure_network.vehicle_submode_on_infrastructure_link.vehicle_submode
    WHERE service_pattern.vehicle_mode_on_scheduled_stop_point.vehicle_mode =
          reusable_components.vehicle_submode.belonging_to_vehicle_mode
      AND service_pattern.scheduled_stop_point.scheduled_stop_point_id = NEW.scheduled_stop_point_id
    )
  THEN
    RAISE EXCEPTION 'scheduled stop point vehicle mode must be compatible with allowed infrastructure link vehicle submodes';
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION service_pattern.check_scheduled_stop_point_vehicle_mode_by_scheduled_stop_point() OWNER TO dbhasura;

--
-- Name: check_scheduled_stop_point_vehicle_mode_by_vehicle_mode(); Type: FUNCTION; Schema: service_pattern; Owner: dbhasura
--

CREATE FUNCTION service_pattern.check_scheduled_stop_point_vehicle_mode_by_vehicle_mode() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS(
       SELECT 1
       FROM service_pattern.vehicle_mode_on_scheduled_stop_point
              JOIN service_pattern.scheduled_stop_point
                   ON service_pattern.scheduled_stop_point.scheduled_stop_point_id =
                      service_pattern.vehicle_mode_on_scheduled_stop_point.scheduled_stop_point_id
              JOIN infrastructure_network.infrastructure_link
                   ON infrastructure_network.infrastructure_link.infrastructure_link_id =
                      service_pattern.scheduled_stop_point.located_on_infrastructure_link_id
              JOIN infrastructure_network.vehicle_submode_on_infrastructure_link
                   ON infrastructure_network.vehicle_submode_on_infrastructure_link.infrastructure_link_id =
                      infrastructure_network.infrastructure_link.infrastructure_link_id
              JOIN reusable_components.vehicle_submode ON reusable_components.vehicle_submode.vehicle_submode =
                                                          infrastructure_network.vehicle_submode_on_infrastructure_link.vehicle_submode
       WHERE service_pattern.vehicle_mode_on_scheduled_stop_point.vehicle_mode =
             reusable_components.vehicle_submode.belonging_to_vehicle_mode
         AND service_pattern.scheduled_stop_point.scheduled_stop_point_id = OLD.scheduled_stop_point_id
       )
    !=
     EXISTS(
       SELECT 1
       FROM service_pattern.scheduled_stop_point
       WHERE service_pattern.scheduled_stop_point.scheduled_stop_point_id = OLD.scheduled_stop_point_id
       )
  THEN
    RAISE EXCEPTION 'scheduled stop point must be assigned a vehicle mode which is compatible with allowed infrastructure link vehicle submodes';
  END IF;

  RETURN OLD;
END;
$$;


ALTER FUNCTION service_pattern.check_scheduled_stop_point_vehicle_mode_by_vehicle_mode() OWNER TO dbhasura;

--
-- Name: delete_scheduled_stop_point_label(text); Type: FUNCTION; Schema: service_pattern; Owner: dbhasura
--

CREATE FUNCTION service_pattern.delete_scheduled_stop_point_label(old_label text) RETURNS void
    LANGUAGE sql
    AS $$
DELETE FROM service_pattern.scheduled_stop_point_invariant
WHERE label = old_label
  AND NOT EXISTS (SELECT 1 FROM service_pattern.scheduled_stop_point WHERE label = old_label);
$$;


ALTER FUNCTION service_pattern.delete_scheduled_stop_point_label(old_label text) OWNER TO dbhasura;

--
-- Name: find_effective_scheduled_stop_points_in_journey_pattern(uuid, date, boolean); Type: FUNCTION; Schema: service_pattern; Owner: dbhasura
--

CREATE FUNCTION service_pattern.find_effective_scheduled_stop_points_in_journey_pattern(filter_journey_pattern_id uuid, observation_date date, include_draft_stops boolean) RETURNS TABLE(journey_pattern_id uuid, scheduled_stop_point_sequence integer, is_used_as_timing_point boolean, is_loading_time_allowed boolean, is_regulated_timing_point boolean, is_via_point boolean, via_point_name_i18n jsonb, via_point_short_name_i18n jsonb, effective_scheduled_stop_point_id uuid)
    LANGUAGE sql STABLE PARALLEL SAFE
    AS $$
WITH unambiguous_sspijp AS (
  SELECT DISTINCT
    sspijp.journey_pattern_id,
    sspijp.scheduled_stop_point_sequence,
    -- Pick the stop point instance with the highest priority.
    first_value(ssp.scheduled_stop_point_id) OVER (
      PARTITION BY sspijp.scheduled_stop_point_sequence
      ORDER BY ssp.priority DESC
    ) AS effective_scheduled_stop_point_id
  FROM journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
  JOIN service_pattern.scheduled_stop_point_invariant sspi ON sspi.label = sspijp.scheduled_stop_point_label
  JOIN service_pattern.scheduled_stop_point ssp USING (label)
  WHERE sspijp.journey_pattern_id = filter_journey_pattern_id
    AND (include_draft_stops OR ssp.priority < internal_utils.const_priority_draft())
    AND internal_utils.daterange_closed_upper(ssp.validity_start, ssp.validity_end) @> observation_date
)
SELECT
  journey_pattern_id,
  scheduled_stop_point_sequence,
  is_used_as_timing_point,
  is_loading_time_allowed,
  is_regulated_timing_point,
  is_via_point,
  via_point_name_i18n,
  via_point_short_name_i18n,
  effective_scheduled_stop_point_id
FROM unambiguous_sspijp
JOIN journey_pattern.scheduled_stop_point_in_journey_pattern USING (journey_pattern_id, scheduled_stop_point_sequence)
$$;


ALTER FUNCTION service_pattern.find_effective_scheduled_stop_points_in_journey_pattern(filter_journey_pattern_id uuid, observation_date date, include_draft_stops boolean) OWNER TO dbhasura;

--
-- Name: find_scheduled_stop_point_locations_in_journey_pattern(uuid, date, boolean); Type: FUNCTION; Schema: service_pattern; Owner: dbhasura
--

CREATE FUNCTION service_pattern.find_scheduled_stop_point_locations_in_journey_pattern(filter_journey_pattern_id uuid, observation_date date, include_draft_stops boolean) RETURNS TABLE(journey_pattern_id uuid, scheduled_stop_point_sequence integer, scheduled_stop_point_id uuid, label text, measured_location public.geography, located_on_infrastructure_link_id uuid, direction text, relative_distance_from_link_start double precision, timing_place_id uuid)
    LANGUAGE sql STABLE PARALLEL SAFE
    AS $$
SELECT
  sspijp.journey_pattern_id,
  sspijp.scheduled_stop_point_sequence,
  ssp.scheduled_stop_point_id,
  ssp.label,
  ssp.measured_location,
  ssp.located_on_infrastructure_link_id,
  ssp.direction,
  internal_utils.ST_LineLocatePoint(il.shape, ssp.measured_location) AS relative_distance_from_link_start,
  ssp.timing_place_id
FROM service_pattern.find_effective_scheduled_stop_points_in_journey_pattern(
  filter_journey_pattern_id,
  observation_date,
  include_draft_stops
) sspijp
JOIN service_pattern.scheduled_stop_point ssp ON ssp.scheduled_stop_point_id = sspijp.effective_scheduled_stop_point_id
JOIN infrastructure_network.infrastructure_link il ON il.infrastructure_link_id = ssp.located_on_infrastructure_link_id
$$;


ALTER FUNCTION service_pattern.find_scheduled_stop_point_locations_in_journey_pattern(filter_journey_pattern_id uuid, observation_date date, include_draft_stops boolean) OWNER TO dbhasura;

--
-- Name: get_distances_between_stop_points_by_routes(uuid[], date); Type: FUNCTION; Schema: service_pattern; Owner: dbhasura
--

CREATE FUNCTION service_pattern.get_distances_between_stop_points_by_routes(route_ids uuid[], observation_date date) RETURNS SETOF service_pattern.distance_between_stops_calculation
    LANGUAGE sql STABLE PARALLEL SAFE
    AS $$
SELECT stop_interval_length.*
FROM (
  SELECT
    r.route_id,
    array_agg(jp.journey_pattern_id) AS journey_pattern_ids
  FROM route.route r
  JOIN journey_pattern.journey_pattern jp ON jp.on_route_id = r.route_id
  WHERE
    r.route_id = ANY(route_ids)
    AND internal_utils.daterange_closed_upper(r.validity_start, r.validity_end) @> observation_date
  GROUP BY r.route_id
) ids
JOIN LATERAL (
  SELECT *
  FROM service_pattern.get_distances_between_stop_points_in_journey_patterns(ids.journey_pattern_ids, observation_date, false)
) stop_interval_length USING (route_id)
ORDER BY journey_pattern_id ASC, stop_interval_sequence ASC
$$;


ALTER FUNCTION service_pattern.get_distances_between_stop_points_by_routes(route_ids uuid[], observation_date date) OWNER TO dbhasura;

--
-- Name: get_distances_between_stop_points_in_journey_pattern(uuid, date, boolean); Type: FUNCTION; Schema: service_pattern; Owner: dbhasura
--

CREATE FUNCTION service_pattern.get_distances_between_stop_points_in_journey_pattern(journey_pattern_id uuid, observation_date date, include_draft_stops boolean) RETURNS SETOF service_pattern.distance_between_stops_calculation
    LANGUAGE sql STABLE PARALLEL SAFE
    AS $$
SELECT *
FROM service_pattern.get_distances_between_stop_points_in_journey_patterns(ARRAY[journey_pattern_id], observation_date, include_draft_stops)
$$;


ALTER FUNCTION service_pattern.get_distances_between_stop_points_in_journey_pattern(journey_pattern_id uuid, observation_date date, include_draft_stops boolean) OWNER TO dbhasura;

--
-- Name: get_distances_between_stop_points_in_journey_patterns(uuid[], date, boolean); Type: FUNCTION; Schema: service_pattern; Owner: dbhasura
--

CREATE FUNCTION service_pattern.get_distances_between_stop_points_in_journey_patterns(journey_pattern_ids uuid[], observation_date date, include_draft_stops boolean) RETURNS SETOF service_pattern.distance_between_stops_calculation
    LANGUAGE sql STABLE PARALLEL SAFE
    AS $$
WITH RECURSIVE
scheduled_stop_point_info AS (
  SELECT
    jp.on_route_id                         AS route_id,
    jp.journey_pattern_id,
    -- Generate continuous (gapless) sequence number starting from 1.
    row_number() OVER(
      PARTITION BY jp.journey_pattern_id
      ORDER BY ssp.scheduled_stop_point_sequence ASC
    )::integer                             AS stop_point_sequence,
    ssp.label                              AS stop_point_label,
    ssp.located_on_infrastructure_link_id  AS infrastructure_link_id,
    ssp.direction                          AS stop_point_direction,
    ssp.relative_distance_from_link_start  AS stop_distance_from_link_start
  FROM journey_pattern.journey_pattern jp
  JOIN LATERAL (
    SELECT *
    FROM service_pattern.find_scheduled_stop_point_locations_in_journey_pattern(jp.journey_pattern_id, observation_date, include_draft_stops)
  ) ssp USING (journey_pattern_id)
  WHERE jp.journey_pattern_id = ANY(journey_pattern_ids)
),
ssp_merged_with_ilar AS ( -- contains recursive term
  SELECT
    sspi.route_id,
    sspi.journey_pattern_id,
    sspi.stop_point_sequence,
    sspi.stop_point_label,
    sspi.stop_distance_from_link_start,

    -- It is assumed, that we stop at the first matching infrastructure link.
    -- 
    -- Our data model does not properly support going around a loop multiple
    -- times without stopping at the same stop point in each loop.
    -- 
    -- Also, if we make a U-turn at the end of a bi-directional link and there
    -- is a two-way stop point along it, it is not possible with this logic to
    -- stop only once and in the return direction. The data model lacks the
    -- possibility to unequivocally define with which individual link visit we
    -- should stop at a stop point along it.
    -- 
    -- Therefore, there is an inherent indeterminism in the distance calculation
    -- for these corner cases. In practice, this may not cause problems.
    -- 
    first_value(ilar.infrastructure_link_sequence) OVER (
      PARTITION BY sspi.journey_pattern_id
      ORDER BY ilar.infrastructure_link_sequence ASC
    ) AS route_link_sequence_start

  FROM scheduled_stop_point_info sspi
  JOIN route.infrastructure_link_along_route ilar USING (route_id, infrastructure_link_id)
  WHERE sspi.stop_point_sequence = 1
    AND (
      sspi.stop_point_direction = 'bidirectional'
      OR sspi.stop_point_direction = 'forward' AND ilar.is_traversal_forwards
      OR sspi.stop_point_direction = 'backward' AND NOT ilar.is_traversal_forwards
    )
  UNION
  -- recursive term begins
  SELECT
    sspi.route_id,
    sspi.journey_pattern_id,
    sspi.stop_point_sequence,
    sspi.stop_point_label,
    sspi.stop_distance_from_link_start,

    -- It is assumed, that we stop at the first matching infrastructure link.
    -- See more remarks above (in the non-recursive term).
    first_value(ilar.infrastructure_link_sequence) OVER (
      PARTITION BY sspi.journey_pattern_id
      ORDER BY ilar.infrastructure_link_sequence ASC
    ) AS route_link_sequence_start

  FROM ssp_merged_with_ilar prev
  JOIN scheduled_stop_point_info sspi
    ON sspi.journey_pattern_id = prev.journey_pattern_id
      AND sspi.stop_point_sequence = prev.stop_point_sequence + 1
  JOIN route.infrastructure_link_along_route ilar
    ON ilar.route_id = sspi.route_id
      AND ilar.infrastructure_link_id = sspi.infrastructure_link_id
  WHERE
    (
      ilar.infrastructure_link_sequence > prev.route_link_sequence_start
      OR (
        ilar.infrastructure_link_sequence = prev.route_link_sequence_start
        AND (
          ilar.is_traversal_forwards AND sspi.stop_distance_from_link_start > prev.stop_distance_from_link_start
          OR NOT ilar.is_traversal_forwards AND sspi.stop_distance_from_link_start < prev.stop_distance_from_link_start
        )
      )
    )
    AND (
      sspi.stop_point_direction = 'bidirectional'
      OR sspi.stop_point_direction = 'forward' AND ilar.is_traversal_forwards
      OR sspi.stop_point_direction = 'backward' AND NOT ilar.is_traversal_forwards
    )
),
stop_interval AS (
  SELECT *
  FROM (
    SELECT
      journey_pattern_id,
      stop_point_sequence AS stop_interval_sequence,
      stop_point_label AS start_stop_label,
      lead(stop_point_label) OVER (
        PARTITION BY journey_pattern_id
        ORDER BY stop_point_sequence ASC
      ) AS end_stop_label,
      stop_distance_from_link_start::numeric AS start_stop_distance_from_link_start,
      lead(stop_distance_from_link_start) OVER (
        PARTITION BY journey_pattern_id
        ORDER BY stop_point_sequence ASC
      )::numeric AS end_stop_distance_from_link_start,
      route_id,
      route_link_sequence_start,
      lead(route_link_sequence_start) OVER (
        PARTITION BY journey_pattern_id
        ORDER BY stop_point_sequence ASC
      ) AS route_link_sequence_end
    FROM ssp_merged_with_ilar
  ) t
   -- Filter out last item, because N stops make N-1 stop intervals.
  WHERE route_link_sequence_end IS NOT NULL
),
route_link_traversal AS (
  SELECT
    si.journey_pattern_id,
    si.stop_interval_sequence,
    ilar.infrastructure_link_sequence,

    -- When the estimated length exists, scale the length of the link section by
    -- the ratio of the estimated length to the geometry length.
    -- 
    -- Take elevation changes into account, hence using 3D lengths.
    CASE
      WHEN il.estimated_length_in_metres IS NOT NULL THEN
        il.estimated_length_in_metres / ST_3DLength(transformed_link_shape.geom) * ST_3DLength(link_section_used.geom)
      ELSE
        ST_3DLength(link_section_used.geom)
    END AS distance_in_metres

  FROM stop_interval si
  JOIN route.infrastructure_link_along_route ilar
    ON ilar.route_id = si.route_id
      AND ilar.infrastructure_link_sequence
        BETWEEN si.route_link_sequence_start AND si.route_link_sequence_end
  JOIN infrastructure_network.infrastructure_link il USING (infrastructure_link_id)
  CROSS JOIN LATERAL (
    -- CRS transformations should result in a metric coordinate system.
    -- E.g. EPSG:4326 is not like one.
    SELECT ST_Transform(il.shape::geometry, internal_utils.determine_srid(il.shape)) AS geom
  ) transformed_link_shape
  CROSS JOIN LATERAL (
    SELECT
      CASE
        WHEN numrange IS NULL THEN transformed_link_shape.geom
        ELSE ST_LineSubstring(transformed_link_shape.geom, lower(numrange), upper(numrange))
      END AS geom
    FROM (
      -- Resolve start/end point on the first/last infra link in stop interval.
      SELECT CASE
        -- both stop points along same single link
        WHEN si.route_link_sequence_start = si.route_link_sequence_end THEN
          CASE
            WHEN ilar.is_traversal_forwards THEN
              numrange(start_stop_distance_from_link_start, end_stop_distance_from_link_start, '[]')
            ELSE
              numrange(end_stop_distance_from_link_start, start_stop_distance_from_link_start, '[]')
          END
        WHEN ilar.infrastructure_link_sequence = si.route_link_sequence_start THEN
          CASE
            WHEN ilar.is_traversal_forwards THEN
              numrange(start_stop_distance_from_link_start, 1.0, '[]')
            ELSE
              numrange(0.0, start_stop_distance_from_link_start, '[]')
          END
        WHEN ilar.infrastructure_link_sequence = si.route_link_sequence_end THEN
          CASE
            WHEN ilar.is_traversal_forwards THEN
              numrange(0.0, end_stop_distance_from_link_start, '[]')
            ELSE
              numrange(end_stop_distance_from_link_start, 1.0, '[]')
          END
        ELSE NULL
      END AS numrange
    ) line_endpoints
  ) link_section_used
),
stop_interval_distance AS (
  SELECT journey_pattern_id, stop_interval_sequence, sum(distance_in_metres) AS total_distance_in_metres
  FROM route_link_traversal
  GROUP BY journey_pattern_id, stop_interval_sequence
)
SELECT
  journey_pattern_id,
  route_id,
  priority AS route_priority,
  observation_date,
  stop_interval_sequence,
  start_stop_label,
  end_stop_label,
  total_distance_in_metres AS distance_in_metres
FROM stop_interval
JOIN stop_interval_distance USING (journey_pattern_id, stop_interval_sequence)
JOIN route.route USING (route_id)
ORDER BY route_id, journey_pattern_id, stop_interval_sequence
$$;


ALTER FUNCTION service_pattern.get_distances_between_stop_points_in_journey_patterns(journey_pattern_ids uuid[], observation_date date, include_draft_stops boolean) OWNER TO dbhasura;

--
-- Name: get_scheduled_stop_points_with_new(uuid, uuid, uuid, public.geography, text, text, date, date, integer); Type: FUNCTION; Schema: service_pattern; Owner: dbhasura
--

CREATE FUNCTION service_pattern.get_scheduled_stop_points_with_new(replace_scheduled_stop_point_id uuid DEFAULT NULL::uuid, new_scheduled_stop_point_id uuid DEFAULT NULL::uuid, new_located_on_infrastructure_link_id uuid DEFAULT NULL::uuid, new_measured_location public.geography DEFAULT NULL::public.geography, new_direction text DEFAULT NULL::text, new_label text DEFAULT NULL::text, new_validity_start date DEFAULT NULL::date, new_validity_end date DEFAULT NULL::date, new_priority integer DEFAULT NULL::integer) RETURNS TABLE(scheduled_stop_point_id uuid, measured_location public.geography, located_on_infrastructure_link_id uuid, direction text, label text, validity_start date, validity_end date, priority integer, relative_distance_from_infrastructure_link_start double precision, closest_point_on_infrastructure_link public.geography)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  IF new_scheduled_stop_point_id IS NULL THEN
    RETURN QUERY
      SELECT ssp.scheduled_stop_point_id,
             ssp.measured_location,
             ssp.located_on_infrastructure_link_id,
             ssp.direction,
             ssp.label,
             ssp.validity_start,
             ssp.validity_end,
             ssp.priority,
             internal_utils.st_linelocatepoint(il.shape, ssp.measured_location) AS relative_distance_from_infrastructure_link_start,
             internal_utils.st_closestpoint(il.shape, ssp.measured_location) AS closest_point_on_infrastructure_link
      FROM service_pattern.scheduled_stop_point ssp
        JOIN infrastructure_network.infrastructure_link il ON ssp.located_on_infrastructure_link_id = il.infrastructure_link_id
      WHERE replace_scheduled_stop_point_id IS NULL
         OR ssp.scheduled_stop_point_id != replace_scheduled_stop_point_id;
  ELSE
    RETURN QUERY
      SELECT ssp.scheduled_stop_point_id,
             ssp.measured_location,
             ssp.located_on_infrastructure_link_id,
             ssp.direction,
             ssp.label,
             ssp.validity_start,
             ssp.validity_end,
             ssp.priority,
             internal_utils.st_linelocatepoint(il.shape, ssp.measured_location) AS relative_distance_from_infrastructure_link_start,
             internal_utils.st_closestpoint(il.shape, ssp.measured_location) AS closest_point_on_infrastructure_link
      FROM service_pattern.scheduled_stop_point ssp
        JOIN infrastructure_network.infrastructure_link il ON ssp.located_on_infrastructure_link_id = il.infrastructure_link_id
      WHERE replace_scheduled_stop_point_id IS NULL
         OR ssp.scheduled_stop_point_id != replace_scheduled_stop_point_id
      UNION ALL
      SELECT new_scheduled_stop_point_id,
             new_measured_location::geography(PointZ, 4326),
             new_located_on_infrastructure_link_id,
             new_direction,
             new_label,
             new_validity_start,
             new_validity_end,
             new_priority,
             internal_utils.st_linelocatepoint(il.shape, new_measured_location) AS relative_distance_from_infrastructure_link_start,
             NULL::geography(PointZ, 4326)                                      AS closest_point_on_infrastructure_link
      FROM infrastructure_network.infrastructure_link il
      WHERE il.infrastructure_link_id = new_located_on_infrastructure_link_id;
  END IF;
END;
$$;


ALTER FUNCTION service_pattern.get_scheduled_stop_points_with_new(replace_scheduled_stop_point_id uuid, new_scheduled_stop_point_id uuid, new_located_on_infrastructure_link_id uuid, new_measured_location public.geography, new_direction text, new_label text, new_validity_start date, new_validity_end date, new_priority integer) OWNER TO dbhasura;

--
-- Name: insert_scheduled_stop_point_label(text); Type: FUNCTION; Schema: service_pattern; Owner: dbhasura
--

CREATE FUNCTION service_pattern.insert_scheduled_stop_point_label(new_label text) RETURNS void
    LANGUAGE sql
    AS $$
INSERT INTO service_pattern.scheduled_stop_point_invariant (label)
VALUES (new_label)
ON CONFLICT (label)
  DO NOTHING;
$$;


ALTER FUNCTION service_pattern.insert_scheduled_stop_point_label(new_label text) OWNER TO dbhasura;

--
-- Name: on_delete_scheduled_stop_point(); Type: FUNCTION; Schema: service_pattern; Owner: dbhasura
--

CREATE FUNCTION service_pattern.on_delete_scheduled_stop_point() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM service_pattern.delete_scheduled_stop_point_label(OLD.label);
  RETURN OLD;
END;
$$;


ALTER FUNCTION service_pattern.on_delete_scheduled_stop_point() OWNER TO dbhasura;

--
-- Name: on_insert_scheduled_stop_point(); Type: FUNCTION; Schema: service_pattern; Owner: dbhasura
--

CREATE FUNCTION service_pattern.on_insert_scheduled_stop_point() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM service_pattern.insert_scheduled_stop_point_label(NEW.label);
  RETURN NEW;
END;
$$;


ALTER FUNCTION service_pattern.on_insert_scheduled_stop_point() OWNER TO dbhasura;

--
-- Name: on_update_scheduled_stop_point(); Type: FUNCTION; Schema: service_pattern; Owner: dbhasura
--

CREATE FUNCTION service_pattern.on_update_scheduled_stop_point() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM service_pattern.insert_scheduled_stop_point_label(NEW.label);
  PERFORM service_pattern.delete_scheduled_stop_point_label(OLD.label);
  RETURN NEW;
END;
$$;


ALTER FUNCTION service_pattern.on_update_scheduled_stop_point() OWNER TO dbhasura;

--
-- Name: prevent_inserting_distance_between_stops_calculation(); Type: FUNCTION; Schema: service_pattern; Owner: dbhasura
--

CREATE FUNCTION service_pattern.prevent_inserting_distance_between_stops_calculation() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN NULL;
END;
$$;


ALTER FUNCTION service_pattern.prevent_inserting_distance_between_stops_calculation() OWNER TO dbhasura;

--
-- Name: scheduled_stop_point_closest_point_on_infrastructure_link(service_pattern.scheduled_stop_point); Type: FUNCTION; Schema: service_pattern; Owner: dbhasura
--

CREATE FUNCTION service_pattern.scheduled_stop_point_closest_point_on_infrastructure_link(ssp service_pattern.scheduled_stop_point) RETURNS public.geography
    LANGUAGE sql STABLE
    AS $$
  SELECT
    internal_utils.st_closestpoint(il.shape, ssp.measured_location) AS closest_point_on_infrastructure_link
  FROM infrastructure_network.infrastructure_link il
  WHERE ssp.located_on_infrastructure_link_id = il.infrastructure_link_id;
$$;


ALTER FUNCTION service_pattern.scheduled_stop_point_closest_point_on_infrastructure_link(ssp service_pattern.scheduled_stop_point) OWNER TO dbhasura;

--
-- Name: ssp_relative_distance_from_infrastructure_link_start(service_pattern.scheduled_stop_point); Type: FUNCTION; Schema: service_pattern; Owner: dbhasura
--

CREATE FUNCTION service_pattern.ssp_relative_distance_from_infrastructure_link_start(ssp service_pattern.scheduled_stop_point) RETURNS double precision
    LANGUAGE sql STABLE
    AS $$
  SELECT
    internal_utils.st_linelocatepoint(il.shape, ssp.measured_location) AS relative_distance_from_infrastructure_link_start
  FROM infrastructure_network.infrastructure_link il
  WHERE ssp.located_on_infrastructure_link_id = il.infrastructure_link_id;
$$;


ALTER FUNCTION service_pattern.ssp_relative_distance_from_infrastructure_link_start(ssp service_pattern.scheduled_stop_point) OWNER TO dbhasura;

--
-- Name: hdb_cron_event_invocation_event_id; Type: INDEX; Schema: hdb_catalog; Owner: dbhasura
--

CREATE INDEX hdb_cron_event_invocation_event_id ON hdb_catalog.hdb_cron_event_invocation_logs USING btree (event_id);

--
-- Name: hdb_cron_event_status; Type: INDEX; Schema: hdb_catalog; Owner: dbhasura
--

CREATE INDEX hdb_cron_event_status ON hdb_catalog.hdb_cron_events USING btree (status);

--
-- Name: hdb_cron_events_unique_scheduled; Type: INDEX; Schema: hdb_catalog; Owner: dbhasura
--

CREATE UNIQUE INDEX hdb_cron_events_unique_scheduled ON hdb_catalog.hdb_cron_events USING btree (trigger_name, scheduled_time) WHERE (status = 'scheduled'::text);

--
-- Name: hdb_scheduled_event_status; Type: INDEX; Schema: hdb_catalog; Owner: dbhasura
--

CREATE INDEX hdb_scheduled_event_status ON hdb_catalog.hdb_scheduled_events USING btree (status);

--
-- Name: hdb_version_one_row; Type: INDEX; Schema: hdb_catalog; Owner: dbhasura
--

CREATE UNIQUE INDEX hdb_version_one_row ON hdb_catalog.hdb_version USING btree (((version IS NOT NULL)));

--
-- Name: idx_infrastructure_link_direction; Type: INDEX; Schema: infrastructure_network; Owner: dbhasura
--

CREATE INDEX idx_infrastructure_link_direction ON infrastructure_network.infrastructure_link USING btree (direction);

--
-- Name: idx_infrastructure_link_external_link_source_fkey; Type: INDEX; Schema: infrastructure_network; Owner: dbhasura
--

CREATE INDEX idx_infrastructure_link_external_link_source_fkey ON infrastructure_network.infrastructure_link USING btree (external_link_source);

--
-- Name: infrastructure_link_external_link_id_external_link_source_idx; Type: INDEX; Schema: infrastructure_network; Owner: dbhasura
--

CREATE UNIQUE INDEX infrastructure_link_external_link_id_external_link_source_idx ON infrastructure_network.infrastructure_link USING btree (external_link_id, external_link_source);

--
-- Name: vehicle_submode_on_infrastruc_vehicle_submode_infrastructur_idx; Type: INDEX; Schema: infrastructure_network; Owner: dbhasura
--

CREATE INDEX vehicle_submode_on_infrastruc_vehicle_submode_infrastructur_idx ON infrastructure_network.vehicle_submode_on_infrastructure_link USING btree (vehicle_submode, infrastructure_link_id);

--
-- Name: idx_scheduled_stop_point_in_journey_pattern_via_point_name_i18n; Type: INDEX; Schema: journey_pattern; Owner: dbhasura
--

CREATE INDEX idx_scheduled_stop_point_in_journey_pattern_via_point_name_i18n ON journey_pattern.scheduled_stop_point_in_journey_pattern USING gin (via_point_name_i18n);

--
-- Name: idx_scheduled_stop_point_in_journey_pattern_via_point_short_nam; Type: INDEX; Schema: journey_pattern; Owner: dbhasura
--

CREATE INDEX idx_scheduled_stop_point_in_journey_pattern_via_point_short_nam ON journey_pattern.scheduled_stop_point_in_journey_pattern USING gin (via_point_short_name_i18n);

--
-- Name: journey_pattern_on_route_id_idx; Type: INDEX; Schema: journey_pattern; Owner: dbhasura
--

CREATE UNIQUE INDEX journey_pattern_on_route_id_idx ON journey_pattern.journey_pattern USING btree (on_route_id);

--
-- Name: scheduled_stop_point_in_journ_scheduled_stop_point_sequence_idx; Type: INDEX; Schema: journey_pattern; Owner: dbhasura
--

CREATE INDEX scheduled_stop_point_in_journ_scheduled_stop_point_sequence_idx ON journey_pattern.scheduled_stop_point_in_journey_pattern USING btree (scheduled_stop_point_sequence, journey_pattern_id);

--
-- Name: scheduled_stop_point_in_journey__scheduled_stop_point_label_idx; Type: INDEX; Schema: journey_pattern; Owner: dbhasura
--

CREATE INDEX scheduled_stop_point_in_journey__scheduled_stop_point_label_idx ON journey_pattern.scheduled_stop_point_in_journey_pattern USING btree (scheduled_stop_point_label);

--
-- Name: vehicle_submode_belonging_to_vehicle_mode_idx; Type: INDEX; Schema: reusable_components; Owner: dbhasura
--

CREATE INDEX vehicle_submode_belonging_to_vehicle_mode_idx ON reusable_components.vehicle_submode USING btree (belonging_to_vehicle_mode);

--
-- Name: idx_direction_the_opposite_of_direction; Type: INDEX; Schema: route; Owner: dbhasura
--

CREATE INDEX idx_direction_the_opposite_of_direction ON route.direction USING btree (the_opposite_of_direction);

--
-- Name: idx_line_name_i18n; Type: INDEX; Schema: route; Owner: dbhasura
--

CREATE INDEX idx_line_name_i18n ON route.line USING gin (name_i18n);

--
-- Name: idx_line_primary_vehicle_mode; Type: INDEX; Schema: route; Owner: dbhasura
--

CREATE INDEX idx_line_primary_vehicle_mode ON route.line USING btree (primary_vehicle_mode);

--
-- Name: idx_line_short_name_i18n; Type: INDEX; Schema: route; Owner: dbhasura
--

CREATE INDEX idx_line_short_name_i18n ON route.line USING gin (short_name_i18n);

--
-- Name: idx_line_type_of_line; Type: INDEX; Schema: route; Owner: dbhasura
--

CREATE INDEX idx_line_type_of_line ON route.line USING btree (type_of_line);

--
-- Name: idx_route_destination_name_i18n; Type: INDEX; Schema: route; Owner: dbhasura
--

CREATE INDEX idx_route_destination_name_i18n ON route.route USING gin (destination_name_i18n);

--
-- Name: idx_route_destination_short_name_i18n; Type: INDEX; Schema: route; Owner: dbhasura
--

CREATE INDEX idx_route_destination_short_name_i18n ON route.route USING gin (destination_short_name_i18n);

--
-- Name: idx_route_direction; Type: INDEX; Schema: route; Owner: dbhasura
--

CREATE INDEX idx_route_direction ON route.route USING btree (direction);

--
-- Name: idx_route_name_i18n; Type: INDEX; Schema: route; Owner: dbhasura
--

CREATE INDEX idx_route_name_i18n ON route.route USING gin (name_i18n);

--
-- Name: idx_route_on_line_id; Type: INDEX; Schema: route; Owner: dbhasura
--

CREATE INDEX idx_route_on_line_id ON route.route USING btree (on_line_id);

--
-- Name: idx_route_origin_name_i18n; Type: INDEX; Schema: route; Owner: dbhasura
--

CREATE INDEX idx_route_origin_name_i18n ON route.route USING gin (origin_name_i18n);

--
-- Name: idx_route_origin_short_name_i18n; Type: INDEX; Schema: route; Owner: dbhasura
--

CREATE INDEX idx_route_origin_short_name_i18n ON route.route USING gin (origin_short_name_i18n);

--
-- Name: infrastructure_link_along_rou_infrastructure_link_sequence__idx; Type: INDEX; Schema: route; Owner: dbhasura
--

CREATE INDEX infrastructure_link_along_rou_infrastructure_link_sequence__idx ON route.infrastructure_link_along_route USING btree (infrastructure_link_sequence, route_id);

--
-- Name: infrastructure_link_along_route_infrastructure_link_id_idx; Type: INDEX; Schema: route; Owner: dbhasura
--

CREATE INDEX infrastructure_link_along_route_infrastructure_link_id_idx ON route.infrastructure_link_along_route USING btree (infrastructure_link_id);

--
-- Name: type_of_line_belonging_to_vehicle_mode_idx; Type: INDEX; Schema: route; Owner: dbhasura
--

CREATE INDEX type_of_line_belonging_to_vehicle_mode_idx ON route.type_of_line USING btree (belonging_to_vehicle_mode);

--
-- Name: idx_scheduled_stop_point_direction; Type: INDEX; Schema: service_pattern; Owner: dbhasura
--

CREATE INDEX idx_scheduled_stop_point_direction ON service_pattern.scheduled_stop_point USING btree (direction);

--
-- Name: scheduled_stop_point_label_idx; Type: INDEX; Schema: service_pattern; Owner: dbhasura
--

CREATE INDEX scheduled_stop_point_label_idx ON service_pattern.scheduled_stop_point USING btree (label);

--
-- Name: scheduled_stop_point_located_on_infrastructure_link_id_idx; Type: INDEX; Schema: service_pattern; Owner: dbhasura
--

CREATE INDEX scheduled_stop_point_located_on_infrastructure_link_id_idx ON service_pattern.scheduled_stop_point USING btree (located_on_infrastructure_link_id);

--
-- Name: scheduled_stop_point_measured_location_idx; Type: INDEX; Schema: service_pattern; Owner: dbhasura
--

CREATE INDEX scheduled_stop_point_measured_location_idx ON service_pattern.scheduled_stop_point USING gist (measured_location);

--
-- Name: scheduled_stop_point_serviced_vehicle_mode_scheduled_stop_p_idx; Type: INDEX; Schema: service_pattern; Owner: dbhasura
--

CREATE INDEX scheduled_stop_point_serviced_vehicle_mode_scheduled_stop_p_idx ON service_pattern.vehicle_mode_on_scheduled_stop_point USING btree (vehicle_mode, scheduled_stop_point_id);

--
-- Name: timing_place_label_idx; Type: INDEX; Schema: timing_pattern; Owner: dbhasura
--

CREATE UNIQUE INDEX timing_place_label_idx ON timing_pattern.timing_place USING btree (label);

--
-- Name: hdb_catalog; Type: SCHEMA; Schema: -; Owner: dbhasura
--

CREATE SCHEMA hdb_catalog;


ALTER SCHEMA hdb_catalog OWNER TO dbhasura;

--
-- Name: infrastructure_network; Type: SCHEMA; Schema: -; Owner: dbhasura
--

CREATE SCHEMA infrastructure_network;


ALTER SCHEMA infrastructure_network OWNER TO dbhasura;

--
-- Name: internal_service_pattern; Type: SCHEMA; Schema: -; Owner: dbhasura
--

CREATE SCHEMA internal_service_pattern;


ALTER SCHEMA internal_service_pattern OWNER TO dbhasura;

--
-- Name: internal_utils; Type: SCHEMA; Schema: -; Owner: dbhasura
--

CREATE SCHEMA internal_utils;


ALTER SCHEMA internal_utils OWNER TO dbhasura;

--
-- Name: journey_pattern; Type: SCHEMA; Schema: -; Owner: dbhasura
--

CREATE SCHEMA journey_pattern;


ALTER SCHEMA journey_pattern OWNER TO dbhasura;

--
-- Name: reusable_components; Type: SCHEMA; Schema: -; Owner: dbhasura
--

CREATE SCHEMA reusable_components;


ALTER SCHEMA reusable_components OWNER TO dbhasura;

--
-- Name: route; Type: SCHEMA; Schema: -; Owner: dbhasura
--

CREATE SCHEMA route;


ALTER SCHEMA route OWNER TO dbhasura;

--
-- Name: service_pattern; Type: SCHEMA; Schema: -; Owner: dbhasura
--

CREATE SCHEMA service_pattern;


ALTER SCHEMA service_pattern OWNER TO dbhasura;

--
-- Name: tiger; Type: SCHEMA; Schema: -; Owner: dbadmin
--

CREATE SCHEMA tiger;


ALTER SCHEMA tiger OWNER TO dbadmin;

--
-- Name: tiger_data; Type: SCHEMA; Schema: -; Owner: dbadmin
--

CREATE SCHEMA tiger_data;


ALTER SCHEMA tiger_data OWNER TO dbadmin;

--
-- Name: timing_pattern; Type: SCHEMA; Schema: -; Owner: dbhasura
--

CREATE SCHEMA timing_pattern;


ALTER SCHEMA timing_pattern OWNER TO dbhasura;

--
-- Name: topology; Type: SCHEMA; Schema: -; Owner: dbadmin
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO dbadmin;

--
-- Name: hdb_action_log; Type: TABLE; Schema: hdb_catalog; Owner: dbhasura
--

CREATE TABLE hdb_catalog.hdb_action_log (
    id uuid DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    action_name text,
    input_payload jsonb NOT NULL,
    request_headers jsonb NOT NULL,
    session_variables jsonb NOT NULL,
    response_payload jsonb,
    errors jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    response_received_at timestamp with time zone,
    status text NOT NULL,
    CONSTRAINT hdb_action_log_status_check CHECK ((status = ANY (ARRAY['created'::text, 'processing'::text, 'completed'::text, 'error'::text])))
);


ALTER TABLE hdb_catalog.hdb_action_log OWNER TO dbhasura;

--
-- Name: hdb_cron_event_invocation_logs; Type: TABLE; Schema: hdb_catalog; Owner: dbhasura
--

CREATE TABLE hdb_catalog.hdb_cron_event_invocation_logs (
    id text DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    event_id text,
    status integer,
    request json,
    response json,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE hdb_catalog.hdb_cron_event_invocation_logs OWNER TO dbhasura;

--
-- Name: hdb_cron_events; Type: TABLE; Schema: hdb_catalog; Owner: dbhasura
--

CREATE TABLE hdb_catalog.hdb_cron_events (
    id text DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    trigger_name text NOT NULL,
    scheduled_time timestamp with time zone NOT NULL,
    status text DEFAULT 'scheduled'::text NOT NULL,
    tries integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    next_retry_at timestamp with time zone,
    CONSTRAINT valid_status CHECK ((status = ANY (ARRAY['scheduled'::text, 'locked'::text, 'delivered'::text, 'error'::text, 'dead'::text])))
);


ALTER TABLE hdb_catalog.hdb_cron_events OWNER TO dbhasura;

--
-- Name: hdb_metadata; Type: TABLE; Schema: hdb_catalog; Owner: dbhasura
--

CREATE TABLE hdb_catalog.hdb_metadata (
    id integer NOT NULL,
    metadata json NOT NULL,
    resource_version integer DEFAULT 1 NOT NULL
);


ALTER TABLE hdb_catalog.hdb_metadata OWNER TO dbhasura;

--
-- Name: hdb_scheduled_event_invocation_logs; Type: TABLE; Schema: hdb_catalog; Owner: dbhasura
--

CREATE TABLE hdb_catalog.hdb_scheduled_event_invocation_logs (
    id text DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    event_id text,
    status integer,
    request json,
    response json,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE hdb_catalog.hdb_scheduled_event_invocation_logs OWNER TO dbhasura;

--
-- Name: hdb_scheduled_events; Type: TABLE; Schema: hdb_catalog; Owner: dbhasura
--

CREATE TABLE hdb_catalog.hdb_scheduled_events (
    id text DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    webhook_conf json NOT NULL,
    scheduled_time timestamp with time zone NOT NULL,
    retry_conf json,
    payload json,
    header_conf json,
    status text DEFAULT 'scheduled'::text NOT NULL,
    tries integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    next_retry_at timestamp with time zone,
    comment text,
    CONSTRAINT valid_status CHECK ((status = ANY (ARRAY['scheduled'::text, 'locked'::text, 'delivered'::text, 'error'::text, 'dead'::text])))
);


ALTER TABLE hdb_catalog.hdb_scheduled_events OWNER TO dbhasura;

--
-- Name: hdb_schema_notifications; Type: TABLE; Schema: hdb_catalog; Owner: dbhasura
--

CREATE TABLE hdb_catalog.hdb_schema_notifications (
    id integer NOT NULL,
    notification json NOT NULL,
    resource_version integer DEFAULT 1 NOT NULL,
    instance_id uuid NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT hdb_schema_notifications_id_check CHECK ((id = 1))
);


ALTER TABLE hdb_catalog.hdb_schema_notifications OWNER TO dbhasura;

--
-- Name: hdb_version; Type: TABLE; Schema: hdb_catalog; Owner: dbhasura
--

CREATE TABLE hdb_catalog.hdb_version (
    hasura_uuid uuid DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    version text NOT NULL,
    upgraded_on timestamp with time zone NOT NULL,
    cli_state jsonb DEFAULT '{}'::jsonb NOT NULL,
    console_state jsonb DEFAULT '{}'::jsonb NOT NULL
);


ALTER TABLE hdb_catalog.hdb_version OWNER TO dbhasura;

--
-- Name: direction; Type: TABLE; Schema: infrastructure_network; Owner: dbhasura
--

CREATE TABLE infrastructure_network.direction (
    value text NOT NULL
);


ALTER TABLE infrastructure_network.direction OWNER TO dbhasura;

--
-- Name: external_source; Type: TABLE; Schema: infrastructure_network; Owner: dbhasura
--

CREATE TABLE infrastructure_network.external_source (
    value text NOT NULL
);


ALTER TABLE infrastructure_network.external_source OWNER TO dbhasura;

--
-- Name: infrastructure_link; Type: TABLE; Schema: infrastructure_network; Owner: dbhasura
--

CREATE TABLE infrastructure_network.infrastructure_link (
    infrastructure_link_id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    direction text NOT NULL,
    shape public.geography(LineStringZ,4326) NOT NULL,
    estimated_length_in_metres double precision,
    external_link_id text NOT NULL,
    external_link_source text NOT NULL
);


ALTER TABLE infrastructure_network.infrastructure_link OWNER TO dbhasura;

--
-- Name: vehicle_submode_on_infrastructure_link; Type: TABLE; Schema: infrastructure_network; Owner: dbhasura
--

CREATE TABLE infrastructure_network.vehicle_submode_on_infrastructure_link (
    infrastructure_link_id uuid NOT NULL,
    vehicle_submode text NOT NULL
);


ALTER TABLE infrastructure_network.vehicle_submode_on_infrastructure_link OWNER TO dbhasura;

--
-- Name: journey_pattern; Type: TABLE; Schema: journey_pattern; Owner: dbhasura
--

CREATE TABLE journey_pattern.journey_pattern (
    journey_pattern_id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    on_route_id uuid NOT NULL
);


ALTER TABLE journey_pattern.journey_pattern OWNER TO dbhasura;

--
-- Name: scheduled_stop_point_in_journey_pattern; Type: TABLE; Schema: journey_pattern; Owner: dbhasura
--

CREATE TABLE journey_pattern.scheduled_stop_point_in_journey_pattern (
    journey_pattern_id uuid NOT NULL,
    scheduled_stop_point_sequence integer NOT NULL,
    is_used_as_timing_point boolean DEFAULT false NOT NULL,
    is_via_point boolean DEFAULT false NOT NULL,
    via_point_name_i18n jsonb,
    via_point_short_name_i18n jsonb,
    scheduled_stop_point_label text NOT NULL,
    is_loading_time_allowed boolean DEFAULT false NOT NULL,
    is_regulated_timing_point boolean DEFAULT false NOT NULL,
    CONSTRAINT ck_is_via_point_state CHECK ((((is_via_point = false) AND (via_point_name_i18n IS NULL) AND (via_point_short_name_i18n IS NULL)) OR ((is_via_point = true) AND (via_point_name_i18n IS NOT NULL) AND (via_point_short_name_i18n IS NOT NULL))))
);


ALTER TABLE journey_pattern.scheduled_stop_point_in_journey_pattern OWNER TO dbhasura;

--
-- Name: vehicle_mode; Type: TABLE; Schema: reusable_components; Owner: dbhasura
--

CREATE TABLE reusable_components.vehicle_mode (
    vehicle_mode text NOT NULL
);


ALTER TABLE reusable_components.vehicle_mode OWNER TO dbhasura;

--
-- Name: vehicle_submode; Type: TABLE; Schema: reusable_components; Owner: dbhasura
--

CREATE TABLE reusable_components.vehicle_submode (
    vehicle_submode text NOT NULL,
    belonging_to_vehicle_mode text NOT NULL
);


ALTER TABLE reusable_components.vehicle_submode OWNER TO dbhasura;

--
-- Name: direction; Type: TABLE; Schema: route; Owner: dbhasura
--

CREATE TABLE route.direction (
    direction text NOT NULL,
    the_opposite_of_direction text
);


ALTER TABLE route.direction OWNER TO dbhasura;

--
-- Name: infrastructure_link_along_route; Type: TABLE; Schema: route; Owner: dbhasura
--

CREATE TABLE route.infrastructure_link_along_route (
    route_id uuid NOT NULL,
    infrastructure_link_id uuid NOT NULL,
    infrastructure_link_sequence integer NOT NULL,
    is_traversal_forwards boolean NOT NULL
);


ALTER TABLE route.infrastructure_link_along_route OWNER TO dbhasura;

--
-- Name: line; Type: TABLE; Schema: route; Owner: dbhasura
--

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


ALTER TABLE route.line OWNER TO dbhasura;

--
-- Name: route; Type: TABLE; Schema: route; Owner: dbhasura
--

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
    destination_short_name_i18n jsonb,
    unique_label text GENERATED ALWAYS AS (label) STORED
);


ALTER TABLE route.route OWNER TO dbhasura;

--
-- Name: type_of_line; Type: TABLE; Schema: route; Owner: dbhasura
--

CREATE TABLE route.type_of_line (
    type_of_line text NOT NULL,
    belonging_to_vehicle_mode text NOT NULL
);


ALTER TABLE route.type_of_line OWNER TO dbhasura;

--
-- Name: distance_between_stops_calculation; Type: TABLE; Schema: service_pattern; Owner: dbhasura
--

CREATE TABLE service_pattern.distance_between_stops_calculation (
    journey_pattern_id uuid NOT NULL,
    route_id uuid NOT NULL,
    route_priority integer NOT NULL,
    observation_date date NOT NULL,
    stop_interval_sequence integer NOT NULL,
    start_stop_label text NOT NULL,
    end_stop_label text NOT NULL,
    distance_in_metres double precision NOT NULL
);


ALTER TABLE service_pattern.distance_between_stops_calculation OWNER TO dbhasura;

--
-- Name: scheduled_stop_point; Type: TABLE; Schema: service_pattern; Owner: dbhasura
--

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


ALTER TABLE service_pattern.scheduled_stop_point OWNER TO dbhasura;

--
-- Name: scheduled_stop_point_invariant; Type: TABLE; Schema: service_pattern; Owner: dbhasura
--

CREATE TABLE service_pattern.scheduled_stop_point_invariant (
    label text NOT NULL
);


ALTER TABLE service_pattern.scheduled_stop_point_invariant OWNER TO dbhasura;

--
-- Name: vehicle_mode_on_scheduled_stop_point; Type: TABLE; Schema: service_pattern; Owner: dbhasura
--

CREATE TABLE service_pattern.vehicle_mode_on_scheduled_stop_point (
    scheduled_stop_point_id uuid NOT NULL,
    vehicle_mode text NOT NULL
);


ALTER TABLE service_pattern.vehicle_mode_on_scheduled_stop_point OWNER TO dbhasura;

--
-- Name: timing_place; Type: TABLE; Schema: timing_pattern; Owner: dbhasura
--

CREATE TABLE timing_pattern.timing_place (
    timing_place_id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    label text NOT NULL,
    description jsonb
);


ALTER TABLE timing_pattern.timing_place OWNER TO dbhasura;

--
-- Name: infrastructure_link check_infrastructure_link_route_link_direction_trigger; Type: TRIGGER; Schema: infrastructure_network; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER check_infrastructure_link_route_link_direction_trigger AFTER UPDATE ON infrastructure_network.infrastructure_link DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION infrastructure_network.check_infrastructure_link_route_link_direction();

--
-- Name: infrastructure_link check_infrastructure_link_scheduled_stop_points_direction_trigg; Type: TRIGGER; Schema: infrastructure_network; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER check_infrastructure_link_scheduled_stop_points_direction_trigg AFTER UPDATE ON infrastructure_network.infrastructure_link DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION infrastructure_network.check_infrastructure_link_scheduled_stop_points_direction_trigg();

--
-- Name: vehicle_submode_on_infrastructure_link prevent_update_of_vehicle_submode_on_infrastructure_link; Type: TRIGGER; Schema: infrastructure_network; Owner: dbhasura
--

CREATE TRIGGER prevent_update_of_vehicle_submode_on_infrastructure_link BEFORE UPDATE ON infrastructure_network.vehicle_submode_on_infrastructure_link FOR EACH ROW EXECUTE FUNCTION internal_utils.prevent_update();

--
-- Name: vehicle_submode_on_infrastructure_link scheduled_stop_point_vehicle_mode_by_infra_link_trigger; Type: TRIGGER; Schema: infrastructure_network; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER scheduled_stop_point_vehicle_mode_by_infra_link_trigger AFTER DELETE ON infrastructure_network.vehicle_submode_on_infrastructure_link DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION service_pattern.check_scheduled_stop_point_vehicle_mode_by_infra_link();

--
-- Name: journey_pattern queue_verify_infra_link_stop_refs_on_jp_update_trigger; Type: TRIGGER; Schema: journey_pattern; Owner: dbhasura
--

CREATE TRIGGER queue_verify_infra_link_stop_refs_on_jp_update_trigger AFTER UPDATE ON journey_pattern.journey_pattern REFERENCING NEW TABLE AS new_table FOR EACH STATEMENT EXECUTE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_journey_pattern_id();

--
-- Name: journey_pattern verify_infra_link_stop_refs_on_journey_pattern_trigger; Type: TRIGGER; Schema: journey_pattern; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER verify_infra_link_stop_refs_on_journey_pattern_trigger AFTER UPDATE ON journey_pattern.journey_pattern DEFERRABLE INITIALLY DEFERRED FOR EACH ROW WHEN ((NOT journey_pattern.infra_link_stop_refs_already_verified())) EXECUTE FUNCTION journey_pattern.verify_infra_link_stop_refs();

--
-- Name: scheduled_stop_point_in_journey_pattern queue_verify_infra_link_stop_refs_on_sspijp_insert_trigger; Type: TRIGGER; Schema: journey_pattern; Owner: dbhasura
--

CREATE TRIGGER queue_verify_infra_link_stop_refs_on_sspijp_insert_trigger AFTER INSERT ON journey_pattern.scheduled_stop_point_in_journey_pattern REFERENCING NEW TABLE AS new_table FOR EACH STATEMENT EXECUTE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_journey_pattern_id();

--
-- Name: scheduled_stop_point_in_journey_pattern queue_verify_infra_link_stop_refs_on_sspijp_update_trigger; Type: TRIGGER; Schema: journey_pattern; Owner: dbhasura
--

CREATE TRIGGER queue_verify_infra_link_stop_refs_on_sspijp_update_trigger AFTER UPDATE ON journey_pattern.scheduled_stop_point_in_journey_pattern REFERENCING NEW TABLE AS new_table FOR EACH STATEMENT EXECUTE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_journey_pattern_id();

--
-- Name: scheduled_stop_point_in_journey_pattern scheduled_stop_point_has_timing_place_if_used_as_timing_point_t; Type: TRIGGER; Schema: journey_pattern; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER scheduled_stop_point_has_timing_place_if_used_as_timing_point_t AFTER INSERT OR UPDATE ON journey_pattern.scheduled_stop_point_in_journey_pattern DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION journey_pattern.scheduled_stop_point_has_timing_place_if_used_as_timing_point();

--
-- Name: scheduled_stop_point_in_journey_pattern verify_infra_link_stop_refs_on_sspijp_trigger; Type: TRIGGER; Schema: journey_pattern; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER verify_infra_link_stop_refs_on_sspijp_trigger AFTER INSERT OR UPDATE ON journey_pattern.scheduled_stop_point_in_journey_pattern DEFERRABLE INITIALLY DEFERRED FOR EACH ROW WHEN ((NOT journey_pattern.infra_link_stop_refs_already_verified())) EXECUTE FUNCTION journey_pattern.verify_infra_link_stop_refs();

--
-- Name: infrastructure_link_along_route check_route_link_infrastructure_link_direction_trigger; Type: TRIGGER; Schema: route; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER check_route_link_infrastructure_link_direction_trigger AFTER INSERT OR UPDATE ON route.infrastructure_link_along_route DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION route.check_route_link_infrastructure_link_direction();

--
-- Name: infrastructure_link_along_route queue_verify_infra_link_stop_refs_on_ilar_delete_trigger; Type: TRIGGER; Schema: route; Owner: dbhasura
--

CREATE TRIGGER queue_verify_infra_link_stop_refs_on_ilar_delete_trigger AFTER DELETE ON route.infrastructure_link_along_route REFERENCING OLD TABLE AS old_table FOR EACH STATEMENT EXECUTE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_id();

--
-- Name: infrastructure_link_along_route queue_verify_infra_link_stop_refs_on_ilar_update_trigger; Type: TRIGGER; Schema: route; Owner: dbhasura
--

CREATE TRIGGER queue_verify_infra_link_stop_refs_on_ilar_update_trigger AFTER UPDATE ON route.infrastructure_link_along_route REFERENCING OLD TABLE AS old_table FOR EACH STATEMENT EXECUTE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_id();

--
-- Name: infrastructure_link_along_route truncate_sspijp_on_ilar_truncate_trigger; Type: TRIGGER; Schema: route; Owner: dbhasura
--

CREATE TRIGGER truncate_sspijp_on_ilar_truncate_trigger AFTER TRUNCATE ON route.infrastructure_link_along_route FOR EACH STATEMENT EXECUTE FUNCTION journey_pattern.truncate_scheduled_stop_point_in_journey_pattern();

--
-- Name: infrastructure_link_along_route verify_infra_link_stop_refs_on_ilar_trigger; Type: TRIGGER; Schema: route; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER verify_infra_link_stop_refs_on_ilar_trigger AFTER DELETE OR UPDATE ON route.infrastructure_link_along_route DEFERRABLE INITIALLY DEFERRED FOR EACH ROW WHEN ((NOT journey_pattern.infra_link_stop_refs_already_verified())) EXECUTE FUNCTION journey_pattern.verify_infra_link_stop_refs();

--
-- Name: line check_line_routes_priorities_trigger; Type: TRIGGER; Schema: route; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER check_line_routes_priorities_trigger AFTER UPDATE ON route.line DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION route.check_line_routes_priorities();

--
-- Name: line check_line_validity_against_all_associated_routes_trigger; Type: TRIGGER; Schema: route; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER check_line_validity_against_all_associated_routes_trigger AFTER UPDATE ON route.line DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION route.check_line_validity_against_all_associated_routes();

--
-- Name: line check_type_of_line_vehicle_mode_trigger; Type: TRIGGER; Schema: route; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER check_type_of_line_vehicle_mode_trigger AFTER INSERT OR UPDATE ON route.line DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION route.check_type_of_line_vehicle_mode();

--
-- Name: route check_route_line_priorities_trigger; Type: TRIGGER; Schema: route; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER check_route_line_priorities_trigger AFTER INSERT OR UPDATE ON route.route DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION route.check_route_line_priorities();

--
-- Name: route check_route_validity_is_within_line_validity_trigger; Type: TRIGGER; Schema: route; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER check_route_validity_is_within_line_validity_trigger AFTER INSERT OR UPDATE ON route.route DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION route.check_route_validity_is_within_line_validity();

--
-- Name: route queue_verify_infra_link_stop_refs_on_route_delete_trigger; Type: TRIGGER; Schema: route; Owner: dbhasura
--

CREATE TRIGGER queue_verify_infra_link_stop_refs_on_route_delete_trigger AFTER DELETE ON route.route REFERENCING OLD TABLE AS old_table FOR EACH STATEMENT EXECUTE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_label();

--
-- Name: route verify_infra_link_stop_refs_on_route_trigger; Type: TRIGGER; Schema: route; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER verify_infra_link_stop_refs_on_route_trigger AFTER DELETE ON route.route DEFERRABLE INITIALLY DEFERRED FOR EACH ROW WHEN ((NOT journey_pattern.infra_link_stop_refs_already_verified())) EXECUTE FUNCTION journey_pattern.verify_infra_link_stop_refs();

--
-- Name: distance_between_stops_calculation prevent_insertion_to_distance_between_stops_calculation; Type: TRIGGER; Schema: service_pattern; Owner: dbhasura
--

CREATE TRIGGER prevent_insertion_to_distance_between_stops_calculation BEFORE INSERT ON service_pattern.distance_between_stops_calculation FOR EACH ROW EXECUTE FUNCTION service_pattern.prevent_inserting_distance_between_stops_calculation();

--
-- Name: scheduled_stop_point check_scheduled_stop_point_infrastructure_link_direction_trigge; Type: TRIGGER; Schema: service_pattern; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER check_scheduled_stop_point_infrastructure_link_direction_trigge AFTER INSERT OR UPDATE ON service_pattern.scheduled_stop_point DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION service_pattern.check_scheduled_stop_point_infrastructure_link_direction();

--
-- Name: scheduled_stop_point queue_verify_infra_link_stop_refs_on_ssp_delete_trigger; Type: TRIGGER; Schema: service_pattern; Owner: dbhasura
--

CREATE TRIGGER queue_verify_infra_link_stop_refs_on_ssp_delete_trigger AFTER DELETE ON service_pattern.scheduled_stop_point REFERENCING OLD TABLE AS old_table FOR EACH STATEMENT EXECUTE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_ssp_label();

--
-- Name: scheduled_stop_point queue_verify_infra_link_stop_refs_on_ssp_insert_trigger; Type: TRIGGER; Schema: service_pattern; Owner: dbhasura
--

CREATE TRIGGER queue_verify_infra_link_stop_refs_on_ssp_insert_trigger AFTER INSERT ON service_pattern.scheduled_stop_point REFERENCING NEW TABLE AS new_table FOR EACH STATEMENT EXECUTE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_ssp_label();

--
-- Name: scheduled_stop_point queue_verify_infra_link_stop_refs_on_ssp_update_trigger; Type: TRIGGER; Schema: service_pattern; Owner: dbhasura
--

CREATE TRIGGER queue_verify_infra_link_stop_refs_on_ssp_update_trigger AFTER UPDATE ON service_pattern.scheduled_stop_point REFERENCING NEW TABLE AS new_table FOR EACH STATEMENT EXECUTE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_ssp_label();

--
-- Name: scheduled_stop_point scheduled_stop_point_has_timing_place_if_used_as_timing_point_t; Type: TRIGGER; Schema: service_pattern; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER scheduled_stop_point_has_timing_place_if_used_as_timing_point_t AFTER INSERT OR UPDATE ON service_pattern.scheduled_stop_point DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION journey_pattern.scheduled_stop_point_has_timing_place_if_used_as_timing_point();

--
-- Name: scheduled_stop_point scheduled_stop_point_vehicle_mode_by_scheduled_stop_point_trigg; Type: TRIGGER; Schema: service_pattern; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER scheduled_stop_point_vehicle_mode_by_scheduled_stop_point_trigg AFTER INSERT OR UPDATE ON service_pattern.scheduled_stop_point DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION service_pattern.check_scheduled_stop_point_vehicle_mode_by_scheduled_stop_point();

--
-- Name: scheduled_stop_point service_pattern_delete_scheduled_stop_point_trigger; Type: TRIGGER; Schema: service_pattern; Owner: dbhasura
--

CREATE TRIGGER service_pattern_delete_scheduled_stop_point_trigger AFTER DELETE ON service_pattern.scheduled_stop_point FOR EACH ROW EXECUTE FUNCTION service_pattern.on_delete_scheduled_stop_point();

--
-- Name: scheduled_stop_point service_pattern_insert_scheduled_stop_point_trigger; Type: TRIGGER; Schema: service_pattern; Owner: dbhasura
--

CREATE TRIGGER service_pattern_insert_scheduled_stop_point_trigger BEFORE INSERT ON service_pattern.scheduled_stop_point FOR EACH ROW EXECUTE FUNCTION service_pattern.on_insert_scheduled_stop_point();

--
-- Name: scheduled_stop_point service_pattern_update_scheduled_stop_point_trigger; Type: TRIGGER; Schema: service_pattern; Owner: dbhasura
--

CREATE TRIGGER service_pattern_update_scheduled_stop_point_trigger BEFORE UPDATE ON service_pattern.scheduled_stop_point FOR EACH ROW EXECUTE FUNCTION service_pattern.on_update_scheduled_stop_point();

--
-- Name: scheduled_stop_point verify_infra_link_stop_refs_on_scheduled_stop_point_trigger; Type: TRIGGER; Schema: service_pattern; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER verify_infra_link_stop_refs_on_scheduled_stop_point_trigger AFTER INSERT OR DELETE OR UPDATE ON service_pattern.scheduled_stop_point DEFERRABLE INITIALLY DEFERRED FOR EACH ROW WHEN ((NOT journey_pattern.infra_link_stop_refs_already_verified())) EXECUTE FUNCTION journey_pattern.verify_infra_link_stop_refs();

--
-- Name: vehicle_mode_on_scheduled_stop_point prevent_update_of_vehicle_mode_on_scheduled_stop_point; Type: TRIGGER; Schema: service_pattern; Owner: dbhasura
--

CREATE TRIGGER prevent_update_of_vehicle_mode_on_scheduled_stop_point BEFORE UPDATE ON service_pattern.vehicle_mode_on_scheduled_stop_point FOR EACH ROW EXECUTE FUNCTION internal_utils.prevent_update();

--
-- Name: vehicle_mode_on_scheduled_stop_point scheduled_stop_point_vehicle_mode_by_vehicle_mode_trigger; Type: TRIGGER; Schema: service_pattern; Owner: dbhasura
--

CREATE CONSTRAINT TRIGGER scheduled_stop_point_vehicle_mode_by_vehicle_mode_trigger AFTER DELETE ON service_pattern.vehicle_mode_on_scheduled_stop_point DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION service_pattern.check_scheduled_stop_point_vehicle_mode_by_vehicle_mode();

--
-- Sorted dump complete
--
