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
  draftSunApril2023Dataset,
  draftSunApril2023VehicleScheduleFrame,
  draftSunApril2024Dataset,
  draftSunApril2024VehicleScheduleFrame,
  expressBusServiceSaturday20230520Dataset,
  getDbDataWithAdditionalDatasets,
  specialAprilFools2023Dataset,
  specialAprilFools2023VehicleScheduleFrame,
  stagingSunApril2024Dataset,
  temporarySatFirstHalfApril2023Dataset,
  temporarySatFirstHalfApril2023VehicleScheduleFrame,
} from 'hsl/timetablesdb/datasets/additional-sets';
import {
  defaultHslTimetablesDbData,
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

    const response = await getTimetableVersions(
      defaultHslTimetablesDbData,
      [journeyPatternRefsByName.route123Inbound.journey_pattern_id],
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

        const response = await getTimetableVersions(
          getDbDataWithAdditionalDatasets({
            datasets: [temporarySatFirstHalfApril2023Dataset],
          }),
          [journeyPatternRefsByName.route123Inbound.journey_pattern_id],
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
                vehicleScheduleFramesByName.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SUNDAY,
              in_effect: true,
            },
            {
              vehicle_schedule_frame_id:
                vehicleScheduleFramesByName.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              in_effect: true,
            },
            {
              vehicle_schedule_frame_id:
                vehicleScheduleFramesByName.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SATURDAY,
              in_effect: true,
            },
            {
              vehicle_schedule_frame_id:
                temporarySatFirstHalfApril2023VehicleScheduleFrame.vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
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
          ]),
        );
      });
    });

    describe('standard and temporary priority are valid on observation date', () => {
      it(`should have temporary priority in effect (Saturday)`, async () => {
        const startDate = DateTime.fromISO('2023-04-01');
        const endDate = DateTime.fromISO('2023-04-30');
        const observationDate = DateTime.fromISO('2023-04-14');

        const response = await getTimetableVersions(
          getDbDataWithAdditionalDatasets({
            datasets: [temporarySatFirstHalfApril2023Dataset],
          }),
          [journeyPatternRefsByName.route123Inbound.journey_pattern_id],
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
                vehicleScheduleFramesByName.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SUNDAY,
              in_effect: true,
            },
            {
              vehicle_schedule_frame_id:
                vehicleScheduleFramesByName.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              in_effect: true,
            },
            {
              vehicle_schedule_frame_id:
                vehicleScheduleFramesByName.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SATURDAY,
              in_effect: false,
            },
            {
              vehicle_schedule_frame_id:
                temporarySatFirstHalfApril2023VehicleScheduleFrame.vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SATURDAY,
              in_effect: true,
            },
            {
              vehicle_schedule_frame_id: null,
              substitute_operating_day_by_line_type_id:
                substituteOperatingDayByLineTypesByName.aprilFools
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

        const response = await getTimetableVersions(
          getDbDataWithAdditionalDatasets({
            datasets: [temporarySatFirstHalfApril2023Dataset],
          }),
          [journeyPatternRefsByName.route123Inbound.journey_pattern_id],
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
                vehicleScheduleFramesByName.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SUNDAY,
              in_effect: true,
            },
            {
              vehicle_schedule_frame_id:
                vehicleScheduleFramesByName.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              in_effect: true,
            },
            {
              vehicle_schedule_frame_id:
                vehicleScheduleFramesByName.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SATURDAY,
              in_effect: false,
            },
            {
              vehicle_schedule_frame_id:
                temporarySatFirstHalfApril2023VehicleScheduleFrame.vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SATURDAY,
              in_effect: false,
            },
            {
              vehicle_schedule_frame_id: null,
              substitute_operating_day_by_line_type_id:
                substituteOperatingDayByLineTypesByName.aprilFools
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

        const response = await getTimetableVersions(
          getDbDataWithAdditionalDatasets({
            datasets: [
              temporarySatFirstHalfApril2023Dataset,
              specialAprilFools2023Dataset,
            ],
          }),
          [journeyPatternRefsByName.route123Inbound.journey_pattern_id],
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
                vehicleScheduleFramesByName.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SUNDAY,
              in_effect: true,
            },
            {
              vehicle_schedule_frame_id:
                vehicleScheduleFramesByName.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              in_effect: true,
            },
            {
              vehicle_schedule_frame_id:
                vehicleScheduleFramesByName.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SATURDAY,
              in_effect: false,
            },
            {
              vehicle_schedule_frame_id:
                temporarySatFirstHalfApril2023VehicleScheduleFrame.vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
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
                specialAprilFools2023VehicleScheduleFrame.vehicle_schedule_frame_id,
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

        const response = await getTimetableVersions(
          defaultHslTimetablesDbData,
          [journeyPatternRefsByName.route123Inbound.journey_pattern_id],
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
                vehicleScheduleFramesByName.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SATURDAY,
              in_effect: true,
            },
            {
              vehicle_schedule_frame_id:
                vehicleScheduleFramesByName.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SUNDAY,
              in_effect: true,
            },
            {
              vehicle_schedule_frame_id:
                vehicleScheduleFramesByName.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              in_effect: true,
            },
            {
              vehicle_schedule_frame_id:
                hslVehicleScheduleFramesByName.specialAscensionDay2023
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

        const response = await getTimetableVersions(
          getDbDataWithAdditionalDatasets({
            datasets: [expressBusServiceSaturday20230520Dataset],
          }),
          [journeyPatternRefsByName.route123Inbound.journey_pattern_id],
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
                vehicleScheduleFramesByName.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SATURDAY,
              in_effect: true,
            },
            {
              vehicle_schedule_frame_id:
                vehicleScheduleFramesByName.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SUNDAY,
              in_effect: true,
            },
            {
              vehicle_schedule_frame_id:
                vehicleScheduleFramesByName.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              in_effect: true,
            },
            {
              vehicle_schedule_frame_id:
                hslVehicleScheduleFramesByName.specialAscensionDay2023
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

        const response = await getTimetableVersions(
          defaultHslTimetablesDbData,
          [journeyPatternRefsByName.route123Inbound.journey_pattern_id],
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
                vehicleScheduleFramesByName.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SATURDAY,
              in_effect: false,
            },
            {
              vehicle_schedule_frame_id:
                vehicleScheduleFramesByName.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SUNDAY,
              in_effect: false,
            },
            {
              vehicle_schedule_frame_id:
                vehicleScheduleFramesByName.winter2022
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

        const response = await getTimetableVersions(
          defaultHslTimetablesDbData,
          [journeyPatternRefsByName.route123Inbound.journey_pattern_id],
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
                vehicleScheduleFramesByName.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SATURDAY,
              in_effect: true,
            },
            {
              vehicle_schedule_frame_id:
                vehicleScheduleFramesByName.winter2022
                  .vehicle_schedule_frame_id,
              substitute_operating_day_by_line_type_id: null,
              day_type_id: defaultDayTypeIds.SUNDAY,
              in_effect: true,
            },
            {
              vehicle_schedule_frame_id:
                vehicleScheduleFramesByName.winter2022
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

  describe('draft and staging priorities', () => {
    it('should not be affected by draft priority (Standard priorities should be in effect)', async () => {
      const startDate = DateTime.fromISO('2023-04-01');
      const endDate = DateTime.fromISO('2023-04-30');
      const observationDate = DateTime.fromISO('2023-04-10');

      const response = await getTimetableVersions(
        getDbDataWithAdditionalDatasets({
          datasets: [draftSunApril2023Dataset],
        }),
        [journeyPatternRefsByName.route123Inbound.journey_pattern_id],
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
              substituteOperatingDayByLineTypesByName.aprilFools
                .substitute_operating_day_by_line_type_id,
            day_type_id: defaultDayTypeIds.SATURDAY,
            in_effect: false,
          },
          {
            vehicle_schedule_frame_id:
              vehicleScheduleFramesByName.winter2022.vehicle_schedule_frame_id,
            substitute_operating_day_by_line_type_id: null,
            day_type_id: defaultDayTypeIds.SUNDAY,
            in_effect: true,
          },
          {
            vehicle_schedule_frame_id:
              vehicleScheduleFramesByName.winter2022.vehicle_schedule_frame_id,
            substitute_operating_day_by_line_type_id: null,
            day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
            in_effect: true,
          },
          {
            vehicle_schedule_frame_id:
              vehicleScheduleFramesByName.winter2022.vehicle_schedule_frame_id,
            substitute_operating_day_by_line_type_id: null,
            day_type_id: defaultDayTypeIds.SATURDAY,
            in_effect: true,
          },
          {
            vehicle_schedule_frame_id:
              draftSunApril2023VehicleScheduleFrame.vehicle_schedule_frame_id,
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

      const response = await getTimetableVersions(
        getDbDataWithAdditionalDatasets({
          datasets: [draftSunApril2024Dataset],
        }),
        [journeyPatternRefsByName.route123Inbound.journey_pattern_id],
        startDate,
        endDate,
        observationDate,
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

    it('should not return staging priorities at all', async () => {
      const startDate = DateTime.fromISO('2024-04-01');
      const endDate = DateTime.fromISO('2024-04-30');
      const observationDate = DateTime.fromISO('2024-04-10');

      const response = await getTimetableVersions(
        getDbDataWithAdditionalDatasets({
          datasets: [stagingSunApril2024Dataset],
        }),
        [journeyPatternRefsByName.route123Inbound.journey_pattern_id],
        startDate,
        endDate,
        observationDate,
      );

      expect(response.length).toBe(0);
    });
  });
});
