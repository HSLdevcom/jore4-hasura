import * as rp from "request-promise";
import * as pg from "pg";
import * as config from "@config";
import * as db from "@util/db";
import * as dataset from "@util/dataset";
import { infrastructureLinks } from "@datasets/infrastructure-links";
import {
  scheduledStopPoints,
  scheduledStopPoints as sampleScheduledStopPoints,
} from "@datasets/scheduled-stop-points";
import { Direction, ScheduledStopPoint } from "@datasets/types";
import "@util/matchers";

const toBeUpdated: Partial<ScheduledStopPoint> = {
  located_on_infrastructure_link_id:
    infrastructureLinks[0].infrastructure_link_id,
  direction: Direction.Backward,
  measured_location: {
    type: "Point",
    coordinates: [20.1, 19.2, 10],
    crs: {
      properties: { name: "urn:ogc:def:crs:EPSG::4326" },
      type: "name",
    },
  } as dataset.GeometryObject,
  priority: 30,
  validity_start: new Date("2077-10-22 23:44:11"),
  validity_end: new Date("2079-10-22 23:44:11"),
};

const completeUpdated: ScheduledStopPoint = {
  ...scheduledStopPoints[2],
  ...toBeUpdated,
};

const mutation = `
  mutation {
    update_service_pattern_scheduled_stop_point(
      where: {
        scheduled_stop_point_id: {_eq: "${
          completeUpdated.scheduled_stop_point_id
        }"}
      },
      _set: ${dataset.toGraphQlObject(toBeUpdated)}
    ) {
      returning {
        ${Object.keys(sampleScheduledStopPoints[0]).join(",")}
      }
    }
  }
`;

describe("Update scheduled_stop_point", () => {
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
          update_service_pattern_scheduled_stop_point: {
            returning: [dataset.asGraphQlTimestampObject(completeUpdated)],
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
          ${Object.keys(sampleScheduledStopPoints[0])
            .map((key) => `ssp.${key}`)
            .join(",")}
        FROM service_pattern.scheduled_stop_point ssp
      `
    );

    expect(response.rowCount).toEqual(sampleScheduledStopPoints.length);

    expect(response.rows).toEqual(
      expect.arrayContaining(
        dataset.asDbGeometryObjectArray(
          [
            completeUpdated,
            ...sampleScheduledStopPoints.filter(
              (scheduledStopPoint) =>
                scheduledStopPoint.scheduled_stop_point_id !=
                completeUpdated.scheduled_stop_point_id
            ),
          ],
          ["measured_location"]
        )
      )
    );
  });
});
