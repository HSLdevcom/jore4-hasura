import * as config from '@config';
import { DbConnection, closeDbConnection, createDbConnection } from '@util/db';
import { queryTable } from '@util/setup';
import { hslTimetablesDbSchema } from 'hsl/timetablesdb/datasets/schema';
import * as testDatasetJson from './example.json';
import { insertDatasetFromJson } from './json-parser';
import {
  HslTimetablesDatasetOutput,
  HslVehicleScheduleFrameOutput,
  SubstituteOperatingDayByLineTypeOutput,
} from './types';

describe('HSL timetables data inserter json parser', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(config.timetablesDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  const insertTestDataset = () => {
    return insertDatasetFromJson(JSON.stringify(testDatasetJson));
  };

  it('should return the built dataset', async () => {
    const result: HslTimetablesDatasetOutput = await insertTestDataset();
    expect(result).toBeTruthy();

    // Just check that there's nothing extra here. Each model is checked in a separate tests.
    // If this fails because of new properties being added, new tests for those should probably be created as well.
    expect(Object.keys(result).sort()).toEqual(
      [
        '_vehicle_schedule_frames',
        '_journey_pattern_refs',
        '_substitute_operating_periods',
      ].sort(),
    );
  });

  describe('tables', () => {
    // Note: only testing additions over generic schema here.

    describe('vehicle schedule frame', () => {
      let builtDataset: HslTimetablesDatasetOutput;
      let builtVehicleScheduleFrame: HslVehicleScheduleFrameOutput;
      beforeAll(async () => {
        builtDataset = await insertTestDataset();
        builtVehicleScheduleFrame =
          builtDataset._vehicle_schedule_frames.winter2022;
      });

      it('should be built correctly', async () => {
        expect(
          builtVehicleScheduleFrame.vehicle_schedule_frame_id,
        ).toBeValidUuid();
        expect(builtVehicleScheduleFrame.booking_label).toBe(
          'Winter booking label',
        );
      });

      it('should be inserted correctly', async () => {
        const vehicleScheduleFrames = await queryTable(
          dbConnection,
          hslTimetablesDbSchema['vehicle_schedule.vehicle_schedule_frame'],
        );

        expect(vehicleScheduleFrames.rowCount).toBe(1);
        expect(vehicleScheduleFrames.rows[0].vehicle_schedule_frame_id).toBe(
          builtVehicleScheduleFrame.vehicle_schedule_frame_id,
        );

        expect(vehicleScheduleFrames.rows[0].booking_label).toBe(
          builtVehicleScheduleFrame.booking_label,
        );
      });
    });

    // TODO: 'substitute operating period'

    describe('substitute operating day by line type', () => {
      let builtDataset: HslTimetablesDatasetOutput;
      let builtSubstituteOperatingDayByLineType: SubstituteOperatingDayByLineTypeOutput;
      beforeAll(async () => {
        builtDataset = await insertTestDataset();
        builtSubstituteOperatingDayByLineType =
          builtDataset._substitute_operating_periods.aprilFools
            ._substitute_operating_day_by_line_types.aprilFools;
      });

      it('should be built correctly', async () => {
        expect(
          builtSubstituteOperatingDayByLineType.substitute_operating_day_by_line_type_id,
        ).toBeValidUuid();
      });

      it('should be inserted correctly', async () => {
        const vehicleScheduleFrames = await queryTable(
          dbConnection,
          hslTimetablesDbSchema[
            'service_calendar.substitute_operating_day_by_line_type'
          ],
        );

        expect(vehicleScheduleFrames.rowCount).toBe(1);

        expect(
          vehicleScheduleFrames.rows[0]
            .substitute_operating_day_by_line_type_id,
        ).toBe(
          builtSubstituteOperatingDayByLineType.substitute_operating_day_by_line_type_id,
        );
      });
    });
  });
});
