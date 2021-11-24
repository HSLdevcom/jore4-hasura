import * as rp from "request-promise";
import * as pg from "pg";
import * as config from "@config";
import * as db from "@util/db";
import * as dataset from "@util/dataset";
import { infrastructureLinks } from "@datasets/infrastructure-links";
import { scheduledStopPoints as sampleScheduledStopPoints } from "@datasets/scheduled-stop-points";
import { routes as sampleRoutes } from "@datasets/routes";
import { lines as sampleLines } from "@datasets/lines";
import "@util/matchers";
import { LinkDirection, ScheduledStopPoint } from "@datasets/types";
import { expect } from "@jest/globals";
import { asDbGeometryObjectArray } from "@util/dataset";

const createMutation = (toBeInserted: Partial<ScheduledStopPoint>) => `
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

describe("Insert scheduled stop point", () => {
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
      .truncate("route.line")
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
      .insertFromJson("internal_route.route", sampleRoutes)
      .insertFromJson("route.line", sampleLines)
      .run();
  });

  const shouldReturnErrorResponse = (
    toBeInserted: Partial<ScheduledStopPoint>
  ) =>
    it("should return error response", async () => {
      await rp
        .post({
          ...config.hasuraRequestTemplate,
          body: { query: createMutation(toBeInserted) },
        })
        .then((response) => {
          if (response.statusCode >= 200 && response.statusCode < 300)
            throw new Error(
              "Request succeeded even though it was expected to fail"
            );

          expect(response).toEqual(
            expect.objectContaining({
              errors: expect.any(Array),
            })
          );
        });
    });

  const shouldNotModifyDatabase = (toBeInserted: Partial<ScheduledStopPoint>) =>
    it("should not modify the database", async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: createMutation(toBeInserted) },
      });

      const response = await db.singleQuery(
        dbConnectionPool,
        `
          SELECT ${Object.keys(sampleScheduledStopPoints[0])
            .map((key) => `ssp.${key}`)
            .join(",")}
          FROM service_pattern.scheduled_stop_point ssp
        `
      );

      expect(response.rowCount).toEqual(sampleScheduledStopPoints.length);
      expect(response.rows).toEqual(
        expect.arrayContaining(
          asDbGeometryObjectArray(sampleScheduledStopPoints, [
            "measured_location",
          ])
        )
      );
    });

  describe("whose validity period conflicts with open validity start", () => {
    const toBeInserted: Partial<ScheduledStopPoint> = {
      located_on_infrastructure_link_id:
        infrastructureLinks[1].infrastructure_link_id,
      direction: LinkDirection.Forward,
      measured_location: {
        type: "Point",
        coordinates: [10.1, 9.2, 0],
        crs: {
          properties: { name: "urn:ogc:def:crs:EPSG::4326" },
          type: "name",
        },
      },
      label: "stop2",
      priority: 30,
      validity_start: new Date("2062-01-03 12:34:56"),
      validity_end: new Date("2063-01-03 12:34:56"),
    };

    shouldReturnErrorResponse(toBeInserted);

    shouldNotModifyDatabase(toBeInserted);
  });

  describe("whose validity period overlaps partially with existing validity period", () => {
    const toBeInserted: Partial<ScheduledStopPoint> = {
      located_on_infrastructure_link_id:
        infrastructureLinks[0].infrastructure_link_id,
      direction: LinkDirection.Forward,
      measured_location: {
        type: "Point",
        coordinates: [12.1, 11.2, 0],
        crs: {
          properties: { name: "urn:ogc:def:crs:EPSG::4326" },
          type: "name",
        },
      },
      label: "stop1",
      priority: 10,
      validity_start: new Date("2065-01-16 12:34:56"),
      validity_end: new Date("2065-05-01 12:34:56"),
    };

    shouldReturnErrorResponse(toBeInserted);

    shouldNotModifyDatabase(toBeInserted);
  });

  describe("whose validity period is entirely contained in other validity period", () => {
    const toBeInserted: Partial<ScheduledStopPoint> = {
      located_on_infrastructure_link_id:
        infrastructureLinks[0].infrastructure_link_id,
      direction: LinkDirection.Forward,
      measured_location: {
        type: "Point",
        coordinates: [12.1, 11.2, 0],
        crs: {
          properties: { name: "urn:ogc:def:crs:EPSG::4326" },
          type: "name",
        },
      },
      label: "stop1",
      priority: 10,
      validity_start: new Date("2065-01-05 12:34:56"),
      validity_end: new Date("2065-01-08 12:34:56"),
    };

    shouldReturnErrorResponse(toBeInserted);

    shouldNotModifyDatabase(toBeInserted);
  });
});
