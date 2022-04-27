CREATE SCHEMA localization;
COMMENT ON SCHEMA localization IS
  'Tables for storing localized texts for entities';

CREATE TABLE localization.language (
  language_code text PRIMARY KEY
);
COMMENT ON TABLE localization.language IS
  'List of languages in which the localized texts may come. Used as enum table';
INSERT INTO localization.language (language_code)
  VALUES ('en_US'), ('fi_FI'), ('sv_SV');

CREATE TABLE localization.codeset (
  codeset_id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  codeset_name text NOT NULL,
  -- Hasura does not support unique indexes in "ON CONSTRAINT" clauses, thus creating constraint
  -- Note that this automatically creates an index as well
  CONSTRAINT unique_codeset_name UNIQUE (codeset_name)
);
COMMENT ON TABLE localization.codeset IS
  'List of names which are used as localization keys';
COMMENT ON COLUMN localization.codeset.codeset_name IS
  'List of names which are used as localization keys. Should be namespaced (e.g. "route_name")';

INSERT INTO localization.codeset
  (codeset_id, codeset_name) VALUES
  ('288610d7-1d27-4660-8a7a-794d9a361a96', 'route_description'),
  ('02b5427a-98d0-4a15-9ba8-f7694b286c5a', 'line_name'),
  ('1925718b-03a2-4321-b880-c56bbf8cd0ce', 'line_short_name');

CREATE TABLE localization.localized_text (
  entity_id uuid NOT NULL,
  codeset_id uuid NOT NULL REFERENCES localization.codeset (codeset_id),
  language_code text NOT NULL REFERENCES localization.language (language_code),
  localized_text text,
  PRIMARY KEY (entity_id, codeset_id, language_code)
);
CREATE INDEX ON localization.localized_text (entity_id);
CREATE INDEX ON localization.localized_text (codeset_id);
CREATE INDEX ON localization.localized_text (language_code);
COMMENT ON TABLE localization.localized_text IS
  'List of localized texts for entities like routes, lines, etc.';
COMMENT ON COLUMN localization.localized_text.entity_id IS
  'ID of the entity the localized text refers to';
COMMENT ON COLUMN localization.localized_text.codeset_id IS
  'ID of the localization key the localized text refers to';
COMMENT ON COLUMN localization.localized_text.language_code IS
  'Language of the localized text';
COMMENT ON COLUMN localization.localized_text.localized_text IS
  'The localized text itself, in UTF-8 format';

-- delete related localizations when routes are deleted
CREATE FUNCTION internal_route.delete_route_related_localizations ()
  RETURNS TRIGGER
  LANGUAGE plpgsql
AS $delete_route_related_localizations$
BEGIN
  DELETE FROM localization.localized_text
    WHERE entity_id = OLD.route_id;
  RETURN OLD;
END;
$delete_route_related_localizations$;

CREATE TRIGGER internal_route_after_delete_route_trigger
  AFTER DELETE ON internal_route.route FOR EACH ROW
  EXECUTE PROCEDURE internal_route.delete_route_related_localizations();

-- delete related localizations when lines are deleted
CREATE FUNCTION route.delete_line_related_localizations ()
  RETURNS TRIGGER
  LANGUAGE plpgsql
AS $delete_line_related_localizations$
BEGIN
  DELETE FROM localization.localized_text
    WHERE entity_id = OLD.line_id;
  RETURN OLD;
END;
$delete_line_related_localizations$;

CREATE TRIGGER route_after_delete_line_trigger
  AFTER DELETE ON route.line FOR EACH ROW
  EXECUTE PROCEDURE route.delete_line_related_localizations();
