import * as rp from 'request-promise';
import * as pg from 'pg';
import * as config from '@config';
import * as dataset from '@util/dataset';
import { scheduledStopPoints } from '@datasets/defaultSetup/scheduled-stop-points';
import { lines } from '@datasets/defaultSetup/lines';
import { routes } from '@datasets/defaultSetup/routes';
import '@util/matchers';
import { Route, RouteDirection, RouteProps } from '@datasets/types';
import { getPropNameArray, queryTable, setupDb } from '@datasets/setup';

const toBeInserted: Partial<Route> = {
  on_line_id: lines[1].line_id,
  description_i18n: 'new route',
  starts_from_scheduled_stop_point_id:
    scheduledStopPoints[0].scheduled_stop_point_id,
  ends_at_scheduled_stop_point_id:
    scheduledStopPoints[2].scheduled_stop_point_id,
  label: 'new route label',
  direction: RouteDirection.Clockwise,
  priority: 40,
  validity_start: new Date('2044-05-01 23:11:32Z'),
  validity_end: new Date('2045-05-01 23:11:32Z'),
};

const mutation = `
  mutation {
    insert_route_route(objects: ${dataset.toGraphQlObject(toBeInserted, [
      'direction',
    ])}) {
      returning {
        ${getPropNameArray(RouteProps).join(',')}
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
                ...dataset.asGraphQlTimestampObject(toBeInserted),
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
