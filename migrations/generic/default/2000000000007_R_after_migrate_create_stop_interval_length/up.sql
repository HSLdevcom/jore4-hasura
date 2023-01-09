CREATE OR REPLACE FUNCTION service_pattern.prevent_inserting_stop_interval_length() RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN NULL;
END;
$$;

CREATE TRIGGER prevent_stop_interval_length_insertion BEFORE INSERT ON service_pattern.stop_interval_length FOR EACH ROW EXECUTE FUNCTION service_pattern.prevent_inserting_stop_interval_length();
