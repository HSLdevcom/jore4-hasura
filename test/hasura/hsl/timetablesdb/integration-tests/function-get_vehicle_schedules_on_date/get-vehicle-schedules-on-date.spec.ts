import * as config from '@config';
import * as db from '@util/db';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import { setupDb } from '@util/setup';
import {
  defaultDayTypeIds,
  journeyPatternRefsByName,
} from 'generic/timetablesdb/datasets/defaultSetup';
import { TimetablePriority } from 'generic/timetablesdb/datasets/types';
import {
  draftSunApril2023Timetable,
  specialAprilFools2023Timetable,
  stagingSunApril2024Timetable,
  stoppingBusServiceSubstitutesSaturday20230520Dataset,
  temporarySatFirstHalfApril2023Timetable,
} from 'hsl/timetablesdb/datasets/additional-sets';
import { stoppingBusServiceSubstitutesSaturday20230406Dataset } from 'hsl/timetablesdb/datasets/additional-sets/substitute-operating-days-by-line-types/stoppingBusServiceThursday20230406';
import { defaultTimetablesDataset } from 'hsl/timetablesdb/datasets/defaultSetup/default-timetables-dataset';
import { HslTimetablesDbTables } from 'hsl/timetablesdb/datasets/schema';
import { DayOfWeek, VehicleSchedule } from 'hsl/timetablesdb/datasets/types';
import {
  mapVehicleScheduleResponse,
  sortVehicleSchedulesForAssert,
} from 'hsl/timetablesdb/test-utils';
import { DateTime, Duration } from 'luxon';
import {
  buildHslTimetablesDataset,
  createHslTableData,
  mergeTimetablesDatasets,
} from 'timetables-data-inserter';

describe('Function get_timetables_and_substitute_operating_days', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(config.timetablesDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  const getVehicleSchedulesOnDate = async (
    dataset: TableData<HslTimetablesDbTables>[],
    journeyPatternId: UUID,
    observationDate: DateTime,
  ): Promise<Array<VehicleSchedule>> => {
    await setupDb(dbConnection, dataset);
    const response = await db.singleQuery(
      dbConnection,
      `SELECT * FROM vehicle_journey.get_vehicle_schedules_on_date(
        '${journeyPatternId}'::uuid,
        '${observationDate.toISODate()}'::date
      )`,
    );

    return response.rows;
  };

  describe('cases without substitute operating day by line types', () => {
    describe('dataset has priorities: standard(Mon-Fri, Sat, Sun), temporary (Sat), special (Sat, Thu)', () => {
      describe('only standard priorities are valid on observation date', () => {
        it('should return rows for standard priority vehicle schedules', async () => {
          const observationDate = DateTime.fromISO('2023-04-16');
          const mergedDataset = mergeTimetablesDatasets([
            defaultTimetablesDataset,
            temporarySatFirstHalfApril2023Timetable,
            specialAprilFools2023Timetable,
          ]);
          const builtDataset = buildHslTimetablesDataset(mergedDataset);
          const vehicleScheduleFrames = builtDataset._vehicle_schedule_frames;
          const winter2022MonFriVehicleJourneys =
            builtDataset._vehicle_schedule_frames.winter2022._vehicle_services
              .monFri._blocks.block._vehicle_journeys;
          const saturdayVehicleJourneys =
            builtDataset._vehicle_schedule_frames.winter2022._vehicle_services
              .sat._blocks.block._vehicle_journeys;
          const sundayVehicleJourneys =
            builtDataset._vehicle_schedule_frames.winter2022._vehicle_services
              .sun._blocks.block._vehicle_journeys;

          const response = await getVehicleSchedulesOnDate(
            createHslTableData(builtDataset),
            journeyPatternRefsByName.route123Inbound.journey_pattern_id,
            observationDate,
          );

          const mappedResponse = mapVehicleScheduleResponse(response);

          expect(
            // Sort arrays so that the order does not matter
            sortVehicleSchedulesForAssert(mappedResponse),
          ).toEqual(
            sortVehicleSchedulesForAssert([
              {
                vehicle_journey_id:
                  winter2022MonFriVehicleJourneys.route123Inbound1
                    .vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  winter2022MonFriVehicleJourneys.route123Inbound2
                    .vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  winter2022MonFriVehicleJourneys.route123Inbound3
                    .vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  saturdayVehicleJourneys.route123Inbound.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.SATURDAY,
              },
              {
                vehicle_journey_id:
                  sundayVehicleJourneys.route123Inbound.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.SUNDAY,
              },
            ]),
          );
        });
      });

      describe('standard priority (all) and temporary priority (Sat) are valid on observation date', () => {
        it('should return rows for standard (Mon-Fri, Sun) and temporary (Sat)', async () => {
          const observationDate = DateTime.fromISO('2023-04-14');
          const mergedDataset = mergeTimetablesDatasets([
            defaultTimetablesDataset,
            temporarySatFirstHalfApril2023Timetable,
            specialAprilFools2023Timetable,
          ]);
          const builtDataset = buildHslTimetablesDataset(mergedDataset);
          const vehicleScheduleFrames = builtDataset._vehicle_schedule_frames;
          const winter2022MonFriVehicleJourneys =
            builtDataset._vehicle_schedule_frames.winter2022._vehicle_services
              .monFri._blocks.block._vehicle_journeys;
          const temporaryFirstHalfApril2023Journeys =
            builtDataset._vehicle_schedule_frames.temporaryFirstHalfApril2023
              ._vehicle_services.sat._blocks.block._vehicle_journeys;
          const sundayVehicleJourneys =
            builtDataset._vehicle_schedule_frames.winter2022._vehicle_services
              .sun._blocks.block._vehicle_journeys;

          const response = await getVehicleSchedulesOnDate(
            createHslTableData(builtDataset),
            journeyPatternRefsByName.route123Inbound.journey_pattern_id,
            observationDate,
          );

          const mappedResponse = mapVehicleScheduleResponse(response);

          expect(
            // Sort arrays so that the order does not matter
            sortVehicleSchedulesForAssert(mappedResponse),
          ).toEqual(
            sortVehicleSchedulesForAssert([
              {
                vehicle_journey_id:
                  winter2022MonFriVehicleJourneys.route123Inbound1
                    .vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  winter2022MonFriVehicleJourneys.route123Inbound2
                    .vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  winter2022MonFriVehicleJourneys.route123Inbound3
                    .vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  temporaryFirstHalfApril2023Journeys.route123Inbound
                    .vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.temporaryFirstHalfApril2023
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Temporary,
                day_type_id: defaultDayTypeIds.SATURDAY,
              },
              {
                vehicle_journey_id:
                  sundayVehicleJourneys.route123Inbound.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.SUNDAY,
              },
            ]),
          );
        });
      });

      describe('standard priority (all), temporary and special priority (Sat) are valid on observation date', () => {
        it('should return rows for standard (Mon-Fri, Sun) and special (Sat)', async () => {
          const observationDate = DateTime.fromISO('2023-04-01');
          const mergedDataset = mergeTimetablesDatasets([
            defaultTimetablesDataset,
            temporarySatFirstHalfApril2023Timetable,
            specialAprilFools2023Timetable,
          ]);
          const builtDataset = buildHslTimetablesDataset(mergedDataset);
          const vehicleScheduleFrames = builtDataset._vehicle_schedule_frames;
          const winter2022MonFriVehicleJourneys =
            builtDataset._vehicle_schedule_frames.winter2022._vehicle_services
              .monFri._blocks.block._vehicle_journeys;
          const aprilFoolsJourneys =
            builtDataset._vehicle_schedule_frames.aprilFools2023
              ._vehicle_services.sat._blocks.block._vehicle_journeys;
          const sundayVehicleJourneys =
            builtDataset._vehicle_schedule_frames.winter2022._vehicle_services
              .sun._blocks.block._vehicle_journeys;
          const response = await getVehicleSchedulesOnDate(
            createHslTableData(builtDataset),
            journeyPatternRefsByName.route123Inbound.journey_pattern_id,
            observationDate,
          );

          const mappedResponse = mapVehicleScheduleResponse(response);

          expect(
            // Sort arrays so that the order does not matter
            sortVehicleSchedulesForAssert(mappedResponse),
          ).toEqual(
            sortVehicleSchedulesForAssert([
              {
                vehicle_journey_id:
                  winter2022MonFriVehicleJourneys.route123Inbound1
                    .vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  winter2022MonFriVehicleJourneys.route123Inbound2
                    .vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  winter2022MonFriVehicleJourneys.route123Inbound3
                    .vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  aprilFoolsJourneys.route123Outbound.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.aprilFools2023
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Special,
                day_type_id: defaultDayTypeIds.SATURDAY,
              },
              {
                vehicle_journey_id:
                  sundayVehicleJourneys.route123Inbound.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.SUNDAY,
              },
            ]),
          );
        });
      });

      describe('standard priority (all) and special priority (Thu) are valid on observation date', () => {
        it('should return rows for standard (Mon-Fri, Sat, Sun) and special (Thu)', async () => {
          const observationDate = DateTime.fromISO('2023-05-18');
          const mergedDataset = mergeTimetablesDatasets([
            defaultTimetablesDataset,
            temporarySatFirstHalfApril2023Timetable,
            specialAprilFools2023Timetable,
          ]);
          const builtDataset = buildHslTimetablesDataset(mergedDataset);
          const vehicleScheduleFrames = builtDataset._vehicle_schedule_frames;
          const winter2022MonFriVehicleJourneys =
            builtDataset._vehicle_schedule_frames.winter2022._vehicle_services
              .monFri._blocks.block._vehicle_journeys;
          const saturdayVehicleJourneys =
            builtDataset._vehicle_schedule_frames.winter2022._vehicle_services
              .sat._blocks.block._vehicle_journeys;
          const sundayVehicleJourneys =
            builtDataset._vehicle_schedule_frames.winter2022._vehicle_services
              .sun._blocks.block._vehicle_journeys;
          const ascensionDayVehicleJourneys =
            builtDataset._vehicle_schedule_frames.specialAscensionDay2023
              ._vehicle_services.thursday._blocks.block._vehicle_journeys;
          const response = await getVehicleSchedulesOnDate(
            createHslTableData(builtDataset),
            journeyPatternRefsByName.route123Inbound.journey_pattern_id,
            observationDate,
          );

          const mappedResponse = mapVehicleScheduleResponse(response);

          expect(
            // Sort arrays so that the order does not matter
            sortVehicleSchedulesForAssert(mappedResponse),
          ).toEqual(
            sortVehicleSchedulesForAssert([
              {
                vehicle_journey_id:
                  winter2022MonFriVehicleJourneys.route123Inbound1
                    .vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  winter2022MonFriVehicleJourneys.route123Inbound2
                    .vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  winter2022MonFriVehicleJourneys.route123Inbound3
                    .vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  ascensionDayVehicleJourneys.route123Inbound
                    .vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.specialAscensionDay2023
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Special,
                day_type_id: defaultDayTypeIds.THURSDAY,
              },
              {
                vehicle_journey_id:
                  saturdayVehicleJourneys.route123Inbound.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.SATURDAY,
              },
              {
                vehicle_journey_id:
                  sundayVehicleJourneys.route123Inbound.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.SUNDAY,
              },
            ]),
          );
        });
      });
    });

    describe('dataset has standard, draft and staging priorities', () => {
      describe('draft and standard priorities are valid on observation date', () => {
        it('should not include draft priorities in the result set', async () => {
          const observationDate = DateTime.fromISO('2023-04-02');
          const mergedDataset = mergeTimetablesDatasets([
            defaultTimetablesDataset,
            draftSunApril2023Timetable,
            stagingSunApril2024Timetable,
          ]);
          const builtDataset = buildHslTimetablesDataset(mergedDataset);
          const vehicleScheduleFrames = builtDataset._vehicle_schedule_frames;
          const winter2022MonFriVehicleJourneys =
            builtDataset._vehicle_schedule_frames.winter2022._vehicle_services
              .monFri._blocks.block._vehicle_journeys;
          const saturdayVehicleJourneys =
            builtDataset._vehicle_schedule_frames.winter2022._vehicle_services
              .sat._blocks.block._vehicle_journeys;
          const sundayVehicleJourneys =
            builtDataset._vehicle_schedule_frames.winter2022._vehicle_services
              .sun._blocks.block._vehicle_journeys;
          const response = await getVehicleSchedulesOnDate(
            createHslTableData(builtDataset),
            journeyPatternRefsByName.route123Inbound.journey_pattern_id,
            observationDate,
          );

          const mappedResponse = mapVehicleScheduleResponse(response);

          expect(
            // Sort arrays so that the order does not matter
            sortVehicleSchedulesForAssert(mappedResponse),
          ).toEqual(
            sortVehicleSchedulesForAssert([
              {
                vehicle_journey_id:
                  winter2022MonFriVehicleJourneys.route123Inbound1
                    .vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  winter2022MonFriVehicleJourneys.route123Inbound2
                    .vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  winter2022MonFriVehicleJourneys.route123Inbound3
                    .vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  saturdayVehicleJourneys.route123Inbound.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.SATURDAY,
              },
              {
                vehicle_journey_id:
                  sundayVehicleJourneys.route123Inbound.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.SUNDAY,
              },
            ]),
          );
        });
      });

      describe('staging priority is the only valid on observation date', () => {
        it('should return empty array', async () => {
          const observationDate = DateTime.fromISO('2024-04-07');
          const mergedDataset = mergeTimetablesDatasets([
            defaultTimetablesDataset,
            draftSunApril2023Timetable,
            stagingSunApril2024Timetable,
          ]);
          const builtDataset = buildHslTimetablesDataset(mergedDataset);
          const response = await getVehicleSchedulesOnDate(
            createHslTableData(builtDataset),
            journeyPatternRefsByName.route123Inbound.journey_pattern_id,
            observationDate,
          );

          expect(response).toEqual([]);
        });
      });
    });
  });

  describe('cases with substitute operating days', () => {
    describe('dataset has priorities: standard(Mon-Fri, Sat, Sun), temporary and substitute (Sat (operated like Friday))', () => {
      describe('standard, temporary and substitute are valid on observation date', () => {
        it('should have substitute priority for saturday which has same vehicle_journey_id as Mon-Fri rows', async () => {
          const observationDate = DateTime.fromISO('2023-04-01');
          const mergedDataset = mergeTimetablesDatasets([
            defaultTimetablesDataset,
            temporarySatFirstHalfApril2023Timetable,
          ]);
          const builtDataset = buildHslTimetablesDataset(mergedDataset);
          const vehicleScheduleFrames = builtDataset._vehicle_schedule_frames;
          const winter2022MonFriVehicleJourneys =
            builtDataset._vehicle_schedule_frames.winter2022._vehicle_services
              .monFri._blocks.block._vehicle_journeys;
          const sundayVehicleJourneys =
            builtDataset._vehicle_schedule_frames.winter2022._vehicle_services
              .sun._blocks.block._vehicle_journeys;
          const aprilFoolsSubstituteOperatingDay =
            builtDataset._substitute_operating_periods.aprilFools
              ._substitute_operating_day_by_line_types.aprilFools;
          const response = await getVehicleSchedulesOnDate(
            createHslTableData(builtDataset),
            journeyPatternRefsByName.route123Inbound.journey_pattern_id,
            observationDate,
          );

          const mappedResponse = mapVehicleScheduleResponse(response);

          expect(
            // Sort arrays so that the order does not matter
            sortVehicleSchedulesForAssert(mappedResponse),
          ).toEqual(
            sortVehicleSchedulesForAssert([
              {
                vehicle_journey_id:
                  winter2022MonFriVehicleJourneys.route123Inbound1
                    .vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  winter2022MonFriVehicleJourneys.route123Inbound2
                    .vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  winter2022MonFriVehicleJourneys.route123Inbound3
                    .vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  winter2022MonFriVehicleJourneys.route123Inbound1
                    .vehicle_journey_id,
                vehicle_schedule_frame_id: null,
                substitute_operating_day_by_line_type_id:
                  aprilFoolsSubstituteOperatingDay.substitute_operating_day_by_line_type_id,
                priority: TimetablePriority.SubstituteOperatingDayByLineType,
                day_type_id: defaultDayTypeIds.SATURDAY,
              },
              {
                vehicle_journey_id:
                  winter2022MonFriVehicleJourneys.route123Inbound2
                    .vehicle_journey_id,
                vehicle_schedule_frame_id: null,
                substitute_operating_day_by_line_type_id:
                  aprilFoolsSubstituteOperatingDay.substitute_operating_day_by_line_type_id,
                priority: TimetablePriority.SubstituteOperatingDayByLineType,
                day_type_id: defaultDayTypeIds.SATURDAY,
              },
              {
                vehicle_journey_id:
                  winter2022MonFriVehicleJourneys.route123Inbound3
                    .vehicle_journey_id,
                vehicle_schedule_frame_id: null,
                substitute_operating_day_by_line_type_id:
                  aprilFoolsSubstituteOperatingDay.substitute_operating_day_by_line_type_id,
                priority: TimetablePriority.SubstituteOperatingDayByLineType,
                day_type_id: defaultDayTypeIds.SATURDAY,
              },
              {
                vehicle_journey_id:
                  sundayVehicleJourneys.route123Inbound.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.SUNDAY,
              },
            ]),
          );
        });
      });
    });

    describe('dataset has priorities: standard(Mon-Fri, Sat, Sun), substitute(Thu (operated like Sunday))', () => {
      describe('standard, temporary and substitute are valid on observation date', () => {
        it('should have all standard priority vehicle_schedules and also substitute for Thursday(same vj_id as Sunday)', async () => {
          const observationDate = DateTime.fromISO('2023-04-06');
          const mergedDataset = mergeTimetablesDatasets([
            defaultTimetablesDataset,
            stoppingBusServiceSubstitutesSaturday20230406Dataset,
          ]);
          const builtDataset = buildHslTimetablesDataset(mergedDataset);
          const vehicleScheduleFrames = builtDataset._vehicle_schedule_frames;
          const winter2022MonFriVehicleJourneys =
            builtDataset._vehicle_schedule_frames.winter2022._vehicle_services
              .monFri._blocks.block._vehicle_journeys;
          const sundayVehicleJourneys =
            builtDataset._vehicle_schedule_frames.winter2022._vehicle_services
              .sun._blocks.block._vehicle_journeys;
          const saturdayVehicleJourneys =
            builtDataset._vehicle_schedule_frames.winter2022._vehicle_services
              .sat._blocks.block._vehicle_journeys;
          const response = await getVehicleSchedulesOnDate(
            createHslTableData(builtDataset),
            journeyPatternRefsByName.route123Inbound.journey_pattern_id,
            observationDate,
          );

          const mappedResponse = mapVehicleScheduleResponse(response);

          expect(
            // Sort arrays so that the order does not matter
            sortVehicleSchedulesForAssert(mappedResponse),
          ).toEqual(
            sortVehicleSchedulesForAssert([
              {
                vehicle_journey_id:
                  winter2022MonFriVehicleJourneys.route123Inbound1
                    .vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  winter2022MonFriVehicleJourneys.route123Inbound2
                    .vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  winter2022MonFriVehicleJourneys.route123Inbound3
                    .vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  sundayVehicleJourneys.route123Inbound.vehicle_journey_id,
                vehicle_schedule_frame_id: null,
                substitute_operating_day_by_line_type_id:
                  builtDataset._substitute_operating_periods.saturday20230406
                    ._substitute_operating_day_by_line_types.saturday20230406
                    .substitute_operating_day_by_line_type_id,
                priority: TimetablePriority.SubstituteOperatingDayByLineType,
                day_type_id: defaultDayTypeIds.THURSDAY,
              },
              {
                vehicle_journey_id:
                  saturdayVehicleJourneys.route123Inbound.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.SATURDAY,
              },
              {
                vehicle_journey_id:
                  sundayVehicleJourneys.route123Inbound.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.SUNDAY,
              },
            ]),
          );
        });
      });
    });

    describe('dataset has priorities: standard(Mon-Fri, Sat, Sun), temporary, special and substitute (Sat (operated like Friday))', () => {
      describe('standard, temporary, special and substitute are valid on observation date', () => {
        it('should return standard priority (Mon-Fri, Sun) and special (Sat) vehicle schedules', async () => {
          const observationDate = DateTime.fromISO('2023-04-01');
          const mergedDataset = mergeTimetablesDatasets([
            defaultTimetablesDataset,
            temporarySatFirstHalfApril2023Timetable,
            specialAprilFools2023Timetable,
          ]);
          const builtDataset = buildHslTimetablesDataset(mergedDataset);
          const vehicleScheduleFrames = builtDataset._vehicle_schedule_frames;
          const winter2022MonFriVehicleJourneys =
            builtDataset._vehicle_schedule_frames.winter2022._vehicle_services
              .monFri._blocks.block._vehicle_journeys;
          const sundayVehicleJourneys =
            builtDataset._vehicle_schedule_frames.winter2022._vehicle_services
              .sun._blocks.block._vehicle_journeys;
          const aprilFoolsJourneys =
            builtDataset._vehicle_schedule_frames.aprilFools2023
              ._vehicle_services.sat._blocks.block._vehicle_journeys;
          const response = await getVehicleSchedulesOnDate(
            createHslTableData(builtDataset),
            journeyPatternRefsByName.route123Inbound.journey_pattern_id,
            observationDate,
          );

          const mappedResponse = mapVehicleScheduleResponse(response);

          expect(
            // Sort arrays so that the order does not matter
            sortVehicleSchedulesForAssert(mappedResponse),
          ).toEqual(
            sortVehicleSchedulesForAssert([
              {
                vehicle_journey_id:
                  winter2022MonFriVehicleJourneys.route123Inbound1
                    .vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  winter2022MonFriVehicleJourneys.route123Inbound2
                    .vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  winter2022MonFriVehicleJourneys.route123Inbound3
                    .vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  aprilFoolsJourneys.route123Outbound.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.aprilFools2023
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Special,
                day_type_id: defaultDayTypeIds.SATURDAY,
              },
              {
                vehicle_journey_id:
                  sundayVehicleJourneys.route123Inbound.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.SUNDAY,
              },
            ]),
          );
        });
      });
    });

    describe('dataset has priorities Standard (Mon-Fri, Sat, Sun) and substitute day (Sat)', () => {
      describe('standard and susbstitute day are valid on observation date', () => {
        describe('substitute day is no-operation day (substitute_day_of_week is null)', () => {
          it('should have the generated no-operating row for substitute day (Sat)', async () => {
            const observationDate = DateTime.fromISO('2023-05-20');
            const mergedDataset = mergeTimetablesDatasets([
              defaultTimetablesDataset,
              stoppingBusServiceSubstitutesSaturday20230520Dataset,
            ]);
            const builtDataset = buildHslTimetablesDataset(mergedDataset);
            const vehicleScheduleFrames = builtDataset._vehicle_schedule_frames;
            const winter2022MonFriVehicleJourneys =
              builtDataset._vehicle_schedule_frames.winter2022._vehicle_services
                .monFri._blocks.block._vehicle_journeys;
            const sundayVehicleJourneys =
              builtDataset._vehicle_schedule_frames.winter2022._vehicle_services
                .sun._blocks.block._vehicle_journeys;
            const response = await getVehicleSchedulesOnDate(
              createHslTableData(builtDataset),
              journeyPatternRefsByName.route123Inbound.journey_pattern_id,
              observationDate,
            );

            const mappedResponse = mapVehicleScheduleResponse(response);

            expect(
              // Sort arrays so that the order does not matter
              sortVehicleSchedulesForAssert(mappedResponse),
            ).toEqual(
              sortVehicleSchedulesForAssert([
                {
                  vehicle_journey_id:
                    winter2022MonFriVehicleJourneys.route123Inbound1
                      .vehicle_journey_id,
                  vehicle_schedule_frame_id:
                    vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                  substitute_operating_day_by_line_type_id: null,
                  priority: TimetablePriority.Standard,
                  day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                },
                {
                  vehicle_journey_id:
                    winter2022MonFriVehicleJourneys.route123Inbound2
                      .vehicle_journey_id,
                  vehicle_schedule_frame_id:
                    vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                  substitute_operating_day_by_line_type_id: null,
                  priority: TimetablePriority.Standard,
                  day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                },
                {
                  vehicle_journey_id:
                    winter2022MonFriVehicleJourneys.route123Inbound3
                      .vehicle_journey_id,
                  vehicle_schedule_frame_id:
                    vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                  substitute_operating_day_by_line_type_id: null,
                  priority: TimetablePriority.Standard,
                  day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                },
                {
                  vehicle_journey_id: null,
                  vehicle_schedule_frame_id: null,
                  substitute_operating_day_by_line_type_id:
                    builtDataset._substitute_operating_periods.saturday20230520
                      ._substitute_operating_day_by_line_types.saturday20230520
                      .substitute_operating_day_by_line_type_id,
                  priority: TimetablePriority.SubstituteOperatingDayByLineType,
                  day_type_id: defaultDayTypeIds.SATURDAY,
                },
                {
                  vehicle_journey_id:
                    sundayVehicleJourneys.route123Inbound.vehicle_journey_id,
                  vehicle_schedule_frame_id:
                    vehicleScheduleFrames.winter2022.vehicle_schedule_frame_id,
                  substitute_operating_day_by_line_type_id: null,
                  priority: TimetablePriority.Standard,
                  day_type_id: defaultDayTypeIds.SUNDAY,
                },
              ]),
            );
          });
        });

        describe('substitute day target has no departures on given time restrictions', () => {
          describe('begin_time is after the last departure of target day', () => {
            it('should have the generated no-operating row for substitute day (Sat)', async () => {
              const observationDate = DateTime.fromISO('2023-05-20');
              const saturdaySubstitute =
                stoppingBusServiceSubstitutesSaturday20230520Dataset
                  ._substitute_operating_periods.saturday20230520
                  ._substitute_operating_day_by_line_types.saturday20230520;
              const modifiedSubstituteDataset = {
                _substitute_operating_periods: {
                  saturday20230520: {
                    _substitute_operating_day_by_line_types: {
                      saturday20230520: {
                        ...saturdaySubstitute,
                        substitute_day_of_week: DayOfWeek.Friday,
                        begin_time: Duration.fromISO('PT12H'),
                      },
                    },
                  },
                },
              };
              const mergedDataset = mergeTimetablesDatasets([
                defaultTimetablesDataset,
                modifiedSubstituteDataset,
              ]);
              const builtDataset = buildHslTimetablesDataset(mergedDataset);
              const vehicleScheduleFrames =
                builtDataset._vehicle_schedule_frames;
              const winter2022MonFriVehicleJourneys =
                builtDataset._vehicle_schedule_frames.winter2022
                  ._vehicle_services.monFri._blocks.block._vehicle_journeys;
              const sundayVehicleJourneys =
                builtDataset._vehicle_schedule_frames.winter2022
                  ._vehicle_services.sun._blocks.block._vehicle_journeys;
              const response = await getVehicleSchedulesOnDate(
                createHslTableData(builtDataset),
                journeyPatternRefsByName.route123Inbound.journey_pattern_id,
                observationDate,
              );

              const mappedResponse = mapVehicleScheduleResponse(response);

              expect(
                // Sort arrays so that the order does not matter
                sortVehicleSchedulesForAssert(mappedResponse),
              ).toEqual(
                sortVehicleSchedulesForAssert([
                  {
                    vehicle_journey_id:
                      winter2022MonFriVehicleJourneys.route123Inbound1
                        .vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFrames.winter2022
                        .vehicle_schedule_frame_id,
                    substitute_operating_day_by_line_type_id: null,
                    priority: TimetablePriority.Standard,
                    day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                  },
                  {
                    vehicle_journey_id:
                      winter2022MonFriVehicleJourneys.route123Inbound2
                        .vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFrames.winter2022
                        .vehicle_schedule_frame_id,
                    substitute_operating_day_by_line_type_id: null,
                    priority: TimetablePriority.Standard,
                    day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                  },
                  {
                    vehicle_journey_id:
                      winter2022MonFriVehicleJourneys.route123Inbound3
                        .vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFrames.winter2022
                        .vehicle_schedule_frame_id,
                    substitute_operating_day_by_line_type_id: null,
                    priority: TimetablePriority.Standard,
                    day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                  },
                  {
                    vehicle_journey_id: null,
                    vehicle_schedule_frame_id: null,
                    substitute_operating_day_by_line_type_id:
                      builtDataset._substitute_operating_periods
                        .saturday20230520
                        ._substitute_operating_day_by_line_types
                        .saturday20230520
                        .substitute_operating_day_by_line_type_id,
                    priority:
                      TimetablePriority.SubstituteOperatingDayByLineType,
                    day_type_id: defaultDayTypeIds.SATURDAY,
                  },
                  {
                    vehicle_journey_id:
                      sundayVehicleJourneys.route123Inbound.vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFrames.winter2022
                        .vehicle_schedule_frame_id,
                    substitute_operating_day_by_line_type_id: null,
                    priority: TimetablePriority.Standard,
                    day_type_id: defaultDayTypeIds.SUNDAY,
                  },
                ]),
              );
            });
          });

          describe('end_time is before the first departure of target day (Fri)', () => {
            it('should have the generated no-operating row for substitute day (Sat)', async () => {
              const observationDate = DateTime.fromISO('2023-05-20');
              const saturdaySubstitute =
                stoppingBusServiceSubstitutesSaturday20230520Dataset
                  ._substitute_operating_periods.saturday20230520
                  ._substitute_operating_day_by_line_types.saturday20230520;
              const modifiedSubstituteDataset = {
                _substitute_operating_periods: {
                  saturday20230520: {
                    _substitute_operating_day_by_line_types: {
                      saturday20230520: {
                        ...saturdaySubstitute,
                        substitute_day_of_week: DayOfWeek.Friday,
                        end_time: Duration.fromISO('PT06H'),
                      },
                    },
                  },
                },
              };
              const mergedDataset = mergeTimetablesDatasets([
                defaultTimetablesDataset,
                modifiedSubstituteDataset,
              ]);
              const builtDataset = buildHslTimetablesDataset(mergedDataset);
              const vehicleScheduleFrames =
                builtDataset._vehicle_schedule_frames;
              const winter2022MonFriVehicleJourneys =
                builtDataset._vehicle_schedule_frames.winter2022
                  ._vehicle_services.monFri._blocks.block._vehicle_journeys;
              const sundayVehicleJourneys =
                builtDataset._vehicle_schedule_frames.winter2022
                  ._vehicle_services.sun._blocks.block._vehicle_journeys;
              const response = await getVehicleSchedulesOnDate(
                createHslTableData(builtDataset),
                journeyPatternRefsByName.route123Inbound.journey_pattern_id,
                observationDate,
              );

              const mappedResponse = mapVehicleScheduleResponse(response);

              expect(
                // Sort arrays so that the order does not matter
                sortVehicleSchedulesForAssert(mappedResponse),
              ).toEqual(
                sortVehicleSchedulesForAssert([
                  {
                    vehicle_journey_id:
                      winter2022MonFriVehicleJourneys.route123Inbound1
                        .vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFrames.winter2022
                        .vehicle_schedule_frame_id,
                    substitute_operating_day_by_line_type_id: null,
                    priority: TimetablePriority.Standard,
                    day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                  },
                  {
                    vehicle_journey_id:
                      winter2022MonFriVehicleJourneys.route123Inbound2
                        .vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFrames.winter2022
                        .vehicle_schedule_frame_id,
                    substitute_operating_day_by_line_type_id: null,
                    priority: TimetablePriority.Standard,
                    day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                  },
                  {
                    vehicle_journey_id:
                      winter2022MonFriVehicleJourneys.route123Inbound3
                        .vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFrames.winter2022
                        .vehicle_schedule_frame_id,
                    substitute_operating_day_by_line_type_id: null,
                    priority: TimetablePriority.Standard,
                    day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                  },
                  {
                    vehicle_journey_id: null,
                    vehicle_schedule_frame_id: null,
                    substitute_operating_day_by_line_type_id:
                      builtDataset._substitute_operating_periods
                        .saturday20230520
                        ._substitute_operating_day_by_line_types
                        .saturday20230520
                        .substitute_operating_day_by_line_type_id,
                    priority:
                      TimetablePriority.SubstituteOperatingDayByLineType,
                    day_type_id: defaultDayTypeIds.SATURDAY,
                  },
                  {
                    vehicle_journey_id:
                      sundayVehicleJourneys.route123Inbound.vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFrames.winter2022
                        .vehicle_schedule_frame_id,
                    substitute_operating_day_by_line_type_id: null,
                    priority: TimetablePriority.Standard,
                    day_type_id: defaultDayTypeIds.SUNDAY,
                  },
                ]),
              );
            });
          });
        });

        describe('substitute day target has restricted departures on given time restrictions', () => {
          describe('begin_time is after the first departure of target day (Fri)', () => {
            it('should leave out the first target (Fri) departure for substitute day (Sat)', async () => {
              const observationDate = DateTime.fromISO('2023-05-20');
              const saturdaySubstitute =
                stoppingBusServiceSubstitutesSaturday20230520Dataset
                  ._substitute_operating_periods.saturday20230520
                  ._substitute_operating_day_by_line_types.saturday20230520;
              const modifiedSubstituteDataset = {
                _substitute_operating_periods: {
                  saturday20230520: {
                    _substitute_operating_day_by_line_types: {
                      saturday20230520: {
                        ...saturdaySubstitute,
                        substitute_day_of_week: DayOfWeek.Friday,
                        begin_time: Duration.fromISO('PT8H'),
                      },
                    },
                  },
                },
              };
              const mergedDataset = mergeTimetablesDatasets([
                defaultTimetablesDataset,
                modifiedSubstituteDataset,
              ]);
              const builtDataset = buildHslTimetablesDataset(mergedDataset);
              const vehicleScheduleFrames =
                builtDataset._vehicle_schedule_frames;
              const winter2022MonFriVehicleJourneys =
                builtDataset._vehicle_schedule_frames.winter2022
                  ._vehicle_services.monFri._blocks.block._vehicle_journeys;
              const sundayVehicleJourneys =
                builtDataset._vehicle_schedule_frames.winter2022
                  ._vehicle_services.sun._blocks.block._vehicle_journeys;
              const saturday20230520SubstituteOperatingDay =
                builtDataset._substitute_operating_periods.saturday20230520
                  ._substitute_operating_day_by_line_types.saturday20230520;
              const response = await getVehicleSchedulesOnDate(
                createHslTableData(builtDataset),
                journeyPatternRefsByName.route123Inbound.journey_pattern_id,
                observationDate,
              );

              const mappedResponse = mapVehicleScheduleResponse(response);

              expect(
                // Sort arrays so that the order does not matter
                sortVehicleSchedulesForAssert(mappedResponse),
              ).toEqual(
                sortVehicleSchedulesForAssert([
                  {
                    vehicle_journey_id:
                      winter2022MonFriVehicleJourneys.route123Inbound1
                        .vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFrames.winter2022
                        .vehicle_schedule_frame_id,
                    substitute_operating_day_by_line_type_id: null,
                    priority: TimetablePriority.Standard,
                    day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                  },
                  {
                    vehicle_journey_id:
                      winter2022MonFriVehicleJourneys.route123Inbound2
                        .vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFrames.winter2022
                        .vehicle_schedule_frame_id,
                    substitute_operating_day_by_line_type_id: null,
                    priority: TimetablePriority.Standard,
                    day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                  },
                  {
                    vehicle_journey_id:
                      winter2022MonFriVehicleJourneys.route123Inbound3
                        .vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFrames.winter2022
                        .vehicle_schedule_frame_id,
                    substitute_operating_day_by_line_type_id: null,
                    priority: TimetablePriority.Standard,
                    day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                  },
                  {
                    vehicle_journey_id:
                      winter2022MonFriVehicleJourneys.route123Inbound2
                        .vehicle_journey_id,
                    vehicle_schedule_frame_id: null,
                    substitute_operating_day_by_line_type_id:
                      saturday20230520SubstituteOperatingDay.substitute_operating_day_by_line_type_id,
                    priority:
                      TimetablePriority.SubstituteOperatingDayByLineType,
                    day_type_id: defaultDayTypeIds.SATURDAY,
                  },
                  {
                    vehicle_journey_id:
                      winter2022MonFriVehicleJourneys.route123Inbound3
                        .vehicle_journey_id,
                    vehicle_schedule_frame_id: null,
                    substitute_operating_day_by_line_type_id:
                      saturday20230520SubstituteOperatingDay.substitute_operating_day_by_line_type_id,
                    priority:
                      TimetablePriority.SubstituteOperatingDayByLineType,
                    day_type_id: defaultDayTypeIds.SATURDAY,
                  },
                  {
                    vehicle_journey_id:
                      sundayVehicleJourneys.route123Inbound.vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFrames.winter2022
                        .vehicle_schedule_frame_id,
                    substitute_operating_day_by_line_type_id: null,
                    priority: TimetablePriority.Standard,
                    day_type_id: defaultDayTypeIds.SUNDAY,
                  },
                ]),
              );
            });
          });

          describe('end_time is before the last departure of target day (Fri)', () => {
            it('should leave out the last target (Fri) departure for substitute day (Sat)', async () => {
              const observationDate = DateTime.fromISO('2023-05-20');
              const saturdaySubstitute =
                stoppingBusServiceSubstitutesSaturday20230520Dataset
                  ._substitute_operating_periods.saturday20230520
                  ._substitute_operating_day_by_line_types.saturday20230520;
              const modifiedSubstituteDataset = {
                _substitute_operating_periods: {
                  saturday20230520: {
                    _substitute_operating_day_by_line_types: {
                      saturday20230520: {
                        ...saturdaySubstitute,
                        substitute_day_of_week: DayOfWeek.Friday,
                        end_time: Duration.fromISO('PT9H'),
                      },
                    },
                  },
                },
              };
              const mergedDataset = mergeTimetablesDatasets([
                defaultTimetablesDataset,
                modifiedSubstituteDataset,
              ]);
              const builtDataset = buildHslTimetablesDataset(mergedDataset);
              const vehicleScheduleFrames =
                builtDataset._vehicle_schedule_frames;
              const winter2022MonFriVehicleJourneys =
                builtDataset._vehicle_schedule_frames.winter2022
                  ._vehicle_services.monFri._blocks.block._vehicle_journeys;
              const sundayVehicleJourneys =
                builtDataset._vehicle_schedule_frames.winter2022
                  ._vehicle_services.sun._blocks.block._vehicle_journeys;
              const saturday20230520SubstituteOperatingDay =
                builtDataset._substitute_operating_periods.saturday20230520
                  ._substitute_operating_day_by_line_types.saturday20230520;
              const response = await getVehicleSchedulesOnDate(
                createHslTableData(builtDataset),
                journeyPatternRefsByName.route123Inbound.journey_pattern_id,
                observationDate,
              );

              const mappedResponse = mapVehicleScheduleResponse(response);

              expect(
                // Sort arrays so that the order does not matter
                sortVehicleSchedulesForAssert(mappedResponse),
              ).toEqual(
                sortVehicleSchedulesForAssert([
                  {
                    vehicle_journey_id:
                      winter2022MonFriVehicleJourneys.route123Inbound1
                        .vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFrames.winter2022
                        .vehicle_schedule_frame_id,
                    substitute_operating_day_by_line_type_id: null,
                    priority: TimetablePriority.Standard,
                    day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                  },
                  {
                    vehicle_journey_id:
                      winter2022MonFriVehicleJourneys.route123Inbound2
                        .vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFrames.winter2022
                        .vehicle_schedule_frame_id,
                    substitute_operating_day_by_line_type_id: null,
                    priority: TimetablePriority.Standard,
                    day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                  },
                  {
                    vehicle_journey_id:
                      winter2022MonFriVehicleJourneys.route123Inbound3
                        .vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFrames.winter2022
                        .vehicle_schedule_frame_id,
                    substitute_operating_day_by_line_type_id: null,
                    priority: TimetablePriority.Standard,
                    day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                  },
                  {
                    vehicle_journey_id:
                      winter2022MonFriVehicleJourneys.route123Inbound1
                        .vehicle_journey_id,
                    vehicle_schedule_frame_id: null,
                    substitute_operating_day_by_line_type_id:
                      saturday20230520SubstituteOperatingDay.substitute_operating_day_by_line_type_id,
                    priority:
                      TimetablePriority.SubstituteOperatingDayByLineType,
                    day_type_id: defaultDayTypeIds.SATURDAY,
                  },
                  {
                    vehicle_journey_id:
                      winter2022MonFriVehicleJourneys.route123Inbound2
                        .vehicle_journey_id,
                    vehicle_schedule_frame_id: null,
                    substitute_operating_day_by_line_type_id:
                      saturday20230520SubstituteOperatingDay.substitute_operating_day_by_line_type_id,
                    priority:
                      TimetablePriority.SubstituteOperatingDayByLineType,
                    day_type_id: defaultDayTypeIds.SATURDAY,
                  },
                  {
                    vehicle_journey_id:
                      sundayVehicleJourneys.route123Inbound.vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFrames.winter2022
                        .vehicle_schedule_frame_id,
                    substitute_operating_day_by_line_type_id: null,
                    priority: TimetablePriority.Standard,
                    day_type_id: defaultDayTypeIds.SUNDAY,
                  },
                ]),
              );
            });
          });

          describe('begin_time is after first and end_time is before the last departure of target day (Fri)', () => {
            it('should leave out the first and last target days (Fri) departure for substitute day (Sat)', async () => {
              const observationDate = DateTime.fromISO('2023-05-20');
              const saturdaySubstitute =
                stoppingBusServiceSubstitutesSaturday20230520Dataset
                  ._substitute_operating_periods.saturday20230520
                  ._substitute_operating_day_by_line_types.saturday20230520;
              const modifiedSubstituteDataset = {
                _substitute_operating_periods: {
                  saturday20230520: {
                    _substitute_operating_day_by_line_types: {
                      saturday20230520: {
                        ...saturdaySubstitute,
                        substitute_day_of_week: DayOfWeek.Friday,
                        begin_time: Duration.fromISO('PT8H'),
                        end_time: Duration.fromISO('PT9H'),
                      },
                    },
                  },
                },
              };
              const mergedDataset = mergeTimetablesDatasets([
                defaultTimetablesDataset,
                modifiedSubstituteDataset,
              ]);
              const builtDataset = buildHslTimetablesDataset(mergedDataset);
              const vehicleScheduleFrames =
                builtDataset._vehicle_schedule_frames;
              const winter2022MonFriVehicleJourneys =
                builtDataset._vehicle_schedule_frames.winter2022
                  ._vehicle_services.monFri._blocks.block._vehicle_journeys;
              const sundayVehicleJourneys =
                builtDataset._vehicle_schedule_frames.winter2022
                  ._vehicle_services.sun._blocks.block._vehicle_journeys;
              const saturday20230520SubstituteOperatingDay =
                builtDataset._substitute_operating_periods.saturday20230520
                  ._substitute_operating_day_by_line_types.saturday20230520;
              const response = await getVehicleSchedulesOnDate(
                createHslTableData(builtDataset),
                journeyPatternRefsByName.route123Inbound.journey_pattern_id,
                observationDate,
              );

              const mappedResponse = mapVehicleScheduleResponse(response);

              expect(
                // Sort arrays so that the order does not matter
                sortVehicleSchedulesForAssert(mappedResponse),
              ).toEqual(
                sortVehicleSchedulesForAssert([
                  {
                    vehicle_journey_id:
                      winter2022MonFriVehicleJourneys.route123Inbound1
                        .vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFrames.winter2022
                        .vehicle_schedule_frame_id,
                    substitute_operating_day_by_line_type_id: null,
                    priority: TimetablePriority.Standard,
                    day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                  },
                  {
                    vehicle_journey_id:
                      winter2022MonFriVehicleJourneys.route123Inbound2
                        .vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFrames.winter2022
                        .vehicle_schedule_frame_id,
                    substitute_operating_day_by_line_type_id: null,
                    priority: TimetablePriority.Standard,
                    day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                  },
                  {
                    vehicle_journey_id:
                      winter2022MonFriVehicleJourneys.route123Inbound3
                        .vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFrames.winter2022
                        .vehicle_schedule_frame_id,
                    substitute_operating_day_by_line_type_id: null,
                    priority: TimetablePriority.Standard,
                    day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                  },
                  {
                    vehicle_journey_id:
                      winter2022MonFriVehicleJourneys.route123Inbound2
                        .vehicle_journey_id,
                    vehicle_schedule_frame_id: null,
                    substitute_operating_day_by_line_type_id:
                      saturday20230520SubstituteOperatingDay.substitute_operating_day_by_line_type_id,
                    priority:
                      TimetablePriority.SubstituteOperatingDayByLineType,
                    day_type_id: defaultDayTypeIds.SATURDAY,
                  },
                  {
                    vehicle_journey_id:
                      sundayVehicleJourneys.route123Inbound.vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFrames.winter2022
                        .vehicle_schedule_frame_id,
                    substitute_operating_day_by_line_type_id: null,
                    priority: TimetablePriority.Standard,
                    day_type_id: defaultDayTypeIds.SUNDAY,
                  },
                ]),
              );
            });
          });
        });
      });
    });
  });
});
