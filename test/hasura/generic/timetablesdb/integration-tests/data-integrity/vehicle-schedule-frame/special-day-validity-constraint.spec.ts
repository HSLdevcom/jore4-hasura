import { timetablesDbConfig } from '@config';
import {
  DbConnection,
  closeDbConnection,
  createDbConnection,
  singleQuery,
} from '@util/db';
import { setupDb } from '@util/setup';
import { defaultTimetablesDataset } from 'generic/timetablesdb/datasets/defaultSetup/default-timetables-dataset';
import { TimetablePriority } from 'generic/timetablesdb/datasets/types';
import {
  buildGenericTimetablesDataset,
  createGenericTableData,
} from 'timetables-data-inserter';

describe('Vehicle schedule frame - special day priority validity range constraint', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(timetablesDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  const builtDefaultDataset = buildGenericTimetablesDataset(
    defaultTimetablesDataset,
  );

  const testFrameId =
    builtDefaultDataset._vehicle_schedule_frames.winter2022
      .vehicle_schedule_frame_id;

  beforeEach(async () =>
    setupDb(dbConnection, createGenericTableData(builtDefaultDataset)),
  );

  const setTestFramePriorityAndValidity = (
    priority: TimetablePriority,
    validityStart: string,
    validityEnd: string,
  ) => {
    return singleQuery(
      dbConnection,
      `UPDATE vehicle_schedule.vehicle_schedule_frame
       SET "priority" = ${priority},
       "validity_start" = '${validityStart}',
       "validity_end" = '${validityEnd}'
       WHERE "vehicle_schedule_frame_id" = '${testFrameId}'
    `,
    );
  };

  it('should be able to set Special priority to have one day validity period', async () => {
    await expect(
      setTestFramePriorityAndValidity(
        TimetablePriority.Special,
        '2023-01-23',
        '2023-01-23',
      ),
    ).resolves.not.toThrow();
  });

  it('should not be able to set Special priority to have longer than one day validity period', async () => {
    await expect(
      setTestFramePriorityAndValidity(
        TimetablePriority.Special,
        '2023-01-23',
        '2023-01-24',
      ),
    ).rejects.toThrow('special_priority_validity_exactly_one_day');
  });

  const otherPrioritiesToTest: Array<keyof typeof TimetablePriority> = [
    'Standard',
    'Temporary',
    'Draft',
    'Staging',
  ];
  otherPrioritiesToTest.forEach((priorityName) => {
    it(`should also be able to set other priorities to have one day validity range: ${priorityName}`, async () => {
      await expect(
        setTestFramePriorityAndValidity(
          TimetablePriority[priorityName],
          '2023-01-23',
          '2023-01-23',
        ),
      ).resolves.not.toThrow();
    });
  });
});
