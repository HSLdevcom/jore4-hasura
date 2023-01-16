CREATE UNIQUE INDEX jore3_code_unique_idx ON hsl_route.hsl_municipality_code USING btree (jore3_code) WHERE (jore3_code IS NOT NULL);
