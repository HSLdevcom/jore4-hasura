import * as config from '@config';
import { hslLines } from '@datasets-hsl/defaultSetup/lines';
import { hslRoutes } from '@datasets-hsl/defaultSetup/routes';
import { buildHslRoute } from '@datasets-hsl/factories';
import { getPropNameArray, queryTable, setupDb } from '@datasets-hsl/setup';
import {
  HslRoute,
  RouteDirection,
  hslRouteProps,
  HslMunicipalityCodeId,
} from '@datasets-hsl/types';
import * as dataset from '@util/dataset';
import '@util/matchers';
import { expectErrorResponse } from '@util/response';
import { LocalDate } from 'local-date';
import * as pg from 'pg';
import * as rp from 'request-promise';

const toBeInserted = (
  label: string,
  onLineId: string | undefined,
  hslMunicipalityCode: HslMunicipalityCodeId | null,
): Partial<HslRoute> => {
  return buildHslRoute(
    {
      on_line_id: onLineId,
      direction: RouteDirection.Westbound,
      hsl_municipality_code: hslMunicipalityCode,
      variant: 3,
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
  hslMunicipalityCode: HslMunicipalityCodeId | null,
) => `
  mutation {
    insert_route_route(objects: ${dataset.toGraphQlObject(
      toBeInserted(label, onLineId, hslMunicipalityCode),
      ['direction'],
    )}) {
      returning {
        ${getPropNameArray(hslRouteProps).join(',')}
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
    label: string,
    onLineId: string | undefined,
    hslMunicipalityCode: HslMunicipalityCodeId | null,
  ) =>
    it('should return error response', async () => {
      await rp
        .post({
          ...config.hasuraRequestTemplate,
          body: { query: buildMutation(label, onLineId, hslMunicipalityCode) },
        })
        .then(expectErrorResponse());
    });

  const shouldNotModifyDatabase = (
    label: string,
    onLineId: string | undefined,
    hslMunicipalityCode: HslMunicipalityCodeId | null,
  ) =>
    it('should not modify the database', async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(label, onLineId, hslMunicipalityCode) },
      });

      const response = await queryTable(dbConnectionPool, 'route.route');

      expect(response.rowCount).toEqual(hslRoutes.length);
      expect(response.rows).toEqual(expect.arrayContaining(hslRoutes));
    });

  const shouldReturnCorrectResponse = (
    label: string,
    onLineId: string | undefined,
    hslMunicipalityCode: HslMunicipalityCodeId | null,
  ) =>
    it('should return correct response', async () => {
      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(label, onLineId, hslMunicipalityCode) },
      });

      expect(response).toEqual(
        expect.objectContaining({
          data: {
            insert_route_route: {
              returning: [
                {
                  ...dataset.asGraphQlDateObject(
                    toBeInserted(label, onLineId, hslMunicipalityCode),
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
    hslMunicipalityCode: HslMunicipalityCodeId | null,
  ) =>
    it('should insert correct row into the database', async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(label, onLineId, hslMunicipalityCode) },
      });

      const response = await queryTable(dbConnectionPool, 'route.route');

      expect(response.rowCount).toEqual(hslRoutes.length + 1);

      expect(response.rows).toEqual(
        expect.arrayContaining([
          {
            ...toBeInserted(label, onLineId, hslMunicipalityCode),
            route_id: expect.any(String),
          },
          ...hslRoutes,
        ]),
      );
    });

  describe('HSL municipality code that does not exist', () => {
    shouldReturnCorrectResponse(
      '4',
      hslLines[1].line_id,
      HslMunicipalityCodeId.EspoonVantaaRegional,
    );
    shouldInsertCorrectRowIntoDatabase(
      '4',
      hslLines[1].line_id,
      HslMunicipalityCodeId.EspoonVantaaRegional,
    );
  });

  describe('HSL municipality code that exists', () => {
    shouldReturnErrorResponse(
      '6',
      hslLines[4].line_id,
      HslMunicipalityCodeId.Helsinki,
    );
    shouldNotModifyDatabase(
      '6',
      hslLines[4].line_id,
      HslMunicipalityCodeId.Helsinki,
    );
  });

  describe('null HSL municipality code that exists', () => {
    shouldReturnErrorResponse('4', hslLines[1].line_id, null);
    shouldNotModifyDatabase('4', hslLines[1].line_id, null);
  });
});
