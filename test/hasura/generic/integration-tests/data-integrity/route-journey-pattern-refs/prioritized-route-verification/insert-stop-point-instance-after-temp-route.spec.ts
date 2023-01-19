import * as config from '@config';
import { prioritizedRouteVerificationWithTempRouteTableConfig } from '@datasets-generic/prioritizedRouteVerification';
import {
  scheduledStopPointsWithTempRoute,
  tempScheduledStopPointWithConflictingInfraLinkOrderValidAfterTempRoute,
  tempScheduledStopPointWithNonConflictingInfraLinkOrderValidAfterTempRoute,
} from '@datasets-generic/prioritizedRouteVerification/scheduled-stop-points';
import { serializeMatcherInput, serializeMatcherInputs } from '@util/dataset';
import '@util/matchers';
import { queryTable, setupDb } from '@util/setup';
import * as pg from 'pg';
import {
  insertStopPoint,
  shouldReturnCorrectScheduledStopPointResponse,
  shouldReturnErrorResponse,
} from './util';

describe('Insert scheduled stop point after temp route', () => {
  let dbConnectionPool: pg.Pool;

  beforeAll(() => {
    dbConnectionPool = new pg.Pool(config.networkDbConfig);
  });

  afterAll(() => dbConnectionPool.end());

  beforeEach(() =>
    setupDb(
      dbConnectionPool,
      prioritizedRouteVerificationWithTempRouteTableConfig,
    ),
  );

  describe("when stop order is conflicting with basic route's other validity span's stop order", () => {
    it('should return error response', async () => {
      await insertStopPoint(
        tempScheduledStopPointWithConflictingInfraLinkOrderValidAfterTempRoute,
      ).then(shouldReturnErrorResponse);
    });

    it('should not modify database', async () => {
      await insertStopPoint(
        tempScheduledStopPointWithConflictingInfraLinkOrderValidAfterTempRoute,
      );

      const stopResponse = await queryTable(
        dbConnectionPool,
        'service_pattern.scheduled_stop_point',
        prioritizedRouteVerificationWithTempRouteTableConfig,
      );

      expect(stopResponse.rowCount).toEqual(
        scheduledStopPointsWithTempRoute.length,
      );
      expect(stopResponse.rows).toEqual(
        expect.arrayContaining(
          serializeMatcherInputs(scheduledStopPointsWithTempRoute),
        ),
      );
    });
  });

  describe("when stop order is not conflicting with basic route's other validity span's stop order", () => {
    it('should return correct response', async () => {
      await insertStopPoint(
        tempScheduledStopPointWithNonConflictingInfraLinkOrderValidAfterTempRoute,
      ).then((response) =>
        shouldReturnCorrectScheduledStopPointResponse(
          tempScheduledStopPointWithNonConflictingInfraLinkOrderValidAfterTempRoute,
          response,
        ),
      );
    });

    it('should insert the correct row into the database', async () => {
      await insertStopPoint(
        tempScheduledStopPointWithNonConflictingInfraLinkOrderValidAfterTempRoute,
      );

      const stopResponse = await queryTable(
        dbConnectionPool,
        'service_pattern.scheduled_stop_point',
        prioritizedRouteVerificationWithTempRouteTableConfig,
      );

      expect(stopResponse.rowCount).toEqual(
        scheduledStopPointsWithTempRoute.length + 1,
      );
      expect(stopResponse.rows).toEqual(
        expect.arrayContaining([
          {
            ...serializeMatcherInput(
              tempScheduledStopPointWithNonConflictingInfraLinkOrderValidAfterTempRoute,
            ),
            scheduled_stop_point_id: expect.any(String),
          },
          ...serializeMatcherInputs(scheduledStopPointsWithTempRoute),
        ]),
      );
    });
  });
});
