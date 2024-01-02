// Need to use old version of geojson, since CRS-properties are not allowed in newer versions, but postgis allows them.
import { GeometryObject } from 'geojson';
import { DateTime, Duration } from 'luxon';
import { Geometry } from 'wkx';

function isGeometryObject(object: ExplicitAny): object is GeometryObject {
  return (
    // it's a valid object
    object !== undefined &&
    object !== null &&
    typeof object === 'object' &&
    // it has "type" and "coordinates" attributes
    Object.prototype.hasOwnProperty.call(object, 'coordinates') &&
    Object.prototype.hasOwnProperty.call(object, 'type')
  );
}

export const asEwkb = (geoJson: GeometryObject) =>
  // postgresql uses upper case characters in its hex format
  Geometry.parseGeoJSON(geoJson).toEwkb().toString('hex').toUpperCase();

type SerializerFunction = (value: unknown) => unknown;

export const serializePlainObject = (
  obj: PlainObject,
  serializerFn: SerializerFunction,
) => {
  const serializedEntries = Object.entries(obj).map((entry) => {
    const [key, value] = entry;
    return [key, serializerFn(value)];
  });
  return Object.fromEntries(serializedEntries);
};

// serializes values sent to SQL INSERT INTO commands
export const serializeInsertValue: SerializerFunction = (value: unknown) => {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  if (value && (value as any).isLuxonDateTime) {
    return (value as DateTime).toISO();
  }
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  if (value && (value as any).isLuxonDuration) {
    return (value as Duration).toString();
  }
  if (isGeometryObject(value)) {
    return asEwkb(value);
  }
  return value;
};
export const serializeInsertInput = (jsonObject: PlainObject) => {
  return serializePlainObject(jsonObject, serializeInsertValue);
};

// serializes values used in jest test matchers
export const serializeMatcherValue: SerializerFunction = (value: unknown) => {
  if (isGeometryObject(value)) {
    return asEwkb(value);
  }
  return value;
};
export const serializeMatcherInput = (input: PlainObject) => {
  return serializePlainObject(input, serializeMatcherValue);
};
export const serializeMatcherInputs = (inputs: PlainObject[]) =>
  inputs.map(serializeMatcherInput);

export const toGraphQlObject = (
  obj: { [propName: string]: unknown },
  enumProps: string[] = [],
) =>
  JSON.stringify(obj)
    // strip quotes from all keys
    .replace(/"(\w+)"\s*:/g, '$1:')
    // strip quotes from enum values
    .replace(
      new RegExp(`(${enumProps.join('|')}):\\s*"(\\w+)"`, 'g'),
      '$1: $2',
    );

export const asGraphQlDateObject = (obj: { [propName: string]: unknown }) =>
  Object.keys(obj).reduce((mapped, prop) => {
    const value = obj[prop];
    return {
      ...mapped,
      // format dates YYYY-MM-DD
      [prop]: value instanceof DateTime ? value.toISODate() : value,
    };
  }, {});

export const buildLocalizedString = (str: string): LocalizedString => ({
  fi_FI: str,
  sv_FI: `${str} SV`,
});
