import * as rp from "request-promise";
import * as pg from "pg";
import * as config from "@config";
import * as dataset from "@util/dataset";
import { infrastructureLinks } from "@datasets/infrastructure-links";
import { scheduledStopPoints } from "@datasets/scheduled-stop-points";
import {
  InfrastructureLinkAlongRoute,
  Route,
  RouteDirection,
} from "@datasets/types";
import "@util/matchers";
import { queryTable, setupDb } from "@datasets/sampleSetup";
import { checkErrorResponse } from "@util/response";
import { lines } from "@datasets/lines";
import { infrastructureLinkAlongRoute, routes } from "@datasets/routes";

const routeToBeInserted: Partial<Route> = {
  on_line_id: lines[1].line_id,
  description_i18n: "new route",
  starts_from_scheduled_stop_point_id:
    scheduledStopPoints[0].scheduled_stop_point_id,
  ends_at_scheduled_stop_point_id:
    scheduledStopPoints[2].scheduled_stop_point_id,
  label: "new route label",
  direction: RouteDirection.Clockwise,
  priority: lines[1].priority + 10,
  validity_start: new Date("2043-02-01 14:20:54Z"),
};

const createLinksToBeInserted = (
  infrastructureLinkId: string,
  isTraversalForwards: boolean
): Partial<InfrastructureLinkAlongRoute>[] => [
  {
    infrastructure_link_id: infrastructureLinks[4].infrastructure_link_id,
    infrastructure_link_sequence: 0,
    is_traversal_forwards: true,
  },
  {
    infrastructure_link_id: infrastructureLinks[5].infrastructure_link_id,
    infrastructure_link_sequence: 1,
    is_traversal_forwards: true,
  },
  {
    infrastructure_link_id: infrastructureLinkId,
    infrastructure_link_sequence: 2,
    is_traversal_forwards: isTraversalForwards,
  },
];

const insertedDefaultValues: Partial<Route> = {
  validity_end: null,
};

const createMutation = (
  linksToBeInserted: Partial<InfrastructureLinkAlongRoute>[]
) => `
  mutation {
    insert_route_route(objects: ${dataset.toGraphQlObject(
      {
        ...routeToBeInserted,
        infrastructure_links_along_route: {
          data: linksToBeInserted,
        },
      },
      ["direction", "is_traversal_forwards"]
    )}) {
      returning {
        ${Object.keys(routes[0]).join(",")}
      }
    }
  }
`;

describe("Insert route with links", () => {
  let dbConnectionPool: pg.Pool;

  beforeAll(() => {
    dbConnectionPool = new pg.Pool(config.databaseConfig);
  });

  afterAll(() => dbConnectionPool.end());

  beforeEach(() => setupDb(dbConnectionPool));

  describe("containing a link whose direction conflicts with its infrastructure link's direction", () => {
    const shouldReturnErrorResponse = (
      linksToBeInserted: Partial<InfrastructureLinkAlongRoute>[]
    ) =>
      it("should return error response", async () => {
        await rp
          .post({
            ...config.hasuraRequestTemplate,
            body: {
              query: createMutation(linksToBeInserted),
            },
          })
          .then(checkErrorResponse);
      });

    const shouldNotModifyDatabase = (
      linksToBeInserted: Partial<InfrastructureLinkAlongRoute>[]
    ) =>
      it("should not modify the database", async () => {
        await rp.post({
          ...config.hasuraRequestTemplate,
          body: { query: createMutation(linksToBeInserted) },
        });

        const routeResponse = await queryTable(dbConnectionPool, "route.route");

        expect(routeResponse.rowCount).toEqual(routes.length);
        expect(routeResponse.rows).toEqual(expect.arrayContaining(routes));

        const infraLinksResponse = await queryTable(
          dbConnectionPool,
          "route.infrastructure_link_along_route"
        );

        expect(infraLinksResponse.rowCount).toEqual(
          infrastructureLinkAlongRoute.length
        );
        expect(infraLinksResponse.rows).toEqual(
          expect.arrayContaining(infrastructureLinkAlongRoute)
        );
      });

    describe('infrastructure link direction "forward", route link traversal backward', () => {
      const linksToBeInserted = createLinksToBeInserted(
        infrastructureLinks[4].infrastructure_link_id,
        false
      );

      shouldReturnErrorResponse(linksToBeInserted);

      shouldNotModifyDatabase(linksToBeInserted);
    });

    describe('infrastructure link direction "backward", route link traversal forward', () => {
      const linksToBeInserted = createLinksToBeInserted(
        infrastructureLinks[6].infrastructure_link_id,
        true
      );

      shouldReturnErrorResponse(linksToBeInserted);

      shouldNotModifyDatabase(linksToBeInserted);
    });
  });

  describe("whose direction does NOT conflict with its infrastructure link's direction", () => {
    const shouldReturnCorrectResponse = (
      linksToBeInserted: Partial<InfrastructureLinkAlongRoute>[]
    ) =>
      it("should return correct response", async () => {
        const response = await rp.post({
          ...config.hasuraRequestTemplate,
          body: { query: createMutation(linksToBeInserted) },
        });

        expect(response).toEqual(
          expect.objectContaining({
            data: {
              insert_route_route: {
                returning: [
                  {
                    ...dataset.asGraphQlTimestampObject(routeToBeInserted),
                    ...insertedDefaultValues,
                    route_id: expect.any(String),
                  },
                ],
              },
            },
          })
        );

        // check the new ID is a valid UUID
        expect(
          response.data.insert_route_route.returning[0].route_id
        ).toBeValidUuid();
      });

    const shouldInsertCorrectRowsIntoDatabase = (
      linksToBeInserted: Partial<InfrastructureLinkAlongRoute>[]
    ) =>
      it("should insert correct row into the database", async () => {
        await rp.post({
          ...config.hasuraRequestTemplate,
          body: { query: createMutation(linksToBeInserted) },
        });

        const routeResponse = await queryTable(dbConnectionPool, "route.route");

        expect(routeResponse.rowCount).toEqual(routes.length + 1);
        expect(routeResponse.rows).toEqual(
          expect.arrayContaining([
            {
              ...routeToBeInserted,
              ...insertedDefaultValues,
              route_id: expect.any(String),
            },
            ...routes,
          ])
        );

        const infraLinksResponse = await queryTable(
          dbConnectionPool,
          "route.infrastructure_link_along_route"
        );

        expect(infraLinksResponse.rowCount).toEqual(
          infrastructureLinkAlongRoute.length + linksToBeInserted.length
        );
        expect(infraLinksResponse.rows).toEqual(
          expect.arrayContaining([
            ...infrastructureLinkAlongRoute,
            ...linksToBeInserted.map((link) => ({
              ...link,
              route_id: expect.any(String),
            })),
          ])
        );
      });

    describe('infrastructure link direction "forward", route link traversal forward', () => {
      const linksToBeInserted = createLinksToBeInserted(
        infrastructureLinks[4].infrastructure_link_id,
        true
      );

      shouldReturnCorrectResponse(linksToBeInserted);

      shouldInsertCorrectRowsIntoDatabase(linksToBeInserted);
    });

    describe('infrastructure link direction "backward", route link traversal backward', () => {
      const linksToBeInserted = createLinksToBeInserted(
        infrastructureLinks[6].infrastructure_link_id,
        false
      );

      shouldReturnCorrectResponse(linksToBeInserted);

      shouldInsertCorrectRowsIntoDatabase(linksToBeInserted);
    });

    describe('infrastructure link direction "bidirectional", route link traversal forward', () => {
      const linksToBeInserted = createLinksToBeInserted(
        infrastructureLinks[5].infrastructure_link_id,
        true
      );

      shouldReturnCorrectResponse(linksToBeInserted);

      shouldInsertCorrectRowsIntoDatabase(linksToBeInserted);
    });

    describe('infrastructure link direction "bidirectional", route link traversal backward', () => {
      const linksToBeInserted = createLinksToBeInserted(
        infrastructureLinks[5].infrastructure_link_id,
        false
      );

      shouldReturnCorrectResponse(linksToBeInserted);

      shouldInsertCorrectRowsIntoDatabase(linksToBeInserted);
    });
  });
});