import { journeyPatternRefsByName } from 'generic/timetablesdb/datasets/defaultSetup';
import { TimetablePriority } from 'generic/timetablesdb/datasets/types';
import { DateTime } from 'luxon';
import { defaultDayTypeIds } from '../../../../../timetables-data-inserter/day-types';
import { buildHslVehicleScheduleFrame } from '../../factories';
import { HslTimetablesDbTables } from '../../schema';

export const draftSunApril2024VehicleScheduleFrame = {
  ...buildHslVehicleScheduleFrame({
    vehicle_schedule_frame_id: '2a784a4c-b0bc-44c0-be9d-c8cea8915e73',
    validity_start: DateTime.fromISO('2024-04-01'),
    validity_end: DateTime.fromISO('2024-04-30'),
    priority: TimetablePriority.Draft,
    name: 'Huhtikuun luonnos sunnuntait 2024',
    created_at: DateTime.fromISO('2021-01-01T02:34:56.789+02:00'),
  }),
};

export const draftSunApril2024VehicleService = {
  vehicle_service_id: 'fd7eb647-750c-4216-b2fa-a957525b7cfa',
  day_type_id: defaultDayTypeIds.SUNDAY,
  vehicle_schedule_frame_id:
    draftSunApril2024VehicleScheduleFrame.vehicle_schedule_frame_id,
};

export const draftSunApril2024VehicleServiceBlock = {
  block_id: '52718fb2-edff-4cb3-b8ce-2cb2fe90600a',
  vehicle_service_id: draftSunApril2024VehicleService.vehicle_service_id,
};

export const draftSunApril2024VehicleJourneysByName = {
  v1journey1: {
    vehicle_journey_id: '773efcf2-11d9-4e1b-b84b-8d9200abd096',
    block_id: draftSunApril2024VehicleServiceBlock.block_id,
    journey_pattern_ref_id:
      journeyPatternRefsByName.route123Inbound.journey_pattern_ref_id,
  },
  v1journey2: {
    vehicle_journey_id: '33dea211-92e4-4fdc-a82b-57d91518dd38',
    block_id: draftSunApril2024VehicleServiceBlock.block_id,
    journey_pattern_ref_id:
      journeyPatternRefsByName.route123Outbound.journey_pattern_ref_id,
  },
};

export const draftSunApril2024Dataset: TableData<HslTimetablesDbTables>[] = [
  {
    name: 'vehicle_schedule.vehicle_schedule_frame',
    data: [draftSunApril2024VehicleScheduleFrame],
  },
  {
    name: 'vehicle_service.vehicle_service',
    data: [draftSunApril2024VehicleService],
  },
  {
    name: 'vehicle_service.block',
    data: [draftSunApril2024VehicleServiceBlock],
  },
  {
    name: 'vehicle_journey.vehicle_journey',
    data: [...Object.values(draftSunApril2024VehicleJourneysByName)],
  },
];

export const draftSunApril2024Timetable = {
  _vehicle_schedule_frames: {
    draftSunApril2024: {
      validity_start: DateTime.fromISO('2024-04-01'),
      validity_end: DateTime.fromISO('2024-04-30'),
      priority: TimetablePriority.Draft,
      name: 'Huhtikuun luonnos sunnuntait 2024',
      created_at: DateTime.fromISO('2021-01-01T02:34:56.789+02:00'),
      _vehicle_services: {
        sun: {
          day_type_id: defaultDayTypeIds.SUNDAY,
          _blocks: {
            block: {
              _vehicle_journeys: {
                draftSunApril2024_123Outbound: {
                  _journey_pattern_ref_name: 'route123Outbound',
                },
                draftSunApril2024_123Inbound: {
                  _journey_pattern_ref_name: 'route123Inbound',
                },
              },
            },
          },
        },
      },
    },
  },
};
