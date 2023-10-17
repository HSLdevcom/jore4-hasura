-- Enforce that all Special priority vehicle schedule frames must be exactly one day long,
-- and no other priority (besides Staging) can have one day long validity period.
ALTER TABLE vehicle_schedule.vehicle_schedule_frame
  ADD CONSTRAINT one_day_validity_priorities
  CHECK (
    CASE
      WHEN priority != internal_utils.const_timetables_priority_staging()
      THEN
        (validity_start = validity_end AND priority = internal_utils.const_timetables_priority_special())
        OR
        (validity_start != validity_end AND priority != internal_utils.const_timetables_priority_special())
      ELSE
        TRUE
    END
  )
