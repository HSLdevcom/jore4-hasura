import * as rp from "request-promise";
import * as pg from "pg";
import * as fs from "fs";
import * as config from "../config";
import * as dbUtil from "../util/db";

const dbConnectionPool = new pg.Pool(config.databaseConfig);

describe("Demo tests", () => {
  beforeAll(async () => {
    const sql = fs.readFileSync("sql/infrastructure-links.sql").toString();
    await dbUtil.query(dbConnectionPool, sql);
  });

  afterAll(() => dbConnectionPool.end());

  it("Compare response to object", async () => {
    const query = `
            query {
                infrastructure_network_infrastructure_link {
                    direction
                    shape
                }
            }
        `;

    const response = await rp.post({
      ...config.hasuraRequestTemplate,
      body: { query },
    });

    expect(response).toEqual(
      expect.objectContaining({
        data: {
          infrastructure_network_infrastructure_link: [
            {
              direction: "forward",
              shape: {
                coordinates: [
                  [12.1, 11.2, 0],
                  [12.3, 10.1, 0],
                ],
                crs: {
                  properties: {
                    name: "urn:ogc:def:crs:EPSG::4326",
                  },
                  type: "name",
                },
                type: "LineString",
              },
            },
            {
              direction: "bidirectional",
              shape: {
                coordinates: [
                  [12.1, 11.2, 0],
                  [12.3, 10.1, 0],
                ],
                crs: {
                  properties: {
                    name: "urn:ogc:def:crs:EPSG::4326",
                  },
                  type: "name",
                },
                type: "LineString",
              },
            },
            {
              direction: "backward",
              shape: {
                coordinates: [
                  [12.1, 11.2, 0],
                  [12.3, 10.1, 0],
                ],
                crs: {
                  properties: {
                    name: "urn:ogc:def:crs:EPSG::4326",
                  },
                  type: "name",
                },
                type: "LineString",
              },
            },
          ],
        },
      })
    );
  });

  it("Compare database content", async () => {
    const response = await dbUtil.query(
      dbConnectionPool,
      "SELECT * FROM infrastructure_network.infrastructure_link"
    );

    expect(response).toEqual(
      expect.objectContaining({
        rows: [
          expect.objectContaining({
            direction: "forward",
          }),
          expect.objectContaining({
            direction: "bidirectional",
          }),
          expect.objectContaining({
            direction: "backward",
          }),
        ],
      })
    );
  });
});
