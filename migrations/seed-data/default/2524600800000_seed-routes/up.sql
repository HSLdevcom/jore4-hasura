-- seed data for developing the UI
-- warning: this data does not actually make any sense, should update it when we get real data from jore3

-- For testing purposes when checking the migrations' data compatibility, we do not want delete the
-- seed data in the "down" migrations... Which results in having some data in the database when
-- testing the migrations.
-- However when running the complementing "up" migrations again, these inserts get in conflict with
-- the existing data, so we need to skip these errors using "ON CONFLICT DO NOTHING";

INSERT INTO route.line
  (line_id,name_i18n,short_name_i18n,primary_vehicle_mode,label,type_of_line,transport_target,priority,validity_start,validity_end)
VALUES
  ('101f800c-39ed-4d85-8ece-187cd9fe1c5e','{"fi_FI":"Rautatientori - Veräjälaakso FI","sv_FI":"Rautatientori - Veräjälaakso SV"}','{"fi_FI":"Rautatientori - Veräjälaakso short FI","sv_FI":"Rautatientori - Veräjälaakso short SV"}','bus','65','regional_bus_service','helsinki_internal_traffic',10,'2021-01-01','2023-12-13'),
  ('9058c328-efdd-412c-9b2b-37b0f6a2c6fb','{"fi_FI":"Rautatientori - Malmi as. FI","sv_FI":"Rautatientori - Malmi as. SV"}','{"fi_FI":"Rautatientori - Malmi as. short FI","sv_FI":"Rautatientori - Malmi as. short SV"}','bus','71','regional_bus_service','helsinki_internal_traffic',10,'2021-01-01','2023-12-13'),
  ('bbd1cb29-74c3-4fa1-ac86-918d7fa96fe2','{"fi_FI":"Rautatientori - Nikkilä FI","sv_FI":"Rautatientori - Nikkilä SV"}','{"fi_FI":"Rautatientori - Nikkilä short FI","sv_FI":"Rautatientori - Nikkilä short SV"}','bus','785K','regional_bus_service','helsinki_internal_traffic',10,'2021-01-01','2023-12-13'),
  ('db748c5c-42e3-429f-baa0-e0db227dc2c8','{"fi_FI":"Erottaja - Arkkadiankatu FI","sv_FI":"Erottaja - Arkkadiankatu SV"}','{"fi_FI":"Erottaja - Arkkadiankatu short FI","sv_FI":"Erottaja - Arkkadiankatu short SV"}','bus','1234','regional_bus_service','helsinki_internal_traffic',10,'2021-01-01','2023-12-13')
ON CONFLICT DO NOTHING;

-- to avoid constraint conflicts, inserting scheduled_stop_points and their allowed vehicle modes at the same time, within a transaction
DO $$
BEGIN
  INSERT INTO internal_service_pattern.scheduled_stop_point_invariant
    (label)
  VALUES
    ('H1234'),
    ('H1235'),
    ('H1236')
  ON CONFLICT DO NOTHING;

  INSERT INTO internal_service_pattern.scheduled_stop_point
    (scheduled_stop_point_id,measured_location,located_on_infrastructure_link_id,direction,label,validity_start,validity_end,priority)
  VALUES
    ('e3528755-711f-4e4f-9461-7931a2c4bc6d'::uuid,'SRID=4326;POINT Z(24.928326557825727 60.16391811339392 0)'::geography,'c63b749f-5060-4710-8b07-ec9ac017cb5f'::uuid,'bidirectional','H1234','2021-01-01','2023-12-13',10),
    ('4d294d62-df17-46ff-9248-23f66f17fa87'::uuid,'SRID=4326;POINT Z(24.930490150380855 60.164635254660325 0)'::geography,'2feba2ae-c7af-4034-a299-9e592e67358f'::uuid,'bidirectional','H1235','2021-01-01','2023-12-13',10),
	  ('f8eace87-7901-4438-bfee-bb6f24f1c4c4'::uuid,'SRID=4326;POINT Z(24.933251767757206 60.16565505738068 0)'::geography,'d3ed9fcf-d1fa-419a-a279-7ad3ffe47714'::uuid,'bidirectional','H1236','2021-01-01','2023-12-13',10)
  ON CONFLICT DO NOTHING;

  INSERT INTO service_pattern.vehicle_mode_on_scheduled_stop_point
    (scheduled_stop_point_id,vehicle_mode)
  VALUES
    ('e3528755-711f-4e4f-9461-7931a2c4bc6d','bus'),
    ('4d294d62-df17-46ff-9248-23f66f17fa87','bus'),
    ('f8eace87-7901-4438-bfee-bb6f24f1c4c4','bus')
  ON CONFLICT DO NOTHING;
END $$;

INSERT INTO route.route (
  route_id,
  name_i18n,
  description_i18n,
  origin_name_i18n,
  origin_short_name_i18n,
  destination_name_i18n,
  destination_short_name_i18n,
  on_line_id,
  validity_start,
  validity_end,
  priority,
  label,
  direction
)
VALUES (
  '03d55414-e5cf-4cce-9faf-d86ccb7e5f98'::uuid,
  '{"fi_FI":"Reitti A - B FI","sv_FI":"Reitti A - B SV"}',
  '{"fi_FI":"Reitti A - B desc FI","sv_FI":"Reitti A - B desc SV"}',
  '{"fi_FI":"A FI","sv_FI":"A SV"}',
  '{"fi_FI":"A short FI","sv_FI":"A short SV"}',
  '{"fi_FI":"B FI","sv_FI":"B SV"}',
  '{"fi_FI":"B short FI","sv_FI":"B short SV"}',
  '101f800c-39ed-4d85-8ece-187cd9fe1c5e'::uuid,
  '2021-01-01',
  '2023-12-13',
  10,
  '65x',
  'outbound'
)
ON CONFLICT DO NOTHING;

INSERT INTO route.infrastructure_link_along_route
  (route_id,infrastructure_link_id,infrastructure_link_sequence,is_traversal_forwards)
VALUES
  ('03d55414-e5cf-4cce-9faf-d86ccb7e5f98'::uuid,'c63b749f-5060-4710-8b07-ec9ac017cb5f'::uuid,0,true),
  ('03d55414-e5cf-4cce-9faf-d86ccb7e5f98'::uuid,'2feba2ae-c7af-4034-a299-9e592e67358f'::uuid,1,true),
  ('03d55414-e5cf-4cce-9faf-d86ccb7e5f98'::uuid,'d3ed9fcf-d1fa-419a-a279-7ad3ffe47714'::uuid,2,true)
ON CONFLICT DO NOTHING;

INSERT INTO journey_pattern.journey_pattern
  (journey_pattern_id, on_route_id)
VALUES
  ('43e1985d-4643-4415-8367-c4a37fbc0a87','03d55414-e5cf-4cce-9faf-d86ccb7e5f98')
ON CONFLICT DO NOTHING;

INSERT INTO journey_pattern.scheduled_stop_point_in_journey_pattern
  (journey_pattern_id, scheduled_stop_point_label, scheduled_stop_point_sequence, is_timing_point, is_via_point, via_point_name_i18n, via_point_short_name_i18n)
VALUES
  ('43e1985d-4643-4415-8367-c4a37fbc0a87','H1234', 0, FALSE, FALSE, NULL, NULL),
  ('43e1985d-4643-4415-8367-c4a37fbc0a87','H1235', 1, TRUE, TRUE, '{"fi_FI":"Paikka","sv_FI":"Plats"}', '{"fi_FI":"Pai.","sv_FI":"Pla."}'),
  ('43e1985d-4643-4415-8367-c4a37fbc0a87','H1236', 2, FALSE, FALSE, NULL, NULL)
ON CONFLICT DO NOTHING;
