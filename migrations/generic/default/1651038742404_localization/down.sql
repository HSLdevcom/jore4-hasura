DROP TRIGGER internal_route_after_delete_trigger ON internal_route.route;
DROP FUNCTION internal_route.delete_related_localizations;
DROP TABLE localization.localized_texts;
DROP TABLE localization.codesets;
DROP TABLE localization.languages;
DROP SCHEMA localization;
