import * as rp from "request-promise";
import * as pg from "pg";
import * as config from "@config";
import * as dataset from "@util/dataset";
import { scheduledStopPoints } from "@datasets/scheduled-stop-points";
import { routes } from "@datasets/routes";
import { Route } from "@datasets/types";
import "@util/matchers";
import { queryTable, setupDb } from "@datasets/sampleSetup";

const toBeUpdated: Partial<Route> = {
  description_i18n: "updated route",
  starts_from_scheduled_stop_point_id:
    scheduledStopPoints[0].scheduled_stop_point_id,
  priority: 50,
  validity_end: new Date("2079-09-22 23:44:11"),
};

const completeUpdated: Route = {
  ...routes[1],
  ...toBeUpdated,
};

const mutation = `
  mutation {
    update_route_route(
      where: {
        route_id: {_eq: "${completeUpdated.route_id}"}
      },
      _set: ${dataset.toGraphQlObject(toBeUpdated, ["direction"])}
    ) {
      returning {
        ${Object.keys(routes[0]).join(",")}
      }
    }
  }
`;

describe("Update route", () => {
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
          update_route_route: {
            returning: [dataset.asGraphQlTimestampObject(completeUpdated)],
          },
        },
      })
    );
  });

  it("should update correct row in the database", async () => {
    await rp.post({
      ...config.hasuraRequestTemplate,
      body: { query: mutation },
    });

    const response = await queryTable(dbConnectionPool, "route.route");

    expect(response.rowCount).toEqual(routes.length);

    expect(response.rows).toEqual(
      expect.arrayContaining([
        completeUpdated,
        ...routes.filter((route) => route.route_id != completeUpdated.route_id),
      ])
    );
  });
});
