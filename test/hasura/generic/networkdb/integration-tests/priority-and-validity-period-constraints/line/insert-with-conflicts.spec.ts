import * as config from '@config';
import * as dataset from '@util/dataset';
import { buildLocalizedString } from '@util/dataset';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import { expectErrorResponse } from '@util/response';
import { getPropNameArray, queryTable, setupDb } from '@util/setup';
import { defaultGenericNetworkDbData } from 'generic/networkdb/datasets/defaultSetup';
import { lines } from 'generic/networkdb/datasets/defaultSetup/lines';
import { buildLine } from 'generic/networkdb/datasets/factories';
import { genericNetworkDbSchema } from 'generic/networkdb/datasets/schema';
import { Line, lineProps, VehicleMode } from 'generic/networkdb/datasets/types';
import { DateTime } from 'luxon';
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
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(config.networkDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  beforeEach(() => setupDb(dbConnection, defaultGenericNetworkDbData));

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

      const response = await queryTable(
        dbConnection,
        genericNetworkDbSchema['route.line'],
      );

      expect(response.rowCount).toEqual(lines.length);
      expect(response.rows).toEqual(expect.arrayContaining(lines));
    });

  describe('whose validity period conflicts with open validity start', () => {
    const toBeInserted: Partial<Line> = {
      ...buildLine('34', VehicleMode.Tram),
      name_i18n: buildLocalizedString('conflicting transport tram line 34'),
      short_name_i18n: buildLocalizedString('conflicting line 34'),
      priority: 20,
      validity_start: DateTime.fromISO('2041-06-01'),
      validity_end: DateTime.fromISO('2042-05-31'),
    };

    shouldReturnErrorResponse(toBeInserted);

    shouldNotModifyDatabase(toBeInserted);
  });

  describe('whose validity period overlaps partially with existing validity period', () => {
    const toBeInserted: Partial<Line> = {
      ...buildLine('2', VehicleMode.Bus),
      priority: 10,
      validity_start: DateTime.fromISO('2045-04-01'),
      validity_end: DateTime.fromISO('2046-04-30'),
    };

    shouldReturnErrorResponse(toBeInserted);

    shouldNotModifyDatabase(toBeInserted);
  });

  describe('whose validity period is entirely contained in other validity period', () => {
    const toBeInserted: Partial<Line> = {
      ...buildLine('2', VehicleMode.Bus),
      priority: 10,
      validity_start: DateTime.fromISO('2044-06-01'),
      validity_end: DateTime.fromISO('2045-03-31'),
    };

    shouldReturnErrorResponse(toBeInserted);

    shouldNotModifyDatabase(toBeInserted);
  });
});
