DROP TRIGGER route_after_delete_line_trigger ON route.line;
DROP FUNCTION route.delete_line_related_localizations;
DROP TRIGGER internal_route_after_delete_route_trigger ON route.route;
DROP FUNCTION route.delete_route_related_localizations;
DROP TABLE localization.localized_text;
DROP TABLE localization.attribute;
DROP TABLE localization.language;
DROP SCHEMA localization;
