import * as config from '@config';
import { lines } from '@datasets/defaultSetup/lines';
import { buildLine, buildLocalizedString } from '@datasets/factories';
import { getPropNameArray, queryTable, setupDb } from '@datasets/setup';
import { Line, LineProps, VehicleMode } from '@datasets/types';
import { expect } from '@jest/globals';
import * as dataset from '@util/dataset';
import '@util/matchers';
import { expectErrorResponse } from '@util/response';
import * as pg from 'pg';
import * as rp from 'request-promise';

const buildMutation = (toBeInserted: Partial<Line>) => `
  mutation {
    insert_route_line(objects: ${dataset.toGraphQlObject(toBeInserted, [
      'primary_vehicle_mode',
      'type_of_line',
    ])}) {
      returning {
        ${getPropNameArray(LineProps).join(',')}
      }
    }
  }
`;

describe('Insert line', () => {
  let dbConnectionPool: pg.Pool;

  beforeAll(() => {
    dbConnectionPool = new pg.Pool(config.databaseConfig);
  });

  afterAll(() => dbConnectionPool.end());

  beforeEach(() => setupDb(dbConnectionPool));

  const shouldReturnErrorResponse = (toBeInserted: Partial<Line>) =>
    it('should return error response', async () => {
      await rp
        .post({
          ...config.hasuraRequestTemplate,
          body: { query: buildMutation(toBeInserted) },
        })
        .then(expectErrorResponse());
    });

  const shouldNotModifyDatabase = (toBeInserted: Partial<Line>) =>
    it('should not modify the database', async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeInserted) },
      });

      const response = await queryTable(dbConnectionPool, 'route.line');

      expect(response.rowCount).toEqual(lines.length);
      expect(response.rows).toEqual(expect.arrayContaining(lines));
    });

  describe('whose validity period conflicts with open validity start', () => {
    const toBeInserted: Partial<Line> = {
      ...buildLine('34', VehicleMode.Tram),
      name_i18n: buildLocalizedString('conflicting transport tram line 34'),
      short_name_i18n: buildLocalizedString('conflicting line 34'),
      priority: 20,
      validity_start: new Date('2041-06-01 23:11:32Z'),
      validity_end: new Date('2042-06-01 23:11:32Z'),
    };

    shouldReturnErrorResponse(toBeInserted);

    shouldNotModifyDatabase(toBeInserted);
  });

  describe('whose validity period overlaps partially with existing validity period', () => {
    const toBeInserted: Partial<Line> = {
      ...buildLine('2', VehicleMode.Bus),
      priority: 10,
      validity_start: new Date('2045-04-01 23:11:32Z'),
      validity_end: new Date('2046-05-01 23:11:32Z'),
    };

    shouldReturnErrorResponse(toBeInserted);

    shouldNotModifyDatabase(toBeInserted);
  });

  describe('whose validity period is entirely contained in other validity period', () => {
    const toBeInserted: Partial<Line> = {
      ...buildLine('2', VehicleMode.Bus),
      priority: 10,
      validity_start: new Date('2044-06-01 23:11:32Z'),
      validity_end: new Date('2045-04-01 23:11:32Z'),
    };

    shouldReturnErrorResponse(toBeInserted);

    shouldNotModifyDatabase(toBeInserted);
  });
});
