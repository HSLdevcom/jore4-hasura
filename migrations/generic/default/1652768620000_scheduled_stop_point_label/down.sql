-- changes need to be made in separate transactions because of existing constraints

BEGIN;

ALTER TABLE journey_pattern.scheduled_stop_point_in_journey_pattern
  ADD COLUMN scheduled_stop_point_id uuid,
  ALTER COLUMN scheduled_stop_point_label DROP NOT NULL;

-- try to set the first referenced stop point id, whose validity time overlaps with the route's validity time
UPDATE journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
SET scheduled_stop_point_id = (
  SELECT scheduled_stop_point_id
  FROM internal_service_pattern.scheduled_stop_point
         INNER JOIN journey_pattern.journey_pattern
              ON journey_pattern.journey_pattern.journey_pattern_id = sspijp.journey_pattern_id
         INNER JOIN route.route
              ON route.route.route_id = journey_pattern.journey_pattern.on_route_id
  WHERE internal_service_pattern.scheduled_stop_point.label = sspijp.scheduled_stop_point_label
    AND TSTZRANGE(internal_service_pattern.scheduled_stop_point.validity_start, internal_service_pattern.scheduled_stop_point.validity_end) && TSTZRANGE(route.route.validity_start, route.route.validity_end)
  ORDER BY internal_service_pattern.scheduled_stop_point.validity_start ASC
  LIMIT 1
);

-- if there was no overlapping validity time with any stop point, set the first stop point id found
UPDATE journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
SET scheduled_stop_point_id = (
  SELECT internal_service_pattern.scheduled_stop_point.scheduled_stop_point_id
  FROM internal_service_pattern.scheduled_stop_point
  WHERE internal_service_pattern.scheduled_stop_point.label = sspijp.scheduled_stop_point_label
  ORDER BY internal_service_pattern.scheduled_stop_point.validity_start ASC
  LIMIT 1
)
WHERE scheduled_stop_point_id IS NULL;

COMMIT;


BEGIN;

ALTER TABLE journey_pattern.scheduled_stop_point_in_journey_pattern
  ALTER COLUMN scheduled_stop_point_id SET NOT NULL,
  ADD CONSTRAINT scheduled_stop_point_in_journey__scheduled_stop_point_id_fkey FOREIGN KEY (scheduled_stop_point_id)
    REFERENCES internal_service_pattern.scheduled_stop_point (scheduled_stop_point_id);

DROP INDEX journey_pattern.scheduled_stop_point_in_journey__scheduled_stop_point_label_idx;

COMMIT;


BEGIN;

ALTER TABLE journey_pattern.scheduled_stop_point_in_journey_pattern
  DROP COLUMN scheduled_stop_point_label;

DROP INDEX internal_service_pattern.scheduled_stop_point_label_idx;

ALTER TABLE internal_service_pattern.scheduled_stop_point
  DROP CONSTRAINT scheduled_stop_point_scheduled_stop_point_invariant_label_fkey;

DROP TABLE internal_service_pattern.scheduled_stop_point_invariant;

COMMIT;
