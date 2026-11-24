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
      name: 'network.timing_place',
      data: timingPlaces,
    },
    {
      name: 'network.scheduled_stop_point_invariant',
      data: scheduledStopPointInvariants,
    },
    {
      name: 'network.scheduled_stop_point',
      data: scheduledStopPoints,
    },
    {
      name: 'network.vehicle_mode_on_scheduled_stop_point',
      data: vehicleModeOnScheduledStopPoint,
    },
    {
      name: 'network.line',
      data: lines,
    },
    {
      name: 'network.route',
      data: routes,
    },
    {
      name: 'network.infrastructure_link_along_route',
      data: infrastructureLinkAlongRoute,
    },
    {
      name: 'network.journey_pattern',
      data: journeyPatterns,
    },
    {
      name: 'network.scheduled_stop_point_in_journey_pattern',
      data: scheduledStopPointInJourneyPattern,
    },
  ];
