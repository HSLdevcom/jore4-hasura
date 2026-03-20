CREATE OR REPLACE FUNCTION network.prevent_inserting_distance_between_stops_calculation() RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN NULL;
END;
$$;

CREATE TRIGGER prevent_insertion_to_distance_between_stops_calculation
  BEFORE INSERT ON network.distance_between_stops_calculation
  FOR EACH ROW EXECUTE FUNCTION network.prevent_inserting_distance_between_stops_calculation();
