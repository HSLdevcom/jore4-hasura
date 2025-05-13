import * as config from '@config';
import * as dataset from '@util/dataset';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import { post } from '@util/fetch-request';
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

const toBeInserted: Partial<ScheduledStopPoint> = {
  scheduled_stop_point_id: 'd1e8878f-da19-474a-b156-13ac41175789',
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
  timing_place_id: '7b6663b6-0feb-466b-89ed-200e889de472',
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
    const response = await post({
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
              },
            ],
          },
        },
      }),
    );
  });

  it('should insert correct row into the database', async () => {
    await post({
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
