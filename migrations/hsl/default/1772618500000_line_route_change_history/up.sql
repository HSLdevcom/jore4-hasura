--- Create the history table
CREATE TABLE IF NOT EXISTS route.line_change_history (
  id BIGSERIAL NOT NULL PRIMARY KEY,

  --- DB Operation INSERT, UPDATE, DELETE.
  --- Used to determine whether the change was a new item,
  --- or an update to an existing one.
  tg_operation TEXT NOT NULL,

  --- Always populated
  --- All data is grouped by the Line in UI.
  line_id UUID NOT NULL, --- Used to correlate updates to correct version
  line_label TEXT NOT NULL, --- Used to render the initial block-of-changes header
  line_priority INTEGER NOT NULL, --- Extra info for filtering/header section
  line_validity_start DATE NULL DEFAULT NULL, --- Needed for sorting & header section
  line_validity_end DATE NULL DEFAULT NULL, --- Needed for sorting & header section

  --- Populated when a Route is changed instead of the owning Line.
  route_id UUID NULL DEFAULT NULL, --- Used to correlate updates to correct version
  route_label TEXT NULL DEFAULT NULL, --- Used to render the initial block-of-changes header
  route_validity_start DATE NULL DEFAULT NULL, --- Needed for sorting & header section
  route_validity_end DATE NULL DEFAULT NULL, --- Needed for sorting & header section

  --- Primary name of the Line or Route.
  --- Needed for the header section.
  name TEXT NULL DEFAULT NULL,
  version_comment TEXT NULL DEFAULT NULL, --- Version comment from the Line or Route.

  --- Time of change and the person who changed it.
  changed TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  changed_by TEXT NULL DEFAULT NULL,

  --- Aggregated JSON blob containing the historical snapshot of the Line's
  --- state at the time (after) the change. Contains a graph of associated
  --- data from the Line's routes as collected by `collect_line_info_for_history`.
  data JSONB NOT NULL
);

--- UI fetches/groups the rows by the label.
CREATE INDEX IF NOT EXISTS idx_line_and_priority ON route.line_change_history(line_label);

--- Allow only one history item per line and/or line⋄route combo per transaction.
--- Helps facilitate merging of complex change sets, that target multiple dependency tables.
CREATE UNIQUE INDEX IF NOT EXISTS history_unique_line_route_combo_per_transaction
  ON route.line_change_history(line_id, route_id, changed);

--- Add comments
COMMENT ON TABLE route.line_change_history IS
  'Collects and represents the historical states of an HSL Lines.';

COMMENT ON COLUMN route.line_change_history.id IS
  'Auto-incremented serial db row ID.';

COMMENT ON COLUMN route.line_change_history.tg_operation IS
  'DB operation type (INSERT,UPDATE,DELETE) that triggered the creation of this history item.';

COMMENT ON COLUMN route.line_change_history.line_label IS
  'DB ID of the HSL Line this historical record represents.';
COMMENT ON COLUMN route.line_change_history.line_label IS
  'Label of the HSL Line this historical record represents.';
COMMENT ON COLUMN route.line_change_history.line_priority IS
  'Priority of the HSL Line this historical record represents.';

COMMENT ON COLUMN route.line_change_history.line_validity_start IS
  'Validity start date of the HSL line as it was at time of the change.';
COMMENT ON COLUMN route.line_change_history.line_validity_end IS
  'Validity end date of the HSL line as it was at time of the change.';

COMMENT ON COLUMN route.line_change_history.route_id IS
  'DB ID of the HSL route that was changed (inserted, updated, deleted).';
COMMENT ON COLUMN route.line_change_history.route_label IS
  'Label of the HSL route that was changed.';
COMMENT ON COLUMN route.line_change_history.route_validity_start IS
  'Validity start date of the HSL route as it was at time of the change, if a route change triggered this history item.';
COMMENT ON COLUMN route.line_change_history.route_validity_end IS
  'Validity end date of the HSL route as it was at time of the change, if a route change triggered this history item.';

COMMENT ON COLUMN route.line_change_history.name IS
  'Finnish name of the HSL line or route, if a route change triggered this history item.';
COMMENT ON COLUMN route.line_change_history.version_comment IS
  'Version comment of the line or route, if a route change triggered this history item.';

COMMENT ON COLUMN route.line_change_history.changed IS
  'Time when this history item was recorded / the change occurred';
COMMENT ON COLUMN route.line_change_history.changed_by IS
  'UserID of the user who made the change, empty on automated system operations';

COMMENT ON COLUMN route.line_change_history.data IS
  'JSONB blob containing any and all relevant data from the associated line row with full graphs of any extra data (routes) needed to visualize the changes made. See `route.collect_line_info_for_history` function for implementation details.';


--- Create a function to construct a historical snapshot of the line and
--- of any related relevant related rows.
CREATE OR REPLACE FUNCTION
  route.collect_line_info_for_history(lineId UUID)
  RETURNS jsonb
  LANGUAGE plpgsql
  STABLE AS $$
DECLARE
  line JSONB := null;
  routeId UUID := null;
  stopPointsOnRoute JSONB := NULL;
  estimatedRouteLengthInMeters DOUBLE PRECISION := NULL;
  route JSONB := NULL;
  routes JSONB := '[]'::JSONB;

BEGIN
  --- Find and populate in the primary details from the Line
  SELECT to_jsonb(line.*) INTO line FROM route.line WHERE line_id = lineId;

  --- Fetch in pieces to optimize index usage. We are always fetching only a small
  --- subset of rows, but PostgreSQL does not know that if the subaggregates are
  --- nested deep withing a complex query. In local tests this version fetches the
  --- data in 350ms, compared to 1700ms when fetching the data in single query
  --- without the programmatic loop.
  FOR routeId IN SELECT route_id FROM route.route WHERE on_line_id = lineId LOOP
    --- Fetch a list of stops for the route
    SELECT jsonb_agg(to_jsonb(sspijp.*)) INTO stopPointsOnRoute
    FROM journey_pattern.journey_pattern AS jp
    INNER JOIN journey_pattern.scheduled_stop_point_in_journey_pattern AS sspijp
      ON sspijp.journey_pattern_id = jp.journey_pattern_id
    WHERE jp.on_route_id = routeId;

    --- Calculate the estimated length of the Route.
    SELECT sum(il.estimated_length_in_metres) INTO estimatedRouteLengthInMeters
    FROM route.infrastructure_link_along_route AS ilar
    INNER JOIN infrastructure_network.infrastructure_link AS il
      ON il.infrastructure_link_id = ilar.infrastructure_link_id
    WHERE ilar.route_id = routeId;

    --- Fetch the route details and augment with above aggregates.
    SELECT to_jsonb(route.*) || jsonb_build_object(
      'stops', stopPointsOnRoute,
      'estimated_length_in_metres', estimatedRouteLengthInMeters
    ) INTO route
    FROM route.route AS route
    WHERE route_id = routeId;

    --- Append the route into the list if routes
    routes := routes || route;
  END LOOP;

  --- Concat the route info onto the Line's details as 'routes'
  return line || jsonb_build_object('routes', routes);
END;
$$;


CREATE OR REPLACE FUNCTION
  route.get_higher_priority_operation(previousOperation TEXT, nextOperation TEXT)
  RETURNS TEXT
  LANGUAGE plpgsql
  IMMUTABLE AS $$
BEGIN
  IF (previousOperation = nextOperation) THEN
    RETURN previousOperation;

  ELSEIF (previousOperation = 'INSERT' AND nextOperation = 'UPDATE') THEN
    RETURN 'INSERT';

  ELSEIF (previousOperation = 'INSERT' AND nextOperation = 'DELETE') THEN
    RETURN 'DELETE';

  ELSEIF (previousOperation = 'UPDATE' AND nextOperation = 'DELETE') THEN
    RETURN 'DELETE';
  END IF;

  RAISE EXCEPTION 'Illegal/illogical transition: %s -> %s', previousOperation, nextOperation;
END;
$$;
COMMENT ON FUNCTION route.get_higher_priority_operation(previousOperation TEXT, nextOperation TEXT)
  IS 'Determines the appropriate "operation" when multiple operations take place within a single transaction. If an INSERT is followed by an update, the latter UPDATE can be considered to be part of the initial INSERT. UPDATE followed by another UPDATE is just and UPDATE. And an INSERT or UPDATE followed by a DELETE, is ultimately just a DELETE.';


--- Create the helper function and trigger for line INSERT & UPDATE events.
CREATE OR REPLACE FUNCTION
  route.record_history_for_changed_line(tgOperation TEXT, lineId UUID)
  RETURNS VOID
  LANGUAGE plpgsql
  VOLATILE AS $$
BEGIN
  INSERT INTO route.line_change_history AS lch (
    tg_operation,
    line_id,
    line_label,
    line_priority,
    line_validity_start,
    line_validity_end,
    name,
    version_comment,
    changed_by,
    data
  )
  SELECT
    tgOperation,
    line.line_id,
    line.label,
    line.priority,
    line.validity_start,
    line.validity_end,
    line.name_i18n->>'fi_FI',
    line.version_comment,
    current_setting('hasura.user', TRUE)::JSON->>'x-hasura-user-id',
    route.collect_line_info_for_history(line.line_id)
  FROM route.line
  WHERE line.line_id = lineId
  ON CONFLICT (line_id, route_id, changed)
  DO UPDATE SET
    tg_operation=route.get_higher_priority_operation(lch.tg_operation, EXCLUDED.tg_operation),
    line_label=EXCLUDED.line_label,
    line_priority=EXCLUDED.line_priority,
    line_validity_start=EXCLUDED.line_validity_start,
    line_validity_end=EXCLUDED.line_validity_end,
    name=EXCLUDED.name,
    version_comment=EXCLUDED.version_comment,
    data=EXCLUDED.data;
END;
$$;

CREATE OR REPLACE FUNCTION
  route.record_history_after_line_upserted()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  VOLATILE AS $$
BEGIN
  EXECUTE route.record_history_for_changed_line(TG_OP, NEW.line_id);
  RETURN NULL;
END;
$$;

CREATE OR REPLACE TRIGGER record_history_after_line_upserted
AFTER INSERT OR UPDATE ON route.line FOR EACH ROW
EXECUTE FUNCTION route.record_history_after_line_upserted();


--- Create the trigger for line DELETE events.
CREATE OR REPLACE FUNCTION
  route.record_history_before_line_deleted()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  VOLATILE AS $$
BEGIN
  EXECUTE route.record_history_for_changed_line(TG_OP, OLD.line_id);
  RETURN OLD;
END;
$$;

CREATE OR REPLACE TRIGGER record_history_before_line_deleted
BEFORE DELETE ON route.line FOR EACH ROW
EXECUTE FUNCTION route.record_history_before_line_deleted();


--- Create the trigger for route INSERT & UPDATE events
CREATE OR REPLACE FUNCTION
  route.record_history_after_route_upserted()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  VOLATILE AS $$
DECLARE
  line route.line := NULL;
  newLineData JSONB := NULL;
  oldLineData JSONB := NULL;
  lineData JSONB := NULL;

BEGIN
  --- Collect the primary Line information from the Line the Route is
  --- associated with CURRENTLY, AFTER update,
  SELECT * INTO line FROM route.line WHERE line_id = NEW.on_line_id;
  newLineData = route.collect_line_info_for_history(NEW.on_line_id);

  --- If the route was moved to another Line, records the OLD Line's info
  --- and concat it to the data field as 'old_line_data'
  IF (OLD.on_line_id != NEW.on_line_id) THEN
    oldLineData := route.collect_line_info_for_history(NEW.on_line_id);
    lineData := newLineData || jsonb_build_object('old_line_data', oldLineData);
  ELSE
    lineData := newLineData;
  END IF;

  INSERT INTO route.line_change_history AS lch (
    tg_operation,
    line_id,
    line_label,
    line_priority,
    line_validity_start,
    line_validity_end,
    route_id,
    route_label,
    route_validity_start,
    route_validity_end,
    name,
    version_comment,
    changed_by,
    data) VALUES (
    TG_OP,
    line.line_id,
    line.label,
    line.priority,
    line.validity_start,
    line.validity_end,
    NEW.route_id,
    COALESCE(NEW.unique_label, NEW.label),
    NEW.validity_start,
    NEW.validity_end,
    NEW.name_i18n->>'fi_FI',
    NEW.version_comment,
    current_setting('hasura.user', TRUE)::JSON->>'x-hasura-user-id',
    lineData
  )
  ON CONFLICT (line_id, route_id, changed)
  DO UPDATE SET
    tg_operation=route.get_higher_priority_operation(lch.tg_operation, EXCLUDED.tg_operation),
    line_label=EXCLUDED.line_label,
    line_priority=EXCLUDED.line_priority,
    line_validity_start=EXCLUDED.line_validity_start,
    line_validity_end=EXCLUDED.line_validity_end,
    changed_by=EXCLUDED.changed_by,
    route_label=EXCLUDED.route_label,
    route_validity_start=EXCLUDED.route_validity_start,
    route_validity_end=EXCLUDED.route_validity_end,
    name=EXCLUDED.name,
    version_comment=EXCLUDED.version_comment,
    data=EXCLUDED.data;

  RETURN NULL;
END;
$$;

CREATE OR REPLACE TRIGGER record_history_after_route_upserted
AFTER INSERT OR UPDATE ON route.route FOR EACH ROW
EXECUTE FUNCTION route.record_history_after_route_upserted();


--- Create a helper function and the trigger for route DELETE events.
CREATE OR REPLACE FUNCTION
  route.record_history_for_changed_route(tgOperation TEXT, routeId UUID)
  RETURNS VOID
  LANGUAGE plpgsql
  VOLATILE AS $$
BEGIN
  INSERT INTO route.line_change_history AS lch (
    tg_operation,
    line_id,
    line_label,
    line_priority,
    line_validity_start,
    line_validity_end,
    route_id,
    route_label,
    route_validity_start,
    route_validity_end,
    name,
    version_comment,
    changed_by,
    data
  )
  SELECT
    tgOperation,
    line.line_id,
    line.label,
    line.priority,
    line.validity_start,
    line.validity_end,
    route.route_id,
    COALESCE(route.unique_label, route.label),
    route.validity_start,
    route.validity_end,
    route.name_i18n->>'fi_FI',
    route.version_comment,
    current_setting('hasura.user', TRUE)::JSON->>'x-hasura-user-id',
    route.collect_line_info_for_history(route.on_line_id)
  FROM route.route
  INNER JOIN route.line ON line.line_id = route.on_line_id
  WHERE route.route_id = routeId
  ON CONFLICT (line_id, route_id, changed)
  DO UPDATE SET
    tg_operation=route.get_higher_priority_operation(lch.tg_operation, EXCLUDED.tg_operation),
    line_label=EXCLUDED.line_label,
    line_priority=EXCLUDED.line_priority,
    line_validity_start=EXCLUDED.line_validity_start,
    line_validity_end=EXCLUDED.line_validity_end,
    changed_by=EXCLUDED.changed_by,
    route_label=EXCLUDED.route_label,
    route_validity_start=EXCLUDED.route_validity_start,
    route_validity_end=EXCLUDED.route_validity_end,
    name=EXCLUDED.name,
    version_comment=EXCLUDED.version_comment,
    data=EXCLUDED.data;
END;
$$;


CREATE OR REPLACE FUNCTION
  route.record_history_before_route_deleted()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  VOLATILE AS $$
BEGIN
  EXECUTE route.record_history_for_changed_route(TG_OP, OLD.route_id);
  RETURN OLD;
END;
$$;

CREATE OR REPLACE TRIGGER record_history_before_route_deleted
BEFORE DELETE ON route.route FOR EACH ROW
EXECUTE FUNCTION route.record_history_before_route_deleted();


--- Helper triggers to record deeply nested aggregate changes.

--- Along which Infra links is the route located on.
--- Used to calculate the estimated length of the route.
--- Statement level trigger, these should be inserted and changes en masse.
--- Record snapshot for each unique route changed (there should always be only one).
CREATE OR REPLACE FUNCTION
  route.record_history_after_route_infra_links_changed()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  VOLATILE AS $$
DECLARE
  ids UUID[] := NULL;
  id UUID := NULL;
BEGIN
  CASE TG_OP
    WHEN 'INSERT' THEN
      SELECT array_agg(DISTINCT route_id) INTO ids FROM new_links_along_route;

    WHEN 'UPDATE' THEN
      SELECT array_agg(DISTINCT route_id)
      INTO ids
      FROM (
        SELECT route_id FROM new_links_along_route
        UNION ALL
        SELECT route_id FROM old_links_along_route
      ) AS list_of_all_ids;

    WHEN 'DELETE'THEN
      SELECT array_agg(DISTINCT route_id) INTO ids FROM old_links_along_route;
  END CASE;

  FOREACH id IN ARRAY ids
  LOOP
    --- Actual operation might not be UPDATE, but from the Route's perspective, changes to its
    --- children, constitute an "UPDATE" of its "aggregate state".
    EXECUTE route.record_history_for_changed_route('UPDATE', id);
  END LOOP;

  RETURN NULL;
END;
$$;

CREATE OR REPLACE TRIGGER record_history_after_route_infra_links_inserted
  AFTER INSERT ON route.infrastructure_link_along_route
  REFERENCING NEW TABLE AS new_links_along_route
  FOR EACH STATEMENT
EXECUTE FUNCTION route.record_history_after_route_infra_links_changed();

CREATE OR REPLACE TRIGGER record_history_after_route_infra_links_updated
AFTER UPDATE ON route.infrastructure_link_along_route
REFERENCING NEW TABLE AS new_links_along_route OLD TABLE AS old_links_along_route
FOR EACH STATEMENT
EXECUTE FUNCTION route.record_history_after_route_infra_links_changed();

CREATE OR REPLACE TRIGGER record_history_after_route_infra_links_deleted
AFTER DELETE ON route.infrastructure_link_along_route
REFERENCING OLD TABLE AS old_links_along_route
FOR EACH STATEMENT
EXECUTE FUNCTION route.record_history_after_route_infra_links_changed();

--- Should we react to updates on the actual infra links (estimated length, shape)?


--- What stops does the route have?
--- No need to react to changes in the join table (journey_pattern),
--- but update on changes to the actual table containing the data.
--- INSERT: Stop added; UPDATE: via-point info changed; DELETE: stop removed from route.
--- Statement level trigger, these should be inserted and changes en masse.
--- Record snapshot for each unique route changed (there should always be only one).
CREATE OR REPLACE FUNCTION
  journey_pattern.record_history_after_route_journey_pattern_stop_points_changed()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  VOLATILE AS $$
DECLARE
  journeyPatternIds UUID[] := NULL;
  idRecord RECORD := NULL;
BEGIN
  CASE TG_OP
    WHEN 'INSERT' THEN
      SELECT array_agg(journey_pattern_id) INTO journeyPatternIds FROM new_sspijp;

    WHEN 'UPDATE' THEN
      SELECT array_agg(journey_pattern_id)
      INTO journeyPatternIds
      FROM (
        SELECT journey_pattern_id FROM new_sspijp
        UNION ALL
        SELECT journey_pattern_id FROM old_sspijp
      ) AS list_of_all_ids;

    WHEN 'DELETE'THEN
      SELECT array_agg(journey_pattern_id) INTO journeyPatternIds FROM old_sspijp;
    END CASE;

  FOR idRecord IN
    SELECT DISTINCT ON (on_route_id) on_route_id
    FROM journey_pattern.journey_pattern
    WHERE journey_pattern_id = ANY(journeyPatternIds)
  LOOP
    --- Actual operation might not be UPDATE, but from the Route's perspective, changes to its
    --- children, constitute an "UPDATE" of its "aggregate state".
    EXECUTE route.record_history_for_changed_route('UPDATE', idRecord.on_route_id);
  END LOOP;

  RETURN NULL;
END;
$$;

CREATE OR REPLACE TRIGGER record_history_after_route_journey_pattern_stop_points_inserted
  AFTER INSERT ON journey_pattern.scheduled_stop_point_in_journey_pattern
  REFERENCING NEW TABLE AS new_sspijp
  FOR EACH STATEMENT
EXECUTE FUNCTION journey_pattern.record_history_after_route_journey_pattern_stop_points_changed();

CREATE OR REPLACE TRIGGER record_history_after_route_journey_pattern_stop_points_updated
  AFTER UPDATE ON journey_pattern.scheduled_stop_point_in_journey_pattern
  REFERENCING NEW TABLE AS new_sspijp OLD TABLE AS old_sspijp
  FOR EACH STATEMENT
EXECUTE FUNCTION journey_pattern.record_history_after_route_journey_pattern_stop_points_changed();

CREATE OR REPLACE TRIGGER record_history_after_route_journey_pattern_stop_points_deleted
  AFTER DELETE ON journey_pattern.scheduled_stop_point_in_journey_pattern
  REFERENCING OLD TABLE AS old_sspijp
  FOR EACH STATEMENT
EXECUTE FUNCTION journey_pattern.record_history_after_route_journey_pattern_stop_points_changed();


--- Migration to insert existing Lines and Routes into the history.
--- Temporally materialize the sub queries to ensure swift inserts.
--- Makes the migration take < minute, instead of +15 minutes (did not wait more).
CREATE MATERIALIZED VIEW route.stopPointsOnRoute AS
SELECT jp.on_route_id AS routeId, jsonb_agg(to_jsonb(sspijp.*)) AS stops
FROM journey_pattern.journey_pattern AS jp
INNER JOIN journey_pattern.scheduled_stop_point_in_journey_pattern AS sspijp
  ON sspijp.journey_pattern_id = jp.journey_pattern_id
GROUP BY jp.on_route_id;
CREATE INDEX tmp_idx_stopPointsOnRoute_route_id ON route.stopPointsOnRoute(routeId);

CREATE MATERIALIZED VIEW route.estimatedRouteLengthInMeters AS
SELECT ilar.route_id AS routeId, sum(il.estimated_length_in_metres) AS length
FROM route.infrastructure_link_along_route AS ilar
INNER JOIN infrastructure_network.infrastructure_link AS il
  ON il.infrastructure_link_id = ilar.infrastructure_link_id
GROUP BY ilar.route_id;
CREATE INDEX tmp_idx_estimatedRouteLengthInMeters_route_id ON route.estimatedRouteLengthInMeters(routeId);

CREATE MATERIALIZED VIEW route.lineRoutes AS
SELECT route.on_line_id AS lineId, jsonb_agg(to_jsonb(route.*) || jsonb_build_object(
  'stops', COALESCE(stopPointsOnRoute.stops, '[]'::JSONB),
  'estimated_length_in_metres', estimatedRouteLengthInMeters.length
)) AS routes
FROM route.route AS route
LEFT JOIN route.stopPointsOnRoute ON stopPointsOnRoute.routeId = route.route_id
LEFT JOIN route.estimatedRouteLengthInMeters ON estimatedRouteLengthInMeters.routeId = route.route_id
GROUP BY route.on_line_id;
CREATE INDEX tmp_idx_lineRoutes_line_id ON route.lineRoutes(lineId);

--- Insert history items for Line creation
INSERT INTO route.line_change_history AS lch (
  tg_operation,
  line_id,
  line_label,
  line_priority,
  line_validity_start,
  line_validity_end,
  name,
  version_comment,
  data
)
SELECT
  'INSERT',
  line.line_id,
  line.label,
  line.priority,
  line.validity_start,
  line.validity_end,
  line.name_i18n->>'fi_FI',
  line.version_comment,
  --- When created the line has no routes yet.
  to_jsonb(line.*) || '{"routes":[]}'::JSONB
FROM route.line;

--- Insert history items for Route creation
INSERT INTO route.line_change_history AS lch (
  tg_operation,
  line_id,
  line_label,
  line_priority,
  line_validity_start,
  line_validity_end,
  route_id,
  route_label,
  route_validity_start,
  route_validity_end,
  name,
  version_comment,
  data
)
SELECT
  'INSERT',
  line.line_id,
  line.label,
  line.priority,
  line.validity_start,
  line.validity_end,
  route.route_id,
  COALESCE(route.unique_label, route.label),
  route.validity_start,
  route.validity_end,
  route.name_i18n->>'fi_FI',
  line.version_comment,
  to_jsonb(line.*) || jsonb_build_object(
    'routes', COALESCE(lineRoutes.routes, '[]'::JSONB)
  )
FROM route.line
INNER JOIN route.route ON route.on_line_id = line.line_id
INNER JOIN route.lineRoutes ON lineRoutes.lineId = line.line_id;

DROP MATERIALIZED VIEW route.lineRoutes;
DROP MATERIALIZED VIEW route.estimatedRouteLengthInMeters;
DROP MATERIALIZED VIEW route.stopPointsOnRoute;
