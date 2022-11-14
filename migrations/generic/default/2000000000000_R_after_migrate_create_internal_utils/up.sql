
CREATE OR REPLACE FUNCTION internal_utils.prevent_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  RAISE EXCEPTION 'update of table not allowed';
END;
$$;

CREATE OR REPLACE FUNCTION internal_utils.next_day(bound date) RETURNS date
    LANGUAGE sql IMMUTABLE PARALLEL SAFE
    AS $$
SELECT CASE WHEN bound IS NULL THEN NULL::date ELSE (bound + INTERVAL '1 day')::date END;
$$;

CREATE OR REPLACE FUNCTION internal_utils.prev_day(bound date) RETURNS date
    LANGUAGE sql IMMUTABLE PARALLEL SAFE
    AS $$
SELECT CASE WHEN bound IS NULL THEN NULL::date ELSE (bound - INTERVAL '1 day')::date END;
$$;

CREATE OR REPLACE FUNCTION internal_utils.const_priority_draft() RETURNS integer
    LANGUAGE sql IMMUTABLE PARALLEL SAFE
    AS $$SELECT 30$$;

CREATE OR REPLACE FUNCTION internal_utils.date_closed_upper(range daterange) RETURNS date
    LANGUAGE sql IMMUTABLE PARALLEL SAFE
    AS $$
SELECT internal_utils.prev_day(upper(range));
$$;
COMMENT ON FUNCTION internal_utils.date_closed_upper(range daterange) IS 'This function calculates the upper bound of a date range created by the
  internal_utils.daterange_closed_upper function.';

CREATE OR REPLACE FUNCTION internal_utils.daterange_closed_upper(lower_bound date, closed_upper_bound date) RETURNS daterange
    LANGUAGE sql IMMUTABLE PARALLEL SAFE
    AS $$
SELECT daterange(lower_bound, internal_utils.next_day(closed_upper_bound));
$$;
COMMENT ON FUNCTION internal_utils.daterange_closed_upper(lower_bound date, closed_upper_bound date) IS 'In postgresql, date ranges are handled using lower bound closed and upper bound open. In order
  to be able to check for overlapping ranges when using closed upper bounds, this function constructs
  a daterange with the upper bound interpreted as a closed bound. This function behaves the same way
  as "daterange(lower_bound, upper_bound, ''[]'')", but because we also need to access the bounds (and
  this would anyway require manual addition / subtraction of 1 day), we rather do all processing in
  custom functions.

  Note that the range returned by this function will work well for calculating overlaps and merging,
  but does not contain the correct logical upper bound. In order to calculate the upper bound of a range
  created by this function, use the internal_utils.date_closed_upper function.';

CREATE OR REPLACE FUNCTION internal_utils.determine_srid(geog public.geography) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
    AS $$
  SELECT _ST_BestSRID(geog)
$$;
COMMENT ON FUNCTION internal_utils.determine_srid(geog public.geography) IS 'Determine the most suitable SRID to be used for the given geography when converting it to a geometry.
   At the moment, this function serves as a wrapper for the internal _ST_BestSRID function, which is poorly
   documented and may be removed in the future.
   If needed, modify this function and its overloads to return the correct SRID(s) for your use case(s). For many
   projects, returning a constant may be a good choice.';

CREATE OR REPLACE FUNCTION internal_utils.determine_srid(geog1 public.geography, geog2 public.geography) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
    AS $$
  SELECT _ST_BestSRID(geog1, geog2)
$$;
COMMENT ON FUNCTION internal_utils.determine_srid(geog1 public.geography, geog2 public.geography) IS 'Determine the most suitable common SRID to be used for the given geographies when converting them into geometries.
   At the moment, this function serves as a wrapper for the internal _ST_BestSRID function, which is poorly
   documented and may be removed in the future.
   If needed, modify this function and its overloads to return the correct SRID(s) for your use case(s). For many
   projects, returning a constant may be a good choice.';

CREATE OR REPLACE FUNCTION internal_utils.st_closestpoint(a_linestring public.geography, a_point public.geography) RETURNS public.geography
    LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
    AS $$
WITH local_srid AS (
  SELECT internal_utils.determine_SRID(a_linestring, a_point) AS srid
)
SELECT
  ST_Transform(
    ST_ClosestPoint(
      ST_Transform(a_linestring::geometry, srid),
      ST_Transform(a_point::geometry, srid)
    ),
    ST_SRID(a_linestring::geometry)
  )::geography
FROM
  local_srid
$$;
COMMENT ON FUNCTION internal_utils.st_closestpoint(a_linestring public.geography, a_point public.geography) IS 'ST_ClosestPoint for geography';

CREATE OR REPLACE FUNCTION internal_utils.st_lineinterpolatepoint(a_linestring public.geography, a_fraction double precision) RETURNS public.geography
    LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
    AS $$
  WITH local_srid AS (
    SELECT internal_utils.determine_SRID(a_linestring) AS srid
  )
  SELECT
    ST_Transform(
      ST_LineInterpolatePoint(
        ST_Transform(a_linestring::geometry, srid),
        a_fraction
      ),
      ST_SRID(a_linestring::geometry)
    )::geography
  FROM
    local_srid
$$;
COMMENT ON FUNCTION internal_utils.st_lineinterpolatepoint(a_linestring public.geography, a_fraction double precision) IS 'ST_LineInterpolatePoint for geography';

CREATE OR REPLACE FUNCTION internal_utils.st_linelocatepoint(a_linestring public.geography, a_point public.geography) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
    AS $$
  WITH local_srid AS (
    SELECT internal_utils.determine_SRID(a_linestring, a_point) AS srid
  )
  SELECT
    ST_LineLocatePoint(
      ST_Transform(a_linestring::geometry, srid),
      ST_Transform(a_point::geometry, srid)
    )
  FROM
    local_srid
$$;
COMMENT ON FUNCTION internal_utils.st_linelocatepoint(a_linestring public.geography, a_point public.geography) IS 'ST_LineLocatePoint for geography';
