DROP FUNCTION localization.upsert_localized_text (
  entity_id uuid,
  codeset_name text,
  language_code text,
  localized_text text
);

DROP VIEW localization.localized_texts_inline;
