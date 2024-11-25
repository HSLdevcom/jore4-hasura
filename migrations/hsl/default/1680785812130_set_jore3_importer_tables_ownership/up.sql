-- Move ownership of all tables modified (truncated) by jore3 importer to importer user.
-- Otherwise some operations (eg. resetting sequences) are not possible.
-- For these commands to work, dbhasura must be member of dbimporter role.

-- Must have CREATE permission first, see https://www.postgresql.org/docs/current/sql-altertable.html
GRANT CREATE ON SCHEMA journey_pattern TO dbimporter;
GRANT CREATE ON SCHEMA route TO dbimporter;
GRANT CREATE ON SCHEMA service_pattern TO dbimporter;
GRANT CREATE ON SCHEMA timing_pattern TO dbimporter;

ALTER TABLE journey_pattern.scheduled_stop_point_in_journey_pattern OWNER TO dbimporter;
ALTER TABLE journey_pattern.journey_pattern OWNER TO dbimporter;
ALTER TABLE route.infrastructure_link_along_route OWNER TO dbimporter;
ALTER TABLE route.route OWNER TO dbimporter;
ALTER TABLE route.line OWNER TO dbimporter;
ALTER TABLE service_pattern.vehicle_mode_on_scheduled_stop_point OWNER TO dbimporter;
ALTER TABLE service_pattern.scheduled_stop_point OWNER TO dbimporter;
ALTER TABLE timing_pattern.timing_place OWNER TO dbimporter;
