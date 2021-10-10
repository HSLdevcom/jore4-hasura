import { Route } from "./types";
import { scheduledStopPoints } from "@datasets/scheduled-stop-points";

export const routes: Route[] = [
  {
    route_id: "61bef596-84a0-40ea-b818-423d6b9b1fcf",
    description_i18n: "route 1",
    starts_from_scheduled_stop_point_id:
      scheduledStopPoints[0].scheduled_stop_point_id,
    ends_at_scheduled_stop_point_id:
      scheduledStopPoints[1].scheduled_stop_point_id,
  },
  {
    route_id: "91994146-0569-44be-b2f1-da3c073d416c",
    description_i18n: "route 2",
    starts_from_scheduled_stop_point_id:
      scheduledStopPoints[1].scheduled_stop_point_id,
    ends_at_scheduled_stop_point_id:
      scheduledStopPoints[2].scheduled_stop_point_id,
  },
  {
    route_id: "0dac4416-1f84-4951-86b7-149f643594de",
    description_i18n: "route 3",
    starts_from_scheduled_stop_point_id:
      scheduledStopPoints[0].scheduled_stop_point_id,
    ends_at_scheduled_stop_point_id:
      scheduledStopPoints[1].scheduled_stop_point_id,
  },
  {
    route_id: "a77b98e5-cfaf-4c65-bfc5-169d00bcd8d9",
    description_i18n: "route 4",
    starts_from_scheduled_stop_point_id:
      scheduledStopPoints[1].scheduled_stop_point_id,
    ends_at_scheduled_stop_point_id:
      scheduledStopPoints[2].scheduled_stop_point_id,
  },
];
