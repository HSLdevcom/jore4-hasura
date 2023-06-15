import {
  defaultDayTypeIds,
  journeyPatternRefsByName,
} from 'generic/timetablesdb/datasets/defaultSetup';
import { TimetablePriority } from 'generic/timetablesdb/datasets/types';
import { DateTime } from 'luxon';
import { TimetablesDataset } from 'timetables-data-inserter';
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

export const specialAprilFools2023Timetable: TimetablesDataset = {
  // TODO:
  // - remove DateTime.fromISO calls
  // - pass priority as String
  // - pass day_type_id as String
  // - autogenerate ids
  // - pass journey patterns by name
  _vehicle_schedule_frame: {
    vehicle_schedule_frame_id: '9142d422-31c8-40b6-8c76-fcaabd004818',
    // validity_start: DateTime.fromISO('2023-04-01'),
    // validity_end: DateTime.fromISO('2023-04-01'),
    priority: TimetablePriority.Special,
    name: 'Aprillipäivä 2023',
    // created_at: DateTime.fromISO('2022-02-01T02:34:56.789+02:00'),

    _vehicle_service: {
      vehicle_service_id: 'b7de19ec-e336-45e9-a94b-fcd86f7c6512',
      day_type_id: defaultDayTypeIds.SATURDAY,

      _block: {
        block_id: '9c29207d-1dec-44c2-976a-292e6bd9f9dc',

        _vehicle_journeys: [
          {
            vehicle_journey_id: 'cc0ca525-eb96-462e-9658-35cd91eaa17a',
            _journey_pattern_ref_name: 'route123Inbound',

            _passing_times: [
              {
                arrival_time: null,
                departure_time: 'PT7H5M',
                _scheduled_stop_point_label: 'H2201',
              },
              {
                arrival_time: 'PT7H15M',
                departure_time: 'PT7H15M',
                _scheduled_stop_point_label: 'H2202',
              },
              {
                arrival_time: 'PT7H22M',
                departure_time: 'PT7H22M',
                _scheduled_stop_point_label: 'H2203',
              },
              {
                arrival_time: 'PT7H27M',
                departure_time: null,
                _scheduled_stop_point_label: 'H2204',
              },
            ],
          },
          {
            vehicle_journey_id: '5fcabadd-ee62-4455-904b-c652c14b57f0',
            _journey_pattern_ref_name: 'route123Outbound',

            _passing_times: [
              {
                arrival_time: null,
                departure_time: 'PT7H5M',
                _scheduled_stop_point_label: 'H2201',
              },
              {
                arrival_time: 'PT7H15M',
                departure_time: 'PT7H15M',
                _scheduled_stop_point_label: 'H2202',
              },
              {
                arrival_time: 'PT7H19M',
                departure_time: 'PT7H19M',
                _scheduled_stop_point_label: 'H2203',
              },
              {
                arrival_time: 'PT7H25M',
                departure_time: null,
                _scheduled_stop_point_label: 'H2204',
              },
            ],
          },
        ],
      },
    },
  },
  _journey_pattern_refs_by_name: {
    route123Outbound: {
      journey_pattern_ref_id:
        journeyPatternRefsByName.route123Outbound.journey_pattern_ref_id,

      _stop_points: [
        {
          scheduled_stop_point_sequence: 1,
          scheduled_stop_point_label: 'H2201',
        },
        {
          scheduled_stop_point_sequence: 2,
          scheduled_stop_point_label: 'H2202',
        },
        {
          scheduled_stop_point_sequence: 3,
          scheduled_stop_point_label: 'H2203',
        },
        {
          scheduled_stop_point_sequence: 4,
          scheduled_stop_point_label: 'H2204',
        },
      ],
    },
    route123Inbound: {
      journey_pattern_ref_id:
        journeyPatternRefsByName.route123Inbound.journey_pattern_ref_id,

      _stop_points: [
        {
          scheduled_stop_point_sequence: 1,
          scheduled_stop_point_label: 'H2204',
        },
        {
          scheduled_stop_point_sequence: 2,
          scheduled_stop_point_label: 'H2203',
        },
        {
          scheduled_stop_point_sequence: 3,
          scheduled_stop_point_label: 'H2202',
        },
        {
          scheduled_stop_point_sequence: 4,
          scheduled_stop_point_label: 'H2201',
        },
      ],
    },
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
