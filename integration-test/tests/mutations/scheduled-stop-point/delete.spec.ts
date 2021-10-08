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
  export const scheduled_stop_point_id = "5be29866-4a74-45f3-9b85-b0717283231b";
  export const located_on_infrastructure_link_id =
    "96f5419d-5641-46e8-b61e-660db08a87c4";
  export const direction = "backward";
  export const measured_location_coords = [8.1, 7.2, 0];
  export const measured_location_crs_urn = "urn:ogc:def:crs:EPSG::4326";
  export const label = "stop3";
}

const toBeDeleted = {
  scheduled_stop_point_id: testData.scheduled_stop_point_id,
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
    delete_service_pattern_scheduled_stop_point(where: {scheduled_stop_point_id: {_eq: "${testData.scheduled_stop_point_id}"}}) {
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

describe("Delete scheduled_stop_point", () => {
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
          delete_service_pattern_scheduled_stop_point: {
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

    expect(response.rowCount).toEqual(sampleScheduledStopPoints.length - 1);

    expect(response.rows).toEqual(
      expect.arrayContaining(
        sampleScheduledStopPoints.filter(
          (scheduledStopPoint) =>
            scheduledStopPoint.scheduled_stop_point_id !=
            testData.scheduled_stop_point_id
        )
      )
    );
  });
});
