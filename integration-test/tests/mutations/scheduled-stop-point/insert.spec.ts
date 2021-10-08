import * as rp from "request-promise";
import * as pg from "pg";
import * as config from "@config";
import * as db from "@util/db";
import * as dataset from "@util/dataset";
import "@util/matchers";

const sampleScheduledStopPoints = dataset.readJsonArray(
  "datasets/scheduled-stop-points.json",
  ["measured_location"]
);

module testData {
  export const located_on_infrastructure_link_id =
    "d654ff08-a7c3-4799-820c-6d61147dd1ad";
  export const direction = "bidirectional";
  export const measured_location_coords = [12.3, 23.4, 34.5];
  export const measured_location_crs_urn = "urn:ogc:def:crs:EPSG::4326";
  export const label = "inserted stop point";
}

const toBeInserted = {
  located_on_infrastructure_link_id: testData.located_on_infrastructure_link_id,
  direction: testData.direction,
  measured_location: {
    type: "Point",
    coordinates: testData.measured_location_coords,
    crs: {
      properties: { name: testData.measured_location_crs_urn },
      type: "name",
    },
  } as dataset.GeometryObject,
  label: testData.label,
};

const mutation = `
  mutation {
    insert_service_pattern_scheduled_stop_point(objects: ${dataset.toGraphQlObject(
      toBeInserted
    )}) {
      returning {
        scheduled_stop_point_id,
        located_on_infrastructure_link_id,
        direction,
        measured_location,
        label
      }
    }
  }
`;

describe("Insert scheduled_stop_point", () => {
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
    await db
      .setup(config.databaseConfig)
      .truncate("infrastructure_network.infrastructure_link")
      .truncate("internal_service_pattern.scheduled_stop_point")
      .insertFromJson(
        "infrastructure_network.infrastructure_link",
        infrastructureLinks
      )
      .insertFromJson(
        "internal_service_pattern.scheduled_stop_point",
        sampleScheduledStopPoints
      )
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
          insert_service_pattern_scheduled_stop_point: {
            returning: [
              {
                ...toBeInserted,
                scheduled_stop_point_id: expect.any(String),
              },
            ],
          },
        },
      })
    );

    // check the new ID is a valid UUID
    expect(
      response.data.insert_service_pattern_scheduled_stop_point.returning[0]
        .scheduled_stop_point_id
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
          ssp.scheduled_stop_point_id,
          ssp.located_on_infrastructure_link_id,
          ssp.direction,
          ssp.measured_location,
          ssp.label
        FROM service_pattern.scheduled_stop_point ssp
      `
    );

    expect(response.rowCount).toEqual(sampleScheduledStopPoints.length + 1);

    expect(response.rows).toEqual(
      expect.arrayContaining([
        {
          ...dataset.asDbGeometryObject(toBeInserted, ["measured_location"]),
          scheduled_stop_point_id: expect.any(String),
        },
        ...sampleScheduledStopPoints,
      ])
    );
  });
});
