import { GenericNetworkDbTables } from 'generic/networkdb/datasets/schema';
import {
  infrastructureLinks,
  vehicleSubmodeOnInfrastructureLink,
} from './infrastructure-links';
import {
  journeyPatterns,
  scheduledStopPointInJourneyPattern,
} from './journey-patterns';
import { lines } from './lines';
import { infrastructureLinkAlongRoute, routes } from './routes';
import {
  scheduledStopPointInvariants,
  scheduledStopPoints,
  vehicleModeOnScheduledStopPoint,
} from './scheduled-stop-points';
import { timingPlaces } from './timing-places';

export const routesAndJourneyPatternsTableData: TableData<GenericNetworkDbTables>[] =
  [
    {
      name: 'infrastructure_network.infrastructure_link',
      data: infrastructureLinks,
    },
    {
      name: 'infrastructure_network.vehicle_submode_on_infrastructure_link',
      data: vehicleSubmodeOnInfrastructureLink,
    },
    {
      name: 'timing_pattern.timing_place',
      data: timingPlaces,
    },
    {
      name: 'service_pattern.scheduled_stop_point_invariant',
      data: scheduledStopPointInvariants,
    },
    {
      name: 'service_pattern.scheduled_stop_point',
      data: scheduledStopPoints,
    },
    {
      name: 'service_pattern.vehicle_mode_on_scheduled_stop_point',
      data: vehicleModeOnScheduledStopPoint,
    },
    {
      name: 'route.line',
      data: lines,
    },
    {
      name: 'route.route',
      data: routes,
    },
    {
      name: 'route.infrastructure_link_along_route',
      data: infrastructureLinkAlongRoute,
    },
    {
      name: 'journey_pattern.journey_pattern',
      data: journeyPatterns,
    },
    {
      name: 'journey_pattern.scheduled_stop_point_in_journey_pattern',
      data: scheduledStopPointInJourneyPattern,
    },
  ];
