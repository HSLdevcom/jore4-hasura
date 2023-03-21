DROP INDEX vehicle_type_label_idx;

ALTER TABLE vehicle_type.vehicle_type
ALTER COLUMN vehicle_type_id DROP DEFAULT;
