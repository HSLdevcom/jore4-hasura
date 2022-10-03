import * as rp from 'request-promise';
import * as pg from 'pg';
import * as config from '@config';
import * as dataset from '@util/dataset';
import { infrastructureLinks } from '@datasets/defaultSetup/infrastructure-links';
import {
  scheduledStopPointInvariants,
  scheduledStopPoints,
} from '@datasets/defaultSetup/scheduled-stop-points';
import {
  LinkDirection,
  ScheduledStopPoint,
  ScheduledStopPointProps,
  VehicleMode,
} from '@datasets/types';
import '@util/matchers';
import { getPropNameArray, queryTable, setupDb } from '@datasets/setup';
import { LocalDate } from 'local-date';

const toBeInserted: Partial<ScheduledStopPoint> = {
  located_on_infrastructure_link_id:
    infrastructureLinks[2].infrastructure_link_id,
  direction: LinkDirection.Backward,
  measured_location: {
    type: 'Point',
    coordinates: [12.3, 23.4, 34.5],
    crs: {
      properties: { name: 'urn:ogc:def:crs:EPSG::4326' },
      type: 'name',
    },
  } as dataset.GeometryObject,
  label: 'inserted stop point',
  priority: 50,
  validity_end: new LocalDate('2060-11-03'),
};

const insertedDefaultValues: Partial<ScheduledStopPoint> = {
  validity_start: null,
};

const VEHICLE_MODE = VehicleMode.Bus;

const mutation = `
  mutation {
    insert_service_pattern_scheduled_stop_point(objects: ${dataset.toGraphQlObject(
      {
        ...toBeInserted,
        vehicle_mode_on_scheduled_stop_point: {
          data: {
            vehicle_mode: VEHICLE_MODE,
          },
        },
      },
      ['direction', 'vehicle_mode'],
    )}) {
      returning {
        ${getPropNameArray(ScheduledStopPointProps).join(',')}
      }
    }
  }
`;

describe('Insert scheduled_stop_point', () => {
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
          insert_service_pattern_scheduled_stop_point: {
            returning: [
              {
                ...dataset.asGraphQlTimestampObject(toBeInserted),
                ...insertedDefaultValues,
                scheduled_stop_point_id: expect.any(String),
              },
            ],
          },
        },
      }),
    );

    // check the new ID is a valid UUID
    expect(
      response.data.insert_service_pattern_scheduled_stop_point.returning[0]
        .scheduled_stop_point_id,
    ).toBeValidUuid();
  });

  it('should insert correct row into the database', async () => {
    await rp.post({
      ...config.hasuraRequestTemplate,
      body: { query: mutation },
    });

    const response = await queryTable(
      dbConnectionPool,
      'service_pattern.scheduled_stop_point',
    );

    expect(response.rowCount).toEqual(scheduledStopPoints.length + 1);

    expect(response.rows).toEqual(
      expect.arrayContaining(
        dataset.asDbGeometryObjectArray(
          [
            {
              ...toBeInserted,
              ...insertedDefaultValues,
              scheduled_stop_point_id: expect.any(String),
            },
            ...scheduledStopPoints,
          ],
          ['measured_location'],
        ),
      ),
    );

    const stopPointInvariantResponse = await queryTable(
      dbConnectionPool,
      'internal_service_pattern.scheduled_stop_point_invariant',
    );

    expect(stopPointInvariantResponse.rowCount).toEqual(
      scheduledStopPointInvariants.length + 1,
    );
    expect(stopPointInvariantResponse.rows).toEqual(
      expect.arrayContaining([
        { label: toBeInserted.label },
        ...scheduledStopPointInvariants,
      ]),
    );
  });
});
