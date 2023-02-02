import { hasuraRequestTemplate, timetablesDbConfig } from '@config';
import { asGraphQlDateObject, toGraphQlObject } from '@util/dataset';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import '@util/matchers';
import { buildPropNameArray, queryTable, setupDb } from '@util/setup';
import { post } from 'request-promise';
import { defaultGenericTimetablesDbData } from '../datasets/defaultSetup';
import { vehicleScheduleFrames } from '../datasets/defaultSetup/vehicle-schedules-frames';
import { buildVehicleScheduleFrame } from '../datasets/factories';
import { genericTimetablesDbSchema } from '../datasets/schema';
import { VehicleScheduleFrame } from '../datasets/types';

const toBeInserted: Partial<VehicleScheduleFrame> = {
  ...buildVehicleScheduleFrame({
    vehicle_schedule_frame_id: '7e587ab7-a610-4d05-840d-8b5292b80322',
    name: 'Frame 1',
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

    expect(response).toEqual(
      expect.objectContaining({
        data: {
          timetables: {
            timetables_insert_vehicle_schedule_vehicle_schedule_frame: {
              returning: [
                {
                  ...asGraphQlDateObject(toBeInserted),
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

    expect(response.rowCount).toEqual(vehicleScheduleFrames.length + 1);
    expect(response.rows).toEqual(
      expect.arrayContaining([
        {
          ...toBeInserted,
        },
        ...vehicleScheduleFrames,
      ]),
    );
  });
});
