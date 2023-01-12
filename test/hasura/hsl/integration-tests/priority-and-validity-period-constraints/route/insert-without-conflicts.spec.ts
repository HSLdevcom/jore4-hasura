import * as config from '@config';
import { hslLines } from '@datasets-hsl/defaultSetup/lines';
import { hslRoutes } from '@datasets-hsl/defaultSetup/routes';
import { buildHslRoute } from '@datasets-hsl/factories';
import { getPropNameArray, queryTable, setupDb } from '@datasets-hsl/setup';
import { HslRoute, RouteDirection, HslRouteProps } from '@datasets-hsl/types';
import * as dataset from '@util/dataset';
import '@util/matchers';
import { LocalDate } from 'local-date';
import * as pg from 'pg';
import * as rp from 'request-promise';

const buildMutation = (toBeInserted: Partial<HslRoute>) => `
  mutation {
    insert_route_route(objects: ${dataset.toGraphQlObject(toBeInserted, [
      'direction',
    ])}) {
      returning {
        ${getPropNameArray(HslRouteProps).join(',')}
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

  const shouldReturnCorrectResponse = (toBeInserted: Partial<HslRoute>) =>
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

  const shouldInsertCorrectRowIntoDatabase = (
    toBeInserted: Partial<HslRoute>,
  ) =>
    it('should insert correct row into the database', async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeInserted) },
      });

      const response = await queryTable(dbConnectionPool, 'route.route');

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
    const toBeInserted: Partial<HslRoute> = {
      ...buildHslRoute('1'),
      on_line_id: hslLines[0].line_id,
      direction: RouteDirection.Northbound,
      variant: 3,
      priority: 10,
      validity_start: new LocalDate('2044-05-02'),
      validity_end: null,
    };

    shouldReturnCorrectResponse(toBeInserted);

    shouldInsertCorrectRowIntoDatabase(toBeInserted);
  });
});
