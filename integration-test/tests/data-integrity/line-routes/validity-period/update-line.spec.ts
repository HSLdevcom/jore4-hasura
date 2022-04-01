import * as rp from "request-promise";
import * as pg from "pg";
import * as config from "@config";
import * as dataset from "@util/dataset";
import { lines } from "@datasets/defaultSetup/lines";
import "@util/matchers";
import { Line, LineProps } from "@datasets/types";
import { getPropNameArray, queryTable, setupDb } from "@datasets/setup";
import { expectErrorResponse } from "@util/response";

const buildMutation = (line: Line, toBeUpdated: Partial<Line>) => `
  mutation {
    update_route_line(
      where: {
        line_id: {_eq: "${line.line_id}"}
      },
      _set: ${dataset.toGraphQlObject(toBeUpdated, [
        "primary_vehicle_mode",
        "type_of_line",
      ])}
    ) {
      returning {
        ${getPropNameArray(LineProps).join(",")}
      }
    }
  }
`;

const completeUpdated = (line: Line, toBeUpdated: Partial<Line>) => ({
  ...line,
  ...toBeUpdated,
});

describe("Update line", () => {
  let dbConnectionPool: pg.Pool;

  beforeAll(() => {
    dbConnectionPool = new pg.Pool(config.databaseConfig);
  });

  afterAll(() => dbConnectionPool.end());

  beforeEach(() => setupDb(dbConnectionPool));

  const shouldReturnErrorResponse = (line: Line, toBeUpdated: Partial<Line>) =>
    it("should return error response", async () => {
      await rp
        .post({
          ...config.hasuraRequestTemplate,
          body: { query: buildMutation(line, toBeUpdated) },
        })
        .then(
          expectErrorResponse(
            "line validity period must span all its routes' validity periods"
          )
        );
    });

  const shouldNotModifyDatabase = (line: Line, toBeUpdated: Partial<Line>) =>
    it("should not modify the database", async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(line, toBeUpdated) },
      });

      const response = await queryTable(dbConnectionPool, "route.line");

      expect(response.rowCount).toEqual(lines.length);
      expect(response.rows).toEqual(expect.arrayContaining(lines));
    });

  const shouldReturnCorrectResponse = (
    line: Line,
    toBeUpdated: Partial<Line>
  ) =>
    it("should return correct response", async () => {
      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(line, toBeUpdated) },
      });

      expect(response).toEqual(
        expect.objectContaining({
          data: {
            update_route_line: {
              returning: [
                dataset.asGraphQlTimestampObject(
                  completeUpdated(line, toBeUpdated)
                ),
              ],
            },
          },
        })
      );
    });

  const shouldUpdateCorrectRowInDatabase = (
    line: Line,
    toBeUpdated: Partial<Line>
  ) =>
    it("should update correct row into the database", async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(line, toBeUpdated) },
      });

      const response = await queryTable(dbConnectionPool, "route.line");

      const updated = completeUpdated(line, toBeUpdated);

      expect(response.rowCount).toEqual(lines.length);
      expect(response.rows).toEqual(
        expect.arrayContaining([
          updated,
          ...lines.filter((line) => line.line_id != updated.line_id),
        ])
      );
    });

  describe("with a fixed validity start time not spanning the validity time of a route belonging to the line", () => {
    const toBeUpdated = { validity_start: new Date("2045-03-02 23:11:32Z") };

    shouldReturnErrorResponse(lines[1], toBeUpdated);
    shouldNotModifyDatabase(lines[1], toBeUpdated);
  });

  describe("with a fixed validity end time not spanning the validity time of a route belonging to the line", () => {
    const toBeUpdated = { validity_end: new Date("2044-08-02 23:11:32Z") };

    shouldReturnErrorResponse(lines[1], toBeUpdated);
    shouldNotModifyDatabase(lines[1], toBeUpdated);
  });

  describe("with a fixed validity start time spanning the validity time of a route belonging to the line", () => {
    const toBeUpdated = { validity_start: new Date("2043-03-02 23:11:32Z") };

    shouldReturnCorrectResponse(lines[1], toBeUpdated);
    shouldUpdateCorrectRowInDatabase(lines[1], toBeUpdated);
  });

  describe("with infinitely valid validity start", () => {
    const toBeUpdated = { validity_start: null };

    shouldReturnCorrectResponse(lines[1], toBeUpdated);
    shouldUpdateCorrectRowInDatabase(lines[1], toBeUpdated);
  });
});
