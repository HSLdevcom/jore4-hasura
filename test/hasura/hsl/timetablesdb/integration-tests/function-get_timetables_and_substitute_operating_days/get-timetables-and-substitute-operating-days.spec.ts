import * as config from '@config';
import * as db from '@util/db';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import { setupDb } from '@util/setup';
import {
  defaultDayTypeIds,
  journeyPatternRefsByName,
  vehicleScheduleFramesByName,
} from 'generic/timetablesdb/datasets/defaultSetup';
import {
  draftSunApril2024Dataset,
  draftSunApril2024VehicleScheduleFrame,
  expressBusServiceSaturday20230520Dataset,
  getDbDataWithAdditionalDatasets,
  stoppingBusServiceSaturday20230520Dataset,
  stoppingBusServiceSaturday20230520SubstituteOperatingDayByLineType,
  temporarySatFirstHalfApril2023Dataset,
  temporarySatFirstHalfApril2023VehicleService,
} from 'hsl/timetablesdb/datasets/additional-sets';
import {
  specialAprilFools2023Dataset,
  specialAprilFools2023VehicleScheduleFrame,
} from 'hsl/timetablesdb/datasets/additional-sets/timetables/specialAprilFools2023Dataset';
import { stagingSunApril2024Dataset } from 'hsl/timetablesdb/datasets/additional-sets/timetables/stagingSunApril2024Dataset';
import {
  hslVehicleScheduleFramesByName,
  substituteOperatingDayByLineTypesByName,
} from 'hsl/timetablesdb/datasets/defaultSetup';
import { HslTimetablesDbTables } from 'hsl/timetablesdb/datasets/schema';
import { TimetableVersion } from 'hsl/timetablesdb/datasets/types';
import {
  mapTimetableVersionResponse,
  sortVersionsForAssert,
} from 'hsl/timetablesdb/test-utils';
import { DateTime } from 'luxon';

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
      const response = await getTimetablesAndSubstituteOperatingDays(
        getDbDataWithAdditionalDatasets({
          datasets: [
            specialAprilFools2023Dataset,
            temporarySatFirstHalfApril2023Dataset,
            expressBusServiceSaturday20230520Dataset,
            stoppingBusServiceSaturday20230520Dataset,
          ],
        }),
        [journeyPatternRefsByName.route123Inbound.journey_pattern_id],
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
              stoppingBusServiceSaturday20230520SubstituteOperatingDayByLineType.substitute_operating_day_by_line_type_id,
            day_type_id: defaultDayTypeIds.SATURDAY,
            in_effect: false,
          },
          {
            vehicle_schedule_frame_id: null,
            substitute_operating_day_by_line_type_id:
              substituteOperatingDayByLineTypesByName.aprilFools
                .substitute_operating_day_by_line_type_id,
            day_type_id: defaultDayTypeIds.SATURDAY,
            in_effect: false,
          },
          {
            vehicle_schedule_frame_id:
              vehicleScheduleFramesByName.winter2022.vehicle_schedule_frame_id,
            substitute_operating_day_by_line_type_id: null,
            day_type_id: defaultDayTypeIds.SATURDAY,
            in_effect: false,
          },
          {
            vehicle_schedule_frame_id:
              vehicleScheduleFramesByName.winter2022.vehicle_schedule_frame_id,
            substitute_operating_day_by_line_type_id: null,
            day_type_id: defaultDayTypeIds.SUNDAY,
            in_effect: false,
          },
          {
            vehicle_schedule_frame_id:
              vehicleScheduleFramesByName.winter2022.vehicle_schedule_frame_id,
            substitute_operating_day_by_line_type_id: null,
            day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
            in_effect: false,
          },
          {
            vehicle_schedule_frame_id:
              hslVehicleScheduleFramesByName.specialAscensionDay2023
                .vehicle_schedule_frame_id,
            substitute_operating_day_by_line_type_id: null,
            day_type_id: defaultDayTypeIds.THURSDAY,
            in_effect: false,
          },
          {
            vehicle_schedule_frame_id:
              temporarySatFirstHalfApril2023VehicleService.vehicle_schedule_frame_id,
            substitute_operating_day_by_line_type_id: null,
            day_type_id: defaultDayTypeIds.SATURDAY,
            in_effect: false,
          },
          {
            vehicle_schedule_frame_id:
              specialAprilFools2023VehicleScheduleFrame.vehicle_schedule_frame_id,
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

      const response = await getTimetablesAndSubstituteOperatingDays(
        getDbDataWithAdditionalDatasets({
          datasets: [draftSunApril2024Dataset],
        }),
        [journeyPatternRefsByName.route123Inbound.journey_pattern_id],
        startDate,
        endDate,
      );

      const mappedResponse = mapTimetableVersionResponse(response);

      expect(mappedResponse).toEqual([
        {
          vehicle_schedule_frame_id:
            draftSunApril2024VehicleScheduleFrame.vehicle_schedule_frame_id,
          substitute_operating_day_by_line_type_id: null,
          day_type_id: defaultDayTypeIds.SUNDAY,
          in_effect: false,
        },
      ]);
    });

    it('should not return rows for staging priorities', async () => {
      const startDate = DateTime.fromISO('2024-04-01');
      const endDate = DateTime.fromISO('2024-04-30');

      const response = await getTimetablesAndSubstituteOperatingDays(
        getDbDataWithAdditionalDatasets({
          datasets: [stagingSunApril2024Dataset],
        }),
        [journeyPatternRefsByName.route123Inbound.journey_pattern_id],
        startDate,
        endDate,
      );

      expect(response.length).toBe(0);
    });
  });
});
