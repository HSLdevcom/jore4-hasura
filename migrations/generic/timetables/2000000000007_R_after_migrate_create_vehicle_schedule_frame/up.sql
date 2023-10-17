ALTER TABLE vehicle_schedule.vehicle_schedule_frame
  ADD CONSTRAINT one_day_validity_priorities
  CHECK (
    -- All Special priorities must be exactly one day long...
    (priority = internal_utils.const_timetables_priority_special() AND validity_start = validity_end)
    OR
    -- ...and no other priority can have one day long validity period...
    (priority != internal_utils.const_timetables_priority_special() AND validity_start != validity_end)
    OR
    -- ...except Staging.
    (priority = internal_utils.const_timetables_priority_staging())
  )
