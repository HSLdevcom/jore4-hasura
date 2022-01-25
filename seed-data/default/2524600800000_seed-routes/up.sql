-- seed data for developing the UI
-- warning: this data does not actually make any sense, should update it when we get real data from jore3

INSERT INTO route.line
  (line_id,name_i18n,short_name_i18n,description_i18n,primary_vehicle_mode,label,priority,validity_start,validity_end)
VALUES
  ('101f800c-39ed-4d85-8ece-187cd9fe1c5e','Rautatientori - Veräjälaakso','Rautatientori - Veräjälaakso','Rautatientori - Kätilöopisto - Veräjälaakso','bus','65',10,'2021-01-01','2023-12-13'),
  ('9058c328-efdd-412c-9b2b-37b0f6a2c6fb','Rautatientori - Malmi as.','Rautatientori - Malmi as.','Rautatientori - Arabia - Malmi as.','bus','71',10,'2021-01-01','2023-12-13'),
  ('bbd1cb29-74c3-4fa1-ac86-918d7fa96fe2','Rautatientori - Nikkilä','Rautatientori - Nikkilä','Rautatientori - Nikkilä','bus','785K',10,'2021-01-01','2023-12-13'),
  ('db748c5c-42e3-429f-baa0-e0db227dc2c8','Erottaja - Arkkadiankatu','Erottaja - Arkkadiankatu','Erottaja - Arkkadiankatu','bus','1234',10,'2021-01-01','2023-12-13')
ON CONFLICT DO NOTHING;

-- to avoid constraint conflicts, inserting scheduled_stop_points and their allowed vehicle modes at the same time, within a transaction
DO $$
BEGIN
  INSERT INTO internal_service_pattern.scheduled_stop_point
    (scheduled_stop_point_id,measured_location,located_on_infrastructure_link_id,direction,label,validity_start,validity_end,priority)
  VALUES
    ('e3528755-711f-4e4f-9461-7931a2c4bc6d'::uuid,'SRID=4326;POINT Z(24.928326557825727 60.16391811339392 0)'::geography,'c63b749f-5060-4710-8b07-ec9ac017cb5f'::uuid,'forward','pysäkki A','2021-01-01','2023-12-13',10),
	  ('f8eace87-7901-4438-bfee-bb6f24f1c4c4'::uuid,'SRID=4326;POINT Z(24.933251767757206 60.16565505738068 0)'::geography,'d3ed9fcf-d1fa-419a-a279-7ad3ffe47714'::uuid,'forward','pysäkki B','2021-01-01','2023-12-13',10)
  ON CONFLICT DO NOTHING;

  INSERT INTO service_pattern.vehicle_mode_on_scheduled_stop_point
    (scheduled_stop_point_id,vehicle_mode)
  VALUES
    ('e3528755-711f-4e4f-9461-7931a2c4bc6d','bus'),
    ('f8eace87-7901-4438-bfee-bb6f24f1c4c4','bus')
  ON CONFLICT DO NOTHING;
END $$;

INSERT INTO internal_route.route
  (route_id,description_i18n,starts_from_scheduled_stop_point_id,ends_at_scheduled_stop_point_id,on_line_id,validity_start,validity_end,priority,"label",direction)
VALUES
	('03d55414-e5cf-4cce-9faf-d86ccb7e5f98'::uuid,NULL,'f8eace87-7901-4438-bfee-bb6f24f1c4c4'::uuid,'e3528755-711f-4e4f-9461-7931a2c4bc6d'::uuid,'101f800c-39ed-4d85-8ece-187cd9fe1c5e'::uuid,'2021-01-01','2023-12-13',10,'65 itään','outbound')
ON CONFLICT DO NOTHING;

INSERT INTO route.infrastructure_link_along_route
  (route_id,infrastructure_link_id,infrastructure_link_sequence,is_traversal_forwards)
VALUES
  ('03d55414-e5cf-4cce-9faf-d86ccb7e5f98'::uuid,'d3ed9fcf-d1fa-419a-a279-7ad3ffe47714'::uuid,0,true),
  ('03d55414-e5cf-4cce-9faf-d86ccb7e5f98'::uuid,'2feba2ae-c7af-4034-a299-9e592e67358f'::uuid,1,true),
  ('03d55414-e5cf-4cce-9faf-d86ccb7e5f98'::uuid,'c63b749f-5060-4710-8b07-ec9ac017cb5f'::uuid,2,true)
ON CONFLICT DO NOTHING;

INSERT INTO journey_pattern.journey_pattern
  (journey_pattern_id, on_route_id)
VALUES
  ('43e1985d-4643-4415-8367-c4a37fbc0a87','03d55414-e5cf-4cce-9faf-d86ccb7e5f98')
ON CONFLICT DO NOTHING;

INSERT INTO journey_pattern.scheduled_stop_point_in_journey_pattern
  (journey_pattern_id, scheduled_stop_point_id, scheduled_stop_point_sequence, is_timing_point, is_via_point)
VALUES
  ('43e1985d-4643-4415-8367-c4a37fbc0a87','e3528755-711f-4e4f-9461-7931a2c4bc6d', 0, FALSE, TRUE),
  ('43e1985d-4643-4415-8367-c4a37fbc0a87','f8eace87-7901-4438-bfee-bb6f24f1c4c4', 1, FALSE, FALSE)
ON CONFLICT DO NOTHING;
