
--------------------------------------------------------
-- drop the new functions
--------------------------------------------------------

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



DROP FUNCTION journey_pattern.get_broken_route_check_filters(filter_route_ids UUID[]);



DROP FUNCTION journey_pattern.maximum_priority_validity_spans(
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
);


DROP FUNCTION journey_pattern.get_broken_route_journey_patterns(
  filter_route_ids UUID[],
  replace_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE,
  new_priority INT
);


DROP FUNCTION journey_pattern.check_infra_link_stop_refs_with_new_scheduled_stop_point(
  replace_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE,
  new_priority INT
);


DROP FUNCTION journey_pattern.create_verify_infra_link_stop_refs_queue_temp_table();

DROP FUNCTION journey_pattern.verify_infra_link_stop_refs();


DROP FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_ssp_label();

DROP FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_id();

DROP FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_journey_pattern_id();

-- previously queue_verify_infra_link_stop_refs_by_other_journey_pattern_ids
DROP FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_ssp_label();

-- previously queue_verify_infra_link_stop_refs_by_other_route_ids
DROP FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_label();



--------------------------------------------------------
-- restore previous version of functions and triggers
--------------------------------------------------------

ALTER FUNCTION deleted.maximum_priority_validity_spans_1661496355072(
  entity_type TEXT,
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
  SET SCHEMA journey_pattern;

ALTER FUNCTION journey_pattern.maximum_priority_validity_spans_1661496355072(
  entity_type TEXT,
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
  RENAME TO maximum_priority_validity_spans;



ALTER FUNCTION deleted.check_route_journey_pattern_refs_1661496355072(
  filter_journey_pattern_id uuid,
  filter_route_id uuid,
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

ALTER FUNCTION journey_pattern.check_route_journey_pattern_refs_1661496355072(
  filter_journey_pattern_id uuid,
  filter_route_id uuid,
  replace_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE,
  new_priority INT
  )
  RENAME TO check_route_journey_pattern_refs;



ALTER FUNCTION deleted.check_infra_link_stop_refs_with_new_ssp_1661496355072(
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

ALTER FUNCTION journey_pattern.check_infra_link_stop_refs_with_new_ssp_1661496355072(
  replace_scheduled_stop_point_id UUID,
  new_located_on_infrastructure_link_id UUID,
  new_measured_location geography(PointZ, 4326),
  new_direction TEXT,
  new_label TEXT,
  new_validity_start timestamp WITH TIME ZONE,
  new_validity_end timestamp WITH TIME ZONE,
  new_priority INT
  )
  RENAME TO check_infra_link_stop_refs_with_new_scheduled_stop_point;



ALTER FUNCTION deleted.create_verify_infra_link_stop_refs_queue_temp_t_1661496355072()
  SET SCHEMA journey_pattern;

ALTER FUNCTION journey_pattern.create_verify_infra_link_stop_refs_queue_temp_t_1661496355072()
  RENAME TO create_verify_infra_link_stop_refs_queue_temp_table;



ALTER FUNCTION deleted.verify_infra_link_stop_refs_1661496355072()
  SET SCHEMA journey_pattern;

ALTER FUNCTION journey_pattern.verify_infra_link_stop_refs_1661496355072()
  RENAME TO verify_infra_link_stop_refs;



ALTER FUNCTION deleted.queue_verify_infra_link_stop_refs_by_new_ssp_l_1661496355072()
  SET SCHEMA journey_pattern;

ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_ssp_l_1661496355072()
  RENAME TO queue_verify_infra_link_stop_refs_by_new_ssp_label;


ALTER FUNCTION deleted.queue_verify_infra_link_stop_refs_by_old_route_id_1661496355072()
  SET SCHEMA journey_pattern;

ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_id_1661496355072()
  RENAME TO queue_verify_infra_link_stop_refs_by_old_route_id;


ALTER FUNCTION deleted.queue_verify_infra_link_stop_refs_by_new_jp_id_1661496355072()
  SET SCHEMA journey_pattern;

ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_new_jp_id_1661496355072()
  RENAME TO queue_verify_infra_link_stop_refs_by_new_journey_pattern_id;


ALTER FUNCTION deleted.queue_verify_infra_link_stop_refs_by_other_jp_ids_1661496355072()
  SET SCHEMA journey_pattern;

ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_other_jp_ids_1661496355072()
  RENAME TO queue_verify_infra_link_stop_refs_by_other_journey_pattern_ids;


ALTER FUNCTION deleted.queue_verify_infra_link_stop_refs_by_other_r_ids_1661496355072()
  SET SCHEMA journey_pattern;

ALTER FUNCTION journey_pattern.queue_verify_infra_link_stop_refs_by_other_r_ids_1661496355072()
  RENAME TO queue_verify_infra_link_stop_refs_by_other_route_ids;



--------------------------------------------------------
-- re-create the triggers
--------------------------------------------------------

CREATE TRIGGER queue_verify_infra_link_stop_refs_on_sspijp_insert_trigger
  AFTER INSERT
  ON journey_pattern.scheduled_stop_point_in_journey_pattern
  REFERENCING NEW TABLE AS new_table
  FOR EACH STATEMENT
EXECUTE PROCEDURE journey_pattern.queue_verify_infra_link_stop_refs_by_new_journey_pattern_id();
CREATE TRIGGER queue_verify_infra_link_stop_refs_on_sspijp_update_trigger
  AFTER UPDATE
  ON journey_pattern.scheduled_stop_point_in_journey_pattern
  REFERENCING NEW TABLE AS new_table
  FOR EACH STATEMENT
EXECUTE PROCEDURE journey_pattern.queue_verify_infra_link_stop_refs_by_new_journey_pattern_id();

CREATE TRIGGER queue_verify_infra_link_stop_refs_on_ilar_update_trigger
  AFTER UPDATE
  ON route.infrastructure_link_along_route
  REFERENCING OLD TABLE AS old_table
  FOR EACH STATEMENT
EXECUTE PROCEDURE journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_id();
CREATE TRIGGER queue_verify_infra_link_stop_refs_on_ilar_delete_trigger
  AFTER DELETE
  ON route.infrastructure_link_along_route
  REFERENCING OLD TABLE AS old_table
  FOR EACH STATEMENT
EXECUTE PROCEDURE journey_pattern.queue_verify_infra_link_stop_refs_by_old_route_id();

CREATE TRIGGER queue_verify_infra_link_stop_refs_on_ssp_insert_trigger
  AFTER INSERT
  ON internal_service_pattern.scheduled_stop_point
  REFERENCING NEW TABLE AS new_table
  FOR EACH STATEMENT
EXECUTE PROCEDURE journey_pattern.queue_verify_infra_link_stop_refs_by_new_ssp_label();
CREATE TRIGGER queue_verify_infra_link_stop_refs_on_ssp_update_trigger
  AFTER UPDATE
  ON internal_service_pattern.scheduled_stop_point
  REFERENCING NEW TABLE AS new_table
  FOR EACH STATEMENT
EXECUTE PROCEDURE journey_pattern.queue_verify_infra_link_stop_refs_by_new_ssp_label();
CREATE TRIGGER queue_verify_infra_link_stop_refs_on_ssp_delete_trigger
  AFTER DELETE
  ON internal_service_pattern.scheduled_stop_point
  REFERENCING OLD TABLE AS old_table
  FOR EACH STATEMENT
EXECUTE PROCEDURE journey_pattern.queue_verify_infra_link_stop_refs_by_other_journey_pattern_ids();

CREATE TRIGGER queue_verify_infra_link_stop_refs_on_jp_update_trigger
  AFTER UPDATE
  ON journey_pattern.journey_pattern
  REFERENCING NEW TABLE AS new_table
  FOR EACH STATEMENT
EXECUTE PROCEDURE journey_pattern.queue_verify_infra_link_stop_refs_by_new_journey_pattern_id();

CREATE TRIGGER queue_verify_infra_link_stop_refs_on_route_delete_trigger
  AFTER DELETE
  ON route.route
  REFERENCING OLD TABLE AS old_table
  FOR EACH STATEMENT
EXECUTE PROCEDURE journey_pattern.queue_verify_infra_link_stop_refs_by_other_route_ids();



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
  'Check inclusion of a stop into a journey pattern (through insert / update):
     - included stop might be on a link, which is not included in the journey pattern''s route
     - included stop might be included at a position, which does not correspond to the position of its
       infra link in the journey pattern''s route
     - included stop''s link might be traversed in a direction not suitable with the route''s traversal
       direction
   Exclusion of a stop from a journey pattern (through update / delete) is not a problem,
   because it cannot get the order of the stops mixed up.';

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
  'Check exclusion of a link from a route (through update / delete):
     - a route''s journey pattern may contain a stop point residing on that link
   Inclusion of a link (through insert / update) is not a problem, because it cannot get the order of the
   stops mixed up (stop residing on a route''s link cannot be part of journey pattern already at that stage).';

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
  'Check if the stop is moved to a link
     - that is not part of all the routes'' journey patterns the stop is part of OR
     - which is in the wrong order in the stop''s journey patterns OR
     - which is traversed in the wrong direction compared to the stop''s allowed directions

  Also check the journey patterns, which have stops with the same label, in case the stop is removed.
  Other stops with the same label and lower priority might become "visible" in that case.';

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
  'Check if the journey pattern is moved to a route
    - which does not contain all links the journey pattern''s stops reside on OR
    - which traverses a link of a stop of the journey pattern in the wrong direction compared to the stop''s allowed
      directions';


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
  'Check the integrity of routes with lower priorities in case a route is removed.
  Other routes with the same label and lower priority might become "visible" in that case.';
