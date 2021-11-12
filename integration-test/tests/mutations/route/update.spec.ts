import * as rp from "request-promise";
import * as pg from "pg";
import * as config from "@config";
import * as db from "@util/db";
import * as dataset from "@util/dataset";
import { infrastructureLinks } from "@datasets/infrastructure-links";
import { scheduledStopPoints } from "@datasets/scheduled-stop-points";
import { routes as sampleRoutes } from "@datasets/routes";
import { Route } from "@datasets/types";
import "@util/matchers";

const toBeUpdated: Partial<Route> = {
  description_i18n: "updated route",
  starts_from_scheduled_stop_point_id:
    scheduledStopPoints[0].scheduled_stop_point_id,
};

const completeUpdated: Route = {
  ...sampleRoutes[1],
  ...toBeUpdated,
};

const mutation = `
  mutation {
    update_route_route(
      where: {
        route_id: {_eq: "${completeUpdated.route_id}"}
      },
      _set: ${dataset.toGraphQlObject(toBeUpdated)}
    ) {
      returning {
        ${Object.keys(sampleRoutes[0]).join(",")}
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

  beforeEach(async () => {
    await db
      .queryRunner(dbConnectionPool)
      .truncate("infrastructure_network.infrastructure_link")
      .truncate("internal_service_pattern.scheduled_stop_point")
      .truncate("internal_route.route")
      .insertFromJson(
        "infrastructure_network.infrastructure_link",
        dataset.asDbGeometryObjectArray(infrastructureLinks, ["shape"])
      )
      .insertFromJson(
        "internal_service_pattern.scheduled_stop_point",
        dataset.asDbGeometryObjectArray(scheduledStopPoints, [
          "measured_location",
        ])
      )
      .insertFromJson("internal_route.route", sampleRoutes)
      .run();
  });

  it("should return correct response", async () => {
    const response = await rp.post({
      ...config.hasuraRequestTemplate,
      body: { query: mutation },
    });

    expect(response).toEqual(
      expect.objectContaining({
        data: {
          update_route_route: {
            returning: [completeUpdated],
          },
        },
      })
    );
  });

  it("should update correct row into the database", async () => {
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

    expect(response.rowCount).toEqual(sampleRoutes.length);

    expect(response.rows).toEqual(
      expect.arrayContaining([
        completeUpdated,
        ...sampleRoutes.filter(
          (route) => route.route_id != completeUpdated.route_id
        ),
      ])
    );
  });
});
