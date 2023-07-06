import { Duration } from 'luxon';
import { TimetabledPassingTime } from '../types';
import { scheduledStopPointsInJourneyPatternRefByName } from './stop-points';
import { vehicleJourneysByName } from './vehicle-journeys';

export const timetabledPassingTimesByName = {
  // Journey 1, outbound.
  v1MonFriJourney1Stop1: {
    timetabled_passing_time_id: 'd39fd0a9-b05f-4389-a392-90e1610eda87',
    arrival_time: null,
    departure_time: Duration.fromISO('PT7H5M'),
    vehicle_journey_id:
      vehicleJourneysByName.v1MonFriJourney1.vehicle_journey_id,
    scheduled_stop_point_in_journey_pattern_ref_id:
      scheduledStopPointsInJourneyPatternRefByName.route123OutboundStop1
        .scheduled_stop_point_in_journey_pattern_ref_id,
  },
  v1MonFriJourney1Stop2: {
    timetabled_passing_time_id: '2d5994d2-2e21-4e3c-a74f-ca46df6eb4a6',
    arrival_time: Duration.fromISO('PT7H15M'),
    departure_time: Duration.fromISO('PT7H15M'),
    vehicle_journey_id:
      vehicleJourneysByName.v1MonFriJourney1.vehicle_journey_id,
    scheduled_stop_point_in_journey_pattern_ref_id:
      scheduledStopPointsInJourneyPatternRefByName.route123OutboundStop2
        .scheduled_stop_point_in_journey_pattern_ref_id,
  },
  v1MonFriJourney1Stop3: {
    timetabled_passing_time_id: 'a55438ce-766a-4d31-a599-34ef717f0b7d',
    arrival_time: Duration.fromISO('PT7H22M'),
    departure_time: Duration.fromISO('PT7H22M'),
    vehicle_journey_id:
      vehicleJourneysByName.v1MonFriJourney1.vehicle_journey_id,
    scheduled_stop_point_in_journey_pattern_ref_id:
      scheduledStopPointsInJourneyPatternRefByName.route123OutboundStop3
        .scheduled_stop_point_in_journey_pattern_ref_id,
  },
  v1MonFriJourney1Stop4: {
    timetabled_passing_time_id: '6c5795ac-c7d4-47bc-88da-1d56f7f1d40e',
    arrival_time: Duration.fromISO('PT7H27M'),
    departure_time: null,
    vehicle_journey_id:
      vehicleJourneysByName.v1MonFriJourney1.vehicle_journey_id,
    scheduled_stop_point_in_journey_pattern_ref_id:
      scheduledStopPointsInJourneyPatternRefByName.route123OutboundStop4
        .scheduled_stop_point_in_journey_pattern_ref_id,
  },
  // Journey 2, inbound.
  v1MonFriJourney2Stop1: {
    timetabled_passing_time_id: 'fadf979b-f258-418d-9084-d65cecfefa50',
    arrival_time: null,
    departure_time: Duration.fromISO('PT7H5M'),
    vehicle_journey_id:
      vehicleJourneysByName.v1MonFriJourney2.vehicle_journey_id,
    scheduled_stop_point_in_journey_pattern_ref_id:
      scheduledStopPointsInJourneyPatternRefByName.route123InboundStop1
        .scheduled_stop_point_in_journey_pattern_ref_id,
  },
  v1MonFriJourney2Stop2: {
    timetabled_passing_time_id: '1ee02695-3c91-48a3-a235-6b86dfef0145',
    arrival_time: Duration.fromISO('PT7H15M'),
    departure_time: Duration.fromISO('PT7H15M'),
    vehicle_journey_id:
      vehicleJourneysByName.v1MonFriJourney2.vehicle_journey_id,
    scheduled_stop_point_in_journey_pattern_ref_id:
      scheduledStopPointsInJourneyPatternRefByName.route123InboundStop2
        .scheduled_stop_point_in_journey_pattern_ref_id,
  },
  v1MonFriJourney2Stop3: {
    timetabled_passing_time_id: 'adccf185-045e-4a1f-b5cf-be638789f82c',
    arrival_time: Duration.fromISO('PT7H19M'),
    departure_time: Duration.fromISO('PT7H19M'),
    vehicle_journey_id:
      vehicleJourneysByName.v1MonFriJourney2.vehicle_journey_id,
    scheduled_stop_point_in_journey_pattern_ref_id:
      scheduledStopPointsInJourneyPatternRefByName.route123InboundStop3
        .scheduled_stop_point_in_journey_pattern_ref_id,
  },
  v1MonFriJourney2Stop4: {
    timetabled_passing_time_id: 'ae7e9200-7818-4cb5-b1f2-ace8a676b71b',
    arrival_time: Duration.fromISO('PT7H25M'),
    departure_time: null,
    vehicle_journey_id:
      vehicleJourneysByName.v1MonFriJourney2.vehicle_journey_id,
    scheduled_stop_point_in_journey_pattern_ref_id:
      scheduledStopPointsInJourneyPatternRefByName.route123InboundStop4
        .scheduled_stop_point_in_journey_pattern_ref_id,
  },
  // Journey 3, outbound.
  v1MonFriJourney3Stop1: {
    timetabled_passing_time_id: 'c1191bd3-5038-4d63-ba43-d531415536da',
    arrival_time: null,
    departure_time: Duration.fromISO('PT8H5M'),
    vehicle_journey_id:
      vehicleJourneysByName.v1MonFriJourney3.vehicle_journey_id,
    scheduled_stop_point_in_journey_pattern_ref_id:
      scheduledStopPointsInJourneyPatternRefByName.route123OutboundStop1
        .scheduled_stop_point_in_journey_pattern_ref_id,
  },
  v1MonFriJourney3Stop2: {
    timetabled_passing_time_id: 'd9ab72a4-da8f-4d08-bfae-cf5bb33b1634',
    arrival_time: Duration.fromISO('PT8H15M'),
    departure_time: Duration.fromISO('PT8H15M'),
    vehicle_journey_id:
      vehicleJourneysByName.v1MonFriJourney3.vehicle_journey_id,
    scheduled_stop_point_in_journey_pattern_ref_id:
      scheduledStopPointsInJourneyPatternRefByName.route123OutboundStop2
        .scheduled_stop_point_in_journey_pattern_ref_id,
  },
  v1MonFriJourney3Stop3: {
    timetabled_passing_time_id: 'cf068263-852b-4980-9a5c-80794988cdbf',
    arrival_time: Duration.fromISO('PT8H22M'),
    departure_time: Duration.fromISO('PT8H22M'),
    vehicle_journey_id:
      vehicleJourneysByName.v1MonFriJourney3.vehicle_journey_id,
    scheduled_stop_point_in_journey_pattern_ref_id:
      scheduledStopPointsInJourneyPatternRefByName.route123OutboundStop3
        .scheduled_stop_point_in_journey_pattern_ref_id,
  },
  v1MonFriJourney3Stop4: {
    timetabled_passing_time_id: '959dabba-e22d-4e74-ae9f-04c3ebb161e7',
    arrival_time: Duration.fromISO('PT8H27M'),
    departure_time: null,
    vehicle_journey_id:
      vehicleJourneysByName.v1MonFriJourney3.vehicle_journey_id,
    scheduled_stop_point_in_journey_pattern_ref_id:
      scheduledStopPointsInJourneyPatternRefByName.route123OutboundStop4
        .scheduled_stop_point_in_journey_pattern_ref_id,
  },
  // Journey 4, inbound.
  v1MonFriJourney4Stop1: {
    timetabled_passing_time_id: 'ed25e196-2f70-49dc-9dba-760820738bd7',
    arrival_time: null,
    departure_time: Duration.fromISO('PT8H5M'),
    vehicle_journey_id:
      vehicleJourneysByName.v1MonFriJourney4.vehicle_journey_id,
    scheduled_stop_point_in_journey_pattern_ref_id:
      scheduledStopPointsInJourneyPatternRefByName.route123InboundStop1
        .scheduled_stop_point_in_journey_pattern_ref_id,
  },
  v1MonFriJourney4Stop2: {
    timetabled_passing_time_id: '4020319f-3122-4fd6-87d0-14d959b7022d',
    arrival_time: Duration.fromISO('PT8H15M'),
    departure_time: Duration.fromISO('PT8H15M'),
    vehicle_journey_id:
      vehicleJourneysByName.v1MonFriJourney4.vehicle_journey_id,
    scheduled_stop_point_in_journey_pattern_ref_id:
      scheduledStopPointsInJourneyPatternRefByName.route123InboundStop2
        .scheduled_stop_point_in_journey_pattern_ref_id,
  },
  v1MonFriJourney4Stop3: {
    timetabled_passing_time_id: '942e7d51-5105-43e0-b8a6-9591e299d232',
    arrival_time: Duration.fromISO('PT8H19M'),
    departure_time: Duration.fromISO('PT8H19M'),
    vehicle_journey_id:
      vehicleJourneysByName.v1MonFriJourney4.vehicle_journey_id,
    scheduled_stop_point_in_journey_pattern_ref_id:
      scheduledStopPointsInJourneyPatternRefByName.route123InboundStop3
        .scheduled_stop_point_in_journey_pattern_ref_id,
  },
  v1MonFriJourney4Stop4: {
    timetabled_passing_time_id: '5e2772ee-bfec-4af4-abf2-7cca2ccc7c27',
    arrival_time: Duration.fromISO('PT8H25M'),
    departure_time: null,
    vehicle_journey_id:
      vehicleJourneysByName.v1MonFriJourney4.vehicle_journey_id,
    scheduled_stop_point_in_journey_pattern_ref_id:
      scheduledStopPointsInJourneyPatternRefByName.route123InboundStop4
        .scheduled_stop_point_in_journey_pattern_ref_id,
  },
  // Journey 5, outbound.
  v1MonFriJourney5Stop1: {
    timetabled_passing_time_id: 'f58b0fe2-25d9-4252-a2f2-be0700595e5b',
    arrival_time: null,
    departure_time: Duration.fromISO('PT9H5M'),
    vehicle_journey_id:
      vehicleJourneysByName.v1MonFriJourney5.vehicle_journey_id,
    scheduled_stop_point_in_journey_pattern_ref_id:
      scheduledStopPointsInJourneyPatternRefByName.route123OutboundStop1
        .scheduled_stop_point_in_journey_pattern_ref_id,
  },
  v1MonFriJourney5Stop2: {
    timetabled_passing_time_id: '9ee73d7f-67f6-44b9-97a7-07a33d8e90b0',
    arrival_time: Duration.fromISO('PT9H15M'),
    departure_time: Duration.fromISO('PT9H15M'),
    vehicle_journey_id:
      vehicleJourneysByName.v1MonFriJourney5.vehicle_journey_id,
    scheduled_stop_point_in_journey_pattern_ref_id:
      scheduledStopPointsInJourneyPatternRefByName.route123OutboundStop2
        .scheduled_stop_point_in_journey_pattern_ref_id,
  },
  v1MonFriJourney5Stop3: {
    timetabled_passing_time_id: '9c4b1fca-2a86-4678-8d76-2cccc260e0ec',
    arrival_time: Duration.fromISO('PT9H22M'),
    departure_time: Duration.fromISO('PT9H22M'),
    vehicle_journey_id:
      vehicleJourneysByName.v1MonFriJourney5.vehicle_journey_id,
    scheduled_stop_point_in_journey_pattern_ref_id:
      scheduledStopPointsInJourneyPatternRefByName.route123OutboundStop3
        .scheduled_stop_point_in_journey_pattern_ref_id,
  },
  v1MonFriJourney5Stop4: {
    timetabled_passing_time_id: '9f2b1ad1-a27d-4e52-9769-64b1cb5039ed',
    arrival_time: Duration.fromISO('PT9H27M'),
    departure_time: null,
    vehicle_journey_id:
      vehicleJourneysByName.v1MonFriJourney5.vehicle_journey_id,
    scheduled_stop_point_in_journey_pattern_ref_id:
      scheduledStopPointsInJourneyPatternRefByName.route123OutboundStop4
        .scheduled_stop_point_in_journey_pattern_ref_id,
  },
  // Journey 6, inbound.
  v1MonFriJourney6Stop1: {
    timetabled_passing_time_id: 'a29031cd-3311-4c75-b405-c0fd416be6d0',
    arrival_time: null,
    departure_time: Duration.fromISO('PT9H5M'),
    vehicle_journey_id:
      vehicleJourneysByName.v1MonFriJourney6.vehicle_journey_id,
    scheduled_stop_point_in_journey_pattern_ref_id:
      scheduledStopPointsInJourneyPatternRefByName.route123InboundStop1
        .scheduled_stop_point_in_journey_pattern_ref_id,
  },
  v1MonFriJourney6Stop2: {
    timetabled_passing_time_id: '8a3b1d75-6031-4e35-a16b-9e93d1330ce9',
    arrival_time: Duration.fromISO('PT9H15M'),
    departure_time: Duration.fromISO('PT9H15M'),
    vehicle_journey_id:
      vehicleJourneysByName.v1MonFriJourney6.vehicle_journey_id,
    scheduled_stop_point_in_journey_pattern_ref_id:
      scheduledStopPointsInJourneyPatternRefByName.route123InboundStop2
        .scheduled_stop_point_in_journey_pattern_ref_id,
  },
  v1MonFriJourney6Stop3: {
    timetabled_passing_time_id: 'b9640d77-2989-46dd-8baf-6191a300336f',
    arrival_time: Duration.fromISO('PT9H19M'),
    departure_time: Duration.fromISO('PT9H19M'),
    vehicle_journey_id:
      vehicleJourneysByName.v1MonFriJourney6.vehicle_journey_id,
    scheduled_stop_point_in_journey_pattern_ref_id:
      scheduledStopPointsInJourneyPatternRefByName.route123InboundStop3
        .scheduled_stop_point_in_journey_pattern_ref_id,
  },
  v1MonFriJourney6Stop4: {
    timetabled_passing_time_id: 'fb141d82-4953-4e62-bfdb-1edcab25fb19',
    arrival_time: Duration.fromISO('PT9H25M'),
    departure_time: null,
    vehicle_journey_id:
      vehicleJourneysByName.v1MonFriJourney6.vehicle_journey_id,
    scheduled_stop_point_in_journey_pattern_ref_id:
      scheduledStopPointsInJourneyPatternRefByName.route123InboundStop4
        .scheduled_stop_point_in_journey_pattern_ref_id,
  },
};
export const timetabledPassingTimes: TimetabledPassingTime[] = Object.values(
  timetabledPassingTimesByName,
);
