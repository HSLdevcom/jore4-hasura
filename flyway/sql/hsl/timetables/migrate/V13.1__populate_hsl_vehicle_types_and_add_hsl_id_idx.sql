CREATE UNIQUE INDEX  vehicle_type_hsl_id_idx ON vehicle_type.vehicle_type USING btree(hsl_id);

INSERT INTO vehicle_type.vehicle_type
  (vehicle_type_id, hsl_id, label, description_i18n)
VALUES
  ('27ed17a8-ac64-4f6a-b3e8-41c95d8ab153', 0, 'Low multi-axle bus', '{"fi_FI": "Matala telibussi"}'),
  ('b51470c1-8cc7-4508-ac83-eaf8976d67e0', 1, 'High 2-axle bus', '{"fi_FI": "Korkea 2-akselinen bussi"}'),
  ('5705e3de-bea4-4cb3-ac50-76c6332898d1', 2, 'High articulated bus', '{"fi_FI": "Korkea nivelbussi"}'),
  ('9e431f63-1925-45a6-a222-cad58d339da9', 3, 'Low A1 bus', '{"fi_FI": "Matala A1 -bussi"}'),
  ('60db118d-db21-44da-acf5-08f569372373', 7, 'Euro 4 2-axle', '{"fi_FI": "Euro 4 2-aks"}'),
  ('91f63622-044f-4280-be6a-f75cb8311557', 8, 'Low articulated bus', '{"fi_FI": "Matala nivelbussi"}'),
  ('5cb94060-73db-41b6-a892-23cbc13da816', 9, 'Low midibus', '{"fi_FI": "Matala midibussi"}'),
  ('92d8179d-1f79-424d-97b8-688be3f2e85d', 10, 'Euro 4 multi-axle', '{"fi_FI": "Euro 4 teli"}'),
  ('0942ff2e-d3ba-4652-b4aa-911835c60011', 11, 'High gasbus', '{"fi_FI": "Korkea kaasubussi"}'),
  ('b24f8f2d-bb9e-48ed-a9e8-96abe27a4549', 12, 'Mini A', '{"fi_FI": "Mini A"}'),
  ('78162473-168b-487e-a4d7-2195e90ac1b7', 13, 'Mini B', '{"fi_FI": "Mini B"}'),
  ('67cf53ca-7edb-4ed1-a8b1-71d6d58afbc9', 14, 'Mini Dab', '{"fi_FI": "Mini Dab"}'),
  ('3dc05ccb-d3d8-431e-911f-9e8bf4de9b82', 15, 'EEV 2-axle A1', '{"fi_FI": "EEV 2-akselinen A1"}'),
  ('6acaa0a6-d260-453c-a7a4-d7be3714d26a', 16, 'EEV Multi-axle bus', '{"fi_FI": "EEV Telibussi"}'),
  ('e3475423-c8ae-4a41-b9ac-0dce4a29ba25', 17, 'Low A2 Bus', '{"fi_FI": "Matala A2 -bussi"}'),
  ('bdf8bd2c-7166-4b60-b8cd-0eb95bba6919', 18, 'High 43 seated', '{"fi_FI": "Korkea 43-paikkainen"}'),
  ('5a053aa9-e4d7-4a6e-8586-06645f8be8c2', 20, '2-Axled hybrid A1', '{"fi_FI": "2-akselinen hybridi A1"}'),
  ('3590c14b-8a05-449c-bf74-2031ec277651', 21, 'A1 electrical bus', '{"fi_FI": "A1 sähköbussi"}'),
  ('55b5784f-5805-46eb-a842-a25fce9eb560', 22, 'A2 electrical bus', '{"fi_FI": "A2 sähköbussi"}');
