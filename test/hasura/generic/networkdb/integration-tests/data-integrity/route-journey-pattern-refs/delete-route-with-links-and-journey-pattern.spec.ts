import * as config from '@config';
import * as dataset from '@util/dataset';
import { DbConnection, closeDbConnection, createDbConnection } from '@util/db';
import { post } from '@util/fetch-request';
import { getPropNameArray, queryTable, setupDb } from '@util/setup';
import {
  route116TableConfig,
  routes,
} from 'generic/networkdb/datasets/route116';
import { genericNetworkDbSchema } from 'generic/networkdb/datasets/schema';
import { routeProps } from 'generic/networkdb/datasets/types';

const toBeDeleted = routes[0];

const mutation = `
  mutation {
    delete_route_route(
      where: {
        route_id: {_eq: "${toBeDeleted.route_id}"}
      },
    ) {
      returning {
        ${getPropNameArray(routeProps).join(',')}
      }
    }
  }
`;

describe('Delete route with infra links and journey pattern', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(config.networkDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  beforeEach(() => setupDb(dbConnection, route116TableConfig));

  it('should return correct response', async () => {
    const response = await post({
      ...config.hasuraRequestTemplate,
      body: { query: mutation },
    });

    expect(response).toEqual(
      expect.objectContaining({
        data: {
          delete_route_route: {
            returning: [dataset.asGraphQlDateObject(toBeDeleted)],
          },
        },
      }),
    );
  });

  it('should delete correct row from the database', async () => {
    await post({
      ...config.hasuraRequestTemplate,
      body: { query: mutation },
    });

    const response = await queryTable(
      dbConnection,
      genericNetworkDbSchema['route.route'],
    );

    expect(response.rowCount).toEqual(routes.length - 1);

    expect(response.rows).toEqual(
      expect.arrayContaining(
        routes.filter((route) => route.route_id !== toBeDeleted.route_id),
      ),
    );
  });
});
