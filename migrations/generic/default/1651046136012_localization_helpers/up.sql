-- create helper view for seeing all translations in a single row for an entity
CREATE VIEW localization.localized_texts_inline AS
SELECT
  lt.entity_id,
  lt.codeset_id,
  cs.codeset_name,
  MAX(CASE WHEN lt.language_code = 'en_US' THEN lt.localized_text ELSE NULL END) as localized_text_en,
  MAX(CASE WHEN lt.language_code = 'fi_FI' THEN lt.localized_text ELSE NULL END) as localized_text_fi,
  MAX(CASE WHEN lt.language_code = 'sv_SV' THEN lt.localized_text ELSE NULL END) as localized_text_sv
FROM localization.localized_texts lt
INNER JOIN localization.codesets cs ON cs.codeset_id = lt.codeset_id
GROUP BY lt.entity_id, lt.codeset_id, cs.codeset_name;

-- create helper function for upserting a localized text
CREATE FUNCTION localization.upsert_localized_text (
  entity_id uuid,
  codeset_name text,
  language_code text,
  localized_text text
)
RETURNS SETOF localization.localized_texts
LANGUAGE plpgsql
AS $upsert_localized_text$
BEGIN
  -- insert translation key to codesets if it doesn't exist yet
  INSERT INTO localization.codesets (
    codeset_name
  ) VALUES (
    codeset_name
  )
  ON CONFLICT DO NOTHING;

  -- insert localized text
  RETURN QUERY
    INSERT INTO localization.localized_texts (
      entity_id,
      codeset_id,
      language_code,
      localized_text
    ) VALUES (
      entity_id,
      (SELECT codeset_id FROM localization.codesets cs WHERE cs.codeset_name = $2),
      language_code,
      localized_text
    )
    -- in case of conflict, overwrite localized text
    ON CONFLICT ON CONSTRAINT localized_texts_pkey DO
    UPDATE SET
      localized_text = EXCLUDED.localized_text
    RETURNING *;
END;
$upsert_localized_text$;
