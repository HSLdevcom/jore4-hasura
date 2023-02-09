import * as config from '@config';
import * as dataset from '@util/dataset';
import { serializeMatcherInputs } from '@util/dataset';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import { expectErrorResponse } from '@util/response';
import { getPropNameArray, queryTable, setupDb } from '@util/setup';
import { defaultGenericNetworkDbData } from 'generic/networkdb/datasets/defaultSetup';
import { infrastructureLinks } from 'generic/networkdb/datasets/defaultSetup/infrastructure-links';
import {
  scheduledStopPointInvariants,
  scheduledStopPoints,
  vehicleModeOnScheduledStopPoint,
} from 'generic/networkdb/datasets/defaultSetup/scheduled-stop-points';
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
    infrastructureLinks[0].infrastructure_link_id,
  direction: LinkDirection.Forward,
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
  timing_place_id: null,
};

const buildMutation = (vehicleMode?: VehicleMode) => `
  mutation {
    insert_service_pattern_scheduled_stop_point(objects: ${dataset.toGraphQlObject(
      {
        ...toBeInserted,
        ...(vehicleMode && {
          vehicle_mode_on_scheduled_stop_point: {
            data: {
              vehicle_mode: vehicleMode,
            },
          },
        }),
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

  describe("whose vehicle mode conflicts with its infrastructure link's vehicle sub mode", () => {
    const shouldReturnErrorResponse = (vehicleMode?: VehicleMode) =>
      it('should return error response', async () => {
        await rp
          .post({
            ...config.hasuraRequestTemplate,
            body: { query: buildMutation(vehicleMode) },
          })
          .then(
            expectErrorResponse(
              'scheduled stop point vehicle mode must be compatible with allowed infrastructure link vehicle submodes',
            ),
          );
      });

    const shouldNotModifyDatabase = (vehicleMode?: VehicleMode) =>
      it('should not modify the database', async () => {
        await rp.post({
          ...config.hasuraRequestTemplate,
          body: { query: buildMutation(vehicleMode) },
        });

        const stopPointResponse = await queryTable(
          dbConnection,
          genericNetworkDbSchema['service_pattern.scheduled_stop_point'],
        );

        expect(stopPointResponse.rowCount).toEqual(scheduledStopPoints.length);
        expect(stopPointResponse.rows).toEqual(
          expect.arrayContaining(serializeMatcherInputs(scheduledStopPoints)),
        );

        const vehicleModeResponse = await queryTable(
          dbConnection,
          genericNetworkDbSchema[
            'service_pattern.vehicle_mode_on_scheduled_stop_point'
          ],
        );

        expect(vehicleModeResponse.rowCount).toEqual(
          vehicleModeOnScheduledStopPoint.length,
        );
        expect(vehicleModeResponse.rows).toEqual(
          expect.arrayContaining(vehicleModeOnScheduledStopPoint),
        );

        const stopPointInvariantResponse = await queryTable(
          dbConnection,
          genericNetworkDbSchema[
            'service_pattern.scheduled_stop_point_invariant'
          ],
        );

        expect(stopPointInvariantResponse.rowCount).toEqual(
          scheduledStopPointInvariants.length,
        );
        expect(stopPointInvariantResponse.rows).toEqual(
          expect.arrayContaining(scheduledStopPointInvariants),
        );
      });

    describe('infrastructure link sub modes "generic_bus", "generic_tram", stop point mode "metro"', () => {
      shouldReturnErrorResponse(VehicleMode.Metro);

      shouldNotModifyDatabase(VehicleMode.Metro);
    });

    describe('infrastructure link sub modes "generic_bus", "generic_tram", stop point mode "ferry"', () => {
      shouldReturnErrorResponse(VehicleMode.Ferry);

      shouldNotModifyDatabase(VehicleMode.Ferry);
    });

    describe('infrastructure link sub modes "generic_bus", "generic_tram", stop point has no mode', () => {
      shouldReturnErrorResponse();

      shouldNotModifyDatabase();
    });
  });

  describe("whose mode does NOT conflict with its infrastructure link's sub modes", () => {
    const shouldReturnCorrectResponse = (vehicleMode: VehicleMode) =>
      it('should return correct response', async () => {
        const response = await rp.post({
          ...config.hasuraRequestTemplate,
          body: { query: buildMutation(vehicleMode) },
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

    const shouldInsertCorrectRowIntoDatabase = (vehicleMode: VehicleMode) =>
      it('should insert correct row into the database', async () => {
        await rp.post({
          ...config.hasuraRequestTemplate,
          body: { query: buildMutation(vehicleMode) },
        });

        const stopPointResponse = await queryTable(
          dbConnection,
          genericNetworkDbSchema['service_pattern.scheduled_stop_point'],
        );

        expect(stopPointResponse.rowCount).toEqual(
          scheduledStopPoints.length + 1,
        );

        expect(stopPointResponse.rows).toEqual(
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

        const vehicleModeResponse = await queryTable(
          dbConnection,
          genericNetworkDbSchema[
            'service_pattern.vehicle_mode_on_scheduled_stop_point'
          ],
        );

        expect(vehicleModeResponse.rowCount).toEqual(
          vehicleModeOnScheduledStopPoint.length + 1,
        );

        expect(vehicleModeResponse.rows).toEqual(
          expect.arrayContaining([
            {
              scheduled_stop_point_id: expect.any(String),
              vehicle_mode: vehicleMode,
            },
            ...vehicleModeOnScheduledStopPoint,
          ]),
        );

        const stopPointInvariantResponse = await queryTable(
          dbConnection,
          genericNetworkDbSchema[
            'service_pattern.scheduled_stop_point_invariant'
          ],
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

    describe('infrastructure link sub modes "generic_bus", "generic_tram", stop point mode "bus"', () => {
      shouldReturnCorrectResponse(VehicleMode.Bus);

      shouldInsertCorrectRowIntoDatabase(VehicleMode.Bus);
    });

    describe('infrastructure link sub modes "generic_bus", "generic_tram", stop point mode "tram"', () => {
      shouldReturnCorrectResponse(VehicleMode.Tram);

      shouldInsertCorrectRowIntoDatabase(VehicleMode.Tram);
    });
  });
});
