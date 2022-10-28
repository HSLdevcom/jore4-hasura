import * as config from '@config';
import { lines } from '@datasets/defaultSetup/lines';
import { buildLine, buildLocalizedString } from '@datasets/factories';
import { getPropNameArray, queryTable, setupDb } from '@datasets/setup';
import { Line, LineProps, VehicleMode } from '@datasets/types';
import * as dataset from '@util/dataset';
import '@util/matchers';
import * as pg from 'pg';
import * as rp from 'request-promise';
import { LocalDate } from 'local-date';

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

  const shouldReturnCorrectResponse = (toBeInserted: Partial<Line>) =>
    it('should return correct response', async () => {
      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeInserted) },
      });

      expect(response).toEqual(
        expect.objectContaining({
          data: {
            insert_route_line: {
              returning: [
                {
                  ...dataset.asGraphQlDateObject(toBeInserted),
                  line_id: expect.any(String),
                },
              ],
            },
          },
        }),
      );

      // check the new ID is a valid UUID
      expect(
        response.data.insert_route_line.returning[0].line_id,
      ).toBeValidUuid();
    });

  const shouldInsertCorrectRowIntoDatabase = (toBeInserted: Partial<Line>) =>
    it('should insert correct row into the database', async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeInserted) },
      });

      const response = await queryTable(dbConnectionPool, 'route.line');

      expect(response.rowCount).toEqual(lines.length + 1);

      expect(response.rows).toEqual(
        expect.arrayContaining([
          {
            ...toBeInserted,
            line_id: expect.any(String),
          },
          ...lines,
        ]),
      );
    });

  describe('whose validity period conflicts with open validity start but has different priority', () => {
    const toBeInserted: Partial<Line> = {
      ...buildLine('34', VehicleMode.Tram),
      name_i18n: buildLocalizedString('conflicting transport tram line 34'),
      short_name_i18n: buildLocalizedString('conflicting line 34'),
      priority: 10,
      validity_start: new LocalDate('2041-06-01'),
      validity_end: new LocalDate('2042-05-31'),
    };

    shouldReturnCorrectResponse(toBeInserted);

    shouldInsertCorrectRowIntoDatabase(toBeInserted);
  });

  describe('whose validity period conflicts with open validity start but has different label', () => {
    const toBeInserted: Partial<Line> = {
      ...buildLine('34', VehicleMode.Tram),
      label: '35',
      name_i18n: buildLocalizedString('conflicting transport tram line 34'),
      short_name_i18n: buildLocalizedString('conflicting line 34'),
      priority: 20,
      validity_start: new LocalDate('2041-06-01'),
      validity_end: new LocalDate('2042-05-31'),
    };

    shouldReturnCorrectResponse(toBeInserted);

    shouldInsertCorrectRowIntoDatabase(toBeInserted);
  });

  describe('whose validity period does not conflict with open validity start', () => {
    const toBeInserted: Partial<Line> = {
      ...buildLine('34', VehicleMode.Tram),
      name_i18n: buildLocalizedString('conflicting transport tram line 34'),
      short_name_i18n: buildLocalizedString('conflicting line 34'),
      priority: 20,
      validity_start: new LocalDate('2045-06-01'),
      validity_end: new LocalDate('2047-05-31'),
    };

    shouldReturnCorrectResponse(toBeInserted);

    shouldInsertCorrectRowIntoDatabase(toBeInserted);
  });

  describe('whose validity period does not overlap with other validity period ', () => {
    const toBeInserted: Partial<Line> = {
      ...buildLine('2', VehicleMode.Bus),
      priority: 10,
      validity_start: new LocalDate('2045-05-01'),
      validity_end: new LocalDate('2046-05-31'),
    };

    shouldReturnCorrectResponse(toBeInserted);

    shouldInsertCorrectRowIntoDatabase(toBeInserted);
  });

  describe('whose validity period is entirely contained in other validity period but has different priority', () => {
    const toBeInserted: Partial<Line> = {
      ...buildLine('2', VehicleMode.Bus),
      priority: 20,
      validity_start: new LocalDate('2044-06-01'),
      validity_end: new LocalDate('2045-03-31'),
    };

    shouldReturnCorrectResponse(toBeInserted);

    shouldInsertCorrectRowIntoDatabase(toBeInserted);
  });

  describe('whose validity period is entirely contained in other validity period but both have draft priority', () => {
    const toBeInserted: Partial<Line> = {
      ...buildLine('77', VehicleMode.Tram),
      priority: 30,
      validity_start: new LocalDate('2043-06-01'),
      validity_end: new LocalDate('2044-03-31'),
    };

    shouldReturnCorrectResponse(toBeInserted);

    shouldInsertCorrectRowIntoDatabase(toBeInserted);
  });
});
