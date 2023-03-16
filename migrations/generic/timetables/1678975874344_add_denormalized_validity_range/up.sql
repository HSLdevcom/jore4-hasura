ALTER TABLE vehicle_schedule.vehicle_schedule_frame
ADD COLUMN validity_range daterange
GENERATED ALWAYS AS ( daterange(validity_start, validity_end, '[]') )
STORED NOT NULL;
COMMENT ON COLUMN vehicle_schedule.vehicle_schedule_frame.validity_range IS '
A denormalized column for actual daterange when vehicle schedule frame is valid,
that is, a closed date range [validity_start, validity_end].
Added to make working with PostgreSQL functions easier:
they typically expect ranges to be half closed.';
