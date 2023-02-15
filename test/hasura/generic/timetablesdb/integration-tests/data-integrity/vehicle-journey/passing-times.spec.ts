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
  TimetabledPassingTimes,
} from 'generic/timetablesdb/datasets/types';
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
    toBeUpdated: Partial<TimetabledPassingTimes>,
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

  const postUpdateQuery = (query: string) => {
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

    const response = await post({
      ...hasuraRequestTemplate,
      body: {
        query: buildUpdatePassingTimeMutation(
          testPassingTime.timetabled_passing_time_id,
          toBeUpdated,
        ),
      },
    });

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

    const response = await postUpdateQuery(
      buildUpdatePassingTimeMutation(
        testPassingTime.timetabled_passing_time_id,
        toBeUpdated,
      ),
    );

    expectErrorResponse(
      'Not-NULL violation. null value in column \\"passing_time\\" violates not-null constraint',
    )(response);
  });

  it('should not accept passing time with arrival_time < departure_time', async () => {
    const testPassingTime = timetabledPassingTimesByName.v1MonFriJourney2Stop3;

    const toBeUpdated = {
      arrival_time: testPassingTime.arrival_time,
      departure_time: testPassingTime.departure_time.minus({ minutes: 1 }),
    };

    const response = await postUpdateQuery(
      buildUpdatePassingTimeMutation(
        testPassingTime.timetabled_passing_time_id,
        toBeUpdated,
      ),
    );

    expectErrorResponse(
      'Check constraint violation. new row for relation \\"timetabled_passing_time\\" violates check constraint \\"departure_not_after_arrival\\"',
    )(response);
  });

  it('should not accept passing time without arrival_time when it is for a non-last stop point', async () => {
    const testPassingTime = timetabledPassingTimesByName.v1MonFriJourney2Stop3;

    const toBeUpdated = {
      arrival_time: null,
      departure_time: testPassingTime.departure_time,
    };

    const response = await postUpdateQuery(
      buildUpdatePassingTimeMutation(
        testPassingTime.timetabled_passing_time_id,
        toBeUpdated,
      ),
    );

    expectErrorResponse(
      'all passing time that are not first or last in the sequence must have both departure and arrival time defined.',
    )(response);
  });

  it('should not accept passing time without departure_time when it is for a non-first stop point', async () => {
    const testPassingTime = timetabledPassingTimesByName.v1MonFriJourney2Stop3;

    const toBeUpdated = {
      arrival_time: testPassingTime.arrival_time,
      departure_time: null,
    };

    const response = await postUpdateQuery(
      buildUpdatePassingTimeMutation(
        testPassingTime.timetabled_passing_time_id,
        toBeUpdated,
      ),
    );

    expectErrorResponse(
      'all passing time that are not first or last in the sequence must have both departure and arrival time defined.',
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

    const response = await postUpdateQuery(
      buildUpdatePassingTimeMutation(
        testPassingTime.timetabled_passing_time_id,
        toBeUpdated,
      ),
    );

    expectErrorResponse(
      'passing times and their matching stop points must be in same order',
    )(response);
  });

  it('should not be able to create vehicle journey where first passing_time has an arrival time', async () => {
    const testPassingTime = timetabledPassingTimesByName.v1MonFriJourney2Stop1;
    expect(testPassingTime.arrival_time).toBe(null);

    const toBeUpdated = {
      arrival_time: testPassingTime.departure_time,
      departure_time: testPassingTime.departure_time,
    };

    const response = await postUpdateQuery(
      buildUpdatePassingTimeMutation(
        testPassingTime.timetabled_passing_time_id,
        toBeUpdated,
      ),
    );

    expectErrorResponse('first passing time must not have arrival_time set.')(
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

    const response = await postUpdateQuery(
      buildUpdatePassingTimeMutation(
        testPassingTime.timetabled_passing_time_id,
        toBeUpdated,
      ),
    );

    expectErrorResponse('last passing time must not have departure_time set.')(
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

    const response = await postUpdateQuery(updateQuery);

    expectNoErrors(response);
  });
});
