import * as rp from "request-promise";
import * as pg from "pg";
import * as config from "@config";
import * as dataset from "@util/dataset";
import {
  ScheduledStopPointInJourneyPattern,
  ScheduledStopPointInJourneyPatternProps,
} from "@datasets/types";
import "@util/matchers";
import { getPropNameArray, queryTable, setupDb } from "@datasets/setup";
import { expectErrorResponse } from "@util/response";
import { routesAndJourneyPatternsTableConfig } from "@datasets/routesAndJourneyPatterns";
import {
  journeyPatterns,
  scheduledStopPointInJourneyPattern,
} from "@datasets/routesAndJourneyPatterns/journey-patterns";

const buildMutation = (
  journeyPatternId: string,
  scheduledStopPointId: string,
  toBeUpdated: Partial<ScheduledStopPointInJourneyPattern>
) => `
  mutation {
    update_journey_pattern_scheduled_stop_point_in_journey_pattern(
      where: {
        _and: {
          journey_pattern_id: {_eq: "${journeyPatternId}"},
          scheduled_stop_point_id: {_eq: "${scheduledStopPointId}"}
        }
      },
      _set: ${dataset.toGraphQlObject(toBeUpdated)}
    ) {
      returning {
        ${getPropNameArray(ScheduledStopPointInJourneyPatternProps).join(",")}
      }
    }
  }
`;

describe("Update scheduled stop point in journey pattern", () => {
  let dbConnectionPool: pg.Pool;

  beforeAll(() => {
    dbConnectionPool = new pg.Pool(config.databaseConfig);
  });

  afterAll(() => dbConnectionPool.end());

  beforeEach(() =>
    setupDb(dbConnectionPool, routesAndJourneyPatternsTableConfig)
  );

  const shouldReturnErrorResponse = (
    scheduledStopPoint: ScheduledStopPointInJourneyPattern,
    toBeUpdated: Partial<ScheduledStopPointInJourneyPattern>,
    expectedErrorMsg: string
  ) =>
    it("should return error response", async () => {
      await rp
        .post({
          ...config.hasuraRequestTemplate,
          body: {
            query: buildMutation(
              scheduledStopPoint.journey_pattern_id,
              scheduledStopPoint.scheduled_stop_point_id,
              toBeUpdated
            ),
          },
        })
        .then(expectErrorResponse(expectedErrorMsg));
    });

  const shouldNotModifyDatabase = (
    scheduledStopPoint: ScheduledStopPointInJourneyPattern,
    toBeUpdated: Partial<ScheduledStopPointInJourneyPattern>
  ) =>
    it("should not modify the database", async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: {
          query: buildMutation(
            scheduledStopPoint.journey_pattern_id,
            scheduledStopPoint.scheduled_stop_point_id,
            toBeUpdated
          ),
        },
      });

      const response = await queryTable(
        dbConnectionPool,
        "journey_pattern.scheduled_stop_point_in_journey_pattern",
        routesAndJourneyPatternsTableConfig
      );

      expect(response.rowCount).toEqual(
        scheduledStopPointInJourneyPattern.length
      );
      expect(response.rows).toEqual(
        expect.arrayContaining(scheduledStopPointInJourneyPattern)
      );
    });

  describe("when stop is on a link not included in the route", () => {
    const toBeUpdated = {
      journey_pattern_id: journeyPatterns[0].journey_pattern_id,
      scheduled_stop_point_sequence: 150,
    };

    shouldReturnErrorResponse(
      scheduledStopPointInJourneyPattern[3],
      toBeUpdated,
      "route's and journey pattern's traversal paths must match each other"
    );

    shouldNotModifyDatabase(scheduledStopPointInJourneyPattern[3], toBeUpdated);
  });

  describe("when stop is inserted at a position which does not correspond to the stop's link's position in the route", () => {
    const toBeUpdated = {
      journey_pattern_id: journeyPatterns[0].journey_pattern_id,
      scheduled_stop_point_sequence: 450,
    };

    shouldReturnErrorResponse(
      scheduledStopPointInJourneyPattern[4],
      toBeUpdated,
      "route's and journey pattern's traversal paths must match each other"
    );

    shouldNotModifyDatabase(scheduledStopPointInJourneyPattern[3], toBeUpdated);
  });

  describe("without conflict", () => {
    const original = scheduledStopPointInJourneyPattern[4];
    const toBeUpdated = {
      journey_pattern_id: journeyPatterns[0].journey_pattern_id,
      scheduled_stop_point_sequence: 250,
    };
    const completeUpdated = {
      ...original,
      ...toBeUpdated,
    };

    it("should return correct response", async () => {
      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: {
          query: buildMutation(
            original.journey_pattern_id,
            original.scheduled_stop_point_id,
            toBeUpdated
          ),
        },
      });

      expect(response).toEqual(
        expect.objectContaining({
          data: {
            update_journey_pattern_scheduled_stop_point_in_journey_pattern: {
              returning: [completeUpdated],
            },
          },
        })
      );
    });

    it("should update the database", async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: {
          query: buildMutation(
            original.journey_pattern_id,
            original.scheduled_stop_point_id,
            toBeUpdated
          ),
        },
      });

      const response = await queryTable(
        dbConnectionPool,
        "journey_pattern.scheduled_stop_point_in_journey_pattern",
        routesAndJourneyPatternsTableConfig
      );

      expect(response.rowCount).toEqual(
        scheduledStopPointInJourneyPattern.length
      );
      expect(response.rows).toEqual(
        expect.arrayContaining([
          ...scheduledStopPointInJourneyPattern.filter(
            (scheduledStopPoint) =>
              scheduledStopPoint.journey_pattern_id !==
                original.journey_pattern_id ||
              scheduledStopPoint.scheduled_stop_point_id !==
                original.scheduled_stop_point_id
          ),
          completeUpdated,
        ])
      );
    });
  });
});
