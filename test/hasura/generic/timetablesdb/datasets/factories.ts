import { buildLocalizedString } from '@util/dataset';
import { LocalDate } from 'local-date';
import { TimetablePriority, VehicleScheduleFrame } from './types';

// can set either name_i18n (-> leave as is) or name (-> make i18n version)
type EntityName =
  | { name?: never; name_i18n: LocalizedString }
  | { name: string; name_i18n?: never };

/**
 * Builds the name for the entity if the i18n attribute is not set
 */
const buildName = <TEntity extends EntityName>(entityWithName: TEntity) => {
  const result = {
    ...entityWithName,
    name_i18n:
      entityWithName.name_i18n || buildLocalizedString(entityWithName.name),
  };
  delete result.name;
  return result;
};

export const buildVehicleScheduleFrame = (
  frame: RequiredKeys<
    Partial<VehicleScheduleFrame>,
    'vehicle_schedule_frame_id'
  > &
    EntityName,
) => ({
  validity_start: new LocalDate('2020-01-01'),
  validity_end: new LocalDate('2050-12-31'),
  priority: TimetablePriority.Standard,
  ...buildName(frame),
});
