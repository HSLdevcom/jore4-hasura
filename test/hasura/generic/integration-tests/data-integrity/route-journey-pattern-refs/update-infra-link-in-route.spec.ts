import * as config from '@config';
import { routesAndJourneyPatternsTableConfig } from '@datasets-generic/routesAndJourneyPatterns';
import {
  infrastructureLinkAlongRoute,
  routes,
} from '@datasets-generic/routesAndJourneyPatterns/routes';
import {
  InfrastructureLinkAlongRoute,
  infrastructureLinkAlongRouteProps,
} from '@datasets-generic/types';
import * as dataset from '@util/dataset';
import '@util/matchers';
import { expectErrorResponse } from '@util/response';
import { getPropNameArray, queryTable, setupDb } from '@util/setup';
import * as pg from 'pg';
import * as rp from 'request-promise';

const buildMutation = (
  routeId: string,
  linkId: string,
  toBeUpdated: Partial<InfrastructureLinkAlongRoute>,
) => `
  mutation {
    update_route_infrastructure_link_along_route(where: {
      _and: {
        route_id: {_eq: "${routeId}"},
        infrastructure_link_id: {_eq: "${linkId}"},
      }
    },
    _set: ${dataset.toGraphQlObject(toBeUpdated)}
    ) {
      returning {
        ${getPropNameArray(infrastructureLinkAlongRouteProps).join(',')}
      }
    }
  }
`;

describe('Move infra link to other route', () => {
  let dbConnectionPool: pg.Pool;

  beforeAll(() => {
    dbConnectionPool = new pg.Pool(config.networkDbConfig);
  });

  afterAll(() => dbConnectionPool.end());

  beforeEach(() =>
    setupDb(dbConnectionPool, routesAndJourneyPatternsTableConfig),
  );

  describe('when there is a stop on the link', () => {
    const toBeMoved = infrastructureLinkAlongRoute[0];
    const toBeUpdated = {
      route_id: routes[2].route_id,
      infrastructure_link_sequence: 15,
    };

    it('should return error response', async () => {
      await rp
        .post({
          ...config.hasuraRequestTemplate,
          body: {
            query: buildMutation(
              toBeMoved.route_id,
              toBeMoved.infrastructure_link_id,
              toBeUpdated,
            ),
          },
        })
        .then(
          expectErrorResponse(
            "route's and journey pattern's traversal paths must match each other",
          ),
        );
    });

    it('should not modify the database', async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: {
          query: buildMutation(
            toBeMoved.route_id,
            toBeMoved.infrastructure_link_id,
            toBeUpdated,
          ),
        },
      });

      const response = await queryTable(
        dbConnectionPool,
        'route.infrastructure_link_along_route',
        routesAndJourneyPatternsTableConfig,
      );

      expect(response.rowCount).toEqual(infrastructureLinkAlongRoute.length);
      expect(response.rows).toEqual(
        expect.arrayContaining(infrastructureLinkAlongRoute),
      );
    });
  });

  describe('without conflict', () => {
    const toBeMoved = infrastructureLinkAlongRoute[4];
    const toBeUpdated = {
      route_id: routes[2].route_id,
      infrastructure_link_sequence: 15,
    };
    const completeUpdated = {
      ...toBeMoved,
      ...toBeUpdated,
    };

    it('should return correct response', async () => {
      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: {
          query: buildMutation(
            toBeMoved.route_id,
            toBeMoved.infrastructure_link_id,
            toBeUpdated,
          ),
        },
      });

      expect(response).toEqual(
        expect.objectContaining({
          data: {
            update_route_infrastructure_link_along_route: {
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
          query: buildMutation(
            toBeMoved.route_id,
            toBeMoved.infrastructure_link_id,
            toBeUpdated,
          ),
        },
      });

      const response = await queryTable(
        dbConnectionPool,
        'route.infrastructure_link_along_route',
        routesAndJourneyPatternsTableConfig,
      );

      expect(response.rowCount).toEqual(infrastructureLinkAlongRoute.length);
      expect(response.rows).toEqual(
        expect.arrayContaining([
          ...infrastructureLinkAlongRoute.filter(
            (link) =>
              link.route_id !== toBeMoved.route_id ||
              link.infrastructure_link_id !== toBeMoved.infrastructure_link_id,
          ),
          completeUpdated,
        ]),
      );
    });
  });
});
