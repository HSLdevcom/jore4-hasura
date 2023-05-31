CREATE TABLE service_calendar.substitute_operating_period (
    id uuid DEFAULT gen_random_uuid(),
    period_name text UNIQUE NOT NULL,
    is_preset BOOLEAN NOT NULL DEFAULT FALSE
);

ALTER TABLE
    ONLY service_calendar.substitute_operating_period
ADD
    CONSTRAINT substitute_operating_period_pkey PRIMARY KEY (id);

COMMENT ON COLUMN service_calendar.substitute_operating_period.period_name IS 'Substitute operating periods name';

COMMENT ON COLUMN service_calendar.substitute_operating_period.is_preset IS 'Flag indicating wheter operating period is preset or not. Preset operating periods have restrictions on the UI';

ALTER TABLE
    ONLY service_calendar.substitute_operating_day_by_line_type
ADD
    COLUMN substitute_operating_period_id uuid NOT NULL;

ALTER TABLE
    ONLY service_calendar.substitute_operating_day_by_line_type
ADD
    CONSTRAINT substitute_operating_day_by_line_type_substitute_operating_period_fkey FOREIGN KEY (substitute_operating_period_id) REFERENCES service_calendar.substitute_operating_period(id);

CREATE INDEX substitute_operating_day_by_line_type_substitute_operating_period ON service_calendar.substitute_operating_day_by_line_type USING btree (substitute_operating_period_id);

COMMENT ON COLUMN service_calendar.substitute_operating_day_by_line_type.substitute_operating_period_id IS 'The id of the substitute operating period';

CREATE
OR REPLACE VIEW service_calendar.substitute_operating_period_with_date_range AS (
    SELECT
        p.id,
        period_name,
        MIN(d.superseded_date) AS begin_date,
        MAX(d.superseded_date) AS end_date,
        array_agg(DISTINCT d.type_of_line) AS line_types,
        d.substitute_day_of_week,
        MIN(d.begin_time) AS begin_time,
        MAX(d.end_time) AS end_time
    FROM
        service_calendar.substitute_operating_period p
        INNER JOIN service_calendar.substitute_operating_day_by_line_type d ON p.id = d.substitute_operating_period_id
    GROUP BY
        p.id,
        d.substitute_day_of_week
);

CREATE
OR REPLACE FUNCTION service_calendar.save_operating_periods(periods jsonb, removed jsonb) RETURNS SETOF service_calendar.substitute_operating_period LANGUAGE plpgsql VOLATILE AS $$ BEGIN
    -- Temporary table to help handling input jsonb data
    CREATE temp TABLE operating_periods (
        id uuid,
        period_name text,
        line_types text [ ],
        substitute_day_of_week INTEGER,
        begin_date DATE,
        end_date DATE,
        begin_time INTERVAL,
        end_time INTERVAL
    ) ON COMMIT DROP;

-- Remove operating periods that have been removed
-- Remove each day of the period
DELETE FROM
    service_calendar.substitute_operating_day_by_line_type
WHERE
    substitute_operating_period_id IN (
        SELECT
            jsonb_array_elements_text(removed) :: uuid AS id
    );

-- Remove period rows
DELETE FROM
    service_calendar.substitute_operating_period
WHERE
    id IN (
        SELECT
            jsonb_array_elements_text(removed) :: uuid AS id
    );

-- Insert input jsonb data into the temporary table
INSERT INTO
    operating_periods (
        id,
        period_name,
        line_types,
        substitute_day_of_week,
        begin_date,
        end_date,
        begin_time,
        end_time
    )
SELECT
    (p.period ->> 'id') :: uuid,
    p.period ->> 'period_name',
    array_agg((type_of_line_arr.value) :: text) AS line_types,
    (p.period ->> 'substitute_day_of_week') :: INT,
    (p.period ->> 'begin_date') :: DATE,
    (p.period ->> 'end_date') :: DATE,
    (p.period ->> 'begin_time') :: INTERVAL,
    (p.period ->> 'end_time') :: INTERVAL
FROM
    jsonb_array_elements(periods) AS p(period)
    CROSS JOIN LATERAL jsonb_array_elements_text(p.period -> 'line_types') AS type_of_line_arr(VALUE)
GROUP BY
    p.period;

-- Clean operating periods references from day-table for periods that are under modification
-- Instead of updating rows in substitute_operating_day_by_line_type, we delete rows and insert them back into table.
DELETE FROM
    service_calendar.substitute_operating_day_by_line_type sodblt
WHERE
    EXISTS(
        SELECT
            1
        FROM
            operating_periods
        WHERE
            sodblt.substitute_operating_period_id = operating_periods.id
    );

-- IF periods id does not exists, insert new row
INSERT INTO
    service_calendar.substitute_operating_period (period_name)
SELECT
    period_name
FROM
    operating_periods
WHERE
    operating_periods.id IS NULL;

-- If existing operating period have been changed, update it
UPDATE
    service_calendar.substitute_operating_period
SET
    period_name = op.period_name
FROM
    operating_periods op
WHERE
    substitute_operating_period.id = op.id;

-- Insert new rows to substitute_operating_period_day_by_line_type
-- There is also rows that were removed before
INSERT INTO
    service_calendar.substitute_operating_day_by_line_type (
        type_of_line,
        superseded_date,
        substitute_day_of_week,
        begin_time,
        end_time,
        substitute_operating_period_id
    )
SELECT
    unnest(period.line_types),
    period_date,
    period.substitute_day_of_week,
    period.begin_time,
    period.end_time,
    COALESCE(period.id, sop.id)
FROM
    operating_periods period
    INNER JOIN service_calendar.substitute_operating_period sop ON period.period_name = sop.period_name,
    generate_series(
        period.begin_date,
        period.end_date,
        INTERVAL '1' DAY
    ) AS period_date(i);

RETURN QUERY
SELECT
    *
FROM
    service_calendar.substitute_operating_period;

END;

$$;