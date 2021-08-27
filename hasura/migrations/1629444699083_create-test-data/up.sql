CREATE SCHEMA test;
GRANT ALL PRIVILEGES ON SCHEMA test TO xxx_db_username_xxx;

CREATE TABLE test.data (message VARCHAR(255));
INSERT INTO test.data VALUES ('Hello'), ('World!');
