import { mergeLists } from '@util/schema';
import { defaultGenericTimetablesDbData } from 'generic/timetablesdb/datasets/defaultSetup';
import { HslTimetablesDbTables } from '../schema';
import { substituteOperatingDayByLineTypes } from './substitute-operating-day-by-line-types';
import { substituteOperatingPeriod } from './substitute-operating-periods';
import { hslVehicleJourneys } from './vehicle-journeys';
import { hslVehicleScheduleFrames } from './vehicle-schedule-frames';
import { hslVehicleServices } from './vehicle-services';
import { hslVehicleServiceBlocks } from './vehicle-services-blocks';

export const defaultHslTimetablesDbData: TableData<HslTimetablesDbTables>[] = [
  ...mergeLists(
    defaultGenericTimetablesDbData,
    [
      {
        name: 'timetables.vehicle_schedule_frame',
        data: hslVehicleScheduleFrames,
      },
      {
        name: 'timetables.vehicle_service',
        data: hslVehicleServices,
      },
      {
        name: 'timetables.block',
        data: hslVehicleServiceBlocks,
      },
      { name: 'timetables.vehicle_journey', data: hslVehicleJourneys },
    ],
    (tableSchema) => tableSchema.name,
  ),
  {
    name: 'timetables.substitute_operating_period',
    data: substituteOperatingPeriod,
  },
  {
    name: 'timetables.substitute_operating_day_by_line_type',
    data: substituteOperatingDayByLineTypes,
  },
];
