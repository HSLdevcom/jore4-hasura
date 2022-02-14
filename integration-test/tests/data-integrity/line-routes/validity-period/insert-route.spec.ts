import * as rp from "request-promise";
import * as pg from "pg";
import * as config from "@config";
import * as dataset from "@util/dataset";
import { scheduledStopPoints } from "@datasets/defaultSetup/scheduled-stop-points";
import { lines } from "@datasets/defaultSetup/lines";
import { routes } from "@datasets/defaultSetup/routes";
import "@util/matchers";
import { Route, RouteDirection, RouteProps } from "@datasets/types";
import { getPropNameArray, queryTable, setupDb } from "@datasets/setup";
import { expectErrorResponse } from "@util/response";

const toBeInserted = (
  on_line_id: string,
  validity_start: Date | null,
  validity_end: Date | null
): Partial<Route> => ({
  on_line_id,
  description_i18n: "new route",
  starts_from_scheduled_stop_point_id:
    scheduledStopPoints[0].scheduled_stop_point_id,
  ends_at_scheduled_stop_point_id:
    scheduledStopPoints[2].scheduled_stop_point_id,
  label: "new route label",
  direction: RouteDirection.Clockwise,
  priority: 30,
  validity_start,
  validity_end,
});

const buildMutation = (
  on_line_id: string,
  validity_start: Date | null,
  validity_end: Date | null
) => `
  mutation {
    insert_route_route(objects: ${dataset.toGraphQlObject(
      toBeInserted(on_line_id, validity_start, validity_end),
      ["direction"]
    )}) {
      returning {
        ${getPropNameArray(RouteProps).join(",")}
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

  beforeEach(() => setupDb(dbConnectionPool));

  const shouldReturnErrorResponse = (
    on_line_id: string,
    validity_start: Date | null,
    validity_end: Date | null
  ) =>
    it("should return error response", async () => {
      await rp
        .post({
          ...config.hasuraRequestTemplate,
          body: {
            query: buildMutation(on_line_id, validity_start, validity_end),
          },
        })
        .then(
          expectErrorResponse(
            "route validity period must lie within its line's validity period"
          )
        );
    });

  const shouldNotModifyDatabase = (
    on_line_id: string,
    validity_start: Date | null,
    validity_end: Date | null
  ) =>
    it("should not modify the database", async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: {
          query: buildMutation(on_line_id, validity_start, validity_end),
        },
      });

      const response = await queryTable(dbConnectionPool, "route.route");

      expect(response.rowCount).toEqual(routes.length);
      expect(response.rows).toEqual(expect.arrayContaining(routes));
    });

  const shouldReturnCorrectResponse = (
    on_line_id: string,
    validity_start: Date | null,
    validity_end: Date | null
  ) =>
    it("should return correct response", async () => {
      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: {
          query: buildMutation(on_line_id, validity_start, validity_end),
        },
      });

      expect(response).toEqual(
        expect.objectContaining({
          data: {
            insert_route_route: {
              returning: [
                {
                  ...dataset.asGraphQlTimestampObject(
                    toBeInserted(on_line_id, validity_start, validity_end)
                  ),
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
    on_line_id: string,
    validity_start: Date | null,
    validity_end: Date | null
  ) =>
    it("should insert correct row into the database", async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: {
          query: buildMutation(on_line_id, validity_start, validity_end),
        },
      });

      const response = await queryTable(dbConnectionPool, "route.route");

      expect(response.rowCount).toEqual(routes.length + 1);

      expect(response.rows).toEqual(
        expect.arrayContaining([
          {
            ...toBeInserted(on_line_id, validity_start, validity_end),
            route_id: expect.any(String),
          },
          ...routes,
        ])
      );
    });

  describe("which is valid indefinitely, but its line is not", () => {
    shouldReturnErrorResponse(lines[1].line_id, null, null);
    shouldNotModifyDatabase(lines[1].line_id, null, null);
  });

  describe("which is valid indefinitely and its line is valid indefinitely", () => {
    shouldReturnCorrectResponse(lines[4].line_id, null, null);
    shouldInsertCorrectRowIntoDatabase(lines[4].line_id, null, null);
  });

  describe("which is valid for a fixed period not entirely covered by it's line's validity period", () => {
    shouldReturnErrorResponse(
      lines[1].line_id,
      new Date("2044-03-01 23:11:32Z"),
      new Date("2045-03-01 23:11:32Z")
    );
    shouldNotModifyDatabase(
      lines[1].line_id,
      new Date("2044-03-01 23:11:32Z"),
      new Date("2045-03-01 23:11:32Z")
    );
  });

  describe("which is valid for a fixed period entirely covered by it's line's validity period", () => {
    shouldReturnCorrectResponse(
      lines[1].line_id,
      new Date("2044-07-01 23:11:32Z"),
      new Date("2045-03-01 23:11:32Z")
    );
    shouldInsertCorrectRowIntoDatabase(
      lines[1].line_id,
      new Date("2044-07-01 23:11:32Z"),
      new Date("2045-03-01 23:11:32Z")
    );
  });
});
