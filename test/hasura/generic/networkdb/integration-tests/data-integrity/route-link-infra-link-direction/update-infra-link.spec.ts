import * as config from '@config';
import * as dataset from '@util/dataset';
import { serializeMatcherInputs } from '@util/dataset';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import { post } from '@util/fetch-request';
import { expectErrorResponse } from '@util/response';
import { getPropNameArray, queryTable, setupDb } from '@util/setup';
import {
  defaultGenericNetworkDbData,
  infrastructureLinks,
} from 'generic/networkdb/datasets/defaultSetup';
import { genericNetworkDbSchema } from 'generic/networkdb/datasets/schema';
import {
  InfrastructureLink,
  infrastructureLinkProps,
  LinkDirection,
} from 'generic/networkdb/datasets/types';

const buildMutation = (
  infrastructureLinkId: string,
  toBeUpdated: Partial<InfrastructureLink>,
) => `
  mutation {
    update_infrastructure_network_infrastructure_link(
      where: {
        infrastructure_link_id: {_eq: "${infrastructureLinkId}"}
      },
      _set: ${dataset.toGraphQlObject(toBeUpdated, ['direction'])}) {
      returning {
        ${getPropNameArray(infrastructureLinkProps).join(',')}
      }
    }
  }
`;

describe('Update infrastructure link', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(config.networkDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  beforeEach(() => setupDb(dbConnection, defaultGenericNetworkDbData));

  describe("whose direction conflicts with a route link's direction", () => {
    const shouldReturnErrorResponse = (
      infrastructureLinkId: string,
      toBeUpdated: Partial<InfrastructureLink>,
    ) =>
      it('should return error response', async () => {
        await post({
          ...config.hasuraRequestTemplate,
          body: { query: buildMutation(infrastructureLinkId, toBeUpdated) },
        }).then(
          expectErrorResponse(
            'route link direction must be compatible with infrastructure link direction',
          ),
        );
      });

    const shouldNotModifyDatabase = (
      infrastructureLinkId: string,
      toBeUpdated: Partial<InfrastructureLink>,
    ) =>
      it('should not modify the database', async () => {
        await post({
          ...config.hasuraRequestTemplate,
          body: { query: buildMutation(infrastructureLinkId, toBeUpdated) },
        });

        const response = await queryTable(
          dbConnection,
          genericNetworkDbSchema['infrastructure_network.infrastructure_link'],
        );

        expect(response.rowCount).toEqual(infrastructureLinks.length);
        expect(response.rows).toEqual(
          expect.arrayContaining(serializeMatcherInputs(infrastructureLinks)),
        );
      });

    describe('infrastructure link direction "backward", route link direction "forward"', () => {
      const toBeUpdated = {
        direction: LinkDirection.Backward,
      };

      shouldReturnErrorResponse(
        infrastructureLinks[4].infrastructure_link_id,
        toBeUpdated,
      );

      shouldNotModifyDatabase(
        infrastructureLinks[4].infrastructure_link_id,
        toBeUpdated,
      );
    });

    describe('infrastructure link direction "forward", route link direction "backward"', () => {
      const toBeUpdated = {
        direction: LinkDirection.Forward,
      };

      shouldReturnErrorResponse(
        infrastructureLinks[5].infrastructure_link_id,
        toBeUpdated,
      );

      shouldNotModifyDatabase(
        infrastructureLinks[5].infrastructure_link_id,
        toBeUpdated,
      );
    });

    describe("whose direction does NOT conflict with its infrastructure link's direction", () => {
      const shouldReturnCorrectResponse = (
        original: InfrastructureLink,
        toBeUpdated: Partial<InfrastructureLink>,
      ) =>
        it('should return correct response', async () => {
          const response = await post({
            ...config.hasuraRequestTemplate,
            body: {
              query: buildMutation(
                original.infrastructure_link_id,
                toBeUpdated,
              ),
            },
          });

          expect(response).toEqual(
            expect.objectContaining({
              data: {
                update_infrastructure_network_infrastructure_link: {
                  returning: [
                    dataset.asGraphQlDateObject({
                      ...original,
                      ...toBeUpdated,
                    }),
                  ],
                },
              },
            }),
          );
        });

      const shouldUpdateCorrectRowInDatabase = (
        original: InfrastructureLink,
        toBeUpdated: Partial<InfrastructureLink>,
      ) =>
        it('should update correct row in the database', async () => {
          await post({
            ...config.hasuraRequestTemplate,
            body: {
              query: buildMutation(
                original.infrastructure_link_id,
                toBeUpdated,
              ),
            },
          });

          const response = await queryTable(
            dbConnection,
            genericNetworkDbSchema[
              'infrastructure_network.infrastructure_link'
            ],
          );

          expect(response.rowCount).toEqual(infrastructureLinks.length);

          expect(response.rows).toEqual(
            expect.arrayContaining(
              dataset.serializeMatcherInputs([
                { ...original, ...toBeUpdated },
                ...infrastructureLinks.filter(
                  (infrastructureLink) =>
                    infrastructureLink.infrastructure_link_id !==
                    original.infrastructure_link_id,
                ),
              ]),
            ),
          );
        });

      describe('infrastructure link direction "forward", no route link existing', () => {
        const toBeUpdated = {
          direction: LinkDirection.Forward,
        };

        shouldReturnCorrectResponse(infrastructureLinks[7], toBeUpdated);

        shouldUpdateCorrectRowInDatabase(infrastructureLinks[7], toBeUpdated);
      });

      describe('infrastructure link direction "bidirectional", route link direction "backward', () => {
        const toBeUpdated = {
          direction: LinkDirection.BiDirectional,
        };

        shouldReturnCorrectResponse(infrastructureLinks[5], toBeUpdated);

        shouldUpdateCorrectRowInDatabase(infrastructureLinks[5], toBeUpdated);
      });
    });
  });
});
