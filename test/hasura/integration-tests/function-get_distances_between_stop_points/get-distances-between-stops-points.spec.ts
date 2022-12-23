import * as config from '@config';
import { routesAndJourneyPatternsTableConfig as baseTableConfig } from '@datasets/routesAndJourneyPatterns';
import { journeyPatterns } from '@datasets/routesAndJourneyPatterns/journey-patterns';
import { scheduledStopPoints as sourceScheduledStopPoints } from '@datasets/routesAndJourneyPatterns/scheduled-stop-points';
import { setupDb } from '@datasets/setup';
import {
  ScheduledStopPoint,
  VehicleMode,
  VehicleModeOnScheduledStopPoint,
} from '@datasets/types';
import * as db from '@util/db';
import { randomUUID } from 'crypto';
import { LocalDate } from 'local-date';
import * as pg from 'pg';

describe('Function service_pattern.get_distances_between_stop_points', () => {
  let dbConnectionPool: pg.Pool;

  beforeAll(() => {
    dbConnectionPool = new pg.Pool(config.databaseConfig);
  });

  afterAll(() => dbConnectionPool.end());

  // Reset all scheduled stop point priorities.
  const baseScheduledStopPoints: ScheduledStopPoint[] =
    sourceScheduledStopPoints.map((ssp) => {
      return {
        ...ssp,
        priority: 10,
      };
    });

  const getTableDataToBePopulated = (
    scheduledStopPoints: ScheduledStopPoint[] = baseScheduledStopPoints,
  ): TableLikeConfig[] => {
    const tableConfig = [...baseTableConfig];

    const scheduledStopPointsIndex = baseTableConfig.findIndex((elem) => {
      return elem.name === 'service_pattern.scheduled_stop_point';
    });

    const vehicleModeOnStopPointIndex = baseTableConfig.findIndex((elem) => {
      return (
        elem.name === 'service_pattern.vehicle_mode_on_scheduled_stop_point'
      );
    });

    // Override scheduled stop points in base dataset.
    tableConfig[scheduledStopPointsIndex].data = scheduledStopPoints;

    const vehicleModes: VehicleModeOnScheduledStopPoint[] =
      scheduledStopPoints.map((ssp) => {
        return {
          scheduled_stop_point_id: ssp.scheduled_stop_point_id,
          vehicle_mode: VehicleMode.Bus,
        };
      });

    // Override vehicle modes (on stop points) in base dataset.
    tableConfig[vehicleModeOnStopPointIndex].data = vehicleModes;

    return tableConfig;
  };

  const roundToTwoDecimalPlaces = (n: number) => {
    return Math.round(n * 100) / 100;
  };

  type StopIntervalLength = {
    journey_pattern_id: string;
    route_id: string;
    stop_interval_sequence: number;
    start_stop_label: string;
    end_stop_label: string;
    distance_in_metres: number;
  };

  const getDistancesBetweenStopPoints = async (
    dataset: TableLikeConfig[],
    journeyPatternIds: string[],
    observationDate: LocalDate,
    includeDraftStopPoints = false,
  ): Promise<Array<StopIntervalLength>> => {
    await setupDb(dbConnectionPool, dataset);

    const response = await db.singleQuery(
      dbConnectionPool,
      `SELECT * FROM service_pattern.get_distances_between_stop_points('{${journeyPatternIds}}'::uuid[], '${observationDate.toISOString()}'::date, ${includeDraftStopPoints})`,
    );

    return response.rows.map((row) => {
      // Round the distances to two decimal places.
      return {
        ...row,
        distance_in_metres: roundToTwoDecimalPlaces(row.distance_in_metres),
      };
    });
  };

  it('test single journey pattern involving an infrastructure link with two stop points associated', async () => {
    const journeyPattern = journeyPatterns[2];
    const journeyPatternId = journeyPattern.journey_pattern_id;
    const routeId = journeyPattern.on_route_id;

    const response = await getDistancesBetweenStopPoints(
      getTableDataToBePopulated(),
      [journeyPatternId],
      new LocalDate('2044-05-02'),
    );

    expect(response.length).toEqual(3);

    expect(response).toEqual(
      expect.arrayContaining([
        {
          journey_pattern_id: journeyPatternId,
          route_id: routeId,
          stop_interval_sequence: 1,
          start_stop_label: 'stop1',
          end_stop_label: 'stop1X',
          distance_in_metres: 11021.92,
        },
        {
          journey_pattern_id: journeyPatternId,
          route_id: routeId,
          stop_interval_sequence: 2,
          start_stop_label: 'stop1X',
          end_stop_label: 'stop3X',
          distance_in_metres: 47741.72,
        },
        {
          journey_pattern_id: journeyPatternId,
          route_id: routeId,
          stop_interval_sequence: 3,
          start_stop_label: 'stop3X',
          end_stop_label: 'stop2X',
          distance_in_metres: 217330.59,
        },
      ]),
    );
  });

  it('with two journey patterns', async () => {
    const journeyPattern = journeyPatterns[0];
    const journeyPattern2 = journeyPatterns[2];

    const journeyPatternId = journeyPattern.journey_pattern_id;
    const journeyPatternId2 = journeyPattern2.journey_pattern_id;

    const response = await getDistancesBetweenStopPoints(
      getTableDataToBePopulated(),
      [journeyPatternId, journeyPatternId2],
      new LocalDate('2044-05-02'),
    );

    expect(response.length).toEqual(5);

    expect(response).toEqual(
      expect.arrayContaining([
        {
          journey_pattern_id: journeyPatternId,
          route_id: journeyPattern.on_route_id,
          stop_interval_sequence: 1,
          start_stop_label: 'stop1',
          end_stop_label: 'stop3',
          distance_in_metres: 69886.32,
        },
        {
          journey_pattern_id: journeyPatternId,
          route_id: journeyPattern.on_route_id,
          stop_interval_sequence: 2,
          start_stop_label: 'stop3',
          end_stop_label: 'stop2',
          distance_in_metres: 211718.65,
        },
        {
          journey_pattern_id: journeyPatternId2,
          route_id: journeyPattern2.on_route_id,
          stop_interval_sequence: 1,
          start_stop_label: 'stop1',
          end_stop_label: 'stop1X',
          distance_in_metres: 11021.92,
        },
        {
          journey_pattern_id: journeyPatternId2,
          route_id: journeyPattern2.on_route_id,
          stop_interval_sequence: 2,
          start_stop_label: 'stop1X',
          end_stop_label: 'stop3X',
          distance_in_metres: 47741.72,
        },
        {
          journey_pattern_id: journeyPatternId2,
          route_id: journeyPattern2.on_route_id,
          stop_interval_sequence: 3,
          start_stop_label: 'stop3X',
          end_stop_label: 'stop2X',
          distance_in_metres: 217330.59,
        },
      ]),
    );
  });

  describe('test priority overriding', () => {
    const journeyPattern = journeyPatterns[2];
    const journeyPatternId = journeyPattern.journey_pattern_id;
    const routeId = journeyPattern.on_route_id;

    const getScheduledStopPoints = (
      newPriority: number,
    ): ScheduledStopPoint[] => {
      const scheduledStopPoints: ScheduledStopPoint[] = [
        ...baseScheduledStopPoints,
      ];

      // Introduce a higher priority variant for label "stop3X".
      // Set a different location along the associated infrastructure link.
      const higherPriorityStopVariant: ScheduledStopPoint = {
        ...scheduledStopPoints[7],
        scheduled_stop_point_id: randomUUID(),
        priority: newPriority,
        measured_location: {
          type: 'Point',
          coordinates: [25.7, 60.3, 0],
          crs: {
            properties: { name: 'urn:ogc:def:crs:EPSG::4326' },
            type: 'name',
          },
        },
      };
      scheduledStopPoints.push(higherPriorityStopVariant);

      return scheduledStopPoints;
    };

    it('test that higher priority stop point overrides the one with lower priority', async () => {
      const scheduledStopPoints = getScheduledStopPoints(20);

      const response = await getDistancesBetweenStopPoints(
        getTableDataToBePopulated(scheduledStopPoints),
        [journeyPatternId],
        new LocalDate('2044-05-02'),
      );

      expect(response.length).toEqual(3);

      expect(response).toEqual(
        expect.arrayContaining([
          {
            journey_pattern_id: journeyPatternId,
            route_id: routeId,
            stop_interval_sequence: 1,
            start_stop_label: 'stop1',
            end_stop_label: 'stop1X',
            distance_in_metres: 11021.92,
          },
          {
            journey_pattern_id: journeyPatternId,
            route_id: routeId,
            stop_interval_sequence: 2,
            start_stop_label: 'stop1X',
            end_stop_label: 'stop3X',
            distance_in_metres: 25466.08,
          },
          {
            journey_pattern_id: journeyPatternId,
            route_id: routeId,
            stop_interval_sequence: 3,
            start_stop_label: 'stop3X',
            end_stop_label: 'stop2X',
            distance_in_metres: 239606.24,
          },
        ]),
      );
    });

    it('test that draft priority stop point is ignored when not selected', async () => {
      const scheduledStopPoints = getScheduledStopPoints(30);

      const response = await getDistancesBetweenStopPoints(
        getTableDataToBePopulated(scheduledStopPoints),
        [journeyPatternId],
        new LocalDate('2044-05-02'),
      );

      expect(response.length).toEqual(3);

      expect(response).toEqual(
        expect.arrayContaining([
          {
            journey_pattern_id: journeyPatternId,
            route_id: routeId,
            stop_interval_sequence: 1,
            start_stop_label: 'stop1',
            end_stop_label: 'stop1X',
            distance_in_metres: 11021.92,
          },
          {
            journey_pattern_id: journeyPatternId,
            route_id: routeId,
            stop_interval_sequence: 2,
            start_stop_label: 'stop1X',
            end_stop_label: 'stop3X',
            distance_in_metres: 47741.72,
          },
          {
            journey_pattern_id: journeyPatternId,
            route_id: routeId,
            stop_interval_sequence: 3,
            start_stop_label: 'stop3X',
            end_stop_label: 'stop2X',
            distance_in_metres: 217330.59,
          },
        ]),
      );
    });

    it('test that draft priority stop point is included when selected so', async () => {
      const scheduledStopPoints = getScheduledStopPoints(30);

      const response = await getDistancesBetweenStopPoints(
        getTableDataToBePopulated(scheduledStopPoints),
        [journeyPatternId],
        new LocalDate('2044-05-02'),
        true,
      );

      expect(response.length).toEqual(3);

      expect(response).toEqual(
        expect.arrayContaining([
          {
            journey_pattern_id: journeyPatternId,
            route_id: routeId,
            stop_interval_sequence: 1,
            start_stop_label: 'stop1',
            end_stop_label: 'stop1X',
            distance_in_metres: 11021.92,
          },
          {
            journey_pattern_id: journeyPatternId,
            route_id: routeId,
            stop_interval_sequence: 2,
            start_stop_label: 'stop1X',
            end_stop_label: 'stop3X',
            distance_in_metres: 25466.08,
          },
          {
            journey_pattern_id: journeyPatternId,
            route_id: routeId,
            stop_interval_sequence: 3,
            start_stop_label: 'stop3X',
            end_stop_label: 'stop2X',
            distance_in_metres: 239606.24,
          },
        ]),
      );
    });
  });
});
