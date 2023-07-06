import * as config from '@config';
import * as db from '@util/db';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import { setupDb } from '@util/setup';
import {
  defaultDayTypeIds,
  journeyPatternRefsByName,
  vehicleJourneysByName,
  vehicleScheduleFramesByName,
} from 'generic/timetablesdb/datasets/defaultSetup';
import { TimetablePriority } from 'generic/timetablesdb/datasets/types';
import {
  draftSunApril2023Dataset,
  getDbDataWithAdditionalDatasets,
  specialAprilFools2023Dataset,
  specialAprilFools2023VehicleJourneysByName,
  specialAprilFools2023VehicleScheduleFrame,
  stagingSunApril2024Dataset,
  stoppingBusServiceSaturday20230520Dataset,
  stoppingBusServiceSaturday20230520SubstituteOperatingDayByLineType,
  temporarySatFirstHalfApril2023Dataset,
  temporarySatFirstHalfApril2023VehicleJourneysByName,
  temporarySatFirstHalfApril2023VehicleScheduleFrame,
} from 'hsl/timetablesdb/datasets/additional-sets';
import {
  stoppingBusServiceSaturday20230406Dataset,
  stoppingBusServiceThursday20230406SubstituteOperatingDayByLineType,
} from 'hsl/timetablesdb/datasets/additional-sets/substitute-operating-days-by-line-types/stoppingBusServiceThursday20230406';
import {
  hslVehicleScheduleFramesByName,
  substituteOperatingDayByLineTypesByName,
} from 'hsl/timetablesdb/datasets/defaultSetup';
import { hslVehicleJourneysByName } from 'hsl/timetablesdb/datasets/defaultSetup/vehicle-journeys';
import { HslTimetablesDbTables } from 'hsl/timetablesdb/datasets/schema';
import { DayOfWeek, VehicleSchedule } from 'hsl/timetablesdb/datasets/types';
import {
  mapVehicleScheduleResponse,
  sortVehicleSchedulesForAssert,
} from 'hsl/timetablesdb/test-utils';
import { DateTime } from 'luxon';

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
          const response = await getVehicleSchedulesOnDate(
            getDbDataWithAdditionalDatasets({
              datasets: [
                temporarySatFirstHalfApril2023Dataset,
                specialAprilFools2023Dataset,
              ],
            }),
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
                  vehicleJourneysByName.v1MonFriJourney2.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFramesByName.winter2022
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  vehicleJourneysByName.v1MonFriJourney4.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFramesByName.winter2022
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  vehicleJourneysByName.v1MonFriJourney6.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFramesByName.winter2022
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  hslVehicleJourneysByName.v1SatJourney1.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFramesByName.winter2022
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.SATURDAY,
              },
              {
                vehicle_journey_id:
                  hslVehicleJourneysByName.v1SunJourney1.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFramesByName.winter2022
                    .vehicle_schedule_frame_id,
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
          const response = await getVehicleSchedulesOnDate(
            getDbDataWithAdditionalDatasets({
              datasets: [
                temporarySatFirstHalfApril2023Dataset,
                specialAprilFools2023Dataset,
              ],
            }),
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
                  vehicleJourneysByName.v1MonFriJourney2.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFramesByName.winter2022
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  vehicleJourneysByName.v1MonFriJourney4.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFramesByName.winter2022
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  vehicleJourneysByName.v1MonFriJourney6.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFramesByName.winter2022
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  temporarySatFirstHalfApril2023VehicleJourneysByName.v1journey1
                    .vehicle_journey_id,
                vehicle_schedule_frame_id:
                  temporarySatFirstHalfApril2023VehicleScheduleFrame.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Temporary,
                day_type_id: defaultDayTypeIds.SATURDAY,
              },
              {
                vehicle_journey_id:
                  hslVehicleJourneysByName.v1SunJourney1.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFramesByName.winter2022
                    .vehicle_schedule_frame_id,
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
          const response = await getVehicleSchedulesOnDate(
            getDbDataWithAdditionalDatasets({
              datasets: [
                temporarySatFirstHalfApril2023Dataset,
                specialAprilFools2023Dataset,
              ],
            }),
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
                  vehicleJourneysByName.v1MonFriJourney2.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFramesByName.winter2022
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  vehicleJourneysByName.v1MonFriJourney4.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFramesByName.winter2022
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  vehicleJourneysByName.v1MonFriJourney6.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFramesByName.winter2022
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  specialAprilFools2023VehicleJourneysByName.v1journey1
                    .vehicle_journey_id,
                vehicle_schedule_frame_id:
                  specialAprilFools2023VehicleScheduleFrame.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Special,
                day_type_id: defaultDayTypeIds.SATURDAY,
              },
              {
                vehicle_journey_id:
                  hslVehicleJourneysByName.v1SunJourney1.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFramesByName.winter2022
                    .vehicle_schedule_frame_id,
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
          const response = await getVehicleSchedulesOnDate(
            getDbDataWithAdditionalDatasets({
              datasets: [
                temporarySatFirstHalfApril2023Dataset,
                specialAprilFools2023Dataset,
              ],
            }),
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
                  vehicleJourneysByName.v1MonFriJourney2.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFramesByName.winter2022
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  vehicleJourneysByName.v1MonFriJourney4.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFramesByName.winter2022
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  vehicleJourneysByName.v1MonFriJourney6.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFramesByName.winter2022
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  hslVehicleJourneysByName.v1AscensionDayJourney1
                    .vehicle_journey_id,
                vehicle_schedule_frame_id:
                  hslVehicleScheduleFramesByName.specialAscensionDay2023
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Special,
                day_type_id: defaultDayTypeIds.THURSDAY,
              },
              {
                vehicle_journey_id:
                  hslVehicleJourneysByName.v1SatJourney1.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFramesByName.winter2022
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.SATURDAY,
              },
              {
                vehicle_journey_id:
                  hslVehicleJourneysByName.v1SunJourney1.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFramesByName.winter2022
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

    describe('dataset has standard, draft and staging priorities', () => {
      describe('draft and standard priorities are valid on observation date', () => {
        it('should not include draft priorities in the result set', async () => {
          const observationDate = DateTime.fromISO('2023-04-02');
          const response = await getVehicleSchedulesOnDate(
            getDbDataWithAdditionalDatasets({
              datasets: [draftSunApril2023Dataset, stagingSunApril2024Dataset],
            }),
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
                  vehicleJourneysByName.v1MonFriJourney2.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFramesByName.winter2022
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  vehicleJourneysByName.v1MonFriJourney4.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFramesByName.winter2022
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  vehicleJourneysByName.v1MonFriJourney6.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFramesByName.winter2022
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  hslVehicleJourneysByName.v1SatJourney1.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFramesByName.winter2022
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.SATURDAY,
              },
              {
                vehicle_journey_id:
                  hslVehicleJourneysByName.v1SunJourney1.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFramesByName.winter2022
                    .vehicle_schedule_frame_id,
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
          const response = await getVehicleSchedulesOnDate(
            getDbDataWithAdditionalDatasets({
              datasets: [draftSunApril2023Dataset, stagingSunApril2024Dataset],
            }),
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
          const response = await getVehicleSchedulesOnDate(
            getDbDataWithAdditionalDatasets({
              datasets: [temporarySatFirstHalfApril2023Dataset],
            }),
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
                  vehicleJourneysByName.v1MonFriJourney2.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFramesByName.winter2022
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  vehicleJourneysByName.v1MonFriJourney4.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFramesByName.winter2022
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  vehicleJourneysByName.v1MonFriJourney6.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFramesByName.winter2022
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  vehicleJourneysByName.v1MonFriJourney2.vehicle_journey_id,
                vehicle_schedule_frame_id: null,
                substitute_operating_day_by_line_type_id:
                  substituteOperatingDayByLineTypesByName.aprilFools
                    .substitute_operating_day_by_line_type_id,
                priority: TimetablePriority.SubstituteOperatingDayByLineType,
                day_type_id: defaultDayTypeIds.SATURDAY,
              },
              {
                vehicle_journey_id:
                  vehicleJourneysByName.v1MonFriJourney4.vehicle_journey_id,
                vehicle_schedule_frame_id: null,
                substitute_operating_day_by_line_type_id:
                  substituteOperatingDayByLineTypesByName.aprilFools
                    .substitute_operating_day_by_line_type_id,
                priority: TimetablePriority.SubstituteOperatingDayByLineType,
                day_type_id: defaultDayTypeIds.SATURDAY,
              },
              {
                vehicle_journey_id:
                  vehicleJourneysByName.v1MonFriJourney6.vehicle_journey_id,
                vehicle_schedule_frame_id: null,
                substitute_operating_day_by_line_type_id:
                  substituteOperatingDayByLineTypesByName.aprilFools
                    .substitute_operating_day_by_line_type_id,
                priority: TimetablePriority.SubstituteOperatingDayByLineType,
                day_type_id: defaultDayTypeIds.SATURDAY,
              },
              {
                vehicle_journey_id:
                  hslVehicleJourneysByName.v1SunJourney1.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFramesByName.winter2022
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

    describe('dataset has priorities: standard(Mon-Fri, Sat, Sun), substitute(Thu (operated like Sunday))', () => {
      describe('standard, temporary and substitute are valid on observation date', () => {
        it('should have all standard priority vehicle_schedules and also substitute for Thursday(same vj_id as Sunday)', async () => {
          const observationDate = DateTime.fromISO('2023-04-06');
          const response = await getVehicleSchedulesOnDate(
            getDbDataWithAdditionalDatasets({
              datasets: [stoppingBusServiceSaturday20230406Dataset],
            }),
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
                  vehicleJourneysByName.v1MonFriJourney2.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFramesByName.winter2022
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  vehicleJourneysByName.v1MonFriJourney4.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFramesByName.winter2022
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  vehicleJourneysByName.v1MonFriJourney6.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFramesByName.winter2022
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  hslVehicleJourneysByName.v1SunJourney1.vehicle_journey_id,
                vehicle_schedule_frame_id: null,
                substitute_operating_day_by_line_type_id:
                  stoppingBusServiceThursday20230406SubstituteOperatingDayByLineType.substitute_operating_day_by_line_type_id,
                priority: TimetablePriority.SubstituteOperatingDayByLineType,
                day_type_id: defaultDayTypeIds.THURSDAY,
              },
              {
                vehicle_journey_id:
                  hslVehicleJourneysByName.v1SatJourney1.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFramesByName.winter2022
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.SATURDAY,
              },
              {
                vehicle_journey_id:
                  hslVehicleJourneysByName.v1SunJourney1.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFramesByName.winter2022
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

    describe('dataset has priorities: standard(Mon-Fri, Sat, Sun), temporary, special and substitute (Sat (operated like Friday))', () => {
      describe('standard, temporary, special and substitute are valid on observation date', () => {
        it('should return standard priority (Mon-Fri, Sun) and special (Sat) vehicle schedules', async () => {
          const observationDate = DateTime.fromISO('2023-04-01');
          const response = await getVehicleSchedulesOnDate(
            getDbDataWithAdditionalDatasets({
              datasets: [
                temporarySatFirstHalfApril2023Dataset,
                specialAprilFools2023Dataset,
              ],
            }),
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
                  vehicleJourneysByName.v1MonFriJourney2.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFramesByName.winter2022
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  vehicleJourneysByName.v1MonFriJourney4.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFramesByName.winter2022
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  vehicleJourneysByName.v1MonFriJourney6.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFramesByName.winter2022
                    .vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Standard,
                day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              },
              {
                vehicle_journey_id:
                  specialAprilFools2023VehicleJourneysByName.v1journey1
                    .vehicle_journey_id,
                vehicle_schedule_frame_id:
                  specialAprilFools2023VehicleScheduleFrame.vehicle_schedule_frame_id,
                substitute_operating_day_by_line_type_id: null,
                priority: TimetablePriority.Special,
                day_type_id: defaultDayTypeIds.SATURDAY,
              },
              {
                vehicle_journey_id:
                  hslVehicleJourneysByName.v1SunJourney1.vehicle_journey_id,
                vehicle_schedule_frame_id:
                  vehicleScheduleFramesByName.winter2022
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

    describe('dataset has priorities Standard (Mon-Fri, Sat, Sun) and substitute day (Sat)', () => {
      describe('standard and susbstitute day are valid on observation date', () => {
        describe('substitute day is no-operation day (substitute_day_of_week is null)', () => {
          it('should have the generated no-operating row for substitute day (Sat)', async () => {
            const observationDate = DateTime.fromISO('2023-05-20');
            const response = await getVehicleSchedulesOnDate(
              getDbDataWithAdditionalDatasets({
                datasets: [stoppingBusServiceSaturday20230520Dataset],
              }),
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
                    vehicleJourneysByName.v1MonFriJourney2.vehicle_journey_id,
                  vehicle_schedule_frame_id:
                    vehicleScheduleFramesByName.winter2022
                      .vehicle_schedule_frame_id,
                  substitute_operating_day_by_line_type_id: null,
                  priority: TimetablePriority.Standard,
                  day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                },
                {
                  vehicle_journey_id:
                    vehicleJourneysByName.v1MonFriJourney4.vehicle_journey_id,
                  vehicle_schedule_frame_id:
                    vehicleScheduleFramesByName.winter2022
                      .vehicle_schedule_frame_id,
                  substitute_operating_day_by_line_type_id: null,
                  priority: TimetablePriority.Standard,
                  day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                },
                {
                  vehicle_journey_id:
                    vehicleJourneysByName.v1MonFriJourney6.vehicle_journey_id,
                  vehicle_schedule_frame_id:
                    vehicleScheduleFramesByName.winter2022
                      .vehicle_schedule_frame_id,
                  substitute_operating_day_by_line_type_id: null,
                  priority: TimetablePriority.Standard,
                  day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                },
                {
                  vehicle_journey_id: null,
                  vehicle_schedule_frame_id: null,
                  substitute_operating_day_by_line_type_id:
                    stoppingBusServiceSaturday20230520SubstituteOperatingDayByLineType.substitute_operating_day_by_line_type_id,
                  priority: TimetablePriority.SubstituteOperatingDayByLineType,
                  day_type_id: defaultDayTypeIds.SATURDAY,
                },
                {
                  vehicle_journey_id:
                    hslVehicleJourneysByName.v1SunJourney1.vehicle_journey_id,
                  vehicle_schedule_frame_id:
                    vehicleScheduleFramesByName.winter2022
                      .vehicle_schedule_frame_id,
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
              const response = await getVehicleSchedulesOnDate(
                getDbDataWithAdditionalDatasets({
                  datasets: [
                    [
                      {
                        name: 'service_calendar.substitute_operating_day_by_line_type',
                        data: [
                          {
                            ...stoppingBusServiceSaturday20230520SubstituteOperatingDayByLineType,
                            substitute_day_of_week: DayOfWeek.Friday,
                            begin_time: 'PT12H',
                          },
                        ],
                      },
                    ],
                  ],
                }),
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
                      vehicleJourneysByName.v1MonFriJourney2.vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFramesByName.winter2022
                        .vehicle_schedule_frame_id,
                    substitute_operating_day_by_line_type_id: null,
                    priority: TimetablePriority.Standard,
                    day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                  },
                  {
                    vehicle_journey_id:
                      vehicleJourneysByName.v1MonFriJourney4.vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFramesByName.winter2022
                        .vehicle_schedule_frame_id,
                    substitute_operating_day_by_line_type_id: null,
                    priority: TimetablePriority.Standard,
                    day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                  },
                  {
                    vehicle_journey_id:
                      vehicleJourneysByName.v1MonFriJourney6.vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFramesByName.winter2022
                        .vehicle_schedule_frame_id,
                    substitute_operating_day_by_line_type_id: null,
                    priority: TimetablePriority.Standard,
                    day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                  },
                  {
                    vehicle_journey_id: null,
                    vehicle_schedule_frame_id: null,
                    substitute_operating_day_by_line_type_id:
                      stoppingBusServiceSaturday20230520SubstituteOperatingDayByLineType.substitute_operating_day_by_line_type_id,
                    priority:
                      TimetablePriority.SubstituteOperatingDayByLineType,
                    day_type_id: defaultDayTypeIds.SATURDAY,
                  },
                  {
                    vehicle_journey_id:
                      hslVehicleJourneysByName.v1SunJourney1.vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFramesByName.winter2022
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
              const response = await getVehicleSchedulesOnDate(
                getDbDataWithAdditionalDatasets({
                  datasets: [
                    [
                      {
                        name: 'service_calendar.substitute_operating_day_by_line_type',
                        data: [
                          {
                            ...stoppingBusServiceSaturday20230520SubstituteOperatingDayByLineType,
                            substitute_day_of_week: DayOfWeek.Friday,
                            end_time: 'PT06H',
                          },
                        ],
                      },
                    ],
                  ],
                }),
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
                      vehicleJourneysByName.v1MonFriJourney2.vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFramesByName.winter2022
                        .vehicle_schedule_frame_id,
                    substitute_operating_day_by_line_type_id: null,
                    priority: TimetablePriority.Standard,
                    day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                  },
                  {
                    vehicle_journey_id:
                      vehicleJourneysByName.v1MonFriJourney4.vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFramesByName.winter2022
                        .vehicle_schedule_frame_id,
                    substitute_operating_day_by_line_type_id: null,
                    priority: TimetablePriority.Standard,
                    day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                  },
                  {
                    vehicle_journey_id:
                      vehicleJourneysByName.v1MonFriJourney6.vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFramesByName.winter2022
                        .vehicle_schedule_frame_id,
                    substitute_operating_day_by_line_type_id: null,
                    priority: TimetablePriority.Standard,
                    day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                  },
                  {
                    vehicle_journey_id: null,
                    vehicle_schedule_frame_id: null,
                    substitute_operating_day_by_line_type_id:
                      stoppingBusServiceSaturday20230520SubstituteOperatingDayByLineType.substitute_operating_day_by_line_type_id,
                    priority:
                      TimetablePriority.SubstituteOperatingDayByLineType,
                    day_type_id: defaultDayTypeIds.SATURDAY,
                  },
                  {
                    vehicle_journey_id:
                      hslVehicleJourneysByName.v1SunJourney1.vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFramesByName.winter2022
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
              const response = await getVehicleSchedulesOnDate(
                getDbDataWithAdditionalDatasets({
                  datasets: [
                    [
                      {
                        name: 'service_calendar.substitute_operating_day_by_line_type',
                        data: [
                          {
                            ...stoppingBusServiceSaturday20230520SubstituteOperatingDayByLineType,
                            substitute_day_of_week: DayOfWeek.Friday,
                            begin_time: 'PT8H',
                          },
                        ],
                      },
                    ],
                  ],
                }),
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
                      vehicleJourneysByName.v1MonFriJourney2.vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFramesByName.winter2022
                        .vehicle_schedule_frame_id,
                    substitute_operating_day_by_line_type_id: null,
                    priority: TimetablePriority.Standard,
                    day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                  },
                  {
                    vehicle_journey_id:
                      vehicleJourneysByName.v1MonFriJourney4.vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFramesByName.winter2022
                        .vehicle_schedule_frame_id,
                    substitute_operating_day_by_line_type_id: null,
                    priority: TimetablePriority.Standard,
                    day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                  },
                  {
                    vehicle_journey_id:
                      vehicleJourneysByName.v1MonFriJourney6.vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFramesByName.winter2022
                        .vehicle_schedule_frame_id,
                    substitute_operating_day_by_line_type_id: null,
                    priority: TimetablePriority.Standard,
                    day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                  },
                  {
                    vehicle_journey_id:
                      vehicleJourneysByName.v1MonFriJourney4.vehicle_journey_id,
                    vehicle_schedule_frame_id: null,
                    substitute_operating_day_by_line_type_id:
                      stoppingBusServiceSaturday20230520SubstituteOperatingDayByLineType.substitute_operating_day_by_line_type_id,
                    priority:
                      TimetablePriority.SubstituteOperatingDayByLineType,
                    day_type_id: defaultDayTypeIds.SATURDAY,
                  },
                  {
                    vehicle_journey_id:
                      vehicleJourneysByName.v1MonFriJourney6.vehicle_journey_id,
                    vehicle_schedule_frame_id: null,
                    substitute_operating_day_by_line_type_id:
                      stoppingBusServiceSaturday20230520SubstituteOperatingDayByLineType.substitute_operating_day_by_line_type_id,
                    priority:
                      TimetablePriority.SubstituteOperatingDayByLineType,
                    day_type_id: defaultDayTypeIds.SATURDAY,
                  },
                  {
                    vehicle_journey_id:
                      hslVehicleJourneysByName.v1SunJourney1.vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFramesByName.winter2022
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
              const response = await getVehicleSchedulesOnDate(
                getDbDataWithAdditionalDatasets({
                  datasets: [
                    [
                      {
                        name: 'service_calendar.substitute_operating_day_by_line_type',
                        data: [
                          {
                            ...stoppingBusServiceSaturday20230520SubstituteOperatingDayByLineType,
                            substitute_day_of_week: DayOfWeek.Friday,
                            end_time: 'PT9H',
                          },
                        ],
                      },
                    ],
                  ],
                }),
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
                      vehicleJourneysByName.v1MonFriJourney2.vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFramesByName.winter2022
                        .vehicle_schedule_frame_id,
                    substitute_operating_day_by_line_type_id: null,
                    priority: TimetablePriority.Standard,
                    day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                  },
                  {
                    vehicle_journey_id:
                      vehicleJourneysByName.v1MonFriJourney4.vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFramesByName.winter2022
                        .vehicle_schedule_frame_id,
                    substitute_operating_day_by_line_type_id: null,
                    priority: TimetablePriority.Standard,
                    day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                  },
                  {
                    vehicle_journey_id:
                      vehicleJourneysByName.v1MonFriJourney6.vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFramesByName.winter2022
                        .vehicle_schedule_frame_id,
                    substitute_operating_day_by_line_type_id: null,
                    priority: TimetablePriority.Standard,
                    day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                  },
                  {
                    vehicle_journey_id:
                      vehicleJourneysByName.v1MonFriJourney2.vehicle_journey_id,
                    vehicle_schedule_frame_id: null,
                    substitute_operating_day_by_line_type_id:
                      stoppingBusServiceSaturday20230520SubstituteOperatingDayByLineType.substitute_operating_day_by_line_type_id,
                    priority:
                      TimetablePriority.SubstituteOperatingDayByLineType,
                    day_type_id: defaultDayTypeIds.SATURDAY,
                  },
                  {
                    vehicle_journey_id:
                      vehicleJourneysByName.v1MonFriJourney4.vehicle_journey_id,
                    vehicle_schedule_frame_id: null,
                    substitute_operating_day_by_line_type_id:
                      stoppingBusServiceSaturday20230520SubstituteOperatingDayByLineType.substitute_operating_day_by_line_type_id,
                    priority:
                      TimetablePriority.SubstituteOperatingDayByLineType,
                    day_type_id: defaultDayTypeIds.SATURDAY,
                  },
                  {
                    vehicle_journey_id:
                      hslVehicleJourneysByName.v1SunJourney1.vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFramesByName.winter2022
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
              const response = await getVehicleSchedulesOnDate(
                getDbDataWithAdditionalDatasets({
                  datasets: [
                    [
                      {
                        name: 'service_calendar.substitute_operating_day_by_line_type',
                        data: [
                          {
                            ...stoppingBusServiceSaturday20230520SubstituteOperatingDayByLineType,
                            substitute_day_of_week: DayOfWeek.Friday,
                            begin_time: 'PT8H',
                            end_time: 'PT9H',
                          },
                        ],
                      },
                    ],
                  ],
                }),
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
                      vehicleJourneysByName.v1MonFriJourney2.vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFramesByName.winter2022
                        .vehicle_schedule_frame_id,
                    substitute_operating_day_by_line_type_id: null,
                    priority: TimetablePriority.Standard,
                    day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                  },
                  {
                    vehicle_journey_id:
                      vehicleJourneysByName.v1MonFriJourney4.vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFramesByName.winter2022
                        .vehicle_schedule_frame_id,
                    substitute_operating_day_by_line_type_id: null,
                    priority: TimetablePriority.Standard,
                    day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                  },
                  {
                    vehicle_journey_id:
                      vehicleJourneysByName.v1MonFriJourney6.vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFramesByName.winter2022
                        .vehicle_schedule_frame_id,
                    substitute_operating_day_by_line_type_id: null,
                    priority: TimetablePriority.Standard,
                    day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
                  },
                  {
                    vehicle_journey_id:
                      vehicleJourneysByName.v1MonFriJourney4.vehicle_journey_id,
                    vehicle_schedule_frame_id: null,
                    substitute_operating_day_by_line_type_id:
                      stoppingBusServiceSaturday20230520SubstituteOperatingDayByLineType.substitute_operating_day_by_line_type_id,
                    priority:
                      TimetablePriority.SubstituteOperatingDayByLineType,
                    day_type_id: defaultDayTypeIds.SATURDAY,
                  },
                  {
                    vehicle_journey_id:
                      hslVehicleJourneysByName.v1SunJourney1.vehicle_journey_id,
                    vehicle_schedule_frame_id:
                      vehicleScheduleFramesByName.winter2022
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
