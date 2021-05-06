DROP TABLE IF EXISTS
  infrastructure_network.infrastructure_network_types
  CASCADE;

ALTER TABLE IF EXISTS
  infrastructure_network.infrastructure_links
  DROP COLUMN IF EXISTS
  infrastructure_network_type_id
  CASCADE;
