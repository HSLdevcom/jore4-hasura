import { mergeLists } from '@util/schema';
import { defaultGenericTimetablesDbData } from 'generic/timetablesdb/datasets/defaultSetup';
import { HslTimetablesDbTables } from '../schema';
import { substituteOperatingDayByLineTypes } from './substitute-operating-day-by-line-types';
import { hslVehicleScheduleFrames } from './vehicle-schedule-frames';

export const defaultHslTimetablesDbData: TableData<HslTimetablesDbTables>[] = [
  ...mergeLists(
    defaultGenericTimetablesDbData,
    [
      {
        name: 'vehicle_schedule.vehicle_schedule_frame',
        data: hslVehicleScheduleFrames,
      },
    ],
    (tableSchema) => tableSchema.name,
  ),
  {
    name: 'service_calendar.substitute_operating_day_by_line_type',
    data: substituteOperatingDayByLineTypes,
  },
];
