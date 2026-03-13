ALTER TABLE timetables.vehicle_journey
  ADD COLUMN displayed_name text DEFAULT NULL,
  ADD COLUMN is_vehicle_type_mandatory boolean NOT NULL DEFAULT false,
  ADD COLUMN is_backup_journey boolean NOT NULL DEFAULT false,
  ADD COLUMN is_extra_journey boolean NOT NULL DEFAULT false;

COMMENT ON COLUMN timetables.vehicle_journey.displayed_name IS 'Displayed name of the journey.';
COMMENT ON COLUMN timetables.vehicle_journey.is_vehicle_type_mandatory IS 'It is required to use the same vehicle type as required in vehicle service.';
COMMENT ON COLUMN timetables.vehicle_journey.is_backup_journey IS 'Is the journey a backup journey.';
COMMENT ON COLUMN timetables.vehicle_journey.is_extra_journey IS 'Is the journey an extra journey.';

ALTER TABLE timetables.vehicle_schedule_frame
  ADD COLUMN booking_label text DEFAULT '', -- add default value to avoid migration failure if there are existing rows
  ADD COLUMN booking_description_i18n jsonb NULL;
-- Populate booking_label field with the existing value from name_i18n
UPDATE timetables.vehicle_schedule_frame SET booking_label = name_i18n->'fi_FI';
-- add NOT NULL constraint to make this field required in all new rows
ALTER TABLE timetables.vehicle_schedule_frame
  ALTER COLUMN booking_label SET NOT NULL;
COMMENT ON COLUMN timetables.vehicle_schedule_frame.booking_label IS 'Booking label for the vehicle schedule frame. Comes from BookingRecord vsc_booking field from Hastus.';
COMMENT ON COLUMN timetables.vehicle_schedule_frame.booking_description_i18n IS 'Booking description for the vehicle schedule frame. Comes from BookingRecord vsc_booking_desc field from Hastus.';

ALTER TABLE timetables.vehicle_type
  ADD COLUMN hsl_id smallint NOT NULL;

COMMENT ON COLUMN timetables.vehicle_type.hsl_id is 'ID used in Hastus to represent the vehicle type.';

CREATE OR REPLACE FUNCTION timetables.const_operating_day_start_time()
  RETURNS interval
  IMMUTABLE
  PARALLEL SAFE
  LANGUAGE sql AS
$$
SELECT interval '04:30:00'
$$;

COMMENT ON FUNCTION timetables.const_operating_day_start_time()
  IS 'Get the (inclusive) start time of operating day.';

CREATE OR REPLACE FUNCTION timetables.const_operating_day_end_time()
  RETURNS interval
  IMMUTABLE
  PARALLEL SAFE
  LANGUAGE sql AS
$$
SELECT interval '28:30:00'
$$;

COMMENT ON FUNCTION timetables.const_operating_day_end_time()
  IS 'Get the (exclusive) end time of operating day.';

CREATE OR REPLACE FUNCTION internal_utils.const_default_timezone()
  RETURNS text
  IMMUTABLE
  PARALLEL SAFE
  LANGUAGE sql AS
$$
SELECT 'Europe/Helsinki'
$$;

COMMENT ON FUNCTION internal_utils.const_default_timezone()
  IS 'Get the default timezone of service calendar.';

CREATE TABLE timetables.substitute_operating_day_by_line_type (
  substitute_operating_day_by_line_type_id  uuid DEFAULT gen_random_uuid(),
  type_of_line                              text NOT NULL,
  superseded_date                           date NOT NULL,
  substitute_day_of_week                    integer,
  begin_time                                interval,
  end_time                                  interval,
  timezone                                  text NOT NULL DEFAULT internal_utils.const_default_timezone(),
  begin_datetime                            timestamp with time zone GENERATED ALWAYS AS (timezone(timezone, coalesce(begin_time, timetables.const_operating_day_start_time()) + superseded_date)) STORED NOT NULL,
  end_datetime                              timestamp with time zone GENERATED ALWAYS AS (timezone(timezone, coalesce(end_time,   timetables.const_operating_day_end_time())   + superseded_date)) STORED NOT NULL
);
