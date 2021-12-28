import * as rp from "request-promise";
import * as pg from "pg";
import * as config from "@config";
import * as db from "@util/db";
import * as dataset from "@util/dataset";
import { lines as sampleLines } from "@datasets/lines";
import { routes } from "@datasets/routes";
import "@util/matchers";
import { Line } from "@datasets/types";
import { setupDb } from "@datasets/sampleSetup";

const createMutation = (toBeUpdated: Partial<Line>) => `
  mutation {
    update_route_line(
      where: {
        line_id: {_eq: "${sampleLines[1].line_id}"}
      },
      _set: ${dataset.toGraphQlObject(toBeUpdated, ["primary_vehicle_mode"])}
    ) {
      returning {
        ${Object.keys(sampleLines[0]).join(",")}
      }
    }
  }
`;

const completeUpdated = (toBeUpdated: Partial<Line>) => ({
  ...sampleLines[1],
  ...toBeUpdated,
});

describe("Update line", () => {
  let dbConnectionPool: pg.Pool;

  beforeAll(() => {
    dbConnectionPool = new pg.Pool(config.databaseConfig);
  });

  afterAll(() => dbConnectionPool.end());

  beforeEach(() => setupDb(dbConnectionPool));

  const shouldReturnErrorResponse = (toBeUpdated: Partial<Line>) =>
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

  const shouldNotModifyDatabase = (toBeUpdated: Partial<Line>) =>
    it("should not modify the database", async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: createMutation(toBeUpdated) },
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

      expect(response.rowCount).toEqual(sampleLines.length);
      expect(response.rows).toEqual(expect.arrayContaining(sampleLines));
    });

  const shouldReturnCorrectResponse = (toBeUpdated: Partial<Line>) =>
    it("should return correct response", async () => {
      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: createMutation(toBeUpdated) },
      });

      expect(response).toEqual(
        expect.objectContaining({
          data: {
            update_route_line: {
              returning: [
                dataset.asGraphQlTimestampObject(completeUpdated(toBeUpdated)),
              ],
            },
          },
        })
      );
    });

  const shouldUpdateCorrectRowIntoDatabase = (toBeUpdated: Partial<Line>) =>
    it("should update correct row into the database", async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: createMutation(toBeUpdated) },
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

      const updated = completeUpdated(toBeUpdated);

      expect(response.rowCount).toEqual(sampleLines.length);
      expect(response.rows).toEqual(
        expect.arrayContaining([
          updated,
          ...sampleLines.filter((line) => line.line_id != updated.line_id),
        ])
      );
    });

  describe("with a priority higher than the priority of a route belonging to the line", () => {
    const toBeUpdated = { priority: routes[1].priority + 10 };

    shouldReturnErrorResponse(toBeUpdated);
    shouldNotModifyDatabase(toBeUpdated);
  });

  describe("with a priority equal to the priority of a route belonging to the line", () => {
    const toBeUpdated = { priority: routes[1].priority };

    shouldReturnCorrectResponse(toBeUpdated);
    shouldUpdateCorrectRowIntoDatabase(toBeUpdated);
  });

  describe("with a priority lower than the priority of a route belonging to the line", () => {
    const toBeUpdated = { priority: routes[1].priority - 10 };

    shouldReturnCorrectResponse(toBeUpdated);
    shouldUpdateCorrectRowIntoDatabase(toBeUpdated);
  });
});
