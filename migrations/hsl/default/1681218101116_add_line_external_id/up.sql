CREATE TABLE route.line_external_id (
  label text PRIMARY KEY,
  external_id smallserial NOT NULL
);
COMMENT ON TABLE route.line_external_id IS '
  External identifiers for each line label.
  Stored in separate table because multiple line rows can have same label
  (if they have different priorities) and thus should have same label.
  Old lines (from Jore3) use numbers between 1-1999.
  The ids for new lines will start from 2001.';

-- Set the sequence parameters and restart it.
ALTER SEQUENCE route.line_external_id_external_id_seq
START    2001
MINVALUE 1
MAXVALUE 9999
RESTART;

ALTER TABLE ONLY route.line
ADD CONSTRAINT line_label_external_id_fkey FOREIGN KEY (label) REFERENCES route.line_external_id(label) ON DELETE NO ACTION INITIALLY DEFERRED;
COMMENT ON CONSTRAINT line_label_external_id_fkey ON route.line
IS 'Foreign key for the label external id. Set as INITIALLY DEFERRED to defer validation to end of transaction,
 because the referenced row is created only after inserting line in an AFTER INSERT trigger.';
