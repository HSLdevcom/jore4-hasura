import {
  defaultDayTypeIds,
  journeyPatternRefsByName,
} from 'generic/timetablesdb/datasets/defaultSetup';
import { TimetablePriority } from 'generic/timetablesdb/datasets/types';
import { DateTime } from 'luxon';
import { buildHslVehicleScheduleFrame } from '../../factories';
import { HslTimetablesDbTables } from '../../schema';

export const stagingSunApril2024VehicleScheduleFrame = {
  ...buildHslVehicleScheduleFrame({
    vehicle_schedule_frame_id: '48ca91b8-dfd3-4187-be10-c71ac8b73890',
    validity_start: DateTime.fromISO('2024-04-01'),
    validity_end: DateTime.fromISO('2024-04-30'),
    priority: TimetablePriority.Staging,
    name: 'Huhtikuun (staging) sunnuntait 2024',
    created_at: DateTime.fromISO('2021-01-01T02:34:56.789+02:00'),
  }),
};

export const stagingSunApril2024VehicleService = {
  vehicle_service_id: 'd38dfb0d-ac87-47fa-bea5-60b08b246efe',
  day_type_id: defaultDayTypeIds.SUNDAY,
  vehicle_schedule_frame_id:
    stagingSunApril2024VehicleScheduleFrame.vehicle_schedule_frame_id,
};

export const stagingSunApril2024VehicleServiceBlock = {
  block_id: '29ef6616-e844-47ea-820f-f48330f26732',
  vehicle_service_id: stagingSunApril2024VehicleService.vehicle_service_id,
};

export const stagingSunApril2024VehicleJourneysByName = {
  v1journey1: {
    vehicle_journey_id: '5eb5f451-a415-4497-98b9-e9146175225f',
    block_id: stagingSunApril2024VehicleServiceBlock.block_id,
    journey_pattern_ref_id:
      journeyPatternRefsByName.route123Inbound.journey_pattern_ref_id,
  },
  v1journey2: {
    vehicle_journey_id: '53861267-adf2-47a7-a8ea-671c051e10b0',
    block_id: stagingSunApril2024VehicleServiceBlock.block_id,
    journey_pattern_ref_id:
      journeyPatternRefsByName.route123Outbound.journey_pattern_ref_id,
  },
};

export const stagingSunApril2024Dataset: TableData<HslTimetablesDbTables>[] = [
  {
    name: 'vehicle_schedule.vehicle_schedule_frame',
    data: [stagingSunApril2024VehicleScheduleFrame],
  },
  {
    name: 'vehicle_service.vehicle_service',
    data: [stagingSunApril2024VehicleService],
  },
  {
    name: 'vehicle_service.block',
    data: [stagingSunApril2024VehicleServiceBlock],
  },
  {
    name: 'vehicle_journey.vehicle_journey',
    data: [...Object.values(stagingSunApril2024VehicleJourneysByName)],
  },
];

export const stagingSunApril2024Timetable = {
  _vehicle_schedule_frames: {
    stagingSunApril2024: {
      validity_start: DateTime.fromISO('2024-04-01'),
      validity_end: DateTime.fromISO('2024-04-30'),
      priority: TimetablePriority.Staging,
      name: 'Huhtikuun (staging) sunnuntait 2024',
      created_at: DateTime.fromISO('2021-01-01T02:34:56.789+02:00'),
      _vehicle_services: {
        sun: {
          day_type_id: defaultDayTypeIds.SUNDAY,
          _blocks: {
            block: {
              _vehicle_journeys: {
                route123Inbound: {
                  _journey_pattern_ref_name: 'route123Inbound',
                  _passing_times: [],
                },
                route123Outbound: {
                  _journey_pattern_ref_name: 'route123Outbound',
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
