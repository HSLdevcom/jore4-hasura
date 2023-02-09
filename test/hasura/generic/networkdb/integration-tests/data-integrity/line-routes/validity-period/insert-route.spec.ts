import * as config from '@config';
import * as dataset from '@util/dataset';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import '@util/matchers';
import { expectErrorResponse } from '@util/response';
import { getPropNameArray, queryTable, setupDb } from '@util/setup';
import { defaultGenericNetworkDbData } from 'generic/networkdb/datasets/defaultSetup';
import { lines } from 'generic/networkdb/datasets/defaultSetup/lines';
import { routes } from 'generic/networkdb/datasets/defaultSetup/routes';
import { buildRoute } from 'generic/networkdb/datasets/factories';
import { genericNetworkDbSchema } from 'generic/networkdb/datasets/schema';
import {
  Route,
  RouteDirection,
  routeProps,
} from 'generic/networkdb/datasets/types';
import { DateTime } from 'luxon';
import * as rp from 'request-promise';

const toBeInserted = (
  onLineId: string,
  validityStart: DateTime | null,
  validityEnd: DateTime | null,
): Partial<Route> => ({
  ...buildRoute('new route'),
  on_line_id: onLineId,
  direction: RouteDirection.Clockwise,
  priority: 30,
  validity_start: validityStart,
  validity_end: validityEnd,
});

const buildMutation = (
  onLineId: string,
  validityStart: DateTime | null,
  validityEnd: DateTime | null,
) => `
  mutation {
    insert_route_route(objects: ${dataset.toGraphQlObject(
      toBeInserted(onLineId, validityStart, validityEnd),
      ['direction'],
    )}) {
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

  const shouldReturnErrorResponse = (
    onLineId: string,
    validityStart: DateTime | null,
    validityEnd: DateTime | null,
  ) =>
    it('should return error response', async () => {
      await rp
        .post({
          ...config.hasuraRequestTemplate,
          body: {
            query: buildMutation(onLineId, validityStart, validityEnd),
          },
        })
        .then(
          expectErrorResponse(
            "route validity period must lie within its line's validity period",
          ),
        );
    });

  const shouldNotModifyDatabase = (
    onLineId: string,
    validityStart: DateTime | null,
    validityEnd: DateTime | null,
  ) =>
    it('should not modify the database', async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: {
          query: buildMutation(onLineId, validityStart, validityEnd),
        },
      });

      const response = await queryTable(
        dbConnection,
        genericNetworkDbSchema['route.route'],
      );

      expect(response.rowCount).toEqual(routes.length);
      expect(response.rows).toEqual(expect.arrayContaining(routes));
    });

  const shouldReturnCorrectResponse = (
    onLineId: string,
    validityStart: DateTime | null,
    validityEnd: DateTime | null,
  ) =>
    it('should return correct response', async () => {
      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: {
          query: buildMutation(onLineId, validityStart, validityEnd),
        },
      });

      expect(response).toEqual(
        expect.objectContaining({
          data: {
            insert_route_route: {
              returning: [
                {
                  ...dataset.asGraphQlDateObject(
                    toBeInserted(onLineId, validityStart, validityEnd),
                  ),
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

  const shouldInsertCorrectRowIntoDatabase = (
    onLineId: string,
    validityStart: DateTime | null,
    validityEnd: DateTime | null,
  ) =>
    it('should insert correct row into the database', async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: {
          query: buildMutation(onLineId, validityStart, validityEnd),
        },
      });

      const response = await queryTable(
        dbConnection,
        genericNetworkDbSchema['route.route'],
      );

      expect(response.rowCount).toEqual(routes.length + 1);

      expect(response.rows).toEqual(
        expect.arrayContaining([
          {
            ...toBeInserted(onLineId, validityStart, validityEnd),
            route_id: expect.any(String),
          },
          ...routes,
        ]),
      );
    });

  describe('which is valid indefinitely, but its line is not', () => {
    shouldReturnErrorResponse(lines[1].line_id, null, null);
    shouldNotModifyDatabase(lines[1].line_id, null, null);
  });

  describe('which is valid indefinitely and its line is valid indefinitely', () => {
    shouldReturnCorrectResponse(lines[4].line_id, null, null);
    shouldInsertCorrectRowIntoDatabase(lines[4].line_id, null, null);
  });

  describe("which is valid for a fixed period not entirely covered by it's line's validity period", () => {
    shouldReturnErrorResponse(
      lines[1].line_id,
      DateTime.fromISO('2044-03-01'),
      DateTime.fromISO('2045-03-01'),
    );
    shouldNotModifyDatabase(
      lines[1].line_id,
      DateTime.fromISO('2044-03-01'),
      DateTime.fromISO('2045-03-01'),
    );
  });

  describe("which is valid for a fixed period entirely covered by it's line's validity period", () => {
    shouldReturnCorrectResponse(
      lines[1].line_id,
      DateTime.fromISO('2044-07-01'),
      DateTime.fromISO('2045-03-01'),
    );
    shouldInsertCorrectRowIntoDatabase(
      lines[1].line_id,
      DateTime.fromISO('2044-07-01'),
      DateTime.fromISO('2045-03-01'),
    );
  });
});
