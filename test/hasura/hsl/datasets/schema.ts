import {
  genericNetworkDbSchema,
  genericNetworkDbTables,
} from '@datasets-generic/schema';
import { hslLineProps, hslRouteProps } from '@datasets-hsl/types';
import { mergeLists } from '@util/schema';

export const hslNetworkDbTables = [
  ...genericNetworkDbTables,
  'hsl_route.transport_target',
] as const;
export type HslNetworkDbTables = typeof hslNetworkDbTables[number];

export const hslNetworkDbSchema: TableSchema<HslNetworkDbTables>[] = mergeLists(
  genericNetworkDbSchema,
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
