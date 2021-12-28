import * as rp from "request-promise";
import * as pg from "pg";
import * as config from "@config";
import * as db from "@util/db";
import * as dataset from "@util/dataset";
import { routes as sampleRoutes } from "@datasets/routes";
import "@util/matchers";
import { setupDb } from "@datasets/sampleSetup";

const toBeDeleted = sampleRoutes[2];

const mutation = `
  mutation {
    delete_route_route(
      where: {
        route_id: {_eq: "${toBeDeleted.route_id}"}
      },
    ) {
      returning {
        ${Object.keys(sampleRoutes[0]).join(",")}
      }
    }
  }
`;

describe("Delete route", () => {
  let dbConnectionPool: pg.Pool;

  beforeAll(() => {
    dbConnectionPool = new pg.Pool(config.databaseConfig);
  });

  afterAll(() => dbConnectionPool.end());

  beforeEach(() => setupDb(dbConnectionPool));

  it("should return correct response", async () => {
    const response = await rp.post({
      ...config.hasuraRequestTemplate,
      body: { query: mutation },
    });

    expect(response).toEqual(
      expect.objectContaining({
        data: {
          delete_route_route: {
            returning: [dataset.asGraphQlTimestampObject(toBeDeleted)],
          },
        },
      })
    );
  });

  it("should delete correct row from the database", async () => {
    await rp.post({
      ...config.hasuraRequestTemplate,
      body: { query: mutation },
    });

    const response = await db.singleQuery(
      dbConnectionPool,
      `
        SELECT
          ${Object.keys(sampleRoutes[0])
            .map((key) => `r.${key}`)
            .join(",")}
        FROM route.route r
      `
    );

    expect(response.rowCount).toEqual(sampleRoutes.length - 1);

    expect(response.rows).toEqual(
      expect.arrayContaining(
        sampleRoutes.filter((route) => route.route_id != toBeDeleted.route_id)
      )
    );
  });
});
