import * as config from '@config';
import * as dataset from '@util/dataset';
import { DbConnection, closeDbConnection, createDbConnection } from '@util/db';
import { post } from '@util/fetch-request';
import { expectErrorResponse } from '@util/response';
import { getPropNameArray, queryTable, setupDb } from '@util/setup';
import {
  defaultGenericNetworkDbData,
  infrastructureLinkAlongRoute,
  infrastructureLinks,
} from 'generic/networkdb/datasets/defaultSetup';
import { genericNetworkDbSchema } from 'generic/networkdb/datasets/schema';
import {
  InfrastructureLinkAlongRoute,
  infrastructureLinkAlongRouteProps,
} from 'generic/networkdb/datasets/types';

const buildMutation = (
  routeId: string,
  infrastructureLinkSequence: number,
  toBeUpdated: Partial<InfrastructureLinkAlongRoute>,
) => `
  mutation {
    update_route_infrastructure_link_along_route(
      where: {
        _and: {
          route_id: {_eq: "${routeId}"},
          infrastructure_link_sequence: {_eq: "${infrastructureLinkSequence}"}
        }
      },
      _set: ${dataset.toGraphQlObject(toBeUpdated, [
        'is_traversal_forwards',
      ])}) {
      returning {
        ${getPropNameArray(infrastructureLinkAlongRouteProps).join(',')}
      }
    }
  }
`;

describe('Update route link', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(config.networkDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  beforeEach(() => setupDb(dbConnection, defaultGenericNetworkDbData));

  describe("whose direction conflicts with its infrastructure link's direction", () => {
    const shouldReturnErrorResponse = (
      routeId: string,
      infrastructureLinkSequence: number,
      toBeUpdated: Partial<InfrastructureLinkAlongRoute>,
    ) =>
      it('should return error response', async () => {
        await post({
          ...config.hasuraRequestTemplate,
          body: {
            query: buildMutation(
              routeId,
              infrastructureLinkSequence,
              toBeUpdated,
            ),
          },
        }).then(
          expectErrorResponse(
            'route link direction must be compatible with infrastructure link direction',
          ),
        );
      });

    const shouldNotModifyDatabase = (
      routeId: string,
      infrastructureLinkSequence: number,
      toBeUpdated: Partial<InfrastructureLinkAlongRoute>,
    ) =>
      it('should not modify the database', async () => {
        await post({
          ...config.hasuraRequestTemplate,
          body: {
            query: buildMutation(
              routeId,
              infrastructureLinkSequence,
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

    describe('infrastructure link direction "forward", route link direction "backward"', () => {
      const toBeUpdated = {
        is_traversal_forwards: false,
      };

      shouldReturnErrorResponse(
        infrastructureLinkAlongRoute[2].route_id,
        infrastructureLinkAlongRoute[2].infrastructure_link_sequence,
        toBeUpdated,
      );

      shouldNotModifyDatabase(
        infrastructureLinkAlongRoute[2].route_id,
        infrastructureLinkAlongRoute[2].infrastructure_link_sequence,
        toBeUpdated,
      );
    });

    describe('infrastructure link direction "backward", route link direction "forward"', () => {
      const toBeUpdated = {
        is_traversal_forwards: true,
      };

      shouldReturnErrorResponse(
        infrastructureLinkAlongRoute[1].route_id,
        infrastructureLinkAlongRoute[1].infrastructure_link_sequence,
        toBeUpdated,
      );

      shouldNotModifyDatabase(
        infrastructureLinkAlongRoute[1].route_id,
        infrastructureLinkAlongRoute[1].infrastructure_link_sequence,
        toBeUpdated,
      );
    });

    describe('infrastructure link direction "forward", route link direction "backward", with setting new link', () => {
      const toBeUpdated = {
        infrastructure_link_id: infrastructureLinks[4].infrastructure_link_id,
      };

      shouldReturnErrorResponse(
        infrastructureLinkAlongRoute[1].route_id,
        infrastructureLinkAlongRoute[1].infrastructure_link_sequence,
        toBeUpdated,
      );

      shouldNotModifyDatabase(
        infrastructureLinkAlongRoute[1].route_id,
        infrastructureLinkAlongRoute[1].infrastructure_link_sequence,
        toBeUpdated,
      );
    });

    describe('infrastructure link direction "backward", route link direction "forward", with setting new link', () => {
      const toBeUpdated = {
        infrastructure_link_id: infrastructureLinks[6].infrastructure_link_id,
      };

      shouldReturnErrorResponse(
        infrastructureLinkAlongRoute[2].route_id,
        infrastructureLinkAlongRoute[2].infrastructure_link_sequence,
        toBeUpdated,
      );

      shouldNotModifyDatabase(
        infrastructureLinkAlongRoute[2].route_id,
        infrastructureLinkAlongRoute[2].infrastructure_link_sequence,
        toBeUpdated,
      );
    });
  });

  describe("whose direction does NOT conflict with its infrastructure link's direction", () => {
    const shouldReturnCorrectResponse = (
      original: InfrastructureLinkAlongRoute,
      toBeUpdated: Partial<InfrastructureLinkAlongRoute>,
    ) =>
      it('should return correct response', async () => {
        const response = await post({
          ...config.hasuraRequestTemplate,
          body: {
            query: buildMutation(
              original.route_id,
              original.infrastructure_link_sequence,
              toBeUpdated,
            ),
          },
        });

        expect(response).toEqual(
          expect.objectContaining({
            data: {
              update_route_infrastructure_link_along_route: {
                returning: [
                  {
                    ...original,
                    ...toBeUpdated,
                  },
                ],
              },
            },
          }),
        );
      });

    const shouldUpdateCorrectRowInDatabase = (
      original: InfrastructureLinkAlongRoute,
      toBeUpdated: Partial<InfrastructureLinkAlongRoute>,
    ) =>
      it('should update correct row in the database', async () => {
        await post({
          ...config.hasuraRequestTemplate,
          body: {
            query: buildMutation(
              original.route_id,
              original.infrastructure_link_sequence,
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
            { ...original, ...toBeUpdated },
            ...infrastructureLinkAlongRoute.filter(
              (infraLinkAlongRoute) =>
                infraLinkAlongRoute.route_id !== original.route_id ||
                infraLinkAlongRoute.infrastructure_link_sequence !==
                  original.infrastructure_link_sequence,
            ),
          ]),
        );
      });

    describe('infrastructure link direction "forward", route link direction "forward", with setting new link', () => {
      const toBeUpdated = {
        infrastructure_link_id: infrastructureLinks[0].infrastructure_link_id,
      };

      shouldReturnCorrectResponse(infrastructureLinkAlongRoute[2], toBeUpdated);

      shouldUpdateCorrectRowInDatabase(
        infrastructureLinkAlongRoute[2],
        toBeUpdated,
      );
    });

    describe('infrastructure link direction "backward", route link direction "backward", with setting new link', () => {
      const toBeUpdated = {
        infrastructure_link_id: infrastructureLinks[6].infrastructure_link_id,
      };

      shouldReturnCorrectResponse(infrastructureLinkAlongRoute[1], toBeUpdated);

      shouldUpdateCorrectRowInDatabase(
        infrastructureLinkAlongRoute[1],
        toBeUpdated,
      );
    });

    describe('infrastructure link direction "bidirectional", route link direction "backward", with setting new link', () => {
      const toBeUpdated = {
        infrastructure_link_id: infrastructureLinks[9].infrastructure_link_id,
      };

      shouldReturnCorrectResponse(infrastructureLinkAlongRoute[1], toBeUpdated);

      shouldUpdateCorrectRowInDatabase(
        infrastructureLinkAlongRoute[1],
        toBeUpdated,
      );
    });

    describe('infrastructure link direction "bidirectional", route link direction "forward", with setting new link', () => {
      const toBeUpdated = {
        infrastructure_link_id: infrastructureLinks[7].infrastructure_link_id,
      };

      shouldReturnCorrectResponse(infrastructureLinkAlongRoute[1], toBeUpdated);

      shouldUpdateCorrectRowInDatabase(
        infrastructureLinkAlongRoute[1],
        toBeUpdated,
      );
    });
  });
});
