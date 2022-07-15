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
  basicJourneyPattern,
  scheduledStopPointInTempJourneyPatternWithoutConflictingInfraLinkStop,
  scheduledStopPointInTempJourneyPatternWithSameStops,
} from '@datasets/prioritizedRouteVerification/journey-patterns';
import {
  checkInfraLinkStopRefsForStopPointRemoval,
  deleteRoute,
  deleteStopPoint,
  insertRoute,
  insertStopPoint,
  replaceJourneyPattern,
  shouldReturnCorrectInsertRouteResponse,
  shouldReturnCorrectReplaceJourneyPatternResponse,
  shouldReturnCorrectScheduledStopPointResponse,
} from './util';
import { expectErrorResponse } from '@util/response';

describe('Removing a temporary...', () => {
  let dbConnectionPool: pg.Pool;

  beforeAll(() => {
    dbConnectionPool = new pg.Pool(config.databaseConfig);
  });

  afterAll(() => dbConnectionPool.end());

  beforeEach(() =>
    setupDb(dbConnectionPool, prioritizedRouteVerificationTableConfig),
  );

  it('...route should fail if the underlying basic route is in conflict with the stop points', async () => {
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

    // include the stop label (whose temp instance is conflicting with the basic route) into the temp route's journet
    // pattern (for convenience reasons this is done by deleting the journey pattern and inserting a new one)
    await replaceJourneyPattern(
      tempRouteWithOtherLinks,
      scheduledStopPointInTempJourneyPatternWithSameStops,
    ).then((response) =>
      shouldReturnCorrectReplaceJourneyPatternResponse(
        tempRouteWithOtherLinks,
        response,
      ),
    );

    await deleteRoute(tempRouteWithOtherLinks.route_id).then(
      expectErrorResponse,
    );
  });

  it('...stop should fail if the route is in conflict with the underlying basic stop point', async () => {
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

    await deleteStopPoint(
      tempScheduledStopPointOnInfraLinkNotPresentInBasicRoute.label,
      tempScheduledStopPointOnInfraLinkNotPresentInBasicRoute.priority,
    ).then(expectErrorResponse);
  });

  it('...stop point check should fail if the route is in conflict with the underlying basic stop point', async () => {
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

    // include the stop label (whose temp instance is conflicting with the basic route) into the temp route's journet
    // pattern (for convenience reasons this is done by deleting the journey pattern and inseting a new one)
    await replaceJourneyPattern(
      tempRouteWithOtherLinks,
      scheduledStopPointInTempJourneyPatternWithSameStops,
    ).then(async (replaceJourneyPatternResponse) => {
      shouldReturnCorrectReplaceJourneyPatternResponse(
        tempRouteWithOtherLinks,
        replaceJourneyPatternResponse,
      );

      const tempJourneyPatternId =
        replaceJourneyPatternResponse.data
          .insert_journey_pattern_journey_pattern.returning[0]
          .journey_pattern_id;

      await checkInfraLinkStopRefsForStopPointRemoval(
        tempScheduledStopPointOnInfraLinkNotPresentInBasicRoute,
      ).then((response) => {
        expect(response).toEqual(
          expect.objectContaining({
            data: {
              journey_pattern_check_infra_link_stop_refs_with_new_scheduled_stop_point:
                expect.arrayContaining([
                  {
                    journey_pattern_id: tempJourneyPatternId,
                    on_route_id: expect.any(String),
                  },
                ]),
            },
          }),
        );

        expect(
          response.data
            .journey_pattern_check_infra_link_stop_refs_with_new_scheduled_stop_point
            .length,
        ).toEqual(1);
      });
    });
  });
});
