-- --------------------------
-- HELPER FUNCTIONS
-- --------------------------

CREATE FUNCTION internal_utils.date_closed2open_upper(
  bound DATE
)
  RETURNS DATE
  LANGUAGE sql
  IMMUTABLE
  PARALLEL SAFE
AS
$$
SELECT CASE WHEN bound IS NULL THEN NULL::DATE ELSE (bound + INTERVAL '1 day')::DATE END;
$$;

CREATE FUNCTION internal_utils.date_open2closed_upper(
  bound DATE
)
  RETURNS DATE
  LANGUAGE sql
  IMMUTABLE
  PARALLEL SAFE
AS
$$
SELECT CASE WHEN bound IS NULL THEN NULL::DATE ELSE (bound - INTERVAL '1 day')::DATE END;
$$;

CREATE FUNCTION internal_utils.daterange_closed_upper(
  lower_bound DATE,
  closed_upper_bound DATE
)
  RETURNS daterange
  LANGUAGE sql
  IMMUTABLE
  PARALLEL SAFE
AS
$$
SELECT daterange(lower_bound, internal_utils.date_closed2open_upper(closed_upper_bound));
$$;
COMMENT ON FUNCTION internal_utils.daterange_closed_upper(
  lower_bound DATE,
  upper_bound DATE
  )
  IS 'In postgresql, date ranges are handled using lower bound closed and upper bound open. In order
  to be able to check for overlapping ranges when using closed upper bounds, this function constructs
  a daterange with the upper bound interpreted as a closed bound.

  Note that the range returned by this function will work well for calculating overlaps and merging,
  but does not contain the correct logical upper bound. In order to calculate the upper bound of a range
  created by this function, use the internal_utils.upperinc function.';

CREATE FUNCTION internal_utils.date_closed_upper(
  range daterange
)
  RETURNS DATE
  LANGUAGE sql
  IMMUTABLE
  PARALLEL SAFE
AS
$$
SELECT internal_utils.date_open2closed_upper(upper(range));
$$;
COMMENT ON FUNCTION internal_utils.date_closed_upper(
  range daterange
  )
  IS 'This function calculates the upper bound of a date range created by the
  internal_utils.daterange_upperinc function.';


-- --------------------------
-- TABLES AND VIEWS
-- --------------------------

-- CHANGES FOR scheduled_stop_point

DROP VIEW service_pattern.scheduled_stop_point CASCADE;

ALTER TABLE internal_service_pattern.scheduled_stop_point
  DROP CONSTRAINT unique_validity_period;
ALTER TABLE route.route
  DROP CONSTRAINT route_unique_validity_period;
ALTER TABLE route.line
  DROP CONSTRAINT line_unique_validity_period;

ALTER TABLE internal_service_pattern.scheduled_stop_point
  ALTER COLUMN validity_start TYPE DATE USING validity_start::DATE;
COMMENT ON COLUMN internal_service_pattern.scheduled_stop_point.validity_start
  IS 'start of the operating date span in the scheduled stop point''s local time';
ALTER TABLE internal_service_pattern.scheduled_stop_point
  ALTER COLUMN validity_end TYPE DATE USING validity_end::DATE;
COMMENT ON COLUMN internal_service_pattern.scheduled_stop_point.validity_end
  IS 'end of the operating date span in the scheduled stop point''s local time';

ALTER TABLE internal_service_pattern.scheduled_stop_point
  ADD CONSTRAINT unique_validity_period EXCLUDE USING GIST (
    label WITH =,
    priority WITH =,
    internal_utils.daterange_closed_upper(validity_start, validity_end) WITH &&
    )
    WHERE (priority < internal_utils.const_priority_draft());

CREATE VIEW service_pattern.scheduled_stop_point AS
SELECT ssp.scheduled_stop_point_id,
       ssp.label,
       ssp.measured_location,
       ssp.located_on_infrastructure_link_id,
       ssp.direction,
       internal_utils.ST_LineLocatePoint(il.shape, ssp.measured_location) AS relative_distance_from_infrastructure_link_start,
       internal_utils.ST_ClosestPoint(il.shape, ssp.measured_location)    AS closest_point_on_infrastructure_link,
       ssp.validity_start,
       ssp.validity_end,
       ssp.priority
FROM internal_service_pattern.scheduled_stop_point AS ssp
       INNER JOIN infrastructure_network.infrastructure_link AS il
                  ON (ssp.located_on_infrastructure_link_id = il.infrastructure_link_id);
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
  service_pattern.scheduled_stop_point.direction IS
  'The direction(s) of traffic with respect to the digitization, i.e. the direction of the specified line string.';

COMMENT ON COLUMN
  service_pattern.scheduled_stop_point.relative_distance_from_infrastructure_link_start IS
  'The relative distance of the stop from the start of the linestring along the infrastructure link. Regardless of the specified direction, this value is the distance from the beginning of the linestring. The distance is normalized to the closed interval [0, 1].';
COMMENT ON COLUMN
  service_pattern.scheduled_stop_point.closest_point_on_infrastructure_link IS
  'The point on the infrastructure link closest to measured_location. A PostGIS PointZ geography in EPSG:4326.';
COMMENT ON COLUMN
  service_pattern.scheduled_stop_point.validity_start IS
  'The point in time when the stop becomes valid. If NULL, the stop has been always valid.';
COMMENT ON COLUMN
  service_pattern.scheduled_stop_point.validity_end IS
  'The point in time from which onwards the stop is no longer valid. If NULL, the stop will be always valid.';
COMMENT ON COLUMN
  service_pattern.scheduled_stop_point.priority IS
  'The priority of the stop definition. The definition may be overridden by higher priority definitions.';

-- trigger function service_pattern.insert_scheduled_stop_point does not need to be re-created, is still valid

CREATE TRIGGER service_pattern_insert_scheduled_stop_point_trigger
  INSTEAD OF INSERT
  ON service_pattern.scheduled_stop_point
  FOR EACH ROW
EXECUTE PROCEDURE service_pattern.insert_scheduled_stop_point();

-- trigger function service_pattern.update_scheduled_stop_point does not need to be re-created, is still valid

CREATE TRIGGER service_pattern_update_scheduled_stop_point_trigger
  INSTEAD OF UPDATE
  ON service_pattern.scheduled_stop_point
  FOR EACH ROW
EXECUTE PROCEDURE service_pattern.update_scheduled_stop_point();

-- trigger function service_pattern.delete_scheduled_stop_point does not need to be re-created, is still valid

CREATE TRIGGER service_pattern_delete_scheduled_stop_point_trigger
  INSTEAD OF DELETE
  ON service_pattern.scheduled_stop_point
  FOR EACH ROW
EXECUTE PROCEDURE service_pattern.delete_scheduled_stop_point();


-- CHANGES FOR line

ALTER TABLE route.line
  ALTER COLUMN validity_start TYPE DATE USING validity_start::DATE;
COMMENT ON COLUMN internal_service_pattern.scheduled_stop_point.validity_start
  IS 'start of the line''s operating date span in the line''s local time';
ALTER TABLE route.line
  ALTER COLUMN validity_end TYPE DATE USING validity_end::DATE;
COMMENT ON COLUMN internal_service_pattern.scheduled_stop_point.validity_start
  IS 'end of the line''s operating date span in the line''s local time';
ALTER TABLE route.line
  ADD CONSTRAINT line_unique_validity_period EXCLUDE USING GIST (
    label WITH =,
    priority WITH =,
    internal_utils.daterange_closed_upper(validity_start, validity_end) WITH &&
    )
    WHERE (priority < internal_utils.const_priority_draft());


-- CHANGES FOR route

ALTER TABLE route.route
  ALTER COLUMN validity_start TYPE DATE USING validity_start::DATE;
COMMENT ON COLUMN internal_service_pattern.scheduled_stop_point.validity_start
  IS 'start of the route''s operating date span in the route''s local time';
ALTER TABLE route.route
  ALTER COLUMN validity_end TYPE DATE USING validity_end::DATE;
COMMENT ON COLUMN internal_service_pattern.scheduled_stop_point.validity_start
  IS 'end of the route''s operating date span in the route''s local time';
ALTER TABLE route.route
  ADD CONSTRAINT route_unique_validity_period EXCLUDE USING GIST (
    label WITH =,
    direction WITH =,
    priority WITH =,
    internal_utils.daterange_closed_upper(validity_start, validity_end) WITH &&
    )
    WHERE (priority < internal_utils.const_priority_draft());


-- --------------------------
-- FUNCTIONS
-- --------------------------

-- CHANGES FOR get_scheduled_stop_points_with_new

-- The previous version of the internal_service_pattern.get_scheduled_stop_points_with_new -function cannot be moved
-- to the 'deleted' schema, because it was removed automatically due to the function signature referencing the
-- 'scheduled_stop_points' view, which was removed above.

CREATE FUNCTION internal_service_pattern.get_scheduled_stop_points_with_new(
  replace_scheduled_stop_point_id UUID DEFAULT NULL,
  new_scheduled_stop_point_id UUID DEFAULT NULL,
  new_located_on_infrastructure_link_id UUID DEFAULT NULL,
  new_measured_location geography(PointZ, 4326) DEFAULT NULL,
  new_direction TEXT DEFAULT NULL,
  new_label TEXT DEFAULT NULL,
  new_validity_start DATE DEFAULT NULL,
  new_validity_end DATE DEFAULT NULL,
  new_priority INT DEFAULT NULL
)
  RETURNS SETOF service_pattern.scheduled_stop_point
  STABLE
  LANGUAGE plpgsql
AS
$$
BEGIN
  IF new_scheduled_stop_point_id IS NULL THEN
    RETURN QUERY
      SELECT *
      FROM service_pattern.scheduled_stop_point ssp
      WHERE replace_scheduled_stop_point_id IS NULL
         OR ssp.scheduled_stop_point_id != replace_scheduled_stop_point_id;
  ELSE
    RETURN QUERY
      SELECT *
      FROM service_pattern.scheduled_stop_point ssp
      WHERE replace_scheduled_stop_point_id IS NULL
         OR ssp.scheduled_stop_point_id != replace_scheduled_stop_point_id
      UNION ALL
      SELECT new_scheduled_stop_point_id,
             new_label,
             new_measured_location::geography(PointZ, 4326),
             new_located_on_infrastructure_link_id,
             new_direction,
             internal_utils.st_linelocatepoint(il.shape, new_measured_location) AS relative_distance_from_infrastructure_link_start,
             NULL::geography(PointZ, 4326)                                      AS closest_point_on_infrastructure_link,
             new_validity_start,
             new_validity_end,
             new_priority
      FROM infrastructure_network.infrastructure_link il
      WHERE il.infrastructure_link_id = new_located_on_infrastructure_link_id;
  END IF;
END;
$$;
COMMENT ON FUNCTION internal_service_pattern.get_scheduled_stop_points_with_new(
  replace_scheduled_stop_point_id UUID,
  new_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start DATE,
  new_validity_end DATE,
  new_priority INT
  )
  IS
    'Returns the scheduled stop points from the internal_service_pattern.scheduled_stop_point table.
     If replace_scheduled_stop_point_id is not null, the stop point with that ID is filtered out.
     Similarly, if the new_xxx arguments are specified, a scheduled stop point with those values is
     appended to the result (it is not inserted into the table).';


-- CHANGES FOR insert_scheduled_stop_point_with_vehicle_mode

ALTER FUNCTION internal_service_pattern.insert_scheduled_stop_point_with_vehicle_mode(
  scheduled_stop_point_id uuid,
  measured_location geography(PointZ, 4326),
  located_on_infrastructure_link_id uuid,
  direction text,
  label text,
  validity_start timestamp with time zone,
  validity_end timestamp with time zone,
  priority integer,
  supported_vehicle_mode text
  )
  RENAME TO insert_scheduled_stop_point_with_vehicle_mode_1664191395447;

ALTER FUNCTION internal_service_pattern.insert_scheduled_stop_point_with_vehicle_mode_1664191395447(
  scheduled_stop_point_id uuid,
  measured_location geography(PointZ, 4326),
  located_on_infrastructure_link_id uuid,
  direction text,
  label text,
  validity_start timestamp with time zone,
  validity_end timestamp with time zone,
  priority integer,
  supported_vehicle_mode text
  )
  SET SCHEMA deleted;

CREATE FUNCTION internal_service_pattern.insert_scheduled_stop_point_with_vehicle_mode(
  scheduled_stop_point_id uuid,
  measured_location geography(PointZ, 4326),
  located_on_infrastructure_link_id uuid,
  direction text,
  label text,
  validity_start date,
  validity_end date,
  priority integer,
  supported_vehicle_mode text
) RETURNS void AS
$$
BEGIN
  INSERT INTO internal_service_pattern.scheduled_stop_point (scheduled_stop_point_id,
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
$$ LANGUAGE plpgsql;


-- CHANGES FOR check_route_validity_is_within_line_validity

ALTER FUNCTION route.check_route_validity_is_within_line_validity()
  RENAME TO check_route_validity_is_within_line_validity_1664191395447;

ALTER FUNCTION route.check_route_validity_is_within_line_validity_1664191395447()
  SET SCHEMA deleted;

CREATE FUNCTION route.check_route_validity_is_within_line_validity()
  RETURNS trigger
  LANGUAGE plpgsql AS
$$
DECLARE
  line_validity_start DATE;
  line_validity_end   DATE;
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


-- CHANGES FOR check_infra_link_stop_refs_with_new_scheduled_stop_point

ALTER FUNCTION journey_pattern.check_infra_link_stop_refs_with_new_scheduled_stop_point(
  replace_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE,
  new_priority INT
  )
  RENAME TO check_infra_link_stop_refs_with_new_ssp_1664191395447;

ALTER FUNCTION journey_pattern.check_infra_link_stop_refs_with_new_ssp_1664191395447(
  replace_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE,
  new_priority INT
  )
  SET SCHEMA deleted;

CREATE FUNCTION journey_pattern.check_infra_link_stop_refs_with_new_scheduled_stop_point(
  replace_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start DATE,
  new_validity_end DATE,
  new_priority INT
)
  RETURNS SETOF journey_pattern.journey_pattern
  STABLE
  PARALLEL SAFE
  LANGUAGE SQL AS
$$
WITH filter_route_ids AS (
  SELECT array_agg(DISTINCT r.route_id) AS arr
  FROM route.route r
         LEFT JOIN journey_pattern.journey_pattern jp ON jp.on_route_id = r.route_id
         LEFT JOIN journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
                   ON sspijp.journey_pattern_id = jp.journey_pattern_id
         LEFT JOIN internal_service_pattern.scheduled_stop_point ssp
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
COMMENT ON FUNCTION journey_pattern.check_infra_link_stop_refs_with_new_scheduled_stop_point(
  replace_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start DATE,
  new_validity_end DATE,
  new_priority INT)
  IS
    'Check whether the journey pattern''s / route''s links and stop points still correspond to each other
     if a new stop point would be inserted (defined by arguments new_xxx). If replace_scheduled_stop_point_id
     is specified, the new stop point is thought to replace the stop point with that ID.
     This function returns a list of journey pattern and route ids, in which the links
     and stop points would conflict with each other.';


-- CHANGES FOR get_broken_route_check_filters

ALTER FUNCTION journey_pattern.get_broken_route_check_filters(
  filter_route_ids UUID[]
  )
  RENAME TO get_broken_route_check_filters_1664191395447;

ALTER FUNCTION journey_pattern.get_broken_route_check_filters_1664191395447(
  filter_route_ids UUID[]
  )
  SET SCHEMA deleted;

CREATE FUNCTION journey_pattern.get_broken_route_check_filters(filter_route_ids UUID[])
  RETURNS TABLE
          (
            labels         TEXT[],
            validity_start DATE,
            validity_end   DATE
          )
  STABLE
  PARALLEL SAFE
  LANGUAGE SQL
AS
$$
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
       -- since the upper bound was extended by the internal_utils.daterange_upperinc function above, we need
       -- to subtract the extended day here again
       internal_utils.date_closed_upper(validity_range) AS validity_end
FROM merged_route_range
WHERE ord = (SELECT max(ord) FROM merged_route_range);
$$;
COMMENT ON FUNCTION journey_pattern.get_broken_route_check_filters(filter_route_ids UUID[])
  IS 'Gather the filter parameters (route labels and validity range to check) for the broken route check.';


-- CHANGES FOR maximum_priority_validity_spans

ALTER FUNCTION journey_pattern.maximum_priority_validity_spans(
  entity_type TEXT,
  filter_route_labels TEXT[],
  filter_validity_start TIMESTAMP WITH TIME ZONE,
  filter_validity_end TIMESTAMP WITH TIME ZONE,
  upper_priority_limit INT,
  replace_scheduled_stop_point_id UUID,
  new_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE,
  new_priority int
  )
  RENAME TO maximum_priority_validity_spans_1664191395447;

ALTER FUNCTION journey_pattern.maximum_priority_validity_spans_1664191395447(
  entity_type TEXT,
  filter_route_labels TEXT[],
  filter_validity_start TIMESTAMP WITH TIME ZONE,
  filter_validity_end TIMESTAMP WITH TIME ZONE,
  upper_priority_limit INT,
  replace_scheduled_stop_point_id UUID,
  new_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE,
  new_priority int
  )
  SET SCHEMA deleted;

CREATE FUNCTION journey_pattern.maximum_priority_validity_spans(
  entity_type TEXT,
  filter_route_labels TEXT[],
  filter_validity_start DATE DEFAULT NULL,
  filter_validity_end DATE DEFAULT NULL,
  upper_priority_limit INT DEFAULT NULL,
  replace_scheduled_stop_point_id UUID DEFAULT NULL,
  new_scheduled_stop_point_id UUID DEFAULT NULL,
  new_located_on_infrastructure_link_id UUID DEFAULT NULL,
  new_measured_location geography(PointZ, 4326) DEFAULT NULL,
  new_direction TEXT DEFAULT NULL,
  new_label TEXT DEFAULT NULL,
  new_validity_start DATE DEFAULT NULL,
  new_validity_end DATE DEFAULT NULL,
  new_priority int DEFAULT NULL
)
  RETURNS TABLE
          (
            id             UUID,
            validity_start DATE,
            validity_end   DATE
          )
  STABLE
  PARALLEL SAFE
  LANGUAGE SQL
AS
$$
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
    FROM internal_service_pattern.get_scheduled_stop_points_with_new(
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
    SELECT internal_utils.date_closed2open_upper(e.validity_end), FALSE AS is_start, e.key1, e.key2, e.priority
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
           lead(internal_utils.date_open2closed_upper(validity_start)) OVER entity_window AS validity_end
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
-- choose the instance with the highest priority for each validity span
-- e.g.
-- id, validity_start, validity_end
-----------------------------------
--  1,     2020-01-01,   2022-01-01
--  2,     2022-01-01,   2027-01-01
-- (see COMMENT ON below for a graphical summary of the example data)
SELECT id, validity_start, validity_end
FROM (SELECT id,
             validity_start,
             validity_end,
             priority,
             max(priority) OVER (PARTITION BY key1, key2, validity_start) AS max_priority
      FROM boundary_with_entities) bwe
WHERE priority = max_priority
$$;
COMMENT ON FUNCTION journey_pattern.maximum_priority_validity_spans(
  entity_type TEXT,
  filter_route_labels TEXT[],
  filter_validity_start DATE,
  filter_validity_end DATE,
  upper_priority_limit INT,
  replace_scheduled_stop_point_id UUID,
  new_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start DATE,
  new_validity_end DATE,
  new_priority int
  )
  IS
    'Find the validity time spans of highest priority in the given time span for entities of the given type (routes or
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


-- CHANGES FOR get_broken_route_journey_patterns

ALTER FUNCTION journey_pattern.get_broken_route_journey_patterns(
  filter_route_ids UUID[],
  replace_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE,
  new_priority INT
  )
  RENAME TO get_broken_route_journey_patterns_1664191395447;

ALTER FUNCTION journey_pattern.get_broken_route_journey_patterns_1664191395447(
  filter_route_ids UUID[],
  replace_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE,
  new_priority INT
  )
  SET SCHEMA deleted;

CREATE FUNCTION journey_pattern.get_broken_route_journey_patterns(
  filter_route_ids UUID[],
  replace_scheduled_stop_point_id UUID DEFAULT NULL,
  new_located_on_infrastructure_link_id UUID DEFAULT NULL,
  new_measured_location geography(PointZ, 4326) DEFAULT NULL,
  new_direction TEXT DEFAULT NULL,
  new_label TEXT DEFAULT NULL,
  new_validity_start DATE DEFAULT NULL,
  new_validity_end DATE DEFAULT NULL,
  new_priority INT DEFAULT NULL
)
  RETURNS SETOF journey_pattern.journey_pattern
  STABLE
  PARALLEL SAFE
  LANGUAGE SQL
AS
$$
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
    FROM internal_service_pattern.get_scheduled_stop_points_with_new(
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
COMMENT ON FUNCTION journey_pattern.get_broken_route_journey_patterns(
  filter_route_ids UUID[],
  replace_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start DATE,
  new_validity_end DATE,
  new_priority INT
  )
  IS
    'Check if it is possible to visit all stops of journey patterns in such a fashion that all links, on which
     the stops reside, are visited in an order matching the corresponding routes'' link order. Additionally it is
     checked that there are no stop points on the route''s journey pattern, whose validity span does not overlap with
     the route''s validity span at all. Only the links / stops on the routes with the specified filter_route_ids are
     taken into account for the checks.

     If replace_scheduled_stop_point_id is not null, the stop with that id is left out of the check.
     If the new_xxx arguments are specified, the check is also performed for an imaginary stop defined by those
     arguments, which is not yet present in the table data.

     This functions returns those journey pattern / route combinations, which are broken (either in actual
     table data or with the proposed scheduled stop point changes).';



-- --------------------------
-- CONSTRAINT TRIGGERS
-- --------------------------

-- Note that we re-create all route verification triggers and their trigger functions here, not only those that
-- actually need updating. This should make it easier for future migration creators to pick the latest versions
-- of the triggers and trigger functions for further updating.

DROP TRIGGER verify_infra_link_stop_refs_on_sspijp_trigger
  ON journey_pattern.scheduled_stop_point_in_journey_pattern;

DROP TRIGGER verify_infra_link_stop_refs_on_ilar_trigger
  ON route.infrastructure_link_along_route;

DROP TRIGGER verify_infra_link_stop_refs_on_scheduled_stop_point_trigger
  ON internal_service_pattern.scheduled_stop_point;

DROP TRIGGER verify_infra_link_stop_refs_on_journey_pattern_trigger
  ON journey_pattern.journey_pattern;

DROP TRIGGER verify_infra_link_stop_refs_on_route_trigger
  ON route.route;


DROP TRIGGER queue_verify_infra_link_stop_refs_on_sspijp_insert_trigger
  ON journey_pattern.scheduled_stop_point_in_journey_pattern;
DROP TRIGGER queue_verify_infra_link_stop_refs_on_sspijp_update_trigger
  ON journey_pattern.scheduled_stop_point_in_journey_pattern;

DROP TRIGGER queue_verify_infra_link_stop_refs_on_ilar_update_trigger
  ON route.infrastructure_link_along_route;
DROP TRIGGER queue_verify_infra_link_stop_refs_on_ilar_delete_trigger
  ON route.infrastructure_link_along_route;

DROP TRIGGER queue_verify_infra_link_stop_refs_on_ssp_insert_trigger
  ON internal_service_pattern.scheduled_stop_point;
DROP TRIGGER queue_verify_infra_link_stop_refs_on_ssp_update_trigger
  ON internal_service_pattern.scheduled_stop_point;
DROP TRIGGER queue_verify_infra_link_stop_refs_on_ssp_delete_trigger
  ON internal_service_pattern.scheduled_stop_point;

DROP TRIGGER queue_verify_infra_link_stop_refs_on_jp_update_trigger
  ON journey_pattern.journey_pattern;

DROP TRIGGER queue_verify_infra_link_stop_refs_on_route_delete_trigger
  ON route.route;



ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_ssp_label()
  RENAME TO queue_verify_infra_link_stop_refs_by_new_ssp_l_1664191395447;

ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_ssp_l_1664191395447()
  SET SCHEMA deleted;


ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_id()
  RENAME TO queue_verify_infra_link_stop_refs_by_old_route_id_1664191395447;

ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_id_1664191395447()
  SET SCHEMA deleted;


ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_journey_pattern_id()
  RENAME TO queue_verify_infra_link_stop_refs_by_new_jp_id_1664191395447;

ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_jp_id_1664191395447()
  SET SCHEMA deleted;


ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_ssp_label()
  RENAME TO queue_verify_infra_link_stop_refs_by_old_ssp_l_1664191395447;

ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_ssp_l_1664191395447()
  SET SCHEMA deleted;


ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_label()
  RENAME TO queue_verify_infra_link_stop_refs_by_old_route_l_1664191395447;

ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_l_1664191395447()
  SET SCHEMA deleted;


CREATE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_ssp_label()
  RETURNS TRIGGER
  LANGUAGE plpgsql AS
$$
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

CREATE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_id()
  RETURNS TRIGGER
  LANGUAGE plpgsql
AS
$$
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

CREATE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_journey_pattern_id()
  RETURNS TRIGGER
  LANGUAGE plpgsql
AS
$$
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

CREATE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_ssp_label()
  RETURNS TRIGGER
  LANGUAGE plpgsql AS
$$
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


CREATE FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_label()
  RETURNS TRIGGER
  LANGUAGE plpgsql AS
$$
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


-- re-create the triggers

CREATE TRIGGER queue_verify_infra_link_stop_refs_on_sspijp_insert_trigger
  AFTER INSERT
  ON journey_pattern.scheduled_stop_point_in_journey_pattern
  REFERENCING NEW TABLE AS new_table
  FOR EACH STATEMENT
EXECUTE PROCEDURE journey_pattern.queue_verify_infra_link_stop_refs_by_new_journey_pattern_id();
COMMENT ON TRIGGER queue_verify_infra_link_stop_refs_on_sspijp_insert_trigger
  ON journey_pattern.scheduled_stop_point_in_journey_pattern
  IS 'Trigger to verify the infra link <-> scheduled stop point references.
      Inserting a new scheduled_stop_point_in_journey_pattern -row can break the route consistency in the following
      ways:
      1. The inserted stop point might be located on an infra link which is not part of the journey pattern''s route.
      2. The stop point might be inserted at a position in the journey pattern, which does not correspond to the
         position of the stop point''s infra link within the route.
      3. The stop point might not have any instances whose validity time would at all overlap with the journey
         pattern''s route''s validity time ("ghost stop").';
CREATE TRIGGER queue_verify_infra_link_stop_refs_on_sspijp_update_trigger
  AFTER UPDATE
  ON journey_pattern.scheduled_stop_point_in_journey_pattern
  REFERENCING NEW TABLE AS new_table
  FOR EACH STATEMENT
EXECUTE PROCEDURE journey_pattern.queue_verify_infra_link_stop_refs_by_new_journey_pattern_id();
COMMENT ON TRIGGER queue_verify_infra_link_stop_refs_on_sspijp_update_trigger
  ON journey_pattern.scheduled_stop_point_in_journey_pattern
  IS 'Trigger to verify the infra link <-> scheduled stop point references.
      Updating a scheduled_stop_point_in_journey_pattern -row can break the route consistency in the following
      ways:
      1. The updated stop point might be located on an infra link which is not part of the journey pattern''s route.
      2. The stop point might be moved to a position in the journey pattern, which does not correspond to the
         position of the stop point''s infra link within the route.
      3. The updated stop point might not have any instances whose validity time would at all overlap with the journey
         pattern''s route''s validity time ("ghost stop").';

CREATE TRIGGER queue_verify_infra_link_stop_refs_on_ilar_update_trigger
  AFTER UPDATE
  ON route.infrastructure_link_along_route
  REFERENCING OLD TABLE AS old_table
  FOR EACH STATEMENT
EXECUTE PROCEDURE journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_id();
COMMENT ON TRIGGER queue_verify_infra_link_stop_refs_on_ilar_update_trigger
  ON route.infrastructure_link_along_route
  IS 'Trigger to verify the infra link <-> scheduled stop point references.
      Updating an infrastructure_link_along_route -row can break the route consistency in such a way that
      an infra link associated with a stop point on a journey pattern might not be part of the (journey pattern''s)
      route anymore.';
CREATE TRIGGER queue_verify_infra_link_stop_refs_on_ilar_delete_trigger
  AFTER DELETE
  ON route.infrastructure_link_along_route
  REFERENCING OLD TABLE AS old_table
  FOR EACH STATEMENT
EXECUTE PROCEDURE journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_id();
COMMENT ON TRIGGER queue_verify_infra_link_stop_refs_on_ilar_delete_trigger
  ON route.infrastructure_link_along_route
  IS 'Trigger to verify the infra link <-> scheduled stop point references.
      Deleting an infrastructure_link_along_route -row can break the route consistency in such a way that
      an infra link associated with a stop point on journey pattern might not be part of the route anymore.';

CREATE TRIGGER queue_verify_infra_link_stop_refs_on_ssp_insert_trigger
  AFTER INSERT
  ON internal_service_pattern.scheduled_stop_point
  REFERENCING NEW TABLE AS new_table
  FOR EACH STATEMENT
EXECUTE PROCEDURE journey_pattern.queue_verify_infra_link_stop_refs_by_new_ssp_label();
COMMENT ON TRIGGER queue_verify_infra_link_stop_refs_on_ssp_insert_trigger
  ON internal_service_pattern.scheduled_stop_point
  IS 'Trigger to verify the infra link <-> scheduled stop point references.
      Inserting a scheduled_stop_point instance can break the route consistency in the following ways:
      1. The new stop point instance might be located on an infra link which is not part of all of its journey
         pattern''s routes.
      2. The stop point instance might be located on an infra link, whose position in a route does not correspond to the
         position of the stop point in the corresponding journey pattern.';
CREATE TRIGGER queue_verify_infra_link_stop_refs_on_ssp_update_trigger
  AFTER UPDATE
  ON internal_service_pattern.scheduled_stop_point
  REFERENCING NEW TABLE AS new_table
  FOR EACH STATEMENT
EXECUTE PROCEDURE journey_pattern.queue_verify_infra_link_stop_refs_by_new_ssp_label();
COMMENT ON TRIGGER queue_verify_infra_link_stop_refs_on_ssp_update_trigger
  ON internal_service_pattern.scheduled_stop_point
  IS 'Trigger to verify the infra link <-> scheduled stop point references.
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
CREATE TRIGGER queue_verify_infra_link_stop_refs_on_ssp_delete_trigger
  AFTER DELETE
  ON internal_service_pattern.scheduled_stop_point
  REFERENCING OLD TABLE AS old_table
  FOR EACH STATEMENT
EXECUTE PROCEDURE journey_pattern.queue_verify_infra_link_stop_refs_by_old_ssp_label();
COMMENT ON TRIGGER queue_verify_infra_link_stop_refs_on_ssp_delete_trigger
  ON internal_service_pattern.scheduled_stop_point
  IS 'Trigger to verify the infra link <-> scheduled stop point references.
      Deleting a scheduled_stop_point instance can break the route consistency in the following ways:
      1. The deleted stop point instance may "reveal" a lower priority stop point instance, which may make the route and
         journey pattern conflict in the ways described above (see trigger for insertion of a row in the
         scheduled_stop_point table).
      2. The updated stop point might not anymore have any instances whose validity time would at all overlap with the
         journey pattern''s route''s validity time ("ghost stop").';

CREATE TRIGGER queue_verify_infra_link_stop_refs_on_jp_update_trigger
  AFTER UPDATE
  ON journey_pattern.journey_pattern
  REFERENCING NEW TABLE AS new_table
  FOR EACH STATEMENT
EXECUTE PROCEDURE journey_pattern.queue_verify_infra_link_stop_refs_by_new_journey_pattern_id();
COMMENT ON TRIGGER queue_verify_infra_link_stop_refs_on_jp_update_trigger
  ON journey_pattern.journey_pattern
  IS 'Trigger to verify the infra link <-> scheduled stop point references.
      Updating a journey_pattern''s reference to a route (on_route_id) can break the route consistency in a way that
      the new route is in violation with the journey pattern''s stop points in one of the following ways:
      1. A stop point of the journey pattern might be located on an infra link which is not part of the journey
         pattern''s new route.
      2. The journey pattern may contain a stop point located at a position in the journey pattern, which does not
         correspond to the position of the stop point''s infra link within the new route.
      3. A stop point might not have any instances whose validity time would at all overlap with the journey
         pattern''s new route''s validity time ("ghost stop").';

CREATE TRIGGER queue_verify_infra_link_stop_refs_on_route_delete_trigger
  AFTER DELETE
  ON route.route
  REFERENCING OLD TABLE AS old_table
  FOR EACH STATEMENT
EXECUTE PROCEDURE journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_label();
COMMENT ON TRIGGER queue_verify_infra_link_stop_refs_on_route_delete_trigger
  ON route.route
  IS 'Trigger to verify the infra link <-> scheduled stop point references.
      Deleting a route row can "reveal" a lower priority route instance (which was not valid before), which may be
      break the route consistency such that:
      1. The revealed route''s journey pattern may contain a stop point, which is located on an infra link not part of
         the revealed route.
      2. The revealed route''s journey pattern may contain a stop point located at a position in the journey pattern,
         which does not correspond to the position of the stop point''s infra link within the revealed route.
      3. A stop point of the revealed route''s journey pattern might not have any instances whose validity time overlap
         at all with the revealed route''s validity time ("ghost stop").';



CREATE CONSTRAINT TRIGGER verify_infra_link_stop_refs_on_sspijp_trigger
  AFTER INSERT OR UPDATE
  ON journey_pattern.scheduled_stop_point_in_journey_pattern
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
  WHEN (NOT journey_pattern.infra_link_stop_refs_already_verified())
EXECUTE PROCEDURE journey_pattern.verify_infra_link_stop_refs();
COMMENT ON
  TRIGGER verify_infra_link_stop_refs_on_sspijp_trigger
  ON journey_pattern.scheduled_stop_point_in_journey_pattern IS
  'Trigger to verify the infra link <-> stop references after an insert or update on the
   scheduled_stop_point_in_journey_pattern table.

   This trigger will cause those routes to be checked, whose ID was queued to be checked by a statement
   level trigger.';

CREATE CONSTRAINT TRIGGER verify_infra_link_stop_refs_on_ilar_trigger
  AFTER UPDATE OR DELETE
  ON route.infrastructure_link_along_route
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
  WHEN (NOT journey_pattern.infra_link_stop_refs_already_verified())
EXECUTE PROCEDURE journey_pattern.verify_infra_link_stop_refs();
COMMENT ON
  TRIGGER verify_infra_link_stop_refs_on_ilar_trigger
  ON route.infrastructure_link_along_route IS
  'Trigger to verify the infra link <-> stop references after an update or delete on the
   infrastructure_link_along_route table.

   This trigger will cause those routes to be checked, whose ID was queued to be checked by a statement
   level trigger.';

CREATE CONSTRAINT TRIGGER verify_infra_link_stop_refs_on_scheduled_stop_point_trigger
  AFTER INSERT OR UPDATE OR DELETE
  ON internal_service_pattern.scheduled_stop_point
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
  WHEN (NOT journey_pattern.infra_link_stop_refs_already_verified())
EXECUTE PROCEDURE journey_pattern.verify_infra_link_stop_refs();
COMMENT ON
  TRIGGER verify_infra_link_stop_refs_on_scheduled_stop_point_trigger
  ON internal_service_pattern.scheduled_stop_point IS
  'Trigger to verify the infra link <-> stop references after an insert, update, or delete on the
   scheduled_stop_point table.

   This trigger will cause those routes to be checked, whose ID was queued to be checked by a statement
   level trigger.';

CREATE CONSTRAINT TRIGGER verify_infra_link_stop_refs_on_journey_pattern_trigger
  AFTER UPDATE
  ON journey_pattern.journey_pattern
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
  WHEN (NOT journey_pattern.infra_link_stop_refs_already_verified())
EXECUTE PROCEDURE journey_pattern.verify_infra_link_stop_refs();
COMMENT ON
  TRIGGER verify_infra_link_stop_refs_on_journey_pattern_trigger
  ON journey_pattern.journey_pattern IS
  'Trigger to verify the infra link <-> stop references after an update on the
   journey_pattern table.

   This trigger will cause those routes to be checked, whose ID was queued to be checked by a statement
   level trigger.';


CREATE CONSTRAINT TRIGGER verify_infra_link_stop_refs_on_route_trigger
  AFTER DELETE
  ON route.route
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
  WHEN (NOT journey_pattern.infra_link_stop_refs_already_verified())
EXECUTE PROCEDURE journey_pattern.verify_infra_link_stop_refs();
COMMENT ON
  TRIGGER verify_infra_link_stop_refs_on_journey_pattern_trigger
  ON journey_pattern.journey_pattern IS
  'Trigger to verify the infra link <-> stop references after a delete on the
   route table.

   This trigger will cause those routes to be checked, whose ID was queued to be checked by a statement
   level trigger.';
