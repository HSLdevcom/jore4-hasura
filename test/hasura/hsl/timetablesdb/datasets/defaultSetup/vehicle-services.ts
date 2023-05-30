import {
  defaultDayTypeIds,
  vehicleServices,
} from 'generic/timetablesdb/datasets/defaultSetup';
import { VehicleService } from 'generic/timetablesdb/datasets/types';
import { hslVehicleScheduleFramesByName } from './vehicle-schedule-frames';

export const hslVehicleServicesByName = {
  // vehicle 1, Ascension day
  v1Ascension: {
    vehicle_service_id: 'c2eb46b8-2702-433f-9647-9694a62943c0',
    day_type_id: defaultDayTypeIds.THURSDAY,
    vehicle_schedule_frame_id:
      hslVehicleScheduleFramesByName.specialAscensionDay2023
        .vehicle_schedule_frame_id,
  },
};

// TODO: Add more precise conversion to hsl model when needed
export const hslVehicleServices: VehicleService[] = vehicleServices.concat(
  Object.values(hslVehicleServicesByName),
);
