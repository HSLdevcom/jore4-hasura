-- seed data for developing the UI

-- For testing purposes when checking the migrations' data compatibility, we do not want delete the
-- seed data in the "down" migrations... Which results in having some data in the database when
-- testing the migrations.
-- However when running the complementing "up" migrations again, these inserts get in conflict with
-- the existing data, so we need to skip these errors using "ON CONFLICT DO NOTHING";

INSERT INTO journey_pattern.journey_pattern_ref (journey_pattern_ref_id, journey_pattern_id, observation_timestamp, snapshot_timestamp)
VALUES
  ('77a30292-807a-4cce-b4e2-e95049d3f096', '43e1985d-4643-4415-8367-c4a37fbc0a87', '2022-07-01', '2022-09-28'),
  ('60bca760-9ae6-4723-92bd-60893fd93dff', '43e1985d-4643-4415-8367-c4a37fbc0a87', '2022-11-14', '2022-12-28')
ON CONFLICT DO NOTHING;

INSERT INTO service_pattern.scheduled_stop_point_in_journey_pattern_ref
  (scheduled_stop_point_in_journey_pattern_ref_id, journey_pattern_ref_id, scheduled_stop_point_label, scheduled_stop_point_sequence)
VALUES
  ('1f5e10dc-ed58-4cc6-ac03-9830574bfdf4', '77a30292-807a-4cce-b4e2-e95049d3f096', 'H1234', 1),
  ('4739b73c-56f4-41c0-98e2-0edac7a9e93c', '77a30292-807a-4cce-b4e2-e95049d3f096', 'H1235', 2),
  ('f2da252c-9498-46ef-8428-c2380158bd6f', '77a30292-807a-4cce-b4e2-e95049d3f096', 'H1236', 3),
  ('71e96aa6-668c-4816-9f35-ca26166860ee', '77a30292-807a-4cce-b4e2-e95049d3f096', 'H1237', 4),
  ('1984752e-d7fa-4dde-a2c4-f7f11066627f', '77a30292-807a-4cce-b4e2-e95049d3f096', 'H1238', 5),
  ('bb273647-a630-48ec-872a-a738ef6a54bb', '77a30292-807a-4cce-b4e2-e95049d3f096', 'H1239', 6),
  ('a04a85da-e4c1-44cd-882d-b2c46a051509', '77a30292-807a-4cce-b4e2-e95049d3f096', 'H1240', 7),
  ('f20887c1-6350-4b92-9e97-6bb2775c0380', '77a30292-807a-4cce-b4e2-e95049d3f096', 'H1241', 8),
  ('4713aba5-88c8-4320-9daf-1424bac65126', '77a30292-807a-4cce-b4e2-e95049d3f096', 'H1242', 9),
  ('70188431-ee9b-4a3f-a48d-50169dd20024', '77a30292-807a-4cce-b4e2-e95049d3f096', 'H1243', 10),
  ('6684e42f-0ebc-4c76-a0e9-d19af41a9180', '77a30292-807a-4cce-b4e2-e95049d3f096', 'H1244', 11),
  ('c70f643c-4215-4358-965c-0f8857ae543a', '77a30292-807a-4cce-b4e2-e95049d3f096', 'H1245', 12)
ON CONFLICT DO NOTHING;

INSERT INTO vehicle_schedule.vehicle_schedule_frame
  (vehicle_schedule_frame_id, name_i18n, validity_start, validity_end, priority)
VALUES
  ('10ed8438-878b-4549-82f4-134127824231', '{"fi_FI": "2022 Syksy - 2022 Kevät", "sv_FI": "2022 Höst - 2022 Vår"}', '2022-08-15', '2023-06-04', 10)
ON CONFLICT DO NOTHING;

INSERT INTO vehicle_service.vehicle_service
  (vehicle_service_id, day_type_id, vehicle_schedule_frame_id)
VALUES
  -- vehicle 1 Mon-Fri
  ('b3043186-ccbc-4ae7-a9c8-8472591ffed6', '38853b0d-ec36-4110-b4bc-f53218c6cdcd', '10ed8438-878b-4549-82f4-134127824231'),
  -- vehicle 1 Sat
  ('73b07b05-1faa-4704-b7da-74903b704c15', '61374d2b-5cce-4a7d-b63a-d487f3a05e0d', '10ed8438-878b-4549-82f4-134127824231'),
  -- vehicle 1 Sun
  ('980b143f-1090-4a7c-9648-514a7e177456', '0e1855f1-dfca-4900-a118-f608aa07e939', '10ed8438-878b-4549-82f4-134127824231'),
  -- vehicle 2 Mon-Fri
  ('ed6b6efd-79be-4807-913a-43300a3f8040', '38853b0d-ec36-4110-b4bc-f53218c6cdcd', '10ed8438-878b-4549-82f4-134127824231'),
  -- vehicle 2 Sat
  ('343dd6a8-a07f-48c9-8e6a-2f7c74a13bac', '61374d2b-5cce-4a7d-b63a-d487f3a05e0d', '10ed8438-878b-4549-82f4-134127824231'),
  -- vehicle 2 Sun
  ('14082ec7-9e64-4d06-8c4b-622af04136b5', '0e1855f1-dfca-4900-a118-f608aa07e939', '10ed8438-878b-4549-82f4-134127824231')
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
  (vehicle_journey_id, journey_pattern_ref_id, block_id)
VALUES
  -- journey 1
  ('f8cfea28-29b8-4495-a707-93aea5673b06', '77a30292-807a-4cce-b4e2-e95049d3f096', 'a77a5e0c-9d49-4ecc-8dd6-0f63b079a11d'),
  -- journey 2
  ('45ddcbd4-ac23-48e0-a989-8666bc3d7673', '77a30292-807a-4cce-b4e2-e95049d3f096', 'a77a5e0c-9d49-4ecc-8dd6-0f63b079a11d'),
  -- journey 3
  ('d7d64473-134e-40dd-91cb-afb30e7b862a', '77a30292-807a-4cce-b4e2-e95049d3f096', 'a77a5e0c-9d49-4ecc-8dd6-0f63b079a11d'),
  -- journey 4
  ('22a3c9c1-5b30-4987-ba8d-5c22a87fe4a5', '77a30292-807a-4cce-b4e2-e95049d3f096', 'a77a5e0c-9d49-4ecc-8dd6-0f63b079a11d'),
  -- journey 5
  ('517491a7-46d2-4721-9bce-924644560086', '77a30292-807a-4cce-b4e2-e95049d3f096', 'a77a5e0c-9d49-4ecc-8dd6-0f63b079a11d'),
  -- journey 6
  ('4d08bb3c-269e-4173-985b-8e6d0dc51096', '77a30292-807a-4cce-b4e2-e95049d3f096', 'a77a5e0c-9d49-4ecc-8dd6-0f63b079a11d'),
  -- journey 7
  ('019a307c-fd2d-4a17-b151-f431cb1d1cb9', '77a30292-807a-4cce-b4e2-e95049d3f096', 'a77a5e0c-9d49-4ecc-8dd6-0f63b079a11d')
ON CONFLICT DO NOTHING;

INSERT INTO passing_times.timetabled_passing_time
  (timetabled_passing_time_id, vehicle_journey_id, scheduled_stop_point_in_journey_pattern_ref_id, arrival_time, departure_time)
VALUES
  -- journey 1 --
  -- journey 1 H1234
  ('d0f04468-b667-4af8-8125-0fe23985dc9d', 'f8cfea28-29b8-4495-a707-93aea5673b06', '1f5e10dc-ed58-4cc6-ac03-9830574bfdf4', NULL, '05:05:00'),
  -- journey 1 H1235
  ('e074bb5e-520c-4a7f-b485-4f6ef85f0e35', 'f8cfea28-29b8-4495-a707-93aea5673b06', '4739b73c-56f4-41c0-98e2-0edac7a9e93c', '05:15:00', '05:16:00'),
  -- journey 1 H1236
  ('a7df101c-def1-49b2-947a-782413f011a0', 'f8cfea28-29b8-4495-a707-93aea5673b06', 'f2da252c-9498-46ef-8428-c2380158bd6f', '05:25:00', NULL),
  -- journey 1 H1237
  ('89ae27e9-5bf7-4738-ac07-d035c0cc1b21', 'f8cfea28-29b8-4495-a707-93aea5673b06', '71e96aa6-668c-4816-9f35-ca26166860ee', '05:35:00', '05:38:00'),
  -- journey 1 H1238
  ('7dd25d0c-79cf-452d-bbc3-f65d08bf1058', 'f8cfea28-29b8-4495-a707-93aea5673b06', '1984752e-d7fa-4dde-a2c4-f7f11066627f', '05:40:00', NULL),
  -- journey 1 H1239
  ('2cb28b44-0b73-4049-8c27-65093991f8ae', 'f8cfea28-29b8-4495-a707-93aea5673b06', 'bb273647-a630-48ec-872a-a738ef6a54bb', '05:41:00', NULL),
  -- journey 1 H1240
  ('10dd2301-e509-4d50-bef7-ec12429a7925', 'f8cfea28-29b8-4495-a707-93aea5673b06', 'a04a85da-e4c1-44cd-882d-b2c46a051509', '05:42:00', NULL),
  -- journey 1 H1241
  ('805dd156-fec8-4c96-a7e2-b180d6f8b325', 'f8cfea28-29b8-4495-a707-93aea5673b06', 'f20887c1-6350-4b92-9e97-6bb2775c0380', '05:45:00', NULL),
  -- journey 1 H1242
  ('6e02455a-df2c-45b4-af33-9b32f946b455', 'f8cfea28-29b8-4495-a707-93aea5673b06', '4713aba5-88c8-4320-9daf-1424bac65126', '05:48:00', NULL),
  -- journey 1 H1243
  ('872bbccf-5584-4d34-acf9-f6a0b1bc35a6', 'f8cfea28-29b8-4495-a707-93aea5673b06', '70188431-ee9b-4a3f-a48d-50169dd20024', '05:50:00', NULL),
  -- journey 1 H1244
  ('26edb4ac-4409-4342-8d4a-cfc88fe3cee0', 'f8cfea28-29b8-4495-a707-93aea5673b06', '6684e42f-0ebc-4c76-a0e9-d19af41a9180', '07:25:00', '08:25:00'),
  -- journey 1 H1245
  ('0be46b26-ff6a-4783-a353-9a8c68f2c01a', 'f8cfea28-29b8-4495-a707-93aea5673b06', 'c70f643c-4215-4358-965c-0f8857ae543a', '05:25:00', NULL),

  -- journey 2 --
  -- journey 2 H1234
  ('7ba621d9-c4cb-4533-ba76-d1e0235b3911', '45ddcbd4-ac23-48e0-a989-8666bc3d7673', '1f5e10dc-ed58-4cc6-ac03-9830574bfdf4', NULL, '07:10:00'),
  -- journey 2 H1235 missing
  -- journey 2 H1236 missing
  -- journey 2 H1238
  ('0ba60b61-d44c-4903-a8fd-a84ee1c8d31b', '45ddcbd4-ac23-48e0-a989-8666bc3d7673', '1984752e-d7fa-4dde-a2c4-f7f11066627f', '07:30:00', '07:35:00'),
  -- journey 2 H1239
  ('a1dc853b-8e2e-4f05-80df-682f41f76ad0', '45ddcbd4-ac23-48e0-a989-8666bc3d7673', 'bb273647-a630-48ec-872a-a738ef6a54bb', '07:40:00', '07:42:00'),
  -- journey 2 H1240
  ('48be4885-5a62-4874-a7ad-b711bc3eac7d', '45ddcbd4-ac23-48e0-a989-8666bc3d7673', 'a04a85da-e4c1-44cd-882d-b2c46a051509', '07:50:00', NULL),
  -- journey 2 H1241
  ('86628e10-0adf-471a-a898-cd91752540fb', '45ddcbd4-ac23-48e0-a989-8666bc3d7673', 'f20887c1-6350-4b92-9e97-6bb2775c0380', '07:52:00', NULL),
  -- journey 2 H1242
  ('f2cea37e-fac4-4b00-8a0b-bee84c7c5483', '45ddcbd4-ac23-48e0-a989-8666bc3d7673', '4713aba5-88c8-4320-9daf-1424bac65126', '07:55:00', NULL),
  -- journey 2 H1243
  ('be6406a6-73e8-45d1-8d50-0906fa160160', '45ddcbd4-ac23-48e0-a989-8666bc3d7673', '70188431-ee9b-4a3f-a48d-50169dd20024', '07:56:00', NULL),
  -- journey 2 H1244
  ('903c8511-9a2e-4ed8-9eaf-32373f9c0602', '45ddcbd4-ac23-48e0-a989-8666bc3d7673', '6684e42f-0ebc-4c76-a0e9-d19af41a9180', '25:30:00', NULL),
  -- journey 2 H1245
  ('f258a7a8-7435-4190-bb43-59ac478b40ae', '45ddcbd4-ac23-48e0-a989-8666bc3d7673', 'c70f643c-4215-4358-965c-0f8857ae543a', '27:30:00', NULL),

  -- journey 3 --
  -- journey 3 H1234
  ('ea471fbc-1294-4299-8925-6846cd94d0cc', 'd7d64473-134e-40dd-91cb-afb30e7b862a', '1f5e10dc-ed58-4cc6-ac03-9830574bfdf4', '06:20:00', NULL),
  -- journey 3 H1235
  ('69d1bc62-1726-46fe-b846-60e7de190f1b', 'd7d64473-134e-40dd-91cb-afb30e7b862a', '4739b73c-56f4-41c0-98e2-0edac7a9e93c', '06:50:00', '06:52:00'),

  -- journey 4 --
  -- journey 4 H1234
  ('c0b2cbb0-cf34-468e-976d-4fa0e3b7d107', '22a3c9c1-5b30-4987-ba8d-5c22a87fe4a5', '1f5e10dc-ed58-4cc6-ac03-9830574bfdf4', NULL, '06:40:00'),
  -- journey 4 H1235
  ('110b1c08-5769-4078-840d-c1a83e80d2ea', '22a3c9c1-5b30-4987-ba8d-5c22a87fe4a5', '4739b73c-56f4-41c0-98e2-0edac7a9e93c', '07:50:00', '07:52:00'),

  -- journey 5 --
  -- journey 5 H1234
  ('2a75d5c4-75b5-4289-a3a0-5fe6ab5c21ad', '517491a7-46d2-4721-9bce-924644560086', '1f5e10dc-ed58-4cc6-ac03-9830574bfdf4', NULL, '06:43:00'),
  -- journey 5 H1235
  ('226b0c4e-589d-4a09-b745-007d81b1d44f', '517491a7-46d2-4721-9bce-924644560086', '4739b73c-56f4-41c0-98e2-0edac7a9e93c', '07:05:00', NULL),

  -- journey 6 --
  -- journey 6 H1234
  ('e0b42c15-6b88-4f5a-b3a6-6dfb70c791fa', '4d08bb3c-269e-4173-985b-8e6d0dc51096', '1f5e10dc-ed58-4cc6-ac03-9830574bfdf4', NULL, '06:46:00'),
  -- journey 6 H1235
  ('095944b4-8345-4edb-8e61-a9aabcf156ae', '4d08bb3c-269e-4173-985b-8e6d0dc51096', '4739b73c-56f4-41c0-98e2-0edac7a9e93c', '07:15:00', NULL),

  -- journey 7 --
  -- journey 7 H1234
  ('c0d7de62-b8e7-4ff6-b63e-c5e372546118', '019a307c-fd2d-4a17-b151-f431cb1d1cb9', '1f5e10dc-ed58-4cc6-ac03-9830574bfdf4', '06:05:00', '06:07:00'),
  -- journey 7 H1235
  ('048f53a0-2440-4b33-a1d3-9a3f1d67ba3c', '019a307c-fd2d-4a17-b151-f431cb1d1cb9', '4739b73c-56f4-41c0-98e2-0edac7a9e93c', '06:09:00', '06:11:00')
ON CONFLICT DO NOTHING;
