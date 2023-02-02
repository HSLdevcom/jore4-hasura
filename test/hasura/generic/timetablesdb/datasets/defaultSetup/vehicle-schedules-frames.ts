import { LocalDate } from 'local-date';
import { buildVehicleScheduleFrame } from '../factories';
import { TimetablePriority, VehicleScheduleFrame } from '../types';

export const vehicleScheduleFrames: VehicleScheduleFrame[] = [
  buildVehicleScheduleFrame({
    vehicle_schedule_frame_id: 'c8bf942e-94f0-4e0d-bc65-0f301b544d47',
    validity_start: new LocalDate('2022-07-01'),
    validity_end: new LocalDate('2023-05-31'),
    name: 'Talvi 2022',
  }),
  buildVehicleScheduleFrame({
    vehicle_schedule_frame_id: 'c8bf942e-94f0-4e0d-bc65-0f301b544d47',
    validity_start: new LocalDate('2022-12-01'),
    validity_end: new LocalDate('2022-12-31'),
    name: 'Joulu 2022',
    priority: TimetablePriority.Temporary,
  }),
  buildVehicleScheduleFrame({
    vehicle_schedule_frame_id: 'c8bf942e-94f0-4e0d-bc65-0f301b544d47',
    validity_start: new LocalDate('2023-06-01'),
    validity_end: new LocalDate('2023-08-31'),
    name: 'Kesä 2023',
  }),
];
