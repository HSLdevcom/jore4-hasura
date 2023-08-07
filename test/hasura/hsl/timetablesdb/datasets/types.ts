import {
  TimetablePriority,
  TypeOfLine,
  VehicleScheduleFrame,
  vehicleScheduleFrameProps,
} from 'generic/timetablesdb/datasets/types';
import { DateTime, Duration } from 'luxon';

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
];

export type SubstituteOperatingDayByLineType = {
  substitute_operating_day_by_line_type_id: UUID;
  type_of_line: TypeOfLine;
  superseded_date: DateTime;
  substitute_day_of_week?: DayOfWeek | null;
  begin_time?: Duration | null;
  end_time?: Duration | null;
  timezone?: string;
  begin_datetime?: DateTime;
  end_datetime?: DateTime;
};

export type TimetableVersion = {
  vehicle_schedule_frame_id: UUID | null;
  substitute_operating_day_by_line_type_id: UUID | null;
  in_effect: boolean;
  priority: TimetablePriority;
  day_type_id: UUID;
  validity_start: DateTime;
  validity_end: DateTime;
};

export type VehicleSchedule = {
  vehicle_journey_id: UUID | null;
  vehicle_schedule_frame_id: UUID | null;
  substitute_operating_day_by_line_type_id: UUID | null;
  priority: TimetablePriority;
  day_type_id: UUID;
  validity_start: DateTime;
  validity_end: DateTime;
  created_at: DateTime;
};
