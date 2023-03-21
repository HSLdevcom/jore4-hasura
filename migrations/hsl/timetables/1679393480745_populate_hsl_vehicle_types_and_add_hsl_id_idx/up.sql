CREATE UNIQUE INDEX  vehicle_type_hsl_id_idx ON vehicle_type.vehicle_type USING btree(hsl_id);

INSERT INTO vehicle_type.vehicle_type(label, description_i18n, hsl_id)
VALUES ('Low multi-axle bus', '{"fi_FI": "Matala telibussi"}', 0),
('High 2-axle bus', '{"fi_FI": "Korkea 2-akselinen bussi"}', 1),
('High articulated bus', '{"fi_FI": "Korkea nivelbussi"}', 2),
('Low A1 bus', '{"fi_FI": "Matala A1 -bussi"}', 3),
('Euro 4 2-axle', '{"fi_FI": "Euro 4 2-aks"}', 7),
('Low articulated bus', '{"fi_FI": "Matala nivelbussi"}', 8),
('Low midibus', '{"fi_FI": "Matala midibussi"}', 9),
('Euro 4 teli', '{"fi_FI": "Euro 4 teli"}', 10),
('High gasbus', '{"fi_FI": "Korkea kaasubussi"}', 11),
('Mini A', '{"fi_FI": "Mini A"}', 12),
('Mini B', '{"fi_FI": "Mini B"}', 13),
('Mini Dab', '{"fi_FI": "Mini Dab"}', 14),
('EEV 2-axle A1', '{"fi_FI": "EEV 2-akselinen A1"}', 15),
('EEV Multi-axle bus', '{"fi_FI": "EEV Telibussi"}', 16),
('Low A2 Bus', '{"fi_FI": "Matala A2 -bussi"}', 17),
('High 43 seated', '{"fi_FI": "Korkea 43-paikkainen"}', 18),
('2-Axled hybrid A1', '{"fi_FI": "2-akselinen hybridi A1"}', 20),
('A1 electrical bus', '{"fi_FI": "A1 sähköbussi"}', 21),
('A2 electrical bus', '{"fi_FI": "A2 sähköbussi"}', 22);
