import { DateTime, Duration } from 'luxon';

export type UUID = string;

export enum TimetablePriority {
  Standard = 10, // used for "normal" in-use entities
  Temporary = 20, // overrides Standard, used for temporary adjustments
  Special = 25, // special day that overrides Standard and Temporary
  Draft = 30, // overrides Special, Temporary and Standard, not visible to external systems
  Staging = 40, // imported from Hastus, not in use until priority is changed
}

export type VehicleScheduleFrame = {
  vehicle_schedule_frame_id: UUID;
  label: string;
  name_i18n: LocalizedString;
  validity_start: DateTime | null;
  validity_end: DateTime | null;
  priority: TimetablePriority;
};

export const vehicleScheduleFrameProps: Property[] = [
  'vehicle_schedule_frame_id',
  'label',
  'name_i18n',
  'validity_start',
  'validity_end',
  'priority',
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

export type VehicleServiceBlock = {
  block_id: UUID;
  vehicle_service_id: UUID;
};

export const vehicleServiceBlockProps: Property[] = [
  'block_id',
  'vehicle_service_id',
];

export type VehicleJourney = {
  vehicle_journey_id: UUID;
  block_id: UUID;
  journey_pattern_ref_id: UUID;
};

export const vehicleJourneyProps: Property[] = [
  'vehicle_journey_id',
  'block_id',
  'journey_pattern_ref_id',
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
  journey_pattern_ref_id: UUID;
};

export const scheduledStopInJourneyPatternRefProps: Property[] = [
  'scheduled_stop_point_in_journey_pattern_ref_id',
  'scheduled_stop_point_label',
  'scheduled_stop_point_sequence',
  'journey_pattern_ref_id',
];

export type JourneyPatternRef = {
  journey_pattern_ref_id: UUID;
  observation_timestamp: DateTime;
  snapshot_timestamp: DateTime;
  journey_pattern_id: UUID;
};

export const journeyPatternRefProps: Property[] = [
  'journey_pattern_ref_id',
  'observation_timestamp',
  'snapshot_timestamp',
  'journey_pattern_id',
];
