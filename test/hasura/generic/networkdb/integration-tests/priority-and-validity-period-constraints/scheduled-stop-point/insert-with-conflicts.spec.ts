import * as config from '@config';
import * as dataset from '@util/dataset';
import { serializeMatcherInputs } from '@util/dataset';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import { post } from '@util/fetch-request';
import { expectErrorResponse } from '@util/response';
import { getPropNameArray, queryTable, setupDb } from '@util/setup';
import {
  defaultGenericNetworkDbData,
  infrastructureLinks,
  scheduledStopPoints,
} from 'generic/networkdb/datasets/defaultSetup';
import { genericNetworkDbSchema } from 'generic/networkdb/datasets/schema';
import {
  LinkDirection,
  ScheduledStopPoint,
  scheduledStopPointProps,
  VehicleMode,
} from 'generic/networkdb/datasets/types';
import { DateTime } from 'luxon';

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
        ${getPropNameArray(scheduledStopPointProps).join(',')}
      }
    }
  }
`;

describe('Insert scheduled stop point', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(config.networkDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  beforeEach(() => setupDb(dbConnection, defaultGenericNetworkDbData));

  const shouldReturnErrorResponse = (
    toBeInserted: Partial<ScheduledStopPoint>,
  ) =>
    it('should return error response', async () => {
      await post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeInserted) },
      }).then(expectErrorResponse());
    });

  const shouldNotModifyDatabase = (toBeInserted: Partial<ScheduledStopPoint>) =>
    it('should not modify the database', async () => {
      await post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeInserted) },
      });

      const response = await queryTable(
        dbConnection,
        genericNetworkDbSchema['service_pattern.scheduled_stop_point'],
      );

      expect(response.rowCount).toEqual(scheduledStopPoints.length);
      expect(response.rows).toEqual(
        expect.arrayContaining(serializeMatcherInputs(scheduledStopPoints)),
      );
    });

  describe('whose validity period conflicts with open validity start', () => {
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
      priority: 20,
      validity_start: DateTime.fromISO('2062-01-03'),
      validity_end: DateTime.fromISO('2063-01-02'),
      timing_place_id: null,
    };

    shouldReturnErrorResponse(toBeInserted);

    shouldNotModifyDatabase(toBeInserted);
  });

  describe('whose validity period overlaps partially with existing validity period', () => {
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
      validity_start: DateTime.fromISO('2065-01-16'),
      validity_end: DateTime.fromISO('2065-04-30'),
      timing_place_id: null,
    };

    shouldReturnErrorResponse(toBeInserted);

    shouldNotModifyDatabase(toBeInserted);
  });

  describe('whose validity period is entirely contained in other validity period', () => {
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
      validity_start: DateTime.fromISO('2065-01-05'),
      validity_end: DateTime.fromISO('2065-01-07'),
      timing_place_id: null,
    };

    shouldReturnErrorResponse(toBeInserted);

    shouldNotModifyDatabase(toBeInserted);
  });
});
