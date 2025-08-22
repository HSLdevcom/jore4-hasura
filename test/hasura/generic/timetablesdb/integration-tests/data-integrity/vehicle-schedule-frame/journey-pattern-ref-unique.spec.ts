import pick from 'lodash/pick';
import without from 'lodash/without';
import { DateTime, Duration } from 'luxon';
import { timetablesDbConfig } from '@config';
import {
  DbConnection,
  closeDbConnection,
  createDbConnection,
  getKnex,
} from '@util/db';
import { addMutationWrapper, postQuery } from '@util/graphql';
import { expectErrorResponse, expectNoErrorResponse } from '@util/response';
import { getPartialTableData, insertTableData, setupDb } from '@util/setup';
import { defaultTimetablesDataset } from 'generic/timetablesdb/datasets/defaultSetup/default-timetables-dataset';
import { GenericTimetablesDbTables } from 'generic/timetablesdb/datasets/schema';
import {
  TimetablePriority,
  VehicleScheduleFrame,
} from 'generic/timetablesdb/datasets/types';
import {
  buildUpdateBlockMutation,
  buildUpdateJourneyPatternRefMutation,
  buildUpdateVehicleJourneyMutation,
  buildUpdateVehicleScheduleFrameMutation,
  buildUpdateVehicleServiceMutation,
} from 'generic/timetablesdb/mutations';
import {
  GenericTimetablesDatasetInput,
  buildGenericTimetablesDataset,
  createGenericTableData,
  defaultDayTypeIds,
  genericVehicleScheduleFrameToDbFormat,
  timetabledPassingTimeToDbFormat,
  vehicleJourneyToDbFormat,
  vehicleServiceBlockToDbFormat,
  vehicleServiceToDbFormat,
} from 'timetables-data-inserter';

describe('Vehicle schedule frame - journey pattern ref uniqueness constraint', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(timetablesDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  const builtDefaultDataset = buildGenericTimetablesDataset(
    defaultTimetablesDataset,
  );

  beforeEach(async () =>
    setupDb(dbConnection, createGenericTableData(builtDefaultDataset)),
  );

  const cloneBaseDataset = () => {
    const clonedTimetable: GenericTimetablesDatasetInput = {
      _vehicle_schedule_frames: {
        winter2022:
          defaultTimetablesDataset._vehicle_schedule_frames.winter2022,
      },
      // Important: use the *built* version so same journey pattern ref instance that we have already inserted gets used.
      // We don't actually insert new one anymore, we just need it here so correct foreign keys get assigned for new vehicle journeys.
      _journey_pattern_refs: builtDefaultDataset._journey_pattern_refs,
    };
    const builtClonedDataset = buildGenericTimetablesDataset(clonedTimetable);
    const frame = builtClonedDataset._vehicle_schedule_frames.winter2022;
    const service = frame._vehicle_services.monFri;
    const { block } = service._blocks;
    const journey = block._vehicle_journeys.route123Outbound1;
    const passingTimes = journey._passing_times;

    return {
      frame: genericVehicleScheduleFrameToDbFormat(frame),
      service: vehicleServiceToDbFormat(service),
      block: vehicleServiceBlockToDbFormat(block),
      journey: vehicleJourneyToDbFormat(journey),
      passingTimes: passingTimes.map(timetabledPassingTimeToDbFormat),
    };
  };

  const buildTableDataForBaseDataset = (
    dataset: ReturnType<typeof cloneBaseDataset>,
  ) => {
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
    return dbData;
  };

  const insertTableDataInTransaction = (
    dbData: TableData<GenericTimetablesDbTables>[],
  ) => {
    return getKnex().transaction(
      async (trx) => {
        const result = await insertTableData(trx, dbData);
        // Error expects get very spammy if they fail, with the whole results object. Pick some useful props.
        return result.map((command) => pick(command, 'command', 'rowCount'));
      },
      { connection: dbConnection },
    );
  };

  const insertDataset = (dataset: ReturnType<typeof cloneBaseDataset>) => {
    const dbData = buildTableDataForBaseDataset(dataset);
    return insertTableDataInTransaction(dbData);
  };

  const useRoute234StopPoints = (
    dataset: ReturnType<typeof cloneBaseDataset>,
  ) => {
    // The stops need to be from same journey pattern as well, not to break other constraints.
    const journeyPatternRef =
      builtDefaultDataset._journey_pattern_refs.route234Outbound;
    const newStops = [
      journeyPatternRef._stop_points[0],
      journeyPatternRef._stop_points[1],
    ];

    const newStopPoints = [
      {
        ...dataset.passingTimes[0],
        arrival_time: null,
        departure_time: Duration.fromISO('PT18H12M'),
        scheduled_stop_point_in_journey_pattern_ref_id:
          newStops[0].scheduled_stop_point_in_journey_pattern_ref_id,
      },
      {
        ...dataset.passingTimes[3], // Last stop.
        arrival_time: Duration.fromISO('PT18H23M'),
        departure_time: null,
        scheduled_stop_point_in_journey_pattern_ref_id:
          newStops[1].scheduled_stop_point_in_journey_pattern_ref_id,
      },
    ];

    dataset.passingTimes.length = 0; // eslint-disable-line no-param-reassign
    dataset.passingTimes.push(...newStopPoints);
  };

  const updateBaseDatasetFrame = async (
    toUpdate: Partial<VehicleScheduleFrame>,
  ) => {
    const updateMutation = addMutationWrapper(
      buildUpdateVehicleScheduleFrameMutation(
        builtDefaultDataset._vehicle_schedule_frames.winter2022
          .vehicle_schedule_frame_id,
        {
          ...toUpdate,
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
        frame2: `vehicle schedule frame ${builtDefaultDataset._vehicle_schedule_frames.winter2022.vehicle_schedule_frame_id}`,
        priority: `priority ${dataset.frame.priority}, `,
        journey: `journey_pattern_id ${builtDefaultDataset._journey_pattern_refs.route123Outbound.journey_pattern_id}, `,
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
        dataset.frame.priority = TimetablePriority.Temporary;

        await expect(insertDataset(dataset)).resolves.not.toThrow();
      });

      it('should fail if trying to insert with same priority if priority is Special (or lower)', async () => {
        // Special day priority frames must have validity of exactly one day, so need to set that as well.
        const specialDay = DateTime.fromISO('2023-01-23');
        await updateBaseDatasetFrame({
          validity_start: specialDay,
          validity_end: specialDay,
          priority: TimetablePriority.Special,
        });

        const dataset = cloneBaseDataset();
        dataset.frame.priority = TimetablePriority.Special;
        dataset.frame.validity_start = specialDay;
        dataset.frame.validity_end = specialDay;

        await expect(insertDataset(dataset)).rejects.toThrow(
          'conflicting schedules detected',
        );
      });

      it('should successfully insert with same priority if priority is Draft, even if schedule otherwise conflicts', async () => {
        await updateBaseDatasetFrame({ priority: TimetablePriority.Draft });

        const dataset = cloneBaseDataset();
        dataset.frame.priority = TimetablePriority.Draft;

        await expect(insertDataset(dataset)).resolves.not.toThrow();
      });

      it('should successfully insert with same priority if priority is Staging, even if schedule otherwise conflicts', async () => {
        await updateBaseDatasetFrame({ priority: TimetablePriority.Staging });

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
          builtDefaultDataset._journey_pattern_refs.route234Outbound
            .journey_pattern_ref_id;
        dataset.journey.journey_pattern_ref_id = newJourneyPatternRefId;
        useRoute234StopPoints(dataset);

        await expect(insertDataset(dataset)).resolves.not.toThrow();
      });
    });

    describe('when inserts are done in different transactions', () => {
      // Vehicle journey is the part that finally "links" vehicle_schedule_frame and journey_pattern,
      // so it is important to ensure validation is triggered on that insert alone.
      it('should trigger validation when vehicle journey is inserted separately', async () => {
        const dataset = cloneBaseDataset();

        // Split the test data to two parts that we will insert separately:
        // vehicle_journey (and its "children") and everything else.
        const dbData = buildTableDataForBaseDataset(dataset);
        const allTableNames = dbData.map((td) => td.name);
        const vehicleJourneyTableNames: GenericTimetablesDbTables[] = [
          'vehicle_journey.vehicle_journey',
          'passing_times.timetabled_passing_time',
        ];
        const tableDataWithoutVehicleJourney = getPartialTableData(
          dbData,
          without(allTableNames, ...vehicleJourneyTableNames),
        );
        const vehicleJourneyTableData = getPartialTableData(
          dbData,
          vehicleJourneyTableNames,
        );

        await expect(
          insertTableDataInTransaction(tableDataWithoutVehicleJourney),
        ).resolves.not.toThrow();

        // No connection yet between the inserted vehicle_schedule_frame and base dataset.
        // Insert the vehicle_journey to connect them and create conflict.

        await expect(
          insertTableDataInTransaction(vehicleJourneyTableData),
        ).rejects.toThrow('conflicting schedules detected');
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
        const baseDatasetRef =
          builtDefaultDataset._journey_pattern_refs.route123Outbound;
        const newScheduleRef =
          builtDefaultDataset._journey_pattern_refs.route234Outbound;
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
          builtDefaultDataset._journey_pattern_refs.route234Outbound.journey_pattern_ref_id;
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
