import * as config from '@config';
import { route116TableConfig } from '@datasets-generic/route116';
import { routes } from '@datasets-generic/route116/routes';
import { getPropNameArray, queryTable, setupDb } from '@datasets-generic/setup';
import { RouteProps } from '@datasets-generic/types';
import * as dataset from '@util/dataset';
import '@util/matchers';
import * as pg from 'pg';
import * as rp from 'request-promise';

const toBeDeleted = routes[0];

const mutation = `
  mutation {
    delete_route_route(
      where: {
        route_id: {_eq: "${toBeDeleted.route_id}"}
      },
    ) {
      returning {
        ${getPropNameArray(RouteProps).join(',')}
      }
    }
  }
`;

describe('Delete route with infra links and journey pattern', () => {
  let dbConnectionPool: pg.Pool;

  beforeAll(() => {
    dbConnectionPool = new pg.Pool(config.databaseConfig);
  });

  afterAll(() => dbConnectionPool.end());

  beforeEach(() => setupDb(dbConnectionPool, route116TableConfig));

  it('should return correct response', async () => {
    const response = await rp.post({
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
    await rp.post({
      ...config.hasuraRequestTemplate,
      body: { query: mutation },
    });

    const response = await queryTable(dbConnectionPool, 'route.route');

    expect(response.rowCount).toEqual(routes.length - 1);

    expect(response.rows).toEqual(
      expect.arrayContaining(
        routes.filter((route) => route.route_id !== toBeDeleted.route_id),
      ),
    );
  });
});