import * as pg from 'pg';
import * as db from '@util/db';
import { hasGeoPropSpec, PropArray } from '@datasets/types';
import { asDbGeometryObjectArray } from '@util/dataset';
import { defaultTableConfig } from '@datasets/defaultSetup';
import { throwError } from '@util/helpers';
import { readFileSync } from 'fs';

export type TableLikeConfigCommonProps = {
  name: string;
  props: PropArray;
};

export type TableConfig = TableLikeConfigCommonProps & {
  data: Record<string, unknown>[] | string;
  isView?: never;
};

export type ViewConfig = TableLikeConfigCommonProps & {
  data?: never;
  isView: true;
};

export type TableLikeConfig = TableConfig | ViewConfig;

export function isTableConfig<ObjType extends TableLikeConfig>(
  obj: TableLikeConfig,
): obj is TableConfig {
  return obj.hasOwnProperty('data');
}

export const setupDb = (
  dbConnectionPool: pg.Pool,
  configuration: TableLikeConfig[] = defaultTableConfig,
  disableTriggers: boolean = false,
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
  tables.forEach((table) => {
    const { data, props } = table;

    if (typeof data === 'string') {
      // data contains the file name from which to load SQL statements
      const fileContent = readFileSync(data, 'utf-8');
      queryRunner = queryRunner.query(fileContent);
    } else {
      // data directly contains the table content array
      const geoProps = props.reduce(
        (prev, prop) =>
          hasGeoPropSpec(prop) && prop.isGeoProp
            ? [...prev, prop.propName]
            : prev,
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

  return queryRunner.run();
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

export const getPropNameArray = (props: PropArray) =>
  props.map((prop) => (hasGeoPropSpec(prop) ? prop.propName : prop));

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
