-- For testing purposes when checking the migrations' data compatibility, we do not want delete the
-- seed data in the "down" migrations... Which results in having some data in the database when
-- testing the migrations.
-- However when running the complementing "up" migrations again, these inserts get in conflict with
-- the existing data, so we need to skip these errors using "ON CONFLICT DO NOTHING";

-- just set all the links' vehicle submodes to "generic_bus"
INSERT INTO infrastructure_network.vehicle_submode_on_infrastructure_link
SELECT
  il.infrastructure_link_id,
  'generic_bus' AS vehicle_submode
FROM infrastructure_network.infrastructure_link il
ON CONFLICT DO NOTHING;
