import {
  journeyPatterns,
  journeyPatternsWithTempRoute,
  scheduledStopPointInJourneyPattern,
  scheduledStopPointInJourneyPatternWithTempRoute,
} from '@datasets-generic/prioritizedRouteVerification/journey-patterns';
import {
  InfrastructureLinkAlongRouteProps,
  InfrastructureLinkProps,
  JourneyPatternProps,
  LineProps,
  RouteProps,
  ScheduledStopPointInJourneyPatternProps,
  ScheduledStopPointInvariantProps,
  ScheduledStopPointProps,
  TimingPatternTimingPlaceProps,
  VehicleModeOnScheduledStopPointProps,
  VehicleSubmodeOnInfrastructureLinkProps,
} from '@datasets-generic/types';
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
    name: 'timing_pattern.timing_place',
    data: timingPlaces,
    props: TimingPatternTimingPlaceProps,
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