import { DateTime } from 'luxon';
import { TimetablePriority } from '../../types';

export const christmas2022VehicleScheduleFrame = {
  validity_start: DateTime.fromISO('2022-12-01'),
  validity_end: DateTime.fromISO('2022-12-31'),
  name: 'Joulu 2022',
  priority: TimetablePriority.Temporary,
  created_at: DateTime.fromISO('2021-02-01T02:34:56.789+02:00'),
};
