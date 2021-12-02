import * as rp from "request-promise";
import * as pg from "pg";
import * as config from "@config";
import * as db from "@util/db";
import * as dataset from "@util/dataset";
import { infrastructureLinks } from "@datasets/infrastructure-links";
import { scheduledStopPoints } from "@datasets/scheduled-stop-points";
import { lines } from "@datasets/lines";
import { routes, routes as sampleRoutes } from "@datasets/routes";
import "@util/matchers";
import { Route } from "@datasets/types";

type PartialRouteWithNullableOnLineID = Partial<
  Omit<Route, "on_line_id"> & { on_line_id: string | null }
>;

const createMutation = (toBeUpdated: PartialRouteWithNullableOnLineID) => `
  mutation {
    update_route_route(
      where: {
        route_id: {_eq: "${routes[1].route_id}"}
      },
      _set: ${dataset.toGraphQlObject(toBeUpdated, ["direction"])}
    ) {
      returning {
        ${Object.keys(sampleRoutes[0]).join(",")}
      }
    }
  }
`;

const completeUpdated = (toBeUpdated: PartialRouteWithNullableOnLineID) => ({
  ...routes[1],
  ...toBeUpdated,
});

describe("Update route", () => {
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
    toBeUpdated: PartialRouteWithNullableOnLineID
  ) =>
    it("should return error response", async () => {
      await rp
        .post({
          ...config.hasuraRequestTemplate,
          body: { query: createMutation(toBeUpdated) },
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
    toBeUpdated: PartialRouteWithNullableOnLineID
  ) =>
    it("should not modify the database", async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: createMutation(toBeUpdated) },
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
    toBeUpdated: PartialRouteWithNullableOnLineID
  ) =>
    it("should return correct response", async () => {
      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: createMutation(toBeUpdated) },
      });

      expect(response).toEqual(
        expect.objectContaining({
          data: {
            update_route_route: {
              returning: [
                dataset.asGraphQlTimestampObject(completeUpdated(toBeUpdated)),
              ],
            },
          },
        })
      );
    });

  const shouldUpdateCorrectRowIntoDatabase = (
    toBeUpdated: PartialRouteWithNullableOnLineID
  ) =>
    it("should update correct row into the database", async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: createMutation(toBeUpdated) },
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

      const updated = completeUpdated(toBeUpdated);

      expect(response.rowCount).toEqual(sampleRoutes.length);
      expect(response.rows).toEqual(
        expect.arrayContaining([
          updated,
          ...sampleRoutes.filter((route) => route.route_id != updated.route_id),
        ])
      );
    });

  describe("with a NULL line ID", () => {
    const toBeUpdated = { on_line_id: null };

    shouldReturnErrorResponse(toBeUpdated);
    shouldNotModifyDatabase(toBeUpdated);
  });

  describe("with a line ID whose line has higher priority than the route", () => {
    const toBeUpdated = { on_line_id: lines[3].line_id };

    shouldReturnErrorResponse(toBeUpdated);
    shouldNotModifyDatabase(toBeUpdated);
  });

  describe("with a priority that is lower than the line's priority", () => {
    const toBeUpdated = { priority: lines[1].priority - 10 };

    shouldReturnErrorResponse(toBeUpdated);
    shouldNotModifyDatabase(toBeUpdated);
  });

  describe("with a priority that is equal to the line's priority", () => {
    const toBeUpdated = { priority: lines[1].priority };

    shouldReturnCorrectResponse(toBeUpdated);
    shouldUpdateCorrectRowIntoDatabase(toBeUpdated);
  });

  describe("with a priority that is higher to the line's priority", () => {
    const toBeUpdated = { priority: lines[1].priority + 10 };

    shouldReturnCorrectResponse(toBeUpdated);
    shouldUpdateCorrectRowIntoDatabase(toBeUpdated);
  });
});
