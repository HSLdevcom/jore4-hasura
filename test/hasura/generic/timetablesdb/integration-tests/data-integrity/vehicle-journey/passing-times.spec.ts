import { timetablesDbConfig } from '@config';
import { asGraphQlDateObject, toGraphQlObject } from '@util/dataset';
import { DbConnection, closeDbConnection, createDbConnection } from '@util/db';
import { postQuery } from '@util/graphql';
import { expectErrorResponse, expectNoErrorResponse } from '@util/response';
import { buildPropNameArray, setupDb } from '@util/setup';
import { defaultTimetablesDataset } from 'generic/timetablesdb/datasets/defaultSetup/default-timetables-dataset';
import { genericTimetablesDbSchema } from 'generic/timetablesdb/datasets/schema';
import {
  ScheduledStopInJourneyPatternRef,
  TimetabledPassingTime,
} from 'generic/timetablesdb/datasets/types';
import { Duration } from 'luxon';
import {
  buildGenericTimetablesDataset,
  createGenericTableData,
} from 'timetables-data-inserter';
import { createTimetablesDatasetHelper } from 'timetables-data-inserter/generic/timetables-dataset-helper';

describe('Vehicle journey passing time validation', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(timetablesDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  const builtDefaultDataset = buildGenericTimetablesDataset(
    defaultTimetablesDataset,
  );
  const datasetHelper = createTimetablesDatasetHelper(builtDefaultDataset);

  beforeEach(async () => {
    const tableData = createGenericTableData(builtDefaultDataset);
    await setupDb(dbConnection, tableData);
  });

  // TODO: maybe move these to timetables/mutations.ts
  const wrapWithTimetablesMutation = (mutation: string) => `
mutation {
  timetables {
    ${mutation}
  }
}
`;

  const buildPartialUpdatePassingTimeMutation = (
    passingTimeId: UUID,
    toBeUpdated: Partial<TimetabledPassingTime>,
  ) => `
    timetables_update_passing_times_timetabled_passing_time(
      where: {
        timetabled_passing_time_id: {_eq: "${passingTimeId}"}
      },
      _set: ${toGraphQlObject(toBeUpdated)}
    ) {
      returning {
        ${buildPropNameArray(
          genericTimetablesDbSchema['passing_times.timetabled_passing_time'],
        )}
      }
    }
`;

  const buildPartialDeletePassingTimeMutation = (
    timetabledPassingTimeId: UUID,
  ) => `
    timetables_delete_passing_times_timetabled_passing_time_by_pk(
      timetabled_passing_time_id: "${timetabledPassingTimeId}"
    ) {
      ${buildPropNameArray(
        genericTimetablesDbSchema['passing_times.timetabled_passing_time'],
      )}
    }
`;

  const buildUpdatePassingTimeMutation = (
    passingTimeId: UUID,
    toBeUpdated: Partial<TimetabledPassingTime>,
  ) =>
    wrapWithTimetablesMutation(
      buildPartialUpdatePassingTimeMutation(passingTimeId, toBeUpdated),
    );

  const buildDeletePassingTimeMutation = (timetabledPassingTimeId: UUID) =>
    wrapWithTimetablesMutation(
      buildPartialDeletePassingTimeMutation(timetabledPassingTimeId),
    );

  const buildInsertOnePassingTimeMutation = (
    toInsert: Partial<TimetabledPassingTime>,
  ) => `
  mutation {
    timetables {
      timetables_insert_passing_times_timetabled_passing_time_one(
        object: ${toGraphQlObject(toInsert)}
      ) {
        ${buildPropNameArray(
          genericTimetablesDbSchema['passing_times.timetabled_passing_time'],
        )}
      }
    }
  }
`;

  const buildUpdateStopPointsMutation = (updateMutations: string[]) =>
    wrapWithTimetablesMutation(updateMutations.join('\n    '));

  const buildPartialUpdateStopPointMutation = (
    alias: string,
    stopPointId: UUID,
    toBeUpdated: Partial<ScheduledStopInJourneyPatternRef>,
  ) => `
${alias}: timetables_update_service_pattern_scheduled_stop_point_in_journey_pattern_ref(
  where: {
    scheduled_stop_point_in_journey_pattern_ref_id: {_eq: "${stopPointId}"}
  },
  _set: ${toGraphQlObject(toBeUpdated)}
) {
  returning {
    ${buildPropNameArray(
      genericTimetablesDbSchema[
        'service_pattern.scheduled_stop_point_in_journey_pattern_ref'
      ],
    )}
  }
}
`;

  // Note: most validation logic is shared between UPDATE/INSERT/DELETE.
  // Such logic is mainly tested here with updates.
  describe('on updates', () => {
    it('should accept a valid passing time', async () => {
      const journey = datasetHelper.getVehicleJourney('route123Inbound1');
      const testPassingTime = journey._passing_times[2];
      const nextPassingTime = journey._passing_times[3];

      // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
      const newStopTime = testPassingTime.arrival_time!.plus({ minutes: 2 });
      expect(newStopTime.valueOf()).toBeLessThan(
        // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
        nextPassingTime.arrival_time!.valueOf(),
      ); // Still valid.

      const toBeUpdated = {
        arrival_time: newStopTime,
        departure_time: newStopTime,
      };

      const response = await postQuery(
        buildUpdatePassingTimeMutation(
          testPassingTime.timetabled_passing_time_id,
          toBeUpdated,
        ),
      );

      const expectedUpdated = {
        ...testPassingTime,
        ...toBeUpdated,
      };

      expect(response).toEqual(
        expect.objectContaining({
          data: {
            timetables: {
              timetables_update_passing_times_timetabled_passing_time: {
                returning: [
                  {
                    ...asGraphQlDateObject(expectedUpdated),
                  },
                ],
              },
            },
          },
        }),
      );
    });

    it('should only validate sequence state at the end of transaction', async () => {
      const journey = datasetHelper.getVehicleJourney('route123Inbound1');
      const lastPassingTime = journey._passing_times[3];
      const newLastPassingTime = journey._passing_times[2];

      expect(lastPassingTime.departure_time).toBe(null);

      // Delete last point: after this the sequence is invalid because last stop has departure_time set.
      const deleteMutationPartial = buildPartialDeletePassingTimeMutation(
        lastPassingTime.timetabled_passing_time_id,
      );
      // Fix the new last stop.
      const updateMutationPartial = buildPartialUpdatePassingTimeMutation(
        newLastPassingTime.timetabled_passing_time_id,
        { departure_time: null },
      );

      // Sanity check the test, verify that delete and update fail individually.
      const deleteResponse = await postQuery(
        wrapWithTimetablesMutation(deleteMutationPartial),
      );
      expectErrorResponse('last passing time must not have departure_time set')(
        deleteResponse,
      );

      const updateResponse = await postQuery(
        wrapWithTimetablesMutation(updateMutationPartial),
      );
      expectErrorResponse('must have both departure and arrival time defined')(
        updateResponse,
      );

      // When done in a single transaction, the process succeeds.
      const combinedMutation = wrapWithTimetablesMutation(`
      ${deleteMutationPartial}
      ${updateMutationPartial}
    `);

      const response = await postQuery(combinedMutation);
      expectNoErrorResponse(response);
    });

    it('should not accept a passing time missing both arrival_time and departure_time', async () => {
      const journey = datasetHelper.getVehicleJourney('route123Inbound1');
      const testPassingTime = journey._passing_times[2];

      const toBeUpdated = {
        arrival_time: null,
        departure_time: null,
      };

      const response = await postQuery(
        buildUpdatePassingTimeMutation(
          testPassingTime.timetabled_passing_time_id,
          toBeUpdated,
        ),
      );

      expectErrorResponse(
        'Not-NULL violation. null value in column \\"passing_time\\" of relation \\"timetabled_passing_time\\" violates not-null constraint',
      )(response);
    });

    it('should not accept passing time with arrival_time > departure_time', async () => {
      const journey = datasetHelper.getVehicleJourney('route123Inbound1');
      const testPassingTime = journey._passing_times[2];
      expect(testPassingTime.departure_time).not.toBeNull();

      const toBeUpdated = {
        arrival_time: testPassingTime.arrival_time,
        departure_time: testPassingTime?.departure_time?.minus({ minutes: 1 }),
      };

      const response = await postQuery(
        buildUpdatePassingTimeMutation(
          testPassingTime.timetabled_passing_time_id,
          toBeUpdated,
        ),
      );

      expectErrorResponse(
        'Check constraint violation. new row for relation \\"timetabled_passing_time\\" violates check constraint \\"arrival_not_after_departure\\"',
      )(response);
    });

    it('should not accept passing time without arrival_time when it is for a non-last stop point', async () => {
      const journey = datasetHelper.getVehicleJourney('route123Inbound1');
      const testPassingTime = journey._passing_times[2];

      const toBeUpdated = {
        arrival_time: null,
        departure_time: testPassingTime.departure_time,
      };

      const response = await postQuery(
        buildUpdatePassingTimeMutation(
          testPassingTime.timetabled_passing_time_id,
          toBeUpdated,
        ),
      );

      expectErrorResponse(
        'all passing time that are not first or last in the sequence must have both departure and arrival time defined',
      )(response);
    });

    it('should not accept passing time without departure_time when it is for a non-first stop point', async () => {
      const journey = datasetHelper.getVehicleJourney('route123Inbound1');
      const testPassingTime = journey._passing_times[2];

      const toBeUpdated = {
        arrival_time: testPassingTime.arrival_time,
        departure_time: null,
      };
      const response = await postQuery(
        buildUpdatePassingTimeMutation(
          testPassingTime.timetabled_passing_time_id,
          toBeUpdated,
        ),
      );

      expectErrorResponse(
        'all passing time that are not first or last in the sequence must have both departure and arrival time defined',
      )(response);
    });

    it("should not accept a passing time with arrival_time before the previous passing time's departure_time", async () => {
      const journey = datasetHelper.getVehicleJourney('route123Inbound1');
      const testPassingTime = journey._passing_times[2];
      const nextPassingTime = journey._passing_times[3];
      expect(nextPassingTime.arrival_time).not.toBeNull();

      // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
      const newStopTime = testPassingTime.arrival_time!.plus({ minutes: 10 });
      expect(newStopTime.valueOf()).toBeGreaterThan(
        nextPassingTime.arrival_time!.valueOf(), // eslint-disable-line @typescript-eslint/no-non-null-assertion
      );

      const toBeUpdated = {
        arrival_time: newStopTime,
        departure_time: newStopTime,
      };

      const response = await postQuery(
        buildUpdatePassingTimeMutation(
          testPassingTime.timetabled_passing_time_id,
          toBeUpdated,
        ),
      );

      expectErrorResponse(
        'passing times and their matching stop points must be in same order',
      )(response);
    });

    it('should not accept a sequence where passing times overlap: arrival to next stop before departure from previous stop', async () => {
      const journey = datasetHelper.getVehicleJourney('route123Inbound1');
      const testPassingTime = journey._passing_times[1];
      const nextPassingTime = journey._passing_times[2];

      // Need two passing times with arrival > departure to verify this case.
      // Individually both arrival_time and departure_time fields are still in correct order,
      // but passing time as a whole is not since they overlap:
      // bus would arrive to stop3 before departing from stop2.
      const stop2PassingTimeUpdate = {
        arrival_time: Duration.fromISO('PT7H46M'),
        departure_time: Duration.fromISO('PT7H49M'),
      };
      const stop3PassingTimeUpdate = {
        arrival_time: Duration.fromISO('PT7H48M'),
        departure_time: Duration.fromISO('PT7H50M'),
      };

      // Setup, nothing wrong with this yet.
      const nextPassingTimeUpdateResponse = await postQuery(
        buildUpdatePassingTimeMutation(
          nextPassingTime.timetabled_passing_time_id,
          stop3PassingTimeUpdate,
        ),
      );
      expectNoErrorResponse(nextPassingTimeUpdateResponse);

      const response = await postQuery(
        buildUpdatePassingTimeMutation(
          testPassingTime.timetabled_passing_time_id,
          stop2PassingTimeUpdate,
        ),
      );

      expectErrorResponse(
        'passing times and their matching stop points must be in same order',
      )(response);
    });

    it("should accept a passing time with same arrival_time as the previous passing time's departure_time", async () => {
      const journey = datasetHelper.getVehicleJourney('route123Inbound1');
      const testPassingTime = journey._passing_times[2];
      const previousPassingTime = journey._passing_times[1];

      const newStopTime = previousPassingTime.departure_time;

      const toBeUpdated = {
        arrival_time: newStopTime,
        departure_time: newStopTime,
      };

      const response = await postQuery(
        buildUpdatePassingTimeMutation(
          testPassingTime.timetabled_passing_time_id,
          toBeUpdated,
        ),
      );

      expectNoErrorResponse(response);
    });

    it('should not be able to create vehicle journey where first passing_time has an arrival time', async () => {
      const journey = datasetHelper.getVehicleJourney('route123Inbound1');
      const testPassingTime = journey._passing_times[0];
      expect(testPassingTime.arrival_time).toBe(null);

      const toBeUpdated = {
        arrival_time: testPassingTime.departure_time,
        departure_time: testPassingTime.departure_time,
      };

      const response = await postQuery(
        buildUpdatePassingTimeMutation(
          testPassingTime.timetabled_passing_time_id,
          toBeUpdated,
        ),
      );

      expectErrorResponse('first passing time must not have arrival_time set')(
        response,
      );
    });

    it('should not be able to create vehicle journey where last passing_time has a departure time', async () => {
      const journey = datasetHelper.getVehicleJourney('route123Inbound1');
      const testPassingTime = journey._passing_times[3];
      expect(testPassingTime.departure_time).toBe(null);

      const toBeUpdated = {
        arrival_time: testPassingTime.arrival_time,
        departure_time: testPassingTime.arrival_time,
      };

      const response = await postQuery(
        buildUpdatePassingTimeMutation(
          testPassingTime.timetabled_passing_time_id,
          toBeUpdated,
        ),
      );

      expectErrorResponse('last passing time must not have departure_time set')(
        response,
      );
    });

    it('should accept valid passing times with non-continuous sequence', async () => {
      const journeyPatternRef =
        builtDefaultDataset._journey_pattern_refs.route123Inbound;
      const testStopPoint1 = journeyPatternRef._stop_points[2];
      const testStopPoint2 = journeyPatternRef._stop_points[3];

      const updateQuery = buildUpdateStopPointsMutation([
        buildPartialUpdateStopPointMutation(
          'update_sp1',
          testStopPoint1.scheduled_stop_point_in_journey_pattern_ref_id,
          {
            scheduled_stop_point_sequence:
              testStopPoint1.scheduled_stop_point_sequence + 5,
          },
        ),
        buildPartialUpdateStopPointMutation(
          'update_sp2',
          testStopPoint2.scheduled_stop_point_in_journey_pattern_ref_id,
          {
            scheduled_stop_point_sequence:
              testStopPoint2.scheduled_stop_point_sequence + 6,
          },
        ),
      ]);

      const response = await postQuery(updateQuery);

      expectNoErrorResponse(response);
    });

    it('should not accept inconsistent journey pattern references within a sequence', async () => {
      const journeyOutbound =
        datasetHelper.getVehicleJourney('route123Outbound1');
      const journeyInbound =
        datasetHelper.getVehicleJourney('route123Inbound1');
      // The sequence number is same, but stop points belong to different journey patterns.
      const testPassingTime = journeyInbound._passing_times[1];
      const differentVehicleJourneyPassingTime =
        journeyOutbound._passing_times[1];

      const toBeUpdated = {
        scheduled_stop_point_in_journey_pattern_ref_id:
          differentVehicleJourneyPassingTime.scheduled_stop_point_in_journey_pattern_ref_id,
      };

      const response = await postQuery(
        buildUpdatePassingTimeMutation(
          testPassingTime.timetabled_passing_time_id,
          toBeUpdated,
        ),
      );

      expectErrorResponse(
        'inconsistent journey_pattern_ref within vehicle journey, all timetabled_passing_times must reference same journey_pattern_ref as the vehicle_journey',
      )(response);
      expectErrorResponse(
        `vehicle_journey_id ${testPassingTime.vehicle_journey_id}`,
      )(response);
    });

    it('should not accept sequence where same scheduled stop point is used multiple times', async () => {
      const journey = datasetHelper.getVehicleJourney('route123Inbound1');
      const testPassingTime = journey._passing_times[1];
      const nextPassingTime = journey._passing_times[2];

      const toBeUpdated = {
        scheduled_stop_point_in_journey_pattern_ref_id:
          nextPassingTime.scheduled_stop_point_in_journey_pattern_ref_id,
      };

      const response = await postQuery(
        buildUpdatePassingTimeMutation(
          testPassingTime.timetabled_passing_time_id,
          toBeUpdated,
        ),
      );

      expectErrorResponse(
        'Uniqueness violation. duplicate key value violates unique constraint \\"timetabled_passing_time_stop_point_unique_idx\\',
      )(response);
    });

    it('should trigger validation on scheduled stop point in journey pattern ref update and fail an invalid sequence', async () => {
      const journeyPatternRef =
        builtDefaultDataset._journey_pattern_refs.route123Outbound;
      const testStopPoint = journeyPatternRef._stop_points[1];
      const nextStopPoint = journeyPatternRef._stop_points[2];

      const updateQuery = buildUpdateStopPointsMutation([
        // Make room for swap. Can't swap in place due to unique index:
        // it gets validated on every operation and not per transaction.
        buildPartialUpdateStopPointMutation(
          'dummy_update_to_bypass_unique_constraint',
          nextStopPoint.scheduled_stop_point_in_journey_pattern_ref_id,
          {
            scheduled_stop_point_sequence:
              nextStopPoint.scheduled_stop_point_sequence + 10,
          },
        ),
        // Swap the two points -> passing times are in incorrect order.
        buildPartialUpdateStopPointMutation(
          'update_sp2',
          testStopPoint.scheduled_stop_point_in_journey_pattern_ref_id,
          {
            scheduled_stop_point_sequence:
              testStopPoint.scheduled_stop_point_sequence + 1,
          },
        ),
        buildPartialUpdateStopPointMutation(
          'update_sp3',
          nextStopPoint.scheduled_stop_point_in_journey_pattern_ref_id,
          {
            scheduled_stop_point_sequence:
              nextStopPoint.scheduled_stop_point_sequence - 1,
          },
        ),
      ]);

      const response = await postQuery(updateQuery);

      expectErrorResponse(
        'passing times and their matching stop points must be in same order',
      )(response);
    });

    it('should trigger validation on scheduled stop point in journey pattern ref update and pass a valid sequence', async () => {
      // Last stop. Incrementing sequence just results in a gap, which is fine.
      const journeyPatternRef =
        builtDefaultDataset._journey_pattern_refs.route123Outbound;
      const testStopPoint = journeyPatternRef._stop_points[3];

      const updateQuery = buildUpdateStopPointsMutation([
        buildPartialUpdateStopPointMutation(
          'update_sp',
          testStopPoint.scheduled_stop_point_in_journey_pattern_ref_id,
          {
            scheduled_stop_point_sequence:
              testStopPoint.scheduled_stop_point_sequence + 10,
          },
        ),
      ]);

      const response = await postQuery(updateQuery);

      expectNoErrorResponse(response);
    });
  });

  describe('on inserts', () => {
    it('should trigger validation on passing time insert', async () => {
      const journey = datasetHelper.getVehicleJourney('route123Inbound1');
      const testPassingTime = journey._passing_times[2];
      // "Make room" in the sequence first so we have a valid spot to insert to.
      const deleteQuery = buildDeletePassingTimeMutation(
        testPassingTime.timetabled_passing_time_id,
      );
      const deleteResponse = await postQuery(deleteQuery);
      expectNoErrorResponse(deleteResponse);

      // Insert as non-last -> incorrectly has departure_time: null and should fail.
      const toInsert: TimetabledPassingTime = {
        ...testPassingTime,
        timetabled_passing_time_id: 'f8af422e-610b-4772-80f7-96562ca861b9',
        departure_time: null,
      };

      const response = await postQuery(
        buildInsertOnePassingTimeMutation(toInsert),
      );

      expectErrorResponse(
        'all passing time that are not first or last in the sequence must have both departure and arrival time defined',
      )(response);
      expectErrorResponse(
        `vehicle_journey_id ${toInsert.vehicle_journey_id}, timetabled_passing_time_id ${toInsert.timetabled_passing_time_id}`,
      )(response);
    });
  });

  describe('on deletes', () => {
    it('should trigger validation on passing time delete and pass a valid sequence', async () => {
      // Gaps in sequence are OK so can delete non-first or non-last passing time.
      const journey = datasetHelper.getVehicleJourney('route123Inbound1');
      const testPassingTime = journey._passing_times[2];

      const deleteQuery = buildDeletePassingTimeMutation(
        testPassingTime.timetabled_passing_time_id,
      );

      const response = await postQuery(deleteQuery);

      expectNoErrorResponse(response);
    });

    it('should trigger validation on passing time delete and fail an invalid sequence', async () => {
      // Delete last -> 2nd last has non-null departure_time -> invalid sequence.
      const journey = datasetHelper.getVehicleJourney('route123Inbound1');
      const lastPassingTime = journey._passing_times[3];
      const previousPassingTime = journey._passing_times[2];

      const response = await postQuery(
        buildDeletePassingTimeMutation(
          lastPassingTime.timetabled_passing_time_id,
        ),
      );

      expectErrorResponse('last passing time must not have departure_time set')(
        response,
      );
      expectErrorResponse(
        `vehicle_journey_id ${previousPassingTime.vehicle_journey_id}, timetabled_passing_time_id ${previousPassingTime.timetabled_passing_time_id}`,
      )(response);
    });
  });
});
