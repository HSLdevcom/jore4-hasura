import {
  infrastructureLinks,
  vehicleSubmodeOnInfrastructureLink,
} from './infrastructure-links';
import {
  scheduledStopPointInvariants,
  scheduledStopPoints,
  scheduledStopPointsWithTempRoute,
  vehicleModeOnScheduledStopPoint,
  vehicleModeOnScheduledStopPointWithTempRoute,
} from './scheduled-stop-points';
import { lines } from './lines';
import {
  infrastructureLinkAlongRoute,
  infrastructureLinkAlongRouteWithTempRoute,
  routes,
  routesWithTempRoute,
} from './routes';
import { TableLikeConfig } from '@datasets/setup';
import {
  InfrastructureLinkAlongRouteProps,
  InfrastructureLinkProps,
  JourneyPatternProps,
  LineProps,
  RouteProps,
  ScheduledStopPointInJourneyPatternProps,
  ScheduledStopPointInvariantProps,
  ScheduledStopPointProps,
  VehicleModeOnScheduledStopPointProps,
  VehicleSubmodeOnInfrastructureLinkProps,
} from '@datasets/types';
import {
  journeyPatterns,
  journeyPatternsWithTempRoute,
  scheduledStopPointInJourneyPattern,
  scheduledStopPointInJourneyPatternWithTempRoute,
} from '@datasets/prioritizedRouteVerification/journey-patterns';

export const prioritizedRouteVerificationTableConfig: TableLikeConfig[] = [
  {
    name: 'infrastructure_network.infrastructure_link',
    data: infrastructureLinks,
    props: InfrastructureLinkProps,
  },
  {
    name: 'infrastructure_network.vehicle_submode_on_infrastructure_link',
    data: vehicleSubmodeOnInfrastructureLink,
    props: VehicleSubmodeOnInfrastructureLinkProps,
  },
  {
    name: 'service_pattern.scheduled_stop_point_invariant',
    data: scheduledStopPointInvariants,
    props: ScheduledStopPointInvariantProps,
  },
  {
    name: 'service_pattern.scheduled_stop_point',
    data: scheduledStopPoints,
    props: ScheduledStopPointProps,
  },
  {
    name: 'service_pattern.vehicle_mode_on_scheduled_stop_point',
    data: vehicleModeOnScheduledStopPoint,
    props: VehicleModeOnScheduledStopPointProps,
  },
  { name: 'route.line', data: lines, props: LineProps },
  { name: 'route.route', data: routes, props: RouteProps },
  {
    name: 'route.infrastructure_link_along_route',
    data: infrastructureLinkAlongRoute,
    props: InfrastructureLinkAlongRouteProps,
  },
  {
    name: 'journey_pattern.journey_pattern',
    data: journeyPatterns,
    props: JourneyPatternProps,
  },
  {
    name: 'journey_pattern.scheduled_stop_point_in_journey_pattern',
    data: scheduledStopPointInJourneyPattern,
    props: ScheduledStopPointInJourneyPatternProps,
  },

  // views
  {
    name: 'service_pattern.scheduled_stop_point',
    props: ScheduledStopPointProps,
    isView: true,
  },
  { name: 'route.route', props: RouteProps, isView: true },
];

export const prioritizedRouteVerificationWithTempRouteTableConfig: TableLikeConfig[] =
  prioritizedRouteVerificationTableConfig.map((tableLikeConfig) => {
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
      }
    })();

    if (newData) {
      return {
        ...tableLikeConfig,
        data: newData,
      };
    } else {
      return tableLikeConfig; // use same data as prioritizedRouteVerification data set
    }
  });
