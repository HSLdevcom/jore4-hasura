import { DateTime } from 'luxon';
import { JourneyPatternRef, TypeOfLine } from '../types';

export const journeyPatternRefsByName = {
  route123Outbound: {
    journey_pattern_ref_id: '9692de39-f356-4ebc-9252-587f5eba8901',
    journey_pattern_id: '55bab728-c76c-4ce6-9cc6-f6e51c1c5dca',
    type_of_line: TypeOfLine.StoppingBusService,
    observation_timestamp: DateTime.fromISO('2023-07-01T00:00:00+00:00'),
    snapshot_timestamp: DateTime.fromISO('2023-09-28T00:00:00+00:00'),
  },
  route123Inbound: {
    journey_pattern_ref_id: 'c19ce33d-7ef8-4af9-be67-340d0b4bf185',
    journey_pattern_id: '34acd9ad-f7c4-4af2-a6d4-f9d69f0288ee',
    type_of_line: TypeOfLine.StoppingBusService,
    observation_timestamp: DateTime.fromISO('2023-07-01T00:00:00+00:00'),
    snapshot_timestamp: DateTime.fromISO('2023-09-28T00:00:00+00:00'),
  },
  route234Outbound: {
    journey_pattern_ref_id: 'a5f7109a-035b-40db-8fa7-796645fb313a',
    journey_pattern_id: 'b080eeed-8982-441e-aba2-16150dd89350',
    type_of_line: TypeOfLine.StoppingBusService,
    observation_timestamp: DateTime.fromISO('2023-07-01T00:00:00+00:00'),
    snapshot_timestamp: DateTime.fromISO('2023-09-28T00:00:00+00:00'),
  },
};
export const journeyPatternRefs: JourneyPatternRef[] = Object.values(
  journeyPatternRefsByName,
);
