import * as config from '@config';
import { lines } from '@datasets-generic/defaultSetup/lines';
import { routes } from '@datasets-generic/defaultSetup/routes';
import { buildRoute } from '@datasets-generic/factories';
import { getPropNameArray, queryTable, setupDb } from '@datasets-generic/setup';
import { Route, RouteDirection, routeProps } from '@datasets-generic/types';
import * as dataset from '@util/dataset';
import '@util/matchers';
import { LocalDate } from 'local-date';
import * as pg from 'pg';
import * as rp from 'request-promise';

const toBeInserted: Partial<Route> = {
  ...buildRoute('new route'),
  on_line_id: lines[1].line_id,
  direction: RouteDirection.Clockwise,
  priority: 40,
  validity_start: new LocalDate('2044-05-01'),
  validity_end: new LocalDate('2045-04-30'),
};

const mutation = `
  mutation {
    insert_route_route(objects: ${dataset.toGraphQlObject(toBeInserted, [
      'direction',
    ])}) {
      returning {
        ${getPropNameArray(routeProps).join(',')}
      }
    }
  }
`;

describe('Insert route', () => {
  let dbConnectionPool: pg.Pool;

  beforeAll(() => {
    dbConnectionPool = new pg.Pool(config.databaseConfig);
  });

  afterAll(() => dbConnectionPool.end());

  beforeEach(() => setupDb(dbConnectionPool));

  it('should return correct response', async () => {
    const response = await rp.post({
      ...config.hasuraRequestTemplate,
      body: { query: mutation },
    });

    expect(response).toEqual(
      expect.objectContaining({
        data: {
          insert_route_route: {
            returning: [
              {
                ...dataset.asGraphQlDateObject(toBeInserted),
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

  it('should insert correct row into the database', async () => {
    await rp.post({
      ...config.hasuraRequestTemplate,
      body: { query: mutation },
    });

    const response = await queryTable(dbConnectionPool, 'route.route');

    expect(response.rowCount).toEqual(routes.length + 1);

    expect(response.rows).toEqual(
      expect.arrayContaining([
        {
          ...toBeInserted,
          route_id: expect.any(String),
        },
        ...routes,
      ]),
    );
  });
});
