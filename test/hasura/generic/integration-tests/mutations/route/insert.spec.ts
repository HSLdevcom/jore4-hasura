import * as config from '@config';
import { defaultGenericNetworkDbData } from '@datasets-generic/defaultSetup';
import { lines } from '@datasets-generic/defaultSetup/lines';
import { routes } from '@datasets-generic/defaultSetup/routes';
import { buildRoute } from '@datasets-generic/factories';
import { genericNetworkDbSchema } from '@datasets-generic/schema';
import { Route, RouteDirection, routeProps } from '@datasets-generic/types';
import * as dataset from '@util/dataset';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import '@util/matchers';
import { getPropNameArray, queryTable, setupDb } from '@util/setup';
import { LocalDate } from 'local-date';
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
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(config.networkDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  beforeEach(() => setupDb(dbConnection, defaultGenericNetworkDbData));

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

    const response = await queryTable(
      dbConnection,
      genericNetworkDbSchema['route.route'],
    );

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
