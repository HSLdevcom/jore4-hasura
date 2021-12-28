import * as rp from "request-promise";
import * as pg from "pg";
import * as config from "@config";
import * as db from "@util/db";
import * as dataset from "@util/dataset";
import { lines as sampleLines } from "@datasets/lines";
import "@util/matchers";
import { Line, VehicleMode } from "@datasets/types";
import { setupDb } from "@datasets/sampleSetup";

const createMutation = (toBeInserted: Partial<Line>) => `
  mutation {
    insert_route_line(objects: ${dataset.toGraphQlObject(toBeInserted, [
      "primary_vehicle_mode",
    ])}) {
      returning {
        ${Object.keys(sampleLines[0]).join(",")}
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

  const shouldReturnCorrectResponse = (toBeInserted: Partial<Line>) =>
    it("should return correct response", async () => {
      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: createMutation(toBeInserted) },
      });

      expect(response).toEqual(
        expect.objectContaining({
          data: {
            insert_route_line: {
              returning: [
                {
                  ...dataset.asGraphQlTimestampObject(toBeInserted),
                  line_id: expect.any(String),
                },
              ],
            },
          },
        })
      );

      // check the new ID is a valid UUID
      expect(
        response.data.insert_route_line.returning[0].line_id
      ).toBeValidUuid();
    });

  const shouldInsertCorrectRowIntoDatabase = (toBeInserted: Partial<Line>) =>
    it("should insert correct row into the database", async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: createMutation(toBeInserted) },
      });

      const response = await db.singleQuery(
        dbConnectionPool,
        `
          SELECT ${Object.keys(sampleLines[0])
            .map((key) => `l.${key}`)
            .join(",")}
          FROM route.line l
        `
      );

      expect(response.rowCount).toEqual(sampleLines.length + 1);

      expect(response.rows).toEqual(
        expect.arrayContaining([
          {
            ...toBeInserted,
            line_id: expect.any(String),
          },
          ...sampleLines,
        ])
      );
    });

  describe("whose validity period conflicts with open validity start but has different priority", () => {
    const toBeInserted: Partial<Line> = {
      name_i18n: "conflicting transport tram line 34",
      short_name_i18n: "conflicting line 34",
      description_i18n:
        "conflicting transport tram line from Sometramplace to Anothertramplace",
      primary_vehicle_mode: VehicleMode.Tram,
      label: "34",
      priority: 30,
      validity_start: new Date("2041-06-01 23:11:32Z"),
      validity_end: new Date("2042-06-01 23:11:32Z"),
    };

    shouldReturnCorrectResponse(toBeInserted);

    shouldInsertCorrectRowIntoDatabase(toBeInserted);
  });

  describe("whose validity period conflicts with open validity start but has different label", () => {
    const toBeInserted: Partial<Line> = {
      name_i18n: "conflicting transport tram line 34",
      short_name_i18n: "conflicting line 34",
      description_i18n:
        "conflicting transport tram line from Sometramplace to Anothertramplace",
      primary_vehicle_mode: VehicleMode.Tram,
      label: "35",
      priority: 20,
      validity_start: new Date("2041-06-01 23:11:32Z"),
      validity_end: new Date("2042-06-01 23:11:32Z"),
    };

    shouldReturnCorrectResponse(toBeInserted);

    shouldInsertCorrectRowIntoDatabase(toBeInserted);
  });

  describe("whose validity period does not conflict with open validity start", () => {
    const toBeInserted: Partial<Line> = {
      name_i18n: "conflicting transport tram line 34",
      short_name_i18n: "conflicting line 34",
      description_i18n:
        "conflicting transport tram line from Sometramplace to Anothertramplace",
      primary_vehicle_mode: VehicleMode.Tram,
      label: "34",
      priority: 20,
      validity_start: new Date("2045-06-01 23:11:32Z"),
      validity_end: new Date("2047-06-01 23:11:32Z"),
    };

    shouldReturnCorrectResponse(toBeInserted);

    shouldInsertCorrectRowIntoDatabase(toBeInserted);
  });

  describe("whose validity period does not overlap with other validity period ", () => {
    const toBeInserted: Partial<Line> = {
      name_i18n: "transport bus line 2",
      short_name_i18n: "line 2",
      description_i18n: "transport bus line from SomeplaceX to AnotherplaceY",
      primary_vehicle_mode: VehicleMode.Bus,
      label: "2",
      priority: 10,
      validity_start: new Date("2045-05-01 23:11:32Z"),
      validity_end: new Date("2046-06-01 23:11:32Z"),
    };

    shouldReturnCorrectResponse(toBeInserted);

    shouldInsertCorrectRowIntoDatabase(toBeInserted);
  });

  describe("whose validity period is entirely contained in other validity period but has different priority", () => {
    const toBeInserted: Partial<Line> = {
      name_i18n: "transport bus line 2",
      short_name_i18n: "line 2",
      description_i18n: "transport bus line from SomeplaceX to AnotherplaceY",
      primary_vehicle_mode: VehicleMode.Bus,
      label: "2",
      priority: 30,
      validity_start: new Date("2044-06-01 23:11:32Z"),
      validity_end: new Date("2045-04-01 23:11:32Z"),
    };

    shouldReturnCorrectResponse(toBeInserted);

    shouldInsertCorrectRowIntoDatabase(toBeInserted);
  });
});
