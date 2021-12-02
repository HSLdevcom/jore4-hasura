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

const toBeInserted = (
  on_line_id: string | undefined,
  priority: number
): Partial<Route> => ({
  on_line_id,
  description_i18n: "new route",
  starts_from_scheduled_stop_point_id:
    scheduledStopPoints[0].scheduled_stop_point_id,
  ends_at_scheduled_stop_point_id:
    scheduledStopPoints[2].scheduled_stop_point_id,
  label: "new route label",
  direction: RouteDirection.Clockwise,
  priority,
  validity_start: new Date("2043-02-01 14:20:54Z"),
});

const insertedDefaultValues: Partial<Route> = {
  validity_end: null,
};

const createMutation = (on_line_id: string | undefined, priority: number) => `
  mutation {
    insert_route_route(objects: ${dataset.toGraphQlObject(
      toBeInserted(on_line_id, priority),
      ["direction"]
    )}) {
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

  const shouldReturnErrorResponse = (
    on_line_id: string | undefined,
    priority: number
  ) =>
    it("should return error response", async () => {
      await rp
        .post({
          ...config.hasuraRequestTemplate,
          body: { query: createMutation(on_line_id, priority) },
        })
        .then((response) => {
          if (response.statusCode >= 200 && response.statusCode < 300)
            throw new Error(
              "Request succeeded even though it was expected to fail"
            );

          expect(response).toEqual(
            expect.objectContaining({
              errors: expect.any(Array),
            })
          );
        });
    });

  const shouldNotModifyDatabase = (
    on_line_id: string | undefined,
    priority: number
  ) =>
    it("should not modify the database", async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: createMutation(on_line_id, priority) },
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

      expect(response.rowCount).toEqual(sampleRoutes.length);
      expect(response.rows).toEqual(expect.arrayContaining(sampleRoutes));
    });

  const shouldReturnCorrectResponse = (
    on_line_id: string | undefined,
    priority: number
  ) =>
    it("should return correct response", async () => {
      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: createMutation(on_line_id, priority) },
      });

      expect(response).toEqual(
        expect.objectContaining({
          data: {
            insert_route_route: {
              returning: [
                {
                  ...dataset.asGraphQlTimestampObject(
                    toBeInserted(on_line_id, priority)
                  ),
                  ...insertedDefaultValues,
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

  const shouldInsertCorrectRowIntoDatabase = (
    on_line_id: string | undefined,
    priority: number
  ) =>
    it("should insert correct row into the database", async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: createMutation(on_line_id, priority) },
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
            ...toBeInserted(on_line_id, priority),
            ...insertedDefaultValues,
            route_id: expect.any(String),
          },
          ...sampleRoutes,
        ])
      );
    });

  describe("without line ID", () => {
    shouldReturnErrorResponse(undefined, 50);
    shouldNotModifyDatabase(undefined, 50);
  });

  describe("whose priority is lower than the line's priority", () => {
    shouldReturnErrorResponse(lines[1].line_id, lines[1].priority - 10);
    shouldNotModifyDatabase(lines[1].line_id, lines[1].priority - 10);
  });

  describe("whose priority is equal to the line's priority", () => {
    shouldReturnCorrectResponse(lines[1].line_id, lines[1].priority);
    shouldInsertCorrectRowIntoDatabase(lines[1].line_id, lines[1].priority);
  });

  describe("whose priority is higher to the line's priority", () => {
    shouldReturnCorrectResponse(lines[1].line_id, lines[1].priority + 10);
    shouldInsertCorrectRowIntoDatabase(
      lines[1].line_id,
      lines[1].priority + 10
    );
  });
});
