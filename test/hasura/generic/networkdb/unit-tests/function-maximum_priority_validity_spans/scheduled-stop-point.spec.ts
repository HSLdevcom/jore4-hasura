import { networkDbConfig } from '@config';
import { buildLocalizedString } from '@util/dataset';
import {
  closeDbConnection,
  createDbConnection,
  DbConnection,
  singleQuery,
} from '@util/db';
import { setupDb } from '@util/setup';
import {
  InfrastructureLink,
  JourneyPattern,
  LinkDirection,
  Route,
  RouteDirection,
  ScheduledStopPoint,
} from 'generic/networkdb/datasets/types';
import { DateTime } from 'luxon';
import { v4 as uuidv4 } from 'uuid';

const defaultRouteLabel = 'route 2';
const stopLabel = 'stop A';
const infraLinkId = uuidv4();

const defaultCommonStopProps: Partial<ScheduledStopPoint> = {
  located_on_infrastructure_link_id: infraLinkId,
  direction: LinkDirection.Backward,
  measured_location: {
    type: 'Point',
    coordinates: [24.79994288646075, 60.17599917802331, 0],
    crs: {
      properties: { name: 'urn:ogc:def:crs:EPSG::4326' },
      type: 'name',
    },
  },
  label: stopLabel,
  priority: 10,
};

const route: Partial<Route> = {
  route_id: uuidv4(),
  on_line_id: uuidv4(),
  label: defaultRouteLabel,
  direction: RouteDirection.Outbound,
  priority: 10,
  validity_start: DateTime.fromISO('2018-01-02'),
  validity_end: DateTime.fromISO('2027-01-01'),
  name_i18n: buildLocalizedString('route 1'),
};

const journeyPattern: Partial<JourneyPattern> = {
  journey_pattern_id: uuidv4(),
  on_route_id: route.route_id,
};

const infraLink: Partial<InfrastructureLink> = {
  infrastructure_link_id: infraLinkId,
  direction: LinkDirection.Forward,
  shape: {
    type: 'LineString',
    crs: {
      type: 'name',
      properties: {
        name: 'urn:ogc:def:crs:EPSG::4326',
      },
    },
    coordinates: [
      [12.1, 11.2, 0],
      [12.3, 10.1, 0],
    ],
  },
  external_link_source: 'digiroad_r',
  external_link_id: '1',
};

describe('Function maximum_priority_validity_spans should return correct scheduled stop point rows', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(networkDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  const getMaximumPriorityValiditySpansOfStops = async (
    stopData: Partial<ScheduledStopPoint>[],
    routeLabel?: string,
    validityStart?: DateTime,
    validityEnd?: DateTime,
    upperPriorityLimit?: number,
  ) => {
    await setupDb(
      dbConnection,
      [
        {
          // infra link is needed, since it is used by the service_pattern.scheduled_stop_point view
          name: 'infrastructure_network.infrastructure_link',
          data: [infraLink],
        },
        {
          name: 'service_pattern.scheduled_stop_point',
          data: stopData,
        },
        // the scheduled stop points are filtered by route label, and because of this we have to
        // establish the connection: route -> journey pattern -> journey pattern in ssp -> ssp
        {
          name: 'route.route',
          data: [route],
        },
        {
          name: 'journey_pattern.journey_pattern',
          data: [journeyPattern],
        },
        {
          name: 'journey_pattern.scheduled_stop_point_in_journey_pattern',
          data: stopData.map((stop, index) => ({
            journey_pattern_id: journeyPattern.journey_pattern_id,
            scheduled_stop_point_label: stop.label,
            scheduled_stop_point_sequence: index,
            is_used_as_timing_point: false,
            is_loading_time_allowed: false,
            is_regulated_timing_point: false,
            is_via_point: false,
          })),
        },
      ],
      true,
    );

    return singleQuery(
      dbConnection,
      `SELECT *
       FROM journey_pattern.maximum_priority_validity_spans('scheduled_stop_point', '{ "${
         routeLabel !== undefined ? routeLabel : defaultRouteLabel
       }" }', ${
         validityStart !== undefined ? `'${validityStart.toISODate()}'` : 'NULL'
       }, ${
         validityEnd !== undefined ? `'${validityEnd.toISODate()}'` : 'NULL'
       }, ${upperPriorityLimit !== undefined ? upperPriorityLimit : 'NULL'})`,
    );
  };

  it('when two instances are not adjacent', async () => {
    //   |---earlier---|
    //                       |----later----|
    //
    // expected result:
    //   |---earlier---|     |----later----|

    const earlierStopId = uuidv4();
    const laterStopId = uuidv4();

    const earlierStopValidityStart = DateTime.fromISO('2020-01-04');
    const earlierStopValidityEnd = DateTime.fromISO('2021-04-05');
    const laterStopValidityStart = DateTime.fromISO('2024-01-04');
    const laterStopValidityEnd = DateTime.fromISO('2025-04-05');

    const stopData: Partial<ScheduledStopPoint>[] = [
      {
        ...defaultCommonStopProps,
        scheduled_stop_point_id: earlierStopId,
        validity_start: earlierStopValidityStart,
        validity_end: earlierStopValidityEnd,
      },
      {
        ...defaultCommonStopProps,
        scheduled_stop_point_id: laterStopId,
        validity_start: laterStopValidityStart,
        validity_end: laterStopValidityEnd,
      },
    ];

    const response = await getMaximumPriorityValiditySpansOfStops(stopData);

    expect(response.rowCount).toEqual(2);

    expect(response.rows).toEqual(
      expect.arrayContaining([
        {
          id: earlierStopId,
          validity_start: earlierStopValidityStart,
          validity_end: earlierStopValidityEnd,
        },
        {
          id: laterStopId,
          validity_start: laterStopValidityStart,
          validity_end: laterStopValidityEnd,
        },
      ]),
    );
  });

  it('when two instances are adjacent', async () => {
    //   |---earlier---|
    //                 |----later----|
    //
    // expected result:
    //   |---earlier---|----later----|

    const earlierStopId = uuidv4();
    const laterStopId = uuidv4();

    const earlierStopValidityStart = DateTime.fromISO('2020-01-04');
    const earlierStopValidityEnd = DateTime.fromISO('2021-04-05');
    const laterStopValidityStart = earlierStopValidityEnd.plus({ day: 1 });
    const laterStopValidityEnd = DateTime.fromISO('2025-04-05');

    const stopData: Partial<ScheduledStopPoint>[] = [
      {
        ...defaultCommonStopProps,
        scheduled_stop_point_id: earlierStopId,
        validity_start: earlierStopValidityStart,
        validity_end: earlierStopValidityEnd,
      },
      {
        ...defaultCommonStopProps,
        scheduled_stop_point_id: laterStopId,
        validity_start: laterStopValidityStart,
        validity_end: laterStopValidityEnd,
      },
    ];

    const response = await getMaximumPriorityValiditySpansOfStops(stopData);

    expect(response.rows).toEqual(
      expect.arrayContaining([
        {
          id: earlierStopId,
          validity_start: earlierStopValidityStart,
          validity_end: earlierStopValidityEnd,
        },
        {
          id: laterStopId,
          validity_start: laterStopValidityStart,
          validity_end: laterStopValidityEnd,
        },
      ]),
    );
  });

  it('when two instances are overlapping', async () => {
    //   |--low prio----|
    //                |---high prio---|
    //
    // expected result:
    //   |--low prio--|---high prio---|

    const earlierLowerPrioStopId = uuidv4();
    const laterHigherPrioStopId = uuidv4();

    const earlierLowerPrioStopValidityStart = DateTime.fromISO('2020-01-04');
    const earlierLowerPrioStopValidityEnd = DateTime.fromISO('2024-04-05');
    const laterHigherPrioStopValidityStart = DateTime.fromISO('2021-04-05');
    const laterHigherPrioStopValidityEnd = DateTime.fromISO('2025-04-05');

    const stopData: Partial<ScheduledStopPoint>[] = [
      {
        ...defaultCommonStopProps,
        scheduled_stop_point_id: earlierLowerPrioStopId,
        priority: 10,
        validity_start: earlierLowerPrioStopValidityStart,
        validity_end: earlierLowerPrioStopValidityEnd,
      },
      {
        ...defaultCommonStopProps,
        scheduled_stop_point_id: laterHigherPrioStopId,
        priority: 20,
        validity_start: laterHigherPrioStopValidityStart,
        validity_end: laterHigherPrioStopValidityEnd,
      },
    ];

    const response = await getMaximumPriorityValiditySpansOfStops(stopData);

    expect(response.rowCount).toEqual(2);

    expect(response.rows).toEqual(
      expect.arrayContaining([
        {
          id: earlierLowerPrioStopId,
          validity_start: earlierLowerPrioStopValidityStart,
          validity_end: laterHigherPrioStopValidityStart.minus({ day: 1 }), // sic
        },
        {
          id: laterHigherPrioStopId,
          validity_start: laterHigherPrioStopValidityStart,
          validity_end: laterHigherPrioStopValidityEnd,
        },
      ]),
    );
  });

  it('when two instances are overlapping and the higher prio instance is filtered out by validity time', async () => {
    //   |--low prio----|
    //                |---high prio---|
    //
    // expected result:
    //   |--low prio----|

    const earlierLowerPrioStopId = uuidv4();
    const laterHigherPrioStopId = uuidv4();

    const earlierLowerPrioStopValidityStart = DateTime.fromISO('2020-01-04');
    const earlierLowerPrioStopValidityEnd = DateTime.fromISO('2024-04-05');
    const laterHigherPrioStopValidityStart = DateTime.fromISO('2023-04-05');
    const laterHigherPrioStopValidityEnd = DateTime.fromISO('2025-04-05');

    const stopData: Partial<ScheduledStopPoint>[] = [
      {
        ...defaultCommonStopProps,
        scheduled_stop_point_id: earlierLowerPrioStopId,
        priority: 10,
        validity_start: earlierLowerPrioStopValidityStart,
        validity_end: earlierLowerPrioStopValidityEnd,
      },
      {
        ...defaultCommonStopProps,
        scheduled_stop_point_id: laterHigherPrioStopId,
        priority: 20,
        validity_start: laterHigherPrioStopValidityStart,
        validity_end: laterHigherPrioStopValidityEnd,
      },
    ];

    const response = await getMaximumPriorityValiditySpansOfStops(
      stopData,
      undefined,
      DateTime.fromISO('2021-02-03'),
      DateTime.fromISO('2022-04-05'),
    );

    expect(response.rowCount).toEqual(1);

    expect(response.rows).toEqual(
      expect.arrayContaining([
        {
          id: earlierLowerPrioStopId,
          validity_start: earlierLowerPrioStopValidityStart,
          validity_end: earlierLowerPrioStopValidityEnd,
        },
      ]),
    );
  });

  it('when both instances are filtered out by route label', async () => {
    //   |--low prio----|
    //   |  label: A    |
    //                |---high prio---|
    //                |  label A      |
    //
    // expected result for label B:
    // (empty)

    const earlierLowerPrioStopId = uuidv4();
    const laterHigherPrioStopId = uuidv4();

    const earlierLowerPrioStopValidityStart = DateTime.fromISO('2020-01-04');
    const earlierLowerPrioStopValidityEnd = DateTime.fromISO('2024-04-05');
    const laterHigherPrioStopValidityStart = DateTime.fromISO('2021-04-05');
    const laterHigherPrioStopValidityEnd = DateTime.fromISO('2025-04-05');

    const stopData: Partial<ScheduledStopPoint>[] = [
      {
        ...defaultCommonStopProps,
        scheduled_stop_point_id: earlierLowerPrioStopId,
        priority: 10,
        validity_start: earlierLowerPrioStopValidityStart,
        validity_end: earlierLowerPrioStopValidityEnd,
      },
      {
        ...defaultCommonStopProps,
        scheduled_stop_point_id: laterHigherPrioStopId,
        priority: 20,
        validity_start: laterHigherPrioStopValidityStart,
        validity_end: laterHigherPrioStopValidityEnd,
      },
    ];

    const response = await getMaximumPriorityValiditySpansOfStops(
      stopData,
      'doesNotExist',
    );

    expect(response.rowCount).toEqual(0);

    expect(response.rows).toEqual([]);
  });

  it('when a higher prio instance is covering a lower prio instance partly', async () => {
    //   |-----------------low prio-----------------|
    //                |---high prio---|
    //
    // expected result:
    //   |--low prio--|---high prio---|--low prio---|

    const lowerPrioStopId = uuidv4();
    const higherPrioStopId = uuidv4();

    const lowerPrioStopValidityStart = DateTime.fromISO('2020-01-04');
    const lowerPrioStopValidityEnd = DateTime.fromISO('2025-04-05');
    const higherPrioStopValidityStart = DateTime.fromISO('2022-04-05');
    const higherPrioStopValidityEnd = DateTime.fromISO('2024-04-05');

    const stopData: Partial<ScheduledStopPoint>[] = [
      {
        ...defaultCommonStopProps,
        scheduled_stop_point_id: lowerPrioStopId,
        priority: 10,
        validity_start: lowerPrioStopValidityStart,
        validity_end: lowerPrioStopValidityEnd,
      },
      {
        ...defaultCommonStopProps,
        scheduled_stop_point_id: higherPrioStopId,
        priority: 20,
        validity_start: higherPrioStopValidityStart,
        validity_end: higherPrioStopValidityEnd,
      },
    ];

    const response = await getMaximumPriorityValiditySpansOfStops(stopData);

    expect(response.rowCount).toEqual(3);

    expect(response.rows).toEqual(
      expect.arrayContaining([
        {
          id: lowerPrioStopId,
          validity_start: lowerPrioStopValidityStart,
          validity_end: higherPrioStopValidityStart.minus({ day: 1 }),
        },
        {
          id: higherPrioStopId,
          validity_start: higherPrioStopValidityStart,
          validity_end: higherPrioStopValidityEnd,
        },
        {
          id: lowerPrioStopId,
          validity_start: higherPrioStopValidityEnd.plus({ day: 1 }),
          validity_end: lowerPrioStopValidityEnd,
        },
      ]),
    );
  });

  it('when a higher prio instance is covering a lower prio instance completely', async () => {
    //                |---low prio----|
    //   |----------------high prio-----------------|
    //
    // expected result:
    //   |----------------high prio-----------------|

    const lowerPrioStopId = uuidv4();
    const higherPrioStopId = uuidv4();

    const lowerPrioStopValidityStart = DateTime.fromISO('2022-01-04');
    const lowerPrioStopValidityEnd = DateTime.fromISO('2024-04-05');
    const higherPrioStopValidityStart = DateTime.fromISO('2020-04-05');
    const higherPrioStopValidityEnd = DateTime.fromISO('2025-04-05');

    const stopData: Partial<ScheduledStopPoint>[] = [
      {
        ...defaultCommonStopProps,
        scheduled_stop_point_id: lowerPrioStopId,
        priority: 10,
        validity_start: lowerPrioStopValidityStart,
        validity_end: lowerPrioStopValidityEnd,
      },
      {
        ...defaultCommonStopProps,
        scheduled_stop_point_id: higherPrioStopId,
        priority: 20,
        validity_start: higherPrioStopValidityStart,
        validity_end: higherPrioStopValidityEnd,
      },
    ];

    const response = await getMaximumPriorityValiditySpansOfStops(stopData);

    expect(response.rowCount).toEqual(1);

    expect(response.rows).toEqual(
      expect.arrayContaining([
        {
          id: higherPrioStopId,
          validity_start: higherPrioStopValidityStart,
          validity_end: higherPrioStopValidityEnd,
        },
      ]),
    );
  });

  it('when a higher prio instance, which is covering a lower prio instance completely, is filtered out by priority limit', async () => {
    //                |---prio: 10----|
    //   |----------------prio: 20-----------------|
    //
    // expected result for priority < 20:
    //                |---prio: 10----|

    const lowerPrioStopId = uuidv4();
    const higherPrioStopId = uuidv4();

    const lowerPrioStopValidityStart = DateTime.fromISO('2022-01-04');
    const lowerPrioStopValidityEnd = DateTime.fromISO('2024-04-05');
    const higherPrioStopValidityStart = DateTime.fromISO('2020-04-05');
    const higherPrioStopValidityEnd = DateTime.fromISO('2025-04-05');

    const stopData: Partial<ScheduledStopPoint>[] = [
      {
        ...defaultCommonStopProps,
        scheduled_stop_point_id: lowerPrioStopId,
        priority: 10,
        validity_start: lowerPrioStopValidityStart,
        validity_end: lowerPrioStopValidityEnd,
      },
      {
        ...defaultCommonStopProps,
        scheduled_stop_point_id: higherPrioStopId,
        priority: 20,
        validity_start: higherPrioStopValidityStart,
        validity_end: higherPrioStopValidityEnd,
      },
    ];

    const response = await getMaximumPriorityValiditySpansOfStops(
      stopData,
      undefined,
      undefined,
      undefined,
      20,
    );

    expect(response.rowCount).toEqual(1);

    expect(response.rows).toEqual(
      expect.arrayContaining([
        {
          id: lowerPrioStopId,
          validity_start: lowerPrioStopValidityStart,
          validity_end: lowerPrioStopValidityEnd,
        },
      ]),
    );
  });
});
