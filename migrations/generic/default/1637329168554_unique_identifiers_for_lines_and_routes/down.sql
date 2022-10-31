-- line changes
----------------

ALTER TABLE route.line
  DROP COLUMN label;

-- route changes
-----------------

DROP VIEW route.route;

ALTER VIEW deleted.route_1637329168554
SET SCHEMA route;

ALTER VIEW route.route_1637329168554
RENAME TO route;

ALTER TABLE internal_route.route
DROP COLUMN label,
DROP COLUMN direction;

DROP FUNCTION route.insert_route;

ALTER FUNCTION deleted.insert_route_1637329168554 ()
SET SCHEMA route;

ALTER FUNCTION route.insert_route_1637329168554 ()
RENAME TO insert_route;

DROP FUNCTION route.update_route;

ALTER FUNCTION deleted.update_route_1637329168554 ()
  SET SCHEMA route;

ALTER FUNCTION route.update_route_1637329168554 ()
  RENAME TO update_route;

-- general
-----------

DROP SCHEMA deleted;
