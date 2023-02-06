import { vehicleScheduleFrameProps } from './types';

export const genericTimetablesDbTables = [
  'vehicle_schedule.vehicle_schedule_frame',
] as const;
export type GenericTimetablesDbTables =
  (typeof genericTimetablesDbTables)[number];

export const genericTimetablesDbSchema: TableSchemaMap<GenericTimetablesDbTables> =
  {
    'vehicle_schedule.vehicle_schedule_frame': {
      name: 'vehicle_schedule.vehicle_schedule_frame',
      props: vehicleScheduleFrameProps,
    },
  };
