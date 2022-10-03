import * as pg from 'pg';
import * as config from '@config';
import '@util/matchers';
import { setupDb } from '@datasets/setup';
import { prioritizedRouteVerificationTableConfig } from '@datasets/prioritizedRouteVerification';
import { tempScheduledStopPointWithConflictingInfraLinkOrder } from '@datasets/prioritizedRouteVerification/scheduled-stop-points';
import {
  infrastructureLinkAlongTempRouteWithSameLinks,
  tempRouteWithSameLinks,
} from '@datasets/prioritizedRouteVerification/routes';
import { scheduledStopPointInTempJourneyPatternWithoutConflictingOrderStop } from '@datasets/prioritizedRouteVerification/journey-patterns';
import {
  insertRoute,
  insertStopPoint,
  shouldInsertScheduledStopPointCorrectlyIntoDatabase,
  shouldNotModifyScheduledStopPointsInDatabase,
  shouldReturnCorrectInsertRouteResponse,
  shouldReturnCorrectScheduledStopPointResponse,
  shouldReturnErrorResponse,
} from './util';
import { newLocalDate } from '@util/helpers';

describe('Creating a temporary route with different stop order', () => {
  let dbConnectionPool: pg.Pool;

  beforeAll(() => {
    dbConnectionPool = new pg.Pool(config.databaseConfig);
  });

  afterAll(() => dbConnectionPool.end());

  beforeEach(() =>
    setupDb(dbConnectionPool, prioritizedRouteVerificationTableConfig),
  );

  it('should fail when inserting the conflicting stop first', async () => {
    await insertStopPoint(
      tempScheduledStopPointWithConflictingInfraLinkOrder,
    ).then(shouldReturnErrorResponse);
    await shouldNotModifyScheduledStopPointsInDatabase(dbConnectionPool);
  });

  it('should succeed when inserting the route before the conflicting stop', async () => {
    await insertRoute(
      tempRouteWithSameLinks,
      infrastructureLinkAlongTempRouteWithSameLinks,
      scheduledStopPointInTempJourneyPatternWithoutConflictingOrderStop,
    ).then((response) =>
      shouldReturnCorrectInsertRouteResponse(
        tempRouteWithSameLinks,
        infrastructureLinkAlongTempRouteWithSameLinks,
        scheduledStopPointInTempJourneyPatternWithoutConflictingOrderStop,
        response,
      ),
    );

    await insertStopPoint(
      tempScheduledStopPointWithConflictingInfraLinkOrder,
    ).then((response) =>
      shouldReturnCorrectScheduledStopPointResponse(
        tempScheduledStopPointWithConflictingInfraLinkOrder,
        response,
      ),
    );
    await shouldInsertScheduledStopPointCorrectlyIntoDatabase(
      dbConnectionPool,
      tempScheduledStopPointWithConflictingInfraLinkOrder,
    );
  });

  it('should fail when inserting a temp route with a validity time not covering that of the the stop', async () => {
    const tempRouteWithSameLinksAndTooShortValidityTime = {
      ...tempRouteWithSameLinks,
      validity_start: tempRouteWithSameLinks.validity_start,
      validity_end: newLocalDate(
        tempRouteWithSameLinks.validity_end!.getFullYear(),
        tempRouteWithSameLinks.validity_end!.getMonth(),
        tempRouteWithSameLinks.validity_end!.getDate() - 1,
      ),
    };
    await insertRoute(
      tempRouteWithSameLinksAndTooShortValidityTime,
      infrastructureLinkAlongTempRouteWithSameLinks,
      scheduledStopPointInTempJourneyPatternWithoutConflictingOrderStop,
    ).then((response) =>
      shouldReturnCorrectInsertRouteResponse(
        tempRouteWithSameLinksAndTooShortValidityTime,
        infrastructureLinkAlongTempRouteWithSameLinks,
        scheduledStopPointInTempJourneyPatternWithoutConflictingOrderStop,
        response,
      ),
    );

    await insertStopPoint(
      tempScheduledStopPointWithConflictingInfraLinkOrder,
    ).then(shouldReturnErrorResponse);
    await shouldNotModifyScheduledStopPointsInDatabase(dbConnectionPool);
  });
});
