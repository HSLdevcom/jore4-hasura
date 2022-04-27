DROP VIEW route.route;

ALTER VIEW deleted.route_1651054214739
SET SCHEMA route;

ALTER VIEW route.route_1651054214739
RENAME TO route;

DROP FUNCTION route.insert_route;

ALTER FUNCTION deleted.insert_route_1651054214739 ()
SET SCHEMA route;

ALTER FUNCTION route.insert_route_1651054214739 ()
RENAME TO insert_route;

DROP FUNCTION route.update_route;

ALTER FUNCTION deleted.update_route_1651054214739 ()
  SET SCHEMA route;

ALTER FUNCTION route.update_route_1651054214739 ()
  RENAME TO update_route;
