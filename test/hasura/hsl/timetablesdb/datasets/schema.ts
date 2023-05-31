import {
  genericTimetablesDbSchema,
  genericTimetablesDbTables,
} from 'generic/timetablesdb/datasets/schema';
import {
  SubstituteOperatingPeriodProps,
  substituteOperatingDayByLineTypeProps,
} from './types';

export const hslTimetablesDbTables = [
  ...genericTimetablesDbTables,
  'service_calendar.substitute_operating_day_by_line_type',
  'service_calendar.substitute_operating_period',
] as const;
export type HslTimetablesDbTables = (typeof hslTimetablesDbTables)[number];

export const hslTimetablesDbSchema: TableSchemaMap<HslTimetablesDbTables> = {
  ...genericTimetablesDbSchema,
  'service_calendar.substitute_operating_day_by_line_type': {
    name: 'service_calendar.substitute_operating_day_by_line_type',
    props: substituteOperatingDayByLineTypeProps,
  },
  'service_calendar.substitute_operating_period': {
    name: 'service_calendar.substitute_operating_period',
    props: SubstituteOperatingPeriodProps,
  },
};
