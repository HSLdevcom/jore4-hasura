import {
  defaultDayTypeIds,
  journeyPatternRefsByName,
} from 'generic/timetablesdb/datasets/defaultSetup';
import { TimetablePriority } from 'generic/timetablesdb/datasets/types';
import { DateTime } from 'luxon';
import { buildHslVehicleScheduleFrame } from '../../factories';
import { HslTimetablesDbTables } from '../../schema';

export const specialAprilFools2023VehicleScheduleFrame =
  buildHslVehicleScheduleFrame({
    vehicle_schedule_frame_id: '9142d422-31c8-40b6-8c76-fcaabd004818',
    validity_start: DateTime.fromISO('2023-04-01'),
    validity_end: DateTime.fromISO('2023-04-01'),
    priority: TimetablePriority.Special,
    name: 'Aprillipäivä 2023',
    created_at: DateTime.fromISO('2022-02-01T02:34:56.789+02:00'),
  });

export const specialAprilFools2023VehicleService = {
  vehicle_service_id: 'b7de19ec-e336-45e9-a94b-fcd86f7c6512',
  day_type_id: defaultDayTypeIds.SATURDAY,
  vehicle_schedule_frame_id:
    specialAprilFools2023VehicleScheduleFrame.vehicle_schedule_frame_id,
};

export const specialAprilFools2023VehicleServiceBlock = {
  block_id: '9c29207d-1dec-44c2-976a-292e6bd9f9dc',
  vehicle_service_id: specialAprilFools2023VehicleService.vehicle_service_id,
};

export const specialAprilFools2023VehicleJourneysByName = {
  v1journey1: {
    vehicle_journey_id: 'cc0ca525-eb96-462e-9658-35cd91eaa17a',
    block_id: specialAprilFools2023VehicleServiceBlock.block_id,
    journey_pattern_ref_id:
      journeyPatternRefsByName.route123Inbound.journey_pattern_ref_id,
  },
  v1journey2: {
    vehicle_journey_id: '5fcabadd-ee62-4455-904b-c652c14b57f0',
    block_id: specialAprilFools2023VehicleServiceBlock.block_id,
    journey_pattern_ref_id:
      journeyPatternRefsByName.route123Outbound.journey_pattern_ref_id,
  },
};

export const specialAprilFools2023Dataset: TableData<HslTimetablesDbTables>[] =
  [
    {
      name: 'vehicle_schedule.vehicle_schedule_frame',
      data: [specialAprilFools2023VehicleScheduleFrame],
    },
    {
      name: 'vehicle_service.vehicle_service',
      data: [specialAprilFools2023VehicleService],
    },
    {
      name: 'vehicle_service.block',
      data: [specialAprilFools2023VehicleServiceBlock],
    },
    {
      name: 'vehicle_journey.vehicle_journey',
      data: [...Object.values(specialAprilFools2023VehicleJourneysByName)],
    },
  ];

export const specialAprilFools2023Timetable = {
  _vehicle_schedule_frames: {
    aprilFools2023: {
      validity_start: DateTime.fromISO('2023-04-01'),
      validity_end: DateTime.fromISO('2023-04-01'),
      priority: TimetablePriority.Special,
      name: 'Aprillipäivä 2023',
      created_at: DateTime.fromISO('2022-02-01T02:34:56.789+02:00'),

      _vehicle_services: {
        sat: {
          day_type_id: defaultDayTypeIds.SATURDAY,
          _blocks: {
            block: {
              _vehicle_journeys: {
                route123Outbound: {
                  _journey_pattern_ref_name: 'route123Inbound',

                  _passing_times: [],
                },
                route123Inbound: {
                  vehicle_journey_id: '5fcabadd-ee62-4455-904b-c652c14b57f0',
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
