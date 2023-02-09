import * as config from '@config';
import { buildLocalizedString } from '@util/dataset';
import * as db from '@util/db';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import { nextDay, prevDay } from '@util/helpers';
import '@util/matchers';
import { setupDb } from '@util/setup';
import { randomUUID } from 'crypto';
import { Route, RouteDirection } from 'generic/networkdb/datasets/types';
import { DateTime } from 'luxon';

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
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(config.networkDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  const getMaximumPriorityValiditySpansOfRoutes = async (
    routeData: Partial<Route>[],
    routeLabel?: string,
    validityStart?: DateTime,
    validityEnd?: DateTime,
    upperPriorityLimit?: number,
  ) => {
    await setupDb(
      dbConnection,
      [
        {
          name: 'route.route',
          data: routeData,
        },
      ],
      true,
    );

    return db.singleQuery(
      dbConnection,
      `SELECT *
       FROM journey_pattern.maximum_priority_validity_spans('route', '{ "${
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

    const earlierRouteId = randomUUID();
    const laterRouteId = randomUUID();

    const earlierRouteValidityStart = DateTime.fromISO('2020-01-04');
    const earlierRouteValidityEnd = DateTime.fromISO('2021-04-04');
    const laterRouteValidityStart = DateTime.fromISO('2024-01-04');
    const laterRouteValidityEnd = DateTime.fromISO('2025-04-04');

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

    const earlierRouteValidityStart = DateTime.fromISO('2020-01-04');
    const earlierRouteValidityEnd = DateTime.fromISO('2021-04-04');
    const laterRouteValidityStart = nextDay(earlierRouteValidityEnd);
    const laterRouteValidityEnd = DateTime.fromISO('2025-04-04');

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

    const earlierLowerPrioRouteValidityStart = DateTime.fromISO('2020-01-04');
    const earlierLowerPrioRouteValidityEnd = DateTime.fromISO('2024-04-04');
    const laterHigherPrioRouteValidityStart = DateTime.fromISO('2021-04-05');
    const laterHigherPrioRouteValidityEnd = DateTime.fromISO('2025-04-04');

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

    const earlierLowerPrioRouteValidityStart = DateTime.fromISO('2020-01-04');
    const earlierLowerPrioRouteValidityEnd = DateTime.fromISO('2024-04-04');
    const laterHigherPrioRouteValidityStart = DateTime.fromISO('2023-04-05');
    const laterHigherPrioRouteValidityEnd = DateTime.fromISO('2025-04-04');

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
      DateTime.fromISO('2021-02-03'),
      DateTime.fromISO('2022-04-05'),
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

    const earlierLowerPrioRouteValidityStart = DateTime.fromISO('2020-01-04');
    const earlierLowerPrioRouteValidityEnd = DateTime.fromISO('2024-04-04');
    const laterHigherPrioRouteValidityStart = DateTime.fromISO('2021-04-05');
    const laterHigherPrioRouteValidityEnd = DateTime.fromISO('2025-04-04');

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

    const lowerPrioRouteValidityStart = DateTime.fromISO('2020-01-04');
    const lowerPrioRouteValidityEnd = DateTime.fromISO('2025-04-04');
    const higherPrioRouteValidityStart = DateTime.fromISO('2022-04-05');
    const higherPrioRouteValidityEnd = DateTime.fromISO('2024-04-04');

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

    const lowerPrioRouteValidityStart = DateTime.fromISO('2022-01-04');
    const lowerPrioRouteValidityEnd = DateTime.fromISO('2024-04-04');
    const higherPrioRouteValidityStart = DateTime.fromISO('2020-04-05');
    const higherPrioRouteValidityEnd = DateTime.fromISO('2025-04-04');

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

    const lowerPrioRouteValidityStart = DateTime.fromISO('2022-01-04');
    const lowerPrioRouteValidityEnd = DateTime.fromISO('2024-04-04');
    const higherPrioRouteValidityStart = DateTime.fromISO('2020-04-05');
    const higherPrioRouteValidityEnd = DateTime.fromISO('2025-04-04');

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
