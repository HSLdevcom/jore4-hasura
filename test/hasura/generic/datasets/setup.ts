import { defaultTableConfig } from '@datasets-generic/defaultSetup';
import { isFileDataSource, isGeoProperty } from '@datasets-generic/types';
import { asDbGeometryObjectArray } from '@util/dataset';
import * as db from '@util/db';
import { throwError } from '@util/helpers';
import { readFileSync } from 'fs';
import * as pg from 'pg';

export function isTableConfig(obj: TableLikeConfig): obj is TableConfig {
  return Object.prototype.hasOwnProperty.call(obj, 'data');
}

export const setupDb = (
  dbConnectionPool: pg.Pool,
  configuration: TableLikeConfig[] = defaultTableConfig,
  disableTriggers = false,
) => {
  let queryRunner = db.queryRunner(dbConnectionPool);

  if (disableTriggers) {
    queryRunner = queryRunner.disableTriggers(true);
  }

  queryRunner = queryRunner.query('BEGIN');
  const tables = configuration.filter(isTableConfig);

  tables.forEach((table) => {
    queryRunner = queryRunner.truncate(table.name);
  });
  tables.forEach((table: TableConfig) => {
    const { data, props } = table;

    if (isFileDataSource(data)) {
      // data contains the file name from which to load SQL statements
      const fileContent = readFileSync(data, 'utf-8');
      queryRunner = queryRunner.query(fileContent);
    } else {
      // data directly contains the table content array
      const geoProps = props.reduce(
        (prev, prop) => (isGeoProperty(prop) ? [...prev, prop.propName] : prev),
        [] as string[],
      );

      queryRunner = queryRunner.insertFromJson(
        table.name,
        asDbGeometryObjectArray(data, geoProps),
      );
    }
  });

  queryRunner = queryRunner.query('COMMIT');

  if (disableTriggers) {
    // re-enable triggers in case we disabled them above
    queryRunner = queryRunner.disableTriggers(false);
  }

  return queryRunner.run(true);
};

export const getTableConfig = (
  tableName: string,
  configuration: TableLikeConfig[] = defaultTableConfig,
) =>
  configuration.find((table) => table.name === tableName) ??
  throwError(`no configuration found for table ${tableName}`);

export const getTableConfigArray = (
  tableNames: string[],
  configuration: TableLikeConfig[] = defaultTableConfig,
) => tableNames.map((tableName) => getTableConfig(tableName, configuration));

export const getPropNameArray = (props: Property[]) =>
  props.map((prop) => (isGeoProperty(prop) ? prop.propName : prop));

export const queryTable = (
  dbConnectionPool: pg.Pool,
  tableName: string,
  configuration: TableLikeConfig[] = defaultTableConfig,
) =>
  db.singleQuery(
    dbConnectionPool,
    `
      SELECT ${getPropNameArray(
        getTableConfig(tableName, configuration).props,
      ).join(',')}
      FROM ${tableName}
    `,
  );
