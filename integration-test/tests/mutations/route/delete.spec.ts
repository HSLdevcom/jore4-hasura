import * as rp from "request-promise";
import * as pg from "pg";
import * as config from "@config";
import * as dataset from "@util/dataset";
import { routes } from "@datasets/routes";
import "@util/matchers";
import { queryTable, setupDb } from "@datasets/sampleSetup";

const toBeDeleted = routes[2];

const mutation = `
  mutation {
    delete_route_route(
      where: {
        route_id: {_eq: "${toBeDeleted.route_id}"}
      },
    ) {
      returning {
        ${Object.keys(routes[0]).join(",")}
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

    const response = await queryTable(dbConnectionPool, "route.route");

    expect(response.rowCount).toEqual(routes.length - 1);

    expect(response.rows).toEqual(
      expect.arrayContaining(
        routes.filter((route) => route.route_id != toBeDeleted.route_id)
      )
    );
  });
});
