CREATE SCHEMA localization;
COMMENT ON SCHEMA localization IS
  'Tables for storing localized texts for entities';

CREATE TABLE localization.languages (
  language_code text PRIMARY KEY
);
COMMENT ON TABLE localization.languages IS
  'List of languages in which the localized texts may come. Used as enum table';
INSERT INTO localization.languages (language_code)
  VALUES ('en_US'), ('fi_FI'), ('sv_SV');

CREATE TABLE localization.codesets (
  codeset_id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  codeset_name text NOT NULL,
  -- Hasura does not support unique indexes in "ON CONSTRAINT" clauses, thus creating constraint
  -- Note that this automatically creates an index as well
  CONSTRAINT unique_codeset_name UNIQUE (codeset_name)
);
COMMENT ON TABLE localization.codesets IS
  'List of names which are used as localization keys';
COMMENT ON COLUMN localization.codesets.codeset_name IS
  'List of names which are used as localization keys. Should be namespaced (e.g. "route_name")';

CREATE TABLE localization.localized_texts (
  entity_id uuid NOT NULL,
  codeset_id uuid NOT NULL REFERENCES localization.codesets (codeset_id),
  language_code text NOT NULL REFERENCES localization.languages (language_code),
  localized_text text,
  PRIMARY KEY (entity_id, codeset_id, language_code)
);
CREATE INDEX ON localization.localized_texts (entity_id);
CREATE INDEX ON localization.localized_texts (codeset_id);
CREATE INDEX ON localization.localized_texts (language_code);
COMMENT ON TABLE localization.localized_texts IS
  'List of localized texts for entities like routes, lines, etc.';
COMMENT ON COLUMN localization.localized_texts.entity_id IS
  'ID of the entity the localized text refers to';
COMMENT ON COLUMN localization.localized_texts.codeset_id IS
  'ID of the localization key the localized text refers to';
COMMENT ON COLUMN localization.localized_texts.language_code IS
  'Language of the localized text';
COMMENT ON COLUMN localization.localized_texts.localized_text IS
  'The localized text itself, in UTF-8 format';
