CREATE OR REPLACE FUNCTION journey_pattern.check_dead_run_consistency() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  route_is_dead_run boolean;
BEGIN
  SELECT is_dead_run INTO route_is_dead_run
    FROM route.route
    WHERE route_id = NEW.on_route_id;

  IF NEW.is_dead_run != route_is_dead_run THEN
    RAISE EXCEPTION 'journey_pattern.is_dead_run (%) does not match route.is_dead_run (%) for route %',
      NEW.is_dead_run, route_is_dead_run, NEW.on_route_id;
  END IF;

  RETURN NULL;
END;
$$;
COMMENT ON FUNCTION journey_pattern.check_dead_run_consistency()
IS 'Ensures that the is_dead_run flag of a journey pattern matches the flag of its route.';

DROP TRIGGER IF EXISTS check_dead_run_consistency_trigger ON journey_pattern.journey_pattern;
CREATE CONSTRAINT TRIGGER check_dead_run_consistency_trigger AFTER INSERT OR UPDATE ON journey_pattern.journey_pattern DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION journey_pattern.check_dead_run_consistency();

CREATE OR REPLACE FUNCTION journey_pattern.check_dead_run_stop_properties() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  journey_pattern_is_dead_run boolean;
BEGIN
  SELECT is_dead_run INTO journey_pattern_is_dead_run
    FROM journey_pattern.journey_pattern
    WHERE journey_pattern_id = NEW.journey_pattern_id;

  IF journey_pattern_is_dead_run IS TRUE AND NEW.is_loading_time_allowed IS TRUE THEN
    RAISE EXCEPTION 'Passenger loading time cannot be allowed on a dead run journey pattern (stop sequence %)',
      NEW.scheduled_stop_point_sequence;
  END IF;

  RETURN NULL;
END;
$$;
COMMENT ON FUNCTION journey_pattern.check_dead_run_stop_properties()
IS 'Disallows passenger loading time on the stops of a dead run journey pattern.';

DROP TRIGGER IF EXISTS check_dead_run_stop_properties_trigger ON journey_pattern.scheduled_stop_point_in_journey_pattern;
CREATE CONSTRAINT TRIGGER check_dead_run_stop_properties_trigger AFTER INSERT OR UPDATE ON journey_pattern.scheduled_stop_point_in_journey_pattern DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION journey_pattern.check_dead_run_stop_properties();
