import {
  defaultDayTypeIds,
  journeyPatternRefsByName,
} from 'generic/timetablesdb/datasets/defaultSetup';
import { TimetablePriority } from 'generic/timetablesdb/datasets/types';
import { DateTime } from 'luxon';
import { buildHslVehicleScheduleFrame } from '../../factories';
import { HslTimetablesDbTables } from '../../schema';

export const temporarySatFirstHalfApril2023VehicleScheduleFrame = {
  ...buildHslVehicleScheduleFrame({
    vehicle_schedule_frame_id: 'f48ac8d9-5ecf-43b4-a6f9-cc14f2627e43',
    validity_start: DateTime.fromISO('2023-04-01'),
    validity_end: DateTime.fromISO('2023-04-15'),
    priority: TimetablePriority.Temporary,
    name: 'Huhtikuun ensimmäisen puoliskon lauantait 2023',
    created_at: DateTime.fromISO('2021-01-01T02:34:56.789+02:00'),
  }),
};

export const temporarySatFirstHalfApril2023VehicleService = {
  vehicle_service_id: 'c2b88679-abbb-4f4f-a6af-90522a24825c',
  day_type_id: defaultDayTypeIds.SATURDAY,
  vehicle_schedule_frame_id:
    temporarySatFirstHalfApril2023VehicleScheduleFrame.vehicle_schedule_frame_id,
};

export const temporarySatFirstHalfApril2023VehicleServiceBlock = {
  block_id: '55ae7f82-b854-4875-bea8-3192e65f78ef',
  vehicle_service_id:
    temporarySatFirstHalfApril2023VehicleService.vehicle_service_id,
};

export const temporarySatFirstHalfApril2023VehicleJourneysByName = {
  v1journey1: {
    vehicle_journey_id: '34827909-ffe2-4e2e-a97d-d586dee6ea08',
    block_id: temporarySatFirstHalfApril2023VehicleServiceBlock.block_id,
    journey_pattern_ref_id:
      journeyPatternRefsByName.route123Inbound.journey_pattern_ref_id,
  },
  v1journey2: {
    vehicle_journey_id: '0a452996-b4ed-479f-9faf-e20b31294fe5',
    block_id: temporarySatFirstHalfApril2023VehicleServiceBlock.block_id,
    journey_pattern_ref_id:
      journeyPatternRefsByName.route123Outbound.journey_pattern_ref_id,
  },
};

export const temporarySatFirstHalfApril2023Dataset: TableData<HslTimetablesDbTables>[] =
  [
    {
      name: 'vehicle_schedule.vehicle_schedule_frame',
      data: [temporarySatFirstHalfApril2023VehicleScheduleFrame],
    },
    {
      name: 'vehicle_service.vehicle_service',
      data: [temporarySatFirstHalfApril2023VehicleService],
    },
    {
      name: 'vehicle_service.block',
      data: [temporarySatFirstHalfApril2023VehicleServiceBlock],
    },
    {
      name: 'vehicle_journey.vehicle_journey',
      data: [
        ...Object.values(temporarySatFirstHalfApril2023VehicleJourneysByName),
      ],
    },
  ];
