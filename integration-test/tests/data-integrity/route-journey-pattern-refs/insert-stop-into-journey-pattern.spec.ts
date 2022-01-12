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
import { checkErrorResponse } from "@util/response";
import { routesAndJourneyPatternsTableConfig } from "@datasets/routesAndJourneyPatterns";
import {
  journeyPatterns,
  scheduledStopPointInJourneyPattern,
} from "@datasets/routesAndJourneyPatterns/journey-patterns";
import { scheduledStopPoints } from "@datasets/routesAndJourneyPatterns/scheduled-stop-points";

const createToBeInserted = (
  journeyPatternId: string,
  scheduledStopPointId: string,
  scheduledStopPointSequence: number
): ScheduledStopPointInJourneyPattern => ({
  journey_pattern_id: journeyPatternId,
  scheduled_stop_point_id: scheduledStopPointId,
  scheduled_stop_point_sequence: scheduledStopPointSequence,
  is_via_point: false,
  is_timing_point: false,
});

const buildMutation = (toBeInserted: ScheduledStopPointInJourneyPattern) => `
  mutation {
    insert_journey_pattern_scheduled_stop_point_in_journey_pattern(objects: ${dataset.toGraphQlObject(
      toBeInserted
    )}) {
      returning {
        ${getPropNameArray(ScheduledStopPointInJourneyPatternProps).join(",")}
      }
    }
  }
`;

describe("Insert scheduled stop point into journey pattern", () => {
  let dbConnectionPool: pg.Pool;

  beforeAll(() => {
    dbConnectionPool = new pg.Pool(config.databaseConfig);
  });

  afterAll(() => dbConnectionPool.end());

  beforeEach(() =>
    setupDb(dbConnectionPool, routesAndJourneyPatternsTableConfig)
  );

  const shouldReturnErrorResponse = (
    toBeInserted: ScheduledStopPointInJourneyPattern,
    expectedErrorMsg: string
  ) =>
    it("should return error response", async () => {
      await rp
        .post({
          ...config.hasuraRequestTemplate,
          body: { query: buildMutation(toBeInserted) },
        })
        .then(checkErrorResponse(expectedErrorMsg));
    });

  const shouldNotModifyDatabase = (
    toBeInserted: ScheduledStopPointInJourneyPattern
  ) =>
    it("should not modify the database", async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeInserted) },
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
    const toBeInserted = createToBeInserted(
      journeyPatterns[0].journey_pattern_id,
      scheduledStopPoints[3].scheduled_stop_point_id,
      150
    );

    shouldReturnErrorResponse(
      toBeInserted,
      "route's and journey pattern's traversal paths must match each other"
    );

    shouldNotModifyDatabase(toBeInserted);
  });

  describe("when stop is inserted at a position which does not correspond to the stop's link's position in the route", () => {
    const toBeInserted = createToBeInserted(
      journeyPatterns[0].journey_pattern_id,
      scheduledStopPoints[1].scheduled_stop_point_id,
      50
    );

    shouldReturnErrorResponse(
      toBeInserted,
      "route's and journey pattern's traversal paths must match each other"
    );

    shouldNotModifyDatabase(toBeInserted);
  });

  describe("when stop's link is traversed in a direction not matching the stop's direction", () => {
    const toBeInserted = createToBeInserted(
      journeyPatterns[0].journey_pattern_id,
      scheduledStopPoints[5].scheduled_stop_point_id,
      250
    );

    shouldReturnErrorResponse(
      toBeInserted,
      "route's and journey pattern's traversal paths must match each other"
    );

    shouldNotModifyDatabase(toBeInserted);
  });

  describe("without conflict", () => {
    const toBeInserted = createToBeInserted(
      journeyPatterns[0].journey_pattern_id,
      scheduledStopPoints[1].scheduled_stop_point_id,
      250
    );

    it("should return correct response", async () => {
      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeInserted) },
      });

      expect(response).toEqual(
        expect.objectContaining({
          data: {
            insert_journey_pattern_scheduled_stop_point_in_journey_pattern: {
              returning: [toBeInserted],
            },
          },
        })
      );
    });

    it("should update the database", async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeInserted) },
      });

      const response = await queryTable(
        dbConnectionPool,
        "journey_pattern.scheduled_stop_point_in_journey_pattern",
        routesAndJourneyPatternsTableConfig
      );

      expect(response.rowCount).toEqual(
        scheduledStopPointInJourneyPattern.length + 1
      );
      expect(response.rows).toEqual(
        expect.arrayContaining([
          ...scheduledStopPointInJourneyPattern,
          toBeInserted,
        ])
      );
    });
  });
});
