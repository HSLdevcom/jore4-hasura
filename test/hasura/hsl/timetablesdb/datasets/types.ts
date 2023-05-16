import {
  TypeOfLine,
  VehicleScheduleFrame,
} from 'generic/timetablesdb/datasets/types';
import { DateTime, Interval } from 'luxon';

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

// TODO: Check the correct types for times
export type SubstituteOperatingDayByLineType = {
  substitute_operating_day_by_line_type_id: UUID;
  type_of_line: TypeOfLine;
  superseded_date: DateTime;
  substitute_day_of_week?: DayOfWeek;
  begin_time?: Interval;
  end_time?: Interval;
  timezone?: string;
  begin_datetime?: DateTime;
  end_datetime?: DateTime;
};
