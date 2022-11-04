import * as rp from 'request-promise';
import * as pg from 'pg';
import * as config from '@config';
import * as dataset from '@util/dataset';
import {
  scheduledStopPointInvariants,
  scheduledStopPoints,
} from '@datasets/defaultSetup/scheduled-stop-points';
import '@util/matchers';
import {
  getPropNameArray,
  getTableConfigArray,
  queryTable,
  setupDb,
} from '@datasets/setup';
import { ScheduledStopPointProps } from '@datasets/types';

const toBeDeleted = scheduledStopPoints[1];

const mutation = `
  mutation {
    delete_service_pattern_scheduled_stop_point(where: {scheduled_stop_point_id: {_eq: "${
      toBeDeleted.scheduled_stop_point_id
    }"}}) {
      returning {
        ${getPropNameArray(ScheduledStopPointProps).join(',')}
      }
    }
  }
`;

describe('Delete scheduled_stop_point', () => {
  let dbConnectionPool: pg.Pool;

  beforeAll(() => {
    dbConnectionPool = new pg.Pool(config.databaseConfig);
  });

  afterAll(() => dbConnectionPool.end());

  beforeEach(() =>
    setupDb(
      dbConnectionPool,
      getTableConfigArray([
        'infrastructure_network.infrastructure_link',
        'infrastructure_network.vehicle_submode_on_infrastructure_link',
        'service_pattern.scheduled_stop_point_invariant',
        'service_pattern.scheduled_stop_point',
        'service_pattern.vehicle_mode_on_scheduled_stop_point',
      ]),
    ),
  );

  it('should return correct response', async () => {
    const response = await rp.post({
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
    await rp.post({
      ...config.hasuraRequestTemplate,
      body: { query: mutation },
    });

    const response = await queryTable(
      dbConnectionPool,
      'service_pattern.scheduled_stop_point',
    );

    expect(response.rowCount).toEqual(scheduledStopPoints.length - 1);

    expect(response.rows).toEqual(
      expect.arrayContaining(
        dataset.asDbGeometryObjectArray(
          scheduledStopPoints.filter(
            (scheduledStopPoint) =>
              scheduledStopPoint.scheduled_stop_point_id !=
              toBeDeleted.scheduled_stop_point_id,
          ),
          ['measured_location'],
        ),
      ),
    );

    const stopPointInvariantResponse = await queryTable(
      dbConnectionPool,
      'service_pattern.scheduled_stop_point_invariant',
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
