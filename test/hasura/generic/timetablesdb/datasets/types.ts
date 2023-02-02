import { LocalDate } from 'local-date';

export type UUID = string;

export type VehicleScheduleFrame = {
  vehicle_schedule_frame_id: UUID;
  name_i18n: LocalizedString;
  validity_start: LocalDate | null;
  validity_end: LocalDate | null;
  priority: number;
};

export const vehicleScheduleFrameProps: Property[] = [
  'vehicle_schedule_frame_id',
  'name_i18n',
  'validity_start',
  'validity_end',
  'priority',
];
