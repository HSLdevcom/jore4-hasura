import {
  infrastructureLinks,
  vehicleSubmodeOnInfrastructureLink,
} from "./infrastructure-links";
import {
  scheduledStopPoints,
  vehicleModeOnScheduledStopPoint,
} from "./scheduled-stop-points";
import { lines } from "./lines";
import { infrastructureLinkAlongRoute, routes } from "./routes";
import { TableLikeConfig } from "@datasets/setup";
import {
  InfrastructureLinkAlongRouteProps,
  InfrastructureLinkProps,
  JourneyPatternProps,
  LineProps,
  RouteProps,
  ScheduledStopPointInJourneyPatternProps,
  ScheduledStopPointProps,
  VehicleModeOnScheduledStopPointProps,
  VehicleSubmodeOnInfrastructureLinkProps,
} from "@datasets/types";
import {
  journeyPatterns,
  scheduledStopPointInJourneyPattern,
} from "./journey-patterns";

export const routesAndJourneyPatternsDatasets = {
  infrastructureLinks,
  vehicleSubmodeOnInfrastructureLink,
  scheduledStopPoints,
  vehicleModeOnScheduledStopPoint,
  lines,
  routes,
  infrastructureLinkAlongRoute,
};

export const routesAndJourneyPatternsTableConfig: TableLikeConfig[] = [
  {
    name: "infrastructure_network.infrastructure_link",
    data: infrastructureLinks,
    props: InfrastructureLinkProps,
  },
  {
    name: "infrastructure_network.vehicle_submode_on_infrastructure_link",
    data: vehicleSubmodeOnInfrastructureLink,
    props: VehicleSubmodeOnInfrastructureLinkProps,
  },
  {
    name: "internal_service_pattern.scheduled_stop_point",
    data: scheduledStopPoints,
    props: ScheduledStopPointProps,
  },
  {
    name: "service_pattern.vehicle_mode_on_scheduled_stop_point",
    data: vehicleModeOnScheduledStopPoint,
    props: VehicleModeOnScheduledStopPointProps,
  },
  { name: "route.line", data: lines, props: LineProps },
  { name: "internal_route.route", data: routes, props: RouteProps },
  {
    name: "route.infrastructure_link_along_route",
    data: infrastructureLinkAlongRoute,
    props: InfrastructureLinkAlongRouteProps,
  },
  {
    name: "journey_pattern.journey_pattern",
    data: journeyPatterns,
    props: JourneyPatternProps,
  },
  {
    name: "journey_pattern.scheduled_stop_point_in_journey_pattern",
    data: scheduledStopPointInJourneyPattern,
    props: ScheduledStopPointInJourneyPatternProps,
  },

  // views
  {
    name: "service_pattern.scheduled_stop_point",
    props: ScheduledStopPointProps,
    isView: true,
  },
  { name: "route.route", props: RouteProps, isView: true },
];
