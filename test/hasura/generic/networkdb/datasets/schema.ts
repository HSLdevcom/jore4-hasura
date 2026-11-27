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
  'network.timing_place',
  'network.scheduled_stop_point_invariant',
  'network.scheduled_stop_point',
  'network.vehicle_mode_on_scheduled_stop_point',
  'network.line',
  'network.route',
  'network.infrastructure_link_along_route',
  'network.journey_pattern',
  'network.scheduled_stop_point_in_journey_pattern',
] as const;
export type GenericNetworkDbTables = (typeof genericNetworkDbTables)[number];

export const genericNetworkDbSchema: TableSchemaMap<GenericNetworkDbTables> = {
  'infrastructure_network.infrastructure_link': {
    name: 'infrastructure_network.infrastructure_link',
    props: infrastructureLinkProps,
  },
  'infrastructure_network.vehicle_submode_on_infrastructure_link': {
    name: 'infrastructure_network.vehicle_submode_on_infrastructure_link',
    props: vehicleSubmodeOnInfrastructureLinkProps,
  },
  'network.timing_place': {
    name: 'network.timing_place',
    props: timingPatternTimingPlaceProps,
  },
  'network.scheduled_stop_point_invariant': {
    name: 'network.scheduled_stop_point_invariant',
    props: scheduledStopPointInvariantProps,
  },
  'network.scheduled_stop_point': {
    name: 'network.scheduled_stop_point',
    props: scheduledStopPointProps,
  },
  'network.vehicle_mode_on_scheduled_stop_point': {
    name: 'network.vehicle_mode_on_scheduled_stop_point',
    props: vehicleModeOnScheduledStopPointProps,
  },
  'network.line': {
    name: 'network.line',
    props: lineProps,
  },
  'network.route': {
    name: 'network.route',
    props: routeProps,
  },
  'network.infrastructure_link_along_route': {
    name: 'network.infrastructure_link_along_route',
    props: infrastructureLinkAlongRouteProps,
  },
  'network.journey_pattern': {
    name: 'network.journey_pattern',
    props: journeyPatternProps,
  },
  'network.scheduled_stop_point_in_journey_pattern': {
    name: 'network.scheduled_stop_point_in_journey_pattern',
    props: scheduledStopPointInJourneyPatternProps,
  },
};
