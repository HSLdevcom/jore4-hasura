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

describe('Vehicle schedule frame - special day priority validity period constraint', () => {
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

  const setOneDayValidityPeriod = (
    priorityName: keyof typeof TimetablePriority,
  ) => {
    return setTestFramePriorityAndValidity(
      TimetablePriority[priorityName],
      '2023-01-23',
      '2023-01-23',
    );
  };

  const setLongerValidityPeriod = (
    priorityName: keyof typeof TimetablePriority,
  ) => {
    return setTestFramePriorityAndValidity(
      TimetablePriority[priorityName],
      '2023-01-23',
      '2023-01-24',
    );
  };

  describe('Special priority', () => {
    it('should be able to set Special priority to have one day validity period', async () => {
      await expect(setOneDayValidityPeriod('Special')).resolves.not.toThrow();
    });

    it('should NOT be able to set Special priority to have longer than one day validity period', async () => {
      await expect(setLongerValidityPeriod('Special')).rejects.toThrow(
        'one_day_validity_priorities',
      );
    });
  });

  describe('other restricted priorities', () => {
    const otherPrioritiesToTest: Array<keyof typeof TimetablePriority> = [
      'Standard',
      'Temporary',
      'Draft',
    ];
    otherPrioritiesToTest.forEach((priorityName) => {
      it(`should NOT be able to set ${priorityName} priority to have one day validity period`, async () => {
        await expect(setOneDayValidityPeriod(priorityName)).rejects.toThrow(
          'one_day_validity_priorities',
        );
      });

      it(`should be able to set ${priorityName} priority to have longer than one day validity period`, async () => {
        await expect(
          setLongerValidityPeriod(priorityName),
        ).resolves.not.toThrow();
      });
    });
  });

  describe('ignored priorities', () => {
    const otherPrioritiesToTest: Array<keyof typeof TimetablePriority> = [
      'Staging',
    ];
    otherPrioritiesToTest.forEach((priorityName) => {
      it(`should be able to set ${priorityName} priority to have one day validity period`, async () => {
        await expect(
          setOneDayValidityPeriod(priorityName),
        ).resolves.not.toThrow();
      });

      it(`should be able to set ${priorityName} priority to have longer than one day validity period`, async () => {
        await expect(
          setLongerValidityPeriod(priorityName),
        ).resolves.not.toThrow();
      });
    });
  });
});
