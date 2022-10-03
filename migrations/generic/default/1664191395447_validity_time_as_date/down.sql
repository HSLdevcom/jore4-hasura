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
  ALTER COLUMN validity_start TYPE TIMESTAMP WITH TIME ZONE USING validity_start::TIMESTAMP WITH TIME ZONE;
ALTER TABLE internal_service_pattern.scheduled_stop_point
  ALTER COLUMN validity_end TYPE TIMESTAMP WITH TIME ZONE USING validity_end::TIMESTAMP WITH TIME ZONE;

ALTER TABLE internal_service_pattern.scheduled_stop_point
  ADD CONSTRAINT unique_validity_period EXCLUDE USING GIST (
    label WITH =,
    priority WITH =,
    tstzrange(validity_start, validity_end) WITH &&
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

-- This function was removed from the deleted schema, because the view was deleted.
-- Unfortunately, this problem cannot be avoided by only renaming the view, because the scheduled_stop_point-table's
-- valdity-time columns' data type changes (which is not allowed when in use by a view).

CREATE FUNCTION deleted.get_scheduled_stop_points_with_new_1657795756608(
  replace_scheduled_stop_point_id UUID DEFAULT NULL,
  new_scheduled_stop_point_id UUID DEFAULT NULL,
  new_located_on_infrastructure_link_id UUID DEFAULT NULL,
  new_measured_location geography(PointZ, 4326) DEFAULT NULL,
  new_direction TEXT DEFAULT NULL,
  new_label TEXT DEFAULT NULL,
  new_validity_start timestamp WITH TIME ZONE DEFAULT NULL,
  new_validity_end timestamp WITH TIME ZONE DEFAULT NULL
)
  RETURNS SETOF service_pattern.scheduled_stop_point
  STABLE
  LANGUAGE plpgsql
AS
$$
BEGIN
  IF new_scheduled_stop_point_id IS NULL THEN
    RETURN QUERY
      SELECT * FROM service_pattern.scheduled_stop_point ssp
      WHERE replace_scheduled_stop_point_id IS NULL OR ssp.scheduled_stop_point_id != replace_scheduled_stop_point_id;
  ELSE
    RETURN QUERY
      SELECT * FROM service_pattern.scheduled_stop_point ssp
      WHERE replace_scheduled_stop_point_id IS NULL OR ssp.scheduled_stop_point_id != replace_scheduled_stop_point_id
      UNION ALL
      SELECT
        new_scheduled_stop_point_id, new_label, new_measured_location::geography(PointZ, 4326),
        new_located_on_infrastructure_link_id, new_direction,
        internal_utils.st_linelocatepoint(il.shape, new_measured_location) AS relative_distance_from_infrastructure_link_start,
        NULL::geography(PointZ, 4326) AS closest_point_on_infrastructure_link,
        new_validity_start, new_validity_end, NULL::integer AS priority
      FROM infrastructure_network.infrastructure_link il
      WHERE il.infrastructure_link_id = new_located_on_infrastructure_link_id;
  END IF;
END;
$$;
COMMENT ON FUNCTION deleted.get_scheduled_stop_points_with_new_1657795756608(
  replace_scheduled_stop_point_id UUID,
  new_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE)
  IS
    'Returns the scheduled stop points from the internal_service_pattern.scheduled_stop_point table.
     If replace_scheduled_stop_point_id is not null, the stop point with that ID is filtered out.
     Similarly, if the new_xxx arguments are specified, a scheduled stop point with those values is
     appended to the result (it is not inserted into the table).';



-- CHANGES FOR line

ALTER TABLE route.line
  ALTER COLUMN validity_start TYPE TIMESTAMP WITH TIME ZONE USING validity_start::TIMESTAMP WITH TIME ZONE;
ALTER TABLE route.line
  ALTER COLUMN validity_end TYPE TIMESTAMP WITH TIME ZONE USING validity_end::TIMESTAMP WITH TIME ZONE;
ALTER TABLE route.line
  ADD CONSTRAINT line_unique_validity_period EXCLUDE USING GIST (
    label WITH =,
    priority WITH =,
    tstzrange(validity_start, validity_end) WITH &&
    )
    WHERE (priority < internal_utils.const_priority_draft());


-- CHANGES FOR route

ALTER TABLE route.route
  ALTER COLUMN validity_start TYPE TIMESTAMP WITH TIME ZONE USING validity_start::TIMESTAMP WITH TIME ZONE;
ALTER TABLE route.route
  ALTER COLUMN validity_end TYPE TIMESTAMP WITH TIME ZONE USING validity_end::TIMESTAMP WITH TIME ZONE;
ALTER TABLE route.route
  ADD CONSTRAINT route_unique_validity_period EXCLUDE USING GIST (
    label WITH =,
    direction WITH =,
    priority WITH =,
    tstzrange(validity_start, validity_end) WITH &&
    )
    WHERE (priority < internal_utils.const_priority_draft());


-- --------------------------
-- FUNCTIONS
-- --------------------------

-- CHANGES FOR get_broken_route_journey_patterns

DROP FUNCTION journey_pattern.get_broken_route_journey_patterns(
  filter_route_ids UUID[],
  replace_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start DATE,
  new_validity_end DATE,
  new_priority INT
);

ALTER FUNCTION deleted.get_broken_route_journey_patterns_1664191395447(
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
  SET SCHEMA journey_pattern;

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
  RENAME TO get_broken_route_journey_patterns;


-- CHANGES FOR maximum_priority_validity_spans

DROP FUNCTION journey_pattern.maximum_priority_validity_spans(
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
);

ALTER FUNCTION deleted.maximum_priority_validity_spans_1664191395447(
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
  new_validity_start TIMESTAMP WITH TIME ZONE,
  new_validity_end TIMESTAMP WITH TIME ZONE,
  new_priority int
  )
  SET SCHEMA journey_pattern;

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
  new_validity_start TIMESTAMP WITH TIME ZONE,
  new_validity_end TIMESTAMP WITH TIME ZONE,
  new_priority int
  )
  RENAME TO maximum_priority_validity_spans;


-- CHANGES FOR get_broken_route_check_filters

DROP FUNCTION journey_pattern.get_broken_route_check_filters(filter_route_ids UUID[]);

ALTER FUNCTION deleted.get_broken_route_check_filters_1664191395447(
  filter_route_ids UUID[]
  )
  SET SCHEMA journey_pattern;

ALTER FUNCTION journey_pattern.get_broken_route_check_filters_1664191395447(
  filter_route_ids UUID[]
  )
  RENAME TO get_broken_route_check_filters;


-- CHANGES FOR check_infra_link_stop_refs_with_new_scheduled_stop_point

DROP FUNCTION journey_pattern.check_infra_link_stop_refs_with_new_scheduled_stop_point(
  replace_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start DATE,
  new_validity_end DATE,
  new_priority INT
);

ALTER FUNCTION deleted.check_infra_link_stop_refs_with_new_ssp_1664191395447(
  replace_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start TIMESTAMP WITH TIME ZONE,
  new_validity_end TIMESTAMP WITH TIME ZONE,
  new_priority INT
  )
  SET SCHEMA journey_pattern;

ALTER FUNCTION journey_pattern.check_infra_link_stop_refs_with_new_ssp_1664191395447(
  replace_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start TIMESTAMP WITH TIME ZONE,
  new_validity_end TIMESTAMP WITH TIME ZONE,
  new_priority INT
  )
  RENAME TO check_infra_link_stop_refs_with_new_scheduled_stop_point;


-- CHANGES FOR check_route_validity_is_within_line_validity

DROP FUNCTION route.check_route_validity_is_within_line_validity();

ALTER FUNCTION deleted.check_route_validity_is_within_line_validity_1664191395447()
  SET SCHEMA route;

ALTER FUNCTION route.check_route_validity_is_within_line_validity_1664191395447()
  RENAME TO check_route_validity_is_within_line_validity;


-- CHANGES FOR insert_scheduled_stop_point_with_vehicle_mode

DROP FUNCTION internal_service_pattern.insert_scheduled_stop_point_with_vehicle_mode(
  scheduled_stop_point_id uuid,
  measured_location geography(PointZ, 4326),
  located_on_infrastructure_link_id uuid,
  direction text,
  label text,
  validity_start date,
  validity_end date,
  priority integer,
  supported_vehicle_mode text
);

ALTER FUNCTION deleted.insert_scheduled_stop_point_with_vehicle_mode_1664191395447(
  scheduled_stop_point_id uuid,
  measured_location geography(PointZ, 4326),
  located_on_infrastructure_link_id uuid,
  direction text,
  label text,
  validity_start TIMESTAMP WITH TIME ZONE,
  validity_end TIMESTAMP WITH TIME ZONE,
  priority integer,
  supported_vehicle_mode text
  )
  SET SCHEMA internal_service_pattern;

ALTER FUNCTION internal_service_pattern.insert_scheduled_stop_point_with_vehicle_mode_1664191395447(
  scheduled_stop_point_id uuid,
  measured_location geography(PointZ, 4326),
  located_on_infrastructure_link_id uuid,
  direction text,
  label text,
  validity_start TIMESTAMP WITH TIME ZONE,
  validity_end TIMESTAMP WITH TIME ZONE,
  priority integer,
  supported_vehicle_mode text
  )
  RENAME TO insert_scheduled_stop_point_with_vehicle_mode;


-- CHANGES FOR get_scheduled_stop_points_with_new

-- The previous version of the internal_service_pattern.get_scheduled_stop_points_with_new -function cannot be restored
-- from the 'deleted' schema, because it was removed automatically due to the function signature referencing the
-- 'scheduled_stop_points' view, which was removed above.

CREATE FUNCTION internal_service_pattern.get_scheduled_stop_points_with_new(
  replace_scheduled_stop_point_id UUID DEFAULT NULL,
  new_scheduled_stop_point_id UUID DEFAULT NULL,
  new_located_on_infrastructure_link_id UUID DEFAULT NULL,
  new_measured_location geography(PointZ, 4326) DEFAULT NULL,
  new_direction TEXT DEFAULT NULL,
  new_label TEXT DEFAULT NULL,
  new_validity_start timestamp WITH TIME ZONE DEFAULT NULL,
  new_validity_end timestamp WITH TIME ZONE DEFAULT NULL,
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
      SELECT * FROM service_pattern.scheduled_stop_point ssp
      WHERE replace_scheduled_stop_point_id IS NULL OR ssp.scheduled_stop_point_id != replace_scheduled_stop_point_id;
  ELSE
    RETURN QUERY
      SELECT * FROM service_pattern.scheduled_stop_point ssp
      WHERE replace_scheduled_stop_point_id IS NULL OR ssp.scheduled_stop_point_id != replace_scheduled_stop_point_id
      UNION ALL
      SELECT
        new_scheduled_stop_point_id, new_label, new_measured_location::geography(PointZ, 4326),
        new_located_on_infrastructure_link_id, new_direction,
        internal_utils.st_linelocatepoint(il.shape, new_measured_location) AS relative_distance_from_infrastructure_link_start,
        NULL::geography(PointZ, 4326) AS closest_point_on_infrastructure_link,
        new_validity_start, new_validity_end, new_priority
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
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE,
  new_priority INT)
  IS
    'Returns the scheduled stop points from the internal_service_pattern.scheduled_stop_point table.
     If replace_scheduled_stop_point_id is not null, the stop point with that ID is filtered out.
     Similarly, if the new_xxx arguments are specified, a scheduled stop point with those values is
     appended to the result (it is not inserted into the table).';


-- --------------------------
-- HELPER FUNCTIONS
-- --------------------------

DROP FUNCTION internal_utils.date_closed_upper(
  range daterange
);

DROP FUNCTION internal_utils.daterange_closed_upper(
  lower_bound DATE,
  closed_upper_bound DATE
);

DROP FUNCTION internal_utils.date_open2closed_upper(
  bound DATE
);

DROP FUNCTION internal_utils.date_closed2open_upper(
  bound DATE
);


-- --------------------------
-- CONSTRAINT TRIGGERS
-- --------------------------

-- drop the new triggers

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


DROP FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_ssp_label();

ALTER FUNCTION deleted.queue_verify_infra_link_stop_refs_by_new_ssp_l_1664191395447()
  SET SCHEMA journey_pattern;

ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_ssp_l_1664191395447()
  RENAME TO queue_verify_infra_link_stop_refs_by_new_ssp_label;


DROP FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_id();

ALTER FUNCTION deleted.queue_verify_infra_link_stop_refs_by_old_route_id_1664191395447()
  SET SCHEMA journey_pattern;

ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_id_1664191395447()
  RENAME TO queue_verify_infra_link_stop_refs_by_old_route_id;


DROP FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_journey_pattern_id();

ALTER FUNCTION deleted.queue_verify_infra_link_stop_refs_by_new_jp_id_1664191395447()
  SET SCHEMA journey_pattern;

ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_jp_id_1664191395447()
  RENAME TO queue_verify_infra_link_stop_refs_by_new_journey_pattern_id;


DROP FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_ssp_label();

ALTER FUNCTION deleted.queue_verify_infra_link_stop_refs_by_old_ssp_l_1664191395447()
  SET SCHEMA journey_pattern;

ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_ssp_l_1664191395447()
  RENAME TO queue_verify_infra_link_stop_refs_by_old_ssp_label;


DROP FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_label();

ALTER FUNCTION deleted.queue_verify_infra_link_stop_refs_by_old_route_l_1664191395447()
  SET SCHEMA journey_pattern;

ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_l_1664191395447()
  RENAME TO queue_verify_infra_link_stop_refs_by_old_route_label;


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
