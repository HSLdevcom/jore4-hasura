import * as rp from "request-promise";
import * as pg from "pg";
import * as config from "@config";
import * as db from "@util/db";
import * as dataset from "@util/dataset";
import { infrastructureLinks } from "@datasets/infrastructure-links";
import { scheduledStopPoints } from "@datasets/scheduled-stop-points";
import { lines } from "@datasets/lines";
import { routes as sampleRoutes } from "@datasets/routes";
import "@util/matchers";
import { Route, RouteDirection } from "@datasets/types";

const createMutation = (toBeInserted: Partial<Route>) => `
  mutation {
    insert_route_route(objects: ${dataset.toGraphQlObject(toBeInserted, [
      "direction",
    ])}) {
      returning {
        ${Object.keys(sampleRoutes[0]).join(",")}
      }
    }
  }
`;

describe("Insert route", () => {
  let dbConnectionPool: pg.Pool;

  beforeAll(() => {
    dbConnectionPool = new pg.Pool(config.databaseConfig);
  });

  afterAll(() => dbConnectionPool.end());

  beforeEach(async () => {
    await db
      .queryRunner(dbConnectionPool)
      .truncate("infrastructure_network.infrastructure_link")
      .truncate("internal_service_pattern.scheduled_stop_point")
      .truncate("route.line")
      .truncate("internal_route.route")
      .insertFromJson(
        "infrastructure_network.infrastructure_link",
        dataset.asDbGeometryObjectArray(infrastructureLinks, ["shape"])
      )
      .insertFromJson(
        "internal_service_pattern.scheduled_stop_point",
        dataset.asDbGeometryObjectArray(scheduledStopPoints, [
          "measured_location",
        ])
      )
      .insertFromJson("route.line", lines)
      .insertFromJson("internal_route.route", sampleRoutes)
      .run();
  });

  const shouldReturnCorrectResponse = (toBeInserted: Partial<Route>) =>
    it("should return correct response", async () => {
      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: createMutation(toBeInserted) },
      });

      expect(response).toEqual(
        expect.objectContaining({
          data: {
            insert_route_route: {
              returning: [
                {
                  ...dataset.asGraphQlTimestampObject(toBeInserted),
                  route_id: expect.any(String),
                },
              ],
            },
          },
        })
      );

      // check the new ID is a valid UUID
      expect(
        response.data.insert_route_route.returning[0].route_id
      ).toBeValidUuid();
    });

  const shouldInsertCorrectRowIntoDatabase = (toBeInserted: Partial<Route>) =>
    it("should insert correct row into the database", async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: createMutation(toBeInserted) },
      });

      const response = await db.singleQuery(
        dbConnectionPool,
        `
          SELECT ${Object.keys(sampleRoutes[0])
            .map((key) => `r.${key}`)
            .join(",")}
          FROM route.route r
        `
      );

      expect(response.rowCount).toEqual(sampleRoutes.length + 1);

      expect(response.rows).toEqual(
        expect.arrayContaining([
          {
            ...toBeInserted,
            route_id: expect.any(String),
          },
          ...sampleRoutes,
        ])
      );
    });

  describe("whose validity period conflicts with open validity start but has different priority", () => {
    const toBeInserted: Partial<Route> = {
      on_line_id: lines[1].line_id,
      description_i18n: "route 2",
      starts_from_scheduled_stop_point_id:
        scheduledStopPoints[1].scheduled_stop_point_id,
      ends_at_scheduled_stop_point_id:
        scheduledStopPoints[2].scheduled_stop_point_id,
      label: "route 2",
      direction: RouteDirection.Southbound,
      priority: 10,
      validity_start: new Date("2042-02-02 23:11:32Z"),
      validity_end: new Date("2043-02-02 23:11:32Z"),
    };

    shouldReturnCorrectResponse(toBeInserted);

    shouldInsertCorrectRowIntoDatabase(toBeInserted);
  });

  describe("whose validity period conflicts with open validity start but has different label", () => {
    const toBeInserted: Partial<Route> = {
      on_line_id: lines[1].line_id,
      description_i18n: "route 2",
      starts_from_scheduled_stop_point_id:
        scheduledStopPoints[1].scheduled_stop_point_id,
      ends_at_scheduled_stop_point_id:
        scheduledStopPoints[2].scheduled_stop_point_id,
      label: "route 2X",
      direction: RouteDirection.Southbound,
      priority: 20,
      validity_start: new Date("2042-02-02 23:11:32Z"),
      validity_end: new Date("2043-02-02 23:11:32Z"),
    };

    shouldReturnCorrectResponse(toBeInserted);

    shouldInsertCorrectRowIntoDatabase(toBeInserted);
  });

  describe("whose validity period does not conflict with open validity start", () => {
    const toBeInserted: Partial<Route> = {
      on_line_id: lines[1].line_id,
      description_i18n: "route 2",
      starts_from_scheduled_stop_point_id:
        scheduledStopPoints[1].scheduled_stop_point_id,
      ends_at_scheduled_stop_point_id:
        scheduledStopPoints[2].scheduled_stop_point_id,
      label: "route 2",
      direction: RouteDirection.Southbound,
      priority: 20,
      validity_start: new Date("2044-02-02 23:11:32Z"),
      validity_end: new Date("2045-02-02 23:11:32Z"),
    };

    shouldReturnCorrectResponse(toBeInserted);

    shouldInsertCorrectRowIntoDatabase(toBeInserted);
  });

  describe("whose validity period overlaps partially with existing validity period but has different direction", () => {
    const toBeInserted: Partial<Route> = {
      on_line_id: lines[1].line_id,
      description_i18n: "route 3",
      starts_from_scheduled_stop_point_id:
        scheduledStopPoints[0].scheduled_stop_point_id,
      ends_at_scheduled_stop_point_id:
        scheduledStopPoints[1].scheduled_stop_point_id,
      label: "route 3",
      direction: RouteDirection.Westbound,
      priority: 30,
      validity_start: new Date("2044-08-02 23:11:32Z"),
      validity_end: new Date("2044-10-02 23:11:32Z"),
    };

    shouldReturnCorrectResponse(toBeInserted);

    shouldInsertCorrectRowIntoDatabase(toBeInserted);
  });

  describe("whose validity period is entirely contained in other validity period but has different direction", () => {
    const toBeInserted: Partial<Route> = {
      on_line_id: lines[1].line_id,
      description_i18n: "route 3",
      starts_from_scheduled_stop_point_id:
        scheduledStopPoints[0].scheduled_stop_point_id,
      ends_at_scheduled_stop_point_id:
        scheduledStopPoints[1].scheduled_stop_point_id,
      label: "route 3",
      direction: RouteDirection.Clockwise,
      priority: 30,
      validity_start: new Date("2044-02-02 23:11:32Z"),
      validity_end: new Date("2044-08-02 23:11:32Z"),
    };

    shouldReturnCorrectResponse(toBeInserted);

    shouldInsertCorrectRowIntoDatabase(toBeInserted);
  });
});
