import * as config from '@config';
import { routesAndJourneyPatternsTableConfig } from '@datasets-generic/routesAndJourneyPatterns';
import { journeyPatterns } from '@datasets-generic/routesAndJourneyPatterns/journey-patterns';
import { routes } from '@datasets-generic/routesAndJourneyPatterns/routes';
import { journeyPatternProps } from '@datasets-generic/types';
import '@util/matchers';
import { expectErrorResponse } from '@util/response';
import { getPropNameArray, queryTable, setupDb } from '@util/setup';
import * as pg from 'pg';
import * as rp from 'request-promise';

const buildMutation = (journeyPatternId: string, newRouteId: string) => `
  mutation {
    update_journey_pattern_journey_pattern(where: {
        journey_pattern_id: {_eq: "${journeyPatternId}"}
      },
      _set: {
        on_route_id: "${newRouteId}"
      }
    ) {
      returning {
        ${getPropNameArray(journeyPatternProps).join(',')}
      }
    }
  }
`;

describe('Move journey pattern to other route', () => {
  let dbConnectionPool: pg.Pool;

  beforeAll(() => {
    dbConnectionPool = new pg.Pool(config.networkDbConfig);
  });

  afterAll(() => dbConnectionPool.end());

  beforeEach(() =>
    setupDb(dbConnectionPool, routesAndJourneyPatternsTableConfig),
  );

  const shouldReturnErrorMessage = (
    journeyPatternId: string,
    newRouteId: string,
    expectedErrorMessage: string,
  ) =>
    it('should return error response', async () => {
      await rp
        .post({
          ...config.hasuraRequestTemplate,
          body: {
            query: buildMutation(journeyPatternId, newRouteId),
          },
        })
        .then(expectErrorResponse(expectedErrorMessage));
    });

  const shouldNotModifyDatabase = (
    journeyPatternId: string,
    newRouteId: string,
  ) =>
    it('should not modify the database', async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: {
          query: buildMutation(journeyPatternId, newRouteId),
        },
      });

      const response = await queryTable(
        dbConnectionPool,
        'journey_pattern.journey_pattern',
        routesAndJourneyPatternsTableConfig,
      );

      expect(response.rowCount).toEqual(journeyPatterns.length);
      expect(response.rows).toEqual(expect.arrayContaining(journeyPatterns));
    });

  describe('when new route does not contain all links on which the stops reside', () => {
    shouldReturnErrorMessage(
      journeyPatterns[0].journey_pattern_id,
      routes[3].route_id,
      "route's and journey pattern's traversal paths must match each other",
    );

    shouldNotModifyDatabase(
      journeyPatterns[0].journey_pattern_id,
      routes[3].route_id,
    );
  });

  describe('when new route traverses a link of a stop in the wrong direction', () => {
    shouldReturnErrorMessage(
      journeyPatterns[1].journey_pattern_id,
      routes[4].route_id,
      "route's and journey pattern's traversal paths must match each other",
    );

    shouldNotModifyDatabase(
      journeyPatterns[1].journey_pattern_id,
      routes[4].route_id,
    );
  });

  describe('without conflict', () => {
    const toBeMoved = journeyPatterns[1];
    const newRouteId = routes[3].route_id;
    const completeUpdated = {
      ...toBeMoved,
      on_route_id: newRouteId,
    };

    it('should return correct response', async () => {
      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: {
          query: buildMutation(toBeMoved.journey_pattern_id, newRouteId),
        },
      });

      expect(response).toEqual(
        expect.objectContaining({
          data: {
            update_journey_pattern_journey_pattern: {
              returning: [completeUpdated],
            },
          },
        }),
      );
    });

    it('should update the database', async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: {
          query: buildMutation(toBeMoved.journey_pattern_id, newRouteId),
        },
      });

      const response = await queryTable(
        dbConnectionPool,
        'journey_pattern.journey_pattern',
        routesAndJourneyPatternsTableConfig,
      );

      expect(response.rowCount).toEqual(journeyPatterns.length);
      expect(response.rows).toEqual(
        expect.arrayContaining([
          ...journeyPatterns.filter(
            (journeyPattern) =>
              journeyPattern.journey_pattern_id !==
              toBeMoved.journey_pattern_id,
          ),
          completeUpdated,
        ]),
      );
    });
  });
});
