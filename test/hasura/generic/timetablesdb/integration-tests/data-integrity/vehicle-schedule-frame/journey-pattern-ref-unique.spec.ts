import { timetablesDbConfig } from '@config';
import {
  closeDbConnection,
  createDbConnection,
  DbConnection,
  getKnex,
} from '@util/db';
import { addMutationWrapper, postQuery } from '@util/graphql';
import { expectErrorResponse, expectNoErrorResponse } from '@util/response';
import { insertTableData, setupDb } from '@util/setup';
import { randomUUID } from 'crypto';
import {
  defaultDayTypeIds,
  defaultGenericTimetablesDbData,
  journeyPatternRefsByName,
  scheduledStopPointsInJourneyPatternRefByName,
  timetabledPassingTimes,
  vehicleJourneysByName,
  vehicleScheduleFramesByName,
  vehicleServiceBlocksByName,
  vehicleServicesByName,
} from 'generic/timetablesdb/datasets/defaultSetup';
import { GenericTimetablesDbTables } from 'generic/timetablesdb/datasets/schema';
import { TimetablePriority } from 'generic/timetablesdb/datasets/types';
import {
  buildUpdateBlockMutation,
  buildUpdateJourneyPatternRefMutation,
  buildUpdateVehicleJourneyMutation,
  buildUpdateVehicleScheduleFrameMutation,
  buildUpdateVehicleServiceMutation,
} from 'generic/timetablesdb/mutations';
import { cloneDeep, merge, pick } from 'lodash';
import { DateTime } from 'luxon';

describe('Vehicle schedule frame - journey pattern ref uniqueness constraint', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(timetablesDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  beforeEach(async () => setupDb(dbConnection, defaultGenericTimetablesDbData));

  const cloneBaseDataset = () => {
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

  const insertDataset = (dataset: ReturnType<typeof cloneBaseDataset>) => {
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

    return getKnex().transaction(
      async (trx) => {
        const result = await insertTableData(trx, dbData);
        // Error expects get very spammy if they fail, with the whole results object. Pick some useful props.
        return result.map((command) => pick(command, 'command', 'rowCount'));
      },
      { connection: dbConnection },
    );
  };

  const useRoute234StopPoints = (
    dataset: ReturnType<typeof cloneBaseDataset>,
  ) => {
    // The stops need to be from same journey pattern as well, not to break other constraints.
    const newStops = [
      scheduledStopPointsInJourneyPatternRefByName.route234OutboundStop1,
      scheduledStopPointsInJourneyPatternRefByName.route234OutboundStop2,
    ];

    const newStopPoints = [
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

    dataset.passingTimes.length = 0; // eslint-disable-line no-param-reassign
    dataset.passingTimes.push(...newStopPoints);
  };

  const setBaseDatasetSchedulePriority = async (
    priority: TimetablePriority,
  ) => {
    const updateMutation = addMutationWrapper(
      buildUpdateVehicleScheduleFrameMutation(
        vehicleScheduleFramesByName.winter2022.vehicle_schedule_frame_id,
        {
          priority,
        },
      ),
    );

    const updateResponse = await postQuery(updateMutation);
    expectNoErrorResponse(updateResponse);
    expect(
      updateResponse.data.timetables
        .timetables_update_vehicle_schedule_vehicle_schedule_frame.returning,
    ).toHaveLength(1);
  };

  describe('on inserts', () => {
    it('should fail when existing and new vehicle schedule frame have same priority, journey pattern, day of week and overlapping validity period', async () => {
      const dataset = cloneBaseDataset();
      await expect(insertDataset(dataset)).rejects.toThrow(
        'conflicting schedules detected',
      );
    });

    it('should return properly formatted exception on error', async () => {
      // Not expecting any UI or other system to depend on the error message.
      // This test is mostly for verifying that the error message formatting code itself doesn't throw.
      // Migrations and other tests would still pass if it did.

      const dataset = cloneBaseDataset();
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
      //   priority 10, journey_pattern_id 55bab728-c76c-4ce6-9cc6-f6e51c1c5dca, overlapping on [2022-07-01,2023-05-31) on day of week 1
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
        weekday: /on day of week [1-5]/, // These conflict on multiple days, so day of week could be between 1-5.
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
        const dataset = cloneBaseDataset();
        expect(dataset.frame.priority).toBe(TimetablePriority.Standard);
        dataset.frame.priority = TimetablePriority.Special;

        await expect(insertDataset(dataset)).resolves.not.toThrow();
      });

      it('should fail if trying to insert with same priority if priority is Special (or lower)', async () => {
        await setBaseDatasetSchedulePriority(TimetablePriority.Special);

        const dataset = cloneBaseDataset();
        dataset.frame.priority = TimetablePriority.Special;

        await expect(insertDataset(dataset)).rejects.toThrow(
          'conflicting schedules detected',
        );
      });

      it('should successfully insert with same priority if priority is Draft, even if schedule otherwise conflicts', async () => {
        await setBaseDatasetSchedulePriority(TimetablePriority.Draft);

        const dataset = cloneBaseDataset();
        dataset.frame.priority = TimetablePriority.Draft;

        await expect(insertDataset(dataset)).resolves.not.toThrow();
      });

      it('should successfully insert with same priority if priority is Staging, even if schedule otherwise conflicts', async () => {
        await setBaseDatasetSchedulePriority(TimetablePriority.Staging);

        const dataset = cloneBaseDataset();
        dataset.frame.priority = TimetablePriority.Staging;

        await expect(insertDataset(dataset)).resolves.not.toThrow();
      });
    });

    describe('validity period checks', () => {
      it('should succeed when validity periods do not overlap', async () => {
        const dataset = cloneBaseDataset();
        // A sanity check: these tests need to be updated in case the base data is modified.
        expect(dataset.frame.validity_start?.toISODate()).toEqual('2022-07-01');
        expect(dataset.frame.validity_end?.toISODate()).toEqual('2023-05-31');

        // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
        dataset.frame.validity_start = dataset.frame.validity_end!.plus({
          days: 1,
        });
        dataset.frame.validity_end = DateTime.fromISO('2023-12-31');

        await expect(insertDataset(dataset)).resolves.not.toThrow();
      });

      it('should fail when validity periods overlap partially', async () => {
        const dataset = cloneBaseDataset();
        dataset.frame.validity_start = DateTime.fromISO('2023-01-01');
        dataset.frame.validity_end = DateTime.fromISO('2023-12-31');

        await expect(insertDataset(dataset)).rejects.toThrow(
          'conflicting schedules detected',
        );
      });

      // No sense going through all possible combinations, that would basically be just testing PostgreSQL OVERLAPS operator.
      // But this is an important corner case since it requires different behavior date ranges in PostgreSQL have by default:
      // validity_end is exclusive = date range is NOT half open.
      it("should fail when validity periods overlap: validity_end same as another's validity_start", async () => {
        const dataset = cloneBaseDataset();
        dataset.frame.validity_start = dataset.frame.validity_end;
        // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
        dataset.frame.validity_end = dataset.frame.validity_end!.plus({
          months: 2,
        });

        await expect(insertDataset(dataset)).rejects.toThrow(
          'conflicting schedules detected',
        );
      });
    });

    describe('day of week checks', () => {
      it('should succeed when there are no vehicle services for same day of week between frames', async () => {
        const dataset = cloneBaseDataset();
        dataset.service.day_type_id = defaultDayTypeIds.SATURDAY;

        await expect(insertDataset(dataset)).resolves.not.toThrow();
      });

      it('should fail when there are vehicle services for same days of week between frames, even if one is defined by compound day type', async () => {
        const dataset = cloneBaseDataset();
        expect(dataset.service.day_type_id).toBe(
          defaultDayTypeIds.MONDAY_FRIDAY,
        );
        dataset.service.day_type_id = defaultDayTypeIds.WEDNESDAY;

        await expect(insertDataset(dataset)).rejects.toThrow(
          'conflicting schedules detected',
        );
      });
    });

    describe('journey pattern checks', () => {
      it('should succeed when frames do not use any common journey patterns between them', async () => {
        const dataset = cloneBaseDataset();

        const newJourneyPatternRefId =
          journeyPatternRefsByName.route234Outbound.journey_pattern_ref_id;
        dataset.journey.journey_pattern_ref_id = newJourneyPatternRefId;
        useRoute234StopPoints(dataset);

        await expect(insertDataset(dataset)).resolves.not.toThrow();
      });
    });
  });

  describe('on updates', () => {
    describe('on properties considered for schedule conflicts', () => {
      it('should run validation when priority is updated', async () => {
        const dataset = cloneBaseDataset();
        const baseDatasePriority = dataset.frame.priority;
        dataset.frame.priority = baseDatasePriority + 10;
        await expect(insertDataset(dataset)).resolves.not.toThrow();

        const updateMutation = addMutationWrapper(
          buildUpdateVehicleScheduleFrameMutation(
            dataset.frame.vehicle_schedule_frame_id,
            {
              priority: baseDatasePriority,
            },
          ),
        );

        const updateResponse = await postQuery(updateMutation);
        expectErrorResponse('conflicting schedules detected')(updateResponse);
      });

      it('should run validation when validity period is updated', async () => {
        const dataset = cloneBaseDataset();
        const baseDatasetValidityStart = dataset.frame.validity_start;
        dataset.frame.validity_start = DateTime.fromISO('2023-11-01');
        dataset.frame.validity_end = DateTime.fromISO('2023-12-31');

        await expect(insertDataset(dataset)).resolves.not.toThrow();

        const updateMutation = addMutationWrapper(
          buildUpdateVehicleScheduleFrameMutation(
            dataset.frame.vehicle_schedule_frame_id,
            {
              validity_start: baseDatasetValidityStart,
            },
          ),
        );

        const updateResponse = await postQuery(updateMutation);
        expectErrorResponse('conflicting schedules detected')(updateResponse);
      });

      it('should run validation when day of week is updated', async () => {
        const dataset = cloneBaseDataset();
        const baseDatasetDayTypeId = dataset.service.day_type_id;
        dataset.service.day_type_id = defaultDayTypeIds.SATURDAY;

        await expect(insertDataset(dataset)).resolves.not.toThrow();

        const updateMutation = addMutationWrapper(
          buildUpdateVehicleServiceMutation(
            dataset.service.vehicle_service_id,
            {
              day_type_id: baseDatasetDayTypeId,
            },
          ),
        );

        const updateResponse = await postQuery(updateMutation);
        expectErrorResponse('conflicting schedules detected')(updateResponse);
      });

      it('should run validation when journey_pattern_ref is updated', async () => {
        const dataset = cloneBaseDataset();
        const baseDatasetRef = journeyPatternRefsByName.route123Outbound;
        const newScheduleRef = journeyPatternRefsByName.route234Outbound;
        // Set to inbound so this doesn't conflict with existing schedule.
        expect(dataset.journey.journey_pattern_ref_id).toBe(
          baseDatasetRef.journey_pattern_ref_id,
        );
        expect(baseDatasetRef.journey_pattern_id).not.toBe(
          newScheduleRef.journey_pattern_id,
        );
        dataset.journey.journey_pattern_ref_id =
          newScheduleRef.journey_pattern_ref_id;
        useRoute234StopPoints(dataset);

        await expect(insertDataset(dataset)).resolves.not.toThrow();

        // Update the ref so that inbound and outbound point to same journey pattern -> conflict in schedules ensues.
        const updateMutation = addMutationWrapper(
          buildUpdateJourneyPatternRefMutation(
            newScheduleRef.journey_pattern_ref_id,
            {
              journey_pattern_id: baseDatasetRef.journey_pattern_id,
            },
          ),
        );
        const updateResponse = await postQuery(updateMutation);
        expectErrorResponse('conflicting schedules detected')(updateResponse);
      });
    });

    describe('on foreign keys', () => {
      const insertSchedulesForForeignKeyTests = async () => {
        // Need 3 different schedules to setup this conflict:
        // 1. the base dataset (vehicle schedule frame winter2022, from defaultGenericTimetablesDbData)
        // 2. datasetDifferentPrio, with same journey pattern as base dataset, but different priority
        // 3. datasetDifferentJourney, with different journey pattern
        //
        // At the start, none of these conflict with each other.
        //
        // With this setup moving the vehicle_journey (or its parents) from datasetDifferentPrio to datasetDifferentJourney
        // will make datasetDifferentJourney conflict with the base dataset since then they have same journey pattern and priority (among other properties).

        const datasetDifferentPrio = cloneBaseDataset();
        datasetDifferentPrio.frame.priority = 20;
        await expect(
          insertDataset(datasetDifferentPrio),
        ).resolves.not.toThrow();

        const datasetDifferentJourney = cloneBaseDataset();
        datasetDifferentJourney.journey.journey_pattern_ref_id =
          journeyPatternRefsByName.route234Outbound.journey_pattern_ref_id;
        useRoute234StopPoints(datasetDifferentJourney);
        await expect(
          insertDataset(datasetDifferentJourney),
        ).resolves.not.toThrow();

        return {
          datasetDifferentPrio,
          datasetDifferentJourney,
        };
      };

      it('should run validation when vehicle_service.vehicle_schedule_frame_id is changed', async () => {
        const { datasetDifferentPrio, datasetDifferentJourney } =
          await insertSchedulesForForeignKeyTests();

        // Move vehicle service from schedule of datasetDifferentPrio to schedule of datasetDifferentJourney.
        // Since the moved vehicle service from datasetDifferentPrio uses same journey pattern as base dataset,
        // after this update datasetDifferentJourney would conflict with base dataset.
        const updateMutation = addMutationWrapper(
          buildUpdateVehicleServiceMutation(
            datasetDifferentPrio.service.vehicle_service_id,
            {
              vehicle_schedule_frame_id:
                datasetDifferentJourney.service.vehicle_schedule_frame_id,
            },
          ),
        );

        const updateResponse = await postQuery(updateMutation);
        expectErrorResponse('conflicting schedules detected')(updateResponse);
      });

      it('should run validation when block.vehicle_service_id is changed', async () => {
        const { datasetDifferentPrio, datasetDifferentJourney } =
          await insertSchedulesForForeignKeyTests();

        // Move block from schedule of datasetDifferentPrio to schedule of datasetDifferentJourney.
        // Since the moved block from datasetDifferentPrio uses same journey pattern as base dataset,
        // after this update datasetDifferentJourney would conflict with base dataset.
        const updateMutation = addMutationWrapper(
          buildUpdateBlockMutation(datasetDifferentPrio.block.block_id, {
            vehicle_service_id:
              datasetDifferentJourney.block.vehicle_service_id,
          }),
        );

        const updateResponse = await postQuery(updateMutation);
        expectErrorResponse('conflicting schedules detected')(updateResponse);
      });

      it('should run validation when vehicle_journey.block_id is changed', async () => {
        const { datasetDifferentPrio, datasetDifferentJourney } =
          await insertSchedulesForForeignKeyTests();

        // Move vehicle journey from schedule of datasetDifferentPrio to schedule of datasetDifferentJourney.
        // Since the moved vehicle journey from datasetDifferentPrio uses same journey pattern as base dataset,
        // after this update datasetDifferentJourney would conflict with base dataset.
        const updateMutation = addMutationWrapper(
          buildUpdateVehicleJourneyMutation(
            datasetDifferentPrio.journey.vehicle_journey_id,
            {
              block_id: datasetDifferentJourney.journey.block_id,
            },
          ),
        );

        const updateResponse = await postQuery(updateMutation);
        expectErrorResponse('conflicting schedules detected')(updateResponse);
      });

      it('should allow valid updates', async () => {
        const { datasetDifferentPrio, datasetDifferentJourney } =
          await insertSchedulesForForeignKeyTests();

        // Similar UPDATE as in previous tests, but the other way around:
        // moving schedule from datasetDifferentJourney -> datasetDifferentPrio.
        // After this datasetDifferentPrio has same journey as base dataset but still different priority,
        // so there is no conflict.
        // Same would apply to all other tables, but don't think it's worth testing all the cases.
        const updateMutation = addMutationWrapper(
          buildUpdateBlockMutation(datasetDifferentJourney.block.block_id, {
            vehicle_service_id: datasetDifferentPrio.block.vehicle_service_id,
          }),
        );

        const updateResponse = await postQuery(updateMutation);
        expectNoErrorResponse(updateResponse);
      });
    });
  });
});
