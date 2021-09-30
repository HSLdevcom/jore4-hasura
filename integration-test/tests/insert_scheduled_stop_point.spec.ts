import * as rp from "request-promise";
import * as pg from "pg";
import * as fs from "fs";
import * as config from "../config";
import * as dbUtil from "../util/db";

const dbConnectionPool = new pg.Pool(config.databaseConfig);

describe("Insert scheduled stop point", () => {
  beforeEach(async () => {
    const sql = fs.readFileSync("sql/journey-patterns.sql").toString();
    await dbUtil.setup(config.databaseConfig, sql);
  });

  afterAll(() => dbConnectionPool.end());

  it("Compare response to object", async () => {
    const query = `
            mutation {
                insert_internal_service_pattern_scheduled_stop_point_one(
                    object: {
                      measured_location: {
                        type: "Point",
                        coordinates: [0, 0, 0]
                      },
                      located_on_infrastructure_link_id: "ced51f16-71ad-49c0-8785-0903240e5a78",
                      direction: "forward",
                      label: "stopNew"
                    }
                 ) {
                  scheduled_stop_point_id
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
});
