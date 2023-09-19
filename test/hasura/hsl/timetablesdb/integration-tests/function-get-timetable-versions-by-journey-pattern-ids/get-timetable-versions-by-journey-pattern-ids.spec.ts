import * as config from '@config';
import * as db from '@util/db';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import { setupDb } from '@util/setup';
import {
  draftSunApril2023Timetable,
  draftSunApril2024Timetable,
  expressBusServiceSubstitutesSaturday20230520Dataset,
  specialAprilFools2023Timetable,
  stagingSunApril2024Timetable,
  temporarySatFirstHalfApril2023Timetable,
} from 'hsl/timetablesdb/datasets/additional-sets';
import { defaultTimetablesDataset } from 'hsl/timetablesdb/datasets/defaultSetup/default-timetables-dataset';
import { HslTimetablesDbTables } from 'hsl/timetablesdb/datasets/schema';
import { TimetableVersion } from 'hsl/timetablesdb/datasets/types';
import {
  mapTimetableVersionResponse,
  sortVersionsForAssert,
} from 'hsl/timetablesdb/test-utils';
import { DateTime } from 'luxon';
import {
  buildHslTimetablesDataset,
  createHslTableData,
  defaultDayTypeIds,
  mergeTimetablesDatasets,
} from 'timetables-data-inserter';
import { createHslTimetablesDatasetHelper } from 'timetables-data-inserter/hsl/timetables-dataset-helper';

describe('function get_timetable_versions_by_journey_pattern_ids', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(config.timetablesDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  const getTimetableVersions = async (
    dataset: TableData<HslTimetablesDbTables>[],
    journeyPatternIds: string[],
    startDate: DateTime,
    endDate: DateTime,
    observationDate: DateTime,
  ): Promise<Array<TimetableVersion>> => {
    await setupDb(dbConnection, dataset);
    const response = await db.singleQuery(
      dbConnection,
      `SELECT * FROM vehicle_service.get_timetable_versions_by_journey_pattern_ids(
        '{${journeyPatternIds}}'::uuid[],
        '${startDate.toISODate()}'::date,
        '${endDate.toISODate()}'::date,
        '${observationDate.toISODate()}'::date
      )`,
    );

    return response.rows;
  };

  it('should have empty result from a timerange where no timetables are valid', async () => {
    const startDate = DateTime.fromISO('2021-01-01');
    const endDate = DateTime.fromISO('2021-06-30');
    const observationDate = DateTime.fromISO('2021-05-01');

    const builtDataset = buildHslTimetablesDataset(defaultTimetablesDataset);
    const response = await getTimetableVersions(
      createHslTableData(builtDataset),
      [builtDataset._journey_pattern_refs.route123Inbound.journey_pattern_id],
      startDate,
      endDate,
      observationDate,
    );

    expect(response.length).toBe(0);
  });

  describe('dataset has priorities: standard (Mon-Fri, Sat, Sun), temporary and substitute operating day by line type (Sat)', () => {
    describe('only standard priority is valid on observation date', () => {
      it(`should have only the standard priority versions in effect`, async () => {
        const startDate = DateTime.fromISO('2023-04-01');
        const endDate = DateTime.fromISO('2023-04-30');
        const observationDate = DateTime.fromISO('2023-04-16');

        const mergedDataset = mergeTimetablesDatasets([
          defaultTimetablesDataset,
          temporarySatFirstHalfApril2023Timetable,
        ]);
        const builtDataset = buildHslTimetablesDataset(mergedDataset);
        const datasetHelper = createHslTimetablesDatasetHelper(builtDataset);
        const response = await getTimetableVersions(
          createHslTableData(builtDataset),
          [
            builtDataset._journey_pattern_refs.route123Inbound
              .journey_pattern_id,
          ],
          startDate,
          endDate,
          observationDate,
        );
        const mappedResponse = mapTimetableVersionResponse(response);

        expect(
          // Sort arrays so that the order does not matter
          sortVersionsForAssert(mappedResponse),
        ).toEqual(
          sortVersionsForAssert([
            {
              vehicle_schedule_frame_id:
                builtDataset._vehicle_schedule_frames.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SUNDAY,
              in_effect: true,
            },
            {
              vehicle_schedule_frame_id:
                builtDataset._vehicle_schedule_frames.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              in_effect: true,
            },
            {
              vehicle_schedule_frame_id:
                builtDataset._vehicle_schedule_frames.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SATURDAY,
              in_effect: true,
            },
            {
              vehicle_schedule_frame_id:
                builtDataset._vehicle_schedule_frames
                  .temporaryFirstHalfApril2023.vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SATURDAY,
              in_effect: false,
            },
            {
              vehicle_schedule_frame_id: null,
              substitute_operating_day_by_line_type_id:
                datasetHelper.getSubstituteOperatingDayByLineTypes('aprilFools')
                  .substitute_operating_day_by_line_type_id,
              day_type_id: defaultDayTypeIds.SATURDAY,
              in_effect: false,
            },
          ]),
        );
      });
    });

    describe('standard and temporary priority are valid on observation date', () => {
      it(`should have temporary priority in effect (Saturday)`, async () => {
        const startDate = DateTime.fromISO('2023-04-01');
        const endDate = DateTime.fromISO('2023-04-30');
        const observationDate = DateTime.fromISO('2023-04-14');

        const mergedDataset = mergeTimetablesDatasets([
          defaultTimetablesDataset,
          temporarySatFirstHalfApril2023Timetable,
        ]);
        const builtDataset = buildHslTimetablesDataset(mergedDataset);
        const datasetHelper = createHslTimetablesDatasetHelper(builtDataset);
        const response = await getTimetableVersions(
          createHslTableData(builtDataset),
          [
            builtDataset._journey_pattern_refs.route123Inbound
              .journey_pattern_id,
          ],
          startDate,
          endDate,
          observationDate,
        );
        const mappedResponse = mapTimetableVersionResponse(response);

        expect(
          // Sort arrays so that the order does not matter
          sortVersionsForAssert(mappedResponse),
        ).toEqual(
          sortVersionsForAssert([
            {
              vehicle_schedule_frame_id:
                builtDataset._vehicle_schedule_frames.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SUNDAY,
              in_effect: true,
            },
            {
              vehicle_schedule_frame_id:
                builtDataset._vehicle_schedule_frames.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              in_effect: true,
            },
            {
              vehicle_schedule_frame_id:
                builtDataset._vehicle_schedule_frames.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SATURDAY,
              in_effect: false,
            },
            {
              vehicle_schedule_frame_id:
                builtDataset._vehicle_schedule_frames
                  .temporaryFirstHalfApril2023.vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SATURDAY,
              in_effect: true,
            },
            {
              vehicle_schedule_frame_id: null,
              substitute_operating_day_by_line_type_id:
                datasetHelper.getSubstituteOperatingDayByLineTypes('aprilFools')
                  .substitute_operating_day_by_line_type_id,
              day_type_id: defaultDayTypeIds.SATURDAY,
              in_effect: false,
            },
          ]),
        );
      });
    });

    describe('standard, temporary and substitute by line type priority are valid on observation date', () => {
      it(`should have substitute day by line type priority in effect (Saturday)`, async () => {
        const startDate = DateTime.fromISO('2023-04-01');
        const endDate = DateTime.fromISO('2023-04-30');
        const observationDate = DateTime.fromISO('2023-04-01');

        const mergedDataset = mergeTimetablesDatasets([
          defaultTimetablesDataset,
          temporarySatFirstHalfApril2023Timetable,
        ]);
        const builtDataset = buildHslTimetablesDataset(mergedDataset);
        const datasetHelper = createHslTimetablesDatasetHelper(builtDataset);
        const response = await getTimetableVersions(
          createHslTableData(builtDataset),
          [
            builtDataset._journey_pattern_refs.route123Inbound
              .journey_pattern_id,
          ],
          startDate,
          endDate,
          observationDate,
        );
        const mappedResponse = mapTimetableVersionResponse(response);

        expect(
          // Sort arrays so that the order does not matter
          sortVersionsForAssert(mappedResponse),
        ).toEqual(
          sortVersionsForAssert([
            {
              vehicle_schedule_frame_id:
                builtDataset._vehicle_schedule_frames.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SUNDAY,
              in_effect: true,
            },
            {
              vehicle_schedule_frame_id:
                builtDataset._vehicle_schedule_frames.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              in_effect: true,
            },
            {
              vehicle_schedule_frame_id:
                builtDataset._vehicle_schedule_frames.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SATURDAY,
              in_effect: false,
            },
            {
              vehicle_schedule_frame_id:
                builtDataset._vehicle_schedule_frames
                  .temporaryFirstHalfApril2023.vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SATURDAY,
              in_effect: false,
            },
            {
              vehicle_schedule_frame_id: null,
              substitute_operating_day_by_line_type_id:
                datasetHelper.getSubstituteOperatingDayByLineTypes('aprilFools')
                  .substitute_operating_day_by_line_type_id,
              day_type_id: defaultDayTypeIds.SATURDAY,
              in_effect: true,
            },
          ]),
        );
      });
    });
  });

  describe('dataset has priorities: standard (Mon-Fri, Sat, Sun), temporary, substitute operating day by line type and special (Sat)', () => {
    describe('standard, temporary and substitute by line type and special priority are valid on observation date', () => {
      it(`should have special priority in effect (Saturday)`, async () => {
        const startDate = DateTime.fromISO('2023-04-01');
        const endDate = DateTime.fromISO('2023-04-30');
        const observationDate = DateTime.fromISO('2023-04-01');

        const mergedDataset = mergeTimetablesDatasets([
          defaultTimetablesDataset,
          temporarySatFirstHalfApril2023Timetable,
          specialAprilFools2023Timetable,
        ]);
        const builtDataset = buildHslTimetablesDataset(mergedDataset);

        const vehicleScheduleFrames = builtDataset._vehicle_schedule_frames;
        const response = await getTimetableVersions(
          createHslTableData(builtDataset),
          [
            builtDataset._journey_pattern_refs.route123Inbound
              .journey_pattern_id,
          ],
          startDate,
          endDate,
          observationDate,
        );
        const mappedResponse = mapTimetableVersionResponse(response);

        expect(
          // Sort arrays so that the order does not matter
          sortVersionsForAssert(mappedResponse),
        ).toEqual(
          sortVersionsForAssert([
            {
              vehicle_schedule_frame_id:
                vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SUNDAY,
              in_effect: true,
            },
            {
              vehicle_schedule_frame_id:
                vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              in_effect: true,
            },
            {
              vehicle_schedule_frame_id:
                vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SATURDAY,
              in_effect: false,
            },
            {
              vehicle_schedule_frame_id:
                vehicleScheduleFrames.temporaryFirstHalfApril2023
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SATURDAY,
              in_effect: false,
            },
            {
              vehicle_schedule_frame_id: null,
              substitute_operating_day_by_line_type_id:
                builtDataset._substitute_operating_periods.aprilFools
                  ._substitute_operating_day_by_line_types.aprilFools
                  .substitute_operating_day_by_line_type_id,
              day_type_id: defaultDayTypeIds.SATURDAY,
              in_effect: false,
            },
            {
              vehicle_schedule_frame_id:
                builtDataset._vehicle_schedule_frames.aprilFools2023
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SATURDAY,
              in_effect: true,
            },
          ]),
        );
      });
    });
  });

  describe('dataset has standard priorities (Mon-Fri, Sat, Sun) and special day (Thu)', () => {
    describe('standard priorities and special priority are valid on observation date', () => {
      it('should have ALL standard priorities AND special day in effect (not 1:1 overlap on day type)', async () => {
        const startDate = DateTime.fromISO('2023-05-01');
        const endDate = DateTime.fromISO('2023-05-31');
        const observationDate = DateTime.fromISO('2023-05-18');

        const builtDataset = buildHslTimetablesDataset(
          defaultTimetablesDataset,
        );
        const response = await getTimetableVersions(
          createHslTableData(builtDataset),
          [
            builtDataset._journey_pattern_refs.route123Inbound
              .journey_pattern_id,
          ],
          startDate,
          endDate,
          observationDate,
        );
        const mappedResponse = mapTimetableVersionResponse(response);

        expect(
          // Sort arrays so that the order does not matter
          sortVersionsForAssert(mappedResponse),
        ).toEqual(
          sortVersionsForAssert([
            {
              vehicle_schedule_frame_id:
                builtDataset._vehicle_schedule_frames.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SATURDAY,
              in_effect: true,
            },
            {
              vehicle_schedule_frame_id:
                builtDataset._vehicle_schedule_frames.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SUNDAY,
              in_effect: true,
            },
            {
              vehicle_schedule_frame_id:
                builtDataset._vehicle_schedule_frames.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              in_effect: true,
            },
            {
              vehicle_schedule_frame_id:
                builtDataset._vehicle_schedule_frames.specialAscensionDay2023
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.THURSDAY,
              in_effect: true,
            },
          ]),
        );
      });
    });
  });

  describe('dataset has substitute operating day for a different type of line (Express bus)', () => {
    describe('substitute operating day would be valid on observation date', () => {
      it('should not include or be affected by the different type of line (Express bus) substitute operating day', async () => {
        const startDate = DateTime.fromISO('2023-05-01');
        const endDate = DateTime.fromISO('2023-05-31');
        const observationDate = DateTime.fromISO('2023-05-20');

        const mergedDataset = mergeTimetablesDatasets([
          defaultTimetablesDataset,
          expressBusServiceSubstitutesSaturday20230520Dataset,
        ]);
        const builtDataset = buildHslTimetablesDataset(mergedDataset);
        const response = await getTimetableVersions(
          createHslTableData(builtDataset),
          [
            builtDataset._journey_pattern_refs.route123Inbound
              .journey_pattern_id,
          ],
          startDate,
          endDate,
          observationDate,
        );

        const mappedResponse = mapTimetableVersionResponse(response);

        expect(
          // Sort arrays so that the order does not matter
          sortVersionsForAssert(mappedResponse),
        ).toEqual(
          sortVersionsForAssert([
            {
              vehicle_schedule_frame_id:
                builtDataset._vehicle_schedule_frames.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SATURDAY,
              in_effect: true,
            },
            {
              vehicle_schedule_frame_id:
                builtDataset._vehicle_schedule_frames.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SUNDAY,
              in_effect: true,
            },
            {
              vehicle_schedule_frame_id:
                builtDataset._vehicle_schedule_frames.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              in_effect: true,
            },
            {
              vehicle_schedule_frame_id:
                builtDataset._vehicle_schedule_frames.specialAscensionDay2023
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.THURSDAY,
              in_effect: false,
            },
          ]),
        );
      });
    });
  });

  describe('dataset has standard priorities (Mon-Fri, Sat, Sun)', () => {
    describe('observation date is out of startDate - endDate range and also out of vehicle_schedule_frame validity range', () => {
      it('should return rows but nothing should be in effect', async () => {
        const startDate = DateTime.fromISO('2023-01-01');
        const endDate = DateTime.fromISO('2023-01-31');
        const observationDate = DateTime.fromISO('2021-01-01');

        const builtDataset = buildHslTimetablesDataset(
          defaultTimetablesDataset,
        );
        const response = await getTimetableVersions(
          createHslTableData(builtDataset),
          [
            builtDataset._journey_pattern_refs.route123Inbound
              .journey_pattern_id,
          ],
          startDate,
          endDate,
          observationDate,
        );

        const mappedResponse = mapTimetableVersionResponse(response);

        expect(
          // Sort arrays so that the order does not matter
          sortVersionsForAssert(mappedResponse),
        ).toEqual(
          sortVersionsForAssert([
            {
              vehicle_schedule_frame_id:
                builtDataset._vehicle_schedule_frames.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SATURDAY,
              in_effect: false,
            },
            {
              vehicle_schedule_frame_id:
                builtDataset._vehicle_schedule_frames.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SUNDAY,
              in_effect: false,
            },
            {
              vehicle_schedule_frame_id:
                builtDataset._vehicle_schedule_frames.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              in_effect: false,
            },
          ]),
        );
      });
    });

    describe('observation date is out of startDate - endDate range but inside vehicle_schedule_frame validity range', () => {
      it('should return rows that are in effect on observation date and valid on observation date and the time range', async () => {
        const startDate = DateTime.fromISO('2023-02-01');
        const endDate = DateTime.fromISO('2023-02-28');
        const observationDate = DateTime.fromISO('2023-01-01');

        const builtDataset = buildHslTimetablesDataset(
          defaultTimetablesDataset,
        );
        const response = await getTimetableVersions(
          createHslTableData(builtDataset),
          [
            builtDataset._journey_pattern_refs.route123Inbound
              .journey_pattern_id,
          ],
          startDate,
          endDate,
          observationDate,
        );

        const mappedResponse = mapTimetableVersionResponse(response);

        expect(
          // Sort arrays so that the order does not matter
          sortVersionsForAssert(mappedResponse),
        ).toEqual(
          sortVersionsForAssert([
            {
              vehicle_schedule_frame_id:
                builtDataset._vehicle_schedule_frames.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SATURDAY,
              in_effect: true,
            },
            {
              vehicle_schedule_frame_id:
                builtDataset._vehicle_schedule_frames.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SUNDAY,
              in_effect: true,
            },
            {
              vehicle_schedule_frame_id:
                builtDataset._vehicle_schedule_frames.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              in_effect: true,
            },
          ]),
        );
      });
    });
  });

  describe('more than one journey pattern', () => {
    describe('time range hits timetables on both journey patterns timetables (winter and summer)', () => {
      describe('observation date is on summer timetables validity range', () => {
        it('should have only the summer timetable version in effect', async () => {
          const startDate = DateTime.fromISO('2023-01-01');
          const endDate = DateTime.fromISO('2023-06-30');
          const observationDate = DateTime.fromISO('2023-06-01');

          const builtDataset = buildHslTimetablesDataset(
            defaultTimetablesDataset,
          );
          const datasetHelper = createHslTimetablesDatasetHelper(builtDataset);
          const response = await getTimetableVersions(
            createHslTableData(builtDataset),
            [
              builtDataset._journey_pattern_refs.route123Inbound
                .journey_pattern_id,
              builtDataset._journey_pattern_refs.route234Outbound
                .journey_pattern_id,
            ],
            startDate,
            endDate,
            observationDate,
          );
          const mappedResponse = mapTimetableVersionResponse(response);

          expect(
            // Sort arrays so that the order does not matter
            sortVersionsForAssert(mappedResponse),
          ).toEqual(
            sortVersionsForAssert([
              {
                vehicle_schedule_frame_id:
                  builtDataset._vehicle_schedule_frames.winter2022
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                day_type_id: defaultDayTypeIds.SUNDAY,
                in_effect: false,
              },
              {
                vehicle_schedule_frame_id:
                  builtDataset._vehicle_schedule_frames.winter2022
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                in_effect: false,
              },
              {
                vehicle_schedule_frame_id:
                  builtDataset._vehicle_schedule_frames.winter2022
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                day_type_id: defaultDayTypeIds.SATURDAY,
                in_effect: false,
              },
              {
                vehicle_schedule_frame_id:
                  builtDataset._vehicle_schedule_frames.specialAscensionDay2023
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                day_type_id: defaultDayTypeIds.THURSDAY,
                in_effect: false,
              },
              {
                vehicle_schedule_frame_id:
                  builtDataset._vehicle_schedule_frames.summer2023
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                in_effect: true,
              },
              {
                day_type_id: defaultDayTypeIds.SATURDAY,
                in_effect: false,
                substitute_operating_day_by_line_type_id:
                  datasetHelper.getSubstituteOperatingDayByLineTypes(
                    'aprilFools',
                  ).substitute_operating_day_by_line_type_id,
                vehicle_schedule_frame_id: null,
              },
            ]),
          );
        });
      });

      describe('observation date is on winter timetables validity range', () => {
        it('should have only the winter timetable version in effect', async () => {
          const startDate = DateTime.fromISO('2023-01-01');
          const endDate = DateTime.fromISO('2023-06-30');
          const observationDate = DateTime.fromISO('2023-01-30');

          const builtDataset = buildHslTimetablesDataset(
            defaultTimetablesDataset,
          );
          const datasetHelper = createHslTimetablesDatasetHelper(builtDataset);
          const response = await getTimetableVersions(
            createHslTableData(builtDataset),
            [
              builtDataset._journey_pattern_refs.route123Inbound
                .journey_pattern_id,
              builtDataset._journey_pattern_refs.route234Outbound
                .journey_pattern_id,
            ],
            startDate,
            endDate,
            observationDate,
          );
          const mappedResponse = mapTimetableVersionResponse(response);

          expect(
            // Sort arrays so that the order does not matter
            sortVersionsForAssert(mappedResponse),
          ).toEqual(
            sortVersionsForAssert([
              {
                vehicle_schedule_frame_id:
                  builtDataset._vehicle_schedule_frames.winter2022
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                day_type_id: defaultDayTypeIds.SUNDAY,
                in_effect: true,
              },
              {
                vehicle_schedule_frame_id:
                  builtDataset._vehicle_schedule_frames.winter2022
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                in_effect: true,
              },
              {
                vehicle_schedule_frame_id:
                  builtDataset._vehicle_schedule_frames.winter2022
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                day_type_id: defaultDayTypeIds.SATURDAY,
                in_effect: true,
              },
              {
                vehicle_schedule_frame_id:
                  builtDataset._vehicle_schedule_frames.specialAscensionDay2023
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                day_type_id: defaultDayTypeIds.THURSDAY,
                in_effect: false,
              },
              {
                vehicle_schedule_frame_id:
                  builtDataset._vehicle_schedule_frames.summer2023
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                in_effect: false,
              },
              {
                day_type_id: defaultDayTypeIds.SATURDAY,
                in_effect: false,
                substitute_operating_day_by_line_type_id:
                  datasetHelper.getSubstituteOperatingDayByLineTypes(
                    'aprilFools',
                  ).substitute_operating_day_by_line_type_id,
                vehicle_schedule_frame_id: null,
              },
            ]),
          );
        });
      });
    });
  });

  describe('draft and staging priorities', () => {
    it('should not be affected by draft priority (Standard priorities should be in effect)', async () => {
      const startDate = DateTime.fromISO('2023-04-01');
      const endDate = DateTime.fromISO('2023-04-30');
      const observationDate = DateTime.fromISO('2023-04-10');

      const mergedDataset = mergeTimetablesDatasets([
        defaultTimetablesDataset,
        draftSunApril2023Timetable,
      ]);
      const builtDataset = buildHslTimetablesDataset(mergedDataset);
      const datasetHelper = createHslTimetablesDatasetHelper(builtDataset);
      const response = await getTimetableVersions(
        createHslTableData(builtDataset),
        [builtDataset._journey_pattern_refs.route123Inbound.journey_pattern_id],
        startDate,
        endDate,
        observationDate,
      );

      const mappedResponse = mapTimetableVersionResponse(response);

      expect(
        // Sort arrays so that the order does not matter
        sortVersionsForAssert(mappedResponse),
      ).toEqual(
        sortVersionsForAssert([
          {
            vehicle_schedule_frame_id: null,
            substitute_operating_day_by_line_type_id:
              datasetHelper.getSubstituteOperatingDayByLineTypes('aprilFools')
                .substitute_operating_day_by_line_type_id,
            day_type_id: defaultDayTypeIds.SATURDAY,
            in_effect: false,
          },
          {
            vehicle_schedule_frame_id:
              builtDataset._vehicle_schedule_frames.winter2022
                .vehicle_schedule_frame_id,
            substitute_operating_day_by_line_type_id: null,
            day_type_id: defaultDayTypeIds.SUNDAY,
            in_effect: true,
          },
          {
            vehicle_schedule_frame_id:
              builtDataset._vehicle_schedule_frames.winter2022
                .vehicle_schedule_frame_id,
            substitute_operating_day_by_line_type_id: null,
            day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
            in_effect: true,
          },
          {
            vehicle_schedule_frame_id:
              builtDataset._vehicle_schedule_frames.winter2022
                .vehicle_schedule_frame_id,
            substitute_operating_day_by_line_type_id: null,
            day_type_id: defaultDayTypeIds.SATURDAY,
            in_effect: true,
          },
          {
            vehicle_schedule_frame_id:
              builtDataset._vehicle_schedule_frames.draftSunApril2023
                .vehicle_schedule_frame_id,
            substitute_operating_day_by_line_type_id: null,
            day_type_id: defaultDayTypeIds.SUNDAY,
            in_effect: false,
          },
        ]),
      );
    });

    it('should not have draft in effect, even if it is the only valid version', async () => {
      const startDate = DateTime.fromISO('2024-04-01');
      const endDate = DateTime.fromISO('2024-04-30');
      const observationDate = DateTime.fromISO('2024-04-10');

      const mergedDataset = mergeTimetablesDatasets([
        defaultTimetablesDataset,
        draftSunApril2024Timetable,
      ]);
      const builtDataset = buildHslTimetablesDataset(mergedDataset);
      const response = await getTimetableVersions(
        createHslTableData(builtDataset),
        [builtDataset._journey_pattern_refs.route123Inbound.journey_pattern_id],
        startDate,
        endDate,
        observationDate,
      );

      const mappedResponse = mapTimetableVersionResponse(response);

      expect(mappedResponse).toEqual([
        {
          vehicle_schedule_frame_id:
            builtDataset._vehicle_schedule_frames.draftSunApril2024
              .vehicle_schedule_frame_id,
          substitute_operating_day_by_line_type_id: null,
          day_type_id: defaultDayTypeIds.SUNDAY,
          in_effect: false,
        },
      ]);
    });

    it('should not return staging priorities at all', async () => {
      const startDate = DateTime.fromISO('2024-04-01');
      const endDate = DateTime.fromISO('2024-04-30');
      const observationDate = DateTime.fromISO('2024-04-10');

      const mergedDataset = mergeTimetablesDatasets([
        defaultTimetablesDataset,
        stagingSunApril2024Timetable,
      ]);
      const builtDataset = buildHslTimetablesDataset(mergedDataset);
      const response = await getTimetableVersions(
        createHslTableData(builtDataset),
        [builtDataset._journey_pattern_refs.route123Inbound.journey_pattern_id],
        startDate,
        endDate,
        observationDate,
      );

      expect(response.length).toBe(0);
    });
  });
});
