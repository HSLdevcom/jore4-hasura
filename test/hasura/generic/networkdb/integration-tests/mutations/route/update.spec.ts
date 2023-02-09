import * as config from '@config';
import * as dataset from '@util/dataset';
import { buildLocalizedString } from '@util/dataset';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import '@util/matchers';
import { getPropNameArray, queryTable, setupDb } from '@util/setup';
import { defaultGenericNetworkDbData } from 'generic/networkdb/datasets/defaultSetup';
import { routes } from 'generic/networkdb/datasets/defaultSetup/routes';
import { genericNetworkDbSchema } from 'generic/networkdb/datasets/schema';
import { Route, routeProps } from 'generic/networkdb/datasets/types';
import { DateTime } from 'luxon';
import * as rp from 'request-promise';

const toBeUpdated: Partial<Route> = {
  description_i18n: buildLocalizedString('updated route'),
  priority: 50,
  validity_end: DateTime.fromISO('2045-03-31'),
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
        ${getPropNameArray(routeProps).join(',')}
      }
    }
  }
`;

describe('Update route', () => {
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
          update_route_route: {
            returning: [dataset.asGraphQlDateObject(completeUpdated)],
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

    const response = await queryTable(
      dbConnection,
      genericNetworkDbSchema['route.route'],
    );

    expect(response.rowCount).toEqual(routes.length);

    expect(response.rows).toEqual(
      expect.arrayContaining([
        completeUpdated,
        ...routes.filter(
          (route) => route.route_id !== completeUpdated.route_id,
        ),
      ]),
    );
  });
});
