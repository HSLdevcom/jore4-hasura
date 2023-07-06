import { VehicleJourney } from '../types';
import { journeyPatternRefsByName } from './journey-pattern-refs';
import { vehicleServiceBlocksByName } from './vehicle-service-blocks';

export const vehicleJourneysByName = {
  v1MonFriJourney1: {
    vehicle_journey_id: '1c1a897e-e355-4e39-9731-3478fe7236fb',
    block_id: vehicleServiceBlocksByName.v1MonFri.block_id,
    journey_pattern_ref_id:
      journeyPatternRefsByName.route123Outbound.journey_pattern_ref_id,
  },
  v1MonFriJourney2: {
    vehicle_journey_id: 'da07ed23-f669-4960-85f9-d9a96a512a83',
    block_id: vehicleServiceBlocksByName.v1MonFri.block_id,
    journey_pattern_ref_id:
      journeyPatternRefsByName.route123Inbound.journey_pattern_ref_id,
  },
  v1MonFriJourney3: {
    vehicle_journey_id: '72b0bc65-bda6-4f5a-ab77-88ac9f7bdb8f',
    block_id: vehicleServiceBlocksByName.v1MonFri.block_id,
    journey_pattern_ref_id:
      journeyPatternRefsByName.route123Outbound.journey_pattern_ref_id,
  },
  v1MonFriJourney4: {
    vehicle_journey_id: '6429d3cd-fa36-4029-908e-ee37189d00dc',
    block_id: vehicleServiceBlocksByName.v1MonFri.block_id,
    journey_pattern_ref_id:
      journeyPatternRefsByName.route123Inbound.journey_pattern_ref_id,
  },
  v1MonFriJourney5: {
    vehicle_journey_id: '6bacee4f-329f-46bd-9a12-a54690b76ae0',
    block_id: vehicleServiceBlocksByName.v1MonFri.block_id,
    journey_pattern_ref_id:
      journeyPatternRefsByName.route123Outbound.journey_pattern_ref_id,
  },
  v1MonFriJourney6: {
    vehicle_journey_id: '6151db34-a4ac-44a6-97c4-81a78308d455',
    block_id: vehicleServiceBlocksByName.v1MonFri.block_id,
    journey_pattern_ref_id:
      journeyPatternRefsByName.route123Inbound.journey_pattern_ref_id,
  },
  v1MonFriJourney1Summer2023: {
    vehicle_journey_id: '2c27c47f-8559-43f2-a572-9f302d6ba0ba',
    block_id: vehicleServiceBlocksByName.v1MonFriSummer2023.block_id,
    journey_pattern_ref_id:
      journeyPatternRefsByName.route234Outbound.journey_pattern_ref_id,
  },
};
export const vehicleJourneys: VehicleJourney[] = Object.values(
  vehicleJourneysByName,
);
