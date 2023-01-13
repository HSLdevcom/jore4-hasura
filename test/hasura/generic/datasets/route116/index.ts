import {
  infrastructureLinkAlongRouteProps,
  infrastructureLinkProps,
  journeyPatternProps,
  lineProps,
  routeProps,
  scheduledStopPointInJourneyPatternProps,
  scheduledStopPointInvariantProps,
  scheduledStopPointProps,
  timingPatternTimingPlaceProps,
  vehicleModeOnScheduledStopPointProps,
  vehicleSubmodeOnInfrastructureLinkProps,
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
    props: infrastructureLinkProps,
  },
  {
    name: 'infrastructure_network.vehicle_submode_on_infrastructure_link',
    data: 'generic/datasets/route116/vehicle-submode-on-infrastructure-links.sql',
    props: vehicleSubmodeOnInfrastructureLinkProps,
  },
  {
    name: 'timing_pattern.timing_place',
    data: timingPlaces,
    props: timingPatternTimingPlaceProps,
  },
  {
    name: 'service_pattern.scheduled_stop_point_invariant',
    data: scheduledStopPointInvariants,
    props: scheduledStopPointInvariantProps,
  },
  {
    name: 'service_pattern.scheduled_stop_point',
    data: scheduledStopPoints,
    props: scheduledStopPointProps,
  },
  {
    name: 'service_pattern.vehicle_mode_on_scheduled_stop_point',
    data: vehicleModeOnScheduledStopPoint,
    props: vehicleModeOnScheduledStopPointProps,
  },
  { name: 'route.line', data: lines, props: lineProps },
  { name: 'route.route', data: routes, props: routeProps },
  {
    name: 'route.infrastructure_link_along_route',
    data: infrastructureLinkAlongRoute,
    props: infrastructureLinkAlongRouteProps,
  },
  {
    name: 'journey_pattern.journey_pattern',
    data: journeyPatterns,
    props: journeyPatternProps,
  },
  {
    name: 'journey_pattern.scheduled_stop_point_in_journey_pattern',
    data: scheduledStopPointInJourneyPattern,
    props: scheduledStopPointInJourneyPatternProps,
  },

  // views
  {
    name: 'service_pattern.scheduled_stop_point',
    props: scheduledStopPointProps,
    isView: true,
  },
  { name: 'route.route', props: routeProps, isView: true },
];
