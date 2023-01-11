import * as config from '@config';
import { lines } from '@datasets-generic/defaultSetup/lines';
import { routes } from '@datasets-generic/defaultSetup/routes';
import { buildRoute } from '@datasets-generic/factories';
import { getPropNameArray, queryTable, setupDb } from '@datasets-generic/setup';
import { Route, RouteDirection, RouteProps } from '@datasets-generic/types';
import * as dataset from '@util/dataset';
import '@util/matchers';
import { expectErrorResponse } from '@util/response';
import { LocalDate } from 'local-date';
import * as pg from 'pg';
import * as rp from 'request-promise';

const toBeInserted = (
  onLineId: string | undefined,
  priority: number,
): Partial<Route> => ({
  ...buildRoute('new route'),
  on_line_id: onLineId,
  direction: RouteDirection.Clockwise,
  priority,
  validity_start: new LocalDate('2044-05-01'),
  validity_end: new LocalDate('2045-04-30'),
});

const buildMutation = (onLineId: string | undefined, priority: number) => `
  mutation {
    insert_route_route(objects: ${dataset.toGraphQlObject(
      toBeInserted(onLineId, priority),
      ['direction'],
    )}) {
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

  const shouldReturnErrorResponse = (
    onLineId: string | undefined,
    priority: number,
    expectedErrorMsg?: string,
  ) =>
    it('should return error response', async () => {
      await rp
        .post({
          ...config.hasuraRequestTemplate,
          body: { query: buildMutation(onLineId, priority) },
        })
        .then(
          expectErrorResponse(
            expectedErrorMsg || 'route priority must be >= line priority',
          ),
        );
    });

  const shouldNotModifyDatabase = (
    onLineId: string | undefined,
    priority: number,
  ) =>
    it('should not modify the database', async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(onLineId, priority) },
      });

      const response = await queryTable(dbConnectionPool, 'route.route');

      expect(response.rowCount).toEqual(routes.length);
      expect(response.rows).toEqual(expect.arrayContaining(routes));
    });

  const shouldReturnCorrectResponse = (
    onLineId: string | undefined,
    priority: number,
  ) =>
    it('should return correct response', async () => {
      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(onLineId, priority) },
      });

      expect(response).toEqual(
        expect.objectContaining({
          data: {
            insert_route_route: {
              returning: [
                {
                  ...dataset.asGraphQlDateObject(
                    toBeInserted(onLineId, priority),
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
    onLineId: string | undefined,
    priority: number,
  ) =>
    it('should insert correct row into the database', async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(onLineId, priority) },
      });

      const response = await queryTable(dbConnectionPool, 'route.route');

      expect(response.rowCount).toEqual(routes.length + 1);

      expect(response.rows).toEqual(
        expect.arrayContaining([
          {
            ...toBeInserted(onLineId, priority),
            route_id: expect.any(String),
          },
          ...routes,
        ]),
      );
    });

  describe('without line ID', () => {
    shouldReturnErrorResponse(undefined, 50, 'Not-NULL violation');
    shouldNotModifyDatabase(undefined, 50);
  });

  describe("whose priority is lower than the line's priority", () => {
    shouldReturnErrorResponse(lines[1].line_id, lines[1].priority - 10);
    shouldNotModifyDatabase(lines[1].line_id, lines[1].priority - 10);
  });

  describe("whose priority is equal to the line's priority", () => {
    shouldReturnCorrectResponse(lines[1].line_id, lines[1].priority);
    shouldInsertCorrectRowIntoDatabase(lines[1].line_id, lines[1].priority);
  });

  describe("whose priority is higher than the line's priority", () => {
    shouldReturnCorrectResponse(lines[1].line_id, lines[1].priority + 10);
    shouldInsertCorrectRowIntoDatabase(
      lines[1].line_id,
      lines[1].priority + 10,
    );
  });
});
