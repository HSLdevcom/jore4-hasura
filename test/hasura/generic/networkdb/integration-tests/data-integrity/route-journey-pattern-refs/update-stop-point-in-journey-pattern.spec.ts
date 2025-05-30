import * as config from '@config';
import * as dataset from '@util/dataset';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import { post } from '@util/fetch-request';
import { expectErrorResponse } from '@util/response';
import { getPropNameArray, queryTable, setupDb } from '@util/setup';
import {
  journeyPatterns,
  routesAndJourneyPatternsTableData,
  scheduledStopPointInJourneyPattern,
} from 'generic/networkdb/datasets/routesAndJourneyPatterns';
import { genericNetworkDbSchema } from 'generic/networkdb/datasets/schema';
import {
  ScheduledStopPointInJourneyPattern,
  scheduledStopPointInJourneyPatternProps,
} from 'generic/networkdb/datasets/types';

const buildMutation = (
  journeyPatternId: string,
  scheduledStopPointLabel: string,
  toBeUpdated: Partial<ScheduledStopPointInJourneyPattern>,
) => `
  mutation {
    update_journey_pattern_scheduled_stop_point_in_journey_pattern(
      where: {
        _and: {
          journey_pattern_id: {_eq: "${journeyPatternId}"},
          scheduled_stop_point_label: {_eq: "${scheduledStopPointLabel}"}
        }
      },
      _set: ${dataset.toGraphQlObject(toBeUpdated)}
    ) {
      returning {
        ${getPropNameArray(scheduledStopPointInJourneyPatternProps).join(',')}
      }
    }
  }
`;

describe('Update scheduled stop point in journey pattern', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(config.networkDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  beforeEach(() => setupDb(dbConnection, routesAndJourneyPatternsTableData));

  const shouldReturnErrorResponse = (
    scheduledStopPoint: ScheduledStopPointInJourneyPattern,
    toBeUpdated: Partial<ScheduledStopPointInJourneyPattern>,
    expectedErrorMsg: string,
  ) =>
    it('should return error response', async () => {
      await post({
        ...config.hasuraRequestTemplate,
        body: {
          query: buildMutation(
            scheduledStopPoint.journey_pattern_id,
            scheduledStopPoint.scheduled_stop_point_label,
            toBeUpdated,
          ),
        },
      }).then(expectErrorResponse(expectedErrorMsg));
    });

  const shouldNotModifyDatabase = (
    scheduledStopPoint: ScheduledStopPointInJourneyPattern,
    toBeUpdated: Partial<ScheduledStopPointInJourneyPattern>,
  ) =>
    it('should not modify the database', async () => {
      await post({
        ...config.hasuraRequestTemplate,
        body: {
          query: buildMutation(
            scheduledStopPoint.journey_pattern_id,
            scheduledStopPoint.scheduled_stop_point_label,
            toBeUpdated,
          ),
        },
      });

      const response = await queryTable(
        dbConnection,
        genericNetworkDbSchema[
          'journey_pattern.scheduled_stop_point_in_journey_pattern'
        ],
      );

      expect(response.rowCount).toEqual(
        scheduledStopPointInJourneyPattern.length,
      );
      expect(response.rows).toEqual(
        expect.arrayContaining(scheduledStopPointInJourneyPattern),
      );
    });

  describe('when stop is on a link not included in the route', () => {
    const toBeUpdated = {
      journey_pattern_id: journeyPatterns[0].journey_pattern_id,
      scheduled_stop_point_sequence: 150,
    };

    shouldReturnErrorResponse(
      scheduledStopPointInJourneyPattern[3],
      toBeUpdated,
      "route's and journey pattern's traversal paths must match each other",
    );

    shouldNotModifyDatabase(scheduledStopPointInJourneyPattern[3], toBeUpdated);
  });

  describe("when stop is inserted at a position which does not correspond to the stop's link's position in the route", () => {
    const toBeUpdated = {
      journey_pattern_id: journeyPatterns[0].journey_pattern_id,
      scheduled_stop_point_sequence: 450,
    };

    shouldReturnErrorResponse(
      scheduledStopPointInJourneyPattern[4],
      toBeUpdated,
      "route's and journey pattern's traversal paths must match each other",
    );

    shouldNotModifyDatabase(scheduledStopPointInJourneyPattern[3], toBeUpdated);
  });

  describe('when scheduled stop point is not associated with a timing place do not allow it to be set as a timing point in the journey pattern', () => {
    const toBeUpdated = {
      is_used_as_timing_point: true,
    };

    shouldReturnErrorResponse(
      scheduledStopPointInJourneyPattern[1],
      toBeUpdated,
      'scheduled stop point must have a timing place attached if it is used as a timing point in a journey pattern',
    );

    shouldNotModifyDatabase(scheduledStopPointInJourneyPattern[1], toBeUpdated);
  });

  describe('without conflict', () => {
    const original = scheduledStopPointInJourneyPattern[4];
    const toBeUpdated = {
      journey_pattern_id: journeyPatterns[0].journey_pattern_id,
      scheduled_stop_point_sequence: 250,
    };
    const completeUpdated = {
      ...original,
      ...toBeUpdated,
    };

    it('should return correct response', async () => {
      const response = await post({
        ...config.hasuraRequestTemplate,
        body: {
          query: buildMutation(
            original.journey_pattern_id,
            original.scheduled_stop_point_label,
            toBeUpdated,
          ),
        },
      });

      expect(response).toEqual(
        expect.objectContaining({
          data: {
            update_journey_pattern_scheduled_stop_point_in_journey_pattern: {
              returning: [completeUpdated],
            },
          },
        }),
      );
    });

    it('should update the database', async () => {
      await post({
        ...config.hasuraRequestTemplate,
        body: {
          query: buildMutation(
            original.journey_pattern_id,
            original.scheduled_stop_point_label,
            toBeUpdated,
          ),
        },
      });

      const response = await queryTable(
        dbConnection,
        genericNetworkDbSchema[
          'journey_pattern.scheduled_stop_point_in_journey_pattern'
        ],
      );

      expect(response.rowCount).toEqual(
        scheduledStopPointInJourneyPattern.length,
      );
      expect(response.rows).toEqual(
        expect.arrayContaining([
          ...scheduledStopPointInJourneyPattern.filter(
            (scheduledStopPoint) =>
              scheduledStopPoint.journey_pattern_id !==
                original.journey_pattern_id ||
              scheduledStopPoint.scheduled_stop_point_label !==
                original.scheduled_stop_point_label,
          ),
          completeUpdated,
        ]),
      );
    });
  });
});
