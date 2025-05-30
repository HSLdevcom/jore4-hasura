import * as config from '@config';
import * as dataset from '@util/dataset';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import { post } from '@util/fetch-request';
import { expectErrorResponse } from '@util/response';
import { getPropNameArray, queryTable, setupDb } from '@util/setup';
import {
  defaultGenericNetworkDbData,
  infrastructureLinkAlongRoute,
  infrastructureLinks,
  lines,
  routes,
} from 'generic/networkdb/datasets/defaultSetup';
import { buildRoute } from 'generic/networkdb/datasets/factories';
import { genericNetworkDbSchema } from 'generic/networkdb/datasets/schema';
import {
  InfrastructureLinkAlongRoute,
  Route,
  RouteDirection,
  routeProps,
} from 'generic/networkdb/datasets/types';
import { DateTime } from 'luxon';

const routeToBeInserted: Partial<Route> = {
  ...buildRoute('new route'),
  on_line_id: lines[1].line_id,
  direction: RouteDirection.Clockwise,
  priority: lines[1].priority + 10,
  validity_start: DateTime.fromISO('2044-05-01'),
  validity_end: DateTime.fromISO('2045-04-30'),
};

const createLinksToBeInserted = (
  infrastructureLinkId: string,
  isTraversalForwards: boolean,
): Partial<InfrastructureLinkAlongRoute>[] => [
  {
    infrastructure_link_id: infrastructureLinks[4].infrastructure_link_id,
    infrastructure_link_sequence: 0,
    is_traversal_forwards: true,
  },
  {
    infrastructure_link_id: infrastructureLinks[5].infrastructure_link_id,
    infrastructure_link_sequence: 4,
    is_traversal_forwards: true,
  },
  {
    infrastructure_link_id: infrastructureLinkId,
    infrastructure_link_sequence: 2,
    is_traversal_forwards: isTraversalForwards,
  },
];

const buildMutation = (
  linksToBeInserted: Partial<InfrastructureLinkAlongRoute>[],
) => `
  mutation {
    insert_route_route(objects: ${dataset.toGraphQlObject(
      {
        ...routeToBeInserted,
        infrastructure_links_along_route: {
          data: linksToBeInserted,
        },
      },
      ['direction', 'is_traversal_forwards'],
    )}) {
      returning {
        ${getPropNameArray(routeProps).join(',')}
      }
    }
  }
`;

describe('Insert route with links', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(config.networkDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  beforeEach(() => setupDb(dbConnection, defaultGenericNetworkDbData));

  describe("containing a link whose direction conflicts with its infrastructure link's direction", () => {
    const shouldReturnErrorResponse = (
      linksToBeInserted: Partial<InfrastructureLinkAlongRoute>[],
    ) =>
      it('should return error response', async () => {
        await post({
          ...config.hasuraRequestTemplate,
          body: {
            query: buildMutation(linksToBeInserted),
          },
        }).then(
          expectErrorResponse(
            'route link direction must be compatible with infrastructure link direction',
          ),
        );
      });

    const shouldNotModifyDatabase = (
      linksToBeInserted: Partial<InfrastructureLinkAlongRoute>[],
    ) =>
      it('should not modify the database', async () => {
        await post({
          ...config.hasuraRequestTemplate,
          body: { query: buildMutation(linksToBeInserted) },
        });

        const routeResponse = await queryTable(
          dbConnection,
          genericNetworkDbSchema['route.route'],
        );

        expect(routeResponse.rowCount).toEqual(routes.length);
        expect(routeResponse.rows).toEqual(expect.arrayContaining(routes));

        const infraLinksResponse = await queryTable(
          dbConnection,
          genericNetworkDbSchema['route.infrastructure_link_along_route'],
        );

        expect(infraLinksResponse.rowCount).toEqual(
          infrastructureLinkAlongRoute.length,
        );
        expect(infraLinksResponse.rows).toEqual(
          expect.arrayContaining(infrastructureLinkAlongRoute),
        );
      });

    describe('infrastructure link direction "forward", route link traversal backward', () => {
      const linksToBeInserted = createLinksToBeInserted(
        infrastructureLinks[4].infrastructure_link_id,
        false,
      );

      shouldReturnErrorResponse(linksToBeInserted);

      shouldNotModifyDatabase(linksToBeInserted);
    });

    describe('infrastructure link direction "backward", route link traversal forward', () => {
      const linksToBeInserted = createLinksToBeInserted(
        infrastructureLinks[6].infrastructure_link_id,
        true,
      );

      shouldReturnErrorResponse(linksToBeInserted);

      shouldNotModifyDatabase(linksToBeInserted);
    });
  });

  describe("whose direction does NOT conflict with its infrastructure link's direction", () => {
    const shouldReturnCorrectResponse = (
      linksToBeInserted: Partial<InfrastructureLinkAlongRoute>[],
    ) =>
      it('should return correct response', async () => {
        const response = await post({
          ...config.hasuraRequestTemplate,
          body: { query: buildMutation(linksToBeInserted) },
        });

        expect(response).toEqual(
          expect.objectContaining({
            data: {
              insert_route_route: {
                returning: [
                  {
                    ...dataset.asGraphQlDateObject(routeToBeInserted),
                    route_id: expect.any(String),
                  },
                ],
              },
            },
          }),
        );

        // check the new ID is a valid UUID
        expect(
          response.data.insert_route_route.returning[0].route_id,
        ).toBeValidUuid();
      });

    const shouldInsertCorrectRowsIntoDatabase = (
      linksToBeInserted: Partial<InfrastructureLinkAlongRoute>[],
    ) =>
      it('should insert correct row into the database', async () => {
        await post({
          ...config.hasuraRequestTemplate,
          body: { query: buildMutation(linksToBeInserted) },
        });

        const routeResponse = await queryTable(
          dbConnection,
          genericNetworkDbSchema['route.route'],
        );

        expect(routeResponse.rowCount).toEqual(routes.length + 1);
        expect(routeResponse.rows).toEqual(
          expect.arrayContaining([
            {
              ...routeToBeInserted,
              route_id: expect.any(String),
            },
            ...routes,
          ]),
        );

        const infraLinksResponse = await queryTable(
          dbConnection,
          genericNetworkDbSchema['route.infrastructure_link_along_route'],
        );

        expect(infraLinksResponse.rowCount).toEqual(
          infrastructureLinkAlongRoute.length + linksToBeInserted.length,
        );
        expect(infraLinksResponse.rows).toEqual(
          expect.arrayContaining([
            ...infrastructureLinkAlongRoute,
            ...linksToBeInserted.map((link) => ({
              ...link,
              route_id: expect.any(String),
            })),
          ]),
        );
      });

    describe('infrastructure link direction "forward", route link traversal forward', () => {
      const linksToBeInserted = createLinksToBeInserted(
        infrastructureLinks[4].infrastructure_link_id,
        true,
      );

      shouldReturnCorrectResponse(linksToBeInserted);

      shouldInsertCorrectRowsIntoDatabase(linksToBeInserted);
    });

    describe('infrastructure link direction "backward", route link traversal backward', () => {
      const linksToBeInserted = createLinksToBeInserted(
        infrastructureLinks[6].infrastructure_link_id,
        false,
      );

      shouldReturnCorrectResponse(linksToBeInserted);

      shouldInsertCorrectRowsIntoDatabase(linksToBeInserted);
    });

    describe('infrastructure link direction "bidirectional", route link traversal forward', () => {
      const linksToBeInserted = createLinksToBeInserted(
        infrastructureLinks[5].infrastructure_link_id,
        true,
      );

      shouldReturnCorrectResponse(linksToBeInserted);

      shouldInsertCorrectRowsIntoDatabase(linksToBeInserted);
    });

    describe('infrastructure link direction "bidirectional", route link traversal backward', () => {
      const linksToBeInserted = createLinksToBeInserted(
        infrastructureLinks[5].infrastructure_link_id,
        false,
      );

      shouldReturnCorrectResponse(linksToBeInserted);

      shouldInsertCorrectRowsIntoDatabase(linksToBeInserted);
    });
  });
});
