import * as config from '@config';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import { setupDb } from '@util/setup';
import {
  infrastructureLinkAlongTempRouteWithSameLinks,
  prioritizedRouteVerificationTableData,
  scheduledStopPointInTempJourneyPatternWithoutConflictingOrderStop,
  tempRouteWithSameLinks,
  tempScheduledStopPointWithConflictingInfraLinkOrder,
} from 'generic/networkdb/datasets/prioritizedRouteVerification';
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
    setupDb(dbConnection, prioritizedRouteVerificationTableData),
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
      // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
      validity_end: tempRouteWithSameLinks.validity_end!.minus({ day: 1 }),
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
