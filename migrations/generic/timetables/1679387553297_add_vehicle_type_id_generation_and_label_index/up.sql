ALTER TABLE vehicle_type.vehicle_type
ALTER COLUMN vehicle_type_id SET DEFAULT gen_random_uuid();

CREATE UNIQUE INDEX vehicle_type.vehicle_type_label_idx ON vehicle_type.vehicle_type USING btree(label);
