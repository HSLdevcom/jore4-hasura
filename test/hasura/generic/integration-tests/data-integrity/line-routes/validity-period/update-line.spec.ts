import * as config from '@config';
import { defaultTableConfig } from '@datasets-generic/defaultSetup';
import { lines } from '@datasets-generic/defaultSetup/lines';
import { Line, lineProps } from '@datasets-generic/types';
import * as dataset from '@util/dataset';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import '@util/matchers';
import { expectErrorResponse } from '@util/response';
import { getPropNameArray, queryTable, setupDb } from '@util/setup';
import { LocalDate } from 'local-date';
import * as rp from 'request-promise';

const buildMutation = (line: Line, toBeUpdated: Partial<Line>) => `
  mutation {
    update_route_line(
      where: {
        line_id: {_eq: "${line.line_id}"}
      },
      _set: ${dataset.toGraphQlObject(toBeUpdated, [
        'primary_vehicle_mode',
        'type_of_line',
      ])}
    ) {
      returning {
        ${getPropNameArray(lineProps).join(',')}
      }
    }
  }
`;

const completeUpdated = (line: Line, toBeUpdated: Partial<Line>) => ({
  ...line,
  ...toBeUpdated,
});

describe('Update line', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(config.networkDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  beforeEach(() => setupDb(dbConnection, defaultTableConfig));

  const shouldReturnErrorResponse = (line: Line, toBeUpdated: Partial<Line>) =>
    it('should return error response', async () => {
      await rp
        .post({
          ...config.hasuraRequestTemplate,
          body: { query: buildMutation(line, toBeUpdated) },
        })
        .then(
          expectErrorResponse(
            "line validity period must span all its routes' validity periods",
          ),
        );
    });

  const shouldNotModifyDatabase = (line: Line, toBeUpdated: Partial<Line>) =>
    it('should not modify the database', async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(line, toBeUpdated) },
      });

      const response = await queryTable(dbConnection, 'route.line');

      expect(response.rowCount).toEqual(lines.length);
      expect(response.rows).toEqual(expect.arrayContaining(lines));
    });

  const shouldReturnCorrectResponse = (
    line: Line,
    toBeUpdated: Partial<Line>,
  ) =>
    it('should return correct response', async () => {
      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(line, toBeUpdated) },
      });

      expect(response).toEqual(
        expect.objectContaining({
          data: {
            update_route_line: {
              returning: [
                dataset.asGraphQlDateObject(completeUpdated(line, toBeUpdated)),
              ],
            },
          },
        }),
      );
    });

  const shouldUpdateCorrectRowInDatabase = (
    line: Line,
    toBeUpdated: Partial<Line>,
  ) =>
    it('should update correct row into the database', async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(line, toBeUpdated) },
      });

      const response = await queryTable(dbConnection, 'route.line');

      const updated = completeUpdated(line, toBeUpdated);

      expect(response.rowCount).toEqual(lines.length);
      expect(response.rows).toEqual(
        expect.arrayContaining([
          updated,
          ...lines.filter((item) => item.line_id !== updated.line_id),
        ]),
      );
    });

  describe('with a fixed validity start time not spanning the validity time of a route belonging to the line', () => {
    const toBeUpdated = { validity_start: new LocalDate('2045-03-02') };

    shouldReturnErrorResponse(lines[1], toBeUpdated);
    shouldNotModifyDatabase(lines[1], toBeUpdated);
  });

  describe('with a fixed validity end time not spanning the validity time of a route belonging to the line', () => {
    const toBeUpdated = { validity_end: new LocalDate('2044-08-01') };

    shouldReturnErrorResponse(lines[1], toBeUpdated);
    shouldNotModifyDatabase(lines[1], toBeUpdated);
  });

  describe('with a fixed validity start time spanning the validity time of a route belonging to the line', () => {
    const toBeUpdated = { validity_start: new LocalDate('2043-03-02') };

    shouldReturnCorrectResponse(lines[1], toBeUpdated);
    shouldUpdateCorrectRowInDatabase(lines[1], toBeUpdated);
  });

  describe('with infinitely valid validity start', () => {
    const toBeUpdated = { validity_start: null };

    shouldReturnCorrectResponse(lines[1], toBeUpdated);
    shouldUpdateCorrectRowInDatabase(lines[1], toBeUpdated);
  });
});
