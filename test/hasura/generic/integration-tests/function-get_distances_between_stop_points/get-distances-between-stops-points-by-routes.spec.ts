import * as config from '@config';
import { routesAndJourneyPatternsTableConfig as baseTableConfig } from '@datasets-generic/routesAndJourneyPatterns';
import { journeyPatterns } from '@datasets-generic/routesAndJourneyPatterns/journey-patterns';
import { scheduledStopPoints as sourceScheduledStopPoints } from '@datasets-generic/routesAndJourneyPatterns/scheduled-stop-points';
import {
  ScheduledStopPoint,
  VehicleMode,
  VehicleModeOnScheduledStopPoint,
} from '@datasets-generic/types';
import * as db from '@util/db';
import { setupDb } from '@util/setup';
import { LocalDate } from 'local-date';
import * as pg from 'pg';

describe('Function service_pattern.get_distances_between_stop_points_by_routes', () => {
  let dbConnectionPool: pg.Pool;

  beforeAll(() => {
    dbConnectionPool = new pg.Pool(config.networkDbConfig);
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
    routeIds: string[],
    observationDate: LocalDate,
  ): Promise<Array<StopIntervalLength>> => {
    await setupDb(dbConnectionPool, dataset);

    const response = await db.singleQuery(
      dbConnectionPool,
      `SELECT * FROM service_pattern.get_distances_between_stop_points_by_routes('{${routeIds}}'::uuid[], '${observationDate.toISOString()}'::date)`,
    );

    return response.rows.map((row: ExplicitAny) => {
      // Round the distances to two decimal places.
      return {
        ...row,
        distance_in_metres: roundToTwoDecimalPlaces(row.distance_in_metres),
      };
    });
  };

  it('with two routes', async () => {
    const journeyPattern = journeyPatterns[0];
    const journeyPattern2 = journeyPatterns[2];

    const routeId = journeyPattern.on_route_id;
    const routeId2 = journeyPattern2.on_route_id;

    const observationDate = new LocalDate('2044-05-02');

    const response = await getDistancesBetweenStopPoints(
      getTableDataToBePopulated(),
      [routeId, routeId2],
      observationDate,
    );

    expect(response.length).toEqual(5);

    expect(response).toEqual(
      expect.arrayContaining([
        {
          journey_pattern_id: journeyPattern.journey_pattern_id,
          route_id: routeId,
          route_priority: 10,
          observation_date: observationDate,
          stop_interval_sequence: 1,
          start_stop_label: 'stop1',
          end_stop_label: 'stop3',
          distance_in_metres: 69886.66,
        },
        {
          journey_pattern_id: journeyPattern.journey_pattern_id,
          route_id: routeId,
          route_priority: 10,
          observation_date: observationDate,
          stop_interval_sequence: 2,
          start_stop_label: 'stop3',
          end_stop_label: 'stop2',
          distance_in_metres: 211598.51,
        },
        {
          journey_pattern_id: journeyPattern2.journey_pattern_id,
          route_id: routeId2,
          route_priority: 10,
          observation_date: observationDate,
          stop_interval_sequence: 1,
          start_stop_label: 'stop1',
          end_stop_label: 'stop1X',
          distance_in_metres: 11022.01,
        },
        {
          journey_pattern_id: journeyPattern2.journey_pattern_id,
          route_id: routeId2,
          route_priority: 10,
          observation_date: observationDate,
          stop_interval_sequence: 2,
          start_stop_label: 'stop1X',
          end_stop_label: 'stop3X',
          distance_in_metres: 47741.93,
        },
        {
          journey_pattern_id: journeyPattern2.journey_pattern_id,
          route_id: routeId2,
          route_priority: 10,
          observation_date: observationDate,
          stop_interval_sequence: 3,
          start_stop_label: 'stop3X',
          end_stop_label: 'stop2X',
          distance_in_metres: 217270.56,
        },
      ]),
    );
  });
});
