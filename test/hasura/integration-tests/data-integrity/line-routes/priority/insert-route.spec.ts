import * as config from '@config';
import { lines } from '@datasets/defaultSetup/lines';
import { routes } from '@datasets/defaultSetup/routes';
import { scheduledStopPoints } from '@datasets/defaultSetup/scheduled-stop-points';
import { buildRoute } from '@datasets/factories';
import { getPropNameArray, queryTable, setupDb } from '@datasets/setup';
import { Route, RouteDirection, RouteProps } from '@datasets/types';
import * as dataset from '@util/dataset';
import '@util/matchers';
import { expectErrorResponse } from '@util/response';
import * as pg from 'pg';
import * as rp from 'request-promise';

const toBeInserted = (
  on_line_id: string | undefined,
  priority: number,
): Partial<Route> => ({
  ...buildRoute('new route'),
  on_line_id,
  direction: RouteDirection.Clockwise,
  priority,
  validity_start: new Date('2044-05-01 23:11:32Z'),
  validity_end: new Date('2045-05-01 23:11:32Z'),
});

const buildMutation = (on_line_id: string | undefined, priority: number) => `
  mutation {
    insert_route_route(objects: ${dataset.toGraphQlObject(
      toBeInserted(on_line_id, priority),
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
    on_line_id: string | undefined,
    priority: number,
    expectedErrorMsg?: string,
  ) =>
    it('should return error response', async () => {
      await rp
        .post({
          ...config.hasuraRequestTemplate,
          body: { query: buildMutation(on_line_id, priority) },
        })
        .then(
          expectErrorResponse(
            expectedErrorMsg || 'route priority must be >= line priority',
          ),
        );
    });

  const shouldNotModifyDatabase = (
    on_line_id: string | undefined,
    priority: number,
  ) =>
    it('should not modify the database', async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(on_line_id, priority) },
      });

      const response = await queryTable(dbConnectionPool, 'route.route');

      expect(response.rowCount).toEqual(routes.length);
      expect(response.rows).toEqual(expect.arrayContaining(routes));
    });

  const shouldReturnCorrectResponse = (
    on_line_id: string | undefined,
    priority: number,
  ) =>
    it('should return correct response', async () => {
      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(on_line_id, priority) },
      });

      expect(response).toEqual(
        expect.objectContaining({
          data: {
            insert_route_route: {
              returning: [
                {
                  ...dataset.asGraphQlTimestampObject(
                    toBeInserted(on_line_id, priority),
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
    on_line_id: string | undefined,
    priority: number,
  ) =>
    it('should insert correct row into the database', async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(on_line_id, priority) },
      });

      const response = await queryTable(dbConnectionPool, 'route.route');

      expect(response.rowCount).toEqual(routes.length + 1);

      expect(response.rows).toEqual(
        expect.arrayContaining([
          {
            ...toBeInserted(on_line_id, priority),
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
