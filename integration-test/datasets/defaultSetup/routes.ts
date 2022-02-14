import {
  InfrastructureLinkAlongRoute,
  Route,
  RouteDirection,
} from "@datasets/types";
import { scheduledStopPoints } from "./scheduled-stop-points";
import { lines } from "./lines";
import { infrastructureLinks } from "./infrastructure-links";

export const routes: Route[] = [
  {
    route_id: "61bef596-84a0-40ea-b818-423d6b9b1fcf",
    on_line_id: lines[0].line_id,
    description_i18n: "route 1",
    starts_from_scheduled_stop_point_id:
      scheduledStopPoints[3].scheduled_stop_point_id,
    ends_at_scheduled_stop_point_id:
      scheduledStopPoints[4].scheduled_stop_point_id,
    label: "route 1",
    direction: RouteDirection.Northbound,
    priority: 10,
    validity_start: new Date("2044-05-02 23:11:32Z"),
    validity_end: null,
  },
  {
    route_id: "91994146-0569-44be-b2f1-da3c073d416c",
    on_line_id: lines[1].line_id,
    description_i18n: "route 2",
    starts_from_scheduled_stop_point_id:
      scheduledStopPoints[1].scheduled_stop_point_id,
    ends_at_scheduled_stop_point_id:
      scheduledStopPoints[2].scheduled_stop_point_id,
    label: "route 2",
    direction: RouteDirection.Southbound,
    priority: 20,
    validity_start: new Date("2044-06-02 23:11:32Z"),
    validity_end: new Date("2045-04-02 23:11:32Z"),
  },
  {
    route_id: "0dac4416-1f84-4951-86b7-149f643594de",
    on_line_id: lines[2].line_id,
    description_i18n: "route 3",
    starts_from_scheduled_stop_point_id:
      scheduledStopPoints[0].scheduled_stop_point_id,
    ends_at_scheduled_stop_point_id:
      scheduledStopPoints[1].scheduled_stop_point_id,
    label: "route 3",
    direction: RouteDirection.Eastbound,
    priority: 30,
    validity_start: null,
    validity_end: new Date("2044-09-02 23:11:32Z"),
  },
  {
    route_id: "a77b98e5-cfaf-4c65-bfc5-169d00bcd8d9",
    on_line_id: lines[2].line_id,
    description_i18n: "route 4",
    starts_from_scheduled_stop_point_id:
      scheduledStopPoints[1].scheduled_stop_point_id,
    ends_at_scheduled_stop_point_id:
      scheduledStopPoints[2].scheduled_stop_point_id,
    label: "route 4",
    direction: RouteDirection.Westbound,
    priority: 20,
    validity_start: new Date("2044-01-02 21:11:32Z"),
    validity_end: new Date("2044-09-02 22:11:32Z"),
  },
];

export const infrastructureLinkAlongRoute: InfrastructureLinkAlongRoute[] = [
  {
    route_id: routes[0].route_id,
    infrastructure_link_id: infrastructureLinks[8].infrastructure_link_id,
    infrastructure_link_sequence: 0,
    is_traversal_forwards: false,
  },
  {
    route_id: routes[0].route_id,
    infrastructure_link_id: infrastructureLinks[6].infrastructure_link_id,
    infrastructure_link_sequence: 1,
    is_traversal_forwards: false,
  },
  {
    route_id: routes[0].route_id,
    infrastructure_link_id: infrastructureLinks[4].infrastructure_link_id,
    infrastructure_link_sequence: 3,
    is_traversal_forwards: true,
  },
  {
    route_id: routes[0].route_id,
    infrastructure_link_id: infrastructureLinks[5].infrastructure_link_id,
    infrastructure_link_sequence: 4,
    is_traversal_forwards: false,
  },
  {
    route_id: routes[0].route_id,
    infrastructure_link_id: infrastructureLinks[9].infrastructure_link_id,
    infrastructure_link_sequence: 10,
    is_traversal_forwards: false,
  },
];
