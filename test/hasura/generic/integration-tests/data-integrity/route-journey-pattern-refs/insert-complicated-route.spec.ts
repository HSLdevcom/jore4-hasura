import * as config from '@config';
import { route116TableConfig } from '@datasets-generic/route116';
import {
  journeyPatterns,
  scheduledStopPointInJourneyPattern,
} from '@datasets-generic/route116/journey-patterns';
import {
  infrastructureLinkAlongRoute,
  routes,
} from '@datasets-generic/route116/routes';
import '@util/matchers';
import { queryTable, setupDb } from '@util/setup';
import * as pg from 'pg';

describe('Inserting a complicated route', () => {
  let dbConnectionPool: pg.Pool;

  beforeAll(() => {
    dbConnectionPool = new pg.Pool(config.networkDbConfig);
  });

  afterAll(() => dbConnectionPool.end());

  beforeEach(() => setupDb(dbConnectionPool, route116TableConfig));

  it('should create the route correctly in the database', async () => {
    const routeResponse = await queryTable(
      dbConnectionPool,
      'route.route',
      route116TableConfig,
    );

    expect(routeResponse.rowCount).toEqual(routes.length);
    expect(routeResponse.rows).toEqual(expect.arrayContaining(routes));

    const infrastructureLinkAlongRouteResponse = await queryTable(
      dbConnectionPool,
      'route.infrastructure_link_along_route',
      route116TableConfig,
    );

    expect(infrastructureLinkAlongRouteResponse.rowCount).toEqual(
      infrastructureLinkAlongRoute.length,
    );
    expect(infrastructureLinkAlongRouteResponse.rows).toEqual(
      expect.arrayContaining(infrastructureLinkAlongRoute),
    );
  });

  it('should create the journey pattern correctly in the database', async () => {
    const journeyPatternResponse = await queryTable(
      dbConnectionPool,
      'journey_pattern.journey_pattern',
      route116TableConfig,
    );

    expect(journeyPatternResponse.rowCount).toEqual(journeyPatterns.length);
    expect(journeyPatternResponse.rows).toEqual(
      expect.arrayContaining(journeyPatterns),
    );

    const scheduledStopPointInJourneyPatternResponse = await queryTable(
      dbConnectionPool,
      'journey_pattern.scheduled_stop_point_in_journey_pattern',
      route116TableConfig,
    );

    expect(scheduledStopPointInJourneyPatternResponse.rowCount).toEqual(
      scheduledStopPointInJourneyPattern.length,
    );
    expect(scheduledStopPointInJourneyPatternResponse.rows).toEqual(
      expect.arrayContaining(scheduledStopPointInJourneyPattern),
    );
  });
});
