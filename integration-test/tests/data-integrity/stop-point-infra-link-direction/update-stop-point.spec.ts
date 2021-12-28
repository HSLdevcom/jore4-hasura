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

const createMutation = (
  stopPointId: string,
  toBeUpdated: Partial<ScheduledStopPoint>
) => `
  mutation {
    update_service_pattern_scheduled_stop_point(
      where: {
        scheduled_stop_point_id: {_eq: "${stopPointId}"}
      },
      _set: ${dataset.toGraphQlObject(toBeUpdated, ["direction"])}) {
      returning {
        ${Object.keys(scheduledStopPoints[0]).join(",")}
      }
    }
  }
`;

describe("Update scheduled stop point", () => {
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
      stopPointId: string,
      toBeUpdated: Partial<ScheduledStopPoint>
    ) =>
      it("should return error response", async () => {
        await rp
          .post({
            ...config.hasuraRequestTemplate,
            body: { query: createMutation(stopPointId, toBeUpdated) },
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
      stopPointId: string,
      toBeUpdated: Partial<ScheduledStopPoint>
    ) =>
      it("should not modify the database", async () => {
        await rp.post({
          ...config.hasuraRequestTemplate,
          body: { query: createMutation(stopPointId, toBeUpdated) },
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
      const toBeUpdated = {
        direction: LinkDirection.Backward,
      };

      shouldReturnErrorResponse(
        scheduledStopPoints[0].scheduled_stop_point_id,
        toBeUpdated
      );

      shouldNotModifyDatabase(
        scheduledStopPoints[0].scheduled_stop_point_id,
        toBeUpdated
      );
    });

    describe('infrastructure link direction "backward", stop point direction "forward"', () => {
      const toBeUpdated = {
        located_on_infrastructure_link_id:
          infrastructureLinks[2].infrastructure_link_id,
      };

      shouldReturnErrorResponse(
        scheduledStopPoints[0].scheduled_stop_point_id,
        toBeUpdated
      );

      shouldNotModifyDatabase(
        scheduledStopPoints[0].scheduled_stop_point_id,
        toBeUpdated
      );
    });

    describe('infrastructure link direction "forward", stop point direction "bidirectional"', () => {
      const toBeUpdated = {
        direction: LinkDirection.BiDirectional,
      };

      shouldReturnErrorResponse(
        scheduledStopPoints[0].scheduled_stop_point_id,
        toBeUpdated
      );

      shouldNotModifyDatabase(
        scheduledStopPoints[0].scheduled_stop_point_id,
        toBeUpdated
      );
    });

    describe('infrastructure link direction "backward", stop point direction "bidirectional"', () => {
      const toBeUpdated = {
        located_on_infrastructure_link_id:
          infrastructureLinks[2].infrastructure_link_id,
        direction: LinkDirection.BiDirectional,
      };

      shouldReturnErrorResponse(
        scheduledStopPoints[0].scheduled_stop_point_id,
        toBeUpdated
      );

      shouldNotModifyDatabase(
        scheduledStopPoints[0].scheduled_stop_point_id,
        toBeUpdated
      );
    });

    describe("whose direction does NOT conflict with its infrastructure link's direction", () => {
      const shouldReturnCorrectResponse = (
        original: ScheduledStopPoint,
        toBeUpdated: Partial<ScheduledStopPoint>
      ) =>
        it("should return correct response", async () => {
          const response = await rp.post({
            ...config.hasuraRequestTemplate,
            body: {
              query: createMutation(
                original.scheduled_stop_point_id,
                toBeUpdated
              ),
            },
          });

          expect(response).toEqual(
            expect.objectContaining({
              data: {
                update_service_pattern_scheduled_stop_point: {
                  returning: [
                    dataset.asGraphQlTimestampObject({
                      ...original,
                      ...toBeUpdated,
                    }),
                  ],
                },
              },
            })
          );
        });

      const shouldUpdateCorrectRowIntoDatabase = (
        original: ScheduledStopPoint,
        toBeUpdated: Partial<ScheduledStopPoint>
      ) =>
        it("should update correct row in the database", async () => {
          await rp.post({
            ...config.hasuraRequestTemplate,
            body: {
              query: createMutation(
                original.scheduled_stop_point_id,
                toBeUpdated
              ),
            },
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
              dataset.asDbGeometryObjectArray(
                [
                  { ...original, ...toBeUpdated },
                  ...scheduledStopPoints.filter(
                    (scheduledStopPoint) =>
                      scheduledStopPoint.scheduled_stop_point_id !=
                      original.scheduled_stop_point_id
                  ),
                ],
                ["measured_location"]
              )
            )
          );
        });

      describe('infrastructure link direction "forward", stop point direction "forward"', () => {
        const toBeUpdated = {
          located_on_infrastructure_link_id:
            infrastructureLinks[0].infrastructure_link_id,
          direction: LinkDirection.Forward,
        };

        shouldReturnCorrectResponse(scheduledStopPoints[1], toBeUpdated);

        shouldUpdateCorrectRowIntoDatabase(scheduledStopPoints[1], toBeUpdated);
      });

      describe('infrastructure link direction "backward", stop point direction "backward"', () => {
        const toBeUpdated = {
          located_on_infrastructure_link_id:
            infrastructureLinks[2].infrastructure_link_id,
          direction: LinkDirection.Backward,
        };

        shouldReturnCorrectResponse(scheduledStopPoints[2], toBeUpdated);

        shouldUpdateCorrectRowIntoDatabase(scheduledStopPoints[2], toBeUpdated);
      });

      describe('infrastructure link direction "bidirectional", stop point direction "forward"', () => {
        const toBeUpdated = {
          located_on_infrastructure_link_id:
            infrastructureLinks[1].infrastructure_link_id,
        };

        shouldReturnCorrectResponse(scheduledStopPoints[2], toBeUpdated);

        shouldUpdateCorrectRowIntoDatabase(scheduledStopPoints[2], toBeUpdated);
      });

      describe('infrastructure link direction "bidirectional", stop point direction "backward"', () => {
        const toBeUpdated = {
          located_on_infrastructure_link_id:
            infrastructureLinks[1].infrastructure_link_id,
        };

        shouldReturnCorrectResponse(scheduledStopPoints[1], toBeUpdated);

        shouldUpdateCorrectRowIntoDatabase(scheduledStopPoints[1], toBeUpdated);
      });

      describe('infrastructure link direction "bidirectional", stop point direction "bidirectional"', () => {
        const toBeUpdated = {
          direction: LinkDirection.BiDirectional,
        };

        shouldReturnCorrectResponse(scheduledStopPoints[1], toBeUpdated);

        shouldUpdateCorrectRowIntoDatabase(scheduledStopPoints[1], toBeUpdated);
      });
    });
  });
});
