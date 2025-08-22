import { timetablesDbConfig } from '@config';
import {
  DbConnection,
  batchInsert,
  closeDbConnection,
  createDbConnection,
  getKnex,
} from '@util/db';
import { addMutationWrapper, postQuery } from '@util/graphql';
import { expectNoErrorResponse } from '@util/response';
import { queryTable, setupDb } from '@util/setup';
import {
  defaultGenericTimetablesDbData,
  journeyPatternRefsByName,
  vehicleJourneys,
  vehicleJourneysByName,
  vehicleServiceBlocksByName,
  vehicleServicesByName,
} from 'generic/timetablesdb/datasets/defaultSetup';
import { genericTimetablesDbSchema } from 'generic/timetablesdb/datasets/schema';
import {
  buildDeletePassingTimeMutation,
  buildDeleteVehicleJourneyMutation,
  buildInsertVehicleJourneyMutation,
  buildUpdateJourneyPatternRefMutation,
  buildUpdateVehicleJourneyMutation,
} from 'generic/timetablesdb/mutations';

describe('Denormalized references to journey patterns in vehicle services', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(timetablesDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  beforeEach(() => setupDb(dbConnection, defaultGenericTimetablesDbData));

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
      reference_count: 3,
    },
    route123Inbound: {
      vehicle_service_id: vehicleServicesByName.v1MonFri.vehicle_service_id,
      journey_pattern_id:
        journeyPatternRefsByName.route123Inbound.journey_pattern_id,
      reference_count: 3,
    },
  };

  it('should have created correct rows to denormalized table initially', async () => {
    const response = await getJourneyPatternsInVehicleServices();
    expectNoErrorResponse(response);
    expect(response.rowCount).toEqual(3);
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
        turnaround_time: null,
        layover_time: null,
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
          {
            ...defaultDatasetRows.route123Outbound,
            reference_count: 4,
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
        turnaround_time: null,
        layover_time: null,
      };
      const insertMutation = addMutationWrapper(
        buildInsertVehicleJourneyMutation(newVehicleJourney),
      );

      const insertResponse = await postQuery(insertMutation);
      expectNoErrorResponse(insertResponse);

      const response = await getJourneyPatternsInVehicleServices();
      expectNoErrorResponse(response);
      expect(response.rowCount).toEqual(4);
      expect(response.rows).toEqual(
        expect.arrayContaining([
          defaultDatasetRows.route123Outbound,
          defaultDatasetRows.route123Inbound,
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
      expectNoErrorResponse(response);
      expect(response.rowCount).toEqual(6);
      expect(response.rows).toEqual(
        expect.arrayContaining([
          {
            ...defaultDatasetRows.route123Outbound,
            reference_count: 5,
          },
          {
            ...defaultDatasetRows.route123Inbound,
            reference_count: 4,
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
      const outboundVehicleJourney = vehicleJourneysByName.v1MonFriJourney1;
      const outboundJourneyPattern = journeyPatternRefsByName.route123Outbound;
      expect(outboundVehicleJourney.journey_pattern_ref_id).toBe(
        outboundJourneyPattern.journey_pattern_ref_id,
      );

      const deleteMutation = addMutationWrapper(`
        ${buildDeletePassingTimeMutation(
          outboundVehicleJourney.vehicle_journey_id,
        )}
        ${buildDeleteVehicleJourneyMutation(
          outboundVehicleJourney.vehicle_journey_id,
        )}
      `);
      const deleteRes = await postQuery(deleteMutation);
      expectNoErrorResponse(deleteRes);

      const response = await getJourneyPatternsInVehicleServices();
      expectNoErrorResponse(response);
      expect(response.rowCount).toEqual(3);
      expect(response.rows).toEqual(
        expect.arrayContaining([
          {
            ...defaultDatasetRows.route123Outbound,
            reference_count: 2,
          },
          defaultDatasetRows.route123Inbound,
        ]),
      );
    });

    it('should delete the row when count reaches zero', async () => {
      // Test with outbound vehicle journeys.
      // Sanity check test data: only relevant vehicle journeys are exactly these three.
      const { v1MonFriJourney1, v1MonFriJourney3, v1MonFriJourney5 } =
        vehicleJourneysByName;
      const outboundJourneyPatternRefId =
        journeyPatternRefsByName.route123Outbound.journey_pattern_ref_id;
      const allOutboundVehicleJourneys = vehicleJourneys.filter(
        (vj) => vj.journey_pattern_ref_id === outboundJourneyPatternRefId,
      );
      expect(allOutboundVehicleJourneys).toEqual(
        expect.arrayContaining([
          v1MonFriJourney1,
          v1MonFriJourney3,
          v1MonFriJourney5,
        ]),
      );
      expect(allOutboundVehicleJourneys).toHaveLength(3);

      const deleteMutation = addMutationWrapper(`
        outbound_journey1_tpt_delete: ${buildDeletePassingTimeMutation(
          v1MonFriJourney1.vehicle_journey_id,
        )}
        outbound_journey1_vj_delete: ${buildDeleteVehicleJourneyMutation(
          v1MonFriJourney1.vehicle_journey_id,
        )}

        outbound_journey2_tpt_delete: ${buildDeletePassingTimeMutation(
          v1MonFriJourney3.vehicle_journey_id,
        )}
        outbound_journey2_vj_delete: ${buildDeleteVehicleJourneyMutation(
          v1MonFriJourney3.vehicle_journey_id,
        )}

        outbound_journey3_tpt_delete: ${buildDeletePassingTimeMutation(
          v1MonFriJourney5.vehicle_journey_id,
        )}
        outbound_journey3_vj_delete: ${buildDeleteVehicleJourneyMutation(
          v1MonFriJourney5.vehicle_journey_id,
        )}
      `);
      const deleteRes = await postQuery(deleteMutation);
      expectNoErrorResponse(deleteRes);

      const response = await getJourneyPatternsInVehicleServices();
      expectNoErrorResponse(response);
      expect(response.rowCount).toEqual(2);
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
      expectNoErrorResponse(response);
      expect(response.rowCount).toEqual(4);
      expect(response.rows).toEqual(
        expect.arrayContaining([
          // One got removed from outbound...
          {
            ...defaultDatasetRows.route123Outbound,
            reference_count: 2,
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
      expectNoErrorResponse(response);
      expect(response.rowCount).toEqual(3);
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

  describe('on transaction rollback', () => {
    it('should also roll back the denormalized table to correct state', async () => {
      const denormalizedTableBefore =
        await getJourneyPatternsInVehicleServices();
      expectNoErrorResponse(denormalizedTableBefore);

      let deleteRan = false;
      await getKnex().transaction(
        async (trx) => {
          await trx
            .from('vehicle_service.journey_patterns_in_vehicle_service')
            .delete();
          deleteRan = true;

          // Rather than manually, this could be caused by an error in eg. validations,
          // but this is simpler for tests and end result is the same.
          return trx.rollback();
        },
        { connection: dbConnection },
      );

      expect(deleteRan).toBe(true); // Mainly a sanity check that the query is valid.
      const denormalizedTableAfter =
        await getJourneyPatternsInVehicleServices();
      expectNoErrorResponse(denormalizedTableAfter);

      expect(denormalizedTableAfter.rows).toEqual(denormalizedTableBefore.rows);
    });
  });
});
