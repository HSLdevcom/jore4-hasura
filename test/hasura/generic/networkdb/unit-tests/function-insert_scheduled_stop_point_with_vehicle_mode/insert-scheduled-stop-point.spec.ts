import * as config from '@config';
import {
  asEwkb,
  serializeMatcherInput,
  serializeMatcherInputs,
} from '@util/dataset';
import * as db from '@util/db';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import { queryTable, setupDb } from '@util/setup';
import {
  defaultGenericNetworkDbData,
  infrastructureLinks,
  scheduledStopPointInvariants,
  scheduledStopPoints,
  vehicleModeOnScheduledStopPoint,
} from 'generic/networkdb/datasets/defaultSetup';
import { genericNetworkDbSchema } from 'generic/networkdb/datasets/schema';
import {
  LinkDirection,
  ScheduledStopPoint,
  VehicleMode,
} from 'generic/networkdb/datasets/types';
import { GeometryObject } from 'geojson';
import { DateTime } from 'luxon';

const toBeInserted: ScheduledStopPoint = {
  scheduled_stop_point_id: '81860cb8-6947-4ecb-abbd-0720ada98b40',
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
  validity_start: DateTime.fromISO('2036-11-03'),
  validity_end: DateTime.fromISO('2060-11-03'),
  timing_place_id: '7b6663b6-0feb-466b-89ed-200e889de472',
};

const defaultVehicleMode: VehicleMode = VehicleMode.Bus;

describe('Function insert_scheduled_stop_point_with_vehicle_mode', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(config.networkDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  beforeEach(() => setupDb(dbConnection, defaultGenericNetworkDbData));

  const insertScheduledStopPointWithVehicleMode = async (
    scheduledStopPoint: ScheduledStopPoint,
    vehicleMode: VehicleMode,
    includeTimingPlaceId = true,
  ) => {
    const params = [
      `'${scheduledStopPoint.scheduled_stop_point_id}'::uuid`,
      `'${asEwkb(
        scheduledStopPoint.measured_location,
      )}'::geography(PointZ, 4326)`,
      `'${scheduledStopPoint.located_on_infrastructure_link_id}'::uuid`,
      `'${scheduledStopPoint.direction}'::text`,
      `'${scheduledStopPoint.label}'::text`,
      `'${scheduledStopPoint.validity_start?.toISODate()}'::date`,
      `'${scheduledStopPoint.validity_end?.toISODate()}'::date`,
      `${scheduledStopPoint.priority}::int`,
      `'${vehicleMode}'::text`,
    ];

    if (includeTimingPlaceId) {
      params.push(`'${scheduledStopPoint.timing_place_id}'::uuid`);
    }

    return db.singleQuery(
      dbConnection,
      `SELECT internal_service_pattern.insert_scheduled_stop_point_with_vehicle_mode(${params})`,
    );
  };

  it('should insert scheduled_stop_point row', async () => {
    await insertScheduledStopPointWithVehicleMode(
      toBeInserted,
      defaultVehicleMode,
    );

    const response = await queryTable(
      dbConnection,
      genericNetworkDbSchema['service_pattern.scheduled_stop_point'],
    );

    expect(response.rowCount).toEqual(scheduledStopPoints.length + 1);

    expect(response.rows).toEqual(
      expect.arrayContaining([
        ...serializeMatcherInputs(scheduledStopPoints),
        serializeMatcherInput(toBeInserted),
      ]),
    );
  });

  it('should insert vehicle_mode_on_scheduled_stop_point row', async () => {
    await insertScheduledStopPointWithVehicleMode(
      toBeInserted,
      defaultVehicleMode,
    );

    const response = await queryTable(
      dbConnection,
      genericNetworkDbSchema[
        'service_pattern.vehicle_mode_on_scheduled_stop_point'
      ],
    );

    expect(response.rowCount).toEqual(
      vehicleModeOnScheduledStopPoint.length + 1,
    );

    expect(response.rows).toEqual(
      expect.arrayContaining([
        ...vehicleModeOnScheduledStopPoint,
        {
          scheduled_stop_point_id: toBeInserted.scheduled_stop_point_id,
          vehicle_mode: defaultVehicleMode,
        },
      ]),
    );
  });

  it('should insert scheduled_stop_point row without timing_place_id parameter', async () => {
    const toBeInsertedWithoutTimingPlaceId = {
      ...toBeInserted,
      timing_place_id: null,
    };

    await insertScheduledStopPointWithVehicleMode(
      toBeInsertedWithoutTimingPlaceId,
      defaultVehicleMode,
      false,
    );

    const response = await queryTable(
      dbConnection,
      genericNetworkDbSchema['service_pattern.scheduled_stop_point'],
    );

    expect(response.rowCount).toEqual(scheduledStopPoints.length + 1);

    expect(response.rows).toEqual(
      expect.arrayContaining([
        ...serializeMatcherInputs(scheduledStopPoints),
        serializeMatcherInput(toBeInsertedWithoutTimingPlaceId),
      ]),
    );
  });

  it('should insert scheduled_stop_point_invariant row if invariant did not exist yet', async () => {
    const toBeInsertedWithNonExistingLabel = {
      ...toBeInserted,
      label: 'ThisLabelDoesNotExistYet',
    };

    await insertScheduledStopPointWithVehicleMode(
      toBeInsertedWithNonExistingLabel,
      defaultVehicleMode,
    );

    const response = await queryTable(
      dbConnection,
      genericNetworkDbSchema['service_pattern.scheduled_stop_point_invariant'],
    );

    expect(response.rowCount).toEqual(scheduledStopPointInvariants.length + 1);

    expect(response.rows).toEqual(
      expect.arrayContaining([
        ...scheduledStopPointInvariants,
        { label: toBeInsertedWithNonExistingLabel.label },
      ]),
    );
  });

  it('should not insert scheduled_stop_point_invariant row if invariant did already exist', async () => {
    const toBeInsertedWithExistingLabel = {
      ...toBeInserted,
      label: scheduledStopPoints[0].label,
    };

    await insertScheduledStopPointWithVehicleMode(
      toBeInsertedWithExistingLabel,
      defaultVehicleMode,
    );

    const response = await queryTable(
      dbConnection,
      genericNetworkDbSchema['service_pattern.scheduled_stop_point_invariant'],
    );

    expect(response.rowCount).toEqual(scheduledStopPointInvariants.length);

    expect(response.rows).toEqual(
      expect.arrayContaining(scheduledStopPointInvariants),
    );
  });
});
