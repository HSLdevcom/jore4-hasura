ALTER TABLE service_pattern.vehicle_mode_on_scheduled_stop_point
  DROP CONSTRAINT scheduled_stop_point_serviced_by_v_scheduled_stop_point_id_fkey,
  ADD CONSTRAINT vehicle_mode_on_scheduled_stop_point_scheduled_stop_point_id_fkey
    FOREIGN KEY (scheduled_stop_point_id)
  REFERENCES internal_service_pattern.scheduled_stop_point (scheduled_stop_point_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE;
