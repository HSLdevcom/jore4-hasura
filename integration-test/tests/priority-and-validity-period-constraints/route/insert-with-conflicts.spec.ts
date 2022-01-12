import * as rp from "request-promise";
import * as pg from "pg";
import * as config from "@config";
import * as dataset from "@util/dataset";
import { scheduledStopPoints } from "@datasets/defaultSetup/scheduled-stop-points";
import { lines } from "@datasets/defaultSetup/lines";
import { routes } from "@datasets/defaultSetup/routes";
import "@util/matchers";
import { Route, RouteDirection, RouteProps } from "@datasets/types";
import { expect } from "@jest/globals";
import { getPropNameArray, queryTable, setupDb } from "@datasets/setup";
import { checkErrorResponse } from "@util/response";

const buildMutation = (toBeInserted: Partial<Route>) => `
  mutation {
    insert_route_route(objects: ${dataset.toGraphQlObject(toBeInserted, [
      "direction",
    ])}) {
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

  const shouldReturnErrorResponse = (toBeInserted: Partial<Route>) =>
    it("should return error response", async () => {
      await rp
        .post({
          ...config.hasuraRequestTemplate,
          body: { query: buildMutation(toBeInserted) },
        })
        .then(checkErrorResponse());
    });

  const shouldNotModifyDatabase = (toBeInserted: Partial<Route>) =>
    it("should not modify the database", async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeInserted) },
      });

      const response = await queryTable(dbConnectionPool, "route.route");

      expect(response.rowCount).toEqual(routes.length);
      expect(response.rows).toEqual(expect.arrayContaining(routes));
    });

  describe("whose validity period conflicts with open validity start", () => {
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
      validity_start: new Date("2042-02-02 23:11:32Z"),
      validity_end: new Date("2043-02-02 23:11:32Z"),
    };

    shouldReturnErrorResponse(toBeInserted);

    shouldNotModifyDatabase(toBeInserted);
  });

  describe("whose validity period overlaps partially with existing validity period", () => {
    const toBeInserted: Partial<Route> = {
      on_line_id: lines[1].line_id,
      description_i18n: "route 3",
      starts_from_scheduled_stop_point_id:
        scheduledStopPoints[0].scheduled_stop_point_id,
      ends_at_scheduled_stop_point_id:
        scheduledStopPoints[1].scheduled_stop_point_id,
      label: "route 3",
      direction: RouteDirection.Eastbound,
      priority: 30,
      validity_start: new Date("2044-08-02 23:11:32Z"),
      validity_end: new Date("2044-10-02 23:11:32Z"),
    };

    shouldReturnErrorResponse(toBeInserted);

    shouldNotModifyDatabase(toBeInserted);
  });

  describe("whose validity period is entirely contained in other validity period", () => {
    const toBeInserted: Partial<Route> = {
      on_line_id: lines[1].line_id,
      description_i18n: "route 3",
      starts_from_scheduled_stop_point_id:
        scheduledStopPoints[0].scheduled_stop_point_id,
      ends_at_scheduled_stop_point_id:
        scheduledStopPoints[1].scheduled_stop_point_id,
      label: "route 3",
      direction: RouteDirection.Eastbound,
      priority: 30,
      validity_start: new Date("2044-02-02 23:11:32Z"),
      validity_end: new Date("2044-08-02 23:11:32Z"),
    };

    shouldReturnErrorResponse(toBeInserted);

    shouldNotModifyDatabase(toBeInserted);
  });
});
