
-- change route.line localized fields from text to jsonb
ALTER TABLE route.line
    ALTER COLUMN name_i18n SET DATA TYPE JSONB
      USING to_jsonb('{"fi_FI": "' || name_i18n || '"}'),
    ALTER COLUMN short_name_i18n SET NOT NULL,
    ALTER COLUMN short_name_i18n SET DATA TYPE JSONB
      USING to_jsonb('{"fi_FI": "' || short_name_i18n || '"}'),
    ALTER COLUMN short_name_i18n SET NOT NULL;
CREATE INDEX idx_line_name_i18n ON route.line USING gin (name_i18n);
CREATE INDEX idx_line_short_name_i18n ON route.line USING gin (short_name_i18n);

-- have to drop all previous views that use the columns below, it's not possible to keep them as the underlying table changes
DROP VIEW deleted.route_1652267227873;
DROP VIEW deleted.route_1637329168554;

-- change route.route localized fields from text to jsonb
-- add some more localized fields that will be used in the future
ALTER TABLE route.route
    ADD COLUMN name_i18n JSONB NOT NULL,
    ALTER COLUMN description_i18n SET DATA TYPE JSONB
      USING to_jsonb('{"fi_FI": "' || description_i18n || '"}'),
    ADD COLUMN origin_name_i18n JSONB NULL,
    ADD COLUMN origin_short_name_i18n JSONB NULL,
    ADD COLUMN destination_name_i18n JSONB NULL,
    ADD COLUMN destination_short_name_i18n JSONB NULL;
CREATE INDEX idx_route_name_i18n ON route.route USING gin (name_i18n);
CREATE INDEX idx_route_origin_name_i18n ON route.route USING gin (origin_name_i18n);
CREATE INDEX idx_route_origin_short_name_i18n ON route.route USING gin (origin_short_name_i18n);
CREATE INDEX idx_route_destination_name_i18n ON route.route USING gin (destination_name_i18n);
CREATE INDEX idx_route_destination_short_name_i18n ON route.route USING gin (destination_short_name_i18n);
