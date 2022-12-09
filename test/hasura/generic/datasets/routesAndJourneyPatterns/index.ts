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

export const routesAndJourneyPatternsTableConfig: TableLikeConfig[] = [
  {
    name: 'infrastructure_network.infrastructure_link',
    data: infrastructureLinks,
    props: infrastructureLinkProps,
  },
  {
    name: 'infrastructure_network.vehicle_submode_on_infrastructure_link',
    data: vehicleSubmodeOnInfrastructureLink,
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
];
