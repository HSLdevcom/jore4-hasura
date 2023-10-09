import * as config from '@config';
import { timetablesDbConfig } from '@config';
import * as db from '@util/db';
import { DbConnection, closeDbConnection, createDbConnection } from '@util/db';
import { setupDb } from '@util/setup';
import { defaultTimetablesDataset } from 'generic/timetablesdb/datasets/defaultSetup/default-timetables-dataset';
import {
  GenericTimetablesDbTables,
  genericTimetablesDbTables,
} from 'generic/timetablesdb/datasets/schema';
import { differenceBy, xor } from 'lodash';
import * as rp from 'request-promise';
import {
  buildGenericTimetablesDataset,
  createGenericTableData,
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

  const builtDefaultDataset = buildGenericTimetablesDataset(
    defaultTimetablesDataset,
  );
  const frameToDelete = builtDefaultDataset._vehicle_schedule_frames.winter2022;
  const executeDeleteMutation = () => {
    return rp.post({
      ...config.hasuraRequestTemplate,
      body: {
        query: buildDeleteMutation(frameToDelete.vehicle_schedule_frame_id),
      },
    });
  };

  const selectAllFromTable = (
    tableName: GenericTimetablesDbTables,
    primaryKey: string,
  ) => {
    return db.singleQuery(
      dbConnection,
      `SELECT * FROM ${tableName} ORDER BY ${primaryKey}`,
    );
  };

  // A helper object for using selectAllFromTable
  const tablesWithSortColumn: Record<
    string,
    [GenericTimetablesDbTables, string]
  > = {
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
  };

  beforeEach(async () =>
    setupDb(dbConnection, createGenericTableData(builtDefaultDataset)),
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

  it('should delete correct row from the database', async () => {
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

  it('should cascade delete related children', async () => {
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
    // Sanity check that the above logic returned expected values and not e.g. nothing...
    expect(expectedDeletedServices).toHaveLength(3);
    expect(expectedDeletedBlocks).toHaveLength(3);
    expect(expectedDeletedJourneys).toHaveLength(6);
    expect(expectedDeletedPassingTimes).toHaveLength(24);

    const fetchAffectedTablesData = () => {
      return Promise.all([
        selectAllFromTable(...tablesWithSortColumn.vehicleService),
        selectAllFromTable(...tablesWithSortColumn.block),
        selectAllFromTable(...tablesWithSortColumn.vehicleJourney),
        selectAllFromTable(...tablesWithSortColumn.timetabledPassingTime),
      ]);
    };

    const [
      vehicleServicesBefore,
      blocksBefore,
      vehicleJourneysBefore,
      timetabledPassingTimesBefore,
    ] = await fetchAffectedTablesData();

    await executeDeleteMutation();

    const [
      vehicleServicesAfter,
      blocksAfter,
      vehicleJourneysAfter,
      timetabledPassingTimesAfter,
    ] = await fetchAffectedTablesData();

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

    assertCorrectRowsDeleted(
      vehicleServicesBefore,
      vehicleServicesAfter,
      expectedDeletedServices,
      tablesWithSortColumn.vehicleService[1],
    );
    assertCorrectRowsDeleted(
      blocksBefore,
      blocksAfter,
      expectedDeletedBlocks,
      tablesWithSortColumn.block[1],
    );
    assertCorrectRowsDeleted(
      vehicleJourneysBefore,
      vehicleJourneysAfter,
      expectedDeletedJourneys,
      tablesWithSortColumn.vehicleJourney[1],
    );
    assertCorrectRowsDeleted(
      timetabledPassingTimesBefore,
      timetabledPassingTimesAfter,
      expectedDeletedPassingTimes,
      tablesWithSortColumn.timetabledPassingTime[1],
    );
  });

  it('should not delete from tables that are not direct children of vehicle schedule frame', async () => {
    // Firstly: check that we actually have assertions for all such tables,
    // to ensure this test is kept up to date when new tables are added.
    const affectedTables: Array<GenericTimetablesDbTables> = [
      // These are checked in previous test.
      'vehicle_schedule.vehicle_schedule_frame',
      'vehicle_service.vehicle_service',
      'vehicle_service.block',
      'vehicle_journey.vehicle_journey',
      'passing_times.timetabled_passing_time',
      // This is an automatically generated table, not relevant.
      'vehicle_service.journey_patterns_in_vehicle_service',
    ];
    const nonAffectedTables = xor(genericTimetablesDbTables, affectedTables);
    expect(nonAffectedTables).toHaveLength(
      genericTimetablesDbTables.length - affectedTables.length,
    );

    const fetchNonAffectedTablesData = () => {
      return Promise.all([
        selectAllFromTable(...tablesWithSortColumn.journeyPatternRef),
        selectAllFromTable(
          ...tablesWithSortColumn.scheduledStopPointInJourneyPatternRef,
        ),
      ]);
    };

    const rowsInTablesBefore = await fetchNonAffectedTablesData();
    // Sanity check that all non affected tables are actually checked.
    // If this fails, most likely new tables have been added to database schema.
    // They should be added to this test.
    expect(rowsInTablesBefore).toHaveLength(nonAffectedTables.length);
    const [
      journeyPatternRefsBefore,
      scheduledStopPointInJourneyPatternRefsBefore,
    ] = rowsInTablesBefore;

    await executeDeleteMutation();

    const [
      journeyPatternRefsAfter,
      scheduledStopPointInJourneyPatternRefsAfter,
    ] = await fetchNonAffectedTablesData();
    expect(journeyPatternRefsAfter).toEqual(journeyPatternRefsBefore);
    expect(scheduledStopPointInJourneyPatternRefsAfter).toEqual(
      scheduledStopPointInJourneyPatternRefsBefore,
    );
  });
});
