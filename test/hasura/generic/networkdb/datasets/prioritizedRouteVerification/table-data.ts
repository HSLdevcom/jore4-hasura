import {
  journeyPatterns,
  journeyPatternsWithTempRoute,
  scheduledStopPointInJourneyPattern,
  scheduledStopPointInJourneyPatternWithTempRoute,
} from 'generic/networkdb/datasets/prioritizedRouteVerification/journey-patterns';
import { GenericNetworkDbTables } from 'generic/networkdb/datasets/schema';
import {
  infrastructureLinks,
  vehicleSubmodeOnInfrastructureLink,
} from './infrastructure-links';
import { lines } from './lines';
import {
  infrastructureLinkAlongRoute,
  infrastructureLinkAlongRouteWithTempRoute,
  routes,
  routesWithTempRoute,
} from './routes';
import {
  scheduledStopPointInvariants,
  scheduledStopPoints,
  scheduledStopPointsWithTempRoute,
  vehicleModeOnScheduledStopPoint,
  vehicleModeOnScheduledStopPointWithTempRoute,
} from './scheduled-stop-points';
import { timingPlaces } from './timing-places';

export const prioritizedRouteVerificationTableData: TableData<GenericNetworkDbTables>[] =
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

export const prioritizedRouteVerificationWithTempRouteTableData: TableData<GenericNetworkDbTables>[] =
  prioritizedRouteVerificationTableData.map((tableLikeConfig) => {
    if (!tableLikeConfig.data) {
      return tableLikeConfig; // no data defined
    }

    const newData = (() => {
      switch (tableLikeConfig.name) {
        case 'service_pattern.scheduled_stop_point':
          return scheduledStopPointsWithTempRoute;
        case 'service_pattern.vehicle_mode_on_scheduled_stop_point':
          return vehicleModeOnScheduledStopPointWithTempRoute;
        case 'route.route':
          return routesWithTempRoute;
        case 'route.infrastructure_link_along_route':
          return infrastructureLinkAlongRouteWithTempRoute;
        case 'journey_pattern.journey_pattern':
          return journeyPatternsWithTempRoute;
        case 'journey_pattern.scheduled_stop_point_in_journey_pattern':
          return scheduledStopPointInJourneyPatternWithTempRoute;
        default:
          return undefined;
      }
    })();

    if (newData) {
      return {
        ...tableLikeConfig,
        data: newData,
      };
    }
    return tableLikeConfig; // use same data as prioritizedRouteVerification data set
  });
