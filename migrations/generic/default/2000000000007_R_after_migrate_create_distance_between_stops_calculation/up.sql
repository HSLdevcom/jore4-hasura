CREATE OR REPLACE FUNCTION service_pattern.prevent_inserting_distance_between_stops_calculation() RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN NULL;
END;
$$;

CREATE TRIGGER prevent_insertion_to_distance_between_stops_calculation
  BEFORE INSERT ON service_pattern.distance_between_stops_calculation
  FOR EACH ROW EXECUTE FUNCTION service_pattern.prevent_inserting_distance_between_stops_calculation();
