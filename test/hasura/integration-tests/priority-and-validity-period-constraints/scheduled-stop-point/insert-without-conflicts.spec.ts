import * as config from '@config';
import { infrastructureLinks } from '@datasets/defaultSetup/infrastructure-links';
import { scheduledStopPoints } from '@datasets/defaultSetup/scheduled-stop-points';
import { getPropNameArray, queryTable, setupDb } from '@datasets/setup';
import {
  LinkDirection,
  ScheduledStopPoint,
  ScheduledStopPointProps,
  VehicleMode,
} from '@datasets/types';
import * as dataset from '@util/dataset';
import { asDbGeometryObject, asDbGeometryObjectArray } from '@util/dataset';
import '@util/matchers';
import { LocalDate } from 'local-date';
import * as pg from 'pg';
import * as rp from 'request-promise';

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
                  ...dataset.asGraphQlDateObject(toBeInserted),
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
      validity_start: new LocalDate('2062-01-03'),
      validity_end: new LocalDate('2063-01-02'),
      timing_place_id: null,
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
      validity_start: new LocalDate('2062-01-03'),
      validity_end: new LocalDate('2063-01-02'),
      timing_place_id: null,
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
      validity_start: new LocalDate('2064-01-03'),
      validity_end: new LocalDate('2065-01-02'),
      timing_place_id: null,
    };

    shouldReturnCorrectResponse(toBeInserted);

    shouldInsertCorrectRowIntoDatabase(toBeInserted);
  });

  describe('whose validity period does not overlap with other validity period', () => {
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
      validity_start: new LocalDate('2060-01-16'),
      validity_end: new LocalDate('2061-04-30'),
      timing_place_id: null,
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
      validity_start: new LocalDate('2065-01-05'),
      validity_end: new LocalDate('2065-01-07'),
      timing_place_id: null,
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
      validity_start: new LocalDate('2063-01-05'),
      validity_end: new LocalDate('2064-01-07'),
      timing_place_id: null,
    };

    shouldReturnCorrectResponse(toBeInserted);

    shouldInsertCorrectRowIntoDatabase(toBeInserted);
  });
});
