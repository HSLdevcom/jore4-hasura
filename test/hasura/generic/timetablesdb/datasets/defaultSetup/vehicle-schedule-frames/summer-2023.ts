import { parseDateTime } from '@util/time';
import { defaultDayTypeIds } from '../../../../../timetables-data-inserter/day-types';

export const summer2023VehicleScheduleFrame = {
  validity_start: Temporal.PlainDate.from('2023-06-01'),
  validity_end: Temporal.PlainDate.from('2023-08-31'),
  name: 'Kesä 2023',
  created_at: parseDateTime('2022-02-01T02:34:56.789+02:00'),
  _vehicle_services: {
    monFri: {
      day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
      _blocks: {
        block: {
          _vehicle_journeys: {
            route234Outbound: {
              _journey_pattern_ref_name: 'route234Outbound',
              _passing_times: [],
            },
          },
        },
      },
    },
  },
};
