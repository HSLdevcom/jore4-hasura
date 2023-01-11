import * as config from '@config';
import { buildLocalizedString } from '@datasets-generic/factories';
import { setupDb } from '@datasets-generic/setup';
import { Route, RouteDirection, RouteProps } from '@datasets-generic/types';
import * as db from '@util/db';
import { nextDay, prevDay } from '@util/helpers';
import '@util/matchers';
import { randomUUID } from 'crypto';
import { LocalDate } from 'local-date';
import * as pg from 'pg';

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
    validityStart?: LocalDate,
    validityEnd?: LocalDate,
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

    return db.singleQuery(
      dbConnectionPool,
      `SELECT *
       FROM journey_pattern.maximum_priority_validity_spans('route', '{ "${
         routeLabel !== undefined ? routeLabel : defaultRouteLabel
       }" }', ${
        validityStart !== undefined
          ? `'${validityStart.toISOString()}'`
          : 'NULL'
      }, ${
        validityEnd !== undefined ? `'${validityEnd.toISOString()}'` : 'NULL'
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

    const earlierRouteValidityStart = new LocalDate('2020-01-04');
    const earlierRouteValidityEnd = new LocalDate('2021-04-04');
    const laterRouteValidityStart = new LocalDate('2024-01-04');
    const laterRouteValidityEnd = new LocalDate('2025-04-04');

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

    const earlierRouteValidityStart = new LocalDate('2020-01-04');
    const earlierRouteValidityEnd = new LocalDate('2021-04-04');
    const laterRouteValidityStart = nextDay(earlierRouteValidityEnd);
    const laterRouteValidityEnd = new LocalDate('2025-04-04');

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

    const earlierLowerPrioRouteValidityStart = new LocalDate('2020-01-04');
    const earlierLowerPrioRouteValidityEnd = new LocalDate('2024-04-04');
    const laterHigherPrioRouteValidityStart = new LocalDate('2021-04-05');
    const laterHigherPrioRouteValidityEnd = new LocalDate('2025-04-04');

    const routeData: Partial<Route>[] = [
      {
        ...defaultCommonRouteProps,
        route_id: earlierLowerPrioRouteId,
        priority: 10,
        validity_start: earlierLowerPrioRouteValidityStart,
        validity_end: prevDay(earlierLowerPrioRouteValidityEnd),
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
          validity_end: prevDay(laterHigherPrioRouteValidityStart), // sic
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

    const earlierLowerPrioRouteValidityStart = new LocalDate('2020-01-04');
    const earlierLowerPrioRouteValidityEnd = new LocalDate('2024-04-04');
    const laterHigherPrioRouteValidityStart = new LocalDate('2023-04-05');
    const laterHigherPrioRouteValidityEnd = new LocalDate('2025-04-04');

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
      new LocalDate('2021-02-03'),
      new LocalDate('2022-04-05'),
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

    const earlierLowerPrioRouteValidityStart = new LocalDate('2020-01-04');
    const earlierLowerPrioRouteValidityEnd = new LocalDate('2024-04-04');
    const laterHigherPrioRouteValidityStart = new LocalDate('2021-04-05');
    const laterHigherPrioRouteValidityEnd = new LocalDate('2025-04-04');

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

    const lowerPrioRouteValidityStart = new LocalDate('2020-01-04');
    const lowerPrioRouteValidityEnd = new LocalDate('2025-04-04');
    const higherPrioRouteValidityStart = new LocalDate('2022-04-05');
    const higherPrioRouteValidityEnd = new LocalDate('2024-04-04');

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
          validity_end: prevDay(higherPrioRouteValidityStart),
        },
        {
          id: higherPrioRouteId,
          validity_start: higherPrioRouteValidityStart,
          validity_end: higherPrioRouteValidityEnd,
        },
        {
          id: lowerPrioRouteId,
          validity_start: nextDay(higherPrioRouteValidityEnd),
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

    const lowerPrioRouteValidityStart = new LocalDate('2022-01-04');
    const lowerPrioRouteValidityEnd = new LocalDate('2024-04-04');
    const higherPrioRouteValidityStart = new LocalDate('2020-04-05');
    const higherPrioRouteValidityEnd = new LocalDate('2025-04-04');

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

    const lowerPrioRouteValidityStart = new LocalDate('2022-01-04');
    const lowerPrioRouteValidityEnd = new LocalDate('2024-04-04');
    const higherPrioRouteValidityStart = new LocalDate('2020-04-05');
    const higherPrioRouteValidityEnd = new LocalDate('2025-04-04');

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
