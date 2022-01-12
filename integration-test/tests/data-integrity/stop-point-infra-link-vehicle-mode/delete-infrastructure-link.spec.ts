import * as rp from "request-promise";
import * as pg from "pg";
import * as config from "@config";
import * as dataset from "@util/dataset";
import "@util/matchers";
import { getPropNameArray, queryTable, setupDb } from "@datasets/setup";
import {
  infrastructureLinks,
  vehicleSubmodeOnInfrastructureLink,
} from "@datasets/defaultSetup/infrastructure-links";
import { expectErrorResponse } from "@util/response";
import { InfrastructureLinkProps } from "@datasets/types";

const buildMutation = (infrastructureLinkId: string) => `
  mutation {
    delete_infrastructure_network_infrastructure_link(where: {infrastructure_link_id: {_eq: "${infrastructureLinkId}"}}) {
      returning {
        ${getPropNameArray(InfrastructureLinkProps).join(",")}
      }
    }
  }
`;

describe("Delete infrastructure link", () => {
  let dbConnectionPool: pg.Pool;

  beforeAll(() => {
    dbConnectionPool = new pg.Pool(config.databaseConfig);
  });

  afterAll(() => dbConnectionPool.end());

  beforeEach(() => setupDb(dbConnectionPool));

  describe("which is referenced by a scheduled stop point", () => {
    const toBeDeleted = infrastructureLinks[0];

    it("should return error response", async () => {
      await rp
        .post({
          ...config.hasuraRequestTemplate,
          body: { query: buildMutation(toBeDeleted.infrastructure_link_id) },
        })
        .then(expectErrorResponse("violates foreign key constraint"));
    });

    it("should not modify database", async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeDeleted.infrastructure_link_id) },
      });

      const infraLinkResponse = await queryTable(
        dbConnectionPool,
        "infrastructure_network.infrastructure_link"
      );

      expect(infraLinkResponse.rowCount).toEqual(infrastructureLinks.length);
      expect(infraLinkResponse.rows).toEqual(
        expect.arrayContaining(
          dataset.asDbGeometryObjectArray(infrastructureLinks, ["shape"])
        )
      );

      const vehicleSubModeResponse = await queryTable(
        dbConnectionPool,
        "infrastructure_network.vehicle_submode_on_infrastructure_link"
      );

      expect(vehicleSubModeResponse.rowCount).toEqual(
        vehicleSubmodeOnInfrastructureLink.length
      );
      expect(vehicleSubModeResponse.rows).toEqual(
        expect.arrayContaining(vehicleSubmodeOnInfrastructureLink)
      );
    });
  });

  describe("which is NOT referenced by a scheduled stop point", () => {
    const toBeDeleted = infrastructureLinks[2];

    it("should return correct response", async () => {
      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeDeleted.infrastructure_link_id) },
      });

      expect(response).toEqual(
        expect.objectContaining({
          data: {
            delete_infrastructure_network_infrastructure_link: {
              returning: [dataset.asGraphQlTimestampObject(toBeDeleted)],
            },
          },
        })
      );
    });

    it("should delete correct rows from the database", async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeDeleted.infrastructure_link_id) },
      });

      const infraLinkResponse = await queryTable(
        dbConnectionPool,
        "infrastructure_network.infrastructure_link"
      );

      expect(infraLinkResponse.rowCount).toEqual(
        infrastructureLinks.length - 1
      );

      expect(infraLinkResponse.rows).toEqual(
        expect.arrayContaining(
          dataset.asDbGeometryObjectArray(
            infrastructureLinks.filter(
              (infrastructureLink) =>
                infrastructureLink.infrastructure_link_id !=
                toBeDeleted.infrastructure_link_id
            ),
            ["shape"]
          )
        )
      );

      const vehicleSubModeResponse = await queryTable(
        dbConnectionPool,
        "infrastructure_network.vehicle_submode_on_infrastructure_link"
      );

      expect(vehicleSubModeResponse.rowCount).toEqual(
        vehicleSubmodeOnInfrastructureLink.length - 1
      );
      expect(vehicleSubModeResponse.rows).toEqual(
        expect.arrayContaining(
          vehicleSubmodeOnInfrastructureLink.filter(
            (vehicleSubMode) =>
              vehicleSubMode.infrastructure_link_id !=
              toBeDeleted.infrastructure_link_id
          )
        )
      );
    });
  });
});
