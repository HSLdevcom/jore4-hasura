--
-- General utilities
--

CREATE SCHEMA IF NOT EXISTS internal_utils;
COMMENT ON SCHEMA
  internal_utils IS
  'General utilities';

CREATE OR REPLACE FUNCTION internal_utils.ST_LineLocatePoint (
  a_linestring geography,
  a_point geography
)
RETURNS double precision
LANGUAGE sql
IMMUTABLE
STRICT
PARALLEL SAFE
AS $internal_utils_st_linelocatepoint$
  WITH local_srid AS (
    SELECT _ST_BestSRID(a_linestring, a_point) AS srid
  )
  SELECT
    ST_LineLocatePoint(
      ST_Transform(a_linestring::geometry, srid),
      ST_Transform(a_point::geometry, srid)
    )
  FROM
    local_srid
$internal_utils_st_linelocatepoint$;
COMMENT ON FUNCTION
  internal_utils.ST_LineLocatePoint IS
  'ST_LineLocatePoint for geography';

CREATE OR REPLACE FUNCTION internal_utils.ST_LineInterpolatePoint (
  a_linestring geography,
  a_fraction double precision
)
RETURNS geography
LANGUAGE sql
IMMUTABLE
STRICT
PARALLEL SAFE
AS $internal_utils_st_lineinterpolatepoint$
  WITH local_srid AS (
    SELECT _ST_BestSRID(a_linestring) AS srid
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
$internal_utils_st_lineinterpolatepoint$;
COMMENT ON FUNCTION
  internal_utils.ST_LineInterpolatePoint IS
  'ST_LineInterpolatePoint for geography';
