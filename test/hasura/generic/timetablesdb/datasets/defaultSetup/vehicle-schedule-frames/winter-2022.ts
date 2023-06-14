import { DateTime, Duration } from 'luxon';
import { defaultDayTypeIds } from '../day-types';

export const winter2022VehicleScheduleFrame = {
  validity_start: DateTime.fromISO('2022-07-01'),
  validity_end: DateTime.fromISO('2023-05-31'),
  name: 'Talvi 2022',
  created_at: DateTime.fromISO('2021-01-01T02:34:56.789+02:00'),
  _vehicle_services: {
    monFri: {
      day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
      _blocks: {
        block: {
          _vehicle_journeys: {
            route123Outbound1: {
              _journey_pattern_ref_name: 'route123Outbound',
              _passing_times: [
                {
                  _scheduled_stop_point_label: 'H2201',
                  arrival_time: null,
                  departure_time: Duration.fromISO('PT7H5M'),
                },
                {
                  _scheduled_stop_point_label: 'H2202',
                  arrival_time: Duration.fromISO('PT7H15M'),
                  departure_time: Duration.fromISO('PT7H15M'),
                },
                {
                  _scheduled_stop_point_label: 'H2203',
                  arrival_time: Duration.fromISO('PT7H22M'),
                  departure_time: Duration.fromISO('PT7H22M'),
                },
                {
                  _scheduled_stop_point_label: 'H2204',
                  arrival_time: Duration.fromISO('PT7H27M'),
                  departure_time: null,
                },
              ],
            },
            route123Inbound1: {
              _journey_pattern_ref_name: 'route123Inbound',
              _passing_times: [
                {
                  _scheduled_stop_point_label: 'H2204',
                  arrival_time: null,
                  departure_time: Duration.fromISO('PT7H5M'),
                },
                {
                  _scheduled_stop_point_label: 'H2203',
                  arrival_time: Duration.fromISO('PT7H15M'),
                  departure_time: Duration.fromISO('PT7H15M'),
                },
                {
                  _scheduled_stop_point_label: 'H2202',
                  arrival_time: Duration.fromISO('PT7H19M'),
                  departure_time: Duration.fromISO('PT7H19M'),
                },
                {
                  _scheduled_stop_point_label: 'H2201',
                  arrival_time: Duration.fromISO('PT7H25M'),
                  departure_time: null,
                },
              ],
            },
            route123Outbound2: {
              _journey_pattern_ref_name: 'route123Outbound',
              _passing_times: [
                {
                  _scheduled_stop_point_label: 'H2201',
                  arrival_time: null,
                  departure_time: Duration.fromISO('PT8H5M'),
                },
                {
                  _scheduled_stop_point_label: 'H2202',
                  arrival_time: Duration.fromISO('PT8H15M'),
                  departure_time: Duration.fromISO('PT8H15M'),
                },
                {
                  _scheduled_stop_point_label: 'H2203',
                  arrival_time: Duration.fromISO('PT8H22M'),
                  departure_time: Duration.fromISO('PT8H22M'),
                },
                {
                  _scheduled_stop_point_label: 'H2204',
                  arrival_time: Duration.fromISO('PT8H27M'),
                  departure_time: null,
                },
              ],
            },
            route123Inbound2: {
              _journey_pattern_ref_name: 'route123Inbound',
              _passing_times: [
                {
                  _scheduled_stop_point_label: 'H2204',
                  arrival_time: null,
                  departure_time: Duration.fromISO('PT8H5M'),
                },
                {
                  _scheduled_stop_point_label: 'H2203',
                  arrival_time: Duration.fromISO('PT8H15M'),
                  departure_time: Duration.fromISO('PT8H15M'),
                },
                {
                  _scheduled_stop_point_label: 'H2202',
                  arrival_time: Duration.fromISO('PT8H19M'),
                  departure_time: Duration.fromISO('PT8H19M'),
                },
                {
                  _scheduled_stop_point_label: 'H2201',
                  arrival_time: Duration.fromISO('PT8H25M'),
                  departure_time: null,
                },
              ],
            },
          },
        },
      },
    },
    sat: {
      day_type_id: defaultDayTypeIds.SATURDAY,
      _blocks: {
        block: {
          _vehicle_journeys: {},
        },
      },
    },
    sun: {
      day_type_id: defaultDayTypeIds.SUNDAY,
      _blocks: {
        block: {
          _vehicle_journeys: {},
        },
      },
    },
  },
};
