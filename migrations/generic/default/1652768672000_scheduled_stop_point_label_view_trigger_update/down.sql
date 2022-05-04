
DROP TRIGGER service_pattern_insert_scheduled_stop_point_trigger
  ON service_pattern.scheduled_stop_point;

DROP FUNCTION service_pattern.insert_scheduled_stop_point ();

ALTER FUNCTION deleted.insert_scheduled_stop_point_1651476243443 ()
  SET SCHEMA service_pattern;

ALTER FUNCTION service_pattern.insert_scheduled_stop_point_1651476243443 ()
  RENAME TO insert_scheduled_stop_point;

CREATE TRIGGER service_pattern_insert_scheduled_stop_point_trigger
  INSTEAD OF INSERT ON service_pattern.scheduled_stop_point
  FOR EACH ROW EXECUTE PROCEDURE service_pattern.insert_scheduled_stop_point();



DROP TRIGGER service_pattern_update_scheduled_stop_point_trigger
  ON service_pattern.scheduled_stop_point;

DROP FUNCTION service_pattern.update_scheduled_stop_point ();

ALTER FUNCTION deleted.update_scheduled_stop_point_1651476243443 ()
  SET SCHEMA service_pattern;

ALTER FUNCTION service_pattern.update_scheduled_stop_point_1651476243443 ()
  RENAME TO update_scheduled_stop_point;

CREATE TRIGGER service_pattern_update_scheduled_stop_point_trigger
  INSTEAD OF UPDATE ON service_pattern.scheduled_stop_point
  FOR EACH ROW EXECUTE PROCEDURE service_pattern.update_scheduled_stop_point();



DROP TRIGGER service_pattern_delete_scheduled_stop_point_trigger
  ON service_pattern.scheduled_stop_point;

DROP FUNCTION service_pattern.delete_scheduled_stop_point ();

ALTER FUNCTION deleted.delete_scheduled_stop_point_1651476243443 ()
  SET SCHEMA service_pattern;

ALTER FUNCTION service_pattern.delete_scheduled_stop_point_1651476243443 ()
  RENAME TO delete_scheduled_stop_point;

CREATE TRIGGER service_pattern_delete_scheduled_stop_point_trigger
  INSTEAD OF DELETE ON service_pattern.scheduled_stop_point
  FOR EACH ROW EXECUTE PROCEDURE service_pattern.delete_scheduled_stop_point();


DROP FUNCTION internal_service_pattern.insert_scheduled_stop_point_label (text);
DROP FUNCTION internal_service_pattern.delete_scheduled_stop_point_label (text);
