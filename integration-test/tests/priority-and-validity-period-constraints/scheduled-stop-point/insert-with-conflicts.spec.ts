import * as rp from "request-promise";
import * as pg from "pg";
import * as config from "@config";
import * as dataset from "@util/dataset";
import { infrastructureLinks } from "@datasets/infrastructure-links";
import { scheduledStopPoints } from "@datasets/scheduled-stop-points";
import "@util/matchers";
import {
  LinkDirection,
  ScheduledStopPoint,
  VehicleMode,
} from "@datasets/types";
import { expect } from "@jest/globals";
import { asDbGeometryObjectArray } from "@util/dataset";
import { queryTable, setupDb } from "@datasets/sampleSetup";
import { checkErrorResponse } from "@util/response";

const VEHICLE_MODE = VehicleMode.Bus;

const createMutation = (toBeInserted: Partial<ScheduledStopPoint>) => `
  mutation {
    insert_service_pattern_scheduled_stop_point(objects: ${dataset.toGraphQlObject(
      {
        ...toBeInserted,
        vehicle_mode_on_scheduled_stop_point: {
          data: {
            vehicle_mode: VEHICLE_MODE,
          },
        },
      },
      ["direction", "vehicle_mode"]
    )}) {
      returning {
        ${Object.keys(scheduledStopPoints[0]).join(",")}
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

  beforeEach(() => setupDb(dbConnectionPool));

  const shouldReturnErrorResponse = (
    toBeInserted: Partial<ScheduledStopPoint>
  ) =>
    it("should return error response", async () => {
      await rp
        .post({
          ...config.hasuraRequestTemplate,
          body: { query: createMutation(toBeInserted) },
        })
        .then(checkErrorResponse());
    });

  const shouldNotModifyDatabase = (toBeInserted: Partial<ScheduledStopPoint>) =>
    it("should not modify the database", async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: createMutation(toBeInserted) },
      });

      const response = await queryTable(
        dbConnectionPool,
        "service_pattern.scheduled_stop_point"
      );

      expect(response.rowCount).toEqual(scheduledStopPoints.length);
      expect(response.rows).toEqual(
        expect.arrayContaining(
          asDbGeometryObjectArray(scheduledStopPoints, ["measured_location"])
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
