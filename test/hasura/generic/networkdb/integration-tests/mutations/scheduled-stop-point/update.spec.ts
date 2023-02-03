import * as config from '@config';
import * as dataset from '@util/dataset';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import '@util/matchers';
import { getPropNameArray, queryTable, setupDb } from '@util/setup';
import { defaultGenericNetworkDbData } from 'generic/networkdb/datasets/defaultSetup';
import { infrastructureLinks } from 'generic/networkdb/datasets/defaultSetup/infrastructure-links';
import { scheduledStopPoints } from 'generic/networkdb/datasets/defaultSetup/scheduled-stop-points';
import { genericNetworkDbSchema } from 'generic/networkdb/datasets/schema';
import {
  ScheduledStopPoint,
  scheduledStopPointProps,
} from 'generic/networkdb/datasets/types';
import { GeometryObject } from 'geojson';
import { LocalDate } from 'local-date';
import * as rp from 'request-promise';

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
  } as GeometryObject,
  priority: 30,
  validity_start: new LocalDate('2077-10-22'),
  validity_end: new LocalDate('2079-10-21'),
  timing_place_id: null,
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
        ${getPropNameArray(scheduledStopPointProps).join(',')}
      }
    }
  }
`;

describe('Update scheduled_stop_point', () => {
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
      dbConnection,
      genericNetworkDbSchema['service_pattern.scheduled_stop_point'],
    );

    expect(response.rowCount).toEqual(scheduledStopPoints.length);

    expect(response.rows).toEqual(
      expect.arrayContaining(
        dataset.serializeMatcherInputs([
          completeUpdated,
          ...scheduledStopPoints.filter(
            (scheduledStopPoint) =>
              scheduledStopPoint.scheduled_stop_point_id !==
              completeUpdated.scheduled_stop_point_id,
          ),
        ]),
      ),
    );
  });
});
