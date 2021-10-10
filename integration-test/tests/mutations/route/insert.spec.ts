import * as rp from "request-promise";
import * as pg from "pg";
import * as config from "@config";
import * as db from "@util/db";
import * as dataset from "@util/dataset";
import "@util/matchers";

const sampleRoutes = dataset.readJsonArray("datasets/routes.json");

module testData {
  export const description_i18n = "new route";
  export const starts_from_scheduled_stop_point_id =
    "3f604abf-06a9-42c6-90fc-649bf7d8c5eb";
  export const ends_at_scheduled_stop_point_id =
    "d269d7e7-3ff4-48eb-8a07-3acec1bc349d";
}

const toBeInserted = {
  description_i18n: testData.description_i18n,
  starts_from_scheduled_stop_point_id:
    testData.starts_from_scheduled_stop_point_id,
  ends_at_scheduled_stop_point_id: testData.ends_at_scheduled_stop_point_id,
};

const mutation = `
  mutation {
    insert_route_route(objects: ${dataset.toGraphQlObject(toBeInserted)}) {
      returning {
        route_id,
        description_i18n,
        starts_from_scheduled_stop_point_id,
        ends_at_scheduled_stop_point_id
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
    const infrastructureLinks = dataset.readJsonArray(
      "datasets/infrastructure-links.json",
      ["shape"]
    );
    const scheduledStopPoints = dataset.readJsonArray(
      "datasets/scheduled-stop-points.json",
      ["measured_location"]
    );
    await db
      .setup(config.databaseConfig)
      .truncate("infrastructure_network.infrastructure_link")
      .truncate("internal_service_pattern.scheduled_stop_point")
      .truncate("internal_route.route")
      .insertFromJson(
        "infrastructure_network.infrastructure_link",
        infrastructureLinks
      )
      .insertFromJson(
        "internal_service_pattern.scheduled_stop_point",
        scheduledStopPoints
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
                ...toBeInserted,
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

    const response = await db.query(
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

    expect(response.rowCount).toEqual(sampleRoutes.length + 1);

    expect(response.rows).toEqual(
      expect.arrayContaining([
        {
          ...toBeInserted,
          route_id: expect.any(String),
        },
        ...sampleRoutes,
      ])
    );
  });
});
