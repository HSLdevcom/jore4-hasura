DROP VIEW IF EXISTS vehicle_schedule.timetable_instances;
CREATE VIEW vehicle_schedule.timetable_instances AS
  SELECT *
  FROM vehicle_schedule.vehicle_schedule_frame;
