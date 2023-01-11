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

export const route116TableConfig: TableLikeConfig[] = [
  {
    name: 'infrastructure_network.infrastructure_link',
    data: 'generic/datasets/route116/infrastructure-links.sql',
    props: InfrastructureLinkProps,
  },
  {
    name: 'infrastructure_network.vehicle_submode_on_infrastructure_link',
    data: 'generic/datasets/route116/vehicle-submode-on-infrastructure-links.sql',
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
