import * as rp from "request-promise";
import * as pg from "pg";
import * as config from "@config";
import * as db from "@util/db";
import * as dataset from "@util/dataset";
import { infrastructureLinks } from "@datasets/infrastructure-links";
import { scheduledStopPoints } from "@datasets/scheduled-stop-points";
import { routes as sampleRoutes } from "@datasets/routes";
import "@util/matchers";
import { Route, RouteDirection } from "@datasets/types";

const toBeInserted: Partial<Route> = {
  description_i18n: "new route",
  starts_from_scheduled_stop_point_id:
    scheduledStopPoints[0].scheduled_stop_point_id,
  ends_at_scheduled_stop_point_id:
    scheduledStopPoints[2].scheduled_stop_point_id,
  label: "new route label",
  direction: RouteDirection.Clockwise,
  priority: 40,
  validity_start: new Date("2043-02-01 14:20:54Z"),
};

const insertedDefaultValues: Partial<Route> = {
  validity_end: null,
};

const mutation = `
  mutation {
    insert_route_route(objects: ${dataset.toGraphQlObject(toBeInserted)}) {
      returning {
        ${Object.keys(sampleRoutes[0]).join(",")}
      }
    }
  }
`;

describe("Insert route", () => {
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
          insert_route_route: {
            returning: [
              {
                ...dataset.asGraphQlTimestampObject(toBeInserted),
                ...insertedDefaultValues,
                route_id: expect.any(String),
              },
            ],
          },
        },
      })
    );

    // check the new ID is a valid UUID
    expect(
      response.data.insert_route_route.returning[0].route_id
    ).toBeValidUuid();
  });

  it("should insert correct row into the database", async () => {
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

    expect(response.rowCount).toEqual(sampleRoutes.length + 1);

    expect(response.rows).toEqual(
      expect.arrayContaining([
        {
          ...toBeInserted,
          ...insertedDefaultValues,
          route_id: expect.any(String),
        },
        ...sampleRoutes,
      ])
    );
  });
});
