import * as rp from "request-promise";
import * as pg from "pg";
import * as config from "@config";
import * as dataset from "@util/dataset";
import { lines } from "@datasets/defaultSetup/lines";
import "@util/matchers";
import { Line, LineProps, VehicleMode } from "@datasets/types";
import { expect } from "@jest/globals";
import { getPropNameArray, queryTable, setupDb } from "@datasets/setup";
import { checkErrorResponse } from "@util/response";

const createMutation = (toBeInserted: Partial<Line>) => `
  mutation {
    insert_route_line(objects: ${dataset.toGraphQlObject(toBeInserted, [
      "primary_vehicle_mode",
    ])}) {
      returning {
        ${getPropNameArray(LineProps).join(",")}
      }
    }
  }
`;

describe("Insert line", () => {
  let dbConnectionPool: pg.Pool;

  beforeAll(() => {
    dbConnectionPool = new pg.Pool(config.databaseConfig);
  });

  afterAll(() => dbConnectionPool.end());

  beforeEach(() => setupDb(dbConnectionPool));

  const shouldReturnErrorResponse = (toBeInserted: Partial<Line>) =>
    it("should return error response", async () => {
      await rp
        .post({
          ...config.hasuraRequestTemplate,
          body: { query: createMutation(toBeInserted) },
        })
        .then(checkErrorResponse());
    });

  const shouldNotModifyDatabase = (toBeInserted: Partial<Line>) =>
    it("should not modify the database", async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: createMutation(toBeInserted) },
      });

      const response = await queryTable(dbConnectionPool, "route.line");

      expect(response.rowCount).toEqual(lines.length);
      expect(response.rows).toEqual(expect.arrayContaining(lines));
    });

  describe("whose validity period conflicts with open validity start", () => {
    const toBeInserted: Partial<Line> = {
      name_i18n: "conflicting transport tram line 34",
      short_name_i18n: "conflicting line 34",
      description_i18n:
        "conflicting transport tram line from Sometramplace to Anothertramplace",
      primary_vehicle_mode: VehicleMode.Tram,
      label: "34",
      priority: 20,
      validity_start: new Date("2041-06-01 23:11:32Z"),
      validity_end: new Date("2042-06-01 23:11:32Z"),
    };

    shouldReturnErrorResponse(toBeInserted);

    shouldNotModifyDatabase(toBeInserted);
  });

  describe("whose validity period overlaps partially with existing validity period", () => {
    const toBeInserted: Partial<Line> = {
      name_i18n: "transport bus line 2",
      short_name_i18n: "line 2",
      description_i18n: "transport bus line from SomeplaceX to AnotherplaceY",
      primary_vehicle_mode: VehicleMode.Bus,
      label: "2",
      priority: 10,
      validity_start: new Date("2045-04-01 23:11:32Z"),
      validity_end: new Date("2046-05-01 23:11:32Z"),
    };

    shouldReturnErrorResponse(toBeInserted);

    shouldNotModifyDatabase(toBeInserted);
  });

  describe("whose validity period is entirely contained in other validity period", () => {
    const toBeInserted: Partial<Line> = {
      name_i18n: "transport bus line 2",
      short_name_i18n: "line 2",
      description_i18n: "transport bus line from SomeplaceX to AnotherplaceY",
      primary_vehicle_mode: VehicleMode.Bus,
      label: "2",
      priority: 10,
      validity_start: new Date("2044-06-01 23:11:32Z"),
      validity_end: new Date("2045-04-01 23:11:32Z"),
    };

    shouldReturnErrorResponse(toBeInserted);

    shouldNotModifyDatabase(toBeInserted);
  });
});
