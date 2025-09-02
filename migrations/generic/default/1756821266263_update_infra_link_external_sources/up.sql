INSERT INTO infrastructure_network.external_source VALUES ('digiroad_r_mml'), ('digiroad_r_supplementary');

-- Update all existing infrastructure links to use "digiroad_r_mml" even though
-- this is not really the case. In future database dumps, we will also use
-- "digiroad_r_supplementary".
UPDATE infrastructure_network.infrastructure_link
SET external_link_source = 'digiroad_r_mml'
WHERE external_link_source = 'digiroad_r';

-- External source "digiroad_r" should be deleted in a future migration.
-- It is kept for now to avoid issues with the existing infrastructure link
-- population script (in the jore4-ui repository).
