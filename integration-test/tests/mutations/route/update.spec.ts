import * as config from '@config';
import { routes } from '@datasets/defaultSetup/routes';
import { scheduledStopPoints } from '@datasets/defaultSetup/scheduled-stop-points';
import { buildLocalizedString } from '@datasets/factories';
import { getPropNameArray, queryTable, setupDb } from '@datasets/setup';
import { Route, RouteProps } from '@datasets/types';
import * as dataset from '@util/dataset';
import '@util/matchers';
import * as pg from 'pg';
import * as rp from 'request-promise';

const toBeUpdated: Partial<Route> = {
  description_i18n: buildLocalizedString('updated route'),
  priority: 50,
  validity_end: new Date('2045-04-01 12:11:32Z'),
};

const completeUpdated: Route = {
  ...routes[1],
  ...toBeUpdated,
};

const mutation = `
  mutation {
    update_route_route(
      where: {
        route_id: {_eq: "${completeUpdated.route_id}"}
      },
      _set: ${dataset.toGraphQlObject(toBeUpdated, ['direction'])}
    ) {
      returning {
        ${getPropNameArray(RouteProps).join(',')}
      }
    }
  }
`;

describe('Update route', () => {
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
          update_route_route: {
            returning: [dataset.asGraphQlTimestampObject(completeUpdated)],
          },
        },
      }),
    );
  });

  it('should update correct row in the database', async () => {
    await rp.post({
      ...config.hasuraRequestTemplate,
      body: { query: mutation },
    });

    const response = await queryTable(dbConnectionPool, 'route.route');

    expect(response.rowCount).toEqual(routes.length);

    expect(response.rows).toEqual(
      expect.arrayContaining([
        completeUpdated,
        ...routes.filter((route) => route.route_id != completeUpdated.route_id),
      ]),
    );
  });
});
