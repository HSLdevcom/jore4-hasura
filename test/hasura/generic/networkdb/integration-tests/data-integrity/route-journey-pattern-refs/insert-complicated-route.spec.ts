import * as config from '@config';
import { DbConnection, closeDbConnection, createDbConnection } from '@util/db';
import { queryTable, setupDb } from '@util/setup';
import {
  infrastructureLinkAlongRoute,
  journeyPatterns,
  route116TableConfig,
  routes,
  scheduledStopPointInJourneyPattern,
} from 'generic/networkdb/datasets/route116';
import { genericNetworkDbSchema } from 'generic/networkdb/datasets/schema';

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
      genericNetworkDbSchema['route.route'],
    );

    expect(routeResponse.rowCount).toEqual(routes.length);
    expect(routeResponse.rows).toEqual(expect.arrayContaining(routes));

    const infrastructureLinkAlongRouteResponse = await queryTable(
      dbConnection,
      genericNetworkDbSchema['route.infrastructure_link_along_route'],
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
      genericNetworkDbSchema['journey_pattern.journey_pattern'],
    );

    expect(journeyPatternResponse.rowCount).toEqual(journeyPatterns.length);
    expect(journeyPatternResponse.rows).toEqual(
      expect.arrayContaining(journeyPatterns),
    );

    const scheduledStopPointInJourneyPatternResponse = await queryTable(
      dbConnection,
      genericNetworkDbSchema[
        'journey_pattern.scheduled_stop_point_in_journey_pattern'
      ],
    );

    expect(scheduledStopPointInJourneyPatternResponse.rowCount).toEqual(
      scheduledStopPointInJourneyPattern.length,
    );
    expect(scheduledStopPointInJourneyPatternResponse.rows).toEqual(
      expect.arrayContaining(scheduledStopPointInJourneyPattern),
    );
  });
});
