import * as config from '@config';
import { prioritizedRouteVerificationTableConfig } from '@datasets-generic/prioritizedRouteVerification';
import {
  scheduledStopPointInTempJourneyPatternWithoutConflictingInfraLinkStop,
  scheduledStopPointInTempJourneyPatternWithSameStops,
} from '@datasets-generic/prioritizedRouteVerification/journey-patterns';
import {
  infrastructureLinkAlongTempRouteWithOtherLinks,
  tempRouteWithOtherLinks,
} from '@datasets-generic/prioritizedRouteVerification/routes';
import { tempScheduledStopPointOnInfraLinkNotPresentInBasicRoute } from '@datasets-generic/prioritizedRouteVerification/scheduled-stop-points';
import { setupDb } from '@datasets-generic/setup';
import { newLocalDate } from '@util/helpers';
import '@util/matchers';
import * as pg from 'pg';
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
        tempRouteWithOtherLinks.validity_end!.getFullYear(), // eslint-disable-line @typescript-eslint/no-non-null-assertion
        tempRouteWithOtherLinks.validity_end!.getMonth(), // eslint-disable-line @typescript-eslint/no-non-null-assertion
        tempRouteWithOtherLinks.validity_end!.getDate() - 1, // eslint-disable-line @typescript-eslint/no-non-null-assertion
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
        tempRouteWithOtherLinks.validity_end!.getFullYear(), // eslint-disable-line @typescript-eslint/no-non-null-assertion
        tempRouteWithOtherLinks.validity_end!.getMonth(), // eslint-disable-line @typescript-eslint/no-non-null-assertion
        tempRouteWithOtherLinks.validity_end!.getDate() + 1, // eslint-disable-line @typescript-eslint/no-non-null-assertion
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