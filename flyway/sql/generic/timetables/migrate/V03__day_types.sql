CREATE TABLE service_calendar.day_type_active_on_day_of_week (
  day_type_id uuid REFERENCES service_calendar.day_type (day_type_id) NOT NULL,
  day_of_week int NOT NULL,
  PRIMARY KEY(day_type_id, day_of_week)
);
COMMENT ON TABLE service_calendar.day_type_active_on_day_of_week IS 'Tells on which days of week a particular DAY TYPE is active';
COMMENT ON COLUMN service_calendar.day_type_active_on_day_of_week.day_type_id IS 'The DAY TYPE for which we define the activeness';
COMMENT ON COLUMN service_calendar.day_type_active_on_day_of_week.day_of_week IS 'ISO week day definition (1 = Monday, 7 = Sunday)';

-- adding basic day types for other single weekdays too
INSERT INTO service_calendar.day_type
  (day_type_id, label, name_i18n)
VALUES
  ('d3dfb71f-8ee1-41fd-ad49-c4968c043290','MA','{"fi_FI": "Maanantai", "sv_FI": "Måndag", "en_US": "Monday"}'),
  ('c1d27421-dd3b-43b6-a0b9-7387aae488c9','TI','{"fi_FI": "Tiistai", "sv_FI": "Tistag", "en_US": "Tuesday"}'),
  ('5ec086a3-343c-42f0-a050-3464fc3d63de','KE','{"fi_FI": "Keskiviikko", "sv_FI": "Onsdag", "en_US": "Wednesday"}'),
  ('9c708e58-fb49-440e-b4bd-736b9275f53f','TO','{"fi_FI": "Torstai", "sv_FI": "Torsdag", "en_US": "Thursday"}');

-- setting that basic day types are active on which day(s)
INSERT INTO service_calendar.day_type_active_on_day_of_week
  (day_type_id, day_of_week)
VALUES
  -- Monday-Thursday
  ('6781bd06-08cf-489e-a2bb-be9a07b15752',1),
  ('6781bd06-08cf-489e-a2bb-be9a07b15752',2),
  ('6781bd06-08cf-489e-a2bb-be9a07b15752',3),
  ('6781bd06-08cf-489e-a2bb-be9a07b15752',4),
  -- Monday-Friday
  ('38853b0d-ec36-4110-b4bc-f53218c6cdcd',1),
  ('38853b0d-ec36-4110-b4bc-f53218c6cdcd',2),
  ('38853b0d-ec36-4110-b4bc-f53218c6cdcd',3),
  ('38853b0d-ec36-4110-b4bc-f53218c6cdcd',4),
  ('38853b0d-ec36-4110-b4bc-f53218c6cdcd',5),
  -- Monday
  ('d3dfb71f-8ee1-41fd-ad49-c4968c043290',1),
  -- Tuesday
  ('c1d27421-dd3b-43b6-a0b9-7387aae488c9',2),
  -- Wednesday
  ('5ec086a3-343c-42f0-a050-3464fc3d63de',3),
  -- Thursday
  ('9c708e58-fb49-440e-b4bd-736b9275f53f',4),
  -- Friday
  ('7176e238-d46e-4583-a567-b836b1ae2589',5),
  -- Saturday
  ('61374d2b-5cce-4a7d-b63a-d487f3a05e0d',6),
  -- Sunday
  ('0e1855f1-dfca-4900-a118-f608aa07e939',7);
