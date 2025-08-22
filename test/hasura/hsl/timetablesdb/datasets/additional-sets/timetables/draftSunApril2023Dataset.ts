import { DateTime } from 'luxon';
import { journeyPatternRefsByName } from 'generic/timetablesdb/datasets/defaultSetup';
import { TimetablePriority } from 'generic/timetablesdb/datasets/types';
import { defaultDayTypeIds } from '../../../../../timetables-data-inserter/day-types';
import { buildHslVehicleScheduleFrame } from '../../factories';
import { HslTimetablesDbTables } from '../../schema';

export const draftSunApril2023VehicleScheduleFrame = {
  ...buildHslVehicleScheduleFrame({
    vehicle_schedule_frame_id: '410b94d2-7465-44d9-a08f-8a5d1c2400b2',
    validity_start: DateTime.fromISO('2023-04-01'),
    validity_end: DateTime.fromISO('2023-04-30'),
    priority: TimetablePriority.Draft,
    name: 'Huhtikuun luonnos sunnuntait 2023',
    created_at: DateTime.fromISO('2021-01-01T02:34:56.789+02:00'),
  }),
};

export const draftSunApril2023VehicleService = {
  vehicle_service_id: '66f4e1f0-9b41-4e8e-b4b8-82118e4aaa4e',
  day_type_id: defaultDayTypeIds.SUNDAY,
  vehicle_schedule_frame_id:
    draftSunApril2023VehicleScheduleFrame.vehicle_schedule_frame_id,
};

export const draftSunApril2023VehicleServiceBlock = {
  block_id: '73c9fc5d-67b3-4a1a-ba6b-c74051c03066',
  vehicle_service_id: draftSunApril2023VehicleService.vehicle_service_id,
};

export const draftSunApril2023VehicleJourneysByName = {
  v1journey1: {
    vehicle_journey_id: 'b2ebd040-4935-4d73-bdd5-b9aa39d2bb03',
    block_id: draftSunApril2023VehicleServiceBlock.block_id,
    journey_pattern_ref_id:
      journeyPatternRefsByName.route123Inbound.journey_pattern_ref_id,
  },
  v1journey2: {
    vehicle_journey_id: '09ac200a-b7cf-417d-95fd-b83ae9fe3060',
    block_id: draftSunApril2023VehicleServiceBlock.block_id,
    journey_pattern_ref_id:
      journeyPatternRefsByName.route123Outbound.journey_pattern_ref_id,
  },
};

export const draftSunApril2023Dataset: TableData<HslTimetablesDbTables>[] = [
  {
    name: 'vehicle_schedule.vehicle_schedule_frame',
    data: [draftSunApril2023VehicleScheduleFrame],
  },
  {
    name: 'vehicle_service.vehicle_service',
    data: [draftSunApril2023VehicleService],
  },
  {
    name: 'vehicle_service.block',
    data: [draftSunApril2023VehicleServiceBlock],
  },
  {
    name: 'vehicle_journey.vehicle_journey',
    data: [...Object.values(draftSunApril2023VehicleJourneysByName)],
  },
];

export const draftSunApril2023Timetable = {
  _vehicle_schedule_frames: {
    draftSunApril2023: {
      validity_start: DateTime.fromISO('2023-04-01'),
      validity_end: DateTime.fromISO('2023-04-30'),
      priority: TimetablePriority.Draft,
      name: 'Huhtikuun luonnos sunnuntait 2023',
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
