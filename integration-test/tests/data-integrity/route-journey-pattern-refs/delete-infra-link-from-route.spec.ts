import * as rp from "request-promise";
import * as pg from "pg";
import * as config from "@config";
import {
  InfrastructureLinkAlongRoute,
  InfrastructureLinkAlongRouteProps,
} from "@datasets/types";
import "@util/matchers";
import { getPropNameArray, queryTable, setupDb } from "@datasets/setup";
import { checkErrorResponse } from "@util/response";
import { routesAndJourneyPatternsTableConfig } from "@datasets/routesAndJourneyPatterns";
import { infrastructureLinkAlongRoute } from "@datasets/routesAndJourneyPatterns/routes";

const createMutation = (routeId: string, linkId: string) => `
  mutation {
    delete_route_infrastructure_link_along_route(where: {
      _and: {
        route_id: {_eq: "${routeId}"},
        infrastructure_link_id: {_eq: "${linkId}"},
      }
    }) {
      returning {
        ${getPropNameArray(InfrastructureLinkAlongRouteProps).join(",")}
      }
    }
  }
`;

describe("Delete infra link from route", () => {
  let dbConnectionPool: pg.Pool;

  beforeAll(() => {
    dbConnectionPool = new pg.Pool(config.databaseConfig);
  });

  afterAll(() => dbConnectionPool.end());

  beforeEach(() =>
    setupDb(dbConnectionPool, routesAndJourneyPatternsTableConfig)
  );

  const postHasuraRequest = (toBeRemoved: InfrastructureLinkAlongRoute) =>
    rp.post({
      ...config.hasuraRequestTemplate,
      body: {
        query: createMutation(
          toBeRemoved.route_id,
          toBeRemoved.infrastructure_link_id
        ),
      },
    });

  describe("when there is a stop on the link", () => {
    const toBeRemoved = infrastructureLinkAlongRoute[1];

    it("should return error response", async () => {
      await postHasuraRequest(toBeRemoved).then(
        checkErrorResponse(
          "route's and journey pattern's traversal paths must match each other"
        )
      );
    });

    it("should not modify the database", async () => {
      await postHasuraRequest(toBeRemoved);

      const response = await queryTable(
        dbConnectionPool,
        "route.infrastructure_link_along_route",
        routesAndJourneyPatternsTableConfig
      );

      expect(response.rowCount).toEqual(infrastructureLinkAlongRoute.length);
      expect(response.rows).toEqual(
        expect.arrayContaining(infrastructureLinkAlongRoute)
      );
    });
  });

  describe("without conflict", () => {
    const toBeRemoved = infrastructureLinkAlongRoute[4];

    it("should return correct response", async () => {
      const response = await postHasuraRequest(toBeRemoved);

      expect(response).toEqual(
        expect.objectContaining({
          data: {
            delete_route_infrastructure_link_along_route: {
              returning: [toBeRemoved],
            },
          },
        })
      );
    });

    it("should update the database", async () => {
      await postHasuraRequest(toBeRemoved);

      const response = await queryTable(
        dbConnectionPool,
        "route.infrastructure_link_along_route",
        routesAndJourneyPatternsTableConfig
      );

      expect(response.rowCount).toEqual(
        infrastructureLinkAlongRoute.length - 1
      );
      expect(response.rows).toEqual(
        expect.arrayContaining(
          infrastructureLinkAlongRoute.filter(
            (link) =>
              link.route_id !== toBeRemoved.route_id ||
              link.infrastructure_link_id !== toBeRemoved.infrastructure_link_id
          )
        )
      );
    });
  });
});
