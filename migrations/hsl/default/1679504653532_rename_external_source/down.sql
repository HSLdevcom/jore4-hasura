INSERT INTO infrastructure_network.external_source VALUES ('fixup');

UPDATE infrastructure_network.infrastructure_link
  SET external_link_source = 'fixup'
  WHERE external_link_source = 'hsl_fixup';

DELETE FROM infrastructure_network.external_source WHERE value = 'hsl_fixup';
