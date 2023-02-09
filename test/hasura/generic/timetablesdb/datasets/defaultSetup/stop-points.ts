// ScheduledStopInJourneyPatternRef = {
//   scheduled_stop_point_in_journey_pattern_ref_id: UUID;
//   scheduled_stop_point_label: string;
//   scheduled_stop_point_sequence: number;
//   journey_pattern_ref_id: UUID;

import { ScheduledStopInJourneyPatternRef } from '../types';
import { journeyPatternRefsByName } from './journey-pattern-refs';

const { route123Outbound, route123Inbound } = journeyPatternRefsByName;

export const scheduledStopPointsInJourneyPatternRefByName: Record<
  string,
  ScheduledStopInJourneyPatternRef
> = {
  route123OutboundStop1: {
    scheduled_stop_point_in_journey_pattern_ref_id:
      '4d31a026-d8b7-4aae-a196-79980bf870cc',
    scheduled_stop_point_sequence: 1,
    scheduled_stop_point_label: 'H2201',
    journey_pattern_ref_id: route123Outbound.journey_pattern_ref_id,
  },
  route123OutboundStop2: {
    scheduled_stop_point_in_journey_pattern_ref_id:
      '4b65bdc7-42c8-4de7-8547-44f92b7dc951',
    scheduled_stop_point_sequence: 2,
    scheduled_stop_point_label: 'H2202',
    journey_pattern_ref_id: route123Outbound.journey_pattern_ref_id,
  },
  route123OutboundStop3: {
    scheduled_stop_point_in_journey_pattern_ref_id:
      '4db8857e-6474-401b-9607-28544e425cf6',
    scheduled_stop_point_sequence: 3,
    scheduled_stop_point_label: 'H2203',
    journey_pattern_ref_id: route123Outbound.journey_pattern_ref_id,
  },
  route123OutboundStop4: {
    scheduled_stop_point_in_journey_pattern_ref_id:
      '7d7b4864-f5d2-46c1-bc88-74068763866c',
    scheduled_stop_point_sequence: 4,
    scheduled_stop_point_label: 'H2204',
    journey_pattern_ref_id: route123Outbound.journey_pattern_ref_id,
  },

  route123InboundStop1: {
    scheduled_stop_point_in_journey_pattern_ref_id:
      'df80aa18-d481-4b06-bfda-9efc5c723331',
    scheduled_stop_point_sequence: 1,
    scheduled_stop_point_label: 'H2204',
    journey_pattern_ref_id: route123Inbound.journey_pattern_ref_id,
  },
  route123InboundStop2: {
    scheduled_stop_point_in_journey_pattern_ref_id:
      '072015f7-5397-4900-b866-fcbb599b1556',
    scheduled_stop_point_sequence: 2,
    scheduled_stop_point_label: 'H2203',
    journey_pattern_ref_id: route123Inbound.journey_pattern_ref_id,
  },
  route123InboundStop3: {
    scheduled_stop_point_in_journey_pattern_ref_id:
      '8fd84d1b-ec31-4b9a-9898-4149542c71d7',
    scheduled_stop_point_sequence: 3,
    scheduled_stop_point_label: 'H2202',
    journey_pattern_ref_id: route123Inbound.journey_pattern_ref_id,
  },
  route123InboundStop4: {
    scheduled_stop_point_in_journey_pattern_ref_id:
      '474d327d-6302-41df-9a8c-c0fb65a97be6',
    scheduled_stop_point_sequence: 4,
    scheduled_stop_point_label: 'H2201',
    journey_pattern_ref_id: route123Inbound.journey_pattern_ref_id,
  },
};
export const scheduledStopPointsInJourneyPatternRef = Object.values(
  scheduledStopPointsInJourneyPatternRefByName,
);
