import * as pg from "pg";
import * as db from "@util/db";
import * as dataset from "@util/dataset";
import {
  infrastructureLinks,
  vehicleSubmodeOnInfrastructureLink,
} from "@datasets/infrastructure-links";
import {
  scheduledStopPoints,
  vehicleModeOnScheduledStopPoint,
} from "@datasets/scheduled-stop-points";
import { lines } from "@datasets/lines";
import { routes } from "@datasets/routes";

export const tables: Record<string, Record<string, unknown>[]> = {
  "infrastructure_network.infrastructure_link": dataset.asDbGeometryObjectArray(
    infrastructureLinks,
    ["shape"]
  ),
  "infrastructure_network.vehicle_submode_on_infrastructure_link":
    vehicleSubmodeOnInfrastructureLink,
  "internal_service_pattern.scheduled_stop_point":
    dataset.asDbGeometryObjectArray(scheduledStopPoints, ["measured_location"]),
  "service_pattern.vehicle_mode_on_scheduled_stop_point":
    vehicleModeOnScheduledStopPoint,
  "route.line": lines,
  "internal_route.route": routes,
};

export const setupDb = (
  dbConnectionPool: pg.Pool,
  configuration: (keyof typeof tables)[] = Object.keys(tables)
) => {
  let queryRunner = db.queryRunner(dbConnectionPool).query("BEGIN");

  configuration.forEach((table) => {
    queryRunner = queryRunner.truncate(table);
  });
  configuration.forEach((table) => {
    queryRunner = queryRunner.insertFromJson(table, tables[table]);
  });

  return queryRunner.query("COMMIT").run();
};
