import { routes as genericRoutes } from 'generic/networkdb/datasets/defaultSetup/routes';
import {
  HslRoute,
  LegacyHslMunicipality,
  RouteDirection,
} from 'hsl/networkdb/datasets/types';
import { DateTime } from 'luxon';
import { buildHslRoute } from '../factories';
import { hslLines } from './lines';

export const hslRoutes: HslRoute[] = genericRoutes
  .map((r) => buildHslRoute(r))
  .concat([
    buildHslRoute(
      {
        route_id: '4dadce26-0689-4843-b9fc-1ffb43a35fc1',
        on_line_id: hslLines[4].line_id,
        variant: 3,
        legacy_hsl_municipality_code: LegacyHslMunicipality.Helsinki,
        direction: RouteDirection.Westbound,
        priority: 20,
        validity_start: null,
        validity_end: DateTime.fromISO('2044-09-01'),
      },
      '6',
    ),
  ]);
