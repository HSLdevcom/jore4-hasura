
-- just set all the links' vehicle submodes to "generic_bus"
INSERT INTO infrastructure_network.vehicle_submode_on_infrastructure_link
SELECT
  il.infrastructure_link_id,
  'generic_bus' AS vehicle_submode
FROM infrastructure_network.infrastructure_link il;
