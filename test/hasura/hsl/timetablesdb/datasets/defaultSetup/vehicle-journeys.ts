import {
  journeyPatternRefsByName,
  vehicleJourneys,
  vehicleServiceBlocksByName,
} from 'generic/timetablesdb/datasets/defaultSetup';
import { VehicleJourney } from 'generic/timetablesdb/datasets/types';
import { hslVehicleServiceBlocksByName } from './vehicle-services-blocks';

export const hslVehicleJourneysByName = {
  v1SatJourney1: {
    vehicle_journey_id: 'fb56601c-7ac5-4369-bf26-c7f0d3a00b92',
    block_id: vehicleServiceBlocksByName.v1Sat.block_id,
    journey_pattern_ref_id:
      journeyPatternRefsByName.route123Inbound.journey_pattern_ref_id,
  },
  v1SatJourney2: {
    vehicle_journey_id: '9bdac86c-f7a0-46ac-9d79-65ac9907c4bb',
    block_id: vehicleServiceBlocksByName.v1Sat.block_id,
    journey_pattern_ref_id:
      journeyPatternRefsByName.route123Outbound.journey_pattern_ref_id,
  },
  v1SunJourney1: {
    vehicle_journey_id: '40690cb5-dadd-46bd-9f44-62ca072e902c',
    block_id: vehicleServiceBlocksByName.v1Sun.block_id,
    journey_pattern_ref_id:
      journeyPatternRefsByName.route123Inbound.journey_pattern_ref_id,
  },
  v1SunJourney2: {
    vehicle_journey_id: '1c71002e-25b6-47b9-b90c-42c868ddb7c8',
    block_id: vehicleServiceBlocksByName.v1Sun.block_id,
    journey_pattern_ref_id:
      journeyPatternRefsByName.route123Outbound.journey_pattern_ref_id,
  },
  v1AscensionDayJourney1: {
    vehicle_journey_id: 'feb60181-3313-43a7-bdae-07508e2cebca',
    block_id: hslVehicleServiceBlocksByName.v1Ascension.block_id,
    journey_pattern_ref_id:
      journeyPatternRefsByName.route123Inbound.journey_pattern_ref_id,
  },
  v1AscensionDayJourney2: {
    vehicle_journey_id: '9947bacd-353b-4489-84e8-26492b69b8b6',
    block_id: hslVehicleServiceBlocksByName.v1Ascension.block_id,
    journey_pattern_ref_id:
      journeyPatternRefsByName.route123Outbound.journey_pattern_ref_id,
  },
};

// TODO: Add actual conversion to hsl model when needed
export const hslVehicleJourneys: VehicleJourney[] = vehicleJourneys.concat(
  Object.values(hslVehicleJourneysByName),
);
