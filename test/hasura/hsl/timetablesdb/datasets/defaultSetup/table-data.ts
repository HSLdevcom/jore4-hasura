import { mergeLists } from '@util/schema';
import { defaultGenericTimetablesDbData } from 'generic/timetablesdb/datasets/defaultSetup';
import { HslTimetablesDbTables } from '../schema';
import { substituteOperatingDayByLineTypes } from './substitute-operating-day-by-line-types';
import { substituteOperatingPeriod } from './substitute_operating_period';
import { hslVehicleJourneys } from './vehicle-journeys';
import { hslVehicleScheduleFrames } from './vehicle-schedule-frames';
import { hslVehicleServices } from './vehicle-services';
import { hslVehicleServiceBlocks } from './vehicle-services-blocks';

export const defaultHslTimetablesDbData: TableData<HslTimetablesDbTables>[] = [
  ...mergeLists(
    defaultGenericTimetablesDbData,
    [
      {
        name: 'vehicle_schedule.vehicle_schedule_frame',
        data: hslVehicleScheduleFrames,
      },
      {
        name: 'vehicle_service.vehicle_service',
        data: hslVehicleServices,
      },
      {
        name: 'vehicle_service.block',
        data: hslVehicleServiceBlocks,
      },
      { name: 'vehicle_journey.vehicle_journey', data: hslVehicleJourneys },
    ],
    (tableSchema) => tableSchema.name,
  ),
  {
    name: 'service_calendar.substitute_operating_period',
    data: substituteOperatingPeriod,
  },
  {
    name: 'service_calendar.substitute_operating_day_by_line_type',
    data: substituteOperatingDayByLineTypes,
  },
];
