ALTER TABLE infrastructure_network.vehicle_submode_on_infrastructure_link
  DROP CONSTRAINT vehicle_submode_on_infrastructure_link_infrastructure_link_id_fkey,
  ADD CONSTRAINT vehicle_submode_on_infrastructure_l_infrastructure_link_id_fkey
    FOREIGN KEY (infrastructure_link_id)
  REFERENCES infrastructure_network.infrastructure_link (infrastructure_link_id)
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;
