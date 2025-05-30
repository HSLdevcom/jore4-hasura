import * as config from '@config';
import * as dataset from '@util/dataset';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import { post } from '@util/fetch-request';
import {
  getPartialTableData,
  getPropNameArray,
  queryTable,
  setupDb,
} from '@util/setup';
import {
  defaultGenericNetworkDbData,
  scheduledStopPointInvariants,
  scheduledStopPoints,
} from 'generic/networkdb/datasets/defaultSetup';
import { genericNetworkDbSchema } from 'generic/networkdb/datasets/schema';
import { scheduledStopPointProps } from 'generic/networkdb/datasets/types';

const toBeDeleted = scheduledStopPoints[1];

const mutation = `
  mutation {
    delete_service_pattern_scheduled_stop_point(where: {scheduled_stop_point_id: {_eq: "${
      toBeDeleted.scheduled_stop_point_id
    }"}}) {
      returning {
        ${getPropNameArray(scheduledStopPointProps).join(',')}
      }
    }
  }
`;

describe('Delete scheduled_stop_point', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(config.networkDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  beforeEach(() =>
    setupDb(
      dbConnection,
      getPartialTableData(defaultGenericNetworkDbData, [
        'infrastructure_network.infrastructure_link',
        'infrastructure_network.vehicle_submode_on_infrastructure_link',
        'service_pattern.scheduled_stop_point_invariant',
        'service_pattern.scheduled_stop_point',
        'service_pattern.vehicle_mode_on_scheduled_stop_point',
      ]),
    ),
  );

  it('should return correct response', async () => {
    const response = await post({
      ...config.hasuraRequestTemplate,
      body: { query: mutation },
    });

    expect(response).toEqual(
      expect.objectContaining({
        data: {
          delete_service_pattern_scheduled_stop_point: {
            returning: [dataset.asGraphQlDateObject(toBeDeleted)],
          },
        },
      }),
    );
  });

  it('should delete correct row from the database', async () => {
    await post({
      ...config.hasuraRequestTemplate,
      body: { query: mutation },
    });

    const response = await queryTable(
      dbConnection,
      genericNetworkDbSchema['service_pattern.scheduled_stop_point'],
    );

    expect(response.rowCount).toEqual(scheduledStopPoints.length - 1);

    expect(response.rows).toEqual(
      expect.arrayContaining(
        dataset.serializeMatcherInputs(
          scheduledStopPoints.filter(
            (scheduledStopPoint) =>
              scheduledStopPoint.scheduled_stop_point_id !==
              toBeDeleted.scheduled_stop_point_id,
          ),
        ),
      ),
    );

    const stopPointInvariantResponse = await queryTable(
      dbConnection,
      genericNetworkDbSchema['service_pattern.scheduled_stop_point_invariant'],
    );

    expect(stopPointInvariantResponse.rowCount).toEqual(
      scheduledStopPointInvariants.length - 1,
    );
    expect(stopPointInvariantResponse.rows).toEqual(
      expect.arrayContaining(
        scheduledStopPointInvariants.filter(
          (invariant) => invariant.label !== toBeDeleted.label,
        ),
      ),
    );
  });
});
