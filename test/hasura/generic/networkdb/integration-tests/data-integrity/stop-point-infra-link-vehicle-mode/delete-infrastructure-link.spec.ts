import * as config from '@config';
import * as dataset from '@util/dataset';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import { post } from '@util/fetch-request';
import { expectErrorResponse } from '@util/response';
import { getPropNameArray, queryTable, setupDb } from '@util/setup';
import {
  defaultGenericNetworkDbData,
  infrastructureLinks,
  vehicleSubmodeOnInfrastructureLink,
} from 'generic/networkdb/datasets/defaultSetup';
import { genericNetworkDbSchema } from 'generic/networkdb/datasets/schema';
import { infrastructureLinkProps } from 'generic/networkdb/datasets/types';

const buildMutation = (infrastructureLinkId: string) => `
  mutation {
    delete_infrastructure_network_infrastructure_link(where: {infrastructure_link_id: {_eq: "${infrastructureLinkId}"}}) {
      returning {
        ${getPropNameArray(infrastructureLinkProps).join(',')}
      }
    }
  }
`;

describe('Delete infrastructure link', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(config.networkDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  beforeEach(() => setupDb(dbConnection, defaultGenericNetworkDbData));

  describe('which is referenced by a scheduled stop point', () => {
    const toBeDeleted = infrastructureLinks[0];

    it('should return error response', async () => {
      await post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeDeleted.infrastructure_link_id) },
      }).then(expectErrorResponse('violates foreign key constraint'));
    });

    it('should not modify database', async () => {
      await post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeDeleted.infrastructure_link_id) },
      });

      const infraLinkResponse = await queryTable(
        dbConnection,
        genericNetworkDbSchema['infrastructure_network.infrastructure_link'],
      );

      expect(infraLinkResponse.rowCount).toEqual(infrastructureLinks.length);
      expect(infraLinkResponse.rows).toEqual(
        expect.arrayContaining(
          dataset.serializeMatcherInputs(infrastructureLinks),
        ),
      );

      const vehicleSubModeResponse = await queryTable(
        dbConnection,
        genericNetworkDbSchema[
          'infrastructure_network.vehicle_submode_on_infrastructure_link'
        ],
      );

      expect(vehicleSubModeResponse.rowCount).toEqual(
        vehicleSubmodeOnInfrastructureLink.length,
      );
      expect(vehicleSubModeResponse.rows).toEqual(
        expect.arrayContaining(vehicleSubmodeOnInfrastructureLink),
      );
    });
  });

  describe('which is NOT referenced by a scheduled stop point', () => {
    const toBeDeleted = infrastructureLinks[2];

    it('should return correct response', async () => {
      const response = await post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeDeleted.infrastructure_link_id) },
      });

      expect(response).toEqual(
        expect.objectContaining({
          data: {
            delete_infrastructure_network_infrastructure_link: {
              returning: [dataset.asGraphQlDateObject(toBeDeleted)],
            },
          },
        }),
      );
    });

    it('should delete correct rows from the database', async () => {
      await post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeDeleted.infrastructure_link_id) },
      });

      const infraLinkResponse = await queryTable(
        dbConnection,
        genericNetworkDbSchema['infrastructure_network.infrastructure_link'],
      );

      expect(infraLinkResponse.rowCount).toEqual(
        infrastructureLinks.length - 1,
      );

      expect(infraLinkResponse.rows).toEqual(
        expect.arrayContaining(
          dataset.serializeMatcherInputs(
            infrastructureLinks.filter(
              (infrastructureLink) =>
                infrastructureLink.infrastructure_link_id !==
                toBeDeleted.infrastructure_link_id,
            ),
          ),
        ),
      );

      const vehicleSubModeResponse = await queryTable(
        dbConnection,
        genericNetworkDbSchema[
          'infrastructure_network.vehicle_submode_on_infrastructure_link'
        ],
      );

      expect(vehicleSubModeResponse.rowCount).toEqual(
        vehicleSubmodeOnInfrastructureLink.length - 1,
      );
      expect(vehicleSubModeResponse.rows).toEqual(
        expect.arrayContaining(
          vehicleSubmodeOnInfrastructureLink.filter(
            (vehicleSubMode) =>
              vehicleSubMode.infrastructure_link_id !==
              toBeDeleted.infrastructure_link_id,
          ),
        ),
      );
    });
  });
});
