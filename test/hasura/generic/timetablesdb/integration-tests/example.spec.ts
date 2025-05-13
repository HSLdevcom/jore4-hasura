/* eslint-disable camelcase */
import { hasuraRequestTemplate, timetablesDbConfig } from '@config';
import { asGraphQlDateObject, toGraphQlObject } from '@util/dataset';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import { post } from '@util/fetch-request';
import { buildPropNameArray, queryTable, setupDb } from '@util/setup';
import { DateTime } from 'luxon';
import {
  defaultGenericTimetablesDbData,
  vehicleScheduleFrames,
} from '../datasets/defaultSetup';
import { buildVehicleScheduleFrame } from '../datasets/factories';
import { genericTimetablesDbSchema } from '../datasets/schema';
import { VehicleScheduleFrame } from '../datasets/types';

const toBeInserted: Partial<VehicleScheduleFrame> = {
  ...buildVehicleScheduleFrame({
    vehicle_schedule_frame_id: '7e587ab7-a610-4d05-840d-8b5292b80322',
    label: 'Label 1',
    name: 'Frame 1',
    validity_start: DateTime.fromISO('2022-12-01'),
    validity_end: DateTime.fromISO('2023-02-28'),
  }),
};

const buildMutation = (scheduleFrame: Partial<VehicleScheduleFrame>) => `
  mutation {
    timetables {
      timetables_insert_vehicle_schedule_vehicle_schedule_frame(objects: ${toGraphQlObject(
        scheduleFrame,
      )}) {
        returning {
          ${buildPropNameArray(
            genericTimetablesDbSchema[
              'vehicle_schedule.vehicle_schedule_frame'
            ],
          )}
        }
      }
    }
  }
`;

describe('Insert vehicle schedule frame', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(timetablesDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  beforeEach(() => setupDb(dbConnection, defaultGenericTimetablesDbData));

  it('should return correct response', async () => {
    const response = await post({
      ...hasuraRequestTemplate,
      body: { query: buildMutation(toBeInserted) },
    });

    const { created_at } =
      response.data.timetables
        .timetables_insert_vehicle_schedule_vehicle_schedule_frame.returning[0];

    const createdAt = DateTime.fromISO(created_at);
    expect(createdAt.isValid).toBe(true);
    expect(createdAt.diffNow().as('milliseconds')).toBeLessThan(0);
    expect(createdAt.diffNow().as('milliseconds')).toBeGreaterThan(-5000);

    expect(response).toEqual(
      expect.objectContaining({
        data: {
          timetables: {
            timetables_insert_vehicle_schedule_vehicle_schedule_frame: {
              returning: [
                {
                  ...asGraphQlDateObject({
                    created_at,
                    ...toBeInserted,
                  }),
                },
              ],
            },
          },
        },
      }),
    );
  });

  it('should insert correct row into the database', async () => {
    await post({
      ...hasuraRequestTemplate,
      body: { query: buildMutation(toBeInserted) },
    });

    const response = await queryTable(
      dbConnection,
      genericTimetablesDbSchema['vehicle_schedule.vehicle_schedule_frame'],
    );

    const { created_at } = response.rows[response.rows.length - 1];

    expect(response.rowCount).toEqual(vehicleScheduleFrames.length + 1);
    expect(response.rows).toEqual(
      expect.arrayContaining([
        ...vehicleScheduleFrames,
        {
          created_at,
          ...toBeInserted,
        },
      ]),
    );
  });
});
