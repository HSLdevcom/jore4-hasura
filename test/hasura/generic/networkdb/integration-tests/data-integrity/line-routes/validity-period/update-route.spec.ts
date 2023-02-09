import * as config from '@config';
import * as dataset from '@util/dataset';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import { prevDay } from '@util/helpers';
import { expectErrorResponse } from '@util/response';
import { getPropNameArray, queryTable, setupDb } from '@util/setup';
import { defaultGenericNetworkDbData } from 'generic/networkdb/datasets/defaultSetup';
import { lines } from 'generic/networkdb/datasets/defaultSetup/lines';
import { routes } from 'generic/networkdb/datasets/defaultSetup/routes';
import { genericNetworkDbSchema } from 'generic/networkdb/datasets/schema';
import { Route, routeProps } from 'generic/networkdb/datasets/types';
import { DateTime } from 'luxon';
import * as rp from 'request-promise';

const buildMutation = (route: Route, toBeUpdated: Partial<Route>) => `
  mutation {
    update_route_route(
      where: {
        route_id: {_eq: "${route.route_id}"}
      },
      _set: ${dataset.toGraphQlObject(toBeUpdated, ['direction'])}
    ) {
      returning {
        ${getPropNameArray(routeProps).join(',')}
      }
    }
  }
`;

const completeUpdated = (route: Route, toBeUpdated: Partial<Route>) => ({
  ...route,
  ...toBeUpdated,
});

describe('Update route', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(config.networkDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  beforeEach(() => setupDb(dbConnection, defaultGenericNetworkDbData));

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

      const response = await queryTable(
        dbConnection,
        genericNetworkDbSchema['route.route'],
      );

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
                dataset.asGraphQlDateObject(
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

      const response = await queryTable(
        dbConnection,
        genericNetworkDbSchema['route.route'],
      );

      const updated = completeUpdated(route, toBeUpdated);

      expect(response.rowCount).toEqual(routes.length);
      expect(response.rows).toEqual(
        expect.arrayContaining([
          updated,
          ...routes.filter((item) => item.route_id !== updated.route_id),
        ]),
      );
    });

  describe('with a fixed validity start time outside of the validity time of the line', () => {
    const toBeUpdated = { validity_start: DateTime.fromISO('2040-03-02') };

    shouldReturnErrorResponse(routes[1], toBeUpdated);
    shouldNotModifyDatabase(routes[1], toBeUpdated);
  });

  describe('with a fixed validity end time outside of the validity time of the line', () => {
    const toBeUpdated = { validity_end: DateTime.fromISO('2046-08-01') };

    shouldReturnErrorResponse(routes[1], toBeUpdated);
    shouldNotModifyDatabase(routes[1], toBeUpdated);
  });

  describe('with a fixed validity start time within the validity time of the line', () => {
    const toBeUpdated = { validity_start: DateTime.fromISO('2044-12-02') };

    shouldReturnCorrectResponse(routes[1], toBeUpdated);
    shouldUpdateCorrectRowInDatabase(routes[1], toBeUpdated);
  });

  describe('with infinitely valid validity start, when line has also infinitely valid validity start', () => {
    const toBeUpdated = { validity_start: null };

    shouldReturnCorrectResponse(routes[3], toBeUpdated);
    shouldUpdateCorrectRowInDatabase(routes[3], toBeUpdated);
  });

  describe('with a fixed validity start time of 1 day prior to the validity time of the line', () => {
    const toBeUpdated = {
      // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
      validity_start: prevDay(lines[1].validity_start!),
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
