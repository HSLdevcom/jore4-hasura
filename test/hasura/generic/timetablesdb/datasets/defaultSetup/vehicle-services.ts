import { VehicleService } from '../types';
import { defaultDayTypeIds } from './day-types';
import { vehicleScheduleFramesByName } from './vehicle-schedules-frames';

export const vehicleServicesByName = {
  // vehicle 1, Mon-Fri
  v1MonFri: {
    vehicle_service_id: 'b97684d1-e5cc-4c8a-959d-cc7461c60225',
    day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
    vehicle_schedule_frame_id:
      vehicleScheduleFramesByName.winter2022.vehicle_schedule_frame_id,
  },
  // vehicle 1, Sat
  v1Sat: {
    vehicle_service_id: '46bfd79a-3969-453b-88eb-cb87cf6041ff',
    day_type_id: defaultDayTypeIds.SATURDAY,
    vehicle_schedule_frame_id:
      vehicleScheduleFramesByName.winter2022.vehicle_schedule_frame_id,
  },
  // vehicle 1, Sun
  v1Sun: {
    vehicle_service_id: 'aa638a6e-aeef-4cd2-b7b2-29a0201c60be',
    day_type_id: defaultDayTypeIds.SUNDAY,
    vehicle_schedule_frame_id:
      vehicleScheduleFramesByName.winter2022.vehicle_schedule_frame_id,
  },
};
export const vehicleServices: VehicleService[] = Object.values(
  vehicleServicesByName,
);
