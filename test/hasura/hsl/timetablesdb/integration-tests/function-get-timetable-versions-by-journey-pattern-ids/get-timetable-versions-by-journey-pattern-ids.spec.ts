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
  stoppingBusServiceSaturday20230520Dataset,
  stoppingBusServiceSaturday20230520SubstituteOperatingDayByLineType,
  temporarySatApril2023Dataset,
  temporarySatApril2023VehicleScheduleFrame,
} from 'hsl/timetablesdb/datasets/additional-sets';
import {
  defaultHslTimetablesDbData,
  hslVehicleScheduleFramesByName,
  substituteOperatingDayByLineTypesByName,
} from 'hsl/timetablesdb/datasets/defaultSetup';
import { HslTimetablesDbTables } from 'hsl/timetablesdb/datasets/schema';
import { TimetableVersion } from 'hsl/timetablesdb/datasets/types';
import sortBy from 'lodash/sortBy';
import { DateTime } from 'luxon';

const sortVersionsForAssert = (
  data: {
    vehicle_schedule_frame_id: UUID | null;
    day_type_id: UUID;
    in_effect: boolean;
    substitute_operating_day_by_line_type_id: UUID | null;
  }[],
) =>
  sortBy(data, [
    'vehicle_schedule_frame_id',
    'day_type_id',
    'in_effect',
    'substitute_operating_day_by_line_type_id',
  ]);

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
      `SELECT * FROM vehicle_service.get_timetable_versions_by_journey_pattern_ids('{${journeyPatternIds}}'::uuid[], '${startDate.toISODate()}'::date, '${endDate.toISODate()}'::date, '${observationDate.toISODate()}'::date)`,
    );

    return response.rows;
  };

  it('should have empty result from timerange where no timetables are valid', async () => {
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

  it('should only have standard priorities in effect in May', async () => {
    const startDate = DateTime.fromISO('2023-05-01');
    const endDate = DateTime.fromISO('2023-05-31');
    const observationDate = DateTime.fromISO('2023-05-01');

    const response = await getTimetableVersions(
      getDbDataWithAdditionalDatasets({
        datasets: [stoppingBusServiceSaturday20230520Dataset],
      }),
      [journeyPatternRefsByName.route123Inbound.journey_pattern_id],
      startDate,
      endDate,
      observationDate,
    );
    const mappedResponse = response.map((version) => ({
      vehicle_schedule_frame_id: version.vehicle_schedule_frame_id,
      substitute_operating_day_by_line_type_id:
        version.substitute_operating_day_by_line_type_id,
      day_type_id: version.day_type_id,
      in_effect: version.in_effect,
    }));

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
          vehicle_schedule_frame_id:
            vehicleScheduleFramesByName.winter2022.vehicle_schedule_frame_id,
          substitute_operating_day_by_line_type_id: null,
          day_type_id: defaultDayTypeIds.SATURDAY,
          in_effect: true,
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
            hslVehicleScheduleFramesByName.specialAscensionDay2023
              .vehicle_schedule_frame_id,
          substitute_operating_day_by_line_type_id: null,
          day_type_id: defaultDayTypeIds.THURSDAY,
          in_effect: false,
        },
      ]),
    );
  });

  it('should have standard priorities and also 18.5.2023 special day in effect in May', async () => {
    const startDate = DateTime.fromISO('2023-05-01');
    const endDate = DateTime.fromISO('2023-05-31');
    const observationDate = DateTime.fromISO('2023-05-18');

    const response = await getTimetableVersions(
      getDbDataWithAdditionalDatasets({
        datasets: [stoppingBusServiceSaturday20230520Dataset],
      }),
      [journeyPatternRefsByName.route123Inbound.journey_pattern_id],
      startDate,
      endDate,
      observationDate,
    );
    const mappedResponse = response.map((version) => ({
      vehicle_schedule_frame_id: version.vehicle_schedule_frame_id,
      substitute_operating_day_by_line_type_id:
        version.substitute_operating_day_by_line_type_id,
      day_type_id: version.day_type_id,
      in_effect: version.in_effect,
    }));

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
          vehicle_schedule_frame_id:
            vehicleScheduleFramesByName.winter2022.vehicle_schedule_frame_id,
          substitute_operating_day_by_line_type_id: null,
          day_type_id: defaultDayTypeIds.SATURDAY,
          in_effect: true,
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
            hslVehicleScheduleFramesByName.specialAscensionDay2023
              .vehicle_schedule_frame_id,
          substitute_operating_day_by_line_type_id: null,
          day_type_id: defaultDayTypeIds.THURSDAY,
          in_effect: true,
        },
      ]),
    );
  });

  it('should have substitute operating day in effect instead of Saturdays standard priority', async () => {
    const startDate = DateTime.fromISO('2023-05-01');
    const endDate = DateTime.fromISO('2023-05-31');
    const observationDate = DateTime.fromISO('2023-05-20');

    const response = await getTimetableVersions(
      getDbDataWithAdditionalDatasets({
        datasets: [stoppingBusServiceSaturday20230520Dataset],
      }),
      [journeyPatternRefsByName.route123Inbound.journey_pattern_id],
      startDate,
      endDate,
      observationDate,
    );

    const mappedResponse = response.map((version) => ({
      vehicle_schedule_frame_id: version.vehicle_schedule_frame_id,
      substitute_operating_day_by_line_type_id:
        version.substitute_operating_day_by_line_type_id,
      day_type_id: version.day_type_id,
      in_effect: version.in_effect,
    }));

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
          in_effect: true,
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
            hslVehicleScheduleFramesByName.specialAscensionDay2023
              .vehicle_schedule_frame_id,
          substitute_operating_day_by_line_type_id: null,
          day_type_id: defaultDayTypeIds.THURSDAY,
          in_effect: false,
        },
      ]),
    );
  });

  it('should not include or be affected by Express Bus substitute operating day', async () => {
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

    const mappedResponse = response.map((version) => ({
      vehicle_schedule_frame_id: version.vehicle_schedule_frame_id,
      substitute_operating_day_by_line_type_id:
        version.substitute_operating_day_by_line_type_id,
      day_type_id: version.day_type_id,
      in_effect: version.in_effect,
    }));

    expect(
      // Sort arrays so that the order does not matter
      sortVersionsForAssert(mappedResponse),
    ).toEqual(
      sortVersionsForAssert([
        {
          vehicle_schedule_frame_id:
            vehicleScheduleFramesByName.winter2022.vehicle_schedule_frame_id,
          substitute_operating_day_by_line_type_id: null,
          day_type_id: defaultDayTypeIds.SATURDAY,
          in_effect: true,
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
            hslVehicleScheduleFramesByName.specialAscensionDay2023
              .vehicle_schedule_frame_id,
          substitute_operating_day_by_line_type_id: null,
          day_type_id: defaultDayTypeIds.THURSDAY,
          in_effect: false,
        },
      ]),
    );
  });

  it('should have temporary priority in effect instead of standard on Saturday', async () => {
    const startDate = DateTime.fromISO('2023-04-01');
    const endDate = DateTime.fromISO('2023-04-30');
    const observationDate = DateTime.fromISO('2023-04-08');

    const response = await getTimetableVersions(
      getDbDataWithAdditionalDatasets({
        datasets: [temporarySatApril2023Dataset],
      }),
      [journeyPatternRefsByName.route123Inbound.journey_pattern_id],
      startDate,
      endDate,
      observationDate,
    );

    const mappedResponse = response.map((version) => ({
      vehicle_schedule_frame_id: version.vehicle_schedule_frame_id,
      substitute_operating_day_by_line_type_id:
        version.substitute_operating_day_by_line_type_id,
      day_type_id: version.day_type_id,
      in_effect: version.in_effect,
    }));

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
            temporarySatApril2023VehicleScheduleFrame.vehicle_schedule_frame_id,
          substitute_operating_day_by_line_type_id: null,
          day_type_id: defaultDayTypeIds.SATURDAY,
          in_effect: true,
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
          in_effect: true,
        },
        {
          vehicle_schedule_frame_id:
            vehicleScheduleFramesByName.winter2022.vehicle_schedule_frame_id,
          substitute_operating_day_by_line_type_id: null,
          day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
          in_effect: true,
        },
      ]),
    );
  });

  it('should have only special day in effect, when we have valid standard, temporary, substitute and special day on the same day', async () => {
    const startDate = DateTime.fromISO('2023-04-01');
    const endDate = DateTime.fromISO('2023-04-01');
    const observationDate = DateTime.fromISO('2023-04-01');

    const response = await getTimetableVersions(
      getDbDataWithAdditionalDatasets({
        datasets: [temporarySatApril2023Dataset, specialAprilFools2023Dataset],
      }),
      [journeyPatternRefsByName.route123Inbound.journey_pattern_id],
      startDate,
      endDate,
      observationDate,
    );

    const mappedResponse = response.map((version) => ({
      vehicle_schedule_frame_id: version.vehicle_schedule_frame_id,
      substitute_operating_day_by_line_type_id:
        version.substitute_operating_day_by_line_type_id,
      day_type_id: version.day_type_id,
      in_effect: version.in_effect,
    }));

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
            temporarySatApril2023VehicleScheduleFrame.vehicle_schedule_frame_id,
          substitute_operating_day_by_line_type_id: null,
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
        {
          vehicle_schedule_frame_id:
            vehicleScheduleFramesByName.winter2022.vehicle_schedule_frame_id,
          substitute_operating_day_by_line_type_id: null,
          day_type_id: defaultDayTypeIds.SATURDAY,
          in_effect: false,
        },
      ]),
    );
  });

  it('should not be affected by draft', async () => {
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

    const mappedResponse = response.map((version) => ({
      vehicle_schedule_frame_id: version.vehicle_schedule_frame_id,
      substitute_operating_day_by_line_type_id:
        version.substitute_operating_day_by_line_type_id,
      day_type_id: version.day_type_id,
      in_effect: version.in_effect,
    }));

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
            draftSunApril2023VehicleScheduleFrame.vehicle_schedule_frame_id,
          substitute_operating_day_by_line_type_id: null,
          day_type_id: defaultDayTypeIds.SUNDAY,
          in_effect: false,
        },
        {
          vehicle_schedule_frame_id:
            vehicleScheduleFramesByName.winter2022.vehicle_schedule_frame_id,
          substitute_operating_day_by_line_type_id: null,
          day_type_id: defaultDayTypeIds.SATURDAY,
          in_effect: true,
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

    const mappedResponse = response.map((version) => ({
      vehicle_schedule_frame_id: version.vehicle_schedule_frame_id,
      substitute_operating_day_by_line_type_id:
        version.substitute_operating_day_by_line_type_id,
      day_type_id: version.day_type_id,
      in_effect: version.in_effect,
    }));

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
