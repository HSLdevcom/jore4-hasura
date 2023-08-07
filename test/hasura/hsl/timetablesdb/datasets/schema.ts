import {
  genericTimetablesDbSchema,
  genericTimetablesDbTables,
} from 'generic/timetablesdb/datasets/schema';
import {
  hslVehicleScheduleFrameProps,
  substituteOperatingDayByLineTypeProps,
} from './types';

export const hslTimetablesDbTables = [
  ...genericTimetablesDbTables,
  'service_calendar.substitute_operating_day_by_line_type',
] as const;
export type HslTimetablesDbTables = (typeof hslTimetablesDbTables)[number];

export const hslTimetablesDbSchema: TableSchemaMap<HslTimetablesDbTables> = {
  ...genericTimetablesDbSchema,
  'vehicle_schedule.vehicle_schedule_frame': {
    name: 'vehicle_schedule.vehicle_schedule_frame',
    props: hslVehicleScheduleFrameProps,
  },
  'service_calendar.substitute_operating_day_by_line_type': {
    name: 'service_calendar.substitute_operating_day_by_line_type',
    props: substituteOperatingDayByLineTypeProps,
  },
};
