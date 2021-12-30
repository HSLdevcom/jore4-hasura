import * as rp from "request-promise";
import * as pg from "pg";
import * as config from "@config";
import * as dataset from "@util/dataset";
import { lines } from "@datasets/lines";
import { routes } from "@datasets/routes";
import "@util/matchers";
import { Route } from "@datasets/types";
import { queryTable, setupDb } from "@datasets/sampleSetup";
import { checkErrorResponse } from "@util/response";

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
        ${Object.keys(routes[0]).join(",")}
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

  beforeEach(() => setupDb(dbConnectionPool));

  const shouldReturnErrorResponse = (
    toBeUpdated: PartialRouteWithNullableOnLineID
  ) =>
    it("should return error response", async () => {
      await rp
        .post({
          ...config.hasuraRequestTemplate,
          body: { query: createMutation(toBeUpdated) },
        })
        .then(checkErrorResponse);
    });

  const shouldNotModifyDatabase = (
    toBeUpdated: PartialRouteWithNullableOnLineID
  ) =>
    it("should not modify the database", async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: createMutation(toBeUpdated) },
      });

      const response = await queryTable(dbConnectionPool, "route.route");

      expect(response.rowCount).toEqual(routes.length);
      expect(response.rows).toEqual(expect.arrayContaining(routes));
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

  const shouldUpdateCorrectRowInDatabase = (
    toBeUpdated: PartialRouteWithNullableOnLineID
  ) =>
    it("should update correct row into the database", async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: createMutation(toBeUpdated) },
      });

      const response = await queryTable(dbConnectionPool, "route.route");

      const updated = completeUpdated(toBeUpdated);

      expect(response.rowCount).toEqual(routes.length);
      expect(response.rows).toEqual(
        expect.arrayContaining([
          updated,
          ...routes.filter((route) => route.route_id != updated.route_id),
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
    shouldUpdateCorrectRowInDatabase(toBeUpdated);
  });

  describe("with a priority that is higher to the line's priority", () => {
    const toBeUpdated = { priority: lines[1].priority + 10 };

    shouldReturnCorrectResponse(toBeUpdated);
    shouldUpdateCorrectRowInDatabase(toBeUpdated);
  });
});
