UPDATE infrastructure_network.infrastructure_link
SET external_link_source = 'digiroad_r'
WHERE external_link_source = 'digiroad_r_mml';

DELETE FROM infrastructure_network.external_source
WHERE value IN ('digiroad_r_mml', 'digiroad_r_supplementary');
