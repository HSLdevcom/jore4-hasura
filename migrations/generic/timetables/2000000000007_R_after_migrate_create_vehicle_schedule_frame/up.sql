-- Enforce that all Special priority vehicle schedule frames must be exactly one day long.
-- Does not restrict other priorities.
ALTER TABLE vehicle_schedule.vehicle_schedule_frame
  ADD CONSTRAINT special_priority_validity_exactly_one_day
  CHECK (NOT (
    priority = internal_utils.const_timetables_priority_special()
    AND validity_start != validity_end
  ));
