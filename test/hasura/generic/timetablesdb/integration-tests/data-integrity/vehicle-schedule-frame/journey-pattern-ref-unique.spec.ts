import { timetablesDbConfig } from '@config';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import * as db from '@util/db';
import { insertTableData, setupDb } from '@util/setup';
import { randomUUID } from 'crypto';
import { defaultGenericTimetablesDbData } from 'generic/timetablesdb/datasets/defaultSetup';
import { defaultDayTypeIds } from 'generic/timetablesdb/datasets/defaultSetup/day-types';
import { journeyPatternRefsByName } from 'generic/timetablesdb/datasets/defaultSetup/journey-pattern-refs';
import { timetabledPassingTimes } from 'generic/timetablesdb/datasets/defaultSetup/passing-times';
import { scheduledStopPointsInJourneyPatternRefByName } from 'generic/timetablesdb/datasets/defaultSetup/stop-points';
import { vehicleJourneysByName } from 'generic/timetablesdb/datasets/defaultSetup/vehicle-journeys';
import { vehicleScheduleFramesByName } from 'generic/timetablesdb/datasets/defaultSetup/vehicle-schedules-frames';
import { vehicleServiceBlocksByName } from 'generic/timetablesdb/datasets/defaultSetup/vehicle-service-blocks';
import { vehicleServicesByName } from 'generic/timetablesdb/datasets/defaultSetup/vehicle-services';
import { GenericTimetablesDbTables } from 'generic/timetablesdb/datasets/schema';
import { cloneDeep, merge, pick } from 'lodash';
import { DateTime } from 'luxon';

describe('Vehicle schedule frame - journey pattern ref uniqueness constraint', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(timetablesDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  beforeEach(async () => setupDb(dbConnection, defaultGenericTimetablesDbData));

  const getBaseDataset = () => {
    // Use an existing vehicle schedule frame (winter 2022) as a base.
    // Clone it and its children, and assign new ids so they can be inserted to DB.
    const frame = vehicleScheduleFramesByName.winter2022;
    const service = vehicleServicesByName.v1MonFri;
    const block = vehicleServiceBlocksByName.v1MonFri;
    const journey = vehicleJourneysByName.v1MonFriJourney1;
    const passingTimes = timetabledPassingTimes.filter(
      (pt) => pt.vehicle_journey_id === journey.vehicle_journey_id,
    );

    const clonedData = cloneDeep({
      frame,
      service,
      block,
      journey,
      passingTimes,
    });

    const ids = {
      frame: { vehicle_schedule_frame_id: randomUUID() },
      service: { vehicle_service_id: randomUUID() },
      block: { block_id: randomUUID() },
      journey: { vehicle_journey_id: randomUUID() },
      passingTimes: passingTimes.map(() => {
        return { timetabled_passing_time_id: randomUUID() };
      }),
    };

    merge(clonedData, {
      frame: { ...ids.frame },
      service: { ...ids.service, ...ids.frame },
      block: { ...ids.block, ...ids.service },
      journey: { ...ids.journey, ...ids.block },
      passingTimes: ids.passingTimes.map((ptId) => {
        return { ...ptId, ...ids.journey };
      }),
    });

    return clonedData;
  };

  const insertDataset = (dataset: ReturnType<typeof getBaseDataset>) => {
    const dbData: TableData<GenericTimetablesDbTables>[] = [
      {
        name: 'vehicle_schedule.vehicle_schedule_frame',
        data: [dataset.frame],
      },
      {
        name: 'vehicle_service.vehicle_service',
        data: [dataset.service],
      },
      {
        name: 'vehicle_service.block',
        data: [dataset.block],
      },
      {
        name: 'vehicle_journey.vehicle_journey',
        data: [dataset.journey],
      },
      {
        name: 'passing_times.timetabled_passing_time',
        data: dataset.passingTimes,
      },
    ];

    return db.getKnex().transaction(
      async (trx) => {
        const result = await insertTableData(dbConnection, dbData, trx);
        // Error expects get very spammy if they fail, with the whole results object. Pick some useful props.
        return result.map((command) => pick(command, 'command', 'rowCount'));
      },
      { connection: dbConnection },
    );
  };

  describe('on inserts', () => {
    it('should fail when existing and new vehicle schedule frame have same priority, journey pattern, day of week and overlapping validity period', async () => {
      const dataset = getBaseDataset();
      await expect(insertDataset(dataset)).rejects.toThrow();
    });

    it('should return properly formatted exception on error', async () => {
      // This test is mostly for verifying that the error message formatting code itself doesn't throw.
      // Migrations and other tests would still pass if it did.

      const dataset = getBaseDataset();
      let error;
      try {
        await insertDataset(dataset);
      } catch (err: unknown) {
        error = err;
      }

      const errorMessage = error?.toString();
      expect(errorMessage).toBeDefined();
      // Something like this, without line breaks:
      //   conflicting schedules detected:
      //   vehicle schedule frame 0e37fdb8-e35e-4d5a-9e5b-88e1b35c0a18 and vehicle schedule frame 792ff598-371b-41dd-8865-3a506f391409,
      //   priority 10, journey_pattern_id 55bab728-c76c-4ce6-9cc6-f6e51c1c5dca, overlapping on [2022-07-01,2023-05-31) on weekday 1
      const validityStart = dataset.frame.validity_start?.toISODate();
      const validityEndClosedUpper = dataset.frame.validity_end
        ?.plus({ days: 1 })
        ?.toISODate();
      const expectedValidityRange = `[${validityStart},${validityEndClosedUpper})`;
      const expectedParts = {
        prefix: 'conflicting schedules detected: ',
        // The order is random, either of these could be defined first.
        frame1: `vehicle schedule frame ${dataset.frame.vehicle_schedule_frame_id}`,
        frame2: `vehicle schedule frame ${vehicleScheduleFramesByName.winter2022.vehicle_schedule_frame_id}`,
        priority: `priority ${dataset.frame.priority}, `,
        journey: `journey_pattern_id ${journeyPatternRefsByName.route123Outbound.journey_pattern_id}, `,
        validity: `overlapping on ${expectedValidityRange}`,
        weekday: /on weekday [1-5]/, // These conflict on multiple days, so weekday could be between 1-5.
      };

      expect(errorMessage).toContain(expectedParts.prefix);
      expect(errorMessage).toContain(expectedParts.frame1);
      expect(errorMessage).toContain(expectedParts.frame2);
      expect(errorMessage).toContain(expectedParts.priority);
      expect(errorMessage).toContain(expectedParts.journey);
      expect(errorMessage).toContain(expectedParts.validity);
      expect(errorMessage).toMatch(expectedParts.weekday);
    });

    describe('priority checks', () => {
      it('should succeed when priorities are different', async () => {
        const dataset = getBaseDataset();
        dataset.frame.priority += 5;

        await expect(insertDataset(dataset)).resolves.not.toThrow();
      });
    });

    describe('validity period checks', () => {
      it('should succeed when validity periods do not overlap', async () => {
        const dataset = getBaseDataset();
        // A sanity check: these tests need to be updated in case the base data is modified.
        expect(dataset.frame.validity_start?.toISODate()).toEqual('2022-07-01');
        expect(dataset.frame.validity_end?.toISODate()).toEqual('2023-05-31');

        dataset.frame.validity_start = dataset.frame.validity_end!.plus({
          days: 1,
        });
        dataset.frame.validity_end = DateTime.fromISO('2023-12-31');

        await expect(insertDataset(dataset)).resolves.not.toThrow();
      });

      it('should fail when validity periods overlap partially', async () => {
        const dataset = getBaseDataset();
        dataset.frame.validity_start = DateTime.fromISO('2023-01-01');
        dataset.frame.validity_end = DateTime.fromISO('2023-12-31');

        await expect(insertDataset(dataset)).rejects.toThrow();
      });

      // No sense going through all possible combinations, that would basically be just testing PostgreSQL OVERLAPS operator.
      // But this is an important corner case since it requires different behavior date ranges in PostgreSQL have by default:
      // validity_end is exclusive = date range is NOT half open.
      it("should fail when validity periods overlap: validity_end same as another's validity_start", async () => {
        const dataset = getBaseDataset();
        dataset.frame.validity_start = dataset.frame.validity_end;
        dataset.frame.validity_end = dataset.frame.validity_end!.plus({
          months: 2,
        });

        await expect(insertDataset(dataset)).rejects.toThrow();
      });
    });

    describe('day of week checks', () => {
      it('should succeed when there are no vehicle services for same day of week between frames', async () => {
        const dataset = getBaseDataset();
        dataset.service.day_type_id = defaultDayTypeIds.SATURDAY;

        await expect(insertDataset(dataset)).resolves.not.toThrow();
      });

      it('should fail when there are vehicle services for same days of week between frames, even if one is defined by compound day type', async () => {
        const dataset = getBaseDataset();
        expect(dataset.service.day_type_id).toBe(
          defaultDayTypeIds.MONDAY_FRIDAY,
        );
        dataset.service.day_type_id = defaultDayTypeIds.WEDNESDAY;

        await expect(insertDataset(dataset)).rejects.toThrow();
      });
    });

    describe('journey pattern checks', () => {
      it('should succeed when frames do not use any common journey patters between them', async () => {
        const dataset = getBaseDataset();

        const newJourneyPatternRefId =
          journeyPatternRefsByName.route234Outbound.journey_pattern_ref_id;
        dataset.journey.journey_pattern_ref_id = newJourneyPatternRefId;

        // The stops need to be from same journey pattern as well, to not break other constraints.
        const newStops = [
          scheduledStopPointsInJourneyPatternRefByName.route234OutboundStop1,
          scheduledStopPointsInJourneyPatternRefByName.route234OutboundStop2,
        ];
        dataset.passingTimes = [
          {
            ...dataset.passingTimes[0],
            scheduled_stop_point_in_journey_pattern_ref_id:
              newStops[0].scheduled_stop_point_in_journey_pattern_ref_id,
          },
          {
            ...dataset.passingTimes[3], // Last stop.
            scheduled_stop_point_in_journey_pattern_ref_id:
              newStops[1].scheduled_stop_point_in_journey_pattern_ref_id,
          },
        ];

        await expect(insertDataset(dataset)).resolves.not.toThrow();
      });
    });
  });
});
