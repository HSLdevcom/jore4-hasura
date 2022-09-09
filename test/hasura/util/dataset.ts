import { Geometry } from 'wkx';
// Need to use old version of geojson, since CRS-properties are not allowed in newer versions, but postgis allows them.
import * as geojson from 'geojson';

export type GeometryObject = geojson.GeometryObject;

// define this type just to state our intention
type ObjectWithGeometryProps<T> = GeometryObject extends T[keyof T]
  ? Record<string, T[keyof T]>
  : never;

function isGeometryObject(object: any): object is GeometryObject {
  return 'coordinates' in object && 'type' in object;
}

export const asEwkb = (geoJson: GeometryObject) =>
  // postgresql uses upper case characters in its hex format
  Geometry.parseGeoJSON(geoJson).toEwkb().toString('hex').toUpperCase();

export function asDbGeometryObject<T extends ObjectWithGeometryProps<T>>(
  obj: T,
  geographyProps: string[],
): Record<string, unknown> {
  const mappedProps: { [propName: string]: string } = geographyProps.reduce(
    (mapped, prop) => {
      const value = obj[prop];
      if (!isGeometryObject(value)) {
        throw new Error(`Property ${prop} is not a GeometryObject`);
      }
      return { ...mapped, [prop]: asEwkb(value) };
    },
    {},
  );
  return Object.assign({}, obj, mappedProps);
}

export function asDbGeometryObjectArray<T extends ObjectWithGeometryProps<T>>(
  objectArray: T[],
  geographyProps?: string[],
) {
  // Map the values of the specified geographyProps properties to EWKB in order
  // to be able to use the returned JSON as jsonb in postgresql.
  return geographyProps
    ? objectArray.map((member) => asDbGeometryObject(member, geographyProps))
    : objectArray;
}

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

export const asGraphQlTimestampObject = (obj: {
  [propName: string]: unknown;
}) =>
  Object.keys(obj).reduce((mapped, prop) => {
    const value = obj[prop];
    return {
      ...mapped,
      // cut off milliseconds and add explicit UTC offset
      [prop]:
        value instanceof Date
          ? value.toISOString().replace(/\.\d+Z$/, '+00:00')
          : value,
    };
  }, {});
