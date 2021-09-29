
-- Initializations, which are needed locally, but not in the cloud / prod environments,
-- go here.

-- These users are created from the jore4-deploy repository in cloud environments.
CREATE USER jore4auth PASSWORD 'jore4auth';
CREATE USER jore3importer PASSWORD 'jore3importer';
