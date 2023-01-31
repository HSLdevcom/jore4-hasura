import * as config from '@config';
import { defaultHslNetworkDbData } from '@datasets-hsl/defaultSetup';
import { hslLines } from '@datasets-hsl/defaultSetup/lines';
import { hslRoutes } from '@datasets-hsl/defaultSetup/routes';
import { buildHslRoute } from '@datasets-hsl/factories';
import { hslNetworkDbSchema } from '@datasets-hsl/schema';
import { HslRoute, hslRouteProps, RouteDirection } from '@datasets-hsl/types';
import * as dataset from '@util/dataset';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import '@util/matchers';
import { expectErrorResponse } from '@util/response';
import { getPropNameArray, queryTable, setupDb } from '@util/setup';
import { LocalDate } from 'local-date';
import * as rp from 'request-promise';

const toBeInserted = (
  label: string,
  onLineId: string | undefined,
  variant: number | null,
): Partial<HslRoute> => {
  return buildHslRoute(
    {
      on_line_id: onLineId,
      direction: RouteDirection.Westbound,
      variant,
      priority: 20,
      validity_start: new LocalDate('2044-05-01'),
      validity_end: new LocalDate('2045-04-30'),
    },
    label,
  );
};

const buildMutation = (
  label: string,
  onLineId: string | undefined,
  variant: number | null,
) => `
  mutation {
    insert_route_route(objects: ${dataset.toGraphQlObject(
      toBeInserted(label, onLineId, variant),
      ['direction'],
    )}) {
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

  const shouldReturnErrorResponse = (
    label: string,
    onLineId: string | undefined,
    variant: number | null,
  ) =>
    it('should return error response', async () => {
      await rp
        .post({
          ...config.hasuraRequestTemplate,
          body: { query: buildMutation(label, onLineId, variant) },
        })
        .then(expectErrorResponse());
    });

  const shouldNotModifyDatabase = (
    label: string,
    onLineId: string | undefined,
    variant: number | null,
  ) =>
    it('should not modify the database', async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(label, onLineId, variant) },
      });

      const response = await queryTable(
        dbConnection,
        hslNetworkDbSchema['route.route'],
      );

      expect(response.rowCount).toEqual(hslRoutes.length);
      expect(response.rows).toEqual(expect.arrayContaining(hslRoutes));
    });

  const shouldReturnCorrectResponse = (
    label: string,
    onLineId: string | undefined,
    variant: number | null,
  ) =>
    it('should return correct response', async () => {
      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(label, onLineId, variant) },
      });

      expect(response).toEqual(
        expect.objectContaining({
          data: {
            insert_route_route: {
              returning: [
                {
                  ...dataset.asGraphQlDateObject(
                    toBeInserted(label, onLineId, variant),
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
    label: string,
    onLineId: string | undefined,
    variant: number | null,
  ) =>
    it('should insert correct row into the database', async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(label, onLineId, variant) },
      });

      const response = await queryTable(
        dbConnection,
        hslNetworkDbSchema['route.route'],
      );

      expect(response.rowCount).toEqual(hslRoutes.length + 1);

      expect(response.rows).toEqual(
        expect.arrayContaining([
          {
            ...toBeInserted(label, onLineId, variant),
            route_id: expect.any(String),
          },
          ...hslRoutes,
        ]),
      );
    });

  describe('variant that does not exist', () => {
    shouldReturnCorrectResponse('4', hslLines[1].line_id, 3);
    shouldInsertCorrectRowIntoDatabase('4', hslLines[1].line_id, 3);
  });

  describe('variant that exists', () => {
    shouldReturnErrorResponse('6', hslLines[4].line_id, 3);
    shouldNotModifyDatabase('6', hslLines[4].line_id, 3);
  });

  describe('null variant that exists', () => {
    shouldReturnErrorResponse('4', hslLines[1].line_id, null);
    shouldNotModifyDatabase('4', hslLines[1].line_id, null);
  });
});
