import * as rp from 'request-promise';
import * as pg from 'pg';
import * as config from '@config';
import * as dataset from '@util/dataset';
import { asDbGeometryObjectArray } from '@util/dataset';
import { infrastructureLinks } from '@datasets/defaultSetup/infrastructure-links';
import {
  scheduledStopPoints,
  vehicleModeOnScheduledStopPoint,
} from '@datasets/defaultSetup/scheduled-stop-points';
import {
  LinkDirection,
  ScheduledStopPoint,
  ScheduledStopPointProps,
  VehicleMode,
} from '@datasets/types';
import '@util/matchers';
import { getPropNameArray, queryTable, setupDb } from '@datasets/setup';
import { expectErrorResponse } from '@util/response';

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
  } as dataset.GeometryObject,
  label: 'inserted stop point',
  priority: 50,
  validity_end: new Date('2060-11-04 15:30:40Z'),
};

const insertedDefaultValues: Partial<ScheduledStopPoint> = {
  validity_start: null,
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
          dbConnectionPool,
          'service_pattern.scheduled_stop_point',
        );

        expect(stopPointResponse.rowCount).toEqual(scheduledStopPoints.length);
        expect(stopPointResponse.rows).toEqual(
          expect.arrayContaining(
            asDbGeometryObjectArray(scheduledStopPoints, ['measured_location']),
          ),
        );

        const vehicleModeResponse = await queryTable(
          dbConnectionPool,
          'service_pattern.vehicle_mode_on_scheduled_stop_point',
        );

        expect(vehicleModeResponse.rowCount).toEqual(
          vehicleModeOnScheduledStopPoint.length,
        );
        expect(vehicleModeResponse.rows).toEqual(
          expect.arrayContaining(vehicleModeOnScheduledStopPoint),
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

    const shouldInsertCorrectRowIntoDatabase = (vehicleMode: VehicleMode) =>
      it('should insert correct row into the database', async () => {
        await rp.post({
          ...config.hasuraRequestTemplate,
          body: { query: buildMutation(vehicleMode) },
        });

        const stopPointResponse = await queryTable(
          dbConnectionPool,
          'service_pattern.scheduled_stop_point',
        );

        expect(stopPointResponse.rowCount).toEqual(
          scheduledStopPoints.length + 1,
        );

        expect(stopPointResponse.rows).toEqual(
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

        const vehicleModeResponse = await queryTable(
          dbConnectionPool,
          'service_pattern.vehicle_mode_on_scheduled_stop_point',
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
