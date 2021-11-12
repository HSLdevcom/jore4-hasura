import { GeometryObject } from "@util/dataset";

export enum Direction {
  Forward = "forward",
  Backward = "backward",
  BiDirectional = "bidirectional",
}

export type InfrastructureLink = {
  infrastructure_link_id: string;
  direction: Direction;
  shape: GeometryObject;
  estimated_length_in_metres: number;
  external_link_source: string;
  external_link_id: number;
};

export type ScheduledStopPoint = {
  scheduled_stop_point_id: string;
  located_on_infrastructure_link_id: string;
  direction: Direction;
  measured_location: GeometryObject;
  label: string;
  priority: number;
  validity_start: Date | null;
  validity_end: Date | null;
};

export type Route = {
  route_id: string;
  description_i18n: string;
  starts_from_scheduled_stop_point_id: string;
  ends_at_scheduled_stop_point_id: string;
  priority: number;
  validity_start: Date | null;
  validity_end: Date | null;
};
