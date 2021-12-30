ALTER TABLE route.infrastructure_link_along_route
  DROP CONSTRAINT infrastructure_link_along_route_infrastructure_link_id_fkey,
  ADD CONSTRAINT infrastructure_link_along_route_infrastructure_link_id_fkey
    FOREIGN KEY (infrastructure_link_id)
      REFERENCES infrastructure_network.infrastructure_link (infrastructure_link_id)
      ON UPDATE NO ACTION
      ON DELETE NO ACTION;
