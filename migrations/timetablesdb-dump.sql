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
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';

--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';

--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';

--
-- Name: SCHEMA journey_pattern; Type: COMMENT; Schema: -; Owner: dbhasura
--

COMMENT ON SCHEMA journey_pattern IS 'The journey pattern model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:1:683 ';

--
-- Name: SCHEMA passing_times; Type: COMMENT; Schema: -; Owner: dbhasura
--

COMMENT ON SCHEMA passing_times IS 'The passing times model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=3:4:939 ';

--
-- Name: SCHEMA service_calendar; Type: COMMENT; Schema: -; Owner: dbhasura
--

COMMENT ON SCHEMA service_calendar IS 'The service calendar model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=1:6:3:294 ';

--
-- Name: SCHEMA service_pattern; Type: COMMENT; Schema: -; Owner: dbhasura
--

COMMENT ON SCHEMA service_pattern IS 'The service pattern model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:4:723 ';

--
-- Name: SCHEMA vehicle_journey; Type: COMMENT; Schema: -; Owner: dbhasura
--

COMMENT ON SCHEMA vehicle_journey IS 'The vehicle journey model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=3:1:1:824 ';

--
-- Name: SCHEMA vehicle_schedule; Type: COMMENT; Schema: -; Owner: dbhasura
--

COMMENT ON SCHEMA vehicle_schedule IS 'The vehicle schedule frame adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=3:7:2:993 ';

--
-- Name: SCHEMA vehicle_service; Type: COMMENT; Schema: -; Owner: dbhasura
--

COMMENT ON SCHEMA vehicle_service IS 'The vehicle service model adapted from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=3:5:947 ';

--
-- Name: COLUMN journey_pattern_ref.journey_pattern_id; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON COLUMN journey_pattern.journey_pattern_ref.journey_pattern_id IS 'The ID of the referenced JOURNEY PATTERN';

--
-- Name: COLUMN journey_pattern_ref.observation_timestamp; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON COLUMN journey_pattern.journey_pattern_ref.observation_timestamp IS 'The user-given point of time used to pick one journey pattern (with route and scheduled stop points) among possibly many variants. The selected, unambiguous journey pattern variant is used as a basis for schedule planning.';

--
-- Name: COLUMN journey_pattern_ref.snapshot_timestamp; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON COLUMN journey_pattern.journey_pattern_ref.snapshot_timestamp IS 'The timestamp when the snapshot was taken';

--
-- Name: TABLE journey_pattern_ref; Type: COMMENT; Schema: journey_pattern; Owner: dbhasura
--

COMMENT ON TABLE journey_pattern.journey_pattern_ref IS 'Reference to a given snapshot of a JOURNEY PATTERN for a given operating day. Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:4:729 ';

--
-- Name: COLUMN timetabled_passing_time.arrival_time; Type: COMMENT; Schema: passing_times; Owner: dbhasura
--

COMMENT ON COLUMN passing_times.timetabled_passing_time.arrival_time IS 'The time when the vehicle arrives to the SCHEDULED STOP POINT. Measured as interval counted from the midnight of the OPERATING DAY. When NULL, only the departure time is defined for the passing time. E.g. in case this is the first SCHEDULED STOP POINT of the journey.';

--
-- Name: COLUMN timetabled_passing_time.departure_time; Type: COMMENT; Schema: passing_times; Owner: dbhasura
--

COMMENT ON COLUMN passing_times.timetabled_passing_time.departure_time IS 'The time when the vehicle departs from the SCHEDULED STOP POINT. Measured as interval counted from the midnight of the OPERATING DAY. When NULL, only the arrival time is defined for the passing time. E.g. in case this is the last SCHEDULED STOP POINT of the journey.';

--
-- Name: COLUMN timetabled_passing_time.passing_time; Type: COMMENT; Schema: passing_times; Owner: dbhasura
--

COMMENT ON COLUMN passing_times.timetabled_passing_time.passing_time IS 'The time when the vehicle can be considered as passing a SCHEDULED STOP POINT. Computed field to ease development; it can never be NULL.';

--
-- Name: COLUMN timetabled_passing_time.scheduled_stop_point_in_journey_pattern_ref_id; Type: COMMENT; Schema: passing_times; Owner: dbhasura
--

COMMENT ON COLUMN passing_times.timetabled_passing_time.scheduled_stop_point_in_journey_pattern_ref_id IS 'The SCHEDULED STOP POINT of the JOURNEY PATTERN where the vehicle passes';

--
-- Name: COLUMN timetabled_passing_time.vehicle_journey_id; Type: COMMENT; Schema: passing_times; Owner: dbhasura
--

COMMENT ON COLUMN passing_times.timetabled_passing_time.vehicle_journey_id IS 'The VEHICLE JOURNEY to which this TIMETABLED PASSING TIME belongs';

--
-- Name: TABLE timetabled_passing_time; Type: COMMENT; Schema: passing_times; Owner: dbhasura
--

COMMENT ON TABLE passing_times.timetabled_passing_time IS 'Long-term planned time data concerning public transport vehicles passing a particular POINT IN JOURNEY PATTERN on a specified VEHICLE JOURNEY for a certain DAY TYPE. Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=3:4:946 ';

--
-- Name: COLUMN day_type.label; Type: COMMENT; Schema: service_calendar; Owner: dbhasura
--

COMMENT ON COLUMN service_calendar.day_type.label IS 'The label for the DAY TYPE. Used for identifying the DAY TYPE when importing data from Hastus. Includes both basic (e.g. "Monday-Thursday") and special ("Easter Sunday") day types';

--
-- Name: COLUMN day_type.name_i18n; Type: COMMENT; Schema: service_calendar; Owner: dbhasura
--

COMMENT ON COLUMN service_calendar.day_type.name_i18n IS 'Human-readable name for the DAY TYPE';

--
-- Name: COLUMN day_type_active_on_day_of_week.day_of_week; Type: COMMENT; Schema: service_calendar; Owner: dbhasura
--

COMMENT ON COLUMN service_calendar.day_type_active_on_day_of_week.day_of_week IS 'ISO week day definition (1 = Monday, 7 = Sunday)';

--
-- Name: COLUMN day_type_active_on_day_of_week.day_type_id; Type: COMMENT; Schema: service_calendar; Owner: dbhasura
--

COMMENT ON COLUMN service_calendar.day_type_active_on_day_of_week.day_type_id IS 'The DAY TYPE for which we define the activeness';

--
-- Name: FUNCTION default_timezone(); Type: COMMENT; Schema: service_calendar; Owner: dbhasura
--

COMMENT ON FUNCTION service_calendar.default_timezone() IS 'Get the default timezone of service calendar.';

--
-- Name: FUNCTION operating_day_end_time(); Type: COMMENT; Schema: service_calendar; Owner: dbhasura
--

COMMENT ON FUNCTION service_calendar.operating_day_end_time() IS 'Get the (exclusive) end time of operating day.';

--
-- Name: FUNCTION operating_day_start_time(); Type: COMMENT; Schema: service_calendar; Owner: dbhasura
--

COMMENT ON FUNCTION service_calendar.operating_day_start_time() IS 'Get the (inclusive) start time of operating day.';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: TABLE day_type; Type: COMMENT; Schema: service_calendar; Owner: dbhasura
--

COMMENT ON TABLE service_calendar.day_type IS 'A type of day characterised by one or more properties which affect public transport operation. For example: weekday in school holidays. Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=1:6:3:299 ';

--
-- Name: TABLE day_type_active_on_day_of_week; Type: COMMENT; Schema: service_calendar; Owner: dbhasura
--

COMMENT ON TABLE service_calendar.day_type_active_on_day_of_week IS 'Tells on which days of week a particular DAY TYPE is active';

--
-- Name: COLUMN scheduled_stop_point_in_journey_pattern_ref.journey_pattern_ref_id; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.scheduled_stop_point_in_journey_pattern_ref.journey_pattern_ref_id IS 'JOURNEY PATTERN to which the SCHEDULED STOP POINT belongs';

--
-- Name: COLUMN scheduled_stop_point_in_journey_pattern_ref.scheduled_stop_point_label; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.scheduled_stop_point_in_journey_pattern_ref.scheduled_stop_point_label IS 'The label of the SCHEDULED STOP POINT';

--
-- Name: COLUMN scheduled_stop_point_in_journey_pattern_ref.scheduled_stop_point_sequence; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON COLUMN service_pattern.scheduled_stop_point_in_journey_pattern_ref.scheduled_stop_point_sequence IS 'The order of the SCHEDULED STOP POINT within the JOURNEY PATTERN.';

--
-- Name: TABLE scheduled_stop_point_in_journey_pattern_ref; Type: COMMENT; Schema: service_pattern; Owner: dbhasura
--

COMMENT ON TABLE service_pattern.scheduled_stop_point_in_journey_pattern_ref IS 'Reference the a SCHEDULED STOP POINT within a JOURNEY PATTERN. Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=2:3:4:729 ';

--
-- Name: COLUMN vehicle_journey.block_id; Type: COMMENT; Schema: vehicle_journey; Owner: dbhasura
--

COMMENT ON COLUMN vehicle_journey.vehicle_journey.block_id IS 'The BLOCK to which this VEHICLE JOURNEY belongs';

--
-- Name: COLUMN vehicle_journey.journey_pattern_ref_id; Type: COMMENT; Schema: vehicle_journey; Owner: dbhasura
--

COMMENT ON COLUMN vehicle_journey.vehicle_journey.journey_pattern_ref_id IS 'The JOURNEY PATTERN on which the VEHICLE JOURNEY travels';

--
-- Name: TABLE vehicle_journey; Type: COMMENT; Schema: vehicle_journey; Owner: dbhasura
--

COMMENT ON TABLE vehicle_journey.vehicle_journey IS 'The planned movement of a public transport vehicle on a DAY TYPE from the start point to the end point of a JOURNEY PATTERN on a specified ROUTE. Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=3:1:1:831 ';

--
-- Name: COLUMN vehicle_schedule_frame.name_i18n; Type: COMMENT; Schema: vehicle_schedule; Owner: dbhasura
--

COMMENT ON COLUMN vehicle_schedule.vehicle_schedule_frame.name_i18n IS 'Human-readable name for the VEHICLE SCHEDULE FRAME';

--
-- Name: COLUMN vehicle_schedule_frame.priority; Type: COMMENT; Schema: vehicle_schedule; Owner: dbhasura
--

COMMENT ON COLUMN vehicle_schedule.vehicle_schedule_frame.priority IS 'The priority of the timetable definition. The definition may be overridden by higher priority definitions.';

--
-- Name: COLUMN vehicle_schedule_frame.validity_end; Type: COMMENT; Schema: vehicle_schedule; Owner: dbhasura
--

COMMENT ON COLUMN vehicle_schedule.vehicle_schedule_frame.validity_end IS 'OPERATING DAY when the VEHICLE SCHEDULE FRAME validity end. Null if always will be valid.';

--
-- Name: COLUMN vehicle_schedule_frame.validity_start; Type: COMMENT; Schema: vehicle_schedule; Owner: dbhasura
--

COMMENT ON COLUMN vehicle_schedule.vehicle_schedule_frame.validity_start IS 'OPERATING DAY when the VEHICLE SCHEDULE FRAME validity starts. Null if always has been valid.';

--
-- Name: TABLE vehicle_schedule_frame; Type: COMMENT; Schema: vehicle_schedule; Owner: dbhasura
--

COMMENT ON TABLE vehicle_schedule.vehicle_schedule_frame IS 'A coherent set of BLOCKS, COMPOUND BLOCKs, COURSEs of JOURNEY and VEHICLE SCHEDULEs to which the same set of VALIDITY CONDITIONs have been assigned. Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=3:7:2:993 ';

--
-- Name: COLUMN block.vehicle_service_id; Type: COMMENT; Schema: vehicle_service; Owner: dbhasura
--

COMMENT ON COLUMN vehicle_service.block.vehicle_service_id IS 'The VEHICLE SERVICE to which this BLOCK belongs.';

--
-- Name: COLUMN vehicle_service.day_type_id; Type: COMMENT; Schema: vehicle_service; Owner: dbhasura
--

COMMENT ON COLUMN vehicle_service.vehicle_service.day_type_id IS 'The DAY TYPE for the VEHICLE SERVICE.';

--
-- Name: COLUMN vehicle_service.vehicle_schedule_frame_id; Type: COMMENT; Schema: vehicle_service; Owner: dbhasura
--

COMMENT ON COLUMN vehicle_service.vehicle_service.vehicle_schedule_frame_id IS 'Human-readable name for the VEHICLE SCHEDULE FRAME';

--
-- Name: TABLE block; Type: COMMENT; Schema: vehicle_service; Owner: dbhasura
--

COMMENT ON TABLE vehicle_service.block IS 'The work of a vehicle from the time it leaves a PARKING POINT after parking until its next return to park at a PARKING POINT. Any subsequent departure from a PARKING POINT after parking marks the start of a new BLOCK. The period of a BLOCK has to be covered by DUTies. Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=3:5:958 ';

--
-- Name: TABLE vehicle_service; Type: COMMENT; Schema: vehicle_service; Owner: dbhasura
--

COMMENT ON TABLE vehicle_service.vehicle_service IS 'A work plan for a single vehicle for a whole day, planned for a specific DAY TYPE. A VEHICLE SERVICE includes one or several BLOCKs. If there is no service on a given day, it does not include any BLOCKs. Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=3:5:965 ';

--
-- Name: journey_pattern_ref journey_pattern_ref_pkey; Type: CONSTRAINT; Schema: journey_pattern; Owner: dbhasura
--

ALTER TABLE ONLY journey_pattern.journey_pattern_ref
    ADD CONSTRAINT journey_pattern_ref_pkey PRIMARY KEY (journey_pattern_ref_id);

--
-- Name: timetabled_passing_time timetabled_passing_time_pkey; Type: CONSTRAINT; Schema: passing_times; Owner: dbhasura
--

ALTER TABLE ONLY passing_times.timetabled_passing_time
    ADD CONSTRAINT timetabled_passing_time_pkey PRIMARY KEY (timetabled_passing_time_id);

--
-- Name: day_type day_type_pkey; Type: CONSTRAINT; Schema: service_calendar; Owner: dbhasura
--

ALTER TABLE ONLY service_calendar.day_type
    ADD CONSTRAINT day_type_pkey PRIMARY KEY (day_type_id);

--
-- Name: day_type_active_on_day_of_week day_type_active_on_day_of_week_pkey; Type: CONSTRAINT; Schema: service_calendar; Owner: dbhasura
--

ALTER TABLE ONLY service_calendar.day_type_active_on_day_of_week
    ADD CONSTRAINT day_type_active_on_day_of_week_pkey PRIMARY KEY (day_type_id, day_of_week);

--
-- Name: scheduled_stop_point_in_journey_pattern_ref scheduled_stop_point_in_journey_pattern_ref_pkey; Type: CONSTRAINT; Schema: service_pattern; Owner: dbhasura
--

ALTER TABLE ONLY service_pattern.scheduled_stop_point_in_journey_pattern_ref
    ADD CONSTRAINT scheduled_stop_point_in_journey_pattern_ref_pkey PRIMARY KEY (scheduled_stop_point_in_journey_pattern_ref_id);

--
-- Name: vehicle_journey vehicle_journey_pkey; Type: CONSTRAINT; Schema: vehicle_journey; Owner: dbhasura
--

ALTER TABLE ONLY vehicle_journey.vehicle_journey
    ADD CONSTRAINT vehicle_journey_pkey PRIMARY KEY (vehicle_journey_id);

--
-- Name: vehicle_schedule_frame vehicle_schedule_frame_pkey; Type: CONSTRAINT; Schema: vehicle_schedule; Owner: dbhasura
--

ALTER TABLE ONLY vehicle_schedule.vehicle_schedule_frame
    ADD CONSTRAINT vehicle_schedule_frame_pkey PRIMARY KEY (vehicle_schedule_frame_id);

--
-- Name: block block_pkey; Type: CONSTRAINT; Schema: vehicle_service; Owner: dbhasura
--

ALTER TABLE ONLY vehicle_service.block
    ADD CONSTRAINT block_pkey PRIMARY KEY (block_id);

--
-- Name: vehicle_service vehicle_service_pkey; Type: CONSTRAINT; Schema: vehicle_service; Owner: dbhasura
--

ALTER TABLE ONLY vehicle_service.vehicle_service
    ADD CONSTRAINT vehicle_service_pkey PRIMARY KEY (vehicle_service_id);

--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;

--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;

--
-- Name: timetabled_passing_time timetabled_passing_time_scheduled_stop_point_in_journey_pa_fkey; Type: FK CONSTRAINT; Schema: passing_times; Owner: dbhasura
--

ALTER TABLE ONLY passing_times.timetabled_passing_time
    ADD CONSTRAINT timetabled_passing_time_scheduled_stop_point_in_journey_pa_fkey FOREIGN KEY (scheduled_stop_point_in_journey_pattern_ref_id) REFERENCES service_pattern.scheduled_stop_point_in_journey_pattern_ref(scheduled_stop_point_in_journey_pattern_ref_id);

--
-- Name: timetabled_passing_time timetabled_passing_time_vehicle_journey_id_fkey; Type: FK CONSTRAINT; Schema: passing_times; Owner: dbhasura
--

ALTER TABLE ONLY passing_times.timetabled_passing_time
    ADD CONSTRAINT timetabled_passing_time_vehicle_journey_id_fkey FOREIGN KEY (vehicle_journey_id) REFERENCES vehicle_journey.vehicle_journey(vehicle_journey_id);

--
-- Name: day_type_active_on_day_of_week day_type_active_on_day_of_week_day_type_id_fkey; Type: FK CONSTRAINT; Schema: service_calendar; Owner: dbhasura
--

ALTER TABLE ONLY service_calendar.day_type_active_on_day_of_week
    ADD CONSTRAINT day_type_active_on_day_of_week_day_type_id_fkey FOREIGN KEY (day_type_id) REFERENCES service_calendar.day_type(day_type_id);

--
-- Name: scheduled_stop_point_in_journey_pattern_ref scheduled_stop_point_in_journey_pat_journey_pattern_ref_id_fkey; Type: FK CONSTRAINT; Schema: service_pattern; Owner: dbhasura
--

ALTER TABLE ONLY service_pattern.scheduled_stop_point_in_journey_pattern_ref
    ADD CONSTRAINT scheduled_stop_point_in_journey_pat_journey_pattern_ref_id_fkey FOREIGN KEY (journey_pattern_ref_id) REFERENCES journey_pattern.journey_pattern_ref(journey_pattern_ref_id);

--
-- Name: vehicle_journey vehicle_journey_block_id_fkey; Type: FK CONSTRAINT; Schema: vehicle_journey; Owner: dbhasura
--

ALTER TABLE ONLY vehicle_journey.vehicle_journey
    ADD CONSTRAINT vehicle_journey_block_id_fkey FOREIGN KEY (block_id) REFERENCES vehicle_service.block(block_id);

--
-- Name: vehicle_journey vehicle_journey_journey_pattern_ref_id_fkey; Type: FK CONSTRAINT; Schema: vehicle_journey; Owner: dbhasura
--

ALTER TABLE ONLY vehicle_journey.vehicle_journey
    ADD CONSTRAINT vehicle_journey_journey_pattern_ref_id_fkey FOREIGN KEY (journey_pattern_ref_id) REFERENCES journey_pattern.journey_pattern_ref(journey_pattern_ref_id);

--
-- Name: block block_vehicle_service_id_fkey; Type: FK CONSTRAINT; Schema: vehicle_service; Owner: dbhasura
--

ALTER TABLE ONLY vehicle_service.block
    ADD CONSTRAINT block_vehicle_service_id_fkey FOREIGN KEY (vehicle_service_id) REFERENCES vehicle_service.vehicle_service(vehicle_service_id);

--
-- Name: vehicle_service vehicle_service_day_type_id_fkey; Type: FK CONSTRAINT; Schema: vehicle_service; Owner: dbhasura
--

ALTER TABLE ONLY vehicle_service.vehicle_service
    ADD CONSTRAINT vehicle_service_day_type_id_fkey FOREIGN KEY (day_type_id) REFERENCES service_calendar.day_type(day_type_id);

--
-- Name: vehicle_service vehicle_service_vehicle_schedule_frame_id_fkey; Type: FK CONSTRAINT; Schema: vehicle_service; Owner: dbhasura
--

ALTER TABLE ONLY vehicle_service.vehicle_service
    ADD CONSTRAINT vehicle_service_vehicle_schedule_frame_id_fkey FOREIGN KEY (vehicle_schedule_frame_id) REFERENCES vehicle_schedule.vehicle_schedule_frame(vehicle_schedule_frame_id);

--
-- Name: default_timezone(); Type: FUNCTION; Schema: service_calendar; Owner: dbhasura
--

CREATE FUNCTION service_calendar.default_timezone() RETURNS text
    LANGUAGE sql IMMUTABLE PARALLEL SAFE
    AS $$
SELECT 'Europe/Helsinki'
$$;


ALTER FUNCTION service_calendar.default_timezone() OWNER TO dbhasura;

--
-- Name: operating_day_end_time(); Type: FUNCTION; Schema: service_calendar; Owner: dbhasura
--

CREATE FUNCTION service_calendar.operating_day_end_time() RETURNS interval
    LANGUAGE sql IMMUTABLE PARALLEL SAFE
    AS $$
SELECT interval '28:30:00'
$$;


ALTER FUNCTION service_calendar.operating_day_end_time() OWNER TO dbhasura;

--
-- Name: operating_day_start_time(); Type: FUNCTION; Schema: service_calendar; Owner: dbhasura
--

CREATE FUNCTION service_calendar.operating_day_start_time() RETURNS interval
    LANGUAGE sql IMMUTABLE PARALLEL SAFE
    AS $$
SELECT interval '04:30:00'
$$;


ALTER FUNCTION service_calendar.operating_day_start_time() OWNER TO dbhasura;

--
-- Name: vehicle_journey_end_time(vehicle_journey.vehicle_journey); Type: FUNCTION; Schema: vehicle_journey; Owner: dbhasura
--

CREATE FUNCTION vehicle_journey.vehicle_journey_end_time(vj vehicle_journey.vehicle_journey) RETURNS text
    LANGUAGE sql STABLE
    AS $$
  SELECT MAX (arrival_time)::text AS end_time
  FROM passing_times.timetabled_passing_time tpt
  WHERE tpt.vehicle_journey_id = vj.vehicle_journey_id;
$$;


ALTER FUNCTION vehicle_journey.vehicle_journey_end_time(vj vehicle_journey.vehicle_journey) OWNER TO dbhasura;

--
-- Name: vehicle_journey_start_time(vehicle_journey.vehicle_journey); Type: FUNCTION; Schema: vehicle_journey; Owner: dbhasura
--

CREATE FUNCTION vehicle_journey.vehicle_journey_start_time(vj vehicle_journey.vehicle_journey) RETURNS text
    LANGUAGE sql STABLE
    AS $$
  SELECT MIN (departure_time)::text AS start_time
  FROM passing_times.timetabled_passing_time tpt
  WHERE tpt.vehicle_journey_id = vj.vehicle_journey_id;
$$;


ALTER FUNCTION vehicle_journey.vehicle_journey_start_time(vj vehicle_journey.vehicle_journey) OWNER TO dbhasura;

--
-- Name: idx_timetabled_passing_time_sspijp_ref; Type: INDEX; Schema: passing_times; Owner: dbhasura
--

CREATE INDEX idx_timetabled_passing_time_sspijp_ref ON passing_times.timetabled_passing_time USING btree (scheduled_stop_point_in_journey_pattern_ref_id);

--
-- Name: idx_timetabled_passing_time_vehicle_journey; Type: INDEX; Schema: passing_times; Owner: dbhasura
--

CREATE INDEX idx_timetabled_passing_time_vehicle_journey ON passing_times.timetabled_passing_time USING btree (vehicle_journey_id);

--
-- Name: service_calendar_day_type_label_idx; Type: INDEX; Schema: service_calendar; Owner: dbhasura
--

CREATE UNIQUE INDEX service_calendar_day_type_label_idx ON service_calendar.day_type USING btree (label);

--
-- Name: service_pattern_scheduled_stop_point_in_journey_pattern_ref_idx; Type: INDEX; Schema: service_pattern; Owner: dbhasura
--

CREATE UNIQUE INDEX service_pattern_scheduled_stop_point_in_journey_pattern_ref_idx ON service_pattern.scheduled_stop_point_in_journey_pattern_ref USING btree (journey_pattern_ref_id, scheduled_stop_point_sequence);

--
-- Name: idx_vehicle_journey_block; Type: INDEX; Schema: vehicle_journey; Owner: dbhasura
--

CREATE INDEX idx_vehicle_journey_block ON vehicle_journey.vehicle_journey USING btree (block_id);

--
-- Name: idx_vehicle_journey_journey_pattern_ref; Type: INDEX; Schema: vehicle_journey; Owner: dbhasura
--

CREATE INDEX idx_vehicle_journey_journey_pattern_ref ON vehicle_journey.vehicle_journey USING btree (journey_pattern_ref_id);

--
-- Name: idx_block_vehicle_service; Type: INDEX; Schema: vehicle_service; Owner: dbhasura
--

CREATE INDEX idx_block_vehicle_service ON vehicle_service.block USING btree (vehicle_service_id);

--
-- Name: idx_vehicle_service_day_type; Type: INDEX; Schema: vehicle_service; Owner: dbhasura
--

CREATE INDEX idx_vehicle_service_day_type ON vehicle_service.vehicle_service USING btree (day_type_id);

--
-- Name: idx_vehicle_service_vehicle_schedule_frame; Type: INDEX; Schema: vehicle_service; Owner: dbhasura
--

CREATE INDEX idx_vehicle_service_vehicle_schedule_frame ON vehicle_service.vehicle_service USING btree (vehicle_schedule_frame_id);

--
-- Name: journey_pattern; Type: SCHEMA; Schema: -; Owner: dbhasura
--

CREATE SCHEMA journey_pattern;


ALTER SCHEMA journey_pattern OWNER TO dbhasura;

--
-- Name: passing_times; Type: SCHEMA; Schema: -; Owner: dbhasura
--

CREATE SCHEMA passing_times;


ALTER SCHEMA passing_times OWNER TO dbhasura;

--
-- Name: service_calendar; Type: SCHEMA; Schema: -; Owner: dbhasura
--

CREATE SCHEMA service_calendar;


ALTER SCHEMA service_calendar OWNER TO dbhasura;

--
-- Name: service_pattern; Type: SCHEMA; Schema: -; Owner: dbhasura
--

CREATE SCHEMA service_pattern;


ALTER SCHEMA service_pattern OWNER TO dbhasura;

--
-- Name: vehicle_journey; Type: SCHEMA; Schema: -; Owner: dbhasura
--

CREATE SCHEMA vehicle_journey;


ALTER SCHEMA vehicle_journey OWNER TO dbhasura;

--
-- Name: vehicle_schedule; Type: SCHEMA; Schema: -; Owner: dbhasura
--

CREATE SCHEMA vehicle_schedule;


ALTER SCHEMA vehicle_schedule OWNER TO dbhasura;

--
-- Name: vehicle_service; Type: SCHEMA; Schema: -; Owner: dbhasura
--

CREATE SCHEMA vehicle_service;


ALTER SCHEMA vehicle_service OWNER TO dbhasura;

--
-- Name: journey_pattern_ref; Type: TABLE; Schema: journey_pattern; Owner: dbhasura
--

CREATE TABLE journey_pattern.journey_pattern_ref (
    journey_pattern_ref_id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    journey_pattern_id uuid NOT NULL,
    observation_timestamp timestamp with time zone NOT NULL,
    snapshot_timestamp timestamp with time zone NOT NULL
);


ALTER TABLE journey_pattern.journey_pattern_ref OWNER TO dbhasura;

--
-- Name: timetabled_passing_time; Type: TABLE; Schema: passing_times; Owner: dbhasura
--

CREATE TABLE passing_times.timetabled_passing_time (
    timetabled_passing_time_id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    vehicle_journey_id uuid NOT NULL,
    scheduled_stop_point_in_journey_pattern_ref_id uuid NOT NULL,
    arrival_time interval,
    departure_time interval,
    passing_time interval GENERATED ALWAYS AS (COALESCE(departure_time, arrival_time)) STORED NOT NULL,
    CONSTRAINT arrival_or_departure_time_exists CHECK (((arrival_time IS NOT NULL) OR (departure_time IS NOT NULL)))
);


ALTER TABLE passing_times.timetabled_passing_time OWNER TO dbhasura;

--
-- Name: day_type; Type: TABLE; Schema: service_calendar; Owner: dbhasura
--

CREATE TABLE service_calendar.day_type (
    day_type_id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    label text NOT NULL,
    name_i18n jsonb NOT NULL
);


ALTER TABLE service_calendar.day_type OWNER TO dbhasura;

--
-- Name: day_type_active_on_day_of_week; Type: TABLE; Schema: service_calendar; Owner: dbhasura
--

CREATE TABLE service_calendar.day_type_active_on_day_of_week (
    day_type_id uuid NOT NULL,
    day_of_week integer NOT NULL,
    CONSTRAINT day_type_active_on_day_of_week_day_of_week_check CHECK (((day_of_week >= 1) AND (day_of_week <= 7)))
);


ALTER TABLE service_calendar.day_type_active_on_day_of_week OWNER TO dbhasura;

--
-- Name: scheduled_stop_point_in_journey_pattern_ref; Type: TABLE; Schema: service_pattern; Owner: dbhasura
--

CREATE TABLE service_pattern.scheduled_stop_point_in_journey_pattern_ref (
    scheduled_stop_point_in_journey_pattern_ref_id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    journey_pattern_ref_id uuid NOT NULL,
    scheduled_stop_point_label text NOT NULL,
    scheduled_stop_point_sequence integer NOT NULL
);


ALTER TABLE service_pattern.scheduled_stop_point_in_journey_pattern_ref OWNER TO dbhasura;

--
-- Name: vehicle_journey; Type: TABLE; Schema: vehicle_journey; Owner: dbhasura
--

CREATE TABLE vehicle_journey.vehicle_journey (
    vehicle_journey_id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    journey_pattern_ref_id uuid NOT NULL,
    block_id uuid NOT NULL
);


ALTER TABLE vehicle_journey.vehicle_journey OWNER TO dbhasura;

--
-- Name: vehicle_schedule_frame; Type: TABLE; Schema: vehicle_schedule; Owner: dbhasura
--

CREATE TABLE vehicle_schedule.vehicle_schedule_frame (
    vehicle_schedule_frame_id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name_i18n jsonb NOT NULL,
    validity_start date,
    validity_end date,
    priority integer NOT NULL
);


ALTER TABLE vehicle_schedule.vehicle_schedule_frame OWNER TO dbhasura;

--
-- Name: block; Type: TABLE; Schema: vehicle_service; Owner: dbhasura
--

CREATE TABLE vehicle_service.block (
    block_id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    vehicle_service_id uuid NOT NULL
);


ALTER TABLE vehicle_service.block OWNER TO dbhasura;

--
-- Name: vehicle_service; Type: TABLE; Schema: vehicle_service; Owner: dbhasura
--

CREATE TABLE vehicle_service.vehicle_service (
    vehicle_service_id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    day_type_id uuid NOT NULL,
    vehicle_schedule_frame_id uuid NOT NULL
);


ALTER TABLE vehicle_service.vehicle_service OWNER TO dbhasura;

--
-- Sorted dump complete
--
