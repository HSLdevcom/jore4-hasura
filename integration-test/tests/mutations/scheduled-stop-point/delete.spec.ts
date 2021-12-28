import * as rp from "request-promise";
import * as pg from "pg";
import * as config from "@config";
import * as db from "@util/db";
import * as dataset from "@util/dataset";
import { scheduledStopPoints as sampleScheduledStopPoints } from "@datasets/scheduled-stop-points";
import "@util/matchers";
import { setupDb } from "@datasets/sampleSetup";

const toBeDeleted = sampleScheduledStopPoints[1];

const mutation = `
  mutation {
    delete_service_pattern_scheduled_stop_point(where: {scheduled_stop_point_id: {_eq: "${
      toBeDeleted.scheduled_stop_point_id
    }"}}) {
      returning {
        ${Object.keys(sampleScheduledStopPoints[0]).join(",")}
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

  beforeEach(() =>
    setupDb(dbConnectionPool, [
      "infrastructure_network.infrastructure_link",
      "infrastructure_network.vehicle_submode_on_infrastructure_link",
      "internal_service_pattern.scheduled_stop_point",
      "service_pattern.vehicle_mode_on_scheduled_stop_point",
    ])
  );

  it("should return correct response", async () => {
    const response = await rp.post({
      ...config.hasuraRequestTemplate,
      body: { query: mutation },
    });

    expect(response).toEqual(
      expect.objectContaining({
        data: {
          delete_service_pattern_scheduled_stop_point: {
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

    expect(response.rowCount).toEqual(sampleScheduledStopPoints.length - 1);

    expect(response.rows).toEqual(
      expect.arrayContaining(
        dataset.asDbGeometryObjectArray(
          sampleScheduledStopPoints.filter(
            (scheduledStopPoint) =>
              scheduledStopPoint.scheduled_stop_point_id !=
              toBeDeleted.scheduled_stop_point_id
          ),
          ["measured_location"]
        )
      )
    );
  });
});
