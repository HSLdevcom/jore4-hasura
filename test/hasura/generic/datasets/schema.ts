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
import keyBy from 'lodash/keyBy';

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

// TODO: delete this list format if not proven useful
export const genericNetworkDbSchemaList: TableSchema<GenericNetworkDbTables>[] =
  [
    {
      name: 'infrastructure_network.infrastructure_link',
      props: infrastructureLinkProps,
    },
    {
      name: 'infrastructure_network.vehicle_submode_on_infrastructure_link',
      props: vehicleSubmodeOnInfrastructureLinkProps,
    },
    {
      name: 'timing_pattern.timing_place',
      props: timingPatternTimingPlaceProps,
    },
    {
      name: 'service_pattern.scheduled_stop_point_invariant',
      props: scheduledStopPointInvariantProps,
    },
    {
      name: 'service_pattern.scheduled_stop_point',
      props: scheduledStopPointProps,
    },
    {
      name: 'service_pattern.vehicle_mode_on_scheduled_stop_point',
      props: vehicleModeOnScheduledStopPointProps,
    },
    {
      name: 'route.line',
      props: lineProps,
    },
    {
      name: 'route.route',
      props: routeProps,
    },
    {
      name: 'route.infrastructure_link_along_route',
      props: infrastructureLinkAlongRouteProps,
    },
    {
      name: 'journey_pattern.journey_pattern',
      props: journeyPatternProps,
    },
    {
      name: 'journey_pattern.scheduled_stop_point_in_journey_pattern',
      props: scheduledStopPointInJourneyPatternProps,
    },
  ];

// hash map format for easy searchability
// TODO: fix type mapping from lodash to final format
export const genericNetworkDbSchema = keyBy(
  genericNetworkDbSchemaList,
  (schema) => schema.name,
) as TableSchemaMap<GenericNetworkDbTables>;
