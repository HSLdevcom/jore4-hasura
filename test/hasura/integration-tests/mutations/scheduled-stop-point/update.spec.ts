import * as rp from 'request-promise';
import * as pg from 'pg';
import * as config from '@config';
import * as dataset from '@util/dataset';
import { infrastructureLinks } from '@datasets/defaultSetup/infrastructure-links';
import { scheduledStopPoints } from '@datasets/defaultSetup/scheduled-stop-points';
import { ScheduledStopPoint, ScheduledStopPointProps } from '@datasets/types';
import '@util/matchers';
import { getPropNameArray, queryTable, setupDb } from '@datasets/setup';
import { LocalDate } from 'local-date';

const toBeUpdated: Partial<ScheduledStopPoint> = {
  located_on_infrastructure_link_id:
    infrastructureLinks[0].infrastructure_link_id,
  measured_location: {
    type: 'Point',
    coordinates: [20.1, 19.2, 10],
    crs: {
      properties: { name: 'urn:ogc:def:crs:EPSG::4326' },
      type: 'name',
    },
  } as dataset.GeometryObject,
  priority: 30,
  validity_start: new LocalDate('2077-10-22'),
  validity_end: new LocalDate('2079-10-21'),
};

const completeUpdated: ScheduledStopPoint = {
  ...scheduledStopPoints[2],
  ...toBeUpdated,
};

const mutation = `
  mutation {
    update_service_pattern_scheduled_stop_point(
      where: {
        scheduled_stop_point_id: {_eq: "${
          completeUpdated.scheduled_stop_point_id
        }"}
      },
      _set: ${dataset.toGraphQlObject(toBeUpdated, ['direction'])}
    ) {
      returning {
        ${getPropNameArray(ScheduledStopPointProps).join(',')}
      }
    }
  }
`;

describe('Update scheduled_stop_point', () => {
  let dbConnectionPool: pg.Pool;

  beforeAll(() => {
    dbConnectionPool = new pg.Pool(config.databaseConfig);
  });

  afterAll(() => dbConnectionPool.end());

  beforeEach(() => setupDb(dbConnectionPool));

  it('should return correct response', async () => {
    const response = await rp.post({
      ...config.hasuraRequestTemplate,
      body: { query: mutation },
    });

    expect(response).toEqual(
      expect.objectContaining({
        data: {
          update_service_pattern_scheduled_stop_point: {
            returning: [dataset.asGraphQlDateObject(completeUpdated)],
          },
        },
      }),
    );
  });

  it('should update correct row in the database', async () => {
    await rp.post({
      ...config.hasuraRequestTemplate,
      body: { query: mutation },
    });

    const response = await queryTable(
      dbConnectionPool,
      'service_pattern.scheduled_stop_point',
    );

    expect(response.rowCount).toEqual(scheduledStopPoints.length);

    expect(response.rows).toEqual(
      expect.arrayContaining(
        dataset.asDbGeometryObjectArray(
          [
            completeUpdated,
            ...scheduledStopPoints.filter(
              (scheduledStopPoint) =>
                scheduledStopPoint.scheduled_stop_point_id !=
                completeUpdated.scheduled_stop_point_id,
            ),
          ],
          ['measured_location'],
        ),
      ),
    );
  });
});
