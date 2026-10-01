-- Drop the constraints explicitly because they reference stop_place_ref column
-- which needs to be droppable in earlier down migrations.
-- Other constraints/functions are dropped in the before_migrate hook.
ALTER TABLE service_pattern.scheduled_stop_point DROP CONSTRAINT IF EXISTS unique_validity_period;
ALTER TABLE service_pattern.scheduled_stop_point DROP CONSTRAINT IF EXISTS null_stop_place_ref_conflict;
