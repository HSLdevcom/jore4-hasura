import { hasuraRequestTemplate, timetablesDbConfig } from '@config';
import { toGraphQlObject } from '@util/dataset';
import {
  batchInsert,
  closeDbConnection,
  createDbConnection,
  DbConnection,
} from '@util/db';
import { expectNoErrorResponse } from '@util/response';
import { buildPropNameArray, queryTable, setupDb } from '@util/setup';
import { defaultGenericTimetablesDbData } from 'generic/timetablesdb/datasets/defaultSetup';
import { journeyPatternRefsByName } from 'generic/timetablesdb/datasets/defaultSetup/journey-pattern-refs';
import { vehicleJourneysByName } from 'generic/timetablesdb/datasets/defaultSetup/vehicle-journeys';
import { vehicleServiceBlocksByName } from 'generic/timetablesdb/datasets/defaultSetup/vehicle-service-blocks';
import { vehicleServicesByName } from 'generic/timetablesdb/datasets/defaultSetup/vehicle-services';
import { genericTimetablesDbSchema } from 'generic/timetablesdb/datasets/schema';
import {
  JourneyPatternRef,
  VehicleJourney,
} from 'generic/timetablesdb/datasets/types';
import { post } from 'request-promise';

describe('Denormalized references to journey patterns in vehicle services', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(timetablesDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  beforeEach(() => setupDb(dbConnection, defaultGenericTimetablesDbData));

  const addMutationWrapper = (query: string) => `mutation {
    ${query}
  }`;

  const buildInsertVehicleJourneyMutation = (
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

  const buildUpdateVehicleJourneyMutation = (
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

  const buildDeletePassingTimeMutation = (vehicleJourneyId: UUID) => `
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

  const buildDeleteVehicleJourneyMutation = (vehicleJourneyId: UUID) => `
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

  const buildUpdateJourneyPatternRefMutation = (
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

  const postQuery = (query: string) => {
    return post({
      ...hasuraRequestTemplate,
      body: {
        query,
      },
    });
  };

  const getJourneyPatternsInVehicleServices = () => {
    return queryTable(
      dbConnection,
      genericTimetablesDbSchema[
        'vehicle_service.journey_patterns_in_vehicle_service'
      ],
    );
  };

  // What there should be in the denormalized
  // journey_patterns_in_vehicle_service table with default dataset.
  const defaultDatasetRows = {
    route123Outbound: {
      vehicle_service_id: vehicleServicesByName.v1MonFri.vehicle_service_id,
      journey_pattern_id:
        journeyPatternRefsByName.route123Outbound.journey_pattern_id,
      reference_count: 2,
    },
    route123Inbound: {
      vehicle_service_id: vehicleServicesByName.v1MonFri.vehicle_service_id,
      journey_pattern_id:
        journeyPatternRefsByName.route123Inbound.journey_pattern_id,
      reference_count: 2,
    },
  };

  it('should have created correct rows to denormalized table initially', async () => {
    const response = await getJourneyPatternsInVehicleServices();
    expectNoErrorResponse(response);
    expect(response.rowCount).toEqual(2);
    expect(response.rows).toEqual(
      expect.arrayContaining([
        defaultDatasetRows.route123Outbound,
        defaultDatasetRows.route123Inbound,
      ]),
    );
  });

  describe('on vehicle journey insert', () => {
    it('should increment count on existing row when one exists', async () => {
      const newVehicleJourney = {
        vehicle_journey_id: '587869dd-fbac-468c-9569-c2647763ab78',
        block_id: vehicleServiceBlocksByName.v1MonFri.block_id,
        journey_pattern_ref_id:
          journeyPatternRefsByName.route123Outbound.journey_pattern_ref_id,
      };
      const insertMutation = addMutationWrapper(
        buildInsertVehicleJourneyMutation(newVehicleJourney),
      );

      const insertResponse = await postQuery(insertMutation);
      expectNoErrorResponse(insertResponse);

      const response = await getJourneyPatternsInVehicleServices();
      expectNoErrorResponse(response);
      expect(response.rowCount).toEqual(2);
      expect(response.rows).toEqual(
        expect.arrayContaining([
          {
            ...defaultDatasetRows.route123Outbound,
            reference_count: 3,
          },
          defaultDatasetRows.route123Inbound,
        ]),
      );
    });

    it('should create row when one does not yet exist', async () => {
      const newVehicleJourney = {
        vehicle_journey_id: '587869dd-fbac-468c-9569-c2647763ab78',
        block_id: vehicleServiceBlocksByName.v1Sat.block_id,
        journey_pattern_ref_id:
          journeyPatternRefsByName.route123Outbound.journey_pattern_ref_id,
      };
      const insertMutation = addMutationWrapper(
        buildInsertVehicleJourneyMutation(newVehicleJourney),
      );

      const insertResponse = await postQuery(insertMutation);
      expectNoErrorResponse(insertResponse);

      const response = await getJourneyPatternsInVehicleServices();
      expectNoErrorResponse(response);
      expect(response.rowCount).toEqual(3);
      expect(response.rows).toEqual(
        expect.arrayContaining([
          defaultDatasetRows.route123Outbound,
          defaultDatasetRows.route123Outbound,
          {
            vehicle_service_id: vehicleServicesByName.v1Sat.vehicle_service_id,
            journey_pattern_id:
              journeyPatternRefsByName.route123Outbound.journey_pattern_id,
            reference_count: 1,
          },
        ]),
      );
    });

    it('should correctly increment counts when multiple inserts and updates are required', async () => {
      const newVehicleJourneys = {
        // Existing entries, 2 more for outbound
        forIncrementExistingOutbound1: {
          vehicle_journey_id: '587869dd-fbac-468c-9569-c2647763ab78',
          block_id: vehicleServiceBlocksByName.v1MonFri.block_id,
          journey_pattern_ref_id:
            journeyPatternRefsByName.route123Outbound.journey_pattern_ref_id,
        },
        forIncrementExistingOutbound2: {
          vehicle_journey_id: '2f51e1fe-ae14-4530-8d98-70c59e07960a',
          block_id: vehicleServiceBlocksByName.v1MonFri.block_id,
          journey_pattern_ref_id:
            journeyPatternRefsByName.route123Outbound.journey_pattern_ref_id,
        },
        // Existing entries, 1 more for inbound
        forIncrementExistingInbound: {
          vehicle_journey_id: 'd39d6ede-05d3-4215-9aef-e8328e7109c2',
          block_id: vehicleServiceBlocksByName.v1MonFri.block_id,
          journey_pattern_ref_id:
            journeyPatternRefsByName.route123Inbound.journey_pattern_ref_id,
        },
        // New entries, 2 for same journey pattern for Saturday vehicle schedule.
        forCreateNewSatOutbound1: {
          vehicle_journey_id: '13f46a8d-a9a7-40cb-88b6-c7daedfb4a76',
          block_id: vehicleServiceBlocksByName.v1Sat.block_id,
          journey_pattern_ref_id:
            journeyPatternRefsByName.route123Outbound.journey_pattern_ref_id,
        },
        forCreateNewSatOutbound2: {
          vehicle_journey_id: 'a187b66f-6403-404d-8aba-f648285ca460',
          block_id: vehicleServiceBlocksByName.v1Sat.block_id,
          journey_pattern_ref_id:
            journeyPatternRefsByName.route123Outbound.journey_pattern_ref_id,
        },
        // New entries, 2 for different journey patterns for Sunday vehicle schedule.
        forCreateNewSunOutbound: {
          vehicle_journey_id: '499475cc-8fa5-46f6-8187-f52c655f1bb4',
          block_id: vehicleServiceBlocksByName.v1Sun.block_id,
          journey_pattern_ref_id:
            journeyPatternRefsByName.route123Outbound.journey_pattern_ref_id,
        },
        forCreateNewSunInbound: {
          vehicle_journey_id: '490a6a45-6696-4608-984c-4ef4589bc5d8',
          block_id: vehicleServiceBlocksByName.v1Sun.block_id,
          journey_pattern_ref_id:
            journeyPatternRefsByName.route123Inbound.journey_pattern_ref_id,
        },
      };

      await batchInsert(dbConnection, 'vehicle_journey.vehicle_journey', [
        newVehicleJourneys.forIncrementExistingOutbound1,
        newVehicleJourneys.forIncrementExistingOutbound2,
        newVehicleJourneys.forIncrementExistingInbound,
        newVehicleJourneys.forCreateNewSatOutbound1,
        newVehicleJourneys.forCreateNewSatOutbound2,
        newVehicleJourneys.forCreateNewSunOutbound,
        newVehicleJourneys.forCreateNewSunInbound,
      ]);

      const response = await getJourneyPatternsInVehicleServices();
      expect(response.rowCount).toEqual(5);
      expect(response.rows).toEqual(
        expect.arrayContaining([
          {
            ...defaultDatasetRows.route123Outbound,
            reference_count: 4,
          },
          {
            ...defaultDatasetRows.route123Inbound,
            reference_count: 3,
          },
          {
            vehicle_service_id: vehicleServicesByName.v1Sat.vehicle_service_id,
            journey_pattern_id:
              journeyPatternRefsByName.route123Outbound.journey_pattern_id,
            reference_count: 2,
          },
          {
            vehicle_service_id: vehicleServicesByName.v1Sun.vehicle_service_id,
            journey_pattern_id:
              journeyPatternRefsByName.route123Outbound.journey_pattern_id,
            reference_count: 1,
          },
          {
            vehicle_service_id: vehicleServicesByName.v1Sun.vehicle_service_id,
            journey_pattern_id:
              journeyPatternRefsByName.route123Inbound.journey_pattern_id,
            reference_count: 1,
          },
        ]),
      );
    });
  });

  describe('on journey pattern ref delete', () => {
    it('should correctly decrement count', async () => {
      const deleteMutation = addMutationWrapper(`
        ${buildDeletePassingTimeMutation(
          vehicleJourneysByName.v1MonFriJourney1.vehicle_journey_id,
        )}
        ${buildDeleteVehicleJourneyMutation(
          vehicleJourneysByName.v1MonFriJourney1.vehicle_journey_id,
        )}
      `);
      const deleteRes = await postQuery(deleteMutation);
      expectNoErrorResponse(deleteRes);

      const response = await getJourneyPatternsInVehicleServices();
      expectNoErrorResponse(response);
      expect(response.rowCount).toEqual(2);
      expect(response.rows).toEqual(
        expect.arrayContaining([
          {
            ...defaultDatasetRows.route123Outbound,
            reference_count: 1,
          },
          defaultDatasetRows.route123Inbound,
        ]),
      );
    });

    it('should delete the row when count reaches zero', async () => {
      const deleteMutation = addMutationWrapper(`
        outbound_journey1_tpt_delete: ${buildDeletePassingTimeMutation(
          vehicleJourneysByName.v1MonFriJourney1.vehicle_journey_id,
        )}
        outbound_journey1_vj_delete: ${buildDeleteVehicleJourneyMutation(
          vehicleJourneysByName.v1MonFriJourney1.vehicle_journey_id,
        )}

        outbound_journey2_tpt_delete: ${buildDeletePassingTimeMutation(
          vehicleJourneysByName.v1MonFriJourney3.vehicle_journey_id,
        )}
        outbound_journey2_vj_delete: ${buildDeleteVehicleJourneyMutation(
          vehicleJourneysByName.v1MonFriJourney3.vehicle_journey_id,
        )}
      `);
      const deleteRes = await postQuery(deleteMutation);
      expectNoErrorResponse(deleteRes);

      const response = await getJourneyPatternsInVehicleServices();
      expectNoErrorResponse(response);
      expect(response.rowCount).toEqual(1);
      expect(response.rows).toEqual(
        expect.arrayContaining([defaultDatasetRows.route123Inbound]),
      );
    });
  });

  describe('on vehicle journey update', () => {
    it('should update counts on affected rows when foreign keys were changed', async () => {
      const updateMutation = addMutationWrapper(
        buildUpdateVehicleJourneyMutation(
          vehicleJourneysByName.v1MonFriJourney1.vehicle_journey_id,
          {
            block_id: vehicleServiceBlocksByName.v1Sat.block_id,
          },
        ),
      );
      const updateResponse = await postQuery(updateMutation);
      expectNoErrorResponse(updateResponse);

      const response = await getJourneyPatternsInVehicleServices();
      expect(response.rowCount).toEqual(3);
      expect(response.rows).toEqual(
        expect.arrayContaining([
          // One got removed from outbound...
          {
            ...defaultDatasetRows.route123Outbound,
            reference_count: 1,
          },
          // ...because it was moved to another block,
          // which is in different vehicle service -> new row.
          {
            vehicle_service_id: vehicleServicesByName.v1Sat.vehicle_service_id,
            journey_pattern_id:
              defaultDatasetRows.route123Outbound.journey_pattern_id,
            reference_count: 1,
          },
          // Inbound untouched.
          defaultDatasetRows.route123Inbound,
        ]),
      );
    });
  });

  describe('on journey pattern ref update', () => {
    it('should update denormalized table when journey pattern id is updated', async () => {
      const newJourneyPatternId = '9d5cb599-f348-4b76-b83c-e5c33f53b08e';
      const updateMutation = addMutationWrapper(
        buildUpdateJourneyPatternRefMutation(
          journeyPatternRefsByName.route123Outbound.journey_pattern_ref_id,
          {
            journey_pattern_id: newJourneyPatternId,
          },
        ),
      );
      const updateResponse = await postQuery(updateMutation);
      expectNoErrorResponse(updateResponse);

      const response = await getJourneyPatternsInVehicleServices();
      expect(response.rowCount).toEqual(2);
      expect(response.rows).toEqual(
        expect.arrayContaining([
          {
            ...defaultDatasetRows.route123Outbound,
            journey_pattern_id: newJourneyPatternId,
          },
          defaultDatasetRows.route123Inbound,
        ]),
      );
    });
  });
});
