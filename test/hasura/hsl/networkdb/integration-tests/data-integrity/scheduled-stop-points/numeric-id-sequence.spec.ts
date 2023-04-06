import * as config from '@config';
import {
  closeDbConnection,
  createDbConnection,
  DbConnection,
  singleQuery,
} from '@util/db';
import { mergeLists } from '@util/schema';
import { queryTable, setupDb } from '@util/setup';
import {
  defaultHslNetworkDbData,
  hslScheduledStopPoints,
} from 'hsl/networkdb/datasets/defaultSetup';
import { hslNetworkDbSchema } from 'hsl/networkdb/datasets/schema';
import { HslScheduledStopPoint } from 'hsl/networkdb/datasets/types';
import { cloneDeep } from 'lodash';

describe('service_pattern.scheduled_stop_point.numeric_id sequence', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(config.networkDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  beforeEach(() =>
    singleQuery(
      dbConnection,
      // Eases testing when the numeric ids reliably start from the beginning on each test.
      'TRUNCATE TABLE service_pattern.scheduled_stop_point RESTART IDENTITY CASCADE',
    ),
  );

  it('should create correct numeric ids for new entries', async () => {
    const scheduledStopPoints = cloneDeep(hslScheduledStopPoints);
    scheduledStopPoints.forEach((ssp) => {
      expect(ssp.numeric_id).toBeFalsy();
    });

    await setupDb(dbConnection, defaultHslNetworkDbData);

    const response = await queryTable(
      dbConnection,
      hslNetworkDbSchema['service_pattern.scheduled_stop_point'],
    );

    const numericIds = response.rows
      .map((ssp: HslScheduledStopPoint) => ssp.numeric_id)
      .slice(0, 3)
      .sort();

    expect(numericIds).toEqual([7000001, 7000002, 7000003]);
  });

  it('should be able to explicitly insert values before sequence range, and not have them interfere with sequence', async () => {
    const scheduledStopPoints = cloneDeep(hslScheduledStopPoints);
    scheduledStopPoints[1].numeric_id = 1234567;
    scheduledStopPoints[3].numeric_id = 2345678;

    const testData = mergeLists(
      defaultHslNetworkDbData,
      [
        {
          name: 'service_pattern.scheduled_stop_point',
          data: scheduledStopPoints,
        },
      ],
      (tableSchema) => tableSchema.name,
    );
    await setupDb(dbConnection, testData);

    const response = await queryTable(
      dbConnection,
      hslNetworkDbSchema['service_pattern.scheduled_stop_point'],
    );

    const numericIds = response.rows
      .map((ssp: HslScheduledStopPoint) => ssp.numeric_id)
      .slice(0, 5);

    expect(numericIds).toEqual([
      7000001,
      scheduledStopPoints[1].numeric_id,
      7000002,
      scheduledStopPoints[3].numeric_id,
      7000003,
    ]);
  });

  it('should be able to explicitly insert values after sequence range, and not have them interfere with sequence', async () => {
    const scheduledStopPoints = cloneDeep(hslScheduledStopPoints);
    scheduledStopPoints[1].numeric_id = 9876543;
    scheduledStopPoints[3].numeric_id = 9123456;

    const testData = mergeLists(
      defaultHslNetworkDbData,
      [
        {
          name: 'service_pattern.scheduled_stop_point',
          data: scheduledStopPoints,
        },
      ],
      (tableSchema) => tableSchema.name,
    );
    await setupDb(dbConnection, testData);

    const response = await queryTable(
      dbConnection,
      hslNetworkDbSchema['service_pattern.scheduled_stop_point'],
    );

    const numericIds = response.rows
      .map((ssp: HslScheduledStopPoint) => ssp.numeric_id)
      .slice(0, 5);

    expect(numericIds).toEqual([
      7000001,
      scheduledStopPoints[1].numeric_id,
      7000002,
      scheduledStopPoints[3].numeric_id,
      7000003,
    ]);
  });
});
