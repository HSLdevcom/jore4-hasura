import * as config from '@config';
import * as db from '@util/db';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import { setupDb } from '@util/setup';
import {
  defaultDayTypeIds,
  journeyPatternRefsByName,
} from 'generic/timetablesdb/datasets/defaultSetup';
import {
  draftSunApril2024Timetable,
  expressBusServiceSubstitutesSaturday20230520Dataset,
  stoppingBusServiceSubstitutesSaturday20230520Dataset,
  temporarySatFirstHalfApril2023Timetable,
} from 'hsl/timetablesdb/datasets/additional-sets';
import { specialAprilFools2023Timetable } from 'hsl/timetablesdb/datasets/additional-sets/timetables/specialAprilFools2023Dataset';
import { stagingSunApril2024Timetable } from 'hsl/timetablesdb/datasets/additional-sets/timetables/stagingSunApril2024Dataset';
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
  mergeTimetablesDatasets,
} from 'timetables-data-inserter';
import { createHslTimetablesDatasetHelper } from 'timetables-data-inserter/hsl/timetables-dataset-helper';

describe('Function get_timetables_and_substitute_operating_days', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(config.timetablesDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  const getTimetablesAndSubstituteOperatingDays = async (
    dataset: TableData<HslTimetablesDbTables>[],
    journeyPatternIds: string[],
    startDate: DateTime,
    endDate: DateTime,
  ): Promise<Array<TimetableVersion>> => {
    await setupDb(dbConnection, dataset);
    const response = await db.singleQuery(
      dbConnection,
      `SELECT * FROM vehicle_service.get_timetables_and_substitute_operating_days('
        {${journeyPatternIds}}'::uuid[],
        '${startDate.toISODate()}'::date,
        '${endDate.toISODate()}'::date
      )`,
    );

    return response.rows;
  };

  describe('dataset has priorities: standard, temporary, substitute by line type (express bus and stopping bus service) and special', () => {
    it('should return rows for everything else but express bus substitute operating day by line type', async () => {
      const startDate = DateTime.fromISO('2023-01-01');
      const endDate = DateTime.fromISO('2023-12-31');

      const mergedDataset = mergeTimetablesDatasets([
        defaultTimetablesDataset,
        temporarySatFirstHalfApril2023Timetable,
        specialAprilFools2023Timetable,
        stoppingBusServiceSubstitutesSaturday20230520Dataset,
        expressBusServiceSubstitutesSaturday20230520Dataset,
      ]);

      const builtDataset = buildHslTimetablesDataset(mergedDataset);
      const datasetHelper = createHslTimetablesDatasetHelper(builtDataset);

      const vehicleScheduleFrames = builtDataset._vehicle_schedule_frames;

      const response = await getTimetablesAndSubstituteOperatingDays(
        createHslTableData(builtDataset),
        [builtDataset._journey_pattern_refs.route123Inbound.journey_pattern_id],
        startDate,
        endDate,
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
              datasetHelper.getSubstituteOperatingDayByLineTypes(
                'saturday20230520',
              ).substitute_operating_day_by_line_type_id,
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
          {
            vehicle_schedule_frame_id:
              vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
            substitute_operating_day_by_line_type_id: null,
            day_type_id: defaultDayTypeIds.SATURDAY,
            in_effect: false,
          },
          {
            vehicle_schedule_frame_id:
              vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
            substitute_operating_day_by_line_type_id: null,
            day_type_id: defaultDayTypeIds.SUNDAY,
            in_effect: false,
          },
          {
            vehicle_schedule_frame_id:
              vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
            substitute_operating_day_by_line_type_id: null,
            day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
            in_effect: false,
          },
          {
            vehicle_schedule_frame_id:
              vehicleScheduleFrames.specialAscensionDay2023
                .vehicle_schedule_frame_id,
            substitute_operating_day_by_line_type_id: null,
            day_type_id: defaultDayTypeIds.THURSDAY,
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
            vehicle_schedule_frame_id:
              vehicleScheduleFrames.aprilFools2023.vehicle_schedule_frame_id,
            substitute_operating_day_by_line_type_id: null,
            day_type_id: defaultDayTypeIds.SATURDAY,
            in_effect: false,
          },
        ]),
      );
    });
  });

  describe('draft and staging priorities', () => {
    it('should return rows for draft priorities', async () => {
      const startDate = DateTime.fromISO('2024-04-01');
      const endDate = DateTime.fromISO('2024-04-30');

      const mergedDataset = mergeTimetablesDatasets([
        defaultTimetablesDataset,
        draftSunApril2024Timetable,
      ]);

      const builtDataset = buildHslTimetablesDataset(mergedDataset);

      const response = await getTimetablesAndSubstituteOperatingDays(
        createHslTableData(builtDataset),
        [journeyPatternRefsByName.route123Inbound.journey_pattern_id],
        startDate,
        endDate,
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

    it('should not return rows for staging priorities', async () => {
      const startDate = DateTime.fromISO('2024-04-01');
      const endDate = DateTime.fromISO('2024-04-30');

      const mergedDataset = mergeTimetablesDatasets([
        defaultTimetablesDataset,
        stagingSunApril2024Timetable,
      ]);

      const builtDataset = buildHslTimetablesDataset(mergedDataset);

      const response = await getTimetablesAndSubstituteOperatingDays(
        createHslTableData(builtDataset),
        [journeyPatternRefsByName.route123Inbound.journey_pattern_id],
        startDate,
        endDate,
      );

      expect(response.length).toBe(0);
    });
  });
});
