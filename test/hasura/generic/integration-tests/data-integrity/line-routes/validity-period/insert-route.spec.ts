import * as config from '@config';
import { lines } from '@datasets-generic/defaultSetup/lines';
import { routes } from '@datasets-generic/defaultSetup/routes';
import { buildRoute } from '@datasets-generic/factories';
import { Route, RouteDirection, routeProps } from '@datasets-generic/types';
import * as dataset from '@util/dataset';
import '@util/matchers';
import { expectErrorResponse } from '@util/response';
import { getPropNameArray, queryTable, setupDb } from '@util/setup';
import { LocalDate } from 'local-date';
import * as pg from 'pg';
import * as rp from 'request-promise';

const toBeInserted = (
  onLineId: string,
  validityStart: LocalDate | null,
  validityEnd: LocalDate | null,
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
  validityStart: LocalDate | null,
  validityEnd: LocalDate | null,
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
  let dbConnectionPool: pg.Pool;

  beforeAll(() => {
    dbConnectionPool = new pg.Pool(config.networkDbConfig);
  });

  afterAll(() => dbConnectionPool.end());

  beforeEach(() => setupDb(dbConnectionPool));

  const shouldReturnErrorResponse = (
    onLineId: string,
    validityStart: LocalDate | null,
    validityEnd: LocalDate | null,
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
    validityStart: LocalDate | null,
    validityEnd: LocalDate | null,
  ) =>
    it('should not modify the database', async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: {
          query: buildMutation(onLineId, validityStart, validityEnd),
        },
      });

      const response = await queryTable(dbConnectionPool, 'route.route');

      expect(response.rowCount).toEqual(routes.length);
      expect(response.rows).toEqual(expect.arrayContaining(routes));
    });

  const shouldReturnCorrectResponse = (
    onLineId: string,
    validityStart: LocalDate | null,
    validityEnd: LocalDate | null,
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
    validityStart: LocalDate | null,
    validityEnd: LocalDate | null,
  ) =>
    it('should insert correct row into the database', async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: {
          query: buildMutation(onLineId, validityStart, validityEnd),
        },
      });

      const response = await queryTable(dbConnectionPool, 'route.route');

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
      new LocalDate('2044-03-01'),
      new LocalDate('2045-03-01'),
    );
    shouldNotModifyDatabase(
      lines[1].line_id,
      new LocalDate('2044-03-01'),
      new LocalDate('2045-03-01'),
    );
  });

  describe("which is valid for a fixed period entirely covered by it's line's validity period", () => {
    shouldReturnCorrectResponse(
      lines[1].line_id,
      new LocalDate('2044-07-01'),
      new LocalDate('2045-03-01'),
    );
    shouldInsertCorrectRowIntoDatabase(
      lines[1].line_id,
      new LocalDate('2044-07-01'),
      new LocalDate('2045-03-01'),
    );
  });
});
