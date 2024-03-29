import { DateTime, Duration } from 'luxon';

export type UUID = string;

export enum TimetablePriority {
  Standard = 10, // used for "normal" in-use entities
  Temporary = 20, // overrides Standard, used for temporary adjustments
  SubstituteOperatingDayByLineType = 23, // overrides standard and temporary
  Special = 25, // special day that overrides Standard and Temporary
  Draft = 30, // overrides Special, Temporary and Standard, not visible to external systems
  Staging = 40, // imported from Hastus, not in use until priority is changed
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

export type VehicleScheduleFrame = {
  vehicle_schedule_frame_id: UUID;
  label: string;
  name_i18n: LocalizedString;
  validity_start: DateTime;
  validity_end: DateTime;
  priority: TimetablePriority;
  created_at?: DateTime;
};

export const vehicleScheduleFrameProps: Property[] = [
  'vehicle_schedule_frame_id',
  'label',
  'name_i18n',
  'validity_start',
  'validity_end',
  'priority',
  'created_at',
];

export type VehicleService = {
  vehicle_service_id: UUID;
  day_type_id: UUID;
  vehicle_schedule_frame_id: UUID;
};

export const vehicleServiceProps: Property[] = [
  'vehicle_service_id',
  'day_type_id',
  'vehicle_schedule_frame_id',
];

export type JourneyPatternsInVehicleService = {
  vehicle_service_id: UUID;
  journey_pattern_id: UUID;
  reference_count: number;
};

export const journeyPatternsInVehicleServiceProps: Property[] = [
  'vehicle_service_id',
  'journey_pattern_id',
  'reference_count',
];

export type VehicleServiceBlock = {
  block_id: UUID;
  vehicle_service_id: UUID;
  preparing_time: Duration | null;
  finishing_time: Duration | null;
};

export const vehicleServiceBlockProps: Property[] = [
  'block_id',
  'vehicle_service_id',
  'preparing_time',
  'finishing_time',
];

export type VehicleJourney = {
  vehicle_journey_id: UUID;
  block_id: UUID;
  journey_pattern_ref_id: UUID;
  turnaround_time: Duration | null;
  layover_time: Duration | null;
};

export const vehicleJourneyProps: Property[] = [
  'vehicle_journey_id',
  'block_id',
  'journey_pattern_ref_id',
  'turnaround_time',
  'layover_time',
];

export type TimetabledPassingTime = {
  timetabled_passing_time_id: UUID;
  arrival_time: Duration | null;
  departure_time: Duration | null;
  vehicle_journey_id: UUID;
  scheduled_stop_point_in_journey_pattern_ref_id: UUID;
};

export const timetabledPassingTimeProps: Property[] = [
  'timetabled_passing_time_id',
  'arrival_time',
  'departure_time',
  'vehicle_journey_id',
  'scheduled_stop_point_in_journey_pattern_ref_id',
];

export type ScheduledStopInJourneyPatternRef = {
  scheduled_stop_point_in_journey_pattern_ref_id: UUID;
  scheduled_stop_point_label: string;
  scheduled_stop_point_sequence: number;
  timing_place_label: string | null;
  journey_pattern_ref_id: UUID;
};

export const scheduledStopInJourneyPatternRefProps: Property[] = [
  'scheduled_stop_point_in_journey_pattern_ref_id',
  'scheduled_stop_point_label',
  'scheduled_stop_point_sequence',
  'timing_place_label',
  'journey_pattern_ref_id',
];

export type JourneyPatternRef = {
  journey_pattern_ref_id: UUID;
  observation_timestamp: DateTime;
  snapshot_timestamp: DateTime;
  journey_pattern_id: UUID;
  type_of_line: TypeOfLine;
  route_label: string;
  route_direction: RouteDirection;
  route_validity_start: DateTime | null;
  route_validity_end: DateTime | null;
};

export const journeyPatternRefProps: Property[] = [
  'journey_pattern_ref_id',
  'observation_timestamp',
  'snapshot_timestamp',
  'journey_pattern_id',
  'type_of_line',
  'route_label',
  'route_direction',
  'route_validity_start',
  'route_validity_end',
];
