alter table "journey_pattern"."journey_pattern" drop constraint "journey_pattern_on_route_id_fkey",
  add constraint "journey_pattern_on_route_id_fkey"
  foreign key ("on_route_id")
  references "internal_route"."route"
  ("route_id") on update no action on delete cascade;
