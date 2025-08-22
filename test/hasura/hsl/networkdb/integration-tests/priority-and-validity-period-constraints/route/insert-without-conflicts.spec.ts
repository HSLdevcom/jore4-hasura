import { DateTime } from 'luxon';
import * as config from '@config';
import * as dataset from '@util/dataset';
import { DbConnection, closeDbConnection, createDbConnection } from '@util/db';
import { post } from '@util/fetch-request';
import { getPropNameArray, queryTable, setupDb } from '@util/setup';
import {
  defaultHslNetworkDbData,
  hslLines,
  hslRoutes,
} from 'hsl/networkdb/datasets/defaultSetup';
import { buildHslRoute } from 'hsl/networkdb/datasets/factories';
import { hslNetworkDbSchema } from 'hsl/networkdb/datasets/schema';
import {
  HslRoute,
  RouteDirection,
  hslRouteProps,
} from 'hsl/networkdb/datasets/types';

const buildMutation = (toBeInserted: Partial<HslRoute>) => `
  mutation {
    insert_route_route(objects: ${dataset.toGraphQlObject(toBeInserted, [
      'direction',
    ])}) {
      returning {
        ${getPropNameArray(hslRouteProps).join(',')}
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

  beforeEach(() => setupDb(dbConnection, defaultHslNetworkDbData));

  const shouldReturnCorrectResponse = (toBeInserted: Partial<HslRoute>) =>
    it('should return correct response', async () => {
      const response = await post({
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

  const shouldInsertCorrectRowIntoDatabase = (
    toBeInserted: Partial<HslRoute>,
  ) =>
    it('should insert correct row into the database', async () => {
      await post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeInserted) },
      });

      const response = await queryTable(
        dbConnection,
        hslNetworkDbSchema['route.route'],
      );

      expect(response.rowCount).toEqual(hslRoutes.length + 1);

      expect(response.rows).toEqual(
        expect.arrayContaining([
          {
            ...toBeInserted,
            route_id: expect.any(String),
          },
          ...hslRoutes,
        ]),
      );
    });

  describe('whose validity period conflicts with open validity end but has different variant', () => {
    const toBeInserted: Partial<HslRoute> = buildHslRoute(
      {
        on_line_id: hslLines[0].line_id,
        direction: RouteDirection.Northbound,
        variant: 3,
        priority: 10,
        validity_start: DateTime.fromISO('2044-05-02'),
        validity_end: null,
      },
      '6',
    );

    shouldReturnCorrectResponse(toBeInserted);

    shouldInsertCorrectRowIntoDatabase(toBeInserted);
  });
});
