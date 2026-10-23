import {
  TimetablePriority,
  TypeOfLine,
  VehicleJourney,
  VehicleScheduleFrame,
  vehicleJourneyProps,
  vehicleScheduleFrameProps,
} from 'generic/timetablesdb/datasets/types';

export const hslVehicleScheduleFrameProps: Property[] = [
  ...vehicleScheduleFrameProps,
  'booking_label',
  'booking_description_i18n',
];

export type HslVehicleScheduleFrame = VehicleScheduleFrame & {
  booking_label: string;
  booking_description_i18n?: LocalizedString;
};

export enum DayOfWeek {
  Monday = 1,
  Tuesday = 2,
  Wednesday = 3,
  Thursday = 4,
  Friday = 5,
  Saturday = 6,
  Sunday = 7,
}

export const substituteOperatingDayByLineTypeProps: Property[] = [
  'substitute_operating_day_by_line_type_id',
  'type_of_line',
  'superseded_date',
  'substitute_day_of_week',
  'begin_time',
  'end_time',
  'timezone',
  'begin_datetime',
  'end_datetime',
  'substitute_operating_period_id',
];

export const SubstituteOperatingPeriodProps: Property[] = [
  'substitute_operating_period_id',
  'period_name',
  'is_preset',
];

export type SubstituteOperatingDayByLineType = {
  substitute_operating_day_by_line_type_id: UUID;
  type_of_line: TypeOfLine;
  superseded_date: Temporal.PlainDate;
  substitute_day_of_week?: DayOfWeek | null;
  begin_time?: Temporal.Duration | null;
  end_time?: Temporal.Duration | null;
  timezone?: string;
  begin_datetime?: Temporal.ZonedDateTime;
  end_datetime?: Temporal.ZonedDateTime;
  substitute_operating_period_id: UUID;
};

export type TimetableVersion = {
  vehicle_schedule_frame_id: UUID | null;
  substitute_operating_day_by_line_type_id: UUID | null;
  in_effect: boolean;
  priority: TimetablePriority;
  day_type_id: UUID;
  validity_start: Temporal.PlainDate;
  validity_end: Temporal.PlainDate;
};

export type VehicleSchedule = {
  vehicle_journey_id: UUID | null;
  vehicle_schedule_frame_id: UUID | null;
  substitute_operating_day_by_line_type_id: UUID | null;
  priority: TimetablePriority;
  day_type_id: UUID;
  validity_start: Temporal.PlainDate;
  validity_end: Temporal.PlainDate;
  created_at: Temporal.ZonedDateTime;
};

export type SubstituteOperatingPeriod = {
  substitute_operating_period_id: UUID;
  period_name: string;
  is_preset: boolean;
};

export const hslVehicleJourneyProps: Property[] = [
  ...vehicleJourneyProps,
  'contract_number',
];

export type HslVehicleJourney = VehicleJourney & {
  contract_number: string;
};
