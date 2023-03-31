import * as config from '@config';
import * as dataset from '@util/dataset';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import { getPropNameArray, queryTable, setupDb } from '@util/setup';
import {
  defaultGenericNetworkDbData,
  infrastructureLinks,
  scheduledStopPointInvariants,
  scheduledStopPoints,
} from 'generic/networkdb/datasets/defaultSetup';
import { genericNetworkDbSchema } from 'generic/networkdb/datasets/schema';
import {
  LinkDirection,
  ScheduledStopPoint,
  scheduledStopPointProps,
  VehicleMode,
} from 'generic/networkdb/datasets/types';
import { GeometryObject } from 'geojson';
import { DateTime } from 'luxon';
import * as rp from 'request-promise';

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
  } as GeometryObject,
  label: 'inserted stop point',
  priority: 50,
  validity_end: DateTime.fromISO('2060-11-03'),
  timing_place_id: null,
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
        ${getPropNameArray(scheduledStopPointProps).join(',')}
      }
    }
  }
`;

describe('Insert scheduled_stop_point', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(config.networkDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  beforeEach(() => setupDb(dbConnection, defaultGenericNetworkDbData));

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
                ...dataset.asGraphQlDateObject(toBeInserted),
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
      dbConnection,
      genericNetworkDbSchema['service_pattern.scheduled_stop_point'],
    );

    expect(response.rowCount).toEqual(scheduledStopPoints.length + 1);

    expect(response.rows).toEqual(
      expect.arrayContaining(
        dataset.serializeMatcherInputs([
          {
            ...toBeInserted,
            ...insertedDefaultValues,
            scheduled_stop_point_id: expect.any(String),
          },
          ...scheduledStopPoints,
        ]),
      ),
    );

    const stopPointInvariantResponse = await queryTable(
      dbConnection,
      genericNetworkDbSchema['service_pattern.scheduled_stop_point_invariant'],
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
