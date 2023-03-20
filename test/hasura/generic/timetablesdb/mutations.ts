import { toGraphQlObject } from '@util/dataset';
import { addMutationWrapper } from '@util/graphql';
import { buildPropNameArray } from '@util/setup';
import { genericTimetablesDbSchema } from './datasets/schema';
import { JourneyPatternRef, VehicleJourney } from './datasets/types';

// Note: these mutations are not usable by themselves,
// they need to be ran through addMutationWrapper first.
export { addMutationWrapper };

// vehicle_journey:

export const buildInsertVehicleJourneyMutation = (
  newVehicleJourney: VehicleJourney,
) => `
  timetables {
    timetables_insert_vehicle_journey_vehicle_journey(objects: ${toGraphQlObject(
      newVehicleJourney,
    )}) {
      returning {
        ${buildPropNameArray(
          genericTimetablesDbSchema['vehicle_journey.vehicle_journey'],
        )}
      }
    }
  }
`;

export const buildUpdateVehicleJourneyMutation = (
  vehicleJourneyId: UUID,
  toBeUpdated: Partial<VehicleJourney>,
) => `
  timetables {
    timetables_update_vehicle_journey_vehicle_journey(
      where: {
        vehicle_journey_id: {_eq: "${vehicleJourneyId}"}
      },
      _set: ${toGraphQlObject(toBeUpdated)}
    ) {
      returning {
        ${buildPropNameArray(
          genericTimetablesDbSchema['vehicle_journey.vehicle_journey'],
        )}
      }
    }
  }
`;

export const buildDeleteVehicleJourneyMutation = (vehicleJourneyId: UUID) => `
  timetables {
    timetables_delete_vehicle_journey_vehicle_journey(
      where: {
        vehicle_journey_id: {_eq: "${vehicleJourneyId}"}
      }
    ) {
      affected_rows
    }
  }
`;

// journey_pattern_ref:

export const buildUpdateJourneyPatternRefMutation = (
  journeyPatternRefId: UUID,
  toBeUpdated: Partial<JourneyPatternRef>,
) => `
  timetables {
    timetables_update_journey_pattern_journey_pattern_ref(
      where: {
        journey_pattern_ref_id: {_eq: "${journeyPatternRefId}"}
      },
      _set: ${toGraphQlObject(toBeUpdated)}
    ) {
      returning {
        ${buildPropNameArray(
          genericTimetablesDbSchema['journey_pattern.journey_pattern_ref'],
        )}
      }
    }
  }
`;

// timetabled_passing_time:

export const buildDeletePassingTimeMutation = (vehicleJourneyId: UUID) => `
  timetables {
      timetables_delete_passing_times_timetabled_passing_time(
        where: {
          vehicle_journey_id: {_eq: "${vehicleJourneyId}"}
        }
      ) {
        affected_rows
      }
    }
`;
