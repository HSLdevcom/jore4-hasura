import {
  genericNetworkDbSchemaList,
  genericNetworkDbTables,
} from '@datasets-generic/schema';
import { hslLineProps, hslRouteProps } from '@datasets-hsl/types';
import { mergeLists } from '@util/schema';
import keyBy from 'lodash/keyBy';

export const hslNetworkDbTables = [
  ...genericNetworkDbTables,
  'hsl_route.transport_target',
] as const;
export type HslNetworkDbTables = typeof hslNetworkDbTables[number];

// TODO: delete this list format if not proven useful
export const hslNetworkDbSchemaList: TableSchema<HslNetworkDbTables>[] =
  mergeLists(
    genericNetworkDbSchemaList,
    [
      {
        name: 'route.line',
        props: hslLineProps,
      },
      {
        name: 'route.route',
        props: hslRouteProps,
      },
    ],
    (tableSchema) => tableSchema.name,
  );

// hash map format for easy searchability
// TODO: fix type mapping from lodash to final format
export const hslNetworkDbSchema = keyBy(
  hslNetworkDbSchemaList,
  (schema) => schema.name,
) as TableSchemaMap<HslNetworkDbTables>;
