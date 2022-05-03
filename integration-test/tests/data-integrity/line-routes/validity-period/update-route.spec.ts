import * as rp from 'request-promise';
import * as pg from 'pg';
import * as config from '@config';
import * as dataset from '@util/dataset';
import { routes } from '@datasets/defaultSetup/routes';
import '@util/matchers';
import { Route, RouteProps } from '@datasets/types';
import { getPropNameArray, queryTable, setupDb } from '@datasets/setup';
import { expectErrorResponse } from '@util/response';
import { lines } from '@datasets/defaultSetup/lines';

const buildMutation = (route: Route, toBeUpdated: Partial<Route>) => `
  mutation {
    update_route_route(
      where: {
        route_id: {_eq: "${route.route_id}"}
      },
      _set: ${dataset.toGraphQlObject(toBeUpdated, ['direction'])}
    ) {
      returning {
        ${getPropNameArray(RouteProps).join(',')}
      }
    }
  }
`;

const completeUpdated = (route: Route, toBeUpdated: Partial<Route>) => ({
  ...route,
  ...toBeUpdated,
});

describe('Update route', () => {
  let dbConnectionPool: pg.Pool;

  beforeAll(() => {
    dbConnectionPool = new pg.Pool(config.databaseConfig);
  });

  afterAll(() => dbConnectionPool.end());

  beforeEach(() => setupDb(dbConnectionPool));

  const shouldReturnErrorResponse = (
    route: Route,
    toBeUpdated: Partial<Route>,
  ) =>
    it('should return error response', async () => {
      await rp
        .post({
          ...config.hasuraRequestTemplate,
          body: { query: buildMutation(route, toBeUpdated) },
        })
        .then(
          expectErrorResponse(
            "route validity period must lie within its line's validity period",
          ),
        );
    });

  const shouldNotModifyDatabase = (route: Route, toBeUpdated: Partial<Route>) =>
    it('should not modify the database', async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(route, toBeUpdated) },
      });

      const response = await queryTable(dbConnectionPool, 'route.route');

      expect(response.rowCount).toEqual(routes.length);
      expect(response.rows).toEqual(expect.arrayContaining(routes));
    });

  const shouldReturnCorrectResponse = (
    route: Route,
    toBeUpdated: Partial<Route>,
  ) =>
    it('should return correct response', async () => {
      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(route, toBeUpdated) },
      });

      expect(response).toEqual(
        expect.objectContaining({
          data: {
            update_route_route: {
              returning: [
                dataset.asGraphQlTimestampObject(
                  completeUpdated(route, toBeUpdated),
                ),
              ],
            },
          },
        }),
      );
    });

  const shouldUpdateCorrectRowInDatabase = (
    route: Route,
    toBeUpdated: Partial<Route>,
  ) =>
    it('should update correct row into the database', async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(route, toBeUpdated) },
      });

      const response = await queryTable(dbConnectionPool, 'route.route');

      const updated = completeUpdated(route, toBeUpdated);

      expect(response.rowCount).toEqual(routes.length);
      expect(response.rows).toEqual(
        expect.arrayContaining([
          updated,
          ...routes.filter((route) => route.route_id != updated.route_id),
        ]),
      );
    });

  describe('with a fixed validity start time outside of the validity time of the line', () => {
    const toBeUpdated = { validity_start: new Date('2040-03-02 23:11:32Z') };

    shouldReturnErrorResponse(routes[1], toBeUpdated);
    shouldNotModifyDatabase(routes[1], toBeUpdated);
  });

  describe('with a fixed validity end time outside of the validity time of the line', () => {
    const toBeUpdated = { validity_end: new Date('2046-08-02 23:11:32Z') };

    shouldReturnErrorResponse(routes[1], toBeUpdated);
    shouldNotModifyDatabase(routes[1], toBeUpdated);
  });

  describe('with a fixed validity start time within the validity time of the line', () => {
    const toBeUpdated = { validity_start: new Date('2044-12-02 23:11:32Z') };

    shouldReturnCorrectResponse(routes[1], toBeUpdated);
    shouldUpdateCorrectRowInDatabase(routes[1], toBeUpdated);
  });

  describe('with infinitely valid validity start, when line has also infinitely valid validity start', () => {
    const toBeUpdated = { validity_start: null };

    shouldReturnCorrectResponse(routes[3], toBeUpdated);
    shouldUpdateCorrectRowInDatabase(routes[3], toBeUpdated);
  });

  describe('with a fixed validity start time of 1 ms prior to the validity time of the line', () => {
    const toBeUpdated = {
      validity_start: new Date(lines[1].validity_start!.getTime() - 1),
    };

    shouldReturnErrorResponse(routes[1], toBeUpdated);
    shouldNotModifyDatabase(routes[1], toBeUpdated);
  });

  describe('with a fixed validity start time equal to the validity time of the line', () => {
    const toBeUpdated = {
      validity_start: lines[1].validity_start,
    };

    shouldReturnCorrectResponse(routes[1], toBeUpdated);
    shouldUpdateCorrectRowInDatabase(routes[1], toBeUpdated);
  });
});
