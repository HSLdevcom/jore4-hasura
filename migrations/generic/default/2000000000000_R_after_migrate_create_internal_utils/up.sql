
CREATE OR REPLACE FUNCTION internal_utils.prevent_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  RAISE EXCEPTION 'update of table not allowed';
END;
$$;
