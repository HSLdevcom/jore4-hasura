-- route changes
-----------------

DROP VIEW route.route;

ALTER VIEW deleted.route_1650625582906
SET SCHEMA route;

ALTER VIEW route.route_1650625582906
RENAME TO route;

ALTER TABLE internal_route.route
DROP COLUMN origin_name,
DROP COLUMN origin_name_short,
DROP COLUMN destination_name,
DROP COLUMN destination_name_short;

DROP FUNCTION route.insert_route;

ALTER FUNCTION deleted.insert_route_1650625582906 ()
SET SCHEMA route;

ALTER FUNCTION route.insert_route_1650625582906 ()
RENAME TO insert_route;

DROP FUNCTION route.update_route;

ALTER FUNCTION deleted.update_route_1650625582906 ()
  SET SCHEMA route;

ALTER FUNCTION route.update_route_1650625582906 ()
  RENAME TO update_route;
