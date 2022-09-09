import * as rp from 'request-promise';
import * as pg from 'pg';
import * as config from '@config';
import * as dataset from '@util/dataset';
import { infrastructureLinks } from '@datasets/defaultSetup/infrastructure-links';
import { scheduledStopPoints } from '@datasets/defaultSetup/scheduled-stop-points';
import '@util/matchers';
import {
  LinkDirection,
  ScheduledStopPoint,
  ScheduledStopPointProps,
  VehicleMode,
} from '@datasets/types';
import { asDbGeometryObject, asDbGeometryObjectArray } from '@util/dataset';
import { getPropNameArray, queryTable, setupDb } from '@datasets/setup';

const VEHICLE_MODE = VehicleMode.Bus;

const buildMutation = (toBeInserted: Partial<ScheduledStopPoint>) => `
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

describe('Insert scheduled stop point', () => {
  let dbConnectionPool: pg.Pool;

  beforeAll(() => {
    dbConnectionPool = new pg.Pool(config.databaseConfig);
  });

  afterAll(() => dbConnectionPool.end());

  beforeEach(() => setupDb(dbConnectionPool));

  const shouldReturnCorrectResponse = (
    toBeInserted: Partial<ScheduledStopPoint>,
  ) =>
    it('should return correct response', async () => {
      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeInserted) },
      });

      expect(response).toEqual(
        expect.objectContaining({
          data: {
            insert_service_pattern_scheduled_stop_point: {
              returning: [
                {
                  ...dataset.asGraphQlTimestampObject(toBeInserted),
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

  const shouldInsertCorrectRowIntoDatabase = (
    toBeInserted: Partial<ScheduledStopPoint>,
  ) =>
    it('should insert correct row into the database', async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeInserted) },
      });

      const response = await queryTable(
        dbConnectionPool,
        'service_pattern.scheduled_stop_point',
      );

      expect(response.rowCount).toEqual(scheduledStopPoints.length + 1);

      expect(response.rows).toEqual(
        expect.arrayContaining([
          {
            ...asDbGeometryObject(toBeInserted, ['measured_location']),
            scheduled_stop_point_id: expect.any(String),
          },
          ...asDbGeometryObjectArray(scheduledStopPoints, [
            'measured_location',
          ]),
        ]),
      );
    });

  describe('whose validity period conflicts with open validity start but has different priority', () => {
    const toBeInserted: Partial<ScheduledStopPoint> = {
      located_on_infrastructure_link_id:
        infrastructureLinks[1].infrastructure_link_id,
      direction: LinkDirection.Forward,
      measured_location: {
        type: 'Point',
        coordinates: [10.1, 9.2, 0],
        crs: {
          properties: { name: 'urn:ogc:def:crs:EPSG::4326' },
          type: 'name',
        },
      },
      label: 'stop2',
      priority: 10,
      validity_start: new Date('2062-01-03 12:34:56'),
      validity_end: new Date('2063-01-03 12:34:56'),
    };

    shouldReturnCorrectResponse(toBeInserted);

    shouldInsertCorrectRowIntoDatabase(toBeInserted);
  });

  describe('whose validity period conflicts with open validity start but has different label', () => {
    const toBeInserted: Partial<ScheduledStopPoint> = {
      located_on_infrastructure_link_id:
        infrastructureLinks[1].infrastructure_link_id,
      direction: LinkDirection.Forward,
      measured_location: {
        type: 'Point',
        coordinates: [10.1, 9.2, 0],
        crs: {
          properties: { name: 'urn:ogc:def:crs:EPSG::4326' },
          type: 'name',
        },
      },
      label: 'stop2A',
      priority: 30,
      validity_start: new Date('2062-01-03 12:34:56'),
      validity_end: new Date('2063-01-03 12:34:56'),
    };

    shouldReturnCorrectResponse(toBeInserted);

    shouldInsertCorrectRowIntoDatabase(toBeInserted);
  });

  describe('whose validity period does not conflict with open validity start', () => {
    const toBeInserted: Partial<ScheduledStopPoint> = {
      located_on_infrastructure_link_id:
        infrastructureLinks[1].infrastructure_link_id,
      direction: LinkDirection.Forward,
      measured_location: {
        type: 'Point',
        coordinates: [10.1, 9.2, 0],
        crs: {
          properties: { name: 'urn:ogc:def:crs:EPSG::4326' },
          type: 'name',
        },
      },
      label: 'stop2',
      priority: 30,
      validity_start: new Date('2064-01-03 12:34:56'),
      validity_end: new Date('2065-01-03 12:34:56'),
    };

    shouldReturnCorrectResponse(toBeInserted);

    shouldInsertCorrectRowIntoDatabase(toBeInserted);
  });

  describe('whose validity period does not overlap with other validity period ', () => {
    const toBeInserted: Partial<ScheduledStopPoint> = {
      located_on_infrastructure_link_id:
        infrastructureLinks[0].infrastructure_link_id,
      direction: LinkDirection.Forward,
      measured_location: {
        type: 'Point',
        coordinates: [12.1, 11.2, 0],
        crs: {
          properties: { name: 'urn:ogc:def:crs:EPSG::4326' },
          type: 'name',
        },
      },
      label: 'stop1',
      priority: 10,
      validity_start: new Date('2060-01-16 12:34:56'),
      validity_end: new Date('2061-05-01 12:34:56'),
    };

    shouldReturnCorrectResponse(toBeInserted);

    shouldInsertCorrectRowIntoDatabase(toBeInserted);
  });

  describe('whose validity period is entirely contained in other validity period but has different priority', () => {
    const toBeInserted: Partial<ScheduledStopPoint> = {
      located_on_infrastructure_link_id:
        infrastructureLinks[0].infrastructure_link_id,
      direction: LinkDirection.Forward,
      measured_location: {
        type: 'Point',
        coordinates: [12.1, 11.2, 0],
        crs: {
          properties: { name: 'urn:ogc:def:crs:EPSG::4326' },
          type: 'name',
        },
      },
      label: 'stop1',
      priority: 20,
      validity_start: new Date('2065-01-05 12:34:56'),
      validity_end: new Date('2065-01-08 12:34:56'),
    };

    shouldReturnCorrectResponse(toBeInserted);

    shouldInsertCorrectRowIntoDatabase(toBeInserted);
  });

  describe('whose validity period is entirely contained in other validity period but both have draft priority', () => {
    const toBeInserted: Partial<ScheduledStopPoint> = {
      located_on_infrastructure_link_id:
        infrastructureLinks[5].infrastructure_link_id,
      direction: LinkDirection.Forward,
      measured_location: {
        type: 'Point',
        coordinates: [12.1, 11.2, 0],
        crs: {
          properties: { name: 'urn:ogc:def:crs:EPSG::4326' },
          type: 'name',
        },
      },
      label: 'stopZ2',
      priority: 30,
      validity_start: new Date('2063-01-05 12:34:56'),
      validity_end: new Date('2064-01-08 12:34:56'),
    };

    shouldReturnCorrectResponse(toBeInserted);

    shouldInsertCorrectRowIntoDatabase(toBeInserted);
  });
});
