import * as rp from "request-promise";
import * as pg from "pg";
import * as config from "@config";
import * as dataset from "@util/dataset";
import { infrastructureLinks } from "@datasets/infrastructure-links";
import { InfrastructureLink, LinkDirection } from "@datasets/types";
import "@util/matchers";
import { asDbGeometryObjectArray } from "@util/dataset";
import { queryTable, setupDb } from "@datasets/sampleSetup";
import { checkErrorResponse } from "@util/response";

const createMutation = (
  infrastructureLinkId: string,
  toBeUpdated: Partial<InfrastructureLink>
) => `
  mutation {
    update_infrastructure_network_infrastructure_link(
      where: {
        infrastructure_link_id: {_eq: "${infrastructureLinkId}"}
      },
      _set: ${dataset.toGraphQlObject(toBeUpdated, ["direction"])}) {
      returning {
        ${Object.keys(infrastructureLinks[0]).join(",")}
      }
    }
  }
`;

describe("Update infrastructure link", () => {
  let dbConnectionPool: pg.Pool;

  beforeAll(() => {
    dbConnectionPool = new pg.Pool(config.databaseConfig);
  });

  afterAll(() => dbConnectionPool.end());

  beforeEach(() => setupDb(dbConnectionPool));

  describe("whose direction conflicts with a route link's direction", () => {
    const shouldReturnErrorResponse = (
      infrastructureLinkId: string,
      toBeUpdated: Partial<InfrastructureLink>
    ) =>
      it("should return error response", async () => {
        await rp
          .post({
            ...config.hasuraRequestTemplate,
            body: { query: createMutation(infrastructureLinkId, toBeUpdated) },
          })
          .then(checkErrorResponse);
      });

    const shouldNotModifyDatabase = (
      infrastructureLinkId: string,
      toBeUpdated: Partial<InfrastructureLink>
    ) =>
      it("should not modify the database", async () => {
        await rp.post({
          ...config.hasuraRequestTemplate,
          body: { query: createMutation(infrastructureLinkId, toBeUpdated) },
        });

        const response = await queryTable(
          dbConnectionPool,
          "infrastructure_network.infrastructure_link"
        );

        expect(response.rowCount).toEqual(infrastructureLinks.length);
        expect(response.rows).toEqual(
          expect.arrayContaining(
            asDbGeometryObjectArray(infrastructureLinks, ["shape"])
          )
        );
      });

    describe('infrastructure link direction "backward", route link direction "forward"', () => {
      const toBeUpdated = {
        direction: LinkDirection.Backward,
      };

      shouldReturnErrorResponse(
        infrastructureLinks[4].infrastructure_link_id,
        toBeUpdated
      );

      shouldNotModifyDatabase(
        infrastructureLinks[4].infrastructure_link_id,
        toBeUpdated
      );
    });

    describe('infrastructure link direction "forward", route link direction "backward"', () => {
      const toBeUpdated = {
        direction: LinkDirection.Forward,
      };

      shouldReturnErrorResponse(
        infrastructureLinks[5].infrastructure_link_id,
        toBeUpdated
      );

      shouldNotModifyDatabase(
        infrastructureLinks[5].infrastructure_link_id,
        toBeUpdated
      );
    });

    describe("whose direction does NOT conflict with its infrastructure link's direction", () => {
      const shouldReturnCorrectResponse = (
        original: InfrastructureLink,
        toBeUpdated: Partial<InfrastructureLink>
      ) =>
        it("should return correct response", async () => {
          const response = await rp.post({
            ...config.hasuraRequestTemplate,
            body: {
              query: createMutation(
                original.infrastructure_link_id,
                toBeUpdated
              ),
            },
          });

          expect(response).toEqual(
            expect.objectContaining({
              data: {
                update_infrastructure_network_infrastructure_link: {
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

      const shouldUpdateCorrectRowInDatabase = (
        original: InfrastructureLink,
        toBeUpdated: Partial<InfrastructureLink>
      ) =>
        it("should update correct row in the database", async () => {
          await rp.post({
            ...config.hasuraRequestTemplate,
            body: {
              query: createMutation(
                original.infrastructure_link_id,
                toBeUpdated
              ),
            },
          });

          const response = await queryTable(
            dbConnectionPool,
            "infrastructure_network.infrastructure_link"
          );

          expect(response.rowCount).toEqual(infrastructureLinks.length);

          expect(response.rows).toEqual(
            expect.arrayContaining(
              dataset.asDbGeometryObjectArray(
                [
                  { ...original, ...toBeUpdated },
                  ...infrastructureLinks.filter(
                    (infrastructureLink) =>
                      infrastructureLink.infrastructure_link_id !=
                      original.infrastructure_link_id
                  ),
                ],
                ["shape"]
              )
            )
          );
        });

      describe('infrastructure link direction "forward", no route link existing', () => {
        const toBeUpdated = {
          direction: LinkDirection.Forward,
        };

        shouldReturnCorrectResponse(infrastructureLinks[7], toBeUpdated);

        shouldUpdateCorrectRowInDatabase(infrastructureLinks[7], toBeUpdated);
      });

      describe('infrastructure link direction "bidirectional", route link direction "backward', () => {
        const toBeUpdated = {
          direction: LinkDirection.BiDirectional,
        };

        shouldReturnCorrectResponse(infrastructureLinks[5], toBeUpdated);

        shouldUpdateCorrectRowInDatabase(infrastructureLinks[5], toBeUpdated);
      });
    });
  });
});
