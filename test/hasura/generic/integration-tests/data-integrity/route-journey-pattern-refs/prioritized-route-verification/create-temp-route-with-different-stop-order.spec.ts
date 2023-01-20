import * as config from '@config';
import { prioritizedRouteVerificationTableConfig } from '@datasets-generic/prioritizedRouteVerification';
import { scheduledStopPointInTempJourneyPatternWithoutConflictingOrderStop } from '@datasets-generic/prioritizedRouteVerification/journey-patterns';
import {
  infrastructureLinkAlongTempRouteWithSameLinks,
  tempRouteWithSameLinks,
} from '@datasets-generic/prioritizedRouteVerification/routes';
import { tempScheduledStopPointWithConflictingInfraLinkOrder } from '@datasets-generic/prioritizedRouteVerification/scheduled-stop-points';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import { newLocalDate } from '@util/helpers';
import '@util/matchers';
import { setupDb } from '@util/setup';
import {
  insertRoute,
  insertStopPoint,
  shouldInsertScheduledStopPointCorrectlyIntoDatabase,
  shouldNotModifyScheduledStopPointsInDatabase,
  shouldReturnCorrectInsertRouteResponse,
  shouldReturnCorrectScheduledStopPointResponse,
  shouldReturnErrorResponse,
} from './util';

describe('Creating a temporary route with different stop order', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(config.networkDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  beforeEach(() =>
    setupDb(dbConnection, prioritizedRouteVerificationTableConfig),
  );

  it('should fail when inserting the conflicting stop first', async () => {
    await insertStopPoint(
      tempScheduledStopPointWithConflictingInfraLinkOrder,
    ).then(shouldReturnErrorResponse);
    await shouldNotModifyScheduledStopPointsInDatabase(dbConnection);
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
      dbConnection,
      tempScheduledStopPointWithConflictingInfraLinkOrder,
    );
  });

  it('should fail when inserting a temp route with a validity time not covering that of the the stop', async () => {
    const tempRouteWithSameLinksAndTooShortValidityTime = {
      ...tempRouteWithSameLinks,
      validity_start: tempRouteWithSameLinks.validity_start,
      validity_end: newLocalDate(
        tempRouteWithSameLinks.validity_end!.getFullYear(), // eslint-disable-line @typescript-eslint/no-non-null-assertion
        tempRouteWithSameLinks.validity_end!.getMonth(), // eslint-disable-line @typescript-eslint/no-non-null-assertion
        tempRouteWithSameLinks.validity_end!.getDate() - 1, // eslint-disable-line @typescript-eslint/no-non-null-assertion
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
    await shouldNotModifyScheduledStopPointsInDatabase(dbConnection);
  });
});
