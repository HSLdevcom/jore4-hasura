import {
  genericNetworkDbSchema,
  genericNetworkDbTables,
} from 'generic/networkdb/datasets/schema';
import {
  hslLineProps,
  hslRouteProps,
  hslScheduledStopPointProps,
  lineExternalIdProps,
} from 'hsl/networkdb/datasets/types';

// extend with hsl data model tables on demand
const hslOnlyNetworkDbTables = ['route.line_external_id'];
export const hslNetworkDbTables = [
  ...genericNetworkDbTables,
  ...hslOnlyNetworkDbTables,
] as const;
export type HslNetworkDbTables = (typeof hslNetworkDbTables)[number];

export const hslNetworkDbSchema: TableSchemaMap<HslNetworkDbTables> = {
  ...genericNetworkDbSchema,
  'service_pattern.scheduled_stop_point': {
    name: 'service_pattern.scheduled_stop_point',
    props: hslScheduledStopPointProps,
  },
  'route.line_external_id': {
    name: 'route.line_external_id',
    props: lineExternalIdProps,
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
