ALTER TABLE route.infrastructure_link_along_route
  DROP CONSTRAINT infrastructure_link_along_route_route_id_fkey,
  ADD CONSTRAINT infrastructure_link_along_route_route_id_fkey
    FOREIGN KEY (route_id)
      REFERENCES internal_route.route (route_id)
      ON UPDATE NO ACTION
      ON DELETE NO ACTION;
