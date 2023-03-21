DELETE FROM vehicle_type.vehicle_type WHERE
hsl_id IN (0,1,2,3,7,8,9,10,11,12,13,14,15,16,17,18,20,21,22);

DROP INDEX vehicle_type.vehicle_type_hsl_id_idx;
