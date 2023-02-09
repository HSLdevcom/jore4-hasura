import * as config from '@config';
import * as dataset from '@util/dataset';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import { expectErrorResponse } from '@util/response';
import { getPropNameArray, queryTable, setupDb } from '@util/setup';
import { routesAndJourneyPatternsTableData } from 'generic/networkdb/datasets/routesAndJourneyPatterns';
import {
  infrastructureLinkAlongRoute,
  routes,
} from 'generic/networkdb/datasets/routesAndJourneyPatterns/routes';
import { genericNetworkDbSchema } from 'generic/networkdb/datasets/schema';
import {
  InfrastructureLinkAlongRoute,
  infrastructureLinkAlongRouteProps,
} from 'generic/networkdb/datasets/types';
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
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(config.networkDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  beforeEach(() => setupDb(dbConnection, routesAndJourneyPatternsTableData));

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
        dbConnection,
        genericNetworkDbSchema['route.infrastructure_link_along_route'],
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
        dbConnection,
        genericNetworkDbSchema['route.infrastructure_link_along_route'],
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
