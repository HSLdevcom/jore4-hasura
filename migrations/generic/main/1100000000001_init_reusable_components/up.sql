---------- Reusable Components ----------

CREATE TABLE reusable_components.vehicle_mode (
    vehicle_mode text NOT NULL
);
COMMENT ON TABLE reusable_components.vehicle_mode IS 'The vehicle modes from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=1:6:1:283';
COMMENT ON COLUMN reusable_components.vehicle_mode.vehicle_mode IS 'The vehicle mode from Transmodel: https://www.transmodel-cen.eu/model/index.htm?goto=1:6:1:283';
ALTER TABLE ONLY reusable_components.vehicle_mode
    ADD CONSTRAINT vehicle_mode_pkey PRIMARY KEY (vehicle_mode);
INSERT INTO reusable_components.vehicle_mode
  (vehicle_mode)
  VALUES
  ('bus'),
  ('tram'),
  ('train'),
  ('metro'),
  ('ferry')
  ON CONFLICT (vehicle_mode) DO NOTHING;

CREATE TABLE reusable_components.vehicle_submode (
    vehicle_submode text NOT NULL,
    belonging_to_vehicle_mode text NOT NULL
);
COMMENT ON TABLE reusable_components.vehicle_submode IS 'The vehicle submode, which may have implications on which infrastructure links the vehicle can traverse';
COMMENT ON COLUMN reusable_components.vehicle_submode.vehicle_submode IS 'The vehicle submode, which may have implications on which infrastructure links the vehicle can traverse';
COMMENT ON COLUMN reusable_components.vehicle_submode.belonging_to_vehicle_mode IS 'The vehicle mode the vehicle submode belongs to: https://www.transmodel-cen.eu/model/index.htm?goto=1:6:1:283';
CREATE INDEX vehicle_submode_belonging_to_vehicle_mode_idx ON reusable_components.vehicle_submode USING btree (belonging_to_vehicle_mode);
ALTER TABLE ONLY reusable_components.vehicle_submode
    ADD CONSTRAINT vehicle_submode_pkey PRIMARY KEY (vehicle_submode);
ALTER TABLE ONLY reusable_components.vehicle_submode
    ADD CONSTRAINT vehicle_submode_belonging_to_vehicle_mode_fkey FOREIGN KEY (belonging_to_vehicle_mode) REFERENCES reusable_components.vehicle_mode(vehicle_mode);
INSERT INTO reusable_components.vehicle_submode
  (vehicle_submode, belonging_to_vehicle_mode)
  VALUES
  ('generic_bus', 'bus'),
  ('generic_tram', 'tram'),
  ('generic_train', 'train'),
  ('generic_metro', 'metro'),
  ('generic_ferry', 'ferry'),
  ('tall_electric_bus', 'bus')
  ON CONFLICT (vehicle_submode)
    DO UPDATE SET belonging_to_vehicle_mode = EXCLUDED.belonging_to_vehicle_mode;

GRANT USAGE ON SCHEMA reusable_components TO xxx_db_jore3importer_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA reusable_components TO xxx_db_jore3importer_username_xxx;
ALTER DEFAULT PRIVILEGES IN SCHEMA reusable_components
  GRANT SELECT ON TABLES TO xxx_db_jore3importer_username_xxx;
