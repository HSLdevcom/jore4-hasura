INSERT INTO infrastructure_network.external_source VALUES ('hsl_fixup');

UPDATE infrastructure_network.infrastructure_link
  SET external_link_source = 'hsl_fixup'
  WHERE external_link_source = 'fixup';

DELETE FROM infrastructure_network.external_source WHERE value = 'fixup';
