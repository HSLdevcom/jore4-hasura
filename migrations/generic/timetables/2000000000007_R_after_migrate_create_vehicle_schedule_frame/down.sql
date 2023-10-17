-- Need to drop manually even if this would be dropped in a repeatable migration:
-- this depends on an internal function from non-repeatable migrations,
-- so if this constraint is not dropped here it will break migration tests.
ALTER TABLE vehicle_schedule.vehicle_schedule_frame
  DROP CONSTRAINT special_priority_validity_exactly_one_day
