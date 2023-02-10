import * as config from '@config';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import { setupDb } from '@util/setup';
import { prioritizedRouteVerificationTableData } from 'generic/networkdb/datasets/prioritizedRouteVerification';
import {
  scheduledStopPointInTempJourneyPatternWithoutConflictingInfraLinkStop,
  scheduledStopPointInTempJourneyPatternWithSameStops,
} from 'generic/networkdb/datasets/prioritizedRouteVerification/journey-patterns';
import {
  infrastructureLinkAlongTempRouteWithOtherLinks,
  tempRouteWithOtherLinks,
} from 'generic/networkdb/datasets/prioritizedRouteVerification/routes';
import { tempScheduledStopPointOnInfraLinkNotPresentInBasicRoute } from 'generic/networkdb/datasets/prioritizedRouteVerification/scheduled-stop-points';
import {
  insertRoute,
  insertStopPoint,
  replaceJourneyPattern,
  shouldInsertScheduledStopPointCorrectlyIntoDatabase,
  shouldNotModifyScheduledStopPointsInDatabase,
  shouldReturnCorrectInsertRouteResponse,
  shouldReturnCorrectReplaceJourneyPatternResponse,
  shouldReturnCorrectScheduledStopPointResponse,
  shouldReturnErrorResponse,
} from './util';

describe('Creating a temporary route with different infra links', () => {
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
      tempScheduledStopPointOnInfraLinkNotPresentInBasicRoute,
    ).then(shouldReturnErrorResponse);
    await shouldNotModifyScheduledStopPointsInDatabase(dbConnection);
  });

  it('should succeed when inserting the route before the conflicting stop', async () => {
    // insert temp route and journey pattern without conflicting stop label
    await insertRoute(
      tempRouteWithOtherLinks,
      infrastructureLinkAlongTempRouteWithOtherLinks,
      scheduledStopPointInTempJourneyPatternWithoutConflictingInfraLinkStop,
    ).then((response) =>
      shouldReturnCorrectInsertRouteResponse(
        tempRouteWithOtherLinks,
        infrastructureLinkAlongTempRouteWithOtherLinks,
        scheduledStopPointInTempJourneyPatternWithoutConflictingInfraLinkStop,
        response,
      ),
    );

    // insert stop instance located on a link of the temp route
    await insertStopPoint(
      tempScheduledStopPointOnInfraLinkNotPresentInBasicRoute,
    ).then((response) =>
      shouldReturnCorrectScheduledStopPointResponse(
        tempScheduledStopPointOnInfraLinkNotPresentInBasicRoute,
        response,
      ),
    );
    await shouldInsertScheduledStopPointCorrectlyIntoDatabase(
      dbConnection,
      tempScheduledStopPointOnInfraLinkNotPresentInBasicRoute,
    );

    // include the stop label (whose temp instance is conflicting with the basic route) into the temp route's journet
    // pattern (for convenience reasons this is done by deleting the journey pattern and inseting a new one)
    await replaceJourneyPattern(
      tempRouteWithOtherLinks,
      scheduledStopPointInTempJourneyPatternWithSameStops,
    ).then((response) =>
      shouldReturnCorrectReplaceJourneyPatternResponse(
        tempRouteWithOtherLinks,
        response,
      ),
    );
  });

  it('should fail when inserting a temp route with a validity time not covering that of the the stop', async () => {
    const tempRouteWithOtherLinksAndTooShortValidityTime = {
      ...tempRouteWithOtherLinks,
      validity_start: tempRouteWithOtherLinks.validity_start,
      // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
      validity_end: tempRouteWithOtherLinks.validity_end!.minus({ day: 1 }),
    };

    // insert temp route and journey pattern without conflicting stop label
    await insertRoute(
      tempRouteWithOtherLinksAndTooShortValidityTime,
      infrastructureLinkAlongTempRouteWithOtherLinks,
      scheduledStopPointInTempJourneyPatternWithoutConflictingInfraLinkStop,
    ).then((response) =>
      shouldReturnCorrectInsertRouteResponse(
        tempRouteWithOtherLinksAndTooShortValidityTime,
        infrastructureLinkAlongTempRouteWithOtherLinks,
        scheduledStopPointInTempJourneyPatternWithoutConflictingInfraLinkStop,
        response,
      ),
    );

    // insert stop instance located on a link of the temp route
    await insertStopPoint(
      tempScheduledStopPointOnInfraLinkNotPresentInBasicRoute,
    ).then(shouldReturnErrorResponse);
    await shouldNotModifyScheduledStopPointsInDatabase(dbConnection);
  });

  it('should fail when inserting a temp route with a validity time longer than that of the the stop', async () => {
    const tempRouteWithOtherLinksAndTooLongValidityTime = {
      ...tempRouteWithOtherLinks,
      validity_start: tempRouteWithOtherLinks.validity_start,
      // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
      validity_end: tempRouteWithOtherLinks.validity_end!.plus({ day: 1 }),
    };

    // insert temp route and journey pattern without conflicting stop label
    await insertRoute(
      tempRouteWithOtherLinksAndTooLongValidityTime,
      infrastructureLinkAlongTempRouteWithOtherLinks,
      scheduledStopPointInTempJourneyPatternWithoutConflictingInfraLinkStop,
    ).then((response) =>
      shouldReturnCorrectInsertRouteResponse(
        tempRouteWithOtherLinksAndTooLongValidityTime,
        infrastructureLinkAlongTempRouteWithOtherLinks,
        scheduledStopPointInTempJourneyPatternWithoutConflictingInfraLinkStop,
        response,
      ),
    );

    // insert stop instance located on a link of the temp route
    await insertStopPoint(
      tempScheduledStopPointOnInfraLinkNotPresentInBasicRoute,
    ).then((response) =>
      shouldReturnCorrectScheduledStopPointResponse(
        tempScheduledStopPointOnInfraLinkNotPresentInBasicRoute,
        response,
      ),
    );
    await shouldInsertScheduledStopPointCorrectlyIntoDatabase(
      dbConnection,
      tempScheduledStopPointOnInfraLinkNotPresentInBasicRoute,
    );

    // include the stop label (whose temp instance is conflicting with the basic route) into the temp route's journet
    // pattern (for convenience reasons this is done by deleting the journey pattern and inseting a new one)
    await replaceJourneyPattern(
      tempRouteWithOtherLinksAndTooLongValidityTime,
      scheduledStopPointInTempJourneyPatternWithSameStops,
    ).then(shouldReturnErrorResponse);
  });
});
