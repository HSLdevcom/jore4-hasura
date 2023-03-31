import * as config from '@config';
import * as dataset from '@util/dataset';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import { expectErrorResponse } from '@util/response';
import { getPropNameArray, queryTable, setupDb } from '@util/setup';
import {
  defaultGenericNetworkDbData,
  lines,
  routes,
} from 'generic/networkdb/datasets/defaultSetup';
import { genericNetworkDbSchema } from 'generic/networkdb/datasets/schema';
import { Line, lineProps } from 'generic/networkdb/datasets/types';
import * as rp from 'request-promise';

const buildMutation = (toBeUpdated: Partial<Line>) => `
  mutation {
    update_route_line(
      where: {
        line_id: {_eq: "${lines[1].line_id}"}
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

const completeUpdated = (toBeUpdated: Partial<Line>) => ({
  ...lines[1],
  ...toBeUpdated,
});

describe('Update line', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(config.networkDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  beforeEach(() => setupDb(dbConnection, defaultGenericNetworkDbData));

  const shouldReturnErrorResponse = (toBeUpdated: Partial<Line>) =>
    it('should return error response', async () => {
      await rp
        .post({
          ...config.hasuraRequestTemplate,
          body: { query: buildMutation(toBeUpdated) },
        })
        .then(expectErrorResponse('route priority must be >= line priority'));
    });

  const shouldNotModifyDatabase = (toBeUpdated: Partial<Line>) =>
    it('should not modify the database', async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeUpdated) },
      });

      const response = await queryTable(
        dbConnection,
        genericNetworkDbSchema['route.line'],
      );

      expect(response.rowCount).toEqual(lines.length);
      expect(response.rows).toEqual(expect.arrayContaining(lines));
    });

  const shouldReturnCorrectResponse = (toBeUpdated: Partial<Line>) =>
    it('should return correct response', async () => {
      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeUpdated) },
      });

      expect(response).toEqual(
        expect.objectContaining({
          data: {
            update_route_line: {
              returning: [
                dataset.asGraphQlDateObject(completeUpdated(toBeUpdated)),
              ],
            },
          },
        }),
      );
    });

  const shouldUpdateCorrectRowInDatabase = (toBeUpdated: Partial<Line>) =>
    it('should update correct row into the database', async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeUpdated) },
      });

      const response = await queryTable(
        dbConnection,
        genericNetworkDbSchema['route.line'],
      );

      const updated = completeUpdated(toBeUpdated);

      expect(response.rowCount).toEqual(lines.length);
      expect(response.rows).toEqual(
        expect.arrayContaining([
          updated,
          ...lines.filter((line) => line.line_id !== updated.line_id),
        ]),
      );
    });

  describe('with a priority higher than the priority of a route belonging to the line', () => {
    const toBeUpdated = { priority: routes[1].priority + 10 };

    shouldReturnErrorResponse(toBeUpdated);
    shouldNotModifyDatabase(toBeUpdated);
  });

  describe('with a priority equal to the priority of a route belonging to the line', () => {
    const toBeUpdated = { priority: routes[1].priority };

    shouldReturnCorrectResponse(toBeUpdated);
    shouldUpdateCorrectRowInDatabase(toBeUpdated);
  });

  describe('with a priority lower than the priority of a route belonging to the line', () => {
    const toBeUpdated = { priority: routes[1].priority - 10 };

    shouldReturnCorrectResponse(toBeUpdated);
    shouldUpdateCorrectRowInDatabase(toBeUpdated);
  });
});
