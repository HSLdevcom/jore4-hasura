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
  changed TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
  changed_by TEXT NULL DEFAULT NULL,

  --- Aggregated JSON blob containing the historical snapshot of the Line's
  --- state at the time (after) the change. Contans a graph of associated
  --- data from the Line's routes as collected by `collect_line_info_for_history`.
  data JSONB NOT NULL
);

--- UI fetches/groups the rows by the label.
CREATE INDEX IF NOT EXISTS idx_line_and_priority ON route.line_change_history(line_label);

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
  jsonLine jsonb := null;
  jsonRoutes jsonb := null;

BEGIN
  --- Find and populate in the primary details from the Line
  SELECT to_jsonb(line.*) INTO jsonLine FROM route.line WHERE line_id = lineId;

  --- Find and populate in the details from the Line's Routes.
  WITH
    --- Sub query to fetch a list of stops on the Route.
    stopPointsOnRoute AS (
    SELECT jp.on_route_id AS routeId, jsonb_agg(to_jsonb(sspijp.*)) AS stops
    FROM journey_pattern.journey_pattern AS jp
      INNER JOIN journey_pattern.scheduled_stop_point_in_journey_pattern AS sspijp
        ON sspijp.journey_pattern_id = jp.journey_pattern_id
    GROUP BY jp.on_route_id
  ),
    --- Sub query to calculate the estimated length of the Route.
    estimatedRouteLengthInMeters AS (
    SELECT ilar.route_id AS routeId, sum(il.estimated_length_in_metres) AS length
    FROM route.infrastructure_link_along_route AS ilar
      INNER JOIN infrastructure_network.infrastructure_link AS il
        ON il.infrastructure_link_id = ilar.infrastructure_link_id
    GROUP BY ilar.route_id
  )
  --- Select the Route's fields as JSONB and concat (||) with the subquery aggregates.
  SELECT jsonb_agg(to_jsonb(route.*) || jsonb_build_object(
    'stops', stopPointsOnRoute.stops,
    'estimated_length_in_metres', estimatedRouteLengthInMeters.length
  ))
  INTO jsonRoutes
  FROM route.route AS route
    LEFT JOIN stopPointsOnRoute ON stopPointsOnRoute.routeId = route.route_id
    LEFT JOIN estimatedRouteLengthInMeters ON estimatedRouteLengthInMeters.routeId = route.route_id
  WHERE route.on_line_id = lineId;

  --- Concat the route info onto the Line's details as 'routes'
  return jsonLine || jsonb_build_object('routes', jsonRoutes);
END;
$$;


--- Create the tigger for line INSERT & UPDATE events.
CREATE OR REPLACE FUNCTION
  route.record_history_after_line_upserted()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  VOLATILE AS $$
BEGIN
  INSERT INTO route.line_change_history (
    tg_operation,
    line_id,
    line_label,
    line_priority,
    line_validity_start,
    line_validity_end,
    name,
    version_comment,
    changed_by,
    data) VALUES (
    TG_OP,
    NEW.line_id,
    NEW.label,
    NEW.priority,
    NEW.validity_start,
    NEW.validity_end,
    NEW.name_i18n->>'fi_FI',
    NEW.version_comment,
    current_setting('hasura.user', TRUE)::JSON->>'x-hasura-user-id',
    route.collect_line_info_for_history(NEW.line_id)
  );

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
  INSERT INTO route.line_change_history (
    tg_operation,
    line_id,
    line_label,
    line_priority,
    line_validity_start,
    line_validity_end,
    name,
    version_comment,
    changed_by,
    data) VALUES (
    TG_OP,
    OLD.line_id,
    OLD.priority,
    OLD.validity_start,
    OLD.validity_end,
    OLD.name_i18n->>'fi_FI',
    OLD.version_comment,
    current_setting('hasura.user', TRUE)::JSON->>'x-hasura-user-id',
    route.collect_line_info_for_history(OLD.line_id)
    );

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

  INSERT INTO route.line_change_history (
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
  );

  RETURN NULL;
END;
$$;

CREATE OR REPLACE TRIGGER record_history_after_route_upserted
AFTER INSERT OR UPDATE ON route.route FOR EACH ROW
EXECUTE FUNCTION route.record_history_after_route_upserted();


--- Create the trigger for route DELETE events.
CREATE OR REPLACE FUNCTION
  route.record_history_before_route_deleted()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  VOLATILE AS $$
DECLARE
  line route.line := NULL;

BEGIN
  SELECT * INTO line FROM route.line WHERE line_id = OLD.on_line_id;

  INSERT INTO route.line_change_history (
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
    OLD.route_id,
    COALESCE(OLD.unique_label, OLD.label),
    OLD.validity_start,
    OLD.validity_end,
    OLD.name_i18n->>'fi_FI',
    OLD.version_comment,
    current_setting('hasura.user', TRUE)::JSON->>'x-hasura-user-id',
    route.collect_line_info_for_history(OLD.on_line_id)
  );

  RETURN OLD;
END;
$$;

CREATE OR REPLACE TRIGGER record_history_before_route_deleted
BEFORE DELETE ON route.route FOR EACH ROW
EXECUTE FUNCTION route.record_history_before_route_deleted();
