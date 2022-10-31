ALTER TABLE "journey_pattern"."journey_pattern" DROP CONSTRAINT "journey_pattern_on_route_id_fkey",
  ADD CONSTRAINT "journey_pattern_on_route_id_fkey"
  FOREIGN KEY ("on_route_id")
  REFERENCES "internal_route"."route"
  ("route_id") ON UPDATE NO ACTION ON DELETE CASCADE;
