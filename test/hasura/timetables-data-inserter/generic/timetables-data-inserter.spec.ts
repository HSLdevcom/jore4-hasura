import { get } from 'lodash';
import { DateTime } from 'luxon';
import * as config from '@config';
import { DbConnection, closeDbConnection, createDbConnection } from '@util/db';
import { queryTable } from '@util/setup';
import { genericTimetablesDbSchema } from 'generic/timetablesdb/datasets/schema';
import { defaultDayTypeIds } from 'timetables-data-inserter/day-types';
import { insertDatasetFromJson } from './data-insert';
import testDatasetJson from './example.json';
import {
  GenericJourneyPatternRefOutput,
  GenericScheduledStopInJourneyPatternRefOutput,
  GenericTimetabledPassingTimeOutput,
  GenericTimetablesDatasetOutput,
  GenericVehicleJourneyOutput,
  GenericVehicleScheduleFrameOutput,
  GenericVehicleServiceBlockOutput,
  GenericVehicleServiceOutput,
} from './types';

describe('Generic timetables data inserter json parser', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(config.timetablesDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  const insertTestDataset = () => {
    return insertDatasetFromJson(JSON.stringify(testDatasetJson));
  };

  it('should return the built dataset', async () => {
    const result: GenericTimetablesDatasetOutput = await insertTestDataset();
    expect(result).toBeTruthy();

    // Just check that there's nothing extra here. Each model is checked in a separate tests.
    // If this fails because of new properties being added, new tests for those should probably be created as well.
    expect(Object.keys(result).sort()).toEqual(
      ['_vehicle_schedule_frames', '_journey_pattern_refs'].sort(),
    );
  });

  describe('tables', () => {
    describe('vehicle schedule frame', () => {
      let builtDataset: GenericTimetablesDatasetOutput;
      let builtVehicleScheduleFrame: GenericVehicleScheduleFrameOutput;

      beforeAll(async () => {
        builtDataset = await insertTestDataset();
        builtVehicleScheduleFrame =
          builtDataset._vehicle_schedule_frames.winter2022;
      });

      it('should be built correctly', async () => {
        expect(
          builtVehicleScheduleFrame.vehicle_schedule_frame_id,
        ).toBeValidUuid();
      });

      it('should be inserted correctly', async () => {
        const vehicleScheduleFrames = await queryTable(
          dbConnection,
          genericTimetablesDbSchema['vehicle_schedule.vehicle_schedule_frame'],
        );

        expect(vehicleScheduleFrames.rowCount).toBe(1);

        expect(vehicleScheduleFrames.rows[0].vehicle_schedule_frame_id).toBe(
          builtVehicleScheduleFrame.vehicle_schedule_frame_id,
        );
      });
    });

    describe('vehicle services', () => {
      let builtDataset: GenericTimetablesDatasetOutput;
      let builtVehicleServices: Record<string, GenericVehicleServiceOutput>;

      beforeAll(async () => {
        builtDataset = await insertTestDataset();
        builtVehicleServices =
          builtDataset._vehicle_schedule_frames.winter2022._vehicle_services;
      });

      it('should be built correctly', async () => {
        expect(builtVehicleServices.monFri.vehicle_service_id).toBeValidUuid();
        expect(builtVehicleServices.sat.vehicle_service_id).toBeValidUuid();
        expect(builtVehicleServices.sun.vehicle_service_id).toBeValidUuid();

        const parentId =
          builtDataset._vehicle_schedule_frames.winter2022
            .vehicle_schedule_frame_id;
        expect(builtVehicleServices.monFri.vehicle_schedule_frame_id).toBe(
          parentId,
        );
        expect(builtVehicleServices.sat.vehicle_schedule_frame_id).toBe(
          parentId,
        );
        expect(builtVehicleServices.sun.vehicle_schedule_frame_id).toBe(
          parentId,
        );
      });

      it('should be inserted correctly', async () => {
        const vehicleServices = await queryTable(
          dbConnection,
          genericTimetablesDbSchema['vehicle_service.vehicle_service'],
        );

        expect(vehicleServices.rowCount).toBe(3);

        const saturdayService = vehicleServices.rows.find(
          (vs: GenericVehicleServiceOutput) =>
            vs.vehicle_service_id ===
            builtVehicleServices.sat.vehicle_service_id,
        );
        expect(saturdayService).toBeTruthy();
        expect(saturdayService.vehicle_schedule_frame_id).toBe(
          builtVehicleServices.sat.vehicle_schedule_frame_id,
        );
        expect(saturdayService.day_type_id).toBe(defaultDayTypeIds.SATURDAY);
      });
    });

    describe('vehicle service blocks', () => {
      let builtDataset: GenericTimetablesDatasetOutput;
      let builtBlock: GenericVehicleServiceBlockOutput;

      beforeAll(async () => {
        builtDataset = await insertTestDataset();
        builtBlock =
          builtDataset._vehicle_schedule_frames.winter2022._vehicle_services
            .monFri._blocks.block;
      });

      it('should be built correctly', async () => {
        expect(builtBlock.block_id).toBeValidUuid();
        expect(builtBlock.vehicle_service_id).toBe(
          builtDataset._vehicle_schedule_frames.winter2022._vehicle_services
            .monFri.vehicle_service_id,
        );
      });

      it('should be inserted correctly', async () => {
        const blocks = await queryTable(
          dbConnection,
          genericTimetablesDbSchema['vehicle_service.block'],
        );

        expect(blocks.rowCount).toBe(3);

        const monFriBlock = blocks.rows.find(
          (b: GenericVehicleServiceBlockOutput) =>
            b.block_id === builtBlock.block_id,
        );
        expect(monFriBlock).toBeTruthy();
        expect(monFriBlock.vehicle_service_id).toBe(
          builtBlock.vehicle_service_id,
        );
      });
    });

    describe('vehicle journeys', () => {
      let builtDataset: GenericTimetablesDatasetOutput;
      let builtJourneys: Record<string, GenericVehicleJourneyOutput>;

      beforeAll(async () => {
        builtDataset = await insertTestDataset();
        builtJourneys =
          builtDataset._vehicle_schedule_frames.winter2022._vehicle_services
            .monFri._blocks.block._vehicle_journeys;
      });

      it('should be built correctly', async () => {
        expect(
          builtJourneys.route123Outbound1.vehicle_journey_id,
        ).toBeValidUuid();
        expect(
          builtJourneys.route123Inbound1.vehicle_journey_id,
        ).toBeValidUuid();
        expect(
          builtJourneys.route123Outbound2.vehicle_journey_id,
        ).toBeValidUuid();
        expect(
          builtJourneys.route123Inbound2.vehicle_journey_id,
        ).toBeValidUuid();

        const parentBlockId =
          builtDataset._vehicle_schedule_frames.winter2022._vehicle_services
            .monFri._blocks.block.block_id;
        expect(builtJourneys.route123Outbound1.block_id).toBe(parentBlockId);
        expect(builtJourneys.route123Inbound1.block_id).toBe(parentBlockId);
        expect(builtJourneys.route123Outbound2.block_id).toBe(parentBlockId);
        expect(builtJourneys.route123Inbound2.block_id).toBe(parentBlockId);

        const outboundJourneyPatternRef =
          builtDataset._journey_pattern_refs.route123Outbound;
        const inboundJourneyPatternRef =
          builtDataset._journey_pattern_refs.route123Inbound;
        expect(builtJourneys.route123Outbound1.journey_pattern_ref_id).toBe(
          outboundJourneyPatternRef.journey_pattern_ref_id,
        );
        expect(builtJourneys.route123Inbound1.journey_pattern_ref_id).toBe(
          inboundJourneyPatternRef.journey_pattern_ref_id,
        );
        expect(builtJourneys.route123Outbound2.journey_pattern_ref_id).toBe(
          outboundJourneyPatternRef.journey_pattern_ref_id,
        );
        expect(builtJourneys.route123Inbound2.journey_pattern_ref_id).toBe(
          inboundJourneyPatternRef.journey_pattern_ref_id,
        );
      });

      it('should be inserted correctly', async () => {
        const vehicleJourneys = await queryTable(
          dbConnection,
          genericTimetablesDbSchema['vehicle_journey.vehicle_journey'],
        );

        expect(vehicleJourneys.rowCount).toBe(4);

        const monFriInboundJourney = vehicleJourneys.rows.find(
          (vj: GenericVehicleJourneyOutput) =>
            vj.vehicle_journey_id ===
            builtJourneys.route123Inbound1.vehicle_journey_id,
        );
        expect(monFriInboundJourney).toBeTruthy();
        expect(monFriInboundJourney.block_id).toBe(
          builtJourneys.route123Inbound1.block_id,
        );
        expect(monFriInboundJourney.journey_pattern_ref_id).toBe(
          builtJourneys.route123Inbound1.journey_pattern_ref_id,
        );
      });
    });

    describe('timetabled passing times', () => {
      let builtDataset: GenericTimetablesDatasetOutput;
      let builtOutboundPassingTimes: GenericTimetabledPassingTimeOutput[];
      let builtInboundPassingTimes: GenericTimetabledPassingTimeOutput[];
      const outboundPassingTimePath =
        '_vehicle_schedule_frames.winter2022._vehicle_services.monFri._blocks.block._vehicle_journeys.route123Outbound1._passing_times';
      const inboundPassingTimePath =
        '_vehicle_schedule_frames.winter2022._vehicle_services.monFri._blocks.block._vehicle_journeys.route123Inbound1._passing_times';

      beforeAll(async () => {
        builtDataset = await insertTestDataset();
        builtOutboundPassingTimes = get(builtDataset, outboundPassingTimePath);
        builtInboundPassingTimes = get(builtDataset, inboundPassingTimePath);
      });

      it('should be built correctly', async () => {
        expect(
          builtOutboundPassingTimes[0].timetabled_passing_time_id,
        ).toBeValidUuid();
        expect(
          builtInboundPassingTimes[3].timetabled_passing_time_id,
        ).toBeValidUuid();

        const matchingOutboundStopPoint =
          builtDataset._journey_pattern_refs.route123Outbound._stop_points[0];
        const matchingInboundStopPoint =
          builtDataset._journey_pattern_refs.route123Inbound._stop_points[3];
        expect(
          builtOutboundPassingTimes[0]
            .scheduled_stop_point_in_journey_pattern_ref_id,
        ).toBe(
          matchingOutboundStopPoint.scheduled_stop_point_in_journey_pattern_ref_id,
        );
        expect(matchingOutboundStopPoint.scheduled_stop_point_label).toBe(
          get(testDatasetJson, outboundPassingTimePath)[0]
            ._scheduled_stop_point_label,
        );

        expect(
          builtInboundPassingTimes[3]
            .scheduled_stop_point_in_journey_pattern_ref_id,
        ).toBe(
          matchingInboundStopPoint.scheduled_stop_point_in_journey_pattern_ref_id,
        );
        expect(matchingInboundStopPoint.scheduled_stop_point_label).toBe(
          get(testDatasetJson, inboundPassingTimePath)[3]
            ._scheduled_stop_point_label,
        );
      });

      it('should be inserted correctly', async () => {
        const passingTimes = await queryTable(
          dbConnection,
          genericTimetablesDbSchema['passing_times.timetabled_passing_time'],
        );

        expect(passingTimes.rowCount).toBe(16);
        const inboundPassingTime = passingTimes.rows.find(
          (pt: GenericTimetabledPassingTimeOutput) =>
            pt.timetabled_passing_time_id ===
            builtInboundPassingTimes[3].timetabled_passing_time_id,
        );
        expect(inboundPassingTime).toBeTruthy();
        expect(inboundPassingTime.arrival_time.toISO()).toBe('PT7H55M');
        expect(inboundPassingTime.departure_time).toBeNull();
      });
    });

    describe('journey pattern refs', () => {
      let builtDataset: GenericTimetablesDatasetOutput;
      let builtJourneyPatternRef: GenericJourneyPatternRefOutput;

      beforeAll(async () => {
        builtDataset = await insertTestDataset();
        builtJourneyPatternRef =
          builtDataset._journey_pattern_refs.route123Inbound;
      });

      it('should be built correctly', async () => {
        expect(builtJourneyPatternRef.journey_pattern_ref_id).toBeValidUuid();
      });

      it('should be inserted correctly', async () => {
        const journeyPatternRefs = await queryTable(
          dbConnection,
          genericTimetablesDbSchema['journey_pattern.journey_pattern_ref'],
        );

        expect(journeyPatternRefs.rowCount).toBe(3);
        const inboundRef = journeyPatternRefs.rows.find(
          (jpr: GenericJourneyPatternRefOutput) =>
            jpr.journey_pattern_ref_id ===
            builtJourneyPatternRef.journey_pattern_ref_id,
        );
        expect(inboundRef).toBeTruthy();

        expect(inboundRef.observation_timestamp).toEqual(
          DateTime.fromISO('2023-07-01T00:00:00+00:00'),
        );
        expect(inboundRef.snapshot_timestamp).toEqual(
          DateTime.fromISO('2023-09-28T00:00:00+00:00'),
        );
        expect(inboundRef.type_of_line).toBe('stopping_bus_service');
        expect(inboundRef.route_label).toBe('123');
        expect(inboundRef.route_direction).toBe('inbound');
        expect(inboundRef.route_validity_start).toEqual(
          DateTime.fromISO('2023-06-01'),
        );
        expect(inboundRef.route_validity_end).toEqual(
          DateTime.fromISO('2051-01-01'),
        );
      });
    });

    describe('scheduled stop points', () => {
      let builtDataset: GenericTimetablesDatasetOutput;
      let builtInboundStopPoints: GenericScheduledStopInJourneyPatternRefOutput[];

      beforeAll(async () => {
        builtDataset = await insertTestDataset();
        builtInboundStopPoints =
          builtDataset._journey_pattern_refs.route123Inbound._stop_points;
      });

      it('should be built correctly', async () => {
        expect(
          builtInboundStopPoints[2]
            .scheduled_stop_point_in_journey_pattern_ref_id,
        ).toBeValidUuid();
        const parentJourneyPatternRef =
          builtDataset._journey_pattern_refs.route123Inbound;
        expect(builtInboundStopPoints[2].journey_pattern_ref_id).toBe(
          parentJourneyPatternRef.journey_pattern_ref_id,
        );
      });

      it('should be inserted correctly', async () => {
        const stopPoints = await queryTable(
          dbConnection,
          genericTimetablesDbSchema[
            'service_pattern.scheduled_stop_point_in_journey_pattern_ref'
          ],
        );

        expect(stopPoints.rowCount).toBe(10);
        const dbStopPoint = stopPoints.rows.find(
          (sp: GenericScheduledStopInJourneyPatternRefOutput) =>
            sp.scheduled_stop_point_in_journey_pattern_ref_id ===
            builtInboundStopPoints[2]
              .scheduled_stop_point_in_journey_pattern_ref_id,
        );
        expect(dbStopPoint).toBeTruthy();
        expect(dbStopPoint.journey_pattern_ref_id).toBe(
          builtInboundStopPoints[2].journey_pattern_ref_id,
        );
      });
    });
  });
});
