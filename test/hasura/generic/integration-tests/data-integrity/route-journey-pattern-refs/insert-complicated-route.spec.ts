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
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import '@util/matchers';
import { queryTable, setupDb } from '@util/setup';

describe('Inserting a complicated route', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(config.networkDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  beforeEach(() => setupDb(dbConnection, route116TableConfig));

  it('should create the route correctly in the database', async () => {
    const routeResponse = await queryTable(
      dbConnection,
      'route.route',
      route116TableConfig,
    );

    expect(routeResponse.rowCount).toEqual(routes.length);
    expect(routeResponse.rows).toEqual(expect.arrayContaining(routes));

    const infrastructureLinkAlongRouteResponse = await queryTable(
      dbConnection,
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
      dbConnection,
      'journey_pattern.journey_pattern',
      route116TableConfig,
    );

    expect(journeyPatternResponse.rowCount).toEqual(journeyPatterns.length);
    expect(journeyPatternResponse.rows).toEqual(
      expect.arrayContaining(journeyPatterns),
    );

    const scheduledStopPointInJourneyPatternResponse = await queryTable(
      dbConnection,
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
