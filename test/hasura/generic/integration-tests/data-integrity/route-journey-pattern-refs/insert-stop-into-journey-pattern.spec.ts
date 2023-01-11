import * as config from '@config';
import { routesAndJourneyPatternsTableConfig } from '@datasets/routesAndJourneyPatterns';
import {
  journeyPatterns,
  scheduledStopPointInJourneyPattern,
} from '@datasets/routesAndJourneyPatterns/journey-patterns';
import { scheduledStopPoints } from '@datasets/routesAndJourneyPatterns/scheduled-stop-points';
import { getPropNameArray, queryTable, setupDb } from '@datasets/setup';
import {
  ScheduledStopPointInJourneyPattern,
  ScheduledStopPointInJourneyPatternProps,
} from '@datasets/types';
import * as dataset from '@util/dataset';
import '@util/matchers';
import { expectErrorResponse } from '@util/response';
import * as pg from 'pg';
import * as rp from 'request-promise';

const createToBeInserted = (
  journeyPatternId: string,
  scheduledStopPointLabel: string,
  scheduledStopPointSequence: number,
  isUsedAsTimingPoint = false,
): ScheduledStopPointInJourneyPattern => ({
  journey_pattern_id: journeyPatternId,
  scheduled_stop_point_label: scheduledStopPointLabel,
  scheduled_stop_point_sequence: scheduledStopPointSequence,
  is_via_point: false,
  is_used_as_timing_point: isUsedAsTimingPoint,
  is_loading_time_allowed: false,
  via_point_name_i18n: null,
  via_point_short_name_i18n: null,
});

const buildMutation = (toBeInserted: ScheduledStopPointInJourneyPattern) => `
  mutation {
    insert_journey_pattern_scheduled_stop_point_in_journey_pattern(objects: ${dataset.toGraphQlObject(
      toBeInserted,
    )}) {
      returning {
        ${getPropNameArray(ScheduledStopPointInJourneyPatternProps).join(',')}
      }
    }
  }
`;

describe('Insert scheduled stop point into journey pattern', () => {
  let dbConnectionPool: pg.Pool;

  beforeAll(() => {
    dbConnectionPool = new pg.Pool(config.databaseConfig);
  });

  afterAll(() => dbConnectionPool.end());

  beforeEach(() =>
    setupDb(dbConnectionPool, routesAndJourneyPatternsTableConfig),
  );

  const shouldReturnErrorResponse = (
    toBeInserted: ScheduledStopPointInJourneyPattern,
    expectedErrorMsg: string,
  ) =>
    it('should return error response', async () => {
      await rp
        .post({
          ...config.hasuraRequestTemplate,
          body: { query: buildMutation(toBeInserted) },
        })
        .then(expectErrorResponse(expectedErrorMsg));
    });

  const shouldNotModifyDatabase = (
    toBeInserted: ScheduledStopPointInJourneyPattern,
  ) =>
    it('should not modify the database', async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeInserted) },
      });

      const response = await queryTable(
        dbConnectionPool,
        'journey_pattern.scheduled_stop_point_in_journey_pattern',
        routesAndJourneyPatternsTableConfig,
      );

      expect(response.rowCount).toEqual(
        scheduledStopPointInJourneyPattern.length,
      );
      expect(response.rows).toEqual(
        expect.arrayContaining(scheduledStopPointInJourneyPattern),
      );
    });

  const shouldReturnCorrectResponse = (
    toBeInserted: ScheduledStopPointInJourneyPattern,
  ) =>
    it('should return correct response', async () => {
      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeInserted) },
      });

      expect(response).toEqual(
        expect.objectContaining({
          data: {
            insert_journey_pattern_scheduled_stop_point_in_journey_pattern: {
              returning: [toBeInserted],
            },
          },
        }),
      );
    });

  const shouldUpdateTheDatabase = (
    toBeInserted: ScheduledStopPointInJourneyPattern,
  ) =>
    it('should update the database', async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeInserted) },
      });

      const response = await queryTable(
        dbConnectionPool,
        'journey_pattern.scheduled_stop_point_in_journey_pattern',
        routesAndJourneyPatternsTableConfig,
      );

      expect(response.rowCount).toEqual(
        scheduledStopPointInJourneyPattern.length + 1,
      );
      expect(response.rows).toEqual(
        expect.arrayContaining([
          ...scheduledStopPointInJourneyPattern,
          toBeInserted,
        ]),
      );
    });

  describe('when stop is on a link not included in the route', () => {
    const toBeInserted = createToBeInserted(
      journeyPatterns[0].journey_pattern_id,
      scheduledStopPoints[3].label,
      150,
    );

    shouldReturnErrorResponse(
      toBeInserted,
      "route's and journey pattern's traversal paths must match each other",
    );

    shouldNotModifyDatabase(toBeInserted);
  });

  describe('when stop is on a link not included in a draft route', () => {
    const toBeInserted = createToBeInserted(
      journeyPatterns[3].journey_pattern_id,
      scheduledStopPoints[3].label,
      150,
    );

    shouldReturnCorrectResponse(toBeInserted);

    shouldUpdateTheDatabase(toBeInserted);
  });

  describe("when stop is inserted at a position which does not correspond to the stop's link's position in the route", () => {
    const toBeInserted = createToBeInserted(
      journeyPatterns[0].journey_pattern_id,
      scheduledStopPoints[1].label,
      50,
    );

    shouldReturnErrorResponse(
      toBeInserted,
      "route's and journey pattern's traversal paths must match each other",
    );

    shouldNotModifyDatabase(toBeInserted);
  });

  describe("when stop is inserted at a position which does not correspond to the stop's link's position in a draft route", () => {
    const toBeInserted = createToBeInserted(
      journeyPatterns[3].journey_pattern_id,
      scheduledStopPoints[1].label,
      50,
    );

    shouldReturnCorrectResponse(toBeInserted);

    shouldUpdateTheDatabase(toBeInserted);
  });

  describe("when stop's link is traversed in a direction not matching the stop's direction", () => {
    const toBeInserted = createToBeInserted(
      journeyPatterns[0].journey_pattern_id,
      scheduledStopPoints[5].label,
      250,
    );

    shouldReturnErrorResponse(
      toBeInserted,
      "route's and journey pattern's traversal paths must match each other",
    );

    shouldNotModifyDatabase(toBeInserted);
  });

  describe("when stop's validity time does not overlap with route's validity time", () => {
    const toBeInserted = createToBeInserted(
      journeyPatterns[0].journey_pattern_id,
      scheduledStopPoints[9].label,
      250,
    );

    shouldReturnErrorResponse(
      toBeInserted,
      "route's and journey pattern's traversal paths must match each other",
    );

    shouldNotModifyDatabase(toBeInserted);
  });

  describe("when stop's link is traversed on a draft route in a direction not matching the stop's direction", () => {
    const toBeInserted = createToBeInserted(
      journeyPatterns[3].journey_pattern_id,
      scheduledStopPoints[5].label,
      250,
    );

    shouldReturnCorrectResponse(toBeInserted);

    shouldUpdateTheDatabase(toBeInserted);
  });

  describe('when stop is used as timing point but no timing place exists for the stop', () => {
    const toBeInserted = createToBeInserted(
      journeyPatterns[0].journey_pattern_id,
      scheduledStopPoints[1].label,
      250,
      true,
    );

    shouldReturnErrorResponse(
      toBeInserted,
      'scheduled stop point must have a timing place attached if it is used as a timing point in a journey pattern',
    );

    shouldNotModifyDatabase(toBeInserted);
  });

  describe('without conflict', () => {
    const toBeInserted = createToBeInserted(
      journeyPatterns[0].journey_pattern_id,
      scheduledStopPoints[1].label,
      250,
    );

    shouldReturnCorrectResponse(toBeInserted);

    shouldUpdateTheDatabase(toBeInserted);
  });
});
