import { GeometryObject } from '@util/dataset';

export type PropArray = (
  | string
  | {
      propName: string;
      isGeoProp: boolean;
    }
)[];

export function hasGeoPropSpec<
  ObjType extends PropArray[number],
  PropType extends PropertyKey,
>(obj: ObjType): obj is ObjType & Record<PropType, unknown> {
  return obj.hasOwnProperty('isGeoProp');
}

export enum LinkDirection {
  Forward = 'forward',
  Backward = 'backward',
  BiDirectional = 'bidirectional',
}

export enum RouteDirection {
  Inbound = 'inbound',
  Outbound = 'outbound',
  Clockwise = 'clockwise',
  Anticlockwise = 'anticlockwise',
  Northbound = 'northbound',
  Southbound = 'southbound',
  Eastbound = 'eastbound',
  Westbound = 'westbound',
}

export enum VehicleMode {
  Bus = 'bus',
  Tram = 'tram',
  Train = 'train',
  Metro = 'metro',
  Ferry = 'ferry',
}

export enum VehicleSubmode {
  GenericBus = 'generic_bus',
  GenericTram = 'generic_tram',
  GenericTrain = 'generic_train',
  GenericMetro = 'generic_metro',
  GenericFerry = 'generic_ferry',
  TallElectricBus = 'tall_electric_bus',
}

export enum TypeOfLine {
  RegionalRailService = 'regional_rail_service',
  SuburbanRailway = 'suburban_railway',
  MetroService = 'metro_service',
  RegionalBusService = 'regional_bus_service',
  ExpressBusService = 'express_bus_service',
  StoppingBusService = 'stopping_bus_service',
  SpecialNeedsBus = 'special_needs_bus',
  DemandAndResponseBusService = 'demand_and_response_bus_service',
  CityTramService = 'city_tram_service',
  RegionalTramService = 'regional_tram_service',
  FerryService = 'ferry_service',
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
  'infrastructure_link_id',
  'direction',
  { propName: 'shape', isGeoProp: true },
  'estimated_length_in_metres',
  'external_link_source',
  'external_link_id',
];

export type VehicleSubmodeOnInfrastructureLink = {
  infrastructure_link_id: string;
  vehicle_submode: VehicleSubmode;
};
export const VehicleSubmodeOnInfrastructureLinkProps: PropArray = [
  'infrastructure_link_id',
  'vehicle_submode',
];

export type ScheduledStopPointInvariant = {
  label: string;
};
export const ScheduledStopPointInvariantProps: PropArray = ['label'];

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
  'scheduled_stop_point_id',
  'located_on_infrastructure_link_id',
  'direction',
  { propName: 'measured_location', isGeoProp: true },
  'label',
  'priority',
  'validity_start',
  'validity_end',
];

export type VehicleModeOnScheduledStopPoint = {
  scheduled_stop_point_id: string;
  vehicle_mode: VehicleMode;
};
export const VehicleModeOnScheduledStopPointProps: PropArray = [
  'scheduled_stop_point_id',
  'vehicle_mode',
];

export type Languages = 'fi_FI' | 'sv_FI';

export type LocalizedString = {
  [index in Languages]: string;
};

export type Route = {
  route_id: string;
  on_line_id: string;
  name_i18n: LocalizedString;
  description_i18n: LocalizedString | null;
  origin_name_i18n: LocalizedString;
  origin_short_name_i18n: LocalizedString;
  destination_name_i18n: LocalizedString;
  destination_short_name_i18n: LocalizedString;
  label: string;
  direction: RouteDirection;
  priority: number;
  validity_start: Date | null;
  validity_end: Date | null;
};
export const RouteProps: PropArray = [
  'route_id',
  'on_line_id',
  'name_i18n',
  'description_i18n',
  'origin_name_i18n',
  'origin_short_name_i18n',
  'destination_name_i18n',
  'destination_short_name_i18n',
  'label',
  'direction',
  'priority',
  'validity_start',
  'validity_end',
];

export type InfrastructureLinkAlongRoute = {
  route_id: string;
  infrastructure_link_id: string;
  infrastructure_link_sequence: number;
  is_traversal_forwards: boolean;
};
export const InfrastructureLinkAlongRouteProps: PropArray = [
  'route_id',
  'infrastructure_link_id',
  'infrastructure_link_sequence',
  'is_traversal_forwards',
];

export type Line = {
  line_id: string;
  name_i18n: LocalizedString;
  short_name_i18n: LocalizedString;
  primary_vehicle_mode: VehicleMode;
  label: string;
  type_of_line: TypeOfLine;
  priority: number;
  validity_start: Date | null;
  validity_end: Date | null;
};
export const LineProps: PropArray = [
  'line_id',
  'name_i18n',
  'short_name_i18n',
  'primary_vehicle_mode',
  'label',
  'type_of_line',
  'priority',
  'validity_start',
  'validity_end',
];

export type JourneyPattern = {
  journey_pattern_id: string;
  on_route_id: string;
};
export const JourneyPatternProps: PropArray = [
  'journey_pattern_id',
  'on_route_id',
];

export type ScheduledStopPointInJourneyPattern = {
  journey_pattern_id: string;
  scheduled_stop_point_label: string;
  scheduled_stop_point_sequence: number;
  is_timing_point: boolean;
  is_via_point: boolean;
  via_point_name_i18n?: LocalizedString | null;
  via_point_short_name_i18n?: LocalizedString | null;
};
export const ScheduledStopPointInJourneyPatternProps: PropArray = [
  'journey_pattern_id',
  'scheduled_stop_point_label',
  'scheduled_stop_point_sequence',
  'is_timing_point',
  'is_via_point',
  'via_point_name_i18n',
  'via_point_short_name_i18n',
];

export type CheckInfraLinkStopRefsWithNewScheduledStopPointArgs = {
  replace_scheduled_stop_point_id: string | null;
  new_located_on_infrastructure_link_id: string;
  new_measured_location: GeometryObject;
  new_direction: LinkDirection;
  new_label: string;
  new_validity_start: Date | null;
  new_validity_end: Date | null;
};
