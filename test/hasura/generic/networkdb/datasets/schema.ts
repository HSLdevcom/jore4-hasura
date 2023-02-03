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
} from 'generic/networkdb/datasets/types';

export const genericNetworkDbTables = [
  'infrastructure_network.infrastructure_link',
  'infrastructure_network.vehicle_submode_on_infrastructure_link',
  'timing_pattern.timing_place',
  'service_pattern.scheduled_stop_point_invariant',
  'service_pattern.scheduled_stop_point',
  'service_pattern.vehicle_mode_on_scheduled_stop_point',
  'route.line',
  'route.route',
  'route.infrastructure_link_along_route',
  'journey_pattern.journey_pattern',
  'journey_pattern.scheduled_stop_point_in_journey_pattern',
] as const;
export type GenericNetworkDbTables = typeof genericNetworkDbTables[number];

export const genericNetworkDbSchema: TableSchemaMap<GenericNetworkDbTables> = {
  'infrastructure_network.infrastructure_link': {
    name: 'infrastructure_network.infrastructure_link',
    props: infrastructureLinkProps,
  },
  'infrastructure_network.vehicle_submode_on_infrastructure_link': {
    name: 'infrastructure_network.vehicle_submode_on_infrastructure_link',
    props: vehicleSubmodeOnInfrastructureLinkProps,
  },
  'timing_pattern.timing_place': {
    name: 'timing_pattern.timing_place',
    props: timingPatternTimingPlaceProps,
  },
  'service_pattern.scheduled_stop_point_invariant': {
    name: 'service_pattern.scheduled_stop_point_invariant',
    props: scheduledStopPointInvariantProps,
  },
  'service_pattern.scheduled_stop_point': {
    name: 'service_pattern.scheduled_stop_point',
    props: scheduledStopPointProps,
  },
  'service_pattern.vehicle_mode_on_scheduled_stop_point': {
    name: 'service_pattern.vehicle_mode_on_scheduled_stop_point',
    props: vehicleModeOnScheduledStopPointProps,
  },
  'route.line': {
    name: 'route.line',
    props: lineProps,
  },
  'route.route': {
    name: 'route.route',
    props: routeProps,
  },
  'route.infrastructure_link_along_route': {
    name: 'route.infrastructure_link_along_route',
    props: infrastructureLinkAlongRouteProps,
  },
  'journey_pattern.journey_pattern': {
    name: 'journey_pattern.journey_pattern',
    props: journeyPatternProps,
  },
  'journey_pattern.scheduled_stop_point_in_journey_pattern': {
    name: 'journey_pattern.scheduled_stop_point_in_journey_pattern',
    props: scheduledStopPointInJourneyPatternProps,
  },
};
