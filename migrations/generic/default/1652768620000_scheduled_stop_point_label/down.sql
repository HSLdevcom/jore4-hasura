
-- changes need to be made in separate transactions because of existing constraints

BEGIN;

ALTER TABLE journey_pattern.scheduled_stop_point_in_journey_pattern
  ADD COLUMN scheduled_stop_point_id uuid,
  ALTER COLUMN scheduled_stop_point_label DROP NOT NULL;

-- try to set the first referenced stop point id, whose validity time overlaps with the route's validity time
UPDATE journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
SET scheduled_stop_point_id = (
  SELECT scheduled_stop_point_id
  FROM internal_service_pattern.scheduled_stop_point ssp
         JOIN journey_pattern.journey_pattern jp
              ON jp.journey_pattern_id = sspijp.journey_pattern_id
         JOIN route.route r
              ON r.route_id = jp.on_route_id
  WHERE ssp.label = sspijp.scheduled_stop_point_label
    AND TSTZRANGE(ssp.validity_start, ssp.validity_end) && TSTZRANGE(r.validity_start, r.validity_end)
  ORDER BY ssp.validity_start ASC
  LIMIT 1
);

-- if there was no overlapping validity time with any stop point, set the first stop point id found
UPDATE journey_pattern.scheduled_stop_point_in_journey_pattern sspijp
SET scheduled_stop_point_id = (
  SELECT scheduled_stop_point_id
  FROM internal_service_pattern.scheduled_stop_point ssp
  WHERE ssp.label = sspijp.scheduled_stop_point_label
  ORDER BY ssp.validity_start ASC
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
