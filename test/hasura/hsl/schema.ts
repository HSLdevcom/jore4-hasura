import {
  genericNetworkDbSchema,
  genericNetworkDbTables,
} from '@datasets-generic/schema';
import { hslLineProps, hslRouteProps } from '@datasets-hsl/types';
import { upsertList } from '@util/schema';

export const hslNetworkDbTables = [
  ...genericNetworkDbTables,
  'hsl_route.transport_target',
] as const;
export type HslNetworkDbTables = typeof hslNetworkDbTables[number];

export const hslNetworkDbSchema: TableSchema<HslNetworkDbTables>[] = upsertList(
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
