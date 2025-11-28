import { DateTime } from 'luxon';
import * as config from '@config';
import * as db from '@util/db';
import { DbConnection, closeDbConnection, createDbConnection } from '@util/db';
import { setupDb } from '@util/setup';
import {
  routesAndJourneyPatternsTableData as baseTableConfig,
  journeyPatterns,
  infrastructureLinks as sourceInfrastructureLinks,
  scheduledStopPoints as sourceScheduledStopPoints,
} from 'generic/networkdb/datasets/routesAndJourneyPatterns';
import { GenericNetworkDbTables } from 'generic/networkdb/datasets/schema';
import {
  InfrastructureLink,
  ScheduledStopPoint,
  VehicleMode,
  VehicleModeOnScheduledStopPoint,
  VehicleSubmode,
  VehicleSubmodeOnInfrastructureLink,
} from 'generic/networkdb/datasets/types';

describe('Function service_pattern.get_distances_between_stop_points_in_journey_patterns', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(config.networkDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  // Nullify estimated lengths for all infrastructure links.
  const baseInfrastructureLinks: InfrastructureLink[] =
    sourceInfrastructureLinks.map((il) => {
      return {
        ...il,
        estimated_length_in_metres: null,
      };
    });

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
    infrastructureLinks: InfrastructureLink[] = baseInfrastructureLinks,
  ): TableData<GenericNetworkDbTables>[] => {
    const tableConfig = [...baseTableConfig];

    const scheduledStopPointsIndex = baseTableConfig.findIndex((elem) => {
      return elem.name === 'service_pattern.scheduled_stop_point';
    });

    const vehicleModeOnStopPointIndex = baseTableConfig.findIndex((elem) => {
      return (
        elem.name === 'service_pattern.vehicle_mode_on_scheduled_stop_point'
      );
    });

    const infrastructureLinksIndex = baseTableConfig.findIndex((elem) => {
      return elem.name === 'infrastructure_network.infrastructure_link';
    });

    const vehicleSubModeOnInfrastructureLinksIndex = baseTableConfig.findIndex(
      (elem) => {
        return (
          elem.name ===
          'infrastructure_network.vehicle_submode_on_infrastructure_link'
        );
      },
    );

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

    // Override infrastructure links in base dataset.
    tableConfig[infrastructureLinksIndex].data = infrastructureLinks;

    const vehicleSubmodes: VehicleSubmodeOnInfrastructureLink[] =
      infrastructureLinks.map((il) => {
        return {
          infrastructure_link_id: il.infrastructure_link_id,
          vehicle_submode: VehicleSubmode.GenericBus,
        };
      });

    // Override vehicle sub-modes (on infrastructure links) in base dataset.
    tableConfig[vehicleSubModeOnInfrastructureLinksIndex].data =
      vehicleSubmodes;

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
    dataset: TableData<GenericNetworkDbTables>[],
    journeyPatternIds: string[],
    observationDate: DateTime,
    includeDraftStopPoints = false,
  ): Promise<Array<StopIntervalLength>> => {
    await setupDb(dbConnection, dataset);

    const response = await db.singleQuery(
      dbConnection,
      `SELECT * FROM service_pattern.get_distances_between_stop_points_in_journey_patterns('{${journeyPatternIds}}'::uuid[], '${observationDate.toISODate()}'::date, ${includeDraftStopPoints})`,
    );

    return response.rows.map((row: ExplicitAny) => {
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

    const observationDate = DateTime.fromISO('2044-05-02');

    const response = await getDistancesBetweenStopPoints(
      getTableDataToBePopulated(),
      [journeyPatternId],
      observationDate,
    );

    expect(response.length).toEqual(3);

    expect(response).toEqual(
      expect.arrayContaining([
        {
          journey_pattern_id: journeyPatternId,
          route_id: routeId,
          route_priority: 10,
          observation_date: observationDate,
          stop_interval_sequence: 1,
          start_stop_label: 'stop1',
          end_stop_label: 'stop1X',
          distance_in_metres: 11021.92,
        },
        {
          journey_pattern_id: journeyPatternId,
          route_id: routeId,
          route_priority: 10,
          observation_date: observationDate,
          stop_interval_sequence: 2,
          start_stop_label: 'stop1X',
          end_stop_label: 'stop3X',
          distance_in_metres: 47741.72,
        },
        {
          journey_pattern_id: journeyPatternId,
          route_id: routeId,
          route_priority: 10,
          observation_date: observationDate,
          stop_interval_sequence: 3,
          start_stop_label: 'stop3X',
          end_stop_label: 'stop2X',
          distance_in_metres: 217330.08,
        },
      ]),
    );
  });

  it('with two journey patterns', async () => {
    const journeyPattern = journeyPatterns[0];
    const journeyPattern2 = journeyPatterns[2];

    const journeyPatternId = journeyPattern.journey_pattern_id;
    const journeyPatternId2 = journeyPattern2.journey_pattern_id;

    const observationDate = DateTime.fromISO('2044-05-02');

    const response = await getDistancesBetweenStopPoints(
      getTableDataToBePopulated(),
      [journeyPatternId, journeyPatternId2],
      observationDate,
    );

    expect(response.length).toEqual(5);

    expect(response).toEqual(
      expect.arrayContaining([
        {
          journey_pattern_id: journeyPatternId,
          route_id: journeyPattern.on_route_id,
          route_priority: 10,
          observation_date: observationDate,
          stop_interval_sequence: 1,
          start_stop_label: 'stop1',
          end_stop_label: 'stop3',
          distance_in_metres: 69886.32,
        },
        {
          journey_pattern_id: journeyPatternId,
          route_id: journeyPattern.on_route_id,
          route_priority: 10,
          observation_date: observationDate,
          stop_interval_sequence: 2,
          start_stop_label: 'stop3',
          end_stop_label: 'stop2',
          distance_in_metres: 211718.14,
        },
        {
          journey_pattern_id: journeyPatternId2,
          route_id: journeyPattern2.on_route_id,
          route_priority: 10,
          observation_date: observationDate,
          stop_interval_sequence: 1,
          start_stop_label: 'stop1',
          end_stop_label: 'stop1X',
          distance_in_metres: 11021.92,
        },
        {
          journey_pattern_id: journeyPatternId2,
          route_id: journeyPattern2.on_route_id,
          route_priority: 10,
          observation_date: observationDate,
          stop_interval_sequence: 2,
          start_stop_label: 'stop1X',
          end_stop_label: 'stop3X',
          distance_in_metres: 47741.72,
        },
        {
          journey_pattern_id: journeyPatternId2,
          route_id: journeyPattern2.on_route_id,
          route_priority: 10,
          observation_date: observationDate,
          stop_interval_sequence: 3,
          start_stop_label: 'stop3X',
          end_stop_label: 'stop2X',
          distance_in_metres: 217330.08,
        },
      ]),
    );
  });

  describe('test correct handling of link vs. stop point directionality', () => {
    const observationDate = DateTime.fromISO('2044-05-02');

    it('...case 1', async () => {
      const journeyPattern = journeyPatterns[4];
      const journeyPatternId = journeyPattern.journey_pattern_id;
      const routeId = journeyPattern.on_route_id;

      const response = await getDistancesBetweenStopPoints(
        getTableDataToBePopulated(),
        [journeyPatternId],
        observationDate,
      );

      expect(response.length).toEqual(2);

      expect(response).toEqual(
        expect.arrayContaining([
          {
            journey_pattern_id: journeyPatternId,
            route_id: routeId,
            route_priority: 10,
            observation_date: observationDate,
            stop_interval_sequence: 1,
            start_stop_label: 'stop5X',
            end_stop_label: 'stop3X',
            distance_in_metres: 90023.07,
          },
          {
            journey_pattern_id: journeyPatternId,
            route_id: routeId,
            route_priority: 10,
            observation_date: observationDate,
            stop_interval_sequence: 2,
            start_stop_label: 'stop3X',
            end_stop_label: 'stop6X',
            distance_in_metres: 101123.29,
          },
        ]),
      );
    });

    it('...case 2', async () => {
      const journeyPattern = journeyPatterns[5];
      const journeyPatternId = journeyPattern.journey_pattern_id;
      const routeId = journeyPattern.on_route_id;

      const response = await getDistancesBetweenStopPoints(
        getTableDataToBePopulated(),
        [journeyPatternId],
        observationDate,
      );

      expect(response.length).toEqual(2);

      expect(response).toEqual(
        expect.arrayContaining([
          {
            journey_pattern_id: journeyPatternId,
            route_id: routeId,
            route_priority: 10,
            observation_date: observationDate,
            stop_interval_sequence: 1,
            start_stop_label: 'stop3X',
            end_stop_label: 'stop5X',
            distance_in_metres: 84424.24,
          },
          {
            journey_pattern_id: journeyPatternId,
            route_id: routeId,
            route_priority: 10,
            observation_date: observationDate,
            stop_interval_sequence: 2,
            start_stop_label: 'stop5X',
            end_stop_label: 'stop3',
            distance_in_metres: 101145.74,
          },
        ]),
      );
    });
  });

  describe('test that multiple stop points are allocated for correct traversals of single infrastructure link', () => {
    const observationDate = DateTime.fromISO('2044-05-02');

    it('...when traversing the link forwards', async () => {
      const journeyPattern = journeyPatterns[7];
      const journeyPatternId = journeyPattern.journey_pattern_id;
      const routeId = journeyPattern.on_route_id;

      const response = await getDistancesBetweenStopPoints(
        getTableDataToBePopulated(),
        [journeyPatternId],
        observationDate,
      );

      expect(response.length).toEqual(2);

      expect(response).toEqual(
        expect.arrayContaining([
          {
            journey_pattern_id: journeyPatternId,
            route_id: routeId,
            route_priority: 10,
            observation_date: observationDate,
            stop_interval_sequence: 1,
            start_stop_label: 'stop5X',
            end_stop_label: 'stop6X',
            distance_in_metres: 16699.05,
          },
          {
            journey_pattern_id: journeyPatternId,
            route_id: routeId,
            route_priority: 10,
            observation_date: observationDate,
            stop_interval_sequence: 2,
            start_stop_label: 'stop6X',
            end_stop_label: 'stop5X',
            distance_in_metres: 70524.61,
          },
        ]),
      );
    });

    it('...when traversing the link backwards', async () => {
      const journeyPattern = journeyPatterns[6];
      const journeyPatternId = journeyPattern.journey_pattern_id;
      const routeId = journeyPattern.on_route_id;

      const response = await getDistancesBetweenStopPoints(
        getTableDataToBePopulated(),
        [journeyPatternId],
        observationDate,
      );

      expect(response.length).toEqual(2);

      expect(response).toEqual(
        expect.arrayContaining([
          {
            journey_pattern_id: journeyPatternId,
            route_id: routeId,
            route_priority: 10,
            observation_date: observationDate,
            stop_interval_sequence: 1,
            start_stop_label: 'stop3X',
            end_stop_label: 'stop3',
            distance_in_metres: 11122.68,
          },
          {
            journey_pattern_id: journeyPatternId,
            route_id: routeId,
            route_priority: 10,
            observation_date: observationDate,
            stop_interval_sequence: 2,
            start_stop_label: 'stop3',
            end_stop_label: 'stop3X',
            distance_in_metres: 76100.98,
          },
        ]),
      );
    });
  });

  describe('test scheduled stop point priority overriding', () => {
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
        scheduled_stop_point_id: crypto.randomUUID(),
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

    const observationDate = DateTime.fromISO('2044-05-02');

    it('...when higher priority stop point overrides the one with lower priority', async () => {
      const scheduledStopPoints = getScheduledStopPoints(20);

      const response = await getDistancesBetweenStopPoints(
        getTableDataToBePopulated(scheduledStopPoints),
        [journeyPatternId],
        observationDate,
      );

      expect(response.length).toEqual(3);

      expect(response).toEqual(
        expect.arrayContaining([
          {
            journey_pattern_id: journeyPatternId,
            route_id: routeId,
            route_priority: 10,
            observation_date: observationDate,
            stop_interval_sequence: 1,
            start_stop_label: 'stop1',
            end_stop_label: 'stop1X',
            distance_in_metres: 11021.92,
          },
          {
            journey_pattern_id: journeyPatternId,
            route_id: routeId,
            route_priority: 10,
            observation_date: observationDate,
            stop_interval_sequence: 2,
            start_stop_label: 'stop1X',
            end_stop_label: 'stop3X',
            distance_in_metres: 25466.08,
          },
          {
            journey_pattern_id: journeyPatternId,
            route_id: routeId,
            route_priority: 10,
            observation_date: observationDate,
            stop_interval_sequence: 3,
            start_stop_label: 'stop3X',
            end_stop_label: 'stop2X',
            distance_in_metres: 239605.73,
          },
        ]),
      );
    });

    it('...when draft priority stop points are ignored when not selected', async () => {
      const scheduledStopPoints = getScheduledStopPoints(30);

      const response = await getDistancesBetweenStopPoints(
        getTableDataToBePopulated(scheduledStopPoints),
        [journeyPatternId],
        observationDate,
      );

      expect(response.length).toEqual(3);

      expect(response).toEqual(
        expect.arrayContaining([
          {
            journey_pattern_id: journeyPatternId,
            route_id: routeId,
            route_priority: 10,
            observation_date: observationDate,
            stop_interval_sequence: 1,
            start_stop_label: 'stop1',
            end_stop_label: 'stop1X',
            distance_in_metres: 11021.92,
          },
          {
            journey_pattern_id: journeyPatternId,
            route_id: routeId,
            route_priority: 10,
            observation_date: observationDate,
            stop_interval_sequence: 2,
            start_stop_label: 'stop1X',
            end_stop_label: 'stop3X',
            distance_in_metres: 47741.72,
          },
          {
            journey_pattern_id: journeyPatternId,
            route_id: routeId,
            route_priority: 10,
            observation_date: observationDate,
            stop_interval_sequence: 3,
            start_stop_label: 'stop3X',
            end_stop_label: 'stop2X',
            distance_in_metres: 217330.08,
          },
        ]),
      );
    });

    it('...when draft priority stop point is included when selected so', async () => {
      const scheduledStopPoints = getScheduledStopPoints(30);

      const response = await getDistancesBetweenStopPoints(
        getTableDataToBePopulated(scheduledStopPoints),
        [journeyPatternId],
        observationDate,
        true,
      );

      expect(response.length).toEqual(3);

      expect(response).toEqual(
        expect.arrayContaining([
          {
            journey_pattern_id: journeyPatternId,
            route_id: routeId,
            route_priority: 10,
            observation_date: observationDate,
            stop_interval_sequence: 1,
            start_stop_label: 'stop1',
            end_stop_label: 'stop1X',
            distance_in_metres: 11021.92,
          },
          {
            journey_pattern_id: journeyPatternId,
            route_id: routeId,
            route_priority: 10,
            observation_date: observationDate,
            stop_interval_sequence: 2,
            start_stop_label: 'stop1X',
            end_stop_label: 'stop3X',
            distance_in_metres: 25466.08,
          },
          {
            journey_pattern_id: journeyPatternId,
            route_id: routeId,
            route_priority: 10,
            observation_date: observationDate,
            stop_interval_sequence: 3,
            start_stop_label: 'stop3X',
            end_stop_label: 'stop2X',
            distance_in_metres: 239605.73,
          },
        ]),
      );
    });
  });

  describe('test handling of estimated length for infrastructure link', () => {
    const journeyPattern = journeyPatterns[2];
    const journeyPatternId = journeyPattern.journey_pattern_id;
    const routeId = journeyPattern.on_route_id;

    // Makes a copy of baseInfrastructureLinks array and sets estimated length for one link based on parameters.
    const getInfrastructureLinks = (
      linkIndex: number,
      estimatedLength: number,
    ): InfrastructureLink[] => {
      const infrastructureLinks: InfrastructureLink[] = [];
      baseInfrastructureLinks.forEach((il) =>
        infrastructureLinks.push({ ...il }),
      );

      const affectedLink: InfrastructureLink = infrastructureLinks[linkIndex];
      affectedLink.estimated_length_in_metres = estimatedLength;

      return infrastructureLinks;
    };

    const observationDate = DateTime.fromISO('2044-05-02');

    it('...when single stop point resides along a link with estimated length', async () => {
      const response = await getDistancesBetweenStopPoints(
        getTableDataToBePopulated(
          baseScheduledStopPoints,
          getInfrastructureLinks(1, 1000.0),
        ),
        [journeyPatternId],
        observationDate,
      );

      expect(response.length).toEqual(3);

      expect(response).toEqual(
        expect.arrayContaining([
          {
            journey_pattern_id: journeyPatternId,
            route_id: routeId,
            route_priority: 10,
            observation_date: observationDate,
            stop_interval_sequence: 1,
            start_stop_label: 'stop1',
            end_stop_label: 'stop1X',
            distance_in_metres: 11021.92,
          },
          {
            journey_pattern_id: journeyPatternId,
            route_id: routeId,
            route_priority: 10,
            observation_date: observationDate,
            stop_interval_sequence: 2,
            start_stop_label: 'stop1X',
            end_stop_label: 'stop3X',
            distance_in_metres: 5995.01,
          },
          {
            journey_pattern_id: journeyPatternId,
            route_id: routeId,
            route_priority: 10,
            observation_date: observationDate,
            stop_interval_sequence: 3,
            start_stop_label: 'stop3X',
            end_stop_label: 'stop2X',
            distance_in_metres: 172853.14,
          },
        ]),
      );
    });

    it('...when two stop points reside along a link with estimated length', async () => {
      const response = await getDistancesBetweenStopPoints(
        getTableDataToBePopulated(
          baseScheduledStopPoints,
          getInfrastructureLinks(0, 1000.0),
        ),
        [journeyPatternId],
        observationDate,
      );

      expect(response.length).toEqual(3);

      expect(response).toEqual(
        expect.arrayContaining([
          {
            journey_pattern_id: journeyPatternId,
            route_id: routeId,
            route_priority: 10,
            observation_date: observationDate,
            stop_interval_sequence: 1,
            start_stop_label: 'stop1',
            end_stop_label: 'stop1X',
            distance_in_metres: 500.0,
          },
          {
            journey_pattern_id: journeyPatternId,
            route_id: routeId,
            route_priority: 10,
            observation_date: observationDate,
            stop_interval_sequence: 2,
            start_stop_label: 'stop1X',
            end_stop_label: 'stop3X',
            distance_in_metres: 42480.87,
          },
          {
            journey_pattern_id: journeyPatternId,
            route_id: routeId,
            route_priority: 10,
            observation_date: observationDate,
            stop_interval_sequence: 3,
            start_stop_label: 'stop3X',
            end_stop_label: 'stop2X',
            distance_in_metres: 217330.08,
          },
        ]),
      );
    });

    it('...when setting estimated length for link with no stop points on journey pattern', async () => {
      const response = await getDistancesBetweenStopPoints(
        getTableDataToBePopulated(
          baseScheduledStopPoints,
          getInfrastructureLinks(4, 1000.0),
        ),
        [journeyPatternId],
        observationDate,
      );

      expect(response.length).toEqual(3);

      expect(response).toEqual(
        expect.arrayContaining([
          {
            journey_pattern_id: journeyPatternId,
            route_id: routeId,
            route_priority: 10,
            observation_date: observationDate,
            stop_interval_sequence: 1,
            start_stop_label: 'stop1',
            end_stop_label: 'stop1X',
            distance_in_metres: 11021.92,
          },
          {
            journey_pattern_id: journeyPatternId,
            route_id: routeId,
            route_priority: 10,
            observation_date: observationDate,
            stop_interval_sequence: 2,
            start_stop_label: 'stop1X',
            end_stop_label: 'stop3X',
            distance_in_metres: 47741.72,
          },
          {
            journey_pattern_id: journeyPatternId,
            route_id: routeId,
            route_priority: 10,
            observation_date: observationDate,
            stop_interval_sequence: 3,
            start_stop_label: 'stop3X',
            end_stop_label: 'stop2X',
            distance_in_metres: 162967.93,
          },
        ]),
      );
    });
  });
});
