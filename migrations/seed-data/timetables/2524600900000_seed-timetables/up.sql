-- seed data for developing the UI

-- For testing purposes when checking the migrations' data compatibility, we do not want delete the
-- seed data in the "down" migrations... Which results in having some data in the database when
-- testing the migrations.
-- However when running the complementing "up" migrations again, these inserts get in conflict with
-- the existing data, so we need to skip these errors using "ON CONFLICT DO NOTHING";

INSERT INTO journey_pattern.journey_pattern_ref (journey_pattern_ref_id, journey_pattern_id, type_of_line, observation_timestamp, snapshot_timestamp)
VALUES
  ('77a30292-807a-4cce-b4e2-e95049d3f096', '43e1985d-4643-4415-8367-c4a37fbc0a87', 'stopping_bus_service', '2022-07-01', '2022-09-28')
ON CONFLICT DO NOTHING;

INSERT INTO service_pattern.scheduled_stop_point_in_journey_pattern_ref
  (scheduled_stop_point_in_journey_pattern_ref_id, journey_pattern_ref_id, scheduled_stop_point_label, scheduled_stop_point_sequence)
VALUES
  ('1f5e10dc-ed58-4cc6-ac03-9830574bfdf4', '77a30292-807a-4cce-b4e2-e95049d3f096','H1234', 1),
  ('4739b73c-56f4-41c0-98e2-0edac7a9e93c', '77a30292-807a-4cce-b4e2-e95049d3f096','H1235', 2),
  ('f2da252c-9498-46ef-8428-c2380158bd6f', '77a30292-807a-4cce-b4e2-e95049d3f096','H1236', 3)
ON CONFLICT DO NOTHING;

INSERT INTO vehicle_schedule.vehicle_schedule_frame
  (vehicle_schedule_frame_id, name_i18n, validity_start, validity_end, priority, booking_label, label)
VALUES
  ('10ed8438-878b-4549-82f4-134127824231', '{"fi_FI": "2022 Syksy - 2022 Kevät", "sv_FI": "2022 Höst - 2022 Vår"}', '2022-08-15', '2023-06-04', 10, '2022 Syksy - 2022 Kevät', '2022 Syksy - 2022 Kevät'),
  ('e47e46dd-680f-4194-9204-37ae41cfc56c', '{"fi_FI": "2022 Talviloma perjantait", "sv_FI": "2022 Vinterlov fredagar"}', '2022-11-01', '2023-02-28', 20, '2022 Talviloma perjantait', '2022 Talviloma perjantait')
ON CONFLICT DO NOTHING;

INSERT INTO vehicle_service.vehicle_service
  (vehicle_service_id, day_type_id, vehicle_schedule_frame_id)
VALUES
  -- vehicle 1 Mon-Fri
  ('b3043186-ccbc-4ae7-a9c8-8472591ffed6', '38853b0d-ec36-4110-b4bc-f53218c6cdcd','10ed8438-878b-4549-82f4-134127824231'),
  -- vehicle 1 Sat
  ('73b07b05-1faa-4704-b7da-74903b704c15', '61374d2b-5cce-4a7d-b63a-d487f3a05e0d','10ed8438-878b-4549-82f4-134127824231'),
  -- vehicle 1 Sun
  ('980b143f-1090-4a7c-9648-514a7e177456', '0e1855f1-dfca-4900-a118-f608aa07e939','10ed8438-878b-4549-82f4-134127824231'),
  -- vehicle 2 Mon-Fri
  ('ed6b6efd-79be-4807-913a-43300a3f8040', '38853b0d-ec36-4110-b4bc-f53218c6cdcd','10ed8438-878b-4549-82f4-134127824231'),
  -- vehicle 2 Sat
  ('343dd6a8-a07f-48c9-8e6a-2f7c74a13bac', '61374d2b-5cce-4a7d-b63a-d487f3a05e0d','10ed8438-878b-4549-82f4-134127824231'),
  -- vehicle 2 Sun
  ('14082ec7-9e64-4d06-8c4b-622af04136b5', '0e1855f1-dfca-4900-a118-f608aa07e939','10ed8438-878b-4549-82f4-134127824231'),
  -- winter holiday Fridays
  -- vehicle 1 Fri
  ('8f247fd1-364f-4faa-961a-905f1b0e45d5', '7176e238-d46e-4583-a567-b836b1ae2589','e47e46dd-680f-4194-9204-37ae41cfc56c')
ON CONFLICT DO NOTHING;

INSERT INTO vehicle_service.block
  (vehicle_service_id, block_id)
VALUES
  -- vehicle 1 Mon-Fri morning and afternoon blocks
  ('b3043186-ccbc-4ae7-a9c8-8472591ffed6', 'a77a5e0c-9d49-4ecc-8dd6-0f63b079a11d'),
  ('b3043186-ccbc-4ae7-a9c8-8472591ffed6', '5f02a6d6-f54f-486c-b0ba-d98a6e9426a3'),
  -- vehicle 1 Sat morning and afternoon blocks
  ('73b07b05-1faa-4704-b7da-74903b704c15', '38ce427a-09f1-42c0-8bc3-2aa0fdb3db57'),
  ('73b07b05-1faa-4704-b7da-74903b704c15', '1e375664-bcc6-4222-bc95-0a588809b1e9'),
  -- vehicle 1 Sun morning and afternoon blocks
  ('980b143f-1090-4a7c-9648-514a7e177456', '79c614ba-1b5b-4993-b8d6-aca9dab6da6d'),
  ('980b143f-1090-4a7c-9648-514a7e177456', 'cf2c1b52-9a0e-4023-b90f-cde75387e054'),
  -- vehicle 2 Mon-Fri morning and afternoon blocks
  ('ed6b6efd-79be-4807-913a-43300a3f8040', '8bb94bc1-2896-4444-851f-d24717d0bef4'),
  ('ed6b6efd-79be-4807-913a-43300a3f8040', 'aa0ae598-5f98-4c27-9f44-7e5f773ab701'),
  -- vehicle 2 Sat morning and afternoon blocks
  ('343dd6a8-a07f-48c9-8e6a-2f7c74a13bac', '9c099cf3-070a-4dc9-a66e-cc03715df146'),
  ('343dd6a8-a07f-48c9-8e6a-2f7c74a13bac', 'aaf13398-15b3-4fa2-8632-d01d6b1bc9f8'),
  -- vehicle 2 Sun morning and afternoon blocks
  ('14082ec7-9e64-4d06-8c4b-622af04136b5', 'ba911bd5-5f10-425b-bb73-b8eb765adcc6'),
  ('14082ec7-9e64-4d06-8c4b-622af04136b5', '0900e406-77e0-4811-9c6c-86d2b9db7485')
ON CONFLICT DO NOTHING;

-- TODO create function for generating these below
INSERT INTO vehicle_journey.vehicle_journey
  (vehicle_journey_id, journey_pattern_ref_id, block_id, contract_number)
VALUES
  -- lähtö1
  ('f8cfea28-29b8-4495-a707-93aea5673b06', '77a30292-807a-4cce-b4e2-e95049d3f096', 'a77a5e0c-9d49-4ecc-8dd6-0f63b079a11d', '65X/SK22CONTRACT'),
  -- lähtö2
  ('45ddcbd4-ac23-48e0-a989-8666bc3d7673', '77a30292-807a-4cce-b4e2-e95049d3f096', 'a77a5e0c-9d49-4ecc-8dd6-0f63b079a11d', '65X/SK22CONTRACT')
ON CONFLICT DO NOTHING;

INSERT INTO passing_times.timetabled_passing_time
  (timetabled_passing_time_id, vehicle_journey_id, scheduled_stop_point_in_journey_pattern_ref_id, arrival_time, departure_time)
VALUES
  -- journey 1 H1234
  ('d0f04468-b667-4af8-8125-0fe23985dc9d', 'f8cfea28-29b8-4495-a707-93aea5673b06', '1f5e10dc-ed58-4cc6-ac03-9830574bfdf4', NULL, '05:05:00'),
  -- journey 1 H1235
  ('e074bb5e-520c-4a7f-b485-4f6ef85f0e35', 'f8cfea28-29b8-4495-a707-93aea5673b06', '4739b73c-56f4-41c0-98e2-0edac7a9e93c', '05:15:00', '05:16:00'),
  -- journey 1 H1236
  ('a7df101c-def1-49b2-947a-782413f011a0', 'f8cfea28-29b8-4495-a707-93aea5673b06', 'f2da252c-9498-46ef-8428-c2380158bd6f', '05:25:00', NULL),
  -- journey 2 H1234
  ('7ba621d9-c4cb-4533-ba76-d1e0235b3911', '45ddcbd4-ac23-48e0-a989-8666bc3d7673', '1f5e10dc-ed58-4cc6-ac03-9830574bfdf4', NULL, '26:10:00'),
  -- journey 2 H1235 missing
  -- journey 2 H1236
  ('d5fc6f50-7e7a-40eb-8a90-8a21628132f1', '45ddcbd4-ac23-48e0-a989-8666bc3d7673', 'f2da252c-9498-46ef-8428-c2380158bd6f', '26:30:00', NULL)
ON CONFLICT DO NOTHING;
