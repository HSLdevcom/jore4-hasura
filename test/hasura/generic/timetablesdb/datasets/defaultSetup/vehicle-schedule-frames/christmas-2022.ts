import { parseDateTime } from '@util/time';
import { TimetablePriority } from '../../types';

export const christmas2022VehicleScheduleFrame = {
  validity_start: Temporal.PlainDate.from('2022-12-01'),
  validity_end: Temporal.PlainDate.from('2022-12-31'),
  name: 'Joulu 2022',
  priority: TimetablePriority.Temporary,
  created_at: parseDateTime('2021-02-01T02:34:56.789+02:00'),
};
