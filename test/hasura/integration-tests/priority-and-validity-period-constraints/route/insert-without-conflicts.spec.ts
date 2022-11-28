import * as config from '@config';
import { lines } from '@datasets/defaultSetup/lines';
import { routes } from '@datasets/defaultSetup/routes';
import { buildRoute } from '@datasets/factories';
import { getPropNameArray, queryTable, setupDb } from '@datasets/setup';
import { Route, RouteDirection, RouteProps } from '@datasets/types';
import * as dataset from '@util/dataset';
import '@util/matchers';
import { LocalDate } from 'local-date';
import * as pg from 'pg';
import * as rp from 'request-promise';

const buildMutation = (toBeInserted: Partial<Route>) => `
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

  const shouldReturnCorrectResponse = (toBeInserted: Partial<Route>) =>
    it('should return correct response', async () => {
      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeInserted) },
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

  const shouldInsertCorrectRowIntoDatabase = (toBeInserted: Partial<Route>) =>
    it('should insert correct row into the database', async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeInserted) },
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

  describe('whose validity period conflicts with open validity start but has different priority', () => {
    const toBeInserted: Partial<Route> = {
      ...buildRoute('3'),
      on_line_id: lines[2].line_id,
      direction: RouteDirection.Eastbound,
      priority: 20,
      validity_start: new LocalDate('2024-09-02'),
      validity_end: new LocalDate('2034-09-01'),
    };

    shouldReturnCorrectResponse(toBeInserted);

    shouldInsertCorrectRowIntoDatabase(toBeInserted);
  });

  describe('whose validity period conflicts with open validity start but has different label', () => {
    const toBeInserted: Partial<Route> = {
      ...buildRoute('5'),
      on_line_id: lines[4].line_id,
      label: 'route 3X',
      direction: RouteDirection.Eastbound,
      priority: 20,
      validity_start: new LocalDate('2024-09-02'),
      validity_end: new LocalDate('2034-09-01'),
    };

    shouldReturnCorrectResponse(toBeInserted);

    shouldInsertCorrectRowIntoDatabase(toBeInserted);
  });

  describe('whose validity period conflicts with open validity end but has different variant', () => {
    const toBeInserted: Partial<Route> = {
      ...buildRoute('1'),
      on_line_id: lines[0].line_id,
      direction: RouteDirection.Northbound,
      variant: 3,
      priority: 10,
      validity_start: new LocalDate('2044-05-02'),
      validity_end: null,
    };

    shouldReturnCorrectResponse(toBeInserted);

    shouldInsertCorrectRowIntoDatabase(toBeInserted);
  });

  describe('whose validity period does not conflict with open validity start', () => {
    const toBeInserted: Partial<Route> = {
      ...buildRoute('5'),
      on_line_id: lines[4].line_id,
      direction: RouteDirection.Eastbound,
      priority: 20,
      validity_start: new LocalDate('2044-09-02'),
      validity_end: new LocalDate('2045-05-31'),
    };

    shouldReturnCorrectResponse(toBeInserted);

    shouldInsertCorrectRowIntoDatabase(toBeInserted);
  });

  describe('whose validity period overlaps partially with existing validity period but has different direction', () => {
    const toBeInserted: Partial<Route> = {
      ...buildRoute('4'),
      on_line_id: lines[2].line_id,
      direction: RouteDirection.Eastbound,
      priority: 20,
      validity_start: new LocalDate('2044-06-02'),
      validity_end: new LocalDate('2045-05-31'),
    };

    shouldReturnCorrectResponse(toBeInserted);

    shouldInsertCorrectRowIntoDatabase(toBeInserted);
  });

  describe('whose validity period is entirely contained in other validity period but has different direction', () => {
    const toBeInserted: Partial<Route> = {
      ...buildRoute('4'),
      on_line_id: lines[2].line_id,
      direction: RouteDirection.Eastbound,
      priority: 20,
      validity_start: new LocalDate('2044-04-02'),
      validity_end: new LocalDate('2044-07-31'),
    };

    shouldReturnCorrectResponse(toBeInserted);

    shouldInsertCorrectRowIntoDatabase(toBeInserted);
  });

  describe('whose validity period overlaps with existing validity but both have draft priority', () => {
    const toBeInserted: Partial<Route> = {
      ...buildRoute('3'),
      on_line_id: lines[2].line_id,
      direction: RouteDirection.Eastbound,
      priority: 30,
      validity_start: new LocalDate('2042-09-02'),
      validity_end: new LocalDate('2043-09-01'),
    };

    shouldReturnCorrectResponse(toBeInserted);

    shouldInsertCorrectRowIntoDatabase(toBeInserted);
  });
});
