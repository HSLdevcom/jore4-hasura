import * as rp from "request-promise";
import * as pg from "pg";
import * as config from "@config";
import * as db from "@util/db";
import * as dataset from "@util/dataset";
import { infrastructureLinks } from "@datasets/infrastructure-links";
import { scheduledStopPoints as sampleScheduledStopPoints } from "@datasets/scheduled-stop-points";
import { LinkDirection, ScheduledStopPoint } from "@datasets/types";
import "@util/matchers";

const toBeInserted: Partial<ScheduledStopPoint> = {
  located_on_infrastructure_link_id:
    infrastructureLinks[2].infrastructure_link_id,
  direction: LinkDirection.Backward,
  measured_location: {
    type: "Point",
    coordinates: [12.3, 23.4, 34.5],
    crs: {
      properties: { name: "urn:ogc:def:crs:EPSG::4326" },
      type: "name",
    },
  } as dataset.GeometryObject,
  label: "inserted stop point",
  priority: 50,
  validity_end: new Date("2060-11-04 15:30:40Z"),
};

const insertedDefaultValues: Partial<ScheduledStopPoint> = {
  validity_start: null,
};

const mutation = `
  mutation {
    insert_service_pattern_scheduled_stop_point(objects: ${dataset.toGraphQlObject(
      toBeInserted,
      ["direction"]
    )}) {
      returning {
        ${Object.keys(sampleScheduledStopPoints[0]).join(",")}
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
    await db
      .queryRunner(dbConnectionPool)
      .truncate("infrastructure_network.infrastructure_link")
      .truncate("internal_service_pattern.scheduled_stop_point")
      .insertFromJson(
        "infrastructure_network.infrastructure_link",
        dataset.asDbGeometryObjectArray(infrastructureLinks, ["shape"])
      )
      .insertFromJson(
        "internal_service_pattern.scheduled_stop_point",
        dataset.asDbGeometryObjectArray(sampleScheduledStopPoints, [
          "measured_location",
        ])
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
                ...dataset.asGraphQlTimestampObject(toBeInserted),
                ...insertedDefaultValues,
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

    const response = await db.singleQuery(
      dbConnectionPool,
      `
        SELECT
          ${Object.keys(sampleScheduledStopPoints[0])
            .map((key) => `ssp.${key}`)
            .join(",")}
        FROM service_pattern.scheduled_stop_point ssp
      `
    );

    expect(response.rowCount).toEqual(sampleScheduledStopPoints.length + 1);

    expect(response.rows).toEqual(
      expect.arrayContaining(
        dataset.asDbGeometryObjectArray(
          [
            {
              ...toBeInserted,
              ...insertedDefaultValues,
              scheduled_stop_point_id: expect.any(String),
            },
            ...sampleScheduledStopPoints,
          ],
          ["measured_location"]
        )
      )
    );
  });
});
