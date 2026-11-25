CREATE OR REPLACE FUNCTION route.search_for_routes(
  "query" TEXT,
  "observationDate" DATE,
  "priorities" INT[] DEFAULT NULL,
  "transportationModes" TEXT[] DEFAULT NULL,
  "typesOfLines" TEXT[] DEFAULT NULL
) RETURNS SETOF route.route_search
LANGUAGE sql STABLE AS $$
  WITH filtered_routes AS (
    SELECT DISTINCT ON (unique_label, direction) route_id
    FROM route.route
    INNER JOIN route.line ON line.line_id = route.on_line_id
    WHERE (query IS NULL OR unique_label ILIKE query)
      AND (array_length(priorities, 1) IS NULL OR route.priority = ANY (priorities))
      AND route.validity_start <= "observationDate"
      AND (route.validity_end IS NULL OR route.validity_end >= "observationDate")
      AND (array_length("transportationModes", 1) IS NULL OR line.primary_vehicle_mode = ANY("transportationModes"))
      AND (array_length("typesOfLines", 1)        IS NULL OR line.type_of_line         = ANY("typesOfLines"))
    ORDER BY unique_label, direction, route.priority DESC
  )
  SELECT route_search.*
  FROM route.route_search
  WHERE route_id IN (SELECT route_id FROM filtered_routes)
$$;
