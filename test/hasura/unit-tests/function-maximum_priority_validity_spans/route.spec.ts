import * as pg from 'pg';
import * as config from '@config';
import '@util/matchers';
import {
  Route,
  RouteDirection,
  RouteProps,
  ScheduledStopPoint,
} from '@datasets/types';
import { setupDb } from '@datasets/setup';
import * as db from '@util/db';
import { randomUUID } from 'crypto';
import { buildLocalizedString } from '@datasets/factories';

const dummyLineId = randomUUID();
const defaultRouteLabel = 'route 1';

const defaultCommonRouteProps = {
  on_line_id: dummyLineId,
  label: defaultRouteLabel,
  direction: RouteDirection.Outbound,
  priority: 10,
  name_i18n: buildLocalizedString('route 1'),
};

describe('Function maximum_priority_validity_spans should return correct route rows', () => {
  let dbConnectionPool: pg.Pool;

  beforeAll(() => {
    dbConnectionPool = new pg.Pool(config.databaseConfig);
  });

  afterAll(() => dbConnectionPool.end());

  const getMaximumPriorityValiditySpansOfRoutes = async (
    routeData: Partial<Route>[],
    routeLabel?: string,
    validityStart?: Date,
    validityEnd?: Date,
    upperPriorityLimit?: number,
  ) => {
    await setupDb(
      dbConnectionPool,
      [
        {
          name: 'route.route',
          props: RouteProps,
          data: routeData,
        },
      ],
      true,
    );

    return await db.singleQuery(
      dbConnectionPool,
      `SELECT *
       FROM journey_pattern.maximum_priority_validity_spans('route', '{ "${
         routeLabel !== undefined ? routeLabel : defaultRouteLabel
       }" }', ${
        validityStart !== undefined
          ? "'" + validityStart.toISOString() + "'"
          : 'NULL'
      }, ${
        validityEnd !== undefined
          ? "'" + validityEnd.toISOString() + "'"
          : 'NULL'
      }, ${upperPriorityLimit !== undefined ? upperPriorityLimit : 'NULL'})`,
    );
  };

  it('when two instances are not adjacent', async () => {
    //   |---earlier---|
    //                       |----later----|
    //
    // expected result:
    //   |---earlier---|     |----later----|

    const earlierRouteId = randomUUID();
    const laterRouteId = randomUUID();

    const earlierRouteValidityStart = new Date('2020-01-04');
    const earlierRouteValidityEnd = new Date('2021-04-05');
    const laterRouteValidityStart = new Date('2024-01-04');
    const laterRouteValidityEnd = new Date('2025-04-05');

    const routeData: Partial<Route>[] = [
      {
        ...defaultCommonRouteProps,
        route_id: earlierRouteId,
        validity_start: earlierRouteValidityStart,
        validity_end: earlierRouteValidityEnd,
      },
      {
        ...defaultCommonRouteProps,
        route_id: laterRouteId,
        validity_start: laterRouteValidityStart,
        validity_end: laterRouteValidityEnd,
      },
    ];

    const response = await getMaximumPriorityValiditySpansOfRoutes(routeData);

    expect(response.rowCount).toEqual(2);

    expect(response.rows).toEqual(
      expect.arrayContaining([
        {
          id: earlierRouteId,
          validity_start: earlierRouteValidityStart,
          validity_end: earlierRouteValidityEnd,
        },
        {
          id: laterRouteId,
          validity_start: laterRouteValidityStart,
          validity_end: laterRouteValidityEnd,
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

    const earlierRouteId = randomUUID();
    const laterRouteId = randomUUID();

    const earlierRouteValidityStart = new Date('2020-01-04');
    const earlierRouteValidityEnd = new Date('2021-04-05');
    const laterRouteValidityStart = earlierRouteValidityEnd;
    const laterRouteValidityEnd = new Date('2025-04-05');

    const routeData: Partial<Route>[] = [
      {
        ...defaultCommonRouteProps,
        route_id: earlierRouteId,
        validity_start: earlierRouteValidityStart,
        validity_end: earlierRouteValidityEnd,
      },
      {
        ...defaultCommonRouteProps,
        route_id: laterRouteId,
        validity_start: laterRouteValidityStart,
        validity_end: laterRouteValidityEnd,
      },
    ];

    const response = await getMaximumPriorityValiditySpansOfRoutes(routeData);

    expect(response.rows).toEqual(
      expect.arrayContaining([
        {
          id: earlierRouteId,
          validity_start: earlierRouteValidityStart,
          validity_end: earlierRouteValidityEnd,
        },
        {
          id: laterRouteId,
          validity_start: laterRouteValidityStart,
          validity_end: laterRouteValidityEnd,
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

    const earlierLowerPrioRouteId = randomUUID();
    const laterHigherPrioRouteId = randomUUID();

    const earlierLowerPrioRouteValidityStart = new Date('2020-01-04');
    const earlierLowerPrioRouteValidityEnd = new Date('2024-04-05');
    const laterHigherPrioRouteValidityStart = new Date('2021-04-05');
    const laterHigherPrioRouteValidityEnd = new Date('2025-04-05');

    const routeData: Partial<Route>[] = [
      {
        ...defaultCommonRouteProps,
        route_id: earlierLowerPrioRouteId,
        priority: 10,
        validity_start: earlierLowerPrioRouteValidityStart,
        validity_end: earlierLowerPrioRouteValidityEnd,
      },
      {
        ...defaultCommonRouteProps,
        route_id: laterHigherPrioRouteId,
        priority: 20,
        validity_start: laterHigherPrioRouteValidityStart,
        validity_end: laterHigherPrioRouteValidityEnd,
      },
    ];

    const response = await getMaximumPriorityValiditySpansOfRoutes(routeData);

    expect(response.rowCount).toEqual(2);

    expect(response.rows).toEqual(
      expect.arrayContaining([
        {
          id: earlierLowerPrioRouteId,
          validity_start: earlierLowerPrioRouteValidityStart,
          validity_end: laterHigherPrioRouteValidityStart, // sic
        },
        {
          id: laterHigherPrioRouteId,
          validity_start: laterHigherPrioRouteValidityStart,
          validity_end: laterHigherPrioRouteValidityEnd,
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

    const earlierLowerPrioRouteId = randomUUID();
    const laterHigherPrioRouteId = randomUUID();

    const earlierLowerPrioRouteValidityStart = new Date('2020-01-04');
    const earlierLowerPrioRouteValidityEnd = new Date('2024-04-05');
    const laterHigherPrioRouteValidityStart = new Date('2023-04-05');
    const laterHigherPrioRouteValidityEnd = new Date('2025-04-05');

    const routeData: Partial<Route>[] = [
      {
        ...defaultCommonRouteProps,
        route_id: earlierLowerPrioRouteId,
        priority: 10,
        validity_start: earlierLowerPrioRouteValidityStart,
        validity_end: earlierLowerPrioRouteValidityEnd,
      },
      {
        ...defaultCommonRouteProps,
        route_id: laterHigherPrioRouteId,
        priority: 20,
        validity_start: laterHigherPrioRouteValidityStart,
        validity_end: laterHigherPrioRouteValidityEnd,
      },
    ];

    const response = await getMaximumPriorityValiditySpansOfRoutes(
      routeData,
      undefined,
      new Date('2021-02-03'),
      new Date('2022-04-05'),
    );

    expect(response.rowCount).toEqual(1);

    expect(response.rows).toEqual(
      expect.arrayContaining([
        {
          id: earlierLowerPrioRouteId,
          validity_start: earlierLowerPrioRouteValidityStart,
          validity_end: earlierLowerPrioRouteValidityEnd,
        },
      ]),
    );
  });

  it('when higher prio instance is filtered out by route label', async () => {
    //   |--low prio----|
    //   |  label: A    |
    //                |---high prio---|
    //                |  label B      |
    //
    // expected result for label A:
    //   |--low prio----|
    //   |  label: A    |

    const earlierLowerPrioRouteId = randomUUID();
    const laterHigherPrioRouteId = randomUUID();

    const earlierLowerPrioRouteValidityStart = new Date('2020-01-04');
    const earlierLowerPrioRouteValidityEnd = new Date('2024-04-05');
    const laterHigherPrioRouteValidityStart = new Date('2021-04-05');
    const laterHigherPrioRouteValidityEnd = new Date('2025-04-05');

    const routeData: Partial<Route>[] = [
      {
        ...defaultCommonRouteProps,
        route_id: earlierLowerPrioRouteId,
        priority: 10,
        validity_start: earlierLowerPrioRouteValidityStart,
        validity_end: earlierLowerPrioRouteValidityEnd,
      },
      {
        ...defaultCommonRouteProps,
        route_id: laterHigherPrioRouteId,
        label: 'otherRoute',
        priority: 20,
        validity_start: laterHigherPrioRouteValidityStart,
        validity_end: laterHigherPrioRouteValidityEnd,
      },
    ];

    const response = await getMaximumPriorityValiditySpansOfRoutes(routeData);

    expect(response.rowCount).toEqual(1);

    expect(response.rows).toEqual(
      expect.arrayContaining([
        {
          id: earlierLowerPrioRouteId,
          validity_start: earlierLowerPrioRouteValidityStart,
          validity_end: earlierLowerPrioRouteValidityEnd,
        },
      ]),
    );
  });

  it('when a higher prio instance is covering a lower prio instance partly', async () => {
    //   |-----------------low prio-----------------|
    //                |---high prio---|
    //
    // expected result:
    //   |--low prio--|---high prio---|--low prio---|

    const lowerPrioRouteId = randomUUID();
    const higherPrioRouteId = randomUUID();

    const lowerPrioRouteValidityStart = new Date('2020-01-04');
    const lowerPrioRouteValidityEnd = new Date('2025-04-05');
    const higherPrioRouteValidityStart = new Date('2022-04-05');
    const higherPrioRouteValidityEnd = new Date('2024-04-05');

    const routeData: Partial<Route>[] = [
      {
        ...defaultCommonRouteProps,
        route_id: lowerPrioRouteId,
        priority: 10,
        validity_start: lowerPrioRouteValidityStart,
        validity_end: lowerPrioRouteValidityEnd,
      },
      {
        ...defaultCommonRouteProps,
        route_id: higherPrioRouteId,
        priority: 20,
        validity_start: higherPrioRouteValidityStart,
        validity_end: higherPrioRouteValidityEnd,
      },
    ];

    const response = await getMaximumPriorityValiditySpansOfRoutes(routeData);

    expect(response.rowCount).toEqual(3);

    expect(response.rows).toEqual(
      expect.arrayContaining([
        {
          id: lowerPrioRouteId,
          validity_start: lowerPrioRouteValidityStart,
          validity_end: higherPrioRouteValidityStart,
        },
        {
          id: higherPrioRouteId,
          validity_start: higherPrioRouteValidityStart,
          validity_end: higherPrioRouteValidityEnd,
        },
        {
          id: lowerPrioRouteId,
          validity_start: higherPrioRouteValidityEnd,
          validity_end: lowerPrioRouteValidityEnd,
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

    const lowerPrioRouteId = randomUUID();
    const higherPrioRouteId = randomUUID();

    const lowerPrioRouteValidityStart = new Date('2022-01-04');
    const lowerPrioRouteValidityEnd = new Date('2024-04-05');
    const higherPrioRouteValidityStart = new Date('2020-04-05');
    const higherPrioRouteValidityEnd = new Date('2025-04-05');

    const routeData: Partial<Route>[] = [
      {
        ...defaultCommonRouteProps,
        route_id: lowerPrioRouteId,
        priority: 10,
        validity_start: lowerPrioRouteValidityStart,
        validity_end: lowerPrioRouteValidityEnd,
      },
      {
        ...defaultCommonRouteProps,
        route_id: higherPrioRouteId,
        priority: 20,
        validity_start: higherPrioRouteValidityStart,
        validity_end: higherPrioRouteValidityEnd,
      },
    ];

    const response = await getMaximumPriorityValiditySpansOfRoutes(routeData);

    expect(response.rowCount).toEqual(1);

    expect(response.rows).toEqual(
      expect.arrayContaining([
        {
          id: higherPrioRouteId,
          validity_start: higherPrioRouteValidityStart,
          validity_end: higherPrioRouteValidityEnd,
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

    const lowerPrioRouteId = randomUUID();
    const higherPrioRouteId = randomUUID();

    const lowerPrioRouteValidityStart = new Date('2022-01-04');
    const lowerPrioRouteValidityEnd = new Date('2024-04-05');
    const higherPrioRouteValidityStart = new Date('2020-04-05');
    const higherPrioRouteValidityEnd = new Date('2025-04-05');

    const routeData: Partial<Route>[] = [
      {
        ...defaultCommonRouteProps,
        route_id: lowerPrioRouteId,
        priority: 10,
        validity_start: lowerPrioRouteValidityStart,
        validity_end: lowerPrioRouteValidityEnd,
      },
      {
        ...defaultCommonRouteProps,
        route_id: higherPrioRouteId,
        priority: 20,
        validity_start: higherPrioRouteValidityStart,
        validity_end: higherPrioRouteValidityEnd,
      },
    ];

    const response = await getMaximumPriorityValiditySpansOfRoutes(
      routeData,
      defaultRouteLabel,
      undefined,
      undefined,
      20,
    );

    expect(response.rowCount).toEqual(1);

    expect(response.rows).toEqual(
      expect.arrayContaining([
        {
          id: lowerPrioRouteId,
          validity_start: lowerPrioRouteValidityStart,
          validity_end: lowerPrioRouteValidityEnd,
        },
      ]),
    );
  });
});