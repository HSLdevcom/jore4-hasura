import * as config from '@config';
import { lines } from '@datasets-generic/defaultSetup/lines';
import { buildLine, buildLocalizedString } from '@datasets-generic/factories';
import { Line, lineProps, VehicleMode } from '@datasets-generic/types';
import * as dataset from '@util/dataset';
import '@util/matchers';
import { expectErrorResponse } from '@util/response';
import { getPropNameArray, queryTable, setupDb } from '@util/setup';
import { LocalDate } from 'local-date';
import * as pg from 'pg';
import * as rp from 'request-promise';

const buildMutation = (toBeInserted: Partial<Line>) => `
  mutation {
    insert_route_line(objects: ${dataset.toGraphQlObject(toBeInserted, [
      'primary_vehicle_mode',
      'type_of_line',
    ])}) {
      returning {
        ${getPropNameArray(lineProps).join(',')}
      }
    }
  }
`;

describe('Insert line', () => {
  let dbConnectionPool: pg.Pool;

  beforeAll(() => {
    dbConnectionPool = new pg.Pool(config.networkDbConfig);
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
      validity_start: new LocalDate('2041-06-01'),
      validity_end: new LocalDate('2042-05-31'),
    };

    shouldReturnErrorResponse(toBeInserted);

    shouldNotModifyDatabase(toBeInserted);
  });

  describe('whose validity period overlaps partially with existing validity period', () => {
    const toBeInserted: Partial<Line> = {
      ...buildLine('2', VehicleMode.Bus),
      priority: 10,
      validity_start: new LocalDate('2045-04-01'),
      validity_end: new LocalDate('2046-04-30'),
    };

    shouldReturnErrorResponse(toBeInserted);

    shouldNotModifyDatabase(toBeInserted);
  });

  describe('whose validity period is entirely contained in other validity period', () => {
    const toBeInserted: Partial<Line> = {
      ...buildLine('2', VehicleMode.Bus),
      priority: 10,
      validity_start: new LocalDate('2044-06-01'),
      validity_end: new LocalDate('2045-03-31'),
    };

    shouldReturnErrorResponse(toBeInserted);

    shouldNotModifyDatabase(toBeInserted);
  });
});
