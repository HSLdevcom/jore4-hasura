ALTER TABLE route.line
DROP COLUMN type_of_line;

DROP TABLE route.type_of_line;

DROP TRIGGER check_type_of_line_vehicle_mode_trigger
  ON route.line;

DROP FUNCTION route.check_type_of_line_vehicle_mode();
