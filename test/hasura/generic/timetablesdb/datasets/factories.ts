import { DateTime } from 'luxon';
import { buildLocalizedString } from '@util/dataset';
import { TimetablePriority, VehicleScheduleFrame } from './types';

// can set either name_i18n (-> leave as is) or name (-> make i18n version)
export type EntityName =
  | { name?: never; name_i18n: LocalizedString }
  | { name: string; name_i18n?: never };

/**
 * Builds the name for the entity if the i18n attribute is not set
 */
export const buildName = <TEntity extends EntityName>(
  entityWithName: TEntity,
) => entityWithName.name_i18n || buildLocalizedString(entityWithName.name);

export const buildVehicleScheduleFrame = (
  frame: RequiredKeys<
    Partial<VehicleScheduleFrame>,
    'vehicle_schedule_frame_id'
  > &
    EntityName,
) => {
  const vehicleFrame = {
    validity_start: DateTime.fromISO('2020-01-01'),
    validity_end: DateTime.fromISO('2050-12-31'),
    priority: TimetablePriority.Standard,
    label: buildName(frame).fi_FI,
    ...frame,
    name_i18n: buildName(frame),
  };
  // remove the dangling 'name' attribute as it causes issues when inserting it to database
  delete vehicleFrame.name;
  return vehicleFrame;
};
