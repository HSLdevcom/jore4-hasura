import {
  genericNetworkDbSchema,
  genericNetworkDbTables,
} from 'generic/networkdb/datasets/schema';
import {
  hslLineProps,
  hslRouteProps,
  hslScheduledStopPointProps,
} from 'hsl/networkdb/datasets/types';

// extend with hsl data model tables on demand
export const hslNetworkDbTables = [...genericNetworkDbTables] as const;
export type HslNetworkDbTables = (typeof hslNetworkDbTables)[number];

export const hslNetworkDbSchema: TableSchemaMap<HslNetworkDbTables> = {
  ...genericNetworkDbSchema,
  'service_pattern.scheduled_stop_point': {
    name: 'service_pattern.scheduled_stop_point',
    props: hslScheduledStopPointProps,
  },
  'route.line': {
    name: 'route.line',
    props: hslLineProps,
  },
  'route.route': {
    name: 'route.route',
    props: hslRouteProps,
  },
};
