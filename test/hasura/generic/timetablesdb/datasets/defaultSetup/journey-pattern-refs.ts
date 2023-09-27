import { DateTime } from 'luxon';
import { JourneyPatternRef, RouteDirection, TypeOfLine } from '../types';

export const journeyPatternRefsByName = {
  route123Outbound: {
    journey_pattern_ref_id: '9692de39-f356-4ebc-9252-587f5eba8901',
    journey_pattern_id: '55bab728-c76c-4ce6-9cc6-f6e51c1c5dca',
    observation_timestamp: DateTime.fromISO('2023-07-01T00:00:00+00:00'),
    snapshot_timestamp: DateTime.fromISO('2023-09-28T00:00:00+00:00'),
    type_of_line: TypeOfLine.StoppingBusService,
    route_label: '123',
    route_direction: RouteDirection.Outbound,
    route_validity_start: DateTime.fromISO('2023-06-01T00:00:00+00:00'),
    route_validity_end: DateTime.fromISO('2050-01-01T00:00:00+00:00'),
  },
  route123Inbound: {
    journey_pattern_ref_id: 'c19ce33d-7ef8-4af9-be67-340d0b4bf185',
    journey_pattern_id: '34acd9ad-f7c4-4af2-a6d4-f9d69f0288ee',
    observation_timestamp: DateTime.fromISO('2023-07-01T00:00:00+00:00'),
    snapshot_timestamp: DateTime.fromISO('2023-09-28T00:00:00+00:00'),
    type_of_line: TypeOfLine.StoppingBusService,
    route_label: '123',
    route_direction: RouteDirection.Inbound,
    route_validity_start: DateTime.fromISO('2023-06-01T00:00:00+00:00'),
    route_validity_end: DateTime.fromISO('2050-01-01T00:00:00+00:00'),
  },
  route234Outbound: {
    journey_pattern_ref_id: 'a5f7109a-035b-40db-8fa7-796645fb313a',
    journey_pattern_id: 'b080eeed-8982-441e-aba2-16150dd89350',
    observation_timestamp: DateTime.fromISO('2023-07-01T00:00:00+00:00'),
    snapshot_timestamp: DateTime.fromISO('2023-09-28T00:00:00+00:00'),
    type_of_line: TypeOfLine.StoppingBusService,
    route_label: '234',
    route_direction: RouteDirection.Outbound,
    route_validity_start: DateTime.fromISO('2023-06-01T00:00:00+00:00'),
    route_validity_end: DateTime.fromISO('2050-01-01T00:00:00+00:00'),
  },
};
export const journeyPatternRefs: JourneyPatternRef[] = Object.values(
  journeyPatternRefsByName,
);

// TODO: delete this, replace with defaultJourneyPatternRefsByName.
export const journeyPatternRefsDataset = {
  _journey_pattern_refs: {
    route123Outbound: {
      journey_pattern_id:
        journeyPatternRefsByName.route123Outbound.journey_pattern_id,

      _stop_points: [
        {
          scheduled_stop_point_sequence: 1,
          scheduled_stop_point_label: 'H2201',
          timing_place_label: 'TP001',
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
          timing_place_label: 'TP004',
        },
      ],
    },
    route123Inbound: {
      journey_pattern_id:
        journeyPatternRefsByName.route123Inbound.journey_pattern_id,

      _stop_points: [
        {
          scheduled_stop_point_sequence: 1,
          scheduled_stop_point_label: 'H2204',
          timing_place_label: 'TP004',
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
          timing_place_label: 'TP001',
        },
      ],
    },
  },
};

export const defaultJourneyPatternRefsByName = {
  route123Outbound: {
    journey_pattern_id: '55bab728-c76c-4ce6-9cc6-f6e51c1c5dca',
    observation_timestamp: DateTime.fromISO('2023-07-01T00:00:00+00:00'),
    snapshot_timestamp: DateTime.fromISO('2023-09-28T00:00:00+00:00'),
    type_of_line: TypeOfLine.StoppingBusService,
    route_label: '123',
    route_direction: RouteDirection.Outbound,
    route_validity_start: DateTime.fromISO('2023-06-01T00:00:00+00:00'),
    route_validity_end: DateTime.fromISO('2050-01-01T00:00:00+00:00'),

    _stop_points: [
      {
        scheduled_stop_point_sequence: 1,
        scheduled_stop_point_label: 'H2201',
        timing_place_label: 'TP001',
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
        timing_place_label: 'TP004',
      },
    ],
  },
  route123Inbound: {
    journey_pattern_id: '34acd9ad-f7c4-4af2-a6d4-f9d69f0288ee',
    observation_timestamp: DateTime.fromISO('2023-07-01T00:00:00+00:00'),
    snapshot_timestamp: DateTime.fromISO('2023-09-28T00:00:00+00:00'),
    type_of_line: TypeOfLine.StoppingBusService,
    route_label: '123',
    route_direction: RouteDirection.Inbound,
    route_validity_start: DateTime.fromISO('2023-06-01T00:00:00+00:00'),
    route_validity_end: DateTime.fromISO('2050-01-01T00:00:00+00:00'),

    _stop_points: [
      {
        scheduled_stop_point_sequence: 1,
        scheduled_stop_point_label: 'H2204',
        timing_place_label: 'TP004',
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
        timing_place_label: 'TP001',
      },
    ],
  },

  route234Outbound: {
    journey_pattern_id: 'b080eeed-8982-441e-aba2-16150dd89350',
    observation_timestamp: DateTime.fromISO('2023-07-01T00:00:00+00:00'),
    snapshot_timestamp: DateTime.fromISO('2023-09-28T00:00:00+00:00'),
    type_of_line: TypeOfLine.StoppingBusService,
    route_label: '234',
    route_direction: RouteDirection.Outbound,
    route_validity_start: DateTime.fromISO('2023-06-01T00:00:00+00:00'),
    route_validity_end: DateTime.fromISO('2050-01-01T00:00:00+00:00'),

    _stop_points: [
      {
        scheduled_stop_point_sequence: 1,
        scheduled_stop_point_label: 'H2201',
        timing_place_label: 'TP001',
      },
      {
        scheduled_stop_point_sequence: 2,
        scheduled_stop_point_label: 'H2202',
        timing_place_label: 'TP002',
      },
    ],
  },
};
