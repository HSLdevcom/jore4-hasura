import { DateTime } from 'luxon';

export type UUID = string;

export enum TimetablePriority {
  Standard = 10, // used for "normal" in-use entities
  Temporary = 20, // overrides Standard, used for temporary adjustments
  Special = 25, // special day that overrides Standard and Temporary
  Draft = 30, // overrides Special, Temporary and Standard, not visible to external systems
  Staging = 40, // imported from Hastus, not in use until priority is changed
}

export type VehicleScheduleFrame = {
  vehicle_schedule_frame_id: UUID;
  name_i18n: LocalizedString;
  validity_start: DateTime | null;
  validity_end: DateTime | null;
  priority: TimetablePriority;
};

export const vehicleScheduleFrameProps: Property[] = [
  'vehicle_schedule_frame_id',
  'name_i18n',
  'validity_start',
  'validity_end',
  'priority',
];
