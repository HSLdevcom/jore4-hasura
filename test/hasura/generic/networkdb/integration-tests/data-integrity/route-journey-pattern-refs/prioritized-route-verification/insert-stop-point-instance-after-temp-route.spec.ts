import * as config from '@config';
import { serializeMatcherInput, serializeMatcherInputs } from '@util/dataset';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import { queryTable, setupDb } from '@util/setup';
import { prioritizedRouteVerificationWithTempRouteTableData } from 'generic/networkdb/datasets/prioritizedRouteVerification';
import {
  scheduledStopPointsWithTempRoute,
  tempScheduledStopPointWithConflictingInfraLinkOrderValidAfterTempRoute,
  tempScheduledStopPointWithNonConflictingInfraLinkOrderValidAfterTempRoute,
} from 'generic/networkdb/datasets/prioritizedRouteVerification/scheduled-stop-points';
import { genericNetworkDbSchema } from 'generic/networkdb/datasets/schema';
import {
  insertStopPoint,
  shouldReturnCorrectScheduledStopPointResponse,
  shouldReturnErrorResponse,
} from './util';

describe('Insert scheduled stop point after temp route', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(config.networkDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  beforeEach(() =>
    setupDb(dbConnection, prioritizedRouteVerificationWithTempRouteTableData),
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
        dbConnection,
        genericNetworkDbSchema['service_pattern.scheduled_stop_point'],
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
        dbConnection,
        genericNetworkDbSchema['service_pattern.scheduled_stop_point'],
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
