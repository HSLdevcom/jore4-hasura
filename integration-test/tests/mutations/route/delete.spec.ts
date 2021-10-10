import * as rp from "request-promise";
import * as pg from "pg";
import * as config from "@config";
import * as db from "@util/db";
import * as dataset from "@util/dataset";
import { infrastructureLinks } from "@datasets/infrastructure-links";
import { scheduledStopPoints } from "@datasets/scheduled-stop-points";
import { routes as sampleRoutes } from "@datasets/routes";
import "@util/matchers";

const toBeDeleted = sampleRoutes[2];

const mutation = `
  mutation {
    delete_route_route(
      where: {
        route_id: {_eq: "${toBeDeleted.route_id}"}
      },
    ) {
      returning {
        route_id,
        description_i18n,
        starts_from_scheduled_stop_point_id,
        ends_at_scheduled_stop_point_id
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
          delete_route_route: {
            returning: [toBeDeleted],
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
          r.route_id,
          r.description_i18n,
          r.starts_from_scheduled_stop_point_id,
          r.ends_at_scheduled_stop_point_id
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
