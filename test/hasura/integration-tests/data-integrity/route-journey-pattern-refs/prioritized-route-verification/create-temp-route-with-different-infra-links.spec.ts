import * as pg from 'pg';
import * as config from '@config';
import '@util/matchers';
import { setupDb } from '@datasets/setup';
import { prioritizedRouteVerificationTableConfig } from '@datasets/prioritizedRouteVerification';
import { tempScheduledStopPointOnInfraLinkNotPresentInBasicRoute } from '@datasets/prioritizedRouteVerification/scheduled-stop-points';
import {
  infrastructureLinkAlongTempRouteWithOtherLinks,
  tempRouteWithOtherLinks,
} from '@datasets/prioritizedRouteVerification/routes';
import {
  scheduledStopPointInTempJourneyPatternWithoutConflictingInfraLinkStop,
  scheduledStopPointInTempJourneyPatternWithSameStops,
} from '@datasets/prioritizedRouteVerification/journey-patterns';
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
import { newLocalDate } from '@util/helpers';

describe('Creating a temporary route with different infra links', () => {
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
      tempScheduledStopPointOnInfraLinkNotPresentInBasicRoute,
    ).then(shouldReturnErrorResponse);
    await shouldNotModifyScheduledStopPointsInDatabase(dbConnectionPool);
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
      dbConnectionPool,
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
      validity_end: newLocalDate(
        tempRouteWithOtherLinks.validity_end!.getFullYear(),
        tempRouteWithOtherLinks.validity_end!.getMonth(),
        tempRouteWithOtherLinks.validity_end!.getDate() - 1,
      ),
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
    await shouldNotModifyScheduledStopPointsInDatabase(dbConnectionPool);
  });

  it('should fail when inserting a temp route with a validity time longer than that of the the stop', async () => {
    const tempRouteWithOtherLinksAndTooLongValidityTime = {
      ...tempRouteWithOtherLinks,
      validity_start: tempRouteWithOtherLinks.validity_start,
      validity_end: newLocalDate(
        tempRouteWithOtherLinks.validity_end!.getFullYear(),
        tempRouteWithOtherLinks.validity_end!.getMonth(),
        tempRouteWithOtherLinks.validity_end!.getDate() + 1,
      ),
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
      dbConnectionPool,
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
