import fs from "fs";
import util from "util";
import { Geometry } from "wkx";
// Need to use old version of geojson, since CRS-properties are not allowed in newer versions, but postgis allows them.
import * as geojson from "geojson";

export type GeometryObject = geojson.GeometryObject;

// define this type just to state our intention
type ObjectWithGeometryProps<T> = GeometryObject extends T[keyof T]
  ? Record<string, T[keyof T]>
  : never;

function isGeometryObject(object: any): object is GeometryObject {
  return "coordinates" in object && "type" in object;
}

export const asEwkb = (geoJson: GeometryObject) =>
  // postgresql uses upper case characters in its hex format
  Geometry.parseGeoJSON(geoJson).toEwkb().toString("hex").toUpperCase();

export function asDbGeometryObject<T extends ObjectWithGeometryProps<T>>(
  obj: T,
  geographyProps: string[]
): Record<string, unknown> {
  const mappedProps: { [propName: string]: string } = geographyProps.reduce(
    (mapped, prop) => {
      const value = obj[prop];
      if (!isGeometryObject(value)) {
        throw new Error(`Property ${prop} is not a GeometryObject`);
      }
      return { ...mapped, [prop]: asEwkb(value) };
    },
    {}
  );
  return Object.assign(obj, mappedProps);
}

export function readJsonArray<T extends ObjectWithGeometryProps<T>>(
  path: string,
  geographyProps?: string[]
) {
  const data = JSON.parse(fs.readFileSync(path).toString()) as T[];

  // Map the values of the specified geographyProps properties to EWKB in order
  // to be able to use the returned JSON as jsonb in postgresql.
  return geographyProps
    ? data.map((member) => asDbGeometryObject(member, geographyProps))
    : data;
}

export const toGraphQlObject = (obj: { [propName: string]: unknown }) =>
  util.inspect(obj, { depth: Infinity }).replaceAll("'", '"');
