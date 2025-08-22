import { DateTime } from 'luxon';
import * as config from '@config';
import * as dataset from '@util/dataset';
import { DbConnection, closeDbConnection, createDbConnection } from '@util/db';
import { post } from '@util/fetch-request';
import { expectErrorResponse } from '@util/response';
import { getPropNameArray, queryTable, setupDb } from '@util/setup';
import {
  defaultGenericNetworkDbData,
  lines,
  routes,
} from 'generic/networkdb/datasets/defaultSetup';
import { buildRoute } from 'generic/networkdb/datasets/factories';
import { genericNetworkDbSchema } from 'generic/networkdb/datasets/schema';
import {
  Route,
  RouteDirection,
  routeProps,
} from 'generic/networkdb/datasets/types';

const buildMutation = (toBeInserted: Partial<Route>) => `
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

  const shouldReturnErrorResponse = (toBeInserted: Partial<Route>) =>
    it('should return error response', async () => {
      await post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeInserted) },
      }).then(expectErrorResponse());
    });

  const shouldNotModifyDatabase = (toBeInserted: Partial<Route>) =>
    it('should not modify the database', async () => {
      await post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeInserted) },
      });

      const response = await queryTable(
        dbConnection,
        genericNetworkDbSchema['route.route'],
      );

      expect(response.rowCount).toEqual(routes.length);
      expect(response.rows).toEqual(expect.arrayContaining(routes));
    });

  describe('whose validity period conflicts with open validity start', () => {
    const toBeInserted: Partial<Route> = {
      ...buildRoute('5'),
      on_line_id: lines[4].line_id,
      direction: RouteDirection.Eastbound,
      priority: 20,
      validity_start: DateTime.fromISO('2024-09-02'),
      validity_end: DateTime.fromISO('2034-09-01'),
    };

    shouldReturnErrorResponse(toBeInserted);

    shouldNotModifyDatabase(toBeInserted);
  });

  describe('whose validity period overlaps partially with existing validity period', () => {
    const toBeInserted: Partial<Route> = {
      ...buildRoute('2'),
      on_line_id: lines[1].line_id,
      direction: RouteDirection.Eastbound,
      priority: 20,
      validity_start: DateTime.fromISO('2044-04-02'),
      validity_end: DateTime.fromISO('2044-10-01'),
    };

    shouldReturnErrorResponse(toBeInserted);

    shouldNotModifyDatabase(toBeInserted);
  });

  describe('whose validity period is entirely contained in other validity period', () => {
    const toBeInserted: Partial<Route> = {
      ...buildRoute('2'),
      on_line_id: lines[1].line_id,
      direction: RouteDirection.Southbound,
      priority: 20,
      validity_start: DateTime.fromISO('2044-09-02'),
      validity_end: DateTime.fromISO('2045-02-01'),
    };

    shouldReturnErrorResponse(toBeInserted);

    shouldNotModifyDatabase(toBeInserted);
  });
});
