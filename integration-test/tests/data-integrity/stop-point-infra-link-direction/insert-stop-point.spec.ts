import * as rp from "request-promise";
import * as pg from "pg";
import * as config from "@config";
import * as dataset from "@util/dataset";
import { infrastructureLinks } from "@datasets/infrastructure-links";
import { scheduledStopPoints } from "@datasets/scheduled-stop-points";
import {
  LinkDirection,
  ScheduledStopPoint,
  VehicleMode,
} from "@datasets/types";
import "@util/matchers";
import { asDbGeometryObjectArray } from "@util/dataset";
import { queryTable, setupDb } from "@datasets/sampleSetup";
import { checkErrorResponse } from "@util/response";

const createToBeInserted = (
  infrastructureLinkId: string,
  direction: LinkDirection
): Partial<ScheduledStopPoint> => ({
  located_on_infrastructure_link_id: infrastructureLinkId,
  direction,
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
});

const insertedDefaultValues: Partial<ScheduledStopPoint> = {
  validity_start: null,
};

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

  describe("whose direction conflicts with its infrastructure link's direction", () => {
    const shouldReturnErrorResponse = (
      toBeInserted: Partial<ScheduledStopPoint>
    ) =>
      it("should return error response", async () => {
        await rp
          .post({
            ...config.hasuraRequestTemplate,
            body: { query: createMutation(toBeInserted) },
          })
          .then(checkErrorResponse);
      });

    const shouldNotModifyDatabase = (
      toBeInserted: Partial<ScheduledStopPoint>
    ) =>
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

    describe('infrastructure link direction "forward", stop point direction "backward"', () => {
      const toBeInserted = createToBeInserted(
        infrastructureLinks[0].infrastructure_link_id,
        LinkDirection.Backward
      );

      shouldReturnErrorResponse(toBeInserted);

      shouldNotModifyDatabase(toBeInserted);
    });

    describe('infrastructure link direction "backward", stop point direction "forward"', () => {
      const toBeInserted = createToBeInserted(
        infrastructureLinks[2].infrastructure_link_id,
        LinkDirection.Forward
      );

      shouldReturnErrorResponse(toBeInserted);

      shouldNotModifyDatabase(toBeInserted);
    });

    describe('infrastructure link direction "forward", stop point direction "bidirectional"', () => {
      const toBeInserted = createToBeInserted(
        infrastructureLinks[0].infrastructure_link_id,
        LinkDirection.BiDirectional
      );

      shouldReturnErrorResponse(toBeInserted);

      shouldNotModifyDatabase(toBeInserted);
    });

    describe('infrastructure link direction "backward", stop point direction "bidirectional', () => {
      const toBeInserted = createToBeInserted(
        infrastructureLinks[2].infrastructure_link_id,
        LinkDirection.BiDirectional
      );

      shouldReturnErrorResponse(toBeInserted);

      shouldNotModifyDatabase(toBeInserted);
    });
  });

  describe("whose direction does NOT conflict with its infrastructure link's direction", () => {
    const shouldReturnCorrectResponse = (
      toBeInserted: Partial<ScheduledStopPoint>
    ) =>
      it("should return correct response", async () => {
        const response = await rp.post({
          ...config.hasuraRequestTemplate,
          body: { query: createMutation(toBeInserted) },
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

    const shouldInsertCorrectRowIntoDatabase = (
      toBeInserted: Partial<ScheduledStopPoint>
    ) =>
      it("should insert correct row into the database", async () => {
        await rp.post({
          ...config.hasuraRequestTemplate,
          body: { query: createMutation(toBeInserted) },
        });

        const response = await queryTable(
          dbConnectionPool,
          "service_pattern.scheduled_stop_point"
        );

        expect(response.rowCount).toEqual(scheduledStopPoints.length + 1);

        expect(response.rows).toEqual(
          expect.arrayContaining(
            dataset.asDbGeometryObjectArray(
              [
                {
                  ...toBeInserted,
                  ...insertedDefaultValues,
                  scheduled_stop_point_id: expect.any(String),
                },
                ...scheduledStopPoints,
              ],
              ["measured_location"]
            )
          )
        );
      });

    describe('infrastructure link direction "forward", stop point direction "forward"', () => {
      const toBeInserted = createToBeInserted(
        infrastructureLinks[0].infrastructure_link_id,
        LinkDirection.Forward
      );

      shouldReturnCorrectResponse(toBeInserted);

      shouldInsertCorrectRowIntoDatabase(toBeInserted);
    });

    describe('infrastructure link direction "backward", stop point direction "backward"', () => {
      const toBeInserted = createToBeInserted(
        infrastructureLinks[2].infrastructure_link_id,
        LinkDirection.Backward
      );

      shouldReturnCorrectResponse(toBeInserted);

      shouldInsertCorrectRowIntoDatabase(toBeInserted);
    });

    describe('infrastructure link direction "bidirectional", stop point direction "forward"', () => {
      const toBeInserted = createToBeInserted(
        infrastructureLinks[1].infrastructure_link_id,
        LinkDirection.Forward
      );

      shouldReturnCorrectResponse(toBeInserted);

      shouldInsertCorrectRowIntoDatabase(toBeInserted);
    });

    describe('infrastructure link direction "bidirectional", stop point direction "backward"', () => {
      const toBeInserted = createToBeInserted(
        infrastructureLinks[1].infrastructure_link_id,
        LinkDirection.Backward
      );

      shouldReturnCorrectResponse(toBeInserted);

      shouldInsertCorrectRowIntoDatabase(toBeInserted);
    });

    describe('infrastructure link direction "bidirectional", stop point direction "bidirectional"', () => {
      const toBeInserted = createToBeInserted(
        infrastructureLinks[1].infrastructure_link_id,
        LinkDirection.BiDirectional
      );

      shouldReturnCorrectResponse(toBeInserted);

      shouldInsertCorrectRowIntoDatabase(toBeInserted);
    });
  });
});