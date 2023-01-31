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
import { expectErrorResponse } from '@util/response';
import { findTableSchema } from '@util/schema';
import { getPropNameArray, queryTable, setupDb } from '@util/setup';
import { LocalDate } from 'local-date';
import * as rp from 'request-promise';

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
      await rp
        .post({
          ...config.hasuraRequestTemplate,
          body: { query: buildMutation(toBeInserted) },
        })
        .then(expectErrorResponse());
    });

  const shouldNotModifyDatabase = (toBeInserted: Partial<Route>) =>
    it('should not modify the database', async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeInserted) },
      });

      const response = await queryTable(
        dbConnection,
        findTableSchema(genericNetworkDbSchema, 'route.route'),
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
      validity_start: new LocalDate('2024-09-02'),
      validity_end: new LocalDate('2034-09-01'),
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
      validity_start: new LocalDate('2044-04-02'),
      validity_end: new LocalDate('2044-10-01'),
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
      validity_start: new LocalDate('2044-09-02'),
      validity_end: new LocalDate('2045-02-01'),
    };

    shouldReturnErrorResponse(toBeInserted);

    shouldNotModifyDatabase(toBeInserted);
  });
});
