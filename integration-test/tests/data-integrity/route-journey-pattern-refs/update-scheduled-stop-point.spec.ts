import * as rp from "request-promise";
import * as pg from "pg";
import * as config from "@config";
import { ScheduledStopPointProps } from "@datasets/types";
import "@util/matchers";
import { getPropNameArray, queryTable, setupDb } from "@datasets/setup";
import { checkErrorResponse } from "@util/response";
import { routesAndJourneyPatternsTableConfig } from "@datasets/routesAndJourneyPatterns";
import { scheduledStopPoints } from "@datasets/routesAndJourneyPatterns/scheduled-stop-points";
import { infrastructureLinks } from "@datasets/routesAndJourneyPatterns/infrastructure-links";
import { asDbGeometryObjectArray } from "@util/dataset";
import * as dataset from "@util/dataset";

const createMutation = (
  scheduledStopPointId: string,
  newInfraLinkId: string
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
        ${getPropNameArray(ScheduledStopPointProps).join(",")}
      }
    }
  }
`;

describe("Move scheduled stop point to other infra link", () => {
  let dbConnectionPool: pg.Pool;

  beforeAll(() => {
    dbConnectionPool = new pg.Pool(config.databaseConfig);
  });

  afterAll(() => dbConnectionPool.end());

  beforeEach(() =>
    setupDb(dbConnectionPool, routesAndJourneyPatternsTableConfig)
  );

  const shouldReturnErrorResponse = (
    scheduledStopPointId: string,
    newInfraLinkId: string,
    expectedErrorMsg: string
  ) =>
    it("should return error response", async () => {
      await rp
        .post({
          ...config.hasuraRequestTemplate,
          body: {
            query: createMutation(scheduledStopPointId, newInfraLinkId),
          },
        })
        .then(checkErrorResponse(expectedErrorMsg));
    });

  const shouldNotModifyDatabase = (
    scheduledStopPointId: string,
    newInfraLinkId: string
  ) =>
    it("should not modify the database", async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: {
          query: createMutation(scheduledStopPointId, newInfraLinkId),
        },
      });

      const response = await queryTable(
        dbConnectionPool,
        "service_pattern.scheduled_stop_point",
        routesAndJourneyPatternsTableConfig
      );

      expect(response.rowCount).toEqual(scheduledStopPoints.length);
      expect(response.rows).toEqual(
        expect.arrayContaining(
          asDbGeometryObjectArray(scheduledStopPoints, ["measured_location"])
        )
      );
    });

  describe("when new link is not part of all of the stop's journey patterns' routes", () => {
    shouldReturnErrorResponse(
      scheduledStopPoints[1].scheduled_stop_point_id,
      infrastructureLinks[3].infrastructure_link_id,
      "found stop in journey pattern which is on a link that is not part of the route"
    );

    shouldNotModifyDatabase(
      scheduledStopPoints[1].scheduled_stop_point_id,
      infrastructureLinks[3].infrastructure_link_id
    );
  });

  describe("when new link is not at the correct position in all of the stop's journey patterns' routes", () => {
    shouldReturnErrorResponse(
      scheduledStopPoints[6].scheduled_stop_point_id,
      infrastructureLinks[6].infrastructure_link_id,
      "stops in journey pattern are not in the same order as the links they are on in the route"
    );

    shouldNotModifyDatabase(
      scheduledStopPoints[6].scheduled_stop_point_id,
      infrastructureLinks[6].infrastructure_link_id
    );
  });

  describe("without conflict", () => {
    const toBeMoved = scheduledStopPoints[1];
    const newInfraLinkId = infrastructureLinks[6].infrastructure_link_id;
    const completeUpdated = {
      ...toBeMoved,
      located_on_infrastructure_link_id: newInfraLinkId,
    };

    it("should return correct response", async () => {
      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: {
          query: createMutation(
            toBeMoved.scheduled_stop_point_id,
            newInfraLinkId
          ),
        },
      });

      expect(response).toEqual(
        expect.objectContaining({
          data: {
            update_service_pattern_scheduled_stop_point: {
              returning: [dataset.asGraphQlTimestampObject(completeUpdated)],
            },
          },
        })
      );
    });

    it("should update the database", async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: {
          query: createMutation(
            toBeMoved.scheduled_stop_point_id,
            newInfraLinkId
          ),
        },
      });

      const response = await queryTable(
        dbConnectionPool,
        "service_pattern.scheduled_stop_point",
        routesAndJourneyPatternsTableConfig
      );

      expect(response.rowCount).toEqual(scheduledStopPoints.length);
      expect(response.rows).toEqual(
        expect.arrayContaining(
          asDbGeometryObjectArray(
            [
              ...scheduledStopPoints.filter(
                (stopPoint) =>
                  stopPoint.scheduled_stop_point_id !==
                  toBeMoved.scheduled_stop_point_id
              ),
              completeUpdated,
            ],
            ["measured_location"]
          )
        )
      );
    });
  });
});
