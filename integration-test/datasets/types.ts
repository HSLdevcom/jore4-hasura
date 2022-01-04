import { GeometryObject } from "@util/dataset";

export type PropArray = (
  | string
  | {
      propName: string;
      isGeoProp: boolean;
    }
)[];

export function hasGeoPropSpec<
  ObjType extends PropArray[number],
  PropType extends PropertyKey
>(obj: ObjType): obj is ObjType & Record<PropType, unknown> {
  return obj.hasOwnProperty("isGeoProp");
}

export enum LinkDirection {
  Forward = "forward",
  Backward = "backward",
  BiDirectional = "bidirectional",
}

export enum RouteDirection {
  Inbound = "inbound",
  Outbound = "outbound",
  Clockwise = "clockwise",
  Anticlockwise = "anticlockwise",
  Northbound = "northbound",
  Southbound = "southbound",
  Eastbound = "eastbound",
  Westbound = "westbound",
}

export enum VehicleMode {
  Bus = "bus",
  Tram = "tram",
  Train = "train",
  Metro = "metro",
  Ferry = "ferry",
}

export enum VehicleSubmode {
  GenericBus = "generic_bus",
  GenericTram = "generic_tram",
  GenericTrain = "generic_train",
  GenericMetro = "generic_metro",
  GenericFerry = "generic_ferry",
  TallElectricBus = "tall_electric_bus",
}

export type InfrastructureLink = {
  infrastructure_link_id: string;
  direction: LinkDirection;
  shape: GeometryObject;
  estimated_length_in_metres: number;
  external_link_source: string;
  external_link_id: string;
};
export const InfrastructureLinkProps: PropArray = [
  "infrastructure_link_id",
  "direction",
  { propName: "shape", isGeoProp: true },
  "estimated_length_in_metres",
  "external_link_source",
  "external_link_id",
];

export type VehicleSubmodeOnInfrastructureLink = {
  infrastructure_link_id: string;
  vehicle_submode: VehicleSubmode;
};
export const VehicleSubmodeOnInfrastructureLinkProps: PropArray = [
  "infrastructure_link_id",
  "vehicle_submode",
];

export type ScheduledStopPoint = {
  scheduled_stop_point_id: string;
  located_on_infrastructure_link_id: string;
  direction: LinkDirection;
  measured_location: GeometryObject;
  label: string;
  priority: number;
  validity_start: Date | null;
  validity_end: Date | null;
};
export const ScheduledStopPointProps: PropArray = [
  "scheduled_stop_point_id",
  "located_on_infrastructure_link_id",
  "direction",
  { propName: "measured_location", isGeoProp: true },
  "label",
  "priority",
  "validity_start",
  "validity_end",
];

export type VehicleModeOnScheduledStopPoint = {
  scheduled_stop_point_id: string;
  vehicle_mode: VehicleMode;
};
export const VehicleModeOnScheduledStopPointProps: PropArray = [
  "scheduled_stop_point_id",
  "vehicle_mode",
];

export type Route = {
  route_id: string;
  on_line_id: string;
  description_i18n: string;
  starts_from_scheduled_stop_point_id: string;
  ends_at_scheduled_stop_point_id: string;
  label: string;
  direction: RouteDirection;
  priority: number;
  validity_start: Date | null;
  validity_end: Date | null;
};
export const RouteProps: PropArray = [
  "route_id",
  "on_line_id",
  "description_i18n",
  "starts_from_scheduled_stop_point_id",
  "ends_at_scheduled_stop_point_id",
  "label",
  "direction",
  "priority",
  "validity_start",
  "validity_end",
];

export type InfrastructureLinkAlongRoute = {
  route_id: string;
  infrastructure_link_id: string;
  infrastructure_link_sequence: number;
  is_traversal_forwards: boolean;
};
export const InfrastructureLinkAlongRouteProps: PropArray = [
  "route_id",
  "infrastructure_link_id",
  "infrastructure_link_sequence",
  "is_traversal_forwards",
];

export type Line = {
  line_id: string;
  name_i18n: string;
  short_name_i18n: string | null;
  description_i18n: string | null;
  primary_vehicle_mode: VehicleMode;
  label: string;
  priority: number;
  validity_start: Date | null;
  validity_end: Date | null;
};
export const LineProps: PropArray = [
  "line_id",
  "name_i18n",
  "short_name_i18n",
  "description_i18n",
  "primary_vehicle_mode",
  "label",
  "priority",
  "validity_start",
  "validity_end",
];
