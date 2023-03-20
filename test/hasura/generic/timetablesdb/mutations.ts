import { toGraphQlObject } from '@util/dataset';
import { addMutationWrapper } from '@util/graphql';
import { buildPropNameArray } from '@util/setup';
import { genericTimetablesDbSchema } from './datasets/schema';
import {
  JourneyPatternRef,
  VehicleJourney,
  VehicleScheduleFrame,
  VehicleService,
  VehicleServiceBlock,
} from './datasets/types';

// Note: these mutations are not usable by themselves,
// they need to be ran through addMutationWrapper first.
export { addMutationWrapper };

// vehicle_schedule_frame:

export const buildUpdateVehicleScheduleFrameMutation = (
  vehicleScheduleFrameId: UUID,
  toBeUpdated: Partial<VehicleScheduleFrame>,
) => `
  timetables {
    timetables_update_vehicle_schedule_vehicle_schedule_frame(
      where: {
        vehicle_schedule_frame_id: {_eq: "${vehicleScheduleFrameId}"}
      },
      _set: ${toGraphQlObject(toBeUpdated)}
    ) {
      returning {
        ${buildPropNameArray(
          genericTimetablesDbSchema['vehicle_schedule.vehicle_schedule_frame'],
        )}
      }
    }
  }
`;

// vehicle_service:

export const buildInsertVehicleServiceMutation = (
  newVehicleService: VehicleService,
) => `
  timetables {
    timetables_insert_vehicle_service_vehicle_service(objects: ${toGraphQlObject(
      newVehicleService,
    )}) {
      returning {
        ${buildPropNameArray(
          genericTimetablesDbSchema['vehicle_service.vehicle_service'],
        )}
      }
    }
  }
`;

export const buildUpdateVehicleServiceMutation = (
  vehicleServiceId: UUID,
  toBeUpdated: Partial<VehicleService>,
) => `
  timetables {
    timetables_update_vehicle_service_vehicle_service(
      where: {
        vehicle_service_id: {_eq: "${vehicleServiceId}"}
      },
      _set: ${toGraphQlObject(toBeUpdated)}
    ) {
      returning {
        ${buildPropNameArray(
          genericTimetablesDbSchema['vehicle_service.vehicle_service'],
        )}
      }
    }
  }
`;

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
