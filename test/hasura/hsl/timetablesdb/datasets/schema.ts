import {
  genericTimetablesDbSchema,
  genericTimetablesDbTables,
} from 'generic/timetablesdb/datasets/schema';
import {
  SubstituteOperatingPeriodProps,
  hslVehicleJourneyProps,
  hslVehicleScheduleFrameProps,
  substituteOperatingDayByLineTypeProps,
} from './types';

export const hslTimetablesDbTables = [
  ...genericTimetablesDbTables,
  'timetables.substitute_operating_day_by_line_type',
  'timetables.substitute_operating_period',
] as const;
export type HslTimetablesDbTables = (typeof hslTimetablesDbTables)[number];

export const hslTimetablesDbSchema: TableSchemaMap<HslTimetablesDbTables> = {
  ...genericTimetablesDbSchema,
  'timetables.vehicle_schedule_frame': {
    name: 'timetables.vehicle_schedule_frame',
    props: hslVehicleScheduleFrameProps,
  },
  'timetables.substitute_operating_day_by_line_type': {
    name: 'timetables.substitute_operating_day_by_line_type',
    props: substituteOperatingDayByLineTypeProps,
  },
  'timetables.substitute_operating_period': {
    name: 'timetables.substitute_operating_period',
    props: SubstituteOperatingPeriodProps,
  },
  'timetables.vehicle_journey': {
    name: 'timetables.vehicle_journey',
    props: hslVehicleJourneyProps,
  },
};
