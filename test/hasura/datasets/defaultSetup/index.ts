import { TableLikeConfig } from '@datasets/setup';
import {
  InfrastructureLinkAlongRouteProps,
  InfrastructureLinkProps,
  LineProps,
  RouteProps,
  ScheduledStopPointInvariantProps,
  ScheduledStopPointProps,
  VehicleModeOnScheduledStopPointProps,
  VehicleSubmodeOnInfrastructureLinkProps,
} from '@datasets/types';
import {
  infrastructureLinks,
  vehicleSubmodeOnInfrastructureLink,
} from './infrastructure-links';
import { lines } from './lines';
import { infrastructureLinkAlongRoute, routes } from './routes';
import {
  scheduledStopPointInvariants,
  scheduledStopPoints,
  vehicleModeOnScheduledStopPoint,
} from './scheduled-stop-points';

export const defaultTableConfig: TableLikeConfig[] = [
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

  // views
  {
    name: 'service_pattern.scheduled_stop_point',
    props: ScheduledStopPointProps,
    isView: true,
  },
  { name: 'route.route', props: RouteProps, isView: true },
];
