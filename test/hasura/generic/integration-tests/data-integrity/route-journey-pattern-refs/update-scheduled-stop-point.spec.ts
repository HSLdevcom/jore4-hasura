import * as config from '@config';
import { routesAndJourneyPatternsTableConfig } from '@datasets-generic/routesAndJourneyPatterns';
import { infrastructureLinks } from '@datasets-generic/routesAndJourneyPatterns/infrastructure-links';
import { scheduledStopPoints } from '@datasets-generic/routesAndJourneyPatterns/scheduled-stop-points';
import { scheduledStopPointProps } from '@datasets-generic/types';
import * as dataset from '@util/dataset';
import { serializeMatcherInputs } from '@util/dataset';
import '@util/matchers';
import { expectErrorResponse } from '@util/response';
import { getPropNameArray, queryTable, setupDb } from '@util/setup';
import * as pg from 'pg';
import * as rp from 'request-promise';

const buildChangeInfralinkMutation = (
  scheduledStopPointId: string,
  newInfraLinkId: string,
) => `
  mutation {
    update_service_pattern_scheduled_stop_point(where: {
        scheduled_stop_point_id: {_eq: "${scheduledStopPointId}"}
      },
      _set: {
        located_on_infrastructure_link_id: "${newInfraLinkId}"
      }
    ) {
      returning {
        ${getPropNameArray(scheduledStopPointProps).join(',')}
      }
    }
  }
`;

const buildChangeTimingPlaceMutation = (
  scheduledStopPointId: string,
  newTimingPlaceId: string | null,
) => `
  mutation {
    update_service_pattern_scheduled_stop_point(where: {
        scheduled_stop_point_id: {_eq: "${scheduledStopPointId}"}
      },
      _set: {
        timing_place_id: ${newTimingPlaceId ? `"${newTimingPlaceId}"` : null}
      }
    ) {
      returning {
        ${getPropNameArray(scheduledStopPointProps).join(',')}
      }
    }
  }
`;

describe('Move scheduled stop point to other infra link', () => {
  let dbConnectionPool: pg.Pool;

  beforeAll(() => {
    dbConnectionPool = new pg.Pool(config.networkDbConfig);
  });

  afterAll(() => dbConnectionPool.end());

  beforeEach(() =>
    setupDb(dbConnectionPool, routesAndJourneyPatternsTableConfig),
  );

  const shouldReturnErrorResponse = (
    scheduledStopPointId: string,
    newInfraLinkId: string,
    expectedErrorMsg: string,
  ) =>
    it('should return error response', async () => {
      await rp
        .post({
          ...config.hasuraRequestTemplate,
          body: {
            query: buildChangeInfralinkMutation(
              scheduledStopPointId,
              newInfraLinkId,
            ),
          },
        })
        .then(expectErrorResponse(expectedErrorMsg));
    });

  const shouldNotModifyDatabase = (
    scheduledStopPointId: string,
    newInfraLinkId: string,
  ) =>
    it('should not modify the database', async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: {
          query: buildChangeInfralinkMutation(
            scheduledStopPointId,
            newInfraLinkId,
          ),
        },
      });

      const response = await queryTable(
        dbConnectionPool,
        'service_pattern.scheduled_stop_point',
        routesAndJourneyPatternsTableConfig,
      );

      expect(response.rowCount).toEqual(scheduledStopPoints.length);
      expect(response.rows).toEqual(
        expect.arrayContaining(serializeMatcherInputs(scheduledStopPoints)),
      );
    });

  describe("when new link is not part of all of the stop's journey patterns' routes", () => {
    shouldReturnErrorResponse(
      scheduledStopPoints[1].scheduled_stop_point_id,
      infrastructureLinks[3].infrastructure_link_id,
      "route's and journey pattern's traversal paths must match each other",
    );

    shouldNotModifyDatabase(
      scheduledStopPoints[1].scheduled_stop_point_id,
      infrastructureLinks[3].infrastructure_link_id,
    );
  });

  describe("when new link is not at the correct position in all of the stop's journey patterns' routes", () => {
    shouldReturnErrorResponse(
      scheduledStopPoints[6].scheduled_stop_point_id,
      infrastructureLinks[6].infrastructure_link_id,
      "route's and journey pattern's traversal paths must match each other",
    );

    shouldNotModifyDatabase(
      scheduledStopPoints[6].scheduled_stop_point_id,
      infrastructureLinks[6].infrastructure_link_id,
    );
  });

  describe("when new link is traversed in a direction not allowed as the stop's direction", () => {
    shouldReturnErrorResponse(
      scheduledStopPoints[0].scheduled_stop_point_id,
      infrastructureLinks[1].infrastructure_link_id,
      "route's and journey pattern's traversal paths must match each other",
    );

    shouldNotModifyDatabase(
      scheduledStopPoints[0].scheduled_stop_point_id,
      infrastructureLinks[1].infrastructure_link_id,
    );
  });

  describe('without conflict', () => {
    const toBeMoved = scheduledStopPoints[8];
    const newInfraLinkId = infrastructureLinks[6].infrastructure_link_id;
    const completeUpdated = {
      ...toBeMoved,
      located_on_infrastructure_link_id: newInfraLinkId,
    };

    it('should return correct response', async () => {
      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: {
          query: buildChangeInfralinkMutation(
            toBeMoved.scheduled_stop_point_id,
            newInfraLinkId,
          ),
        },
      });

      expect(response).toEqual(
        expect.objectContaining({
          data: {
            update_service_pattern_scheduled_stop_point: {
              returning: [dataset.asGraphQlDateObject(completeUpdated)],
            },
          },
        }),
      );
    });

    it('should update the database', async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: {
          query: buildChangeInfralinkMutation(
            toBeMoved.scheduled_stop_point_id,
            newInfraLinkId,
          ),
        },
      });

      const response = await queryTable(
        dbConnectionPool,
        'service_pattern.scheduled_stop_point',
        routesAndJourneyPatternsTableConfig,
      );

      expect(response.rowCount).toEqual(scheduledStopPoints.length);
      expect(response.rows).toEqual(
        expect.arrayContaining(
          serializeMatcherInputs([
            ...scheduledStopPoints.filter(
              (stopPoint) =>
                stopPoint.scheduled_stop_point_id !==
                toBeMoved.scheduled_stop_point_id,
            ),
            completeUpdated,
          ]),
        ),
      );
    });
  });
});

describe('Change scheduled stop point timing place', () => {
  let dbConnectionPool: pg.Pool;

  beforeAll(() => {
    dbConnectionPool = new pg.Pool(config.networkDbConfig);
  });

  afterAll(() => dbConnectionPool.end());

  beforeEach(() =>
    setupDb(dbConnectionPool, routesAndJourneyPatternsTableConfig),
  );

  const shouldReturnErrorResponse = (
    scheduledStopPointId: string,
    newTimingPlaceId: string | null,
    expectedErrorMsg: string,
  ) =>
    it('should return error response', async () => {
      await rp
        .post({
          ...config.hasuraRequestTemplate,
          body: {
            query: buildChangeTimingPlaceMutation(
              scheduledStopPointId,
              newTimingPlaceId,
            ),
          },
        })
        .then(expectErrorResponse(expectedErrorMsg));
    });

  const shouldNotModifyDatabase = (
    scheduledStopPointId: string,
    newTimingPlaceId: string | null,
  ) =>
    it('should not modify the database', async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: {
          query: buildChangeTimingPlaceMutation(
            scheduledStopPointId,
            newTimingPlaceId,
          ),
        },
      });

      const response = await queryTable(
        dbConnectionPool,
        'service_pattern.scheduled_stop_point',
        routesAndJourneyPatternsTableConfig,
      );

      expect(response.rowCount).toEqual(scheduledStopPoints.length);
      expect(response.rows).toEqual(
        expect.arrayContaining(serializeMatcherInputs(scheduledStopPoints)),
      );
    });

  describe("when stop is used as timing point in a journey pattern and stop's timing place is set to null", () => {
    shouldReturnErrorResponse(
      scheduledStopPoints[0].scheduled_stop_point_id,
      null,
      'scheduled stop point must have a timing place attached if it is used as a timing point in a journey pattern',
    );

    shouldNotModifyDatabase(
      scheduledStopPoints[0].scheduled_stop_point_id,
      null,
    );
  });

  describe('when stop is not used as timing point in any journey pattern and timing place is set to null', () => {
    const toBeChanged = scheduledStopPoints[7];
    const newTimingPlaceId = null;
    const completeUpdated = {
      ...toBeChanged,
      timing_place_id: newTimingPlaceId,
    };

    it('should return correct response', async () => {
      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: {
          query: buildChangeTimingPlaceMutation(
            toBeChanged.scheduled_stop_point_id,
            newTimingPlaceId,
          ),
        },
      });

      expect(response).toEqual(
        expect.objectContaining({
          data: {
            update_service_pattern_scheduled_stop_point: {
              returning: [dataset.asGraphQlDateObject(completeUpdated)],
            },
          },
        }),
      );
    });

    it('should update the database', async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: {
          query: buildChangeTimingPlaceMutation(
            toBeChanged.scheduled_stop_point_id,
            newTimingPlaceId,
          ),
        },
      });

      const response = await queryTable(
        dbConnectionPool,
        'service_pattern.scheduled_stop_point',
        routesAndJourneyPatternsTableConfig,
      );

      expect(response.rowCount).toEqual(scheduledStopPoints.length);
      expect(response.rows).toEqual(
        expect.arrayContaining(
          serializeMatcherInputs([
            ...scheduledStopPoints.filter(
              (stopPoint) =>
                stopPoint.scheduled_stop_point_id !==
                toBeChanged.scheduled_stop_point_id,
            ),
            completeUpdated,
          ]),
        ),
      );
    });
  });
});
