--
-- General utilities
--

CREATE SCHEMA internal_utils;
COMMENT ON SCHEMA
  internal_utils IS
  'General utilities';

CREATE FUNCTION internal_utils.determine_SRID(
  geog geography
)
RETURNS integer
LANGUAGE sql
IMMUTABLE
STRICT
PARALLEL SAFE
AS $internal_utils_determine_srid_geog$
  SELECT _ST_BestSRID(geog)
$internal_utils_determine_srid_geog$;
COMMENT ON FUNCTION
  internal_utils.determine_SRID(geography) IS
  'Determine the SRID to be used for the given geography.
   At the moment, this function serves as a wrapper for the internal _ST_BestSRID function, which is poorly
   documented and may be removed in the future.
   If needed, modify this function and its overloads to return the correct SRID(s) for your use case(s). For many
   projects, returning a constant may be a good choice.';

CREATE FUNCTION internal_utils.determine_SRID(
  geog1 geography,
  geog2 geography
)
RETURNS integer
LANGUAGE sql
IMMUTABLE
STRICT
PARALLEL SAFE
AS $internal_utils_determine_srid_geog1_geog2$
  SELECT _ST_BestSRID(geog1, geog2)
$internal_utils_determine_srid_geog1_geog2$;
COMMENT ON FUNCTION
  internal_utils.determine_SRID(geography, geography) IS
  'Determine the SRID to be used for the given geographies.
   At the moment, this function serves as a wrapper for the internal _ST_BestSRID function, which is poorly
   documented and may be removed in the future.
   If needed, modify this function and its overloads to return the correct SRID(s) for your use case(s). For many
   projects, returning a constant may be a good choice.';

CREATE FUNCTION internal_utils.ST_LineLocatePoint (
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
    SELECT internal_utils.determine_SRID(a_linestring, a_point) AS srid
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

CREATE FUNCTION internal_utils.ST_LineInterpolatePoint (
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
$internal_utils_st_lineinterpolatepoint$;
COMMENT ON FUNCTION
  internal_utils.ST_LineInterpolatePoint IS
  'ST_LineInterpolatePoint for geography';
