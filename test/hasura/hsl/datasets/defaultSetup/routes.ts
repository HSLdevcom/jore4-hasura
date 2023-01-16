import { routes as genericRoutes } from '@datasets-generic/defaultSetup/routes';
import {
  LegacyHslMunicipalityCodeId,
  HslRoute,
  RouteDirection,
} from '@datasets-hsl/types';
import { LocalDate } from 'local-date';
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
        legacy_hsl_municipality_code: LegacyHslMunicipalityCodeId.Helsinki,
        direction: RouteDirection.Westbound,
        priority: 20,
        validity_start: null,
        validity_end: new LocalDate('2044-09-01'),
      },
      '6',
    ),
  ]);
