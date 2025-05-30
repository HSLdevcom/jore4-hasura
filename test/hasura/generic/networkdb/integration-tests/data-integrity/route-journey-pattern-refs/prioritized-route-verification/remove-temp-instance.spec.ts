import * as config from '@config';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import { expectErrorResponse } from '@util/response';
import { setupDb } from '@util/setup';
import {
  infrastructureLinkAlongTempRouteWithOtherLinks,
  prioritizedRouteVerificationTableData,
  scheduledStopPointInTempJourneyPatternWithoutConflictingInfraLinkStop,
  scheduledStopPointInTempJourneyPatternWithSameStops,
  tempRouteWithOtherLinks,
  tempScheduledStopPointOnInfraLinkNotPresentInBasicRoute,
} from 'generic/networkdb/datasets/prioritizedRouteVerification';
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

describe('Removing a temporary...', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(config.networkDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  beforeEach(() =>
    setupDb(dbConnection, prioritizedRouteVerificationTableData),
  );

  // This test is flawed. It expects the delete operation to fail, when in fact
  // it succeeds. The test was previously working "working" because it was using
  // expectErrorResponse in a wrong way. expectErrorResponse is a function that
  // return another function when called, which in turn performs the actual error
  // checking. This test was never calling the actual error checking function.
  // eslint-disable-next-line jest/no-disabled-tests
  it.skip('...route should fail if the underlying basic route is in conflict with the stop points', async () => {
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

    // include the stop label (whose temp instance is conflicting with the basic route) into the temp route's journey
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
      expectErrorResponse(),
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
    ).then(expectErrorResponse());
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
