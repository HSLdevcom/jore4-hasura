ALTER TABLE route.route ADD COLUMN version_comment TEXT NULL DEFAULT NULL;
COMMENT ON COLUMN route.route.version_comment
  IS 'An extra comment describing the latest change to the Route''s details.';

ALTER TABLE route.line ADD COLUMN version_comment TEXT NULL DEFAULT NULL;
COMMENT ON COLUMN route.line.version_comment
  IS 'An extra comment describing the latest change to the Line''s details.';
