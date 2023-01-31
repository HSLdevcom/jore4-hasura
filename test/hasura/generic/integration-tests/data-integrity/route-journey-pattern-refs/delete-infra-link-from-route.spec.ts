import * as config from '@config';
import { routesAndJourneyPatternsTableData } from '@datasets-generic/routesAndJourneyPatterns';
import { infrastructureLinkAlongRoute } from '@datasets-generic/routesAndJourneyPatterns/routes';
import { genericNetworkDbSchema } from '@datasets-generic/schema';
import {
  InfrastructureLinkAlongRoute,
  infrastructureLinkAlongRouteProps,
} from '@datasets-generic/types';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import '@util/matchers';
import { expectErrorResponse } from '@util/response';
import { getPropNameArray, queryTable, setupDb } from '@util/setup';
import * as rp from 'request-promise';

const buildMutation = (routeId: string, linkId: string) => `
  mutation {
    delete_route_infrastructure_link_along_route(where: {
      _and: {
        route_id: {_eq: "${routeId}"},
        infrastructure_link_id: {_eq: "${linkId}"},
      }
    }) {
      returning {
        ${getPropNameArray(infrastructureLinkAlongRouteProps).join(',')}
      }
    }
  }
`;

describe('Delete infra link from route', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(config.networkDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  beforeEach(() => setupDb(dbConnection, routesAndJourneyPatternsTableData));

  const postHasuraRequest = (toBeRemoved: InfrastructureLinkAlongRoute) =>
    rp.post({
      ...config.hasuraRequestTemplate,
      body: {
        query: buildMutation(
          toBeRemoved.route_id,
          toBeRemoved.infrastructure_link_id,
        ),
      },
    });

  describe('when there is a stop on the link', () => {
    const toBeRemoved = infrastructureLinkAlongRoute[1];

    it('should return error response', async () => {
      await postHasuraRequest(toBeRemoved).then(
        expectErrorResponse(
          "route's and journey pattern's traversal paths must match each other",
        ),
      );
    });

    it('should not modify the database', async () => {
      await postHasuraRequest(toBeRemoved);

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
    const toBeRemoved = infrastructureLinkAlongRoute[4];

    it('should return correct response', async () => {
      const response = await postHasuraRequest(toBeRemoved);

      expect(response).toEqual(
        expect.objectContaining({
          data: {
            delete_route_infrastructure_link_along_route: {
              returning: [toBeRemoved],
            },
          },
        }),
      );
    });

    it('should update the database', async () => {
      await postHasuraRequest(toBeRemoved);

      const response = await queryTable(
        dbConnection,
        genericNetworkDbSchema['route.infrastructure_link_along_route'],
      );

      expect(response.rowCount).toEqual(
        infrastructureLinkAlongRoute.length - 1,
      );
      expect(response.rows).toEqual(
        expect.arrayContaining(
          infrastructureLinkAlongRoute.filter(
            (link) =>
              link.route_id !== toBeRemoved.route_id ||
              link.infrastructure_link_id !==
                toBeRemoved.infrastructure_link_id,
          ),
        ),
      );
    });
  });
});
