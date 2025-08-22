import differenceBy from 'lodash/differenceBy';
import xor from 'lodash/xor';
import * as config from '@config';
import { timetablesDbConfig } from '@config';
import * as db from '@util/db';
import { DbConnection, closeDbConnection, createDbConnection } from '@util/db';
import { post } from '@util/fetch-request';
import { setupDb } from '@util/setup';
import { defaultTimetablesDataset } from 'hsl/timetablesdb/datasets/defaultSetup/default-timetables-dataset';
import {
  HslTimetablesDbTables,
  hslTimetablesDbTables,
} from 'hsl/timetablesdb/datasets/schema';
import {
  buildHslTimetablesDataset,
  createHslTableData,
} from 'timetables-data-inserter';

const buildDeleteMutation = (toBeDeletedId: UUID) => `
  mutation {
    timetables {
      timetables_delete_vehicle_schedule_vehicle_schedule_frame(
        where: {
          vehicle_schedule_frame_id: {_eq: "${toBeDeletedId}"}
        },
      ) {
        returning {
          vehicle_schedule_frame_id
        }
      }
    }
  }
`;

describe('Delete vehicle schedule frame', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(timetablesDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  const builtDefaultDataset = buildHslTimetablesDataset(
    defaultTimetablesDataset,
  );
  const frameToDelete = builtDefaultDataset._vehicle_schedule_frames.winter2022;
  const executeDeleteMutation = () => {
    return post({
      ...config.hasuraRequestTemplate,
      body: {
        query: buildDeleteMutation(frameToDelete.vehicle_schedule_frame_id),
      },
    });
  };

  const selectAllFromTable = (
    tableName: HslTimetablesDbTables,
    primaryKey: string,
  ) => {
    return db.singleQuery(
      dbConnection,
      `SELECT * FROM ${tableName} ORDER BY ${primaryKey}`,
    );
  };

  // A helper object for using selectAllFromTable
  type TableAndSortColumn = [HslTimetablesDbTables, string];
  const tablesWithSortColumn: Record<string, TableAndSortColumn> = {
    vehicleScheduleFrame: [
      'vehicle_schedule.vehicle_schedule_frame',
      'vehicle_schedule_frame_id',
    ],
    vehicleService: ['vehicle_service.vehicle_service', 'vehicle_service_id'],
    block: ['vehicle_service.block', 'block_id'],
    vehicleJourney: ['vehicle_journey.vehicle_journey', 'vehicle_journey_id'],
    timetabledPassingTime: [
      'passing_times.timetabled_passing_time',
      'timetabled_passing_time_id',
    ],
    journeyPatternRef: [
      'journey_pattern.journey_pattern_ref',
      'journey_pattern_ref_id',
    ],
    scheduledStopPointInJourneyPatternRef: [
      'service_pattern.scheduled_stop_point_in_journey_pattern_ref',
      'scheduled_stop_point_in_journey_pattern_ref_id',
    ],
    substituteOperatingDayByLineType: [
      'service_calendar.substitute_operating_day_by_line_type',
      'substitute_operating_day_by_line_type_id',
    ],
    substituteOperatingPeriod: [
      'service_calendar.substitute_operating_period',
      'substitute_operating_period_id',
    ],
  };

  beforeEach(async () =>
    setupDb(dbConnection, createHslTableData(builtDefaultDataset)),
  );

  it('should return correct response', async () => {
    const response = await executeDeleteMutation();

    expect(response).toEqual(
      expect.objectContaining({
        data: {
          timetables: {
            timetables_delete_vehicle_schedule_vehicle_schedule_frame: {
              returning: [
                {
                  vehicle_schedule_frame_id:
                    frameToDelete.vehicle_schedule_frame_id,
                },
              ],
            },
          },
        },
      }),
    );
  });

  it('should delete correct vehicle schedule frame row from the database', async () => {
    const vehicleScheduleFramesBefore = await selectAllFromTable(
      ...tablesWithSortColumn.vehicleScheduleFrame,
    );

    await executeDeleteMutation();

    const vehicleScheduleFramesAfter = await selectAllFromTable(
      ...tablesWithSortColumn.vehicleScheduleFrame,
    );

    expect(vehicleScheduleFramesAfter.rowCount).toEqual(
      vehicleScheduleFramesBefore.rowCount - 1,
    );
    const expectedFrameRowsAfter = vehicleScheduleFramesBefore.rows.filter(
      (vsf: { vehicle_schedule_frame_id: string }) =>
        vsf.vehicle_schedule_frame_id !==
        frameToDelete.vehicle_schedule_frame_id,
    );
    expect(vehicleScheduleFramesAfter.rows).toEqual(expectedFrameRowsAfter);
  });

  describe('child tables', () => {
    // Find the expected children from dataset.
    const expectedDeletedServices = Object.values(
      frameToDelete._vehicle_services,
    );
    const expectedDeletedBlocks = expectedDeletedServices
      ?.map((s) => Object.values(s._blocks))
      .flat();
    const expectedDeletedJourneys = expectedDeletedBlocks
      .map((b) => Object.values(b._vehicle_journeys))
      .flat();
    const expectedDeletedPassingTimes = expectedDeletedJourneys
      .map((j) => Object.values(j._passing_times))
      .flat();

    const assertCorrectRowsDeleted = (
      before: Awaited<ReturnType<typeof selectAllFromTable>>,
      after: Awaited<ReturnType<typeof selectAllFromTable>>,
      expectedDeleted: Array<unknown>,
      idColumn: string,
    ) => {
      // Assert just length first: the resulting error is far easier to read than when asserting whole table.
      expect(after.rowCount).toBe(before.rowCount - expectedDeleted.length);

      // Previous expect should be enough if delete does not work, but check everything just in case...
      expect(after.rows).toEqual(
        differenceBy(before.rows, expectedDeleted, idColumn),
      );
    };

    it('should cascade delete related vehicle services', async () => {
      expect(expectedDeletedServices).toHaveLength(3);

      const vehicleServicesBefore = await selectAllFromTable(
        ...tablesWithSortColumn.vehicleService,
      );

      await executeDeleteMutation();

      const vehicleServicesAfter = await selectAllFromTable(
        ...tablesWithSortColumn.vehicleService,
      );

      assertCorrectRowsDeleted(
        vehicleServicesBefore,
        vehicleServicesAfter,
        expectedDeletedServices,
        tablesWithSortColumn.vehicleService[1],
      );
    });

    it('should cascade delete related blocks', async () => {
      expect(expectedDeletedBlocks).toHaveLength(3);

      const blocksBefore = await selectAllFromTable(
        ...tablesWithSortColumn.block,
      );

      await executeDeleteMutation();

      const blocksAfter = await selectAllFromTable(
        ...tablesWithSortColumn.block,
      );

      assertCorrectRowsDeleted(
        blocksBefore,
        blocksAfter,
        expectedDeletedBlocks,
        tablesWithSortColumn.block[1],
      );
    });

    it('should cascade delete related vehicle journeys', async () => {
      expect(expectedDeletedJourneys).toHaveLength(10);

      const vehicleJourneysBefore = await selectAllFromTable(
        ...tablesWithSortColumn.vehicleJourney,
      );

      await executeDeleteMutation();

      const vehicleJourneysAfter = await selectAllFromTable(
        ...tablesWithSortColumn.vehicleJourney,
      );

      assertCorrectRowsDeleted(
        vehicleJourneysBefore,
        vehicleJourneysAfter,
        expectedDeletedJourneys,
        tablesWithSortColumn.vehicleJourney[1],
      );
    });

    it('should cascade delete related timetabled passing times', async () => {
      expect(expectedDeletedPassingTimes).toHaveLength(24);

      const timetabledPassingTimesBefore = await selectAllFromTable(
        ...tablesWithSortColumn.timetabledPassingTime,
      );

      await executeDeleteMutation();

      const timetabledPassingTimesAfter = await selectAllFromTable(
        ...tablesWithSortColumn.timetabledPassingTime,
      );

      assertCorrectRowsDeleted(
        timetabledPassingTimesBefore,
        timetabledPassingTimesAfter,
        expectedDeletedPassingTimes,
        tablesWithSortColumn.timetabledPassingTime[1],
      );
    });
  });

  it('should not delete from tables that are not direct children of vehicle schedule frame', async () => {
    // Firstly: check that we actually have assertions for all such tables,
    // to ensure this test is kept up to date when new tables are added.
    const affectedTables: Array<HslTimetablesDbTables> = [
      // These are checked in previous test.
      'vehicle_schedule.vehicle_schedule_frame',
      'vehicle_service.vehicle_service',
      'vehicle_service.block',
      'vehicle_journey.vehicle_journey',
      'passing_times.timetabled_passing_time',
      // This is an automatically generated table, not relevant.
      'vehicle_service.journey_patterns_in_vehicle_service',
    ];
    const nonAffectedTables = xor(hslTimetablesDbTables, affectedTables);
    expect(nonAffectedTables).toHaveLength(
      hslTimetablesDbTables.length - affectedTables.length,
    );

    const fetchNonAffectedTablesData = async () => {
      const getTableRows = async (params: TableAndSortColumn) => {
        return (await selectAllFromTable(...params)).rows;
      };

      return {
        journeyPatternRef: await getTableRows(
          tablesWithSortColumn.journeyPatternRef,
        ),
        scheduledStopPointInJourneyPatternRef: await getTableRows(
          tablesWithSortColumn.scheduledStopPointInJourneyPatternRef,
        ),
        substituteOperatingDayByLineType: await getTableRows(
          tablesWithSortColumn.substituteOperatingDayByLineType,
        ),
        substituteOperatingPeriod: await getTableRows(
          tablesWithSortColumn.substituteOperatingPeriod,
        ),
      };
    };

    const rowsInTablesBefore = await fetchNonAffectedTablesData();
    // Sanity check that all non affected tables are actually checked.
    // If this fails, most likely new tables have been added to database schema.
    // They should be added to this test.
    expect(Object.values(rowsInTablesBefore)).toHaveLength(
      nonAffectedTables.length,
    );

    await executeDeleteMutation();

    const rowsInTablesAfter = await fetchNonAffectedTablesData();
    expect(rowsInTablesAfter).toEqual(rowsInTablesBefore);
  });
});
