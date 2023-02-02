import { GenericTimetablesDbTables } from '../schema';
import { vehicleScheduleFrames } from './vehicle-schedules-frames';

export const defaultGenericTimetablesDbData: TableData<GenericTimetablesDbTables>[] =
  [
    {
      name: 'vehicle_schedule.vehicle_schedule_frame',
      data: vehicleScheduleFrames,
    },
  ];
