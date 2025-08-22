import { DateTime } from 'luxon';
import { defaultTimetablesDataset as defaultGenericTimetablesDataset } from 'generic/timetablesdb/datasets/defaultSetup/default-timetables-dataset';
import {
  TimetablePriority,
  TypeOfLine,
} from 'generic/timetablesdb/datasets/types';
import { mergeTimetablesDatasets } from 'timetables-data-inserter';
import { defaultDayTypeIds } from '../../../../timetables-data-inserter/day-types';
import { DayOfWeek } from '../types';

const defaultTimetablesDatasetHslAdditions = {
  _vehicle_schedule_frames: {
    specialAscensionDay2023: {
      vehicle_schedule_frame_id: '52c5afdb-9a04-4aed-8769-4bdb761aa6f6',
      validity_start: DateTime.fromISO('2023-05-18'),
      validity_end: DateTime.fromISO('2023-05-18'),
      priority: TimetablePriority.Special,
      name: 'Helatorstai 2023',
      created_at: DateTime.fromISO('2022-02-01T02:34:56.789+02:00'),
      _vehicle_services: {
        thursday: {
          day_type_id: defaultDayTypeIds.THURSDAY,
          _blocks: {
            block: {
              _vehicle_journeys: {
                route123Outbound: {
                  _journey_pattern_ref_name: 'route123Outbound',
                  _passing_times: [],
                },
                route123Inbound: {
                  _journey_pattern_ref_name: 'route123Inbound',
                  _passing_times: [],
                },
              },
            },
          },
        },
      },
    },
  },
  _substitute_operating_periods: {
    aprilFools: {
      period_name: 'AprilFools substitute operating period',
      _substitute_operating_day_by_line_types: {
        aprilFools: {
          type_of_line: TypeOfLine.StoppingBusService,
          superseded_date: DateTime.fromISO('2023-04-01'),
          substitute_day_of_week: DayOfWeek.Friday,
        },
      },
    },
  },
};

const genericDatasetFrameAdditions = {
  _vehicle_schedule_frames: {
    winter2022: {
      _vehicle_services: {
        sat: {
          _blocks: {
            block: {
              _vehicle_journeys: {
                route123Outbound: {
                  _journey_pattern_ref_name: 'route123Outbound',
                  _passing_times: [],
                },
                route123Inbound: {
                  _journey_pattern_ref_name: 'route123Inbound',
                  _passing_times: [],
                },
              },
            },
          },
        },
        sun: {
          _blocks: {
            block: {
              _vehicle_journeys: {
                route123Outbound: {
                  _journey_pattern_ref_name: 'route123Outbound',
                  _passing_times: [],
                },
                route123Inbound: {
                  _journey_pattern_ref_name: 'route123Inbound',
                  _passing_times: [],
                },
              },
            },
          },
        },
      },
    },
  },
};

export const defaultTimetablesDataset = mergeTimetablesDatasets([
  defaultGenericTimetablesDataset,
  genericDatasetFrameAdditions,
  defaultTimetablesDatasetHslAdditions,
]);
