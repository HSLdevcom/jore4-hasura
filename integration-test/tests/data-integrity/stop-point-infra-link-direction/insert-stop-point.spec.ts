import * as rp from "request-promise";
import * as pg from "pg";
import * as config from "@config";
import * as db from "@util/db";
import * as dataset from "@util/dataset";
import { infrastructureLinks } from "@datasets/infrastructure-links";
import { scheduledStopPoints } from "@datasets/scheduled-stop-points";
import { LinkDirection, ScheduledStopPoint } from "@datasets/types";
import "@util/matchers";
import { asDbGeometryObjectArray } from "@util/dataset";

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

const createMutation = (toBeInserted: Partial<ScheduledStopPoint>) => `
  mutation {
    insert_service_pattern_scheduled_stop_point(objects: ${dataset.toGraphQlObject(
      toBeInserted,
      ["direction"]
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
        dataset.asDbGeometryObjectArray(scheduledStopPoints, [
          "measured_location",
        ])
      )
      .run();
  });

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

    const shouldNotModifyDatabase = (
      toBeInserted: Partial<ScheduledStopPoint>
    ) =>
      it("should not modify the database", async () => {
        await rp.post({
          ...config.hasuraRequestTemplate,
          body: { query: createMutation(toBeInserted) },
        });

        const response = await db.singleQuery(
          dbConnectionPool,
          `
          SELECT ${Object.keys(scheduledStopPoints[0])
            .map((key) => `ssp.${key}`)
            .join(",")}
          FROM service_pattern.scheduled_stop_point ssp
        `
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

        const response = await db.singleQuery(
          dbConnectionPool,
          `
          SELECT ${Object.keys(scheduledStopPoints[0])
            .map((key) => `ssp.${key}`)
            .join(",")}
          FROM service_pattern.scheduled_stop_point ssp
        `
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
