CREATE SCHEMA test;
GRANT ALL PRIVILEGES ON SCHEMA test TO xxx_hsl_jore4_db_hasura_username_xxx;

CREATE TABLE test.data (message VARCHAR(255));
INSERT INTO test.data VALUES ('Hello'), ('World!');
