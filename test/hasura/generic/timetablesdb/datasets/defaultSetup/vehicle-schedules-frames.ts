import { DateTime } from 'luxon';
import { buildVehicleScheduleFrame } from '../factories';
import { TimetablePriority, VehicleScheduleFrame } from '../types';

export const vehicleScheduleFrames: VehicleScheduleFrame[] = [
  buildVehicleScheduleFrame({
    vehicle_schedule_frame_id: '792ff598-371b-41dd-8865-3a506f391409',
    validity_start: DateTime.fromISO('2022-07-01'),
    validity_end: DateTime.fromISO('2023-05-31'),
    name: 'Talvi 2022',
  }),
  buildVehicleScheduleFrame({
    vehicle_schedule_frame_id: '511e1060-8018-4f48-b84d-5a9f02ac1149',
    validity_start: DateTime.fromISO('2022-12-01'),
    validity_end: DateTime.fromISO('2022-12-31'),
    name: 'Joulu 2022',
    priority: TimetablePriority.Temporary,
  }),
  buildVehicleScheduleFrame({
    vehicle_schedule_frame_id: '9777bbe4-5220-46a8-bd6e-24a31b0dfe26',
    validity_start: DateTime.fromISO('2023-06-01'),
    validity_end: DateTime.fromISO('2023-08-31'),
    name: 'Kesä 2023',
  }),
];
