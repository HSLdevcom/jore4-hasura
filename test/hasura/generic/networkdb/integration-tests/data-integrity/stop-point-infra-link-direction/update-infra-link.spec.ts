import * as config from '@config';
import * as dataset from '@util/dataset';
import { serializeMatcherInputs } from '@util/dataset';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import { post } from '@util/fetch-request';
import { expectErrorResponse } from '@util/response';
import {
  getPartialTableData,
  getPropNameArray,
  queryTable,
  setupDb,
} from '@util/setup';
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

  beforeEach(() =>
    setupDb(
      dbConnection,
      getPartialTableData(defaultGenericNetworkDbData, [
        'infrastructure_network.infrastructure_link',
        'infrastructure_network.vehicle_submode_on_infrastructure_link',
        'service_pattern.scheduled_stop_point_invariant',
        'service_pattern.scheduled_stop_point',
        'service_pattern.vehicle_mode_on_scheduled_stop_point',
        'route.line',
        'route.route',
      ]),
    ),
  );

  describe("whose direction conflicts with a scheduled stop point's direction", () => {
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
            'infrastructure link direction must be compatible with the directions of the stop points residing on it',
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

    describe('infrastructure link direction "backward", stop point direction "forward"', () => {
      const toBeUpdated = {
        direction: LinkDirection.Backward,
      };

      shouldReturnErrorResponse(
        infrastructureLinks[0].infrastructure_link_id,
        toBeUpdated,
      );

      shouldNotModifyDatabase(
        infrastructureLinks[0].infrastructure_link_id,
        toBeUpdated,
      );
    });

    describe('infrastructure link direction "forward", stop point direction "backward"', () => {
      const toBeUpdated = {
        direction: LinkDirection.Forward,
      };

      shouldReturnErrorResponse(
        infrastructureLinks[1].infrastructure_link_id,
        toBeUpdated,
      );

      shouldNotModifyDatabase(
        infrastructureLinks[1].infrastructure_link_id,
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

      describe('infrastructure link direction "forward", no stop point existing', () => {
        const toBeUpdated = {
          direction: LinkDirection.Forward,
        };

        shouldReturnCorrectResponse(infrastructureLinks[2], toBeUpdated);

        shouldUpdateCorrectRowInDatabase(infrastructureLinks[2], toBeUpdated);
      });

      describe('infrastructure link direction "bidirectional", stop point direction "forward', () => {
        const toBeUpdated = {
          direction: LinkDirection.BiDirectional,
        };

        shouldReturnCorrectResponse(infrastructureLinks[1], toBeUpdated);

        shouldUpdateCorrectRowInDatabase(infrastructureLinks[1], toBeUpdated);
      });
    });
  });
});
