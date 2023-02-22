import { hasuraRequestTemplate, timetablesDbConfig } from '@config';
import { asGraphQlDateObject, toGraphQlObject } from '@util/dataset';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import { expectErrorResponse } from '@util/response';
import { buildPropNameArray, setupDb } from '@util/setup';
import { defaultGenericTimetablesDbData } from 'generic/timetablesdb/datasets/defaultSetup';
import { timetabledPassingTimesByName } from 'generic/timetablesdb/datasets/defaultSetup/passing-times';
import { scheduledStopPointsInJourneyPatternRefByName } from 'generic/timetablesdb/datasets/defaultSetup/stop-points';
import { genericTimetablesDbSchema } from 'generic/timetablesdb/datasets/schema';
import {
  ScheduledStopInJourneyPatternRef,
  TimetabledPassingTime,
} from 'generic/timetablesdb/datasets/types';
import { Duration } from 'luxon';
import { post } from 'request-promise';

describe('Vehicle journey passing time validation', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(timetablesDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  beforeEach(() => setupDb(dbConnection, defaultGenericTimetablesDbData));

  const buildUpdatePassingTimeMutation = (
    passingTimeId: UUID,
    toBeUpdated: Partial<TimetabledPassingTime>,
  ) => `
mutation {
  timetables {
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
  }
}
`;

  const buildUpdateStopPointsMutation = (updateMutations: string[]) => `
mutation {
  timetables {
    ${updateMutations.join('\n    ')}
  }
}
`;

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

  const postQuery = (query: string) => {
    return post({
      ...hasuraRequestTemplate,
      body: {
        query,
      },
    });
  };

  const expectNoErrors = (response: unknown) => {
    expect(response).toEqual(
      expect.not.objectContaining({
        errors: expect.any(Array),
      }),
    );
  };

  it('should accept a valid passing time', async () => {
    const testPassingTime = timetabledPassingTimesByName.v1MonFriJourney2Stop3;
    const nextPassingTime = timetabledPassingTimesByName.v1MonFriJourney2Stop4;

    const newStopTime = testPassingTime.arrival_time?.plus({ minutes: 2 });
    expect(newStopTime.valueOf()).toBeLessThan(
      nextPassingTime.arrival_time?.valueOf(),
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

  it('should not accept a passing time missing both arrival_time and departure_time', async () => {
    const testPassingTime = timetabledPassingTimesByName.v1MonFriJourney2Stop3;

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
      'Not-NULL violation. null value in column \\"passing_time\\" violates not-null constraint',
    )(response);
  });

  it('should not accept passing time with arrival_time > departure_time', async () => {
    const testPassingTime = timetabledPassingTimesByName.v1MonFriJourney2Stop3;

    const toBeUpdated = {
      arrival_time: testPassingTime.arrival_time,
      departure_time: testPassingTime.departure_time.minus({ minutes: 1 }),
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
    const testPassingTime = timetabledPassingTimesByName.v1MonFriJourney2Stop3;

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
    const testPassingTime = timetabledPassingTimesByName.v1MonFriJourney2Stop3;

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
    const testPassingTime = timetabledPassingTimesByName.v1MonFriJourney2Stop3;
    const nextPassingTime = timetabledPassingTimesByName.v1MonFriJourney2Stop4;

    const newStopTime = testPassingTime.arrival_time?.plus({ minutes: 10 });
    expect(newStopTime.valueOf()).toBeGreaterThan(
      nextPassingTime.arrival_time?.valueOf(),
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
    const testPassingTime = timetabledPassingTimesByName.v1MonFriJourney2Stop2;
    const nextPassingTime = timetabledPassingTimesByName.v1MonFriJourney2Stop3;

    // Need two passing times with arrival > departure to verify this case.
    // Individually both arrival_time and departure_time fields are still in correct order,
    // but passing time as a whole is not since they overlap:
    // bus would arrive to stop3 before departing from stop2.
    const stop2PassingTimeUpdate = {
      arrival_time: Duration.fromISO('PT7H16M'),
      departure_time: Duration.fromISO('PT7H19M'),
    };
    const stop3PassingTimeUpdate = {
      arrival_time: Duration.fromISO('PT7H18M'),
      departure_time: Duration.fromISO('PT7H20M'),
    };

    // Setup, nothing wrong with this yet.
    const nextPassingTimeUpdateResponse = await postQuery(
      buildUpdatePassingTimeMutation(
        nextPassingTime.timetabled_passing_time_id,
        stop3PassingTimeUpdate,
      ),
    );
    expectNoErrors(nextPassingTimeUpdateResponse);

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
    const testPassingTime = timetabledPassingTimesByName.v1MonFriJourney2Stop3;
    const previousPassingTime =
      timetabledPassingTimesByName.v1MonFriJourney2Stop2;

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

    expectNoErrors(response);
  });

  it('should not be able to create vehicle journey where first passing_time has an arrival time', async () => {
    const testPassingTime = timetabledPassingTimesByName.v1MonFriJourney2Stop1;
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
    const testPassingTime = timetabledPassingTimesByName.v1MonFriJourney2Stop4;
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
    const testStopPoint1 =
      scheduledStopPointsInJourneyPatternRefByName.route123InboundStop3;
    const testStopPoint2 =
      scheduledStopPointsInJourneyPatternRefByName.route123InboundStop4;

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

    expectNoErrors(response);
  });

  it('should trigger validation on passing time insert', async () => {
    const previousPassingTime =
      timetabledPassingTimesByName.v1MonFriJourney2Stop4;
    // Insert as last -> previous last incorrectly has departure_time: null and should fail.
    const toInsert: TimetabledPassingTime = {
      ...previousPassingTime,
      timetabled_passing_time_id: 'f8af422e-610b-4772-80f7-96562ca861b9',
      arrival_time: previousPassingTime.arrival_time.plus({ minutes: 5 }),
      departure_time: null,
    };

    const insertQuery = `
      mutation {
        timetables {
          timetables_insert_passing_times_timetabled_passing_time_one(
            object: ${toGraphQlObject(toInsert)}
          ) {
            ${buildPropNameArray(
              genericTimetablesDbSchema[
                'passing_times.timetabled_passing_time'
              ],
            )}
          }
        }
      }
    `;

    const response = await postQuery(insertQuery);

    expectErrorResponse(
      'all passing time that are not first or last in the sequence must have both departure and arrival time defined',
    )(response);
    expectErrorResponse(
      `vehicle_journey_id ${previousPassingTime.vehicle_journey_id}, timetabled_passing_time_id ${previousPassingTime.timetabled_passing_time_id}`,
    )(response);
  });

  it('should trigger validation on scheduled stop point in journey pattern ref update and fail an invalid sequence', async () => {
    const testStopPoint =
      scheduledStopPointsInJourneyPatternRefByName.route123OutboundStop2;
    const nextStopPoint =
      scheduledStopPointsInJourneyPatternRefByName.route123OutboundStop3;

    const updateQuery = buildUpdateStopPointsMutation([
      buildPartialUpdateStopPointMutation(
        'dummy_update_to_bypass_unique_constraint',
        nextStopPoint.scheduled_stop_point_in_journey_pattern_ref_id,
        {
          scheduled_stop_point_sequence:
            nextStopPoint.scheduled_stop_point_sequence + 10,
        },
      ),
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
    const testStopPoint =
      scheduledStopPointsInJourneyPatternRefByName.route123OutboundStop4;

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

    expectNoErrors(response);
  });
});
